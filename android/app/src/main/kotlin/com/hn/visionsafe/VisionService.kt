package com.hn.visionsafe

import android.app.*
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import android.util.Log
import androidx.camera.core.ImageProxy
import java.util.concurrent.Executors
import android.content.pm.ServiceInfo

import com.hn.visionsafe.core.VisionRulesEngine
import com.hn.visionsafe.core.DeviceStateManager

/**
 * Orchestrator Utama (Service).
 * Telah direfactor menggunakan prinsip SOLID. Logika State Management (Baterai/Layar)
 * dan Business Logic (Rule 20-20-20, DB Throttling) telah diekstraksi ke komponen terpisah.
 */
class VisionService : Service(), androidx.lifecycle.LifecycleOwner {

    private val lifecycleRegistry = androidx.lifecycle.LifecycleRegistry(this)
    override val lifecycle: androidx.lifecycle.Lifecycle get() = lifecycleRegistry
    
    private lateinit var cameraManager: VisionCameraManager
    private lateinit var analyzer: VisionAnalyzer
    private lateinit var overlayManager: BlurOverlayManager
    private lateinit var dbHelper: TelemetryDatabaseHelper
    
    private lateinit var rulesEngine: VisionRulesEngine
    private lateinit var deviceStateManager: DeviceStateManager
    
    private val cameraExecutor = Executors.newSingleThreadExecutor()

    private var SAMPLING_RATE_MS = 1000L
    private var lastProcessedTime = 0L
    
    companion object {
        var instance: VisionService? = null
        const val ACTION_STOP = "com.hn.visionsafe.ACTION_STOP"
    }

    fun updateThreshold(newThreshold: Double) {
        rulesEngine.violationThresholdCm = newThreshold
        Log.d("VisionSafe", "Threshold updated to: $newThreshold cm")
    }

    override fun onCreate() {
        super.onCreate()
        instance = this
        lifecycleRegistry.handleLifecycleEvent(androidx.lifecycle.Lifecycle.Event.ON_CREATE)

        createNotificationChannel()

        dbHelper = TelemetryDatabaseHelper(this)
        overlayManager = BlurOverlayManager(this)
        analyzer = VisionAnalyzer(this)
        
        // 1. Ekstraksi Business Logic (Rules Engine)
        rulesEngine = VisionRulesEngine(overlayManager, dbHelper, this) { dist, viol, blink, move, squint, lowLight ->
            sendTelemetry(dist, viol, blink, move, squint, lowLight)
        }

        // 2. Ekstraksi Device State Management (Battery, Screen, & Gyroscope)
        deviceStateManager = DeviceStateManager(this, 
            onScreenStateChanged = { isOn ->
                if (isOn) {
                    Log.d("VisionSafe", "Screen ON: Resuming AI")
                    cameraManager.start()
                } else {
                    Log.d("VisionSafe", "Screen OFF: Pausing AI")
                    cameraManager.stop()
                }
            },
            onBatteryStateChanged = { batteryPct, isCharging, tempC ->
                updateSamplingRateBasedOnBattery(batteryPct, isCharging, tempC)
            },
            onDeviceFlatStateChanged = { isFlat ->
                Log.d("VisionSafe", "Device Flat State: $isFlat")
                rulesEngine.isDeviceFlat = isFlat
                if (isFlat) {
                    Log.d("VisionSafe", "Hardware Sleep Mode: Pausing Camera")
                    cameraManager.stop()
                } else {
                    Log.d("VisionSafe", "Device Lifted: Resuming Camera")
                    cameraManager.start()
                }
            }
        )
        deviceStateManager.register()

        cameraManager = VisionCameraManager(this, this, cameraExecutor, onCameraError = { errorType ->
            if (errorType == "PERMISSION_REVOKED") {
                Log.w("VisionSafe", "TAMPERING DETECTED: Camera Permission Revoked!")
                // Simpan log pelanggaran kritis ke DB (Anti-Cheat)
                dbHelper.insertLog(
                    distance = 0.0,
                    isViolation = true,
                    isBlinking = false,
                    eyeMovement = "TAMPERED_PERMISSION",
                    isSquinting = false,
                    isPowerSave = false,
                    isLowLight = false,
                    timestamp = System.currentTimeMillis()
                )
                
                // Paksa layar terkunci sebagai hukuman
                android.os.Handler(android.os.Looper.getMainLooper()).post {
                    overlayManager.showWarning(
                        "PELANGGARAN SISTEM",
                        "Akses kamera dicabut secara paksa! Laporkan ke orang tua untuk membuka kunci.",
                        10000
                    )
                    overlayManager.show(true)
                }
            }
        }) { imageProxy ->
            processImage(imageProxy)
        }

        lifecycleRegistry.handleLifecycleEvent(androidx.lifecycle.Lifecycle.Event.ON_START)
        Log.d("VisionSafe", "VisionService & Subcomponents Created (Refactored)")
    }

    private fun updateSamplingRateBasedOnBattery(batteryPct: Float, isCharging: Boolean, tempC: Float) {
        val oldRate = SAMPLING_RATE_MS
        val sharedPref = getSharedPreferences("VisionSafePrefs", Context.MODE_PRIVATE)
        val userPrefRate = sharedPref.getInt("samplingRate", 1000).toLong()

        // 1. THERMAL THROTTLING (Prioritas Utama untuk mencegah Thermal Death)
        if (tempC >= 42.0f) {
            // Suhu Kritis: Cegah HP meledak/crash
            SAMPLING_RATE_MS = 10000L
            rulesEngine.isPowerSaveActive = true
            Log.w("VisionSafe", "THERMAL CRITICAL ($tempC°C): Throttling to 10s!")
        } else if (tempC >= 40.0f) {
            // Suhu Berat
            SAMPLING_RATE_MS = 5000L
            rulesEngine.isPowerSaveActive = true
            Log.w("VisionSafe", "THERMAL SEVERE ($tempC°C): Throttling to 5s!")
        } else if (tempC >= 38.0f) {
            // Suhu Sedang
            SAMPLING_RATE_MS = maxOf(3000L, userPrefRate)
            rulesEngine.isPowerSaveActive = true
            Log.w("VisionSafe", "THERMAL MODERATE ($tempC°C): Throttling to 3s!")
        } 
        // 2. BATTERY SAVER
        else if (batteryPct <= 20.0f && !isCharging) {
            SAMPLING_RATE_MS = if (batteryPct <= 10.0f) 5000L else 3000L
            rulesEngine.isPowerSaveActive = true
        } 
        // 3. NORMAL
        else {
            SAMPLING_RATE_MS = userPrefRate
            rulesEngine.isPowerSaveActive = false
        }
        
        if (oldRate != SAMPLING_RATE_MS) {
            Log.i("VisionSafe", "DYNAMIC FPS: Battery $batteryPct%, Temp $tempC°C, Charging: $isCharging. Rate: $SAMPLING_RATE_MS ms (Power Save: ${rulesEngine.isPowerSaveActive})")
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == ACTION_STOP) {
            stopSelf()
            return START_NOT_STICKY
        }

        val sharedPref = getSharedPreferences("VisionSafePrefs", Context.MODE_PRIVATE)
        val isServiceEnabled = sharedPref.getBoolean("service_enabled", false)
        if (!isServiceEnabled) {
            Log.w("VisionSafe", "VisionService start command ignored because service_enabled is false.")
            stopSelf()
            return START_NOT_STICKY
        }

        intent?.getDoubleExtra("threshold", -1.0)?.let {
            if (it > 0) rulesEngine.violationThresholdCm = it
        }

        intent?.getLongExtra("samplingRate", -1L)?.let {
            if (it > 0) {
                if (!rulesEngine.isPowerSaveActive) {
                    SAMPLING_RATE_MS = it
                    Log.d("VisionSafe", "Sampling rate updated via intent to: $it ms")
                }
            }
        }

        if (androidx.core.content.ContextCompat.checkSelfPermission(this, android.Manifest.permission.CAMERA) 
            != android.content.pm.PackageManager.PERMISSION_GRANTED) {
            Log.e("VisionSafe", "Batal menjalankan service: Izin Kamera tidak diberikan.")
            stopSelf()
            return START_NOT_STICKY
        }

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                startForeground(1, createNotification(), ServiceInfo.FOREGROUND_SERVICE_TYPE_CAMERA)
            } else {
                startForeground(1, createNotification())
            }
            
            if (!cameraManager.isCameraActive()) {
                cameraManager.start()
            }
        } catch (e: Exception) {
            Log.e("VisionSafe", "Gagal menjalankan Foreground Service", e)
            stopSelf()
        }

        return START_STICKY
    }

    private fun processImage(imageProxy: ImageProxy) {
        try {
            val currentTime = System.currentTimeMillis()
            if (currentTime - lastProcessedTime < SAMPLING_RATE_MS) {
                return 
            }
            
            // Delegate 20-20-20 rule tracking to Rules Engine
            rulesEngine.processScreenTime(SAMPLING_RATE_MS)

            lastProcessedTime = currentTime

            val result = analyzer.analyze(imageProxy)
            if (result != null) {
                Log.d("VisionSafe", "AI STATUS: FACE DETECTED AT ${result.distance.toInt()} CM. Blink: ${result.isBlinking}")
            } else {
                Log.v("VisionSafe", "AI STATUS: NO FACE")
            }
            
            // Delegate business logic to Rules Engine
            rulesEngine.handleResult(result, currentTime)
        } catch (e: Exception) {
            Log.e("VisionSafe", "Frame processing failed", e)
        } finally {
            imageProxy.close()
        }
    }

    private fun sendTelemetry(
        distance: Double, 
        isViolation: Boolean, 
        isBlinking: Boolean,
        eyeMovement: String,
        isSquinting: Boolean,
        isLowLight: Boolean
    ) {
        MainActivity.eventSink?.let { sink ->
            android.os.Handler(android.os.Looper.getMainLooper()).post {
                sink.success(mapOf(
                    "distance" to distance, 
                    "isViolation" to isViolation, 
                    "isBlinking" to isBlinking,
                    "eyeMovement" to eyeMovement,
                    "isSquinting" to isSquinting,
                    "isLowLight" to isLowLight,
                    "isPowerSaveActive" to rulesEngine.isPowerSaveActive,
                    "timestamp" to System.currentTimeMillis()
                ))
            }
        }
    }

    private fun createNotification(): Notification {
        val mainIntent = Intent(this, MainActivity::class.java)
        val pendingMainIntent = PendingIntent.getActivity(
            this, 0, mainIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        return NotificationCompat.Builder(this, "VisionSafeServiceChannel")
            .setContentTitle("VisionSafe: Mata Vizo Melindungi")
            .setContentText("Status: Aktif & Mengawasi")
            .setSmallIcon(R.mipmap.launcher_icon)
            .setOngoing(true)
            .setCategory(Notification.CATEGORY_SERVICE)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setContentIntent(pendingMainIntent)
            .build()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel("VisionSafeServiceChannel", "VisionSafe Guard", NotificationManager.IMPORTANCE_HIGH).apply {
                description = "Layanan monitoring jarak pandang real-time"
                lockscreenVisibility = Notification.VISIBILITY_PUBLIC
            }
            getSystemService(NotificationManager::class.java).createNotificationChannel(channel)
        }
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        Log.d("VisionSafe", "onTaskRemoved called - scheduling service restart")
        
        val restartServiceIntent = Intent(applicationContext, this.javaClass).apply {
            setPackage(packageName)
        }
        val restartServicePendingIntent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            PendingIntent.getForegroundService(
                applicationContext, 1, restartServiceIntent,
                PendingIntent.FLAG_ONE_SHOT or PendingIntent.FLAG_IMMUTABLE
            )
        } else {
            PendingIntent.getService(
                applicationContext, 1, restartServiceIntent,
                PendingIntent.FLAG_ONE_SHOT or PendingIntent.FLAG_IMMUTABLE
            )
        }
        
        val alarmService = applicationContext.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        try {
            alarmService.set(
                AlarmManager.RTC_WAKEUP,
                System.currentTimeMillis() + 1000,
                restartServicePendingIntent
            )
        } catch (e: Exception) {
            Log.e("VisionSafe", "Failed to schedule restart alarm", e)
        }
        
        super.onTaskRemoved(rootIntent)
    }

    override fun onDestroy() {
        MainActivity.eventSink?.let { sink ->
            android.os.Handler(android.os.Looper.getMainLooper()).post {
                sink.success(mapOf("status" to "STOPPED"))
            }
        }

        instance = null
        lifecycleRegistry.handleLifecycleEvent(androidx.lifecycle.Lifecycle.Event.ON_DESTROY)
        
        deviceStateManager.unregister()
        
        cameraManager.stop()
        analyzer.close()
        cameraExecutor.shutdown()
        overlayManager.hide()
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null
}

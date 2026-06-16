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
import androidx.core.app.NotificationManagerCompat

/**
 * Orchestrator Utama (Service).
 */
class VisionService : Service(), androidx.lifecycle.LifecycleOwner {

    private val lifecycleRegistry = androidx.lifecycle.LifecycleRegistry(this)
    override val lifecycle: androidx.lifecycle.Lifecycle get() = lifecycleRegistry
    private lateinit var cameraManager: VisionCameraManager
    private lateinit var analyzer: VisionAnalyzer
    private lateinit var overlayManager: BlurOverlayManager
    private val cameraExecutor = Executors.newSingleThreadExecutor()

    private var SAMPLING_RATE_MS = 1000L // Dioptimalkan: 1 detik sekali (Dapat diubah secara dinamis)
    private var isPowerSaveActive = false
    private var lastProcessedTime = 0L
    private var violationStartTime = 0L
    private var violationThresholdCm = 35.0
    private val TRIGGER_DELAY_MS = 1500L

    companion object {
        var instance: VisionService? = null
        const val ACTION_STOP = "com.hn.visionsafe.ACTION_STOP"
    }

    fun updateThreshold(newThreshold: Double) {
        violationThresholdCm = newThreshold
        Log.d("VisionSafe", "Threshold updated to: $newThreshold cm")
    }

    private val screenStateReceiver = object : android.content.BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            when (intent.action) {
                Intent.ACTION_SCREEN_OFF -> {
                    Log.d("VisionSafe", "Screen OFF: Pausing AI")
                    cameraManager.stop()
                }
                Intent.ACTION_SCREEN_ON -> {
                    Log.d("VisionSafe", "Screen ON: Resuming AI")
                    cameraManager.start()
                }
            }
        }
    }

    private val batteryReceiver = object : android.content.BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val level = intent.getIntExtra(android.os.BatteryManager.EXTRA_LEVEL, -1)
            val scale = intent.getIntExtra(android.os.BatteryManager.EXTRA_SCALE, -1)
            val status = intent.getIntExtra(android.os.BatteryManager.EXTRA_STATUS, -1)
            
            val batteryPct = if (scale > 0) level * 100 / scale.toFloat() else 100.0f
            val isCharging = status == android.os.BatteryManager.BATTERY_STATUS_CHARGING ||
                             status == android.os.BatteryManager.BATTERY_STATUS_FULL
                            
            updateSamplingRateBasedOnBattery(batteryPct, isCharging)
        }
    }

    private fun updateSamplingRateBasedOnBattery(batteryPct: Float, isCharging: Boolean) {
        val oldRate = SAMPLING_RATE_MS
        if (batteryPct <= 20.0f && !isCharging) {
            SAMPLING_RATE_MS = if (batteryPct <= 10.0f) 5000L else 3000L
            isPowerSaveActive = true
        } else {
            val sharedPref = getSharedPreferences("VisionSafePrefs", Context.MODE_PRIVATE)
            SAMPLING_RATE_MS = sharedPref.getInt("samplingRate", 1000).toLong()
            isPowerSaveActive = false
        }
        if (oldRate != SAMPLING_RATE_MS) {
            Log.i("VisionSafe", "DYNAMIC FPS: Battery level $batteryPct%, Charging: $isCharging. Sampling rate adjusted to $SAMPLING_RATE_MS ms (Power Save: $isPowerSaveActive)")
        }
    }

    override fun onCreate() {
        super.onCreate()
        instance = this
        Log.d("VisionSafe", "VisionService Created")
        lifecycleRegistry.handleLifecycleEvent(androidx.lifecycle.Lifecycle.Event.ON_CREATE)

        analyzer = VisionAnalyzer(this)
        overlayManager = BlurOverlayManager(this)
        cameraManager = VisionCameraManager(this, this, cameraExecutor) { processImage(it) }

        createNotificationChannel()

        val filter = android.content.IntentFilter().apply {
            addAction(Intent.ACTION_SCREEN_OFF)
            addAction(Intent.ACTION_SCREEN_ON)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(screenStateReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            registerReceiver(screenStateReceiver, filter)
        }

        val batteryFilter = android.content.IntentFilter(Intent.ACTION_BATTERY_CHANGED)
        val batteryStatusIntent = registerReceiver(batteryReceiver, batteryFilter)
        batteryStatusIntent?.let {
            val level = it.getIntExtra(android.os.BatteryManager.EXTRA_LEVEL, -1)
            val scale = it.getIntExtra(android.os.BatteryManager.EXTRA_SCALE, -1)
            val status = it.getIntExtra(android.os.BatteryManager.EXTRA_STATUS, -1)
            val batteryPct = if (scale > 0) level * 100 / scale.toFloat() else 100.0f
            val isCharging = status == android.os.BatteryManager.BATTERY_STATUS_CHARGING ||
                             status == android.os.BatteryManager.BATTERY_STATUS_FULL
            updateSamplingRateBasedOnBattery(batteryPct, isCharging)
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        lifecycleRegistry.handleLifecycleEvent(androidx.lifecycle.Lifecycle.Event.ON_START)
        
        // Handle Action STOP dari Notifikasi
        if (intent?.action == ACTION_STOP) {
            Log.i("VisionSafe", "Received STOP action from notification")
            val sharedPref = getSharedPreferences("VisionSafePrefs", Context.MODE_PRIVATE)
            sharedPref.edit().putBoolean("service_enabled", false).apply()
            stopSelf()
            return START_NOT_STICKY
        }

        // Layer 2 Lock: Pastikan service tidak berjalan jika service_enabled bernilai false
        val sharedPref = getSharedPreferences("VisionSafePrefs", Context.MODE_PRIVATE)
        val isServiceEnabled = sharedPref.getBoolean("service_enabled", false)
        if (!isServiceEnabled) {
            Log.w("VisionSafe", "VisionService start command ignored because service_enabled is false.")
            stopSelf()
            return START_NOT_STICKY
        }

        intent?.getDoubleExtra("threshold", -1.0)?.let {
            if (it > 0) violationThresholdCm = it
        }

        intent?.getLongExtra("samplingRate", -1L)?.let {
            if (it > 0) {
                if (!isPowerSaveActive) {
                    SAMPLING_RATE_MS = it
                    Log.d("VisionSafe", "Sampling rate updated via intent to: $it ms")
                } else {
                    Log.d("VisionSafe", "Sampling rate updated in prefs to $it ms, but ignored for now because Power Save is active.")
                }
            }
        }

        // Cek Izin Kamera sebelum startForeground (Krusial untuk Android 14+)
        if (androidx.core.content.ContextCompat.checkSelfPermission(this, android.Manifest.permission.CAMERA) 
            != android.content.pm.PackageManager.PERMISSION_GRANTED) {
            Log.e("VisionSafe", "Batal menjalankan service: Izin Kamera tidak diberikan.")
            stopSelf()
            return START_NOT_STICKY
        }

        try {
            // Android 14 (API 34) Foreground Service Compliance
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                startForeground(1, createNotification(), ServiceInfo.FOREGROUND_SERVICE_TYPE_CAMERA)
            } else {
                startForeground(1, createNotification())
            }
            
            if (cameraManager.isCameraActive().not()) {
                cameraManager.start()
            }
        } catch (e: Exception) {
            Log.e("VisionSafe", "Gagal menjalankan Foreground Service", e)
            stopSelf()
        }

        return START_STICKY
    }

    private fun processImage(imageProxy: ImageProxy) {
        val currentTime = System.currentTimeMillis()
        if (currentTime - lastProcessedTime < SAMPLING_RATE_MS) {
            imageProxy.close()
            return
        }
        lastProcessedTime = currentTime

        val result = analyzer.analyze(imageProxy)
        // Log krusial untuk memastikan AI deteksi di background
        if (result != null) {
            Log.d("VisionSafe", "AI STATUS: FACE DETECTED AT ${result.distance.toInt()} CM. Blink: ${result.isBlinking}")
        } else {
            Log.v("VisionSafe", "AI STATUS: NO FACE")
        }
        
        handleResult(result, currentTime)
        imageProxy.close()
    }

    private fun handleResult(result: VisionAnalyzer.AnalysisResult?, currentTime: Long) {
        if (result == null) {
            violationStartTime = 0L
            updateOverlay(false, false)
            return
        }

        val distance = result.distance
        val isViolation = distance < violationThresholdCm
        sendTelemetry(distance, isViolation, result.isBlinking, result.eyeMovement, result.isSquinting)

        if (isViolation) {
            if (violationStartTime == 0L) violationStartTime = currentTime
            
            val violationDuration = currentTime - violationStartTime
            if (violationDuration > 10000L) { // 10 Detik: Emergency Lock
                Log.w("VisionSafe", "!!! EMERGENCY LOCK !!!")
                updateOverlay(true, isEmergency = true)
            } else if (violationDuration > TRIGGER_DELAY_MS) { // 1.5 Detik: Normal Blur
                Log.w("VisionSafe", "!!! CRITICAL DISTANCE !!! Showing Blur.")
                updateOverlay(true, isEmergency = false)
            }
        } else {
            violationStartTime = 0L
            updateOverlay(false, false)
        }
    }

    private fun sendTelemetry(
        distance: Double, 
        isViolation: Boolean, 
        isBlinking: Boolean,
        eyeMovement: String = "center",
        isSquinting: Boolean = false
    ) {
        MainActivity.eventSink?.let { sink ->
            android.os.Handler(android.os.Looper.getMainLooper()).post {
                sink.success(mapOf(
                    "distance" to distance, 
                    "isViolation" to isViolation, 
                    "isBlinking" to isBlinking,
                    "eyeMovement" to eyeMovement,
                    "isSquinting" to isSquinting,
                    "isPowerSaveActive" to isPowerSaveActive,
                    "timestamp" to System.currentTimeMillis()
                ))
            }
        }
    }

    private fun updateOverlay(show: Boolean, isEmergency: Boolean) {
        android.os.Handler(android.os.Looper.getMainLooper()).post {
            if (show) overlayManager.show(isEmergency) else overlayManager.hide()
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
            .setSmallIcon(android.R.drawable.ic_menu_view)
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
        Log.d("VisionSafe", "onTaskRemoved called - scheduling service restart to persist background task")
        
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
            Log.e("VisionSafe", "Failed to schedule restart alarm on task removed", e)
        }
        
        super.onTaskRemoved(rootIntent)
    }

    override fun onDestroy() {
        // Beritahu Flutter bahwa service telah berhenti (penting untuk sinkronisasi UI)
        MainActivity.eventSink?.let { sink ->
            android.os.Handler(android.os.Looper.getMainLooper()).post {
                sink.success(mapOf("status" to "STOPPED"))
            }
        }

        instance = null
        lifecycleRegistry.handleLifecycleEvent(androidx.lifecycle.Lifecycle.Event.ON_DESTROY)
        try {
            unregisterReceiver(screenStateReceiver)
        } catch (e: Exception) {
            Log.e("VisionSafe", "Failed to unregister screenStateReceiver", e)
        }
        try {
            unregisterReceiver(batteryReceiver)
        } catch (e: Exception) {
            Log.e("VisionSafe", "Failed to unregister batteryReceiver", e)
        }
        cameraManager.stop()
        analyzer.close()
        cameraExecutor.shutdown()
        overlayManager.hide()
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null
}

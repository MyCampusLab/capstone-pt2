package com.hn.visionsafe

import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.Settings
import android.os.PowerManager
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val METHOD_CHANNEL = "com.hn.visionsafe/service"
    private val EVENT_CHANNEL = "com.hn.visionsafe/telemetry"
    private val TELEMETRY_DB_CHANNEL = "com.hn.visionsafe/telemetry_db"

    companion object {
        var eventSink: EventChannel.EventSink? = null
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startService" -> {
                    if (checkOverlayPermission()) {
                        startVisionService()
                        result.success(true)
                    } else {
                        requestOverlayPermission()
                        result.error("PERMISSION_DENIED", "Overlay permission not granted", null)
                    }
                }
                "stopService" -> {
                    stopVisionService()
                    result.success(true)
                }
                "isServiceRunning" -> {
                    result.success(isServiceRunning(VisionService::class.java))
                }
                "checkOverlayPermission" -> {
                    result.success(checkOverlayPermission())
                }
                "requestOverlayPermission" -> {
                    requestOverlayPermission()
                    result.success(null)
                }
                "checkBatteryOptimization" -> {
                    val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
                    val isIgnoring = pm.isIgnoringBatteryOptimizations(packageName)
                    result.success(isIgnoring)
                }
                "requestIgnoreBatteryOptimization" -> {
                    val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
                    if (!pm.isIgnoringBatteryOptimizations(packageName)) {
                        val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
                            data = Uri.parse("package:$packageName")
                        }
                        startActivity(intent)
                    }
                    result.success(null)
                }
                "requestAutoStartPermission" -> {
                    requestAutoStartPermission()
                    result.success(null)
                }
                "checkAccessibilityPermission" -> {
                    result.success(checkAccessibilityPermission())
                }
                "requestAccessibilityPermission" -> {
                    requestAccessibilityPermission()
                    result.success(null)
                }
                "updateThreshold" -> {
                    val threshold = call.argument<Double>("threshold") ?: 35.0
                    val sharedPref = getSharedPreferences("VisionSafePrefs", Context.MODE_PRIVATE)
                    sharedPref.edit().putFloat("threshold", threshold.toFloat()).apply()
                    
                    if (isServiceRunning(VisionService::class.java)) {
                        val intent = Intent(this, VisionService::class.java).apply {
                            putExtra("threshold", threshold)
                        }
                        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                            startForegroundService(intent)
                        } else {
                            startService(intent)
                        }
                    }
                    result.success(true)
                }
                "setCalibrationMultiplier" -> {
                    val multiplier = call.argument<Double>("multiplier") ?: 1.0
                    val sharedPref = getSharedPreferences("VisionSafePrefs", Context.MODE_PRIVATE)
                    sharedPref.edit().putFloat("calibrationMultiplier", multiplier.toFloat()).apply()
                    result.success(true)
                }
                "updateSamplingRate" -> {
                    val samplingRate = call.argument<Int>("samplingRate") ?: 1000
                    val sharedPref = getSharedPreferences("VisionSafePrefs", Context.MODE_PRIVATE)
                    sharedPref.edit().putInt("samplingRate", samplingRate).apply()
                    
                    if (isServiceRunning(VisionService::class.java)) {
                        val intent = Intent(this, VisionService::class.java).apply {
                            putExtra("samplingRate", samplingRate.toLong())
                        }
                        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                            startForegroundService(intent)
                        } else {
                            startService(intent)
                        }
                    }
                    result.success(true)
                }
                "showNudgeOverlay" -> {
                    if (checkOverlayPermission()) {
                        val sender = call.argument<String>("sender") ?: "Keluarga"
                        val message = call.argument<String>("message") ?: "Perhatikan jarak matamu!"
                        
                        // Gunakan applicationContext agar tetap aman meskipun Activity dalam state Stopped
                        val overlayManager = BlurOverlayManager(applicationContext)
                        // Tampilkan overlay selama 5 detik
                        overlayManager.showWarning("TEGURAN: ${sender.uppercase()}", message, 5000)
                        result.success(true)
                    } else {
                        result.error("PERMISSION_DENIED", "Overlay permission not granted", null)
                    }
                }
                else -> result.notImplemented()
            }
        }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                }
                override fun onCancel(arguments: Any?) {
                    eventSink = null
                }
            }
        )

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, TELEMETRY_DB_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getUnsyncedLogs" -> {
                    val limit = call.argument<Int>("limit") ?: 100
                    val dbHelper = TelemetryDatabaseHelper(this)
                    val logs = dbHelper.getUnsyncedLogs(limit)
                    result.success(logs)
                }
                "deleteLogs" -> {
                    val ids = call.argument<List<Int>>("ids") ?: emptyList()
                    if (ids.isNotEmpty()) {
                        val dbHelper = TelemetryDatabaseHelper(this)
                        dbHelper.deleteLogs(ids)
                    }
                    result.success(true)
                }
                "setAuthContext" -> {
                    val sharedPref = getSharedPreferences("VisionSafePrefs", Context.MODE_PRIVATE)
                    with(sharedPref.edit()) {
                        putString("supabase_url", call.argument<String>("supabase_url"))
                        putString("supabase_anon_key", call.argument<String>("supabase_anon_key"))
                        putString("supabase_jwt", call.argument<String>("supabase_jwt"))
                        putString("supabase_refresh_token", call.argument<String>("supabase_refresh_token") ?: "")
                        putString("supabase_uuid", call.argument<String>("supabase_uuid"))
                        apply()
                    }
                    result.success(true)
                }
                "getAuthContext" -> {
                    val sharedPref = getSharedPreferences("VisionSafePrefs", Context.MODE_PRIVATE)
                    val authData = mapOf(
                        "supabase_jwt" to sharedPref.getString("supabase_jwt", null),
                        "supabase_refresh_token" to sharedPref.getString("supabase_refresh_token", null),
                        "supabase_uuid" to sharedPref.getString("supabase_uuid", null)
                    )
                    result.success(authData)
                }
                "setEquippedSticker" -> {
                    val sharedPref = getSharedPreferences("VisionSafePrefs", Context.MODE_PRIVATE)
                    val stickerId = call.argument<String>("id")
                    with(sharedPref.edit()) {
                        putString("equipped_sticker", stickerId)
                        apply()
                    }
                    
                    // Kita juga harus merestart aturan rules engine agar efek langsung terasa
                    // Tapi karena rules engine dipegang oleh Service, biarkan polling atau intent yang menghandle
                    // Untuk saat ini, menyimpan di SharedPreferences sudah cukup karena VisionRulesEngine 
                    // akan membacanya setiap kali service direstart atau diinisialisasi
                    
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun checkOverlayPermission(): Boolean {
        return if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
            Settings.canDrawOverlays(this)
        } else true
    }

    private fun requestOverlayPermission() {
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
            val intent = Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:$packageName")
            )
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
        }
    }

    private fun requestAutoStartPermission() {
        try {
            val intents = arrayOf(
                Intent().setComponent(android.content.ComponentName("com.miui.securitycenter", "com.miui.permcenter.autostart.AutoStartManagementActivity")),
                Intent().setComponent(android.content.ComponentName("com.letv.android.letvsafe", "com.letv.android.letvsafe.AutobootManageActivity")),
                Intent().setComponent(android.content.ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity")),
                Intent().setComponent(android.content.ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.optimize.process.ProtectActivity")),
                Intent().setComponent(android.content.ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.appcontrol.activity.StartupAppControlActivity")),
                Intent().setComponent(android.content.ComponentName("com.coloros.safecenter", "com.coloros.safecenter.permission.startup.StartupAppListActivity")),
                Intent().setComponent(android.content.ComponentName("com.coloros.safecenter", "com.coloros.safecenter.startupapp.StartupAppListActivity")),
                Intent().setComponent(android.content.ComponentName("com.oppo.safe", "com.oppo.safe.permission.startup.StartupAppListActivity")),
                Intent().setComponent(android.content.ComponentName("com.iqoo.secure", "com.iqoo.secure.ui.phoneoptimize.AddWhiteListActivity")),
                Intent().setComponent(android.content.ComponentName("com.iqoo.secure", "com.iqoo.secure.ui.phoneoptimize.BgStartUpManager")),
                Intent().setComponent(android.content.ComponentName("com.vivo.permissionmanager", "com.vivo.permissionmanager.activity.BgStartUpManagerActivity")),
                Intent().setComponent(android.content.ComponentName("com.samsung.android.lool", "com.samsung.android.sm.ui.battery.BatteryActivity")),
                Intent().setComponent(android.content.ComponentName("com.htc.pitroad", "com.htc.pitroad.landingpage.activity.LandingPageActivity")),
                Intent().setComponent(android.content.ComponentName("com.asus.mobilemanager", "com.asus.mobilemanager.MainActivity"))
            )

            for (intent in intents) {
                if (packageManager.resolveActivity(intent, android.content.pm.PackageManager.MATCH_DEFAULT_ONLY) != null) {
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    startActivity(intent)
                    break
                }
            }
        } catch (e: Exception) {
            Log.e("VisionSafe", "Failed to open AutoStart settings: ${e.message}")
        }
    }

    private fun isServiceRunning(serviceClass: Class<*>): Boolean {
        val manager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        for (service in manager.getRunningServices(Int.MAX_VALUE)) {
            if (serviceClass.name == service.service.className) return true
        }
        return false
    }

    private fun checkAccessibilityPermission(): Boolean {
        var accessibilityEnabled = 0
        val service = "$packageName/${VisionAccessibilityService::class.java.canonicalName}"
        try {
            accessibilityEnabled = Settings.Secure.getInt(
                applicationContext.contentResolver,
                android.provider.Settings.Secure.ACCESSIBILITY_ENABLED
            )
        } catch (e: Settings.SettingNotFoundException) {
            Log.e("VisionSafe", "Error finding setting, default accessibility to not found: " + e.message)
        }
        val mStringColonSplitter = android.text.TextUtils.SimpleStringSplitter(':')
        if (accessibilityEnabled == 1) {
            val settingValue = Settings.Secure.getString(
                applicationContext.contentResolver,
                Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES
            )
            if (settingValue != null) {
                mStringColonSplitter.setString(settingValue)
                while (mStringColonSplitter.hasNext()) {
                    val accessibilityService = mStringColonSplitter.next()
                    if (accessibilityService.equals(service, ignoreCase = true)) {
                        return true
                    }
                }
            }
        }
        return false
    }

    private fun requestAccessibilityPermission() {
        val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        startActivity(intent)
    }

    private fun startVisionService() {
        val sharedPref = getSharedPreferences("VisionSafePrefs", Context.MODE_PRIVATE)
        sharedPref.edit().putBoolean("service_enabled", true).apply()
        val threshold = sharedPref.getFloat("threshold", 35.0f).toDouble()

        val intent = Intent(this, VisionService::class.java).apply {
            putExtra("threshold", threshold)
        }
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            startForegroundService(intent)
        } else {
            startService(intent)
        }
    }

    private fun stopVisionService() {
        val sharedPref = getSharedPreferences("VisionSafePrefs", Context.MODE_PRIVATE)
        sharedPref.edit().putBoolean("service_enabled", false).apply()
        stopService(Intent(this, VisionService::class.java))
    }

    override fun onDestroy() {
        eventSink = null
        super.onDestroy()
    }
}

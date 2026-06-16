package com.hn.visionsafe

import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val METHOD_CHANNEL = "com.hn.visionsafe/service"
    private val EVENT_CHANNEL = "com.hn.visionsafe/telemetry"

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
            startActivityForResult(intent, 1234)
        }
    }

    private fun isServiceRunning(serviceClass: Class<*>): Boolean {
        val manager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        for (service in manager.getRunningServices(Int.MAX_VALUE)) {
            if (serviceClass.name == service.service.className) return true
        }
        return false
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

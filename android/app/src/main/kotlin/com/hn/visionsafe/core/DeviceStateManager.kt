package com.hn.visionsafe.core

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.util.Log

/**
 * DeviceStateManager: Ekstraksi Receiver dan State Management.
 * Modular, Reusable, & Scalable.
 */
class DeviceStateManager(
    private val context: Context,
    private val onScreenStateChanged: (isOn: Boolean) -> Unit,
    private val onBatteryStateChanged: (batteryPct: Float, isCharging: Boolean, temperatureC: Float) -> Unit,
    private val onDeviceFlatStateChanged: (isFlat: Boolean) -> Unit
) : android.hardware.SensorEventListener {

    private val sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as android.hardware.SensorManager
    private val accelerometer = sensorManager.getDefaultSensor(android.hardware.Sensor.TYPE_ACCELEROMETER)
    
    private var isCurrentlyFlat = false
    private var flatDetectionStartTime = 0L
    private val FLAT_DELAY_MS = 5000L // 5 detik harus stabil datar


    private val screenStateReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            when (intent.action) {
                Intent.ACTION_SCREEN_OFF -> onScreenStateChanged(false)
                Intent.ACTION_SCREEN_ON -> onScreenStateChanged(true)
            }
        }
    }

    private val batteryReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val level = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
            val scale = intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
            val status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1)
            val tempTenths = intent.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, 0)
            
            val batteryPct = if (scale > 0) level * 100 / scale.toFloat() else 100.0f
            val isCharging = status == BatteryManager.BATTERY_STATUS_CHARGING ||
                             status == BatteryManager.BATTERY_STATUS_FULL
            val tempC = tempTenths / 10.0f
                            
            onBatteryStateChanged(batteryPct, isCharging, tempC)
        }
    }

    fun register() {
        val screenFilter = IntentFilter().apply {
            addAction(Intent.ACTION_SCREEN_ON)
            addAction(Intent.ACTION_SCREEN_OFF)
        }
        context.registerReceiver(screenStateReceiver, screenFilter)

        val batteryFilter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
        context.registerReceiver(batteryReceiver, batteryFilter)
        
        accelerometer?.let {
            sensorManager.registerListener(this, it, android.hardware.SensorManager.SENSOR_DELAY_NORMAL)
        }
        
        Log.d("VisionSafe", "DeviceStateManager registered receivers and sensors.")
    }

    fun unregister() {
        try {
            context.unregisterReceiver(screenStateReceiver)
            context.unregisterReceiver(batteryReceiver)
            sensorManager.unregisterListener(this)
            Log.d("VisionSafe", "DeviceStateManager unregistered receivers and sensors.")
        } catch (e: Exception) {
            Log.e("VisionSafe", "Error unregistering DeviceStateManager receivers", e)
        }
    }

    override fun onSensorChanged(event: android.hardware.SensorEvent?) {
        if (event?.sensor?.type == android.hardware.Sensor.TYPE_ACCELEROMETER) {
            val z = event.values[2]
            // Jika Z mendekati 9.8 m/s^2, berarti layar menghadap ke atas (datar di meja)
            val isFlat = z > 8.5f || z < -8.5f
            
            val currentTime = System.currentTimeMillis()
            if (isFlat) {
                if (flatDetectionStartTime == 0L) flatDetectionStartTime = currentTime
                else if (currentTime - flatDetectionStartTime > FLAT_DELAY_MS && !isCurrentlyFlat) {
                    isCurrentlyFlat = true
                    onDeviceFlatStateChanged(true)
                }
            } else {
                flatDetectionStartTime = 0L
                if (isCurrentlyFlat) {
                    isCurrentlyFlat = false
                    onDeviceFlatStateChanged(false)
                }
            }
        }
    }

    override fun onAccuracyChanged(sensor: android.hardware.Sensor?, accuracy: Int) {}
}

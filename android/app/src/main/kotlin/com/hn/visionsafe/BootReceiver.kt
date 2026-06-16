package com.hn.visionsafe

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import androidx.core.content.ContextCompat

/**
 * Receiver untuk menjalankan VisionService otomatis saat HP nyala.
 * Bagian dari Fortress Protocol: "Unstoppable".
 * Diperkuat agar menghormati toggle service_enabled dari user.
 */
class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED || 
            intent.action == "android.intent.action.QUICKBOOT_POWERON") {
            
            Log.d("VisionSafe", "BootReceiver: System boot completed.")
            
            // Cek apakah user mengaktifkan layanan ini secara manual
            val sharedPref = context.getSharedPreferences("VisionSafePrefs", Context.MODE_PRIVATE)
            val isServiceEnabled = sharedPref.getBoolean("service_enabled", false)
            if (!isServiceEnabled) {
                Log.i("VisionSafe", "BootReceiver: VisionService is disabled by user. Skipping autostart.")
                return
            }

            // Cegah crash ForegroundServiceDidNotStartInTimeException di Android 14+
            // dengan mengecek izin terlebih dahulu.
            val hasCamera = ContextCompat.checkSelfPermission(context, android.Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED
            if (!hasCamera) {
                Log.w("VisionSafe", "BootReceiver: Camera permission not granted. Skipping autostart.")
                return
            }
            
            val serviceIntent = Intent(context, VisionService::class.java)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(serviceIntent)
            } else {
                context.startService(serviceIntent)
            }
        }
    }
}

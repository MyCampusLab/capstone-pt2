package com.hn.visionsafe

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.content.Intent
import android.util.Log
import android.view.accessibility.AccessibilityEvent

class VisionAccessibilityService : AccessibilityService() {

    companion object {
        var isPunishmentActive = false
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        val info = AccessibilityServiceInfo()
        info.eventTypes = AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED or AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED
        info.feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC
        info.flags = AccessibilityServiceInfo.FLAG_INCLUDE_NOT_IMPORTANT_VIEWS
        this.serviceInfo = info
        Log.i("VisionSafe", "VisionAccessibilityService Connected!")
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null || !isPunishmentActive) return

        if (event.eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            val packageName = event.packageName?.toString() ?: ""
            
            // Jika user mencoba membuka aplikasi lain atau masuk ke layar Recent Apps
            // (yang memungkinkan mereka meng-kill VisionSafe)
            if (packageName != "com.hn.visionsafe") {
                Log.w("VisionSafe", "Bypass attempt detected by child! Package: $packageName")
                // Paksa kembali ke aplikasi kita atau tekan tombol BACK/HOME secara paksa
                performGlobalAction(GLOBAL_ACTION_HOME)
                
                // Atau, munculkan kembali Main Activity agar layar terkunci sepenuhnya
                val intent = Intent(this, MainActivity::class.java)
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                startActivity(intent)
            }
        }
    }

    override fun onInterrupt() {
        Log.w("VisionSafe", "VisionAccessibilityService Interrupted!")
    }
}

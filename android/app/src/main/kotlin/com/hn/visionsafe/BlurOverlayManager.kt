package com.hn.visionsafe

import android.content.Context
import android.graphics.Color
import android.graphics.PixelFormat
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import android.widget.FrameLayout
import android.widget.TextView
import android.util.Log
import android.graphics.drawable.GradientDrawable

/**
 * Manager Intervensi Overlay (Native Android).
 * Diperhalus agar mendekati style 2D Retro Flutter.
 * File: BlurOverlayManager.kt (< 150 lines)
 */
class BlurOverlayManager(private val context: Context) {

    private var windowManager: WindowManager? = null
    private var overlayView: View? = null
    private var isShowing = false
    private var isCurrentlyEmergency = false

    fun show(isEmergency: Boolean = false) {
        if (isShowing && isCurrentlyEmergency == isEmergency) return
        
        try {
            // Jika status berubah (dari blur ke emergency), hapus dulu yang lama
            if (isShowing) {
                windowManager?.removeView(overlayView)
            }

            windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
            val params = getLayoutParams(isEmergency)
            
            overlayView = createStyledOverlay(isEmergency)
            windowManager?.addView(overlayView, params)
            isShowing = true
            isCurrentlyEmergency = isEmergency
        } catch (e: Exception) {
            Log.e("VisionSafe", "Overlay Show Failed", e)
        }
    }

    private fun getLayoutParams(isEmergency: Boolean): WindowManager.LayoutParams {
        val type = if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O)
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        else WindowManager.LayoutParams.TYPE_PHONE

        var flags = WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN or WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS
        
        // Jika emergency, kita BUKAN FLAG_NOT_FOCUSABLE agar dia menyerap semua input (Device Lock)
        if (!isEmergency) {
            flags = flags or WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
        }

        return WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT, 
            WindowManager.LayoutParams.MATCH_PARENT,
            type, 
            flags,
            if (isEmergency) PixelFormat.OPAQUE else PixelFormat.TRANSLUCENT
        ).apply { gravity = Gravity.CENTER }
    }

    private fun createStyledOverlay(isEmergency: Boolean): View {
        val root = FrameLayout(context).apply {
            // Background Gelap & Mengganggu (Z-Order High)
            setBackgroundColor(Color.parseColor(if (isEmergency) "#E6000000" else "#CC000000"))
        }

        // Card Container - Retro 2D Style
        val card = FrameLayout(context).apply {
            background = GradientDrawable().apply {
                setColor(if (isEmergency) Color.parseColor("#FF0000") else Color.parseColor("#1A1A1A"))
                cornerRadius = 80f
                setStroke(12, Color.WHITE) // Border Retro Tebal
            }
            setPadding(60, 100, 60, 100)
            elevation = 30f
        }

        val layout = android.widget.LinearLayout(context).apply {
            orientation = android.widget.LinearLayout.VERTICAL
            gravity = Gravity.CENTER
        }

        // Icon Stop / Warning
        val icon = TextView(context).apply {
            text = if (isEmergency) "🛑" else "⚠️"
            textSize = 80f
            gravity = Gravity.CENTER
        }

        // Pesan Utama - Runtut kebawah & Tegas
        val message = TextView(context).apply {
            text = if (isEmergency) 
                "STOP!\nTERLALU DEKAT\n\nMUNDUR\nSEKARANG" 
            else 
                "PERINGATAN!\n\nJAUHKAN\nPANDANGANMU"
            
            setTextColor(Color.WHITE)
            textSize = 32f
            gravity = Gravity.CENTER
            setTypeface(null, android.graphics.Typeface.BOLD)
            setLineSpacing(0f, 1.2f)
        }

        val cardParams = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT, 
            FrameLayout.LayoutParams.WRAP_CONTENT, 
            Gravity.CENTER
        ).apply {
            setMargins(50, 0, 50, 0)
        }
        
        layout.addView(icon)
        layout.addView(message)
        card.addView(layout)
        root.addView(card, cardParams)
        
        return root
    }

    fun hide() {
        if (!isShowing) return
        try {
            windowManager?.removeView(overlayView)
            overlayView = null
            isShowing = false
            isCurrentlyEmergency = false
        } catch (e: Exception) {
            Log.e("VisionSafe", "Overlay Hide Failed", e)
        }
    }
}

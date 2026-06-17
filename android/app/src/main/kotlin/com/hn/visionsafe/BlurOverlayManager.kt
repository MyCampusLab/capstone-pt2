package com.hn.visionsafe

import android.animation.ObjectAnimator
import android.animation.PropertyValuesHolder
import android.animation.ValueAnimator
import android.content.Context
import android.graphics.Color
import android.graphics.PixelFormat
import android.view.Gravity
import android.view.View
import android.view.WindowManager
import android.view.animation.AccelerateDecelerateInterpolator
import android.view.animation.OvershootInterpolator
import android.widget.FrameLayout
import android.widget.LinearLayout
import android.widget.TextView
import android.util.Log
import android.graphics.drawable.GradientDrawable

/**
 * Manager Intervensi Overlay (Native Android).
 * Terintegrasi dengan VizoMascotView (Custom View 1:1 dengan Flutter Robot Mascot).
 */
class BlurOverlayManager(private val context: Context) {

    private var windowManager: WindowManager? = null
    private var overlayView: View? = null
    private var isShowing = false
    private var isCurrentlyEmergency = false
    private val animators = mutableListOf<ValueAnimator>()

    fun show(isEmergency: Boolean = false) {
        if (isShowing && isCurrentlyEmergency == isEmergency) return
        
        try {
            if (isShowing) hide()

            windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
            val params = getLayoutParams(isEmergency)
            
            overlayView = createAnimatedOverlay(isEmergency)
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

        // BUG FIX: Selalu gunakan FLAG_NOT_FOCUSABLE agar overlay tidak memblokir sentuhan (touch events).
        // Jika tidak, pengguna akan terjebak (stuck) dan tidak bisa menekan tombol matikan fitur.
        val flags = WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN or 
                    WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS or 
                    WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE

        return WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT, 
            WindowManager.LayoutParams.MATCH_PARENT,
            type, 
            flags,
            if (isEmergency) PixelFormat.OPAQUE else PixelFormat.TRANSLUCENT
        ).apply { gravity = Gravity.CENTER }
    }

    private fun createAnimatedOverlay(isEmergency: Boolean): View {
        val root = FrameLayout(context).apply {
            setBackgroundColor(Color.parseColor(if (isEmergency) "#E6000000" else "#CC000000"))
        }

        val layout = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER
            layoutParams = FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT, 
                FrameLayout.LayoutParams.MATCH_PARENT
            )
        }

        // 1. MASKOT ROBOT VIZO (1:1 dengan Flutter)
        val mascotView = VizoMascotView(context, isEmergency).apply {
            layoutParams = LinearLayout.LayoutParams(600, 600).apply {
                setMargins(0, 0, 0, 40)
            }
        }

        // 2. KOTAK PESAN PERINGATAN (Estetika Rapi & Profesional)
        val card = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#1A1A1A"))
                cornerRadius = 60f
                setStroke(12, if (isEmergency) Color.parseColor("#FF6B6B") else Color.parseColor("#00D2FF"))
            }
            setPadding(80, 80, 80, 80)
            elevation = 50f
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, 
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply {
                setMargins(80, 0, 80, 0)
            }
        }

        val title = TextView(context).apply {
            text = if (isEmergency) "MATA DALAM BAHAYA!" else "VIZO SEDANG MENJAGA"
            setTextColor(if (isEmergency) Color.parseColor("#FF6B6B") else Color.parseColor("#00D2FF"))
            textSize = 28f
            gravity = Gravity.CENTER
            setTypeface(null, android.graphics.Typeface.BOLD)
        }

        val subtitle = TextView(context).apply {
            text = if (isEmergency) 
                "Jarak Anda terlalu dekat dengan layar. Mundur sekarang untuk melindungi mata." 
            else 
                "Jarak aman terdeteksi. Teruskan kebiasaan baik ini!"
            
            setTextColor(Color.WHITE)
            textSize = 18f
            gravity = Gravity.CENTER
            setPadding(0, 30, 0, 0)
            setLineSpacing(0f, 1.3f)
        }

        card.addView(title)
        card.addView(subtitle)

        layout.addView(mascotView)
        layout.addView(card)
        root.addView(layout)

        // --- SISTEM ANIMASI ---
        val floatAnim = ObjectAnimator.ofFloat(mascotView, "translationY", -40f, 40f).apply {
            duration = 1500
            repeatCount = ValueAnimator.INFINITE
            repeatMode = ValueAnimator.REVERSE
            interpolator = AccelerateDecelerateInterpolator()
            start()
        }
        animators.add(floatAnim)

        val scaleX = PropertyValuesHolder.ofFloat(View.SCALE_X, 1.0f, 1.05f)
        val scaleY = PropertyValuesHolder.ofFloat(View.SCALE_Y, 1.0f, 1.05f)
        val pulseAnim = ObjectAnimator.ofPropertyValuesHolder(card, scaleX, scaleY).apply {
            duration = if (isEmergency) 300 else 1000
            repeatCount = ValueAnimator.INFINITE
            repeatMode = ValueAnimator.REVERSE
            interpolator = AccelerateDecelerateInterpolator()
            start()
        }
        animators.add(pulseAnim)

        layout.scaleX = 0f
        layout.scaleY = 0f
        layout.alpha = 0f
        layout.animate()
            .scaleX(1f)
            .scaleY(1f)
            .alpha(1f)
            .setDuration(600)
            .setInterpolator(OvershootInterpolator(1.2f))
            .start()

        return root
    }

    fun hide() {
        if (!isShowing) return
        try {
            animators.forEach { it.cancel() }
            animators.clear()

            windowManager?.removeView(overlayView)
            overlayView = null
            isShowing = false
            isCurrentlyEmergency = false
        } catch (e: Exception) {
            Log.e("VisionSafe", "Overlay Hide Failed", e)
        }
    }
}

package com.hn.visionsafe

import android.animation.ValueAnimator
import android.content.Context
import android.graphics.*
import android.view.View
import android.view.animation.LinearInterpolator

class VizoMascotView(context: Context, private val isEmergency: Boolean) : View(context) {

    private val paint = Paint(Paint.ANTI_ALIAS_FLAG)
    private val path = Path()
    private val rect = RectF()

    private val colorMain = if (isEmergency) Color.parseColor("#FF6B6B") else Color.parseColor("#00D2FF")
    private val colorBorder = Color.parseColor("#1A1A1A")
    private val colorScreen = Color.parseColor("#F0F9FF")
    private val colorEye = Color.parseColor("#1A1A1A")

    private var pulseAnimValue = 0f

    init {
        val animator = ValueAnimator.ofFloat(0f, 1f).apply {
            duration = 1000
            repeatCount = ValueAnimator.INFINITE
            repeatMode = ValueAnimator.REVERSE
            interpolator = LinearInterpolator()
            addUpdateListener { 
                pulseAnimValue = it.animatedValue as Float
                invalidate() 
            }
        }
        animator.start()
    }

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)
        
        val w = width.toFloat()
        val h = height.toFloat()
        val cx = w / 2
        val cy = h / 2
        val size = Math.min(w, h)

        val headW = size * 0.8f
        val headH = size * 0.75f
        val headLeft = cx - headW / 2
        val headTop = cy - headH / 2

        // Draw Ears
        drawEar(canvas, cx - headW * 0.25f, headTop + size * 0.1f, -15f)
        drawEar(canvas, cx + headW * 0.25f, headTop + size * 0.1f, 15f)

        // Draw Head
        rect.set(headLeft, headTop, headLeft + headW, headTop + headH)
        paint.color = colorMain
        paint.style = Paint.Style.FILL
        // Add subtle shadow for 3D effect
        paint.setShadowLayer(15f, 5f, 10f, Color.parseColor("#80000000"))
        canvas.drawRoundRect(rect, size * 0.15f, size * 0.15f, paint)
        paint.clearShadowLayer()

        paint.color = colorBorder
        paint.style = Paint.Style.STROKE
        paint.strokeWidth = size * 0.02f
        canvas.drawRoundRect(rect, size * 0.15f, size * 0.15f, paint)

        // Top Detail Line
        paint.color = Color.argb(100, 255, 255, 255)
        paint.style = Paint.Style.FILL
        rect.set(cx - size * 0.15f, headTop + size * 0.05f, cx + size * 0.15f, headTop + size * 0.07f)
        canvas.drawRoundRect(rect, size * 0.01f, size * 0.01f, paint)

        // Screen
        val screenW = headW * 0.8f
        val screenH = headH * 0.5f
        val screenLeft = cx - screenW / 2
        val screenTop = headTop + headH * 0.2f
        rect.set(screenLeft, screenTop, screenLeft + screenW, screenTop + screenH)
        paint.color = colorScreen
        paint.style = Paint.Style.FILL
        canvas.drawRoundRect(rect, size * 0.1f, size * 0.1f, paint)
        
        paint.color = colorBorder
        paint.style = Paint.Style.STROKE
        canvas.drawRoundRect(rect, size * 0.1f, size * 0.1f, paint)

        // Whiskers
        drawWhiskers(canvas, cx - screenW/2 - size*0.02f, cy, true, size)
        drawWhiskers(canvas, cx + screenW/2 + size*0.02f, cy, false, size)

        // Eyes
        val eyeSpacing = size * 0.15f
        if (isEmergency) {
            drawXEye(canvas, cx - eyeSpacing, screenTop + screenH * 0.4f, size * 0.08f)
            drawXEye(canvas, cx + eyeSpacing, screenTop + screenH * 0.4f, size * 0.08f)
            drawMouth(canvas, cx, screenTop + screenH * 0.8f, size * 0.04f, true)
        } else {
            drawNormalEye(canvas, cx - eyeSpacing, screenTop + screenH * 0.4f, size * 0.08f)
            drawNormalEye(canvas, cx + eyeSpacing, screenTop + screenH * 0.4f, size * 0.08f)
            drawMouth(canvas, cx, screenTop + screenH * 0.8f, size * 0.04f, false)
        }

        // Screws
        drawScrew(canvas, cx - size * 0.2f, headTop + headH * 0.85f, size * 0.04f)
        drawScrew(canvas, cx + size * 0.2f, headTop + headH * 0.85f, size * 0.04f)
    }

    private fun drawEar(canvas: Canvas, ex: Float, ey: Float, degrees: Float) {
        canvas.save()
        canvas.rotate(degrees, ex, ey)
        val earW = width * 0.15f
        val earH = width * 0.2f
        rect.set(ex - earW/2, ey - earH, ex + earW/2, ey)
        paint.color = colorMain
        paint.style = Paint.Style.FILL
        canvas.drawRoundRect(rect, width * 0.05f, width * 0.05f, paint)
        
        paint.color = colorBorder
        paint.style = Paint.Style.STROKE
        canvas.drawRoundRect(rect, width * 0.05f, width * 0.05f, paint)
        
        // Inner ear
        rect.set(ex - earW*0.2f, ey - earH*0.7f, ex + earW*0.2f, ey - earH*0.2f)
        paint.color = Color.argb(120, 26, 26, 26)
        paint.style = Paint.Style.FILL
        canvas.drawRoundRect(rect, width * 0.02f, width * 0.02f, paint)
        canvas.restore()
    }

    private fun drawWhiskers(canvas: Canvas, x: Float, y: Float, isLeft: Boolean, size: Float) {
        val wLen = size * 0.1f
        paint.color = colorBorder
        paint.style = Paint.Style.STROKE
        paint.strokeWidth = size * 0.015f
        paint.strokeCap = Paint.Cap.ROUND
        
        val dir = if (isLeft) -1 else 1
        canvas.drawLine(x, y - size*0.03f, x + dir*wLen, y - size*0.05f, paint)
        canvas.drawLine(x, y, x + dir*wLen, y, paint)
        canvas.drawLine(x, y + size*0.03f, x + dir*wLen, y + size*0.05f, paint)
    }

    private fun drawXEye(canvas: Canvas, x: Float, y: Float, r: Float) {
        paint.color = colorEye
        paint.style = Paint.Style.FILL
        canvas.drawCircle(x, y, r, paint)
        paint.color = Color.WHITE
        paint.strokeWidth = r * 0.4f
        paint.strokeCap = Paint.Cap.ROUND
        val d = r * 0.4f
        canvas.drawLine(x - d, y - d, x + d, y + d, paint)
        canvas.drawLine(x + d, y - d, x - d, y + d, paint)
    }

    private fun drawNormalEye(canvas: Canvas, x: Float, y: Float, r: Float) {
        paint.color = colorEye
        paint.style = Paint.Style.FILL
        canvas.drawCircle(x, y, r, paint)
        
        // Glow Pupil
        paint.color = colorMain
        val pulseR = r * 0.4f + (pulseAnimValue * r * 0.1f)
        canvas.drawCircle(x + r*0.1f, y + r*0.1f, pulseR, paint)
        
        // Glint
        paint.color = Color.WHITE
        canvas.drawCircle(x - r*0.2f, y - r*0.2f, r * 0.2f, paint)
    }

    private fun drawMouth(canvas: Canvas, x: Float, y: Float, r: Float, isSad: Boolean) {
        paint.color = colorBorder
        paint.style = Paint.Style.STROKE
        paint.strokeWidth = r * 0.3f
        paint.strokeCap = Paint.Cap.ROUND
        paint.strokeJoin = Paint.Join.ROUND
        
        val dy = if (isSad) -r else r
        path.reset()
        path.moveTo(x - r*1.5f, y)
        path.lineTo(x, y + dy)
        path.lineTo(x + r*1.5f, y)
        canvas.drawPath(path, paint)
    }

    private fun drawScrew(canvas: Canvas, x: Float, y: Float, r: Float) {
        paint.color = colorBorder
        paint.style = Paint.Style.FILL
        canvas.drawCircle(x, y, r, paint)
        
        paint.color = Color.argb(100, 255, 255, 255)
        paint.style = Paint.Style.STROKE
        paint.strokeWidth = r * 0.1f
        canvas.drawCircle(x, y, r, paint)
        
        paint.color = colorMain
        paint.style = Paint.Style.FILL
        canvas.drawCircle(x, y, r * 0.4f, paint)
    }
}

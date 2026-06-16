package com.hn.visionsafe

import android.content.Context
import android.util.Log
import androidx.camera.core.CameraSelector
import androidx.camera.core.ImageAnalysis
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.core.content.ContextCompat
import java.util.concurrent.ExecutorService

/**
 * Manager untuk urusan CameraX (Lifecycle & Analysis Pipeline).
 * File: VisionCameraManager.kt (< 150 lines)
 */
class VisionCameraManager(
    private val context: Context,
    private val lifecycleOwner: androidx.lifecycle.LifecycleOwner,
    private val cameraExecutor: ExecutorService,
    private val onImageAnalyzed: (androidx.camera.core.ImageProxy) -> Unit
) {

    private var cameraProvider: ProcessCameraProvider? = null
    private var isStarted = false

    fun start() {
        if (isStarted) return
        val cameraProviderFuture = ProcessCameraProvider.getInstance(context)
        cameraProviderFuture.addListener({
            cameraProvider = cameraProviderFuture.get()
            bindAnalysis()
            isStarted = true
        }, ContextCompat.getMainExecutor(context))
    }

    fun isCameraActive(): Boolean = isStarted

    private fun bindAnalysis() {
        val imageAnalysis = ImageAnalysis.Builder()
            .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
            .setOutputImageFormat(ImageAnalysis.OUTPUT_IMAGE_FORMAT_RGBA_8888)
            .build()

        imageAnalysis.setAnalyzer(cameraExecutor) { imageProxy ->
            onImageAnalyzed(imageProxy)
        }

        try {
            cameraProvider?.unbindAll()
            val cameraSelector = CameraSelector.DEFAULT_FRONT_CAMERA
            cameraProvider?.bindToLifecycle(lifecycleOwner, cameraSelector, imageAnalysis)
            Log.d("VisionSafe", "CameraX Analysis Bound Successfully")
        } catch (e: Exception) {
            Log.e("VisionSafe", "Camera Binding Failed", e)
        }
    }

    fun stop() {
        cameraProvider?.unbindAll()
        isStarted = false
    }
}

package com.hn.visionsafe

import android.content.Context
import android.util.Log
import androidx.camera.core.CameraSelector
import androidx.camera.core.ImageAnalysis
import androidx.camera.lifecycle.ProcessCameraProvider
import android.hardware.camera2.CameraManager
import java.util.concurrent.ExecutorService

/**
 * Manager untuk urusan CameraX (Lifecycle & Analysis Pipeline).
 * File: VisionCameraManager.kt (< 150 lines)
 */
class VisionCameraManager(
    private val context: Context,
    private val lifecycleOwner: androidx.lifecycle.LifecycleOwner,
    private val cameraExecutor: ExecutorService,
    private val onCameraError: (String) -> Unit,
    private val onImageAnalyzed: (androidx.camera.core.ImageProxy) -> Unit
) {

    private var cameraProvider: ProcessCameraProvider? = null
    private var isStarted = false
    private val sysCameraManager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager
    
    private val availabilityCallback = object : CameraManager.AvailabilityCallback() {
        override fun onCameraAvailable(cameraId: String) {
            super.onCameraAvailable(cameraId)
            Log.d("VisionSafe", "Camera $cameraId is now available. Restarting analysis...")
            if (isStarted) {
                // If it was supposed to be running, re-bind
                bindAnalysis()
            }
        }
        
        override fun onCameraUnavailable(cameraId: String) {
            super.onCameraUnavailable(cameraId)
            Log.w("VisionSafe", "Camera $cameraId is unavailable (taken by other app?)")
        }
    }

    fun start() {
        if (isStarted) return
        val cameraProviderFuture = ProcessCameraProvider.getInstance(context)
        cameraProviderFuture.addListener({
            cameraProvider = cameraProviderFuture.get()
            bindAnalysis()
            isStarted = true
            sysCameraManager.registerAvailabilityCallback(availabilityCallback, null)
        }, androidx.core.content.ContextCompat.getMainExecutor(context))
    }

    fun isCameraActive(): Boolean = isStarted

    private fun bindAnalysis() {
        val resolutionSelector = androidx.camera.core.resolutionselector.ResolutionSelector.Builder()
            .setResolutionStrategy(androidx.camera.core.resolutionselector.ResolutionStrategy(
                android.util.Size(480, 640), 
                androidx.camera.core.resolutionselector.ResolutionStrategy.FALLBACK_RULE_CLOSEST_LOWER
            ))
            .build()

        val imageAnalysis = ImageAnalysis.Builder()
            .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
            .setResolutionSelector(resolutionSelector)
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
        } catch (e: SecurityException) {
            Log.e("VisionSafe", "Camera Permission Revoked!", e)
            onCameraError("PERMISSION_REVOKED")
        } catch (e: Exception) {
            Log.e("VisionSafe", "Camera Binding Failed", e)
            onCameraError("BIND_FAILED")
        }
    }

    fun stop() {
        cameraProvider?.unbindAll()
        isStarted = false
        try {
            sysCameraManager.unregisterAvailabilityCallback(availabilityCallback)
        } catch (e: Exception) {
            Log.e("VisionSafe", "Error unregistering camera callback", e)
        }
    }
}

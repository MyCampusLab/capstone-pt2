package com.irsyad.visionsafe.visionsafe

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Matrix
import android.util.Log
import androidx.camera.core.ImageProxy
import com.google.mediapipe.framework.image.BitmapImageBuilder
import com.google.mediapipe.tasks.components.containers.Category
import com.google.mediapipe.tasks.vision.core.RunningMode
import com.google.mediapipe.tasks.vision.facelandmarker.FaceLandmarker
import java.nio.ByteBuffer
import kotlin.math.pow
import kotlin.math.sqrt
import kotlin.math.*

/**
 * Analyzer Elite VisionSafe (AI Prof Standard).
 * Menggunakan 3D Face Mesh, Geometri Euclid, dan Low-Pass Filter.
 */
class VisionAnalyzer(private val context: Context) {

    private var faceLandmarker: FaceLandmarker? = null
    private var reusableBitmap: Bitmap? = null
    
    // Konstanta Biometrik & Optik
    private val REAL_IPD_CM = 6.3 // Rata-rata Inter-Pupillary Distance (IPD)
    private val FOCAL_LENGTH_PIXELS = 820.0 // Hasil kalibrasi sensor kamera standar
    
    // Smoothing (Low-Pass Filter) untuk menghindari jitter
    private var lastDistance = 0.0
    private val SMOOTHING_FACTOR = 0.3

    init {
        setupFaceLandmarker()
    }

    private fun setupFaceLandmarker() {
        try {
            val baseOptions = com.google.mediapipe.tasks.core.BaseOptions.builder()
                .setModelAssetPath("face_landmarker.task")
                .setDelegate(com.google.mediapipe.tasks.core.Delegate.GPU)
                .build()
            
            val options = FaceLandmarker.FaceLandmarkerOptions.builder()
                .setBaseOptions(baseOptions)
                .setRunningMode(RunningMode.IMAGE)
                .setNumFaces(1)
                .setOutputFaceBlendshapes(true) // Aktifkan untuk Deteksi Kedipan (Blink)
                .build()
            
            faceLandmarker = FaceLandmarker.createFromOptions(context, options)
        } catch (e: Exception) {
            Log.e("VisionSafe", "AI Engine Init Failed. Falling back to CPU.", e)
            reinitCpu()
        }
    }

    private fun reinitCpu() {
        try {
            val baseOptions = com.google.mediapipe.tasks.core.BaseOptions.builder()
                .setModelAssetPath("face_landmarker.task")
                .setDelegate(com.google.mediapipe.tasks.core.Delegate.CPU)
                .build()
            val options = FaceLandmarker.FaceLandmarkerOptions.builder()
                .setBaseOptions(baseOptions)
                .setRunningMode(RunningMode.IMAGE)
                .setNumFaces(1)
                .setOutputFaceBlendshapes(true)
                .build()
            faceLandmarker = FaceLandmarker.createFromOptions(context, options)
        } catch (e: Exception) {
            Log.e("VisionSafe", "Critical AI Error", e)
        }
    }

    fun analyze(imageProxy: ImageProxy): AnalysisResult? {
        if (faceLandmarker == null) return null

        val bitmap = imageProxy.toBitmapOptimized()
        val mpImage = BitmapImageBuilder(bitmap).build()
        val result = faceLandmarker?.detect(mpImage)

        if (result != null && result.faceLandmarks().isNotEmpty()) {
            val landmarks = result.faceLandmarks()[0]
            
            // 1. Ambil koordinat mata (L: 33, R: 263) dalam ruang 3D (X, Y, Z)
            val leftEye = landmarks[33]
            val rightEye = landmarks[263]

            // 2. Kalkulasi Euclidean Distance 3D
            val dx = (rightEye.x() - leftEye.x()) * bitmap.width
            val dy = (rightEye.y() - leftEye.y()) * bitmap.height
            val dz = (rightEye.z() - leftEye.z()) * bitmap.width 

            val pixelIpd3d = sqrt(dx.pow(2) + dy.pow(2) + dz.pow(2))
            
            // 3. Konversi ke Jarak Nyata
            val rawDistance = (REAL_IPD_CM * FOCAL_LENGTH_PIXELS) / pixelIpd3d
            
            // 4. Smoothing Filter
            if (lastDistance == 0.0) lastDistance = rawDistance
            lastDistance = (rawDistance * SMOOTHING_FACTOR) + (lastDistance * (1.0 - SMOOTHING_FACTOR))
            
            // 5. Deteksi Kedipan & Pergerakan Mata via Blendshapes
            var isBlinking = false
            var eyeLookInLeft = 0f
            var eyeLookOutLeft = 0f
            var eyeLookInRight = 0f
            var eyeLookOutRight = 0f
            var eyeLookUpLeft = 0f
            var eyeLookUpRight = 0f
            var eyeLookDownLeft = 0f
            var eyeLookDownRight = 0f
            var eyeSquintLeft = 0f
            var eyeSquintRight = 0f

            val blendshapesOptional = result.faceBlendshapes()
            if (blendshapesOptional.isPresent) {
                val blendshapesList = blendshapesOptional.get()
                if (blendshapesList.isNotEmpty()) {
                    val firstFaceCategories = blendshapesList[0] as? List<Category>
                    if (firstFaceCategories != null) {
                        for (category in firstFaceCategories) {
                            val name = category.categoryName()
                            val score = category.score()
                            
                            when (name) {
                                "eyeBlinkLeft" -> { if (score > 0.35f) isBlinking = true }
                                "eyeBlinkRight" -> { if (score > 0.35f) isBlinking = true }
                                "eyeLookInLeft" -> eyeLookInLeft = score
                                "eyeLookOutLeft" -> eyeLookOutLeft = score
                                "eyeLookInRight" -> eyeLookInRight = score
                                "eyeLookOutRight" -> eyeLookOutRight = score
                                "eyeLookUpLeft" -> eyeLookUpLeft = score
                                "eyeLookUpRight" -> eyeLookUpRight = score
                                "eyeLookDownLeft" -> eyeLookDownLeft = score
                                "eyeLookDownRight" -> eyeLookDownRight = score
                                "eyeSquintLeft" -> eyeSquintLeft = score
                                "eyeSquintRight" -> eyeSquintRight = score
                            }
                        }
                    }
                }
            }

            // Kalkulasi skor arah lirikan mata
            val lookLeft = (eyeLookOutLeft + eyeLookInRight) / 2f
            val lookRight = (eyeLookInLeft + eyeLookOutRight) / 2f
            val lookUp = (eyeLookUpLeft + eyeLookUpRight) / 2f
            val lookDown = (eyeLookDownLeft + eyeLookDownRight) / 2f
            val squint = (eyeSquintLeft + eyeSquintRight) / 2f

            // Klasifikasi arah dominan lirikan
            var eyeMovement = "center"
            var maxScore = 0.20f // Batas minimal 20% keyakinan
            
            if (lookLeft > maxScore) {
                eyeMovement = "left"
                maxScore = lookLeft
            }
            if (lookRight > maxScore) {
                eyeMovement = "right"
                maxScore = lookRight
            }
            if (lookUp > maxScore) {
                eyeMovement = "up"
                maxScore = lookUp
            }
            if (lookDown > maxScore) {
                eyeMovement = "down"
                maxScore = lookDown
            }

            val isSquinting = squint > 0.35f

            return AnalysisResult(lastDistance, isBlinking, eyeMovement, isSquinting)
        }
        return null
    }

    data class AnalysisResult(
        val distance: Double, 
        val isBlinking: Boolean,
        val eyeMovement: String,
        val isSquinting: Boolean
    )

    private fun ImageProxy.toBitmapOptimized(): Bitmap {
        val buffer = planes[0].buffer
        buffer.rewind()
        
        if (reusableBitmap == null || reusableBitmap!!.width != width || reusableBitmap!!.height != height) {
            reusableBitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
        }
        
        reusableBitmap!!.copyPixelsFromBuffer(buffer)
        
        if (imageInfo.rotationDegrees != 0) {
            val matrix = Matrix().apply { 
                postRotate(imageInfo.rotationDegrees.toFloat())
                postScale(-1f, 1f, width / 2f, height / 2f)
            }
            return Bitmap.createBitmap(reusableBitmap!!, 0, 0, width, height, matrix, true)
        }
        return reusableBitmap!!
    }

    fun close() {
        faceLandmarker?.close()
        reusableBitmap = null
    }
}

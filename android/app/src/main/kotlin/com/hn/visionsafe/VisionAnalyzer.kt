package com.hn.visionsafe

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
    // Rata-rata IPD default (5.5 cm). Akan dikalibrasi otomatis secara Real-Time oleh AI!
    private var smoothedPhysicalIpdCm = 5.5 
    
    // Hardware-Agnostic Auto-Calibration (Mengatasi akurasi di berbagai tipe HP)
    private var dynamicFocalLengthPixels = 820.0 
    private var sensorActiveWidthPixels = 1080.0

    // Smoothing (Low-Pass Filter) untuk menghindari jitter
    private var lastDistance = 0.0
    private val SMOOTHING_FACTOR = 0.25 // Lebih lambat dan stabil

    init {
        calculateHardwareOptics()
        Thread { setupFaceLandmarker() }.start()
    }

    private fun calculateHardwareOptics() {
        try {
            val cameraManager = context.getSystemService(Context.CAMERA_SERVICE) as android.hardware.camera2.CameraManager
            val cameraIds = cameraManager.cameraIdList
            for (id in cameraIds) {
                val chars = cameraManager.getCameraCharacteristics(id)
                val facing = chars.get(android.hardware.camera2.CameraCharacteristics.LENS_FACING)
                if (facing == android.hardware.camera2.CameraCharacteristics.LENS_FACING_FRONT) {
                    val focalLengths = chars.get(android.hardware.camera2.CameraCharacteristics.LENS_INFO_AVAILABLE_FOCAL_LENGTHS)
                    val sensorSize = chars.get(android.hardware.camera2.CameraCharacteristics.SENSOR_INFO_PHYSICAL_SIZE)
                    val activeArray = chars.get(android.hardware.camera2.CameraCharacteristics.SENSOR_INFO_ACTIVE_ARRAY_SIZE)
                    
                    if (focalLengths != null && focalLengths.isNotEmpty() && sensorSize != null && activeArray != null) {
                        val fMm = focalLengths[0]
                        val sensorWidthMm = sensorSize.width
                        // BUG FIX: Selalu gunakan sisi terpanjang sensor agar rotasi HP tidak merusak rasio matematis
                        sensorActiveWidthPixels = max(activeArray.width(), activeArray.height()).toDouble()
                        
                        // Menghitung focal length asli lensa hp (dalam pixel) pada resolusi penuh sensor
                        dynamicFocalLengthPixels = (fMm * sensorActiveWidthPixels) / sensorWidthMm
                        Log.i("VisionSafe", "HARDWARE OPTICS CALIBRATED: Focal Length=${dynamicFocalLengthPixels}px, Sensor Width=${sensorActiveWidthPixels}px")
                        break
                    }
                }
            }
        } catch (e: Exception) {
            Log.e("VisionSafe", "Gagal membaca hardware kamera, menggunakan default fallback.", e)
        }
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

            // 2. Kalkulasi Euclidean Distance 3D antar Pupil (IPD Pixel)
            val dx = (rightEye.x() - leftEye.x()) * bitmap.width
            val dy = (rightEye.y() - leftEye.y()) * bitmap.height
            val dz = (rightEye.z() - leftEye.z()) * bitmap.width 

            val pixelIpd3d = sqrt(dx.pow(2) + dy.pow(2) + dz.pow(2))
            
            // 3. AUTO-CALIBRATION MENGGUNAKAN DIAMETER IRIS (KONSTANTA BIOLOGIS MANUSIA)
            // Fakta Medis Global: Diameter Iris manusia (bayi hingga dewasa) selalu konstan di angka ~1.17 cm.
            // Kita menggunakan Iris untuk melacak proporsi wajah asli pengguna, lalu menghitung IPD aslinya!
            if (landmarks.size >= 478) {
                // Left Iris Horizontal Edges (469 - 471)
                val lIrisDx = (landmarks[469].x() - landmarks[471].x()) * bitmap.width
                val lIrisDy = (landmarks[469].y() - landmarks[471].y()) * bitmap.height
                val pixelIrisLeft = sqrt(lIrisDx.pow(2) + lIrisDy.pow(2))

                // Right Iris Horizontal Edges (474 - 476)
                val rIrisDx = (landmarks[474].x() - landmarks[476].x()) * bitmap.width
                val rIrisDy = (landmarks[474].y() - landmarks[476].y()) * bitmap.height
                val pixelIrisRight = sqrt(rIrisDx.pow(2) + rIrisDy.pow(2))

                val avgPixelIris = (pixelIrisLeft + pixelIrisRight) / 2.0
                
                if (avgPixelIris > 2.0) { // Cegah noise ekstrim saat blur
                    val instantIpdCm = (pixelIpd3d / avgPixelIris) * 1.17
                    
                    // Validasi kewajaran IPD Manusia (4.0 cm Balita - 7.5 cm Dewasa Besar)
                    if (instantIpdCm in 4.0..7.5) {
                        // Slow-Adapt IPD: Proporsi wajah tidak berubah cepat, jadi kita pakai smoothing 98%
                        smoothedPhysicalIpdCm = (instantIpdCm * 0.02) + (smoothedPhysicalIpdCm * 0.98)
                    }
                }
            }

            // 4. Validasi Head Pose (Menoleh Ekstrem)
            val headTurnRatio = abs(dz) / pixelIpd3d
            if (headTurnRatio > 0.55) {
                // BUG FIX: Mengembalikan null jika wajah terlalu miring agar sistem tidak "stuck/freeze"
                // pada jarak terakhir. Ini memungkinkan overlay peringatan untuk hilang (dismiss).
                return null
            }
            
            // 5. Konversi ke Jarak Nyata (Pinhole Camera Model dengan Hardware-Agnostic Optics)
            // BUG FIX (Audit Mode): Menangani rotasi layar (Portrait/Landscape) dan rasio crop CameraX.
            // Membandingkan dimensi maksimal (max_dim) menjamin keakuratan rasio tanpa terpengaruh orientasi.
            val maxBitmapDim = max(bitmap.width, bitmap.height).toDouble()
            val effectiveFocalLength = dynamicFocalLengthPixels * (maxBitmapDim / sensorActiveWidthPixels)
            val rawDistance = (smoothedPhysicalIpdCm * effectiveFocalLength) / pixelIpd3d
            
            // 6. Smart Snap Filter (Low-Pass Filter)
            if (lastDistance == 0.0 || abs(rawDistance - lastDistance) > 15.0) {
                lastDistance = rawDistance
            } else {
                lastDistance = (rawDistance * SMOOTHING_FACTOR) + (lastDistance * (1.0 - SMOOTHING_FACTOR))
            }
            
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

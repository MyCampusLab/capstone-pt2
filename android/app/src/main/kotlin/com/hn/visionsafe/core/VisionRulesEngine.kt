package com.hn.visionsafe.core

import android.os.Handler
import android.os.Looper
import android.util.Log
import com.hn.visionsafe.BlurOverlayManager
import com.hn.visionsafe.TelemetryDatabaseHelper
import com.hn.visionsafe.VisionAnalyzer
import android.content.Context
import java.net.HttpURLConnection
import java.net.URL
import org.json.JSONObject
import org.json.JSONArray
import kotlin.concurrent.thread

/**
 * VisionRulesEngine: Ekstraksi Business Logic dari VisionService.
 * Berpikir Berkembang Maju & Reusable (SOLID Principle: Single Responsibility).
 * Kelas ini bertanggung jawab atas:
 * 1. Aturan 20-20-20 (Screen Time Tracking)
 * 2. Logika Throttling Database (Autonom)
 * 3. Logika Triggering Layar Darurat (Overlay)
 * 4. Menyambungkan Telemetri ke Flutter
 */
class VisionRulesEngine(
    private val overlayManager: BlurOverlayManager,
    private val dbHelper: TelemetryDatabaseHelper,
    private val context: Context,
    private val sendTelemetryCallback: (distance: Double, isViolation: Boolean, isBlinking: Boolean, eyeMovement: String, isSquinting: Boolean, isLowLight: Boolean) -> Unit
) {

    private val handler = Handler(Looper.getMainLooper())

    // 20-20-20 Rule Tracker
    private var screenTimeSeconds = 0L
    private var lastWarningTime = 0L
    private val SCREEN_TIME_LIMIT = 1200L // 20 Menit

    // Throttle untuk SQLite Native
    private var lastDbSaveTime = 0L
    private var lastLowLightWarningTime = 0L

    // Violation State
    private var violationStartTime = 0L
    private var warningShown = false
    var violationThresholdCm = 35.0
    private var WARNING_DELAY_MS = 1500L
    private var EMERGENCY_DELAY_MS = 6500L
    
    init {
        applyGamificationBuffs()
    }

    fun applyGamificationBuffs() {
        val sharedPref = context.getSharedPreferences("VisionSafePrefs", Context.MODE_PRIVATE)
        val equippedSticker = sharedPref.getString("equipped_sticker", null)
        
        WARNING_DELAY_MS = 1500L
        EMERGENCY_DELAY_MS = 6500L
        
        if (equippedSticker == "s2" || equippedSticker == "s8") {
            WARNING_DELAY_MS += 2000L // +2 Detik
            EMERGENCY_DELAY_MS += 2000L
        }
        if (equippedSticker == "s5" || equippedSticker == "s8") {
            WARNING_DELAY_MS += 3000L // +3 Detik
            EMERGENCY_DELAY_MS += 3000L
        }
    }
    
    var isPowerSaveActive = false
    var isDeviceFlat = false

    // Camera Block Bypass Detection
    private var noFaceStartTime = 0L
    private val NO_FACE_LIMIT_MS = 120_000L // 2 Menit tanpa wajah = Asumsi kamera diblokir/ditutup

    // Headless Sync
    private var lastHeadlessSyncTime = 0L
    private val HEADLESS_SYNC_INTERVAL_MS = 900_000L // 15 Menit

    /**
     * Memproses Screen Time (Aturan 20-20-20)
     */
    fun processScreenTime(samplingRateMs: Long) {
        val step = (samplingRateMs / 1000)
        screenTimeSeconds += step
        if (screenTimeSeconds - lastWarningTime >= SCREEN_TIME_LIMIT) {
            lastWarningTime = screenTimeSeconds
            handler.post {
                overlayManager.showWarning(
                    "WAKTUNYA ISTIRAHAT (20-20-20)", 
                    "Layar sudah ditatap selama 20 menit. Alihkan pandangan sejauh 6 meter selama 20 detik.",
                    3000
                )
            }
        }
    }

    /**
     * Menangani hasil dari AI VisionAnalyzer
     */
    fun handleResult(result: VisionAnalyzer.AnalysisResult?, currentTime: Long) {
        if (result == null) {
            handleNoFaceDetected(currentTime)
            return
        }
        
        noFaceStartTime = 0L // Wajah terdeteksi, reset timer bypass

        val distance = result.distance
        val isViolation = distance < violationThresholdCm

        // 1. Simpan ke SQLite Native secara Otonom (Anti-Doze Mode)
        saveToDatabaseAutonomously(result, isViolation, distance, currentTime)

        // 2. Kirim Stream ke Flutter (UI/Dashboard)
        sendTelemetryCallback(distance, isViolation, result.isBlinking, result.eyeMovement, result.isSquinting, result.isLowLight)

        // 3. Logika Peringatan Bahaya (Overlay)
        processOverlayLogic(result, isViolation, currentTime)
    }

    private fun saveToDatabaseAutonomously(result: VisionAnalyzer.AnalysisResult, isViolation: Boolean, distance: Double, currentTime: Long) {
        var shouldSave = false
        if (isViolation) {
            // Pelanggaran: Batasi 1 log per 15 detik agar DB tidak bengkak
            if (currentTime - lastDbSaveTime >= 15000) shouldSave = true
        } else {
            // Heartbeat normal: 1 log per 60 detik
            if (currentTime - lastDbSaveTime >= 60000) shouldSave = true
        }

        if (shouldSave) {
            dbHelper.insertLog(
                distance = distance,
                isViolation = isViolation,
                isBlinking = result.isBlinking,
                eyeMovement = result.eyeMovement,
                isSquinting = result.isSquinting,
                isPowerSave = isPowerSaveActive,
                isLowLight = result.isLowLight,
                timestamp = currentTime
            )
            lastDbSaveTime = currentTime
            Log.d("VisionSafe", "Native DB: Tersimpan (Dist: ${distance.toInt()}cm, Viol: $isViolation)")
        }

        // Jalankan Headless Sync jika sudah 15 Menit
        if (currentTime - lastHeadlessSyncTime >= HEADLESS_SYNC_INTERVAL_MS) {
            lastHeadlessSyncTime = currentTime
            performHeadlessSync()
        }
    }

    private fun processOverlayLogic(result: VisionAnalyzer.AnalysisResult, isViolation: Boolean, currentTime: Long) {
        if (isViolation) {
            if (violationStartTime == 0L) {
                violationStartTime = currentTime
                warningShown = false
            }
            
            val violationDuration = currentTime - violationStartTime
            
            // Progressive Intervention: Warning first
            if (violationDuration > WARNING_DELAY_MS && violationDuration <= EMERGENCY_DELAY_MS) {
                if (!warningShown) {
                    warningShown = true
                    val secondsLeft = ((EMERGENCY_DELAY_MS - violationDuration) / 1000).toInt()
                    handler.post {
                        overlayManager.showWarning(
                            "TERLALU DEKAT!", 
                            "Mundur sekarang. Layar akan dikunci dalam 5 detik.",
                            4500
                        )
                    }
                }
            } 
            // Full Emergency
            else if (violationDuration > EMERGENCY_DELAY_MS) {
                Log.w("VisionSafe", "!!! CRITICAL DISTANCE !!! Showing Emergency.")
                updateOverlay(show = true, isEmergency = true)
            }
        } else {
            resetViolationState()
            
            // Low Light Warning
            if (result.isLowLight && (currentTime - lastLowLightWarningTime > 30000)) {
                lastLowLightWarningTime = currentTime
                handler.post {
                    overlayManager.showWarning(
                        "PENCAHAYAAN BURUK", 
                        "Ruangan terlalu gelap! Bermain HP di tempat gelap sangat berbahaya bagi matamu.",
                        4000
                    )
                }
            }
        }
    }

    private fun resetViolationState() {
        violationStartTime = 0L
        warningShown = false
        updateOverlay(show = false, isEmergency = false)
    }

    private fun handleNoFaceDetected(currentTime: Long) {
        if (isDeviceFlat) {
            resetViolationState()
            noFaceStartTime = 0L
            return
        }

        if (noFaceStartTime == 0L) noFaceStartTime = currentTime
        
        val noFaceDuration = currentTime - noFaceStartTime
        if (noFaceDuration > NO_FACE_LIMIT_MS) {
            Log.w("VisionSafe", "CAMERA BLOCKED! No face detected for 2 mins.")
            
            // Simpan log ke DB sebagai pelanggaran kritis (blocked)
            dbHelper.insertLog(
                distance = 0.0, // 0 = Unknown/Blocked
                isViolation = true,
                isBlinking = false,
                eyeMovement = "BLOCKED",
                isSquinting = false,
                isPowerSave = isPowerSaveActive,
                isLowLight = false,
                timestamp = currentTime
            )
            
            // Kunci layar!
            handler.post {
                overlayManager.showWarning(
                    "KAMERA TERHALANG", 
                    "Sistem tidak mendeteksi wajah Anda selama 2 menit. Lepaskan penutup kamera atau posisikan wajah dengan benar di depan layar.",
                    5000
                )
                // Panggil emergency lock
                overlayManager.show(true)
            }
            
            // Reset timer agar log tidak membanjiri DB setiap frame,
            // tapi overlay akan terus mengunci karena isEmergency = true.
            // Untuk mempermudah recovery, beri jeda sebelum log lagi
            noFaceStartTime = currentTime - (NO_FACE_LIMIT_MS - 15000L) // Log lagi dalam 15 detik jika masih diblok
        } else {
            resetViolationState()
        }
    }

    private fun updateOverlay(show: Boolean, isEmergency: Boolean) {
        handler.post {
            if (show) overlayManager.show(isEmergency) else overlayManager.hide()
        }
    }

    private fun performHeadlessSync() {
        thread {
            try {
                val sharedPref = context.getSharedPreferences("VisionSafePrefs", Context.MODE_PRIVATE)
                val urlStr = sharedPref.getString("supabase_url", null)
                val anonKey = sharedPref.getString("supabase_anon_key", null)
                val jwt = sharedPref.getString("supabase_jwt", null)
                val uuid = sharedPref.getString("supabase_uuid", null)

                if (urlStr == null || jwt == null || uuid == null) return@thread

                val logs = dbHelper.getUnsyncedLogs(100)
                if (logs.isEmpty()) return@thread

                val jsonArray = JSONArray()
                val idsToDelete = mutableListOf<Int>()
                
                for (log in logs) {
                    val jsonObj = JSONObject()
                    jsonObj.put("user_id", uuid)
                    jsonObj.put("distance_cm", log["distance"])
                    jsonObj.put("is_violation", log["isViolation"] as? Boolean ?: false)
                    jsonObj.put("device_info", "Android Background Service")
                    jsonObj.put("is_blinking", log["isBlinking"] as? Boolean ?: false)
                    jsonObj.put("eye_movement", log["eyeMovement"] as? String ?: "center")
                    jsonObj.put("is_squinting", log["isSquinting"] as? Boolean ?: false)
                    jsonObj.put("is_power_save", log["isPowerSaveActive"] as? Boolean ?: false)
                    jsonObj.put("is_low_light", log["isLowLight"] as? Boolean ?: false)
                    
                    val timestamp = log["timestamp"] as? Long ?: System.currentTimeMillis()
                    jsonObj.put("created_at", java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", java.util.Locale.US).apply {
                        timeZone = java.util.TimeZone.getTimeZone("UTC")
                    }.format(java.util.Date(timestamp)))
                    
                    jsonArray.put(jsonObj)
                    val id = log["native_id"] as? Int
                    if (id != null) {
                        idsToDelete.add(id)
                    }
                }

                val url = URL("$urlStr/rest/v1/telemetry_logs")
                val conn = url.openConnection() as HttpURLConnection
                conn.requestMethod = "POST"
                conn.setRequestProperty("apikey", anonKey)
                conn.setRequestProperty("Authorization", "Bearer $jwt")
                conn.setRequestProperty("Content-Type", "application/json")
                conn.setRequestProperty("Prefer", "return=minimal")
                conn.doOutput = true

                conn.outputStream.use { os ->
                    val input = jsonArray.toString().toByteArray(Charsets.UTF_8)
                    os.write(input, 0, input.size)
                }

                val responseCode = conn.responseCode
                if (responseCode in 200..299) {
                    Log.i("VisionSafe", "Headless Sync Berhasil: \${idsToDelete.size} logs")
                    dbHelper.deleteLogs(idsToDelete)
                } else if (responseCode == 401 || responseCode == 403) {
                    val refreshToken = sharedPref.getString("supabase_refresh_token", null)
                    if (!refreshToken.isNullOrEmpty() && refreshTokenNatively(urlStr, anonKey ?: "", refreshToken!!)) {
                        Log.i("VisionSafe", "Token refreshed natively. Will sync on next cycle.")
                    } else {
                        Log.e("VisionSafe", "Headless Sync Gagal Auth (Code $responseCode). Refresh token failed.")
                    }
                } else {
                    Log.e("VisionSafe", "Headless Sync Gagal: Code $responseCode")
                }
                conn.disconnect()
            } catch (e: Exception) {
                Log.e("VisionSafe", "Headless Sync Error", e)
            }
        }
    }

    private fun refreshTokenNatively(urlStr: String, anonKey: String, refreshToken: String): Boolean {
        try {
            val url = URL("$urlStr/auth/v1/token?grant_type=refresh_token")
            val conn = url.openConnection() as HttpURLConnection
            conn.requestMethod = "POST"
            conn.setRequestProperty("apikey", anonKey)
            conn.setRequestProperty("Content-Type", "application/json")
            conn.doOutput = true

            val jsonInput = JSONObject().apply { put("refresh_token", refreshToken) }
            conn.outputStream.use { os ->
                val input = jsonInput.toString().toByteArray(Charsets.UTF_8)
                os.write(input, 0, input.size)
            }

            if (conn.responseCode in 200..299) {
                val responseString = conn.inputStream.bufferedReader().use { it.readText() }
                val responseJson = JSONObject(responseString)
                val newJwt = responseJson.optString("access_token")
                val newRefreshToken = responseJson.optString("refresh_token")
                
                if (newJwt.isNotEmpty() && newRefreshToken.isNotEmpty()) {
                    val sharedPref = context.getSharedPreferences("VisionSafePrefs", Context.MODE_PRIVATE)
                    sharedPref.edit()
                        .putString("supabase_jwt", newJwt)
                        .putString("supabase_refresh_token", newRefreshToken)
                        .apply()
                    return true
                }
            }
        } catch(e: Exception) {
            Log.e("VisionSafe", "Failed to refresh token natively", e)
        }
        return false
    }
}

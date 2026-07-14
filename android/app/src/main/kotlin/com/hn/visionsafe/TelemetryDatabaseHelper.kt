package com.hn.visionsafe

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper

class TelemetryDatabaseHelper(context: Context) : SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION) {

    companion object {
        private const val DATABASE_VERSION = 2
        private const val DATABASE_NAME = "telemetry_logs_native.db"
        const val TABLE_NAME = "telemetry"
        const val COLUMN_ID = "id"
        const val COLUMN_DISTANCE = "distance"
        const val COLUMN_IS_VIOLATION = "isViolation"
        const val COLUMN_IS_BLINKING = "isBlinking"
        const val COLUMN_EYE_MOVEMENT = "eyeMovement"
        const val COLUMN_IS_SQUINTING = "isSquinting"
        const val COLUMN_IS_POWER_SAVE = "isPowerSaveActive"
        const val COLUMN_IS_LOW_LIGHT = "isLowLight"
        const val COLUMN_TIMESTAMP = "timestamp"
    }

    override fun onCreate(db: SQLiteDatabase) {
        val createTable = ("CREATE TABLE " + TABLE_NAME + "("
                + COLUMN_ID + " INTEGER PRIMARY KEY AUTOINCREMENT,"
                + COLUMN_DISTANCE + " REAL,"
                + COLUMN_IS_VIOLATION + " INTEGER,"
                + COLUMN_IS_BLINKING + " INTEGER,"
                + COLUMN_EYE_MOVEMENT + " TEXT,"
                + COLUMN_IS_SQUINTING + " INTEGER,"
                + COLUMN_IS_POWER_SAVE + " INTEGER,"
                + COLUMN_IS_LOW_LIGHT + " INTEGER,"
                + COLUMN_TIMESTAMP + " INTEGER" + ")")
        db.execSQL(createTable)
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        db.execSQL("DROP TABLE IF EXISTS " + TABLE_NAME)
        onCreate(db)
    }

    fun insertLog(
        distance: Double,
        isViolation: Boolean,
        isBlinking: Boolean,
        eyeMovement: String,
        isSquinting: Boolean,
        isPowerSave: Boolean,
        isLowLight: Boolean,
        timestamp: Long
    ) {
        // Mencegah Database Bloat: Batasi maksimal 5000 records
        val db = this.writableDatabase
        
        val countCursor = db.rawQuery("SELECT COUNT(*) FROM $TABLE_NAME", null)
        if (countCursor.moveToFirst()) {
            val count = countCursor.getInt(0)
            if (count > 5000) {
                // Hapus 1000 record paling lama
                db.execSQL("DELETE FROM $TABLE_NAME WHERE $COLUMN_ID IN (SELECT $COLUMN_ID FROM $TABLE_NAME ORDER BY $COLUMN_TIMESTAMP ASC LIMIT 1000)")
            }
        }
        countCursor.close()

        val values = ContentValues().apply {
            put(COLUMN_DISTANCE, distance)
            put(COLUMN_IS_VIOLATION, if (isViolation) 1 else 0)
            put(COLUMN_IS_BLINKING, if (isBlinking) 1 else 0)
            put(COLUMN_EYE_MOVEMENT, eyeMovement)
            put(COLUMN_IS_SQUINTING, if (isSquinting) 1 else 0)
            put(COLUMN_IS_POWER_SAVE, if (isPowerSave) 1 else 0)
            put(COLUMN_IS_LOW_LIGHT, if (isLowLight) 1 else 0)
            put(COLUMN_TIMESTAMP, timestamp)
        }
        db.insert(TABLE_NAME, null, values)
        db.close()
    }

    fun getUnsyncedLogs(limit: Int = 100): List<Map<String, Any>> {
        val list = mutableListOf<Map<String, Any>>()
        val db = this.readableDatabase
        val cursor = db.rawQuery("SELECT * FROM $TABLE_NAME ORDER BY $COLUMN_TIMESTAMP ASC LIMIT $limit", null)

        if (cursor.moveToFirst()) {
            do {
                val map = mutableMapOf<String, Any>()
                map["native_id"] = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_ID))
                map["distance"] = cursor.getDouble(cursor.getColumnIndexOrThrow(COLUMN_DISTANCE))
                map["isViolation"] = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_IS_VIOLATION)) == 1
                map["isBlinking"] = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_IS_BLINKING)) == 1
                map["eyeMovement"] = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_EYE_MOVEMENT)) ?: "center"
                map["isSquinting"] = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_IS_SQUINTING)) == 1
                map["isPowerSaveActive"] = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_IS_POWER_SAVE)) == 1
                
                val lowLightIndex = cursor.getColumnIndex(COLUMN_IS_LOW_LIGHT)
                map["isLowLight"] = if (lowLightIndex >= 0) cursor.getInt(lowLightIndex) == 1 else false
                
                map["timestamp"] = cursor.getLong(cursor.getColumnIndexOrThrow(COLUMN_TIMESTAMP))
                list.add(map)
            } while (cursor.moveToNext())
        }
        cursor.close()
        db.close()
        return list
    }

    fun deleteLogs(ids: List<Int>) {
        if (ids.isEmpty()) return
        val db = this.writableDatabase
        val args = ids.joinToString(",")
        db.execSQL("DELETE FROM $TABLE_NAME WHERE $COLUMN_ID IN ($args)")
        db.close()
    }
}

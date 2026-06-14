# VisionSafe AI Multi-Agent Pipeline
**Solusi UTS Big Data & Capstone Project**

## 🛑 Masalah Sebelumnya (Kritik Dosen)
1. **Kurang Realtime**: Pengambilan data (`data_ingestion.py`) berjalan secara statis (cron/manual).
2. **Tidak Ada Rentang Waktu (Time Range)**: Data ditarik tanpa filter waktu yang jelas, menyebabkan duplikasi dan data yang tidak relevan dengan waktu saat ini.
3. **Arsitektur Monolitik**: Pengolahan data tidak memenuhi spesifikasi alur _AI Pipeline_ yang diminta pada revisi soal UTS.

## ✅ Solusi Baru: 8-Agent AI Pipeline (FastAPI)
Kami merombak sistem menjadi arsitektur micro-agent berbasis *FastAPI* dan *APScheduler*. Data mengalir secara berurutan dan otonom: `Collection -> Storage -> Preparation -> AI -> API -> Mobile`.

### 1. Data Collection Agent 🕒
Berjalan di *background thread* menggunakan `APScheduler`. Agent ini aktif **setiap 15 detik** untuk menarik data (Telemetry/API) secara realtime dengan rentang waktu yang presisi (menggunakan filter `now - 10 detik`). Hal ini memastikan data 100% *up-to-date* dan akurat.

### 2. Data Storage Agent 🗄️
Agent yang menyimpan seluruh data mentah dan hasil olahan ke dalam **Database NoSQL** (menggunakan *TinyDB* untuk simulasi, yang mensimulasikan penyimpanan *JSON Document* seperti MongoDB/Firestore).

### 3. Data Preparation Agent 🧹
Agent pembersih data. Ia melakukan normalisasi teks dan *preprocessing* gambar (misal mengubah ukuran menjadi *tensor* standar PyTorch `224x224`) sebelum data dikirim ke Model AI.

### 4. Computer Vision / Deep Learning Agent 🧠
Pusat kecerdasan buatan. Menggunakan framework *PyTorch* / *TensorFlow* (disimulasikan), Agent ini menerima data yang sudah siap, lalu melakukan inferensi (misal: klasifikasi *"Eye Fatigue"*, atau deteksi "*Screen Too Close*") dan mengembalikan `confidence score` beserta `label`.

### 5. Analytics & Visualization Agent 📊
Menganalisis hasil inferensi menggunakan `Pandas`. Menghasilkan *Insight Report* (seperti rata-rata confidence, distribusi kelelahan mata pengguna) yang datanya dapat digunakan untuk *Chart* pada *Dashboard*.

### 6. API / Web Service Agent 🌐
*Core router* berbasis FastAPI. Agent ini mengekspos endpoint RESTful berformat JSON (misal: `/upload`, `/analytics`, `/data/raw`). Menjembatani Model AI dan Aplikasi Mobile secara asinkron.

### 7. Mobile Application Agent 📱
Aplikasi Flutter (Klien). Mengonsumsi API dari *Web Service Agent*. Menjamin UX yang responsif dengan menerima *feedback* real-time terkait posisi mata atau peringatan *screen-time*.

### 8. Security & Monitoring Agent 🛡️
Diimplementasikan sebagai *FastAPI Middleware*. Agent ini melakukan log terhadap semua aktivitas masuk, memeriksa anomali (seperti *payload* injeksi), dan memastikan jalur komunikasi API aman.

---

## 🚀 Cara Menjalankan Pipeline

1. Pindah ke direktori pipeline:
   ```bash
   cd /home/irsyad/Gudang/EyeGuardian/visionsafe/big_data/ai_pipeline
   ```
2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
3. Jalankan pipeline (Orkestrator Utama):
   ```bash
   python main.py
   ```
4. Buka **Swagger UI** (API Documentation) untuk presentasi:
   - http://localhost:8000/docs

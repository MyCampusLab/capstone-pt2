# Buku 1: Arsitektur Kecerdasan Buatan (AI) & Pemrosesan Citra
**Fokus Presentasi:** Menjawab Dosen Penguji Kecerdasan Buatan & Dosen Citra Digital.

---

## 1. Pemilihan Model Pembelajaran Mesin (Machine Learning)
**Pertanyaan Dosen:** *"Mengapa pakai MediaPipe? Mengapa tidak melatih model YOLO atau Haar Cascade sendiri?"*
**Argumen Presentasi:**
*   **Efisiensi *Mobile*:** *Hardware smartphone* memiliki memori (RAM) dan daya baterai yang sangat terbatas. Melatih dan memaksakan model *Heavy-weight* seperti YOLOv8 di *smartphone* akan menyebabkan *thermal throttling* (HP panas).
*   **Arsitektur BlazeFace & Mesh:** Kami memilih **Google MediaPipe Face Mesh** karena arsitekturnya hibrida. Lapis pertama (*BlazeFace*) hanya mendeteksi "Di mana kotak wajahnya?" dengan komputasi sangat ringan. Lapis kedua memetakan 478 koordinat 3D di dalam kotak tersebut. Ini memastikan AI kita berjalan di bawah 20 ms (*Real-Time*).

## 2. Kalkulus Jarak: Teorema Segitiga Sebangun (Triangle Similarity)
**Pertanyaan Dosen:** *"Bagaimana kamera 2D bisa mengukur jarak sentimeter 3D tanpa sensor LiDAR?"*
**Argumen Presentasi:**
Ini adalah inti inovasi matematis kami. Kamera memang 2D (hanya membaca Pixel). Namun, kita bisa menebak jarak dengan **Konstanta Jarak Pupil Mata**.

**Formulanya:**
1.  **D (Distance / Jarak Asli):** Ini yang sedang kita cari.
2.  **W (Known Width / Lebar Asli Mata):** Secara medis, jarak antar pupil mata (*Inter-Pupillary Distance*) manusia konstan di **6.3 cm**.
3.  **F (Focal Length):** Nilai lensa kamera (didapat saat pengguna pertama kali membuka aplikasi dan meletakkan HP di jarak ukur 30 cm).
4.  **P (Perceived Width / Jarak Layar):** Jarak piksel mata di layar HP saat ini (Dihitung langsung oleh MediaPipe).

**Rumus:** `D = (W * F) / P`
**Logika Penjelasan Dosen:** *"Ketika kepala anak mendekat ke kamera, secara optik, gambar mata di layar pasti membesar. Artinya, angka **P (Pembagi)** akan semakin besar. Dalam ilmu matematika dasar, jika nilai Pembagi membesar, maka hasil pembagiannya (Jarak/D) pasti akan semakin kecil. Saat D menyentuh angka kurang dari 30 cm, sistem akan meledakkan alarm."*

## 3. Penyaring Sinyal Kamera (Low-Pass Filter)
**Pertanyaan Dosen:** *"Kamera HP sering bergetar/noise. Bagaimana kamu memastikan ukuran jaraknya tidak loncat-loncat (misal 30cm, tiba-tiba 45cm)?"*
**Argumen Presentasi:**
*"Betul Pak/Bu, kami tidak langsung menelan mentah-mentah angka dari AI. Kami merancang penyaring sinyal digital yang disebut **Alpha Smoothing (Low-Pass Filter)**. Rumusnya adalah `Nilai Baru = (Nilai Sekarang x Alpha) + (Nilai Sebelumnya x (1 - Alpha))`. Dengan menyetel beban Alpha di 0.2, data yang melompat tiba-tiba akibat gangguan cahaya kamera akan diredam. Hasilnya, ukuran jarak di layar sangat stabil (Smooth)."*

# Bedah Cara Kerja 1: Alur Pendeteksian Jarak Mata
**Fokus:** Menjelaskan dari mana angka sentimeter (cm) di layar itu berasal, secara logis dan teknis.

---

## 👁️ Tahap 1: Kamera Mengintip (Frame Capture)
*   **Cara Kerja Ringan:** Begitu tombol pengawasan ditekan, kamera depan HP akan menyala secara "diam-diam" di latar belakang (tanpa memunculkan kotak *preview* kamera di layar).
*   **Penjelasan Teknis:** Kami memanggil *library* `CameraX` bawaan Android OS melalui *Native Kotlin*. Agar hemat baterai, kami menyetel *ImageAnalysis* untuk hanya menangkap **1 frame per detik (1 FPS)**, bukan 30 FPS.
*   **Bukti Nyata (Tunjukkan ke Dosen):** Buka aplikasi *Task Manager* / Penggunaan Baterai di HP. Buktikan bahwa VisionSafe memakan daya baterai di bawah 5% per jam meskipun kameranya terus bekerja.

## 🤖 Tahap 2: AI Membedah Wajah (Landmarking)
*   **Cara Kerja Ringan:** Gambar wajah yang ditangkap tadi (1 detik sekali) dilempar ke "Otak AI". AI ini langsung membedah wajah anak menjadi ratusan titik jaring.
*   **Penjelasan Teknis:** *Frame* foto dimasukkan ke model **Google MediaPipe Face Mesh**. AI ini tidak mengenali "Siapa" anak itu (bukan Face Recognition), melainkan memetakan **478 titik (Landmarks)** koordinat wajah secara 3D (X, Y, Z).
*   **Bukti Nyata (Tunjukkan ke Dosen):** Tunjukkan cuplikan kode di *Kotlin* di mana fungsi `FaceMeshResult` secara harfiah mengeluarkan *Array* (daftar angka) berisi 478 indeks koordinat mata, hidung, dan bibir.

## 📏 Tahap 3: Matematika Jarak (The Formula)
*   **Cara Kerja Ringan:** Setelah mata ketemu, sistem mengukur berapa jarak piksel mata kiri ke mata kanan di layar. Karena jarak mata asli manusia selalu sama (rata-rata 6.3 cm), sistem bisa menebak kalau gambar mata di layar mengecil, berarti anak menjauh.
*   **Penjelasan Teknis:** Sistem mengambil Index koordinat spesifik (Pupil Kiri & Kanan), menghitung selisih koordinat (Lebar Perceived / P). Lalu memasukkannya ke rumus `(Lebar Medis Mata Asli [6.3cm] * Nilai Kalibrasi Lensa [Focal Length]) / Lebar Perceived [P]`.
*   **Bukti Nyata (Tunjukkan ke Dosen):** Praktikkan memajukan wajah. Angka di layar *(Real-time)* akan menyusut (misal dari 45cm ke 20cm). Tunjukkan bahwa tidak ada alat/sensor laser *Infrared* di HP Anda, membuktikan angka itu murni hasil hitungan matematika pecahan dari piksel kamera.

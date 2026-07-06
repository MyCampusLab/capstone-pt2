# Buku Pintar Irsyad (Panduan Teknis Mendalam)
**Tujuan:** Amunisi khusus untuk menghadapi Dosen IT, Dosen Jaringan, dan Dosen Kecerdasan Buatan (AI).

---

## 🧠 1. BEDAH JANTUNG AI (KHUSUS DOSEN KECERDASAN BUATAN)
Jika Dosen AI mulai mencecar *"Bagaimana cara kerjanya? Pakai model apa? Kok bisa akurat?"*, gunakan argumen ini dengan percaya diri:

### A. Model Apa yang Dipakai?
> *"Bapak/Ibu, kami tidak men-training model dari nol karena keterbatasan *resource* komputasi di *mobile*. Kami mengimplementasikan **Google MediaPipe Face Mesh**. Secara *under-the-hood*, MediaPipe menggunakan arsitektur dua tahap: Pertama, **BlazeFace** untuk mendeteksi kotak wajah (*Bounding Box*) dengan sangat ringan. Kedua, model 3D *Mesh Topology* yang memetakan **478 titik landskap wajah** (termasuk iris mata) ke dalam matriks koordinat X, Y, dan Z."*

### B. Bagaimana Implementasinya agar Tidak Ngelag?
> *"Kesalahan umum mahasiswa adalah menjalankan AI *Computer Vision* langsung di bahasa Dart (Flutter). Hasilnya pasti patah-patah (lag). Saya mem- *bypass* Flutter dan menulis algoritma AI ini murni menggunakan **Native Kotlin (Android)**. Proses penglihatan AI dieksekusi di OS terbawah, lalu hasilnya dikirim ke Flutter menggunakan *MethodChannel* murni sebagai data angka, bukan data gambar. Inilah mengapa aplikasi kita bisa berjalan di bawah 20 *milisecond* per *frame*."*

### C. Matematika Pengukur Jarak (The Math)
> *"Kamera hanyalah lensa 2D. Untuk mengubah piksel 2D menjadi jarak Z (Sentimeter) 3D, saya membangun kalkulus **Triangle Similarity (Segitiga Sebangun)**."*
1. **Titik Ekstraksi:** Dari 478 titik, algoritma memfilter indeks spesifik untuk pupil mata kiri (Titik A) dan pupil mata kanan (Titik B).
2. **Perceived Width (P):** Algoritma menghitung jarak piksel Euclidean antara Titik A dan Titik B di layar saat ini.
3. **Known Width (W):** Secara anatomis, jarak antar-pupil mata (IPD) balita hingga dewasa stabil di angka rata-rata **6.3 cm**.
4. **Focal Length (F):** Saat pertama buka aplikasi (Kalibrasi 30cm), sistem merekam karakter lensa bawaan HP (Jarak 30cm * Jarak Piksel Kalibrasi / 6.3cm).
5. **Rumus Final:** Setiap *frame* kedipan kamera, sistem mengeksekusi rumus: `(W * F) / P`. Jika anak mendekat, mata membesar di layar (P membesar). Jika Pembagi membesar, maka hasil Jarak sentimeternya akan mengecil. Di situlah AI tahu anak sedang terlalu dekat!

### D. Peredam Getaran (Low-Pass Filter)
> *"Lensa kamera sering goyang (*noise/jitter*). Jika murni pakai AI, ukuran jaraknya akan melompat-lompat (misal: 30cm, 35cm, 29cm). Untuk mengatasi itu, saya menyuntikkan algoritma sinyal **Low-Pass Filter (Alpha Smoothing)**. Nilai jarak saat ini dikalikan beban histori jarak sebelumnya (misal Alpha 0.2), sehingga hasil output yang keluar sangat halus (smooth) dan tidak membuat layar berkedip-kedip."*

---

## 🏗️ 2. ARSITEKTUR & ALUR APLIKASI (LIFECYCLE)
### A. Pola Arsitektur (GetX MVC)
> *"Secara struktur *frontend*, proyek ini dipecah ketat menggunakan *Micro-framework* **GetX**. Saya memisahkan `View` (UI murni dari Marsha), `Controller` (Otak logika), dan `Binding` (Injeksi dependensi memori). Artinya, *controller* AI tidak akan di-*load* ke dalam RAM HP sampai halaman pendeteksi wajah benar-benar dibuka (Lazy Loading), sangat menghemat memori."*

### B. Alur Eksekusi (Bagaimana Aplikasi Berjalan)
1. **Booting:** Aplikasi dibuka. Flutter memanggil `VisionCameraManager` di Kotlin.
2. **Background Engine:** Layar HP ditutup/dimatikan, Kotlin **Foreground Service** tetap hidup di *taskbar* OS Android.
3. **Thermal Guard:** `DeviceStateManager` mengecek suhu baterai. Jika melampaui 42°C, sistem AI dipaksa melambat dari 1 FPS menjadi 0.2 FPS (1 frame per 5 detik) agar Android OS tidak membunuh paksa layanan kita (Thermal Throttling Defense).
4. **Punishment Execution (Blur):** Jika rumus *Triangle Similarity* menghasilkan angka <30cm selama 3 detik berturut-turut, Kotlin menembakkan izin *System Alert Window*. Kaca buram (*Gaussian Blur*) menimpa paksa seluruh layar, menutupi game/YouTube anak.

---

## 🔐 3. FITUR KEAMANAN (RLS & AUTENTIKASI)
Jika Dosen Jaringan/Cyber Security bertanya soal keamanan pangkalan data (Database):
> *"Aplikasi ini **Serverless**. Kami tidak punya perantara Node.js/PHP. Klien langsung menembak ke Database PostgreSQL (Supabase). Untuk mencegah peretas, kami menggunakan **Row Level Security (RLS)** bawaan PostgreSQL."*
> *"Login menggunakan Google OAuth. Supabase memberikan JWT (JSON Web Token) yang disematkan di *header* setiap pengiriman data. RLS secara absolut akan menolak (*HTTP 403 Forbidden*) jika UUID dari Token JWT tidak sama persis dengan `user_id` di baris data tersebut. Data anak tidak bisa disadap/diubah orang lain."*

---

## 👥 4. FITUR EKOSISTEM (SQUAD, QUEST, OWNER CONSOLE)
Jelaskan alur data masing-masing fitur ini dengan sederhana:

*   **Family Squad:** Menggunakan teknik Relasional SQL (Tabel `groups` dan `group_members`). Ayah yang *login* akan meminta hak akses (Join SQL) ke tabel log anak. RLS di Supabase mengecek: *"Apakah Ayah ini berstatus supervisor di grup si Anak?"*. Jika iya, data anak dikirim ke HP Ayah.
*   **Quest & Reward:** AI bukan cuma menghukum, tapi memberi hadiah. Jika AI menghitung wajah anak stabil di angka >30cm selama 5 menit berturut-turut, sinyal akan dikirim ke *Reward Service* untuk mencetak 10 XP. Jika XP penuh, tabel *Level* akan di-*update* dan status maskot terbuka.
*   **Developer Owner Console:** Ini adalah markas pusat (Hanya untuk akun pemilik aplikasi). Console ini menggunakan *Bypass RLS (Service Role Key)* terbatas untuk memanggil fungsi agregasi (SUM dan COUNT) dari seluruh tabel `telemetry_logs`. Fungsi utamanya untuk melihat skalabilitas: *Apakah hari ini ada 10.000 user yang menyetor data secara bersamaan?* (Menjamin Big Data termonitor).

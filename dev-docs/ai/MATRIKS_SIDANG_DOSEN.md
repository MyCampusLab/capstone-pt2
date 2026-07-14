# Panduan Presentasi: Matriks Nilai 6 Mata Kuliah (Versi Dosen)
**Proyek:** VisionSafe
**Tujuan:** Panduan "bahasa manusia" untuk menjelaskan teknologi canggih VisionSafe kepada dosen penguji secara sederhana, logis, dan masuk akal.

---

## 1. Mobile Development (100 Poin)
**Target: Stabil, Rapih, dan Siap Rilis**
*   **Aplikasi Berjalan Sangat Lancar (Tanpa Lag):** Kami memisahkan tugas berat (membaca wajah lewat kamera) agar diurus langsung oleh mesin bawah Android (Kotlin), sehingga layar yang dilihat pengguna (Flutter) tetap sangat mulus dan tidak pernah *freeze*.
*   **Kode yang Rapi (GetX):** Ibarat membangun rumah, kami memisahkan ruang tamu (UI), dapur (Logika), dan gudang (Data). Jika ada kerusakan di dapur, ruang tamu tidak akan terpengaruh.
*   **Siap Masuk Pasar:** Kami tidak hanya membuat aplikasi *prototype*, tapi sudah membungkusnya secara resmi (format Android App Bundle) dan saat ini sedang antre untuk tayang di Google Play Store.

## 2. Keamanan Data dan Jaringan (100 Poin)
**Target: Tidak Bisa Dibobol & Data Aman**
*   **Sistem Komunikasi Cepat:** Teguran dari HP orang tua ke HP anak sampai dalam hitungan milidetik, seperti mengirim pesan WhatsApp.
*   **Login Aman (Lebih dari Sekadar SMS OTP):** Daripada memakai OTP SMS yang sering terlambat atau memakan biaya pulsa, kami menggunakan Login Google (OAuth). Sistem akan memberikan "Karcis Khusus" (JWT) yang diacak kodenya agar mustahil dipalsukan.
*   **Satpam Data (Row Level Security):** Data mata anak sangat rahasia. Kami menaruh "Satpam Virtual" langsung di depan pintunya (Database). Anak A tidak akan pernah bisa mengintip data Anak B, dan peretas dari luar otomatis diusir (Akses Ditolak / 403).

## 3. Web Service (100 Poin)
**Target: Sistem Server yang Efisien & Terdokumentasi**
*   **Server Tanpa Ribet (BaaS - Supabase):** Kami tidak membeli komputer server fisik yang mahal. Kami menggunakan teknologi Cloud (Supabase) yang ibarat apartemen—semuanya sudah tersedia (Database, Login, Internet Cepat) dalam satu paket, memangkas biaya pemeliharaan.
*   **Keamanan Terpusat:** Pengecekan keamanan tidak dilakukan di aplikasi yang bisa diretas, melainkan langsung di jantung servernya.
*   **Buku Panduan Mesin (Swagger API):** Kami membuat "buku panduan" digital interaktif (*Swagger*). Jika kelak ada pembuat aplikasi lain yang mau menyambungkan sistem mereka ke VisionSafe, mereka tinggal membaca buku panduan *online* tersebut.

## 4. Big Data (100 Poin)
**Target: Mengolah Data Banyak Menjadi Mudah Dibaca**
*   **Pengumpulan Data Otomatis:** HP anak diam-diam membaca jarak mata setiap 5 detik. Agar baterai dan kuota internet tidak habis, kami **menabung** data tersebut di memori HP dulu, lalu mengirimnya secara "borongan" setiap 15 menit. (Teknik ini menghemat kuota internet hingga 90%!).
*   **Visualisasi Heatmap (Peta Panas):** Ribuan data jarak pandang anak tidak ditampilkan dalam bentuk angka yang membingungkan orang tua. Kami ubah menjadi "Kalender Warna". Jika hari Minggu jam 8 malam warnanya **Merah Menyala**, artinya anak paling sering merusak matanya pada jam tersebut.

## 5. Penjaminan Mutu Perangkat Lunak (SQA) (100 Poin)
**Target: Bebas Error & Teruji secara Internasional (ISO 25010)**
*   **Robot Penguji (Katalon Studio):** Untuk membuktikan aplikasi kami bebas *bug*, kami menggunakan robot penguji otomatis. Robot ini mengetes semua tombol dan fitur dengan memasukkan puluhan data palsu untuk melihat apakah aplikasi akan *crash* (rusak).
*   **Sertifikasi Standar (Laporan ISO 25010):** Kami telah menyusun buku laporan setebal dokumen resmi, membuktikan bahwa aplikasi kami sangat hemat kuota internet (Kinerja) dan sangat kebal dari serangan siber (Keamanan).

## 6. Pemrograman Sistem Cerdas 2 (Non-LLM) (100 Poin)
**Target: AI Pintar yang Bisa Berpikir & Bertindak**
*   **Akurasi Tinggi & Kilat:** Kecerdasan Buatan (AI) kami sanggup melacak 478 titik lekukan wajah anak dan mengukur jaraknya layaknya menggunakan penggaris (dengan hitungan matematika Segitiga), semuanya diproses sangat cepat (kurang dari 20 milidetik).
*   **Bisa Mengambil Keputusan Sendiri:** AI ini tidak hanya diam. Jika AI mendeteksi baterai HP sudah terlalu panas (karena anak bermain *game* berat), AI akan secara cerdas menurunkan kecepatan kerjanya agar HP tidak *hang* (Mekanisme Pencegah HP Panas).
*   **Eksekutor Hukuman:** Jika anak mendekatkan mata kurang dari 30cm selama lebih dari 3 detik, AI akan langsung mengambil alih layar HP dan memberinya **Efek Kaca Buram** (Blur), memaksa anak memundurkan kepalanya tanpa perlu disuruh orang tua.

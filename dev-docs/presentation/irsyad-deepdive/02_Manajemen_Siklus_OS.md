# Buku 2: Manajemen Siklus Hidup & Penetrasi Sistem Operasi (OS)
**Fokus Presentasi:** Menjawab Dosen Arsitektur Perangkat Lunak & Sistem Operasi.

---

## 1. Menembus Batas Flutter (Native Kotlin)
**Pertanyaan Dosen:** *"Aplikasi Flutter biasanya akan mati (*Freeze*) atau sangat ngelag jika dipaksa menjalankan AI berat. Mengapa punyamu mulus?"*
**Argumen Presentasi:**
*"Rahasia utamanya adalah **Isolasi Memori**. Saya tidak mengeksekusi AI di dalam Dart/Flutter. Sistem AI pengukur jarak kami bungkus murni menggunakan bahasa **Kotlin Native** yang terikat langsung ke jantung OS Android. Flutter hanya bertugas menampilkan UI cantik (seperti ruang tamu). Kotlin dan Flutter bertukar data jarak melalui jembatan yang disebut `MethodChannel`.*"

## 2. Kekebalan Latar Belakang (Foreground Service)
**Pertanyaan Dosen:** *"Kalau anak pintar, dia pasti me-minimize aplikasinya atau men-swipe up (Clear RAM) agar kameranya mati. Gimana ngatasinnya?"*
**Argumen Presentasi:**
*"Kami merancang sistem **Background Defense** tingkat tinggi. Modul Kotlin kami berjalan sebagai `Foreground Service` (Bisa dilihat dari adanya ikon notifikasi yang tidak bisa diusir/dihapus di layar atas Android). Meskipun anak menutup paksa aplikasi (Swipe Up), layar Blur dan sensor jarak akan terus menyala. Untuk HP China (Xiaomi/Oppo/Vivo) yang sering membunuh proses latar belakang, kami memaksa pengguna mengaktifkan izin `AutoStart` via OS Intent khusus."*

## 3. Eksekutor Kaca Buram (System Alert Window)
**Pertanyaan Dosen:** *"Bagaimana cara aplikasimu bisa tiba-tiba muncul kaca buram menutupi layar game anak yang sedang dimainkan?"*
**Argumen Presentasi:**
*"Sistem kami meminta izin terdalam di Android yaitu **Draw Over Other Apps** (SYSTEM_ALERT_WINDOW). Saat algoritma AI melihat jarak anak di bawah 30cm, layanan latar belakang Android akan merender (*inflate*) sebuah *View* berbentuk kotak hitam semi-transparan (Kaca Buram) pada koordinat Z-Index tertinggi (menutupi seluruh piksel OS Android, termasuk *game* atau YouTube yang sedang berjalan). Anak dipaksa mundur, karena layar sentuhnya pun tidak akan merespons (Tertutup lapisan kaca kita)."*

## 4. Perlindungan Baterai (Thermal Throttling)
**Pertanyaan Dosen:** *"Menyalakan AI dan Kamera terus menerus pasti bikin HP anak meledak/kepanasan. Bukannya ini berbahaya?"*
**Argumen Presentasi:**
*"Saya sangat setuju, Pak. Karena itulah saya membangun modul `DeviceStateManager`. Sistem ini membaca status perangkat bawaan Android (seperti level baterai dan sensor suhu).
*   **Normal (Suhu < 38°C):** AI memindai wajah **1 kali per detik (1 FPS)**. (Bukan 30 FPS seperti video biasa, ini saja sudah menghemat 96% baterai).
*   **Kritis (Suhu > 40°C / Baterai < 10%):** Sistem **Thermal Throttling** aktif secara otonom. AI dicekik menjadi memindai wajah hanya **1 kali per 5 detik**. HP anak dijamin akan kembali dingin."*

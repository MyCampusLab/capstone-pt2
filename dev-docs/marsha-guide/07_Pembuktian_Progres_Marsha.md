# Panduan Presentasi Marsha (Bagian 6)
**Topik:** Cara Menjawab & Membuktikan 13 Daftar Tugas (Task Progress)
**Tujuan:** Jika dosen menagih *"Mana buktinya fitur X sudah selesai?"*, kamu harus siap menunjukkan buktinya di layar dan memberikan argumen yang elegan (meskipun itu tugas Irsyad, kamu tetap bisa menjawabnya secara *High-Level*).

---

### 🟢 TASK 1: Riset AI & Perancangan Arsitektur (TIM)
*   **Cara Buktikan:** Tunjukkan dokumen *Flowchart* dan *file* `overview.md`. Buka aplikasi dan tunjukkan AI berjalan lancar.
*   **Argumen Marsha:** *"Kami tidak asal koding, Pak/Bu. Kami mulai dari riset kelayakan (Proof of Concept). Buktinya, kami memilih MediaPipe karena terbukti memakan waktu kurang dari 20 milidetik per frame, sehingga tidak memberatkan HP anak."*

### 🟢 TASK 2: Setup Backend Cloud & Autentikasi (IRSYAD)
*   **Cara Buktikan:** Buka *dashboard* Supabase di laptop, tunjukkan tab **Authentication** dan **Policies (RLS)**.
*   **Argumen Marsha:** *"Rekan saya Irsyad telah membangun arsitektur keamanan di Supabase. Login kita valid menggunakan Google Auth, dan Bapak/Ibu bisa lihat aturan RLS ini yang bertindak sebagai satpam data. Data tidak bisa diintip orang luar."*

### 🟢 TASK 3: Desain UI/UX & Maskot Enterprise (MARSHA)
*   **Cara Buktikan:** Putar-putar HP (rotasi layar) atau buka di berbagai ukuran layar saat demonstrasi aplikasi (UI responsif).
*   **Argumen Marsha:** *"Ini adalah tanggung jawab penuh saya. Saya menggunakan arsitektur Flex dan LayoutBuilder di Flutter. Bukti nyatanya, seberapapun ukuran layarnya, tampilan tidak akan pernah overflow (layar kuning error), dan Maskot Vizo (animasi Lottie) berjalan sangat halus."*

### 🟢 TASK 4: Integrasi Core AI Face Mesh & Jarak (IRSYAD)
*   **Cara Buktikan:** Letakkan penggaris nyata di sebelah muka, lalu lihat apakah angka jarak di layar HP sama dengan penggaris asli.
*   **Argumen Marsha:** *"AI ini bukan sekadar nebak, Pak/Bu. Algoritma Triangle Similarity yang dirancang Irsyad berhasil menerjemahkan piksel dari 478 titik wajah MediaPipe menjadi akurasi sentimeter di dunia nyata."*

### 🟢 TASK 5: Optimasi Smoothing & Performa AI (IRSYAD)
*   **Cara Buktikan:** Goyang-goyangkan HP secara wajar, perlihatkan angka sentimeternya tidak loncat gila-gilaan.
*   **Argumen Marsha:** *"Kamera HP rentan getar (*jitter*). Tapi sistem kami sudah dipasang 'Low-Pass Filter', jadi angkanya sangat mulus. Kami juga memasang perlindungan *Thermal Throttling*, jadi kalau HP anak panas >42 derajat, AI ini akan otomatis menurunkan kecepatannya agar HP aman."*

### 🟢 TASK 6: Setup Native Kotlin & Background Service (IRSYAD)
*   **Cara Buktikan:** Minimalkan (*minimize*) atau tutup aplikasinya (*swipe up* dari *recent apps*), perlihatkan ikon aplikasi masih menyala di Status Bar (atas layar HP).
*   **Argumen Marsha:** *"Aplikasi pengawas biasa akan mati kalau layarnya ditutup. Tapi berkat integrasi Kotlin Native yang dibuat Irsyad, sistem kami menjadi 'Foreground Service' yang kebal dari pembunuhan paksa sistem Android."*

### 🟢 TASK 7: Sistem Intervensi Layar / Blur Overlay (IRSYAD)
*   **Cara Buktikan:** Majukan wajah sangat dekat ke layar HP (bawah 30cm) selama 3 detik, dan biarkan dosen melihat layar otomatis tertutup kaca buram.
*   **Argumen Marsha:** *"Ini adalah senjata eksekutor kami. Saat anak melanggar batas, sistem otomatis membajak layar menumpahkan efek Blur. Layar sentuh anak tidak akan berfungsi sampai dia menjauhkan wajahnya."*

### 🟢 TASK 8: Big Data Telemetry & Sinkronisasi (IRSYAD)
*   **Cara Buktikan:** Buka *dashboard* Supabase -> *Table Editor* -> `telemetry_logs`. Tunjukkan log yang masuk jaraknya 15 menitan.
*   **Argumen Marsha:** *"Aplikasi ini sangat ramah kuota. Kami tidak mengirim data tiap detik. Sistem menampung data (*Smart Rollup*) di HP, lalu mengirimkannya borongan setiap 15 menit ke Cloud ini."*

### 🟢 TASK 9: Visualisasi Analitik & Family Squad (MARSHA)
*   **Cara Buktikan:** Buka halaman *Dashboard* -> Menu Grafik Mingguan, lalu perlihatkan tombol/menu masukan kode (Invite Code) Grup Keluarga.
*   **Argumen Marsha:** *"Saya mengubah data ribuan log dari server menjadi visualisasi 'Heatmap' dan 'Bar Chart' menggunakan Fl_Chart agar ramah dibaca orang tua. Saya juga membuat tampilan sistem Family Squad agar seluruh keluarga bisa memantau dengan 'Invite Code'."*

### 🟢 TASK 10: Dokumentasi API Web Service (MARSHA)
*   **Cara Buktikan:** Buka *browser*, ketik **`visionsafe-api.surge.sh`**.
*   **Argumen Marsha:** *"Saya mendokumentasikan setiap titik akhir (Endpoint) server kami layaknya standar perusahaan (Enterprise). Dokumentasi interaktif (Swagger OpenAPI) dan Postman Collection ini memastikan sistem kami siap untuk dikembangkan lebih jauh (Skalabilitas)."*

### 🟢 TASK 11: QA Automation Testing Katalon (MARSHA)
*   **Cara Buktikan:** Tunjukkan dokumen **"Laporan QA ISO25010.pdf"**.
*   **Argumen Marsha:** *"Saya menguji aplikasi ini tidak lagi menekan tombol pakai tangan, melainkan menggunakan robot skenario BDD Gherkin dari Katalon Studio (Data Driven Testing). Dokumen PDF bersertifikasi ISO 25010 ini adalah bukti mutlak bahwa sistem kami lulus uji tanpa kecacatan fungsional."*

### 🟢 TASK 12: Penyusunan Laporan Capstone (TIM)
*   **Cara Buktikan:** Tunjukkan *Draft* laporan MS Word atau dokumen Matriks Nilai yang barusan dikerjakan.
*   **Argumen Marsha:** *"Seluruh kerangka akademis, matriks penilaian 6 matkul, dan slide presentasi yang Bapak/Ibu lihat hari ini adalah bukti penyelesaian dari tugas ini."*

### 🟡 TASK 13: Kompilasi AAB & Rilis Play Store (TIM)
*   **Cara Buktikan:** Buka *Google Play Console* di *browser*, perlihatkan status aplikasinya *(In Review / Menunggu Peninjauan)*.
*   **Argumen Marsha:** *"Kode sumber Flutter kami sudah di- *tree-shaking* (diperkecil ukurannya) dan di-*build* menjadi Android App Bundle (AAB). Saat ini status progres kami 95% hanya karena sedang menunggu antrean persetujuan (Review) resmi dari pihak Google Play Store."*

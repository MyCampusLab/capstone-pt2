# Buku 7: Pembuktian Progres 13 Task (Versi Engineer - Irsyad)
**Topik:** Cara Menjawab & Mendemonstrasikan 13 Daftar Tugas secara Teknis
**Tujuan:** Jika dosen pembimbing teknis menagih bukti nyata *source code*, arsitektur, atau unjuk kerja langsung, ini adalah skenario mematikan yang harus Anda eksekusi.

---

### 🟢 TASK 1: Riset AI & Perancangan Arsitektur (TIM)
*   **Cara Buktikan:** Tunjukkan *file* `overview.md` (Diagram Arsitektur) dan terminal *log console* yang menunjukkan waktu eksekusi MediaPipe.
*   **Argumen Irsyad:** *"Riset arsitektur kami membuktikan bahwa YOLO terlalu berat untuk *mobile*. Kami menggunakan Google MediaPipe Face Mesh. Bukti dari *log profiler* Android Studio menunjukkan bahwa ekstraksi 478 titik wajah kita konsisten memakan waktu di bawah 20 milidetik per *frame* (Zero Lag)."*

### 🟢 TASK 2: Setup Backend Cloud & Autentikasi (IRSYAD)
*   **Cara Buktikan:** Buka konsol Supabase. Tunjukkan tab SQL Editor berisi kode RLS (`CREATE POLICY...`), lalu tunjukkan log *Network* (F12) saat *login* yang mengembalikan token JWT.
*   **Argumen Irsyad:** *"Arsitektur keamanan saya berjalan di lapisan *Database Engine* (PostgreSQL). JWT dari otentikasi Google OAuth dieksekusi oleh aturan *Row Level Security* (RLS). Jika JWT tidak mengandung `user_id` yang cocok dengan pemilik data, permintaan akan langsung ditolak (403 Forbidden) di tingkat *router* Supabase."*

### 🟢 TASK 3: Desain UI/UX & Maskot Enterprise (MARSHA)
*   **Cara Buktikan:** Buka *DevTools* Flutter Inspector (jika diminta), tunjukkan hierarki `Wrap` dan `LayoutBuilder`.
*   **Argumen Irsyad:** *"Rekan saya Marsha merancang *frontend*. Dari sisi arsitektur, saya memastikan dia menggunakan pola *Responsive Layout* (Flex/Wrap) sehingga tidak ada *pixel overflow* pada *rendering tree* Flutter di ukuran layar sekecil apapun."*

### 🟢 TASK 4: Integrasi Core AI Face Mesh & Jarak (IRSYAD)
*   **Cara Buktikan:** Tunjukkan blok kode `VisionCameraManager.kt` tempat perhitungan aljabar terjadi.
*   **Argumen Irsyad:** *"Saya tidak memproses gambar menjadi *String* (yang akan membuat lambat). Pipeline AI berjalan secara *Native Kotlin* di atas pustaka Kamera CameraX. Variabel piksel pupil dihitung menggunakan rumus *Triangle Similarity* dan dikirimkan ke Flutter secara *asynchronous* melalui *MethodChannel*."*

### 🟢 TASK 5: Optimasi Smoothing & Performa AI (IRSYAD)
*   **Cara Buktikan:** Tunjukkan fungsi `applyLowPassFilter` dan `DeviceStateManager.kt` (*Battery/Thermal listener*).
*   **Argumen Irsyad:** *"Untuk meredam *jitter* (nilai sentimeter yang melompat), saya menyuntikkan *Alpha Smoothing*. Di level *hardware*, saya memantau status termal (*BatteryManager.EXTRA_TEMPERATURE*). Jika suhu menyentuh 40°C, *event loop* kamera otomatis turun ke 0.2 FPS (1 frame per 5 detik) untuk mencegah OS membunuh proses kita (*Thermal Death Prevention*)."*

### 🟢 TASK 6: Setup Native Kotlin & Background Service (IRSYAD)
*   **Cara Buktikan:** Paksa tutup aplikasi dari *Recent Apps*, lalu dekatkan wajah, perlihatkan bahwa layar tetap memburam (Service masih hidup).
*   **Argumen Irsyad:** *"Ini adalah bukti bahwa layanan *Computer Vision* terpisah dari *Lifecycle* layar Flutter. Saya meregistrasikannya sebagai `Foreground Service` bertipe `camera` di `AndroidManifest.xml`."*

### 🟢 TASK 7: Sistem Intervensi Layar / Blur Overlay (IRSYAD)
*   **Cara Buktikan:** Demokan efek *Blur*, lalu tunjukkan kode `WindowManager.LayoutParams`.
*   **Argumen Irsyad:** *"Hukuman dieksekusi menembus OS (Bypass App Sandbox) menggunakan izin `SYSTEM_ALERT_WINDOW`. Parameter *window* di-*inflate* ke Android OS dengan *Z-Index* maksimal dan tipe *Overlay*, memastikan tidak ada *game* (bahkan *game full-screen*) yang bisa menghindar dari intervensi kaca buram ini."*

### 🟢 TASK 8: Big Data Telemetry & Sinkronisasi (IRSYAD)
*   **Cara Buktikan:** Tunjukkan letak memori lokal (Hive/SQLite) atau buka log *Network* yang menembak ke Supabase hanya sesekali.
*   **Argumen Irsyad:** *"Ini adalah inovasi *Smart Telemetry Rollup* saya. Data telemetri tidak pernah membanjiri *bandwidth*. Ia mengagregasi 12 insiden dalam 1 memori lokal, dan menyuntikkannya (*Batch Insert*) melalui REST API Supabase setiap 15 menit. *Cost* server turun 95%."*

### 🟢 TASK 9: Visualisasi Analitik & Family Squad (MARSHA)
*   **Cara Buktikan:** Tunjukkan kode SQL Join di *Database* (atau *query* `select('*, groups(*)')`).
*   **Argumen Irsyad:** *"Secara logika bisnis (*backend*), saya merancang topologi relasional (`User` -> `Group Members` -> `Groups`). Saat *Invite Code* valid, tabel tergabung. Data telemetri yang mengalir ke *Heatmap* Marsha adalah hasil isolasi kueri (Isolated Query) berdasarkan *Supervisor ID*."*

### 🟢 TASK 10: Dokumentasi API Web Service (MARSHA)
*   **Cara Buktikan:** Tunjukkan *Swagger Editor* atau situs `visionsafe-api.surge.sh`.
*   **Argumen Irsyad:** *"Bapak/Ibu bisa cek skema OpenAPI (Swagger) kami. Endpoint yang kami miliki sudah direpresentasikan dalam format YAML yang baku, menjadikannya siap dihubungkan (*Microservices Ready*) ke klien pihak ketiga (misal: *Smartwatch*)."*

### 🟢 TASK 11: QA Automation Testing Katalon (MARSHA)
*   **Cara Buktikan:** Tunjukkan *file* skrip Gherkin (`.feature`) atau dokumen PDF hasil uji.
*   **Argumen Irsyad:** *"Selain stabilitas kode, *Quality Assurance* dijamin oleh uji integrasi (Integration Test). *Script Data-Driven* Katalon kami memastikan tidak ada kebocoran memori (Memory Leak) atau galat *Routing* (Navigation Error) saat diinjeksi 30 data *dummy* secara bersamaan."*

### 🟢 TASK 12: Penyusunan Laporan Capstone (TIM)
*   **Cara Buktikan:** Buka *file* **Buku Pintar (Ensiklopedia Deepdive)** ini.
*   **Argumen Irsyad:** *"Semua kerangka pemikiran dari algoritma AI, arsitektur GetX MVC, hingga skema *Database Serverless* sudah saya dokumentasikan dan audit secara rinci mengikuti spesifikasi rekayasa perangkat lunak (Software Engineering)."*

### 🟡 TASK 13: Kompilasi AAB & Rilis Play Store (TIM)
*   **Cara Buktikan:** Buka konsol Play Store yang menunjukkan `visionsafe.aab` berukuran ~67MB.
*   **Argumen Irsyad:** *"Kompilasi Dart telah dieksekusi dengan *flag --release*. Kompiler secara otomatis melakukan *Tree-Shaking* (membuang kode tak terpakai) dan *Obfuscation* (mempersulit *Reverse Engineering*). Buktinya, ukuran *bundle* (*AAB*) hanya berkisar 67MB. Statusnya saat ini sedang *In Review* oleh robot auditor Google Play Protect."*

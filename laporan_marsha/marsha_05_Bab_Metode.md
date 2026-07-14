# METODE

Penelitian ini menggunakan pendekatan eksperimental terapan dalam bidang Rekayasa Perangkat Lunak (*Software Engineering*). Prosedur penelitian berfokus pada pengembangan arsitektur kecerdasan buatan berbasis *mobile* yang mampu berjalan secara mandiri ( *on-device*) tanpa mengandalkan server eksternal, guna meminimalisasi latensi dan menjaga privasi pengguna. Sistem dirancang dengan menggunakan pola arsitektur *Clean Architecture* dan dipisahkan menjadi dua lapisan (*layer*) utama: lapisan presentasi antar-muka yang dibangun menggunakan kerangka kerja Flutter, dan lapisan pemrosesan kecerdasan buatan yang dibangun murni menggunakan bahasa Kotlin (*Native Android*). 

## A. Arsitektur Sistem AI dan Native Bridge
Model *Computer Vision* yang digunakan dalam penelitian ini adalah MediaPipe Face Landmarker. Untuk menjamin proses pemantauan jarak pandang tidak terhenti saat aplikasi ditutup oleh pengguna, lapisan AI dibungkus ke dalam siklus hidup *Kotlin Foreground Service*. Komunikasi data antara mesin inferensi AI (di level *Native*) dan antarmuka pengguna (di level Flutter) difasilitasi menggunakan *MethodChannel* dan *EventChannel*. Gambar 1 mengilustrasikan alur komunikasi arsitektur tersebut, di mana bingkai gambar (*frame*) dari kamera diproses secara asinkron di latar belakang, dan hasil kalkulasi metrik wajah dikirim ke UI hanya jika terjadi pelanggaran batas jarak aman.

*(Tempatkan Gambar 1 Di Sini)*
*Gambar 1. Arsitektur Komunikasi Lapisan Native Kotlin dan Flutter UI Menggunakan EventChannel*

## B. Algoritma Kalkulasi Jarak (Triangle Similarity)
Pendekatan konvensional memerlukan kamera ganda (stereoskopik) untuk menentukan kedalaman (sumbu-Z). Namun, penelitian ini menggunakan model kamera tunggal (*Monocular Camera*) yang disimulasikan menggunakan prinsip Kamera Lubang Jarum (*Pinhole Camera Model*). Setelah MediaPipe berhasil mendeteksi 478 titik koordinat wajah (*Face Mesh*), sistem mengekstraksi titik spesifik (Landmark ID 33 untuk mata kiri dan ID 263 untuk mata kanan). Mengingat keluaran MediaPipe merupakan nilai koordinat yang ternormalisasi (0,0 hingga 1,0), titik-titik tersebut terlebih dahulu didenormalisasi dengan mengalikannya terhadap lebar dan tinggi resolusi bingkai kamera untuk mendapatkan posisi piksel absolut (x, y).

Jarak antar mata di layar (*Pixel Inter-Pupillary Distance*) kemudian dihitung menggunakan persamaan geometri jarak Euclidean tiga dimensi untuk mengakomodasi kemiringan wajah pengguna terhadap lensa kamera, seperti pada Persamaan 1.

JarakPixel = √((x2-x1)² + (y2-y1)² + (z2-z1)²)               (1)

Setelah jarak piksel ditemukan, algoritma *Triangle Similarity* diterapkan untuk mengkonversi nilai piksel tersebut ke dalam jarak fisik absolut bersatuan sentimeter. Estimasi ini didasarkan pada asumsi jarak rata-rata anatomi mata manusia nyata (*Real IPD*) sebesar 6,3 cm dikalikan dengan panjang fokus (*focal length*) bawaan lensa yang dikalibrasi. Persamaan 2 menunjukkan perhitungan estimasi jarak tersebut.

JarakFisik (cm) = (IPDNyata × PanjangFokus) / JarakPixel       (2)

## C. Mekanisme Dynamic Thermal Throttling
Untuk mengatasi tingginya konsumsi energi akibat pemrosesan inferensi berulang oleh MediaPipe, sistem dilengkapi dengan lapisan pengontrol daya dinamis. Sebuah *BroadcastReceiver* didaftarkan pada sistem Android untuk membaca parameter `BatteryManager.EXTRA_TEMPERATURE`. 

Algoritma logika kondisional diterapkan pada lapisan *Native*: Jika suhu baterai berada di bawah ambang batas aman (≤ 38°C), kamera akan mengambil sampel bingkai wajah setiap 1 detik (1 Hz). Namun, jika suhu mencapai titik kritis batas perangkat (≥ 42°C), algoritma *Thermal Throttling* akan aktif dan mencekik laju pemrosesan menjadi 1 bingkai setiap 10 detik (0,1 Hz). Mekanisme ini menjamin OS Android tidak membunuh layanan pelindung mata (*Doze Mode/App Standby*) akibat indikasi bahaya suhu (*thermal runaway*).

---
---

# 🛑 PANDUAN PENYUSUNAN BAB METODE (WAJIB DIBACA)

Silakan salin teks **METODE** di atas (dari paragraf pertama sampai habis) ke dalam *file* Word Anda. Pastikan Anda memperhatikan aturan krusial dari JPIT ini:

### 1. Format Sub-Bab (Tingkat 2)
Aturan JPIT: Sub-bab (seperti A. Arsitektur, B. Algoritma, C. Mekanisme) harus dicetak **Miring (*Italic*)**. Huruf pertamanya kapital.
* **Benar:** *A. Arsitektur Sistem AI dan Native Bridge*
* **Salah:** A. ARSITEKTUR SISTEM AI DAN NATIVE BRIDGE

Saat menempelkannya ke Word, pastikan judul Sub-Bab A, B, dan C di atas Anda ubah menjadi miring (*Italic*).

### 2. Format Penulisan Rumus (Persamaan 1 & 2)
Aturan JPIT: Rumus harus menggunakan notasi standar (gunakan fitur `Insert` -> `Equation` di Word jika ingin terlihat lebih profesional, atau ketik manual saja). Rumus harus diberi nomor di ujung kanan dalam kurung `(1)`.
* Pastikan rumus menjorok ke tengah (*Center*).
* Pastikan nomor rumus `(1)` dan `(2)` rata ke arah kanan margin.

### 3. Pembuatan Gambar 1 (Pekerjaan Rumah untuk Anda / Marsha)
Di bagian `(Tempatkan Gambar 1 Di Sini)`, Anda atau Marsha harus membuat **satu gambar diagram/flowchart sederhana** (Bisa pakai *Visio*, *Canva*, atau *Draw.io*).
* **Isi Diagram (Bebas kreasi, yang penting logis):**
  Kotak [Kamera Monokuler] -> Panah -> Kotak [Kotlin Foreground Service (MediaPipe)] -> Panah -> Kotak [Algoritma Throttling & Triangle] -> Panah -> Kotak [Flutter UI (Blur Overlay)].
* **Aturan Gambar JPIT:**
  * Gambar harus dirujuk di dalam teks (Di paragraf atas sudah saya rujukan: *"Gambar 1 mengilustrasikan alur..."*). Jangan pakai kata "Gambar di bawah ini".
  * Gambar diletakkan di **Rata Tengah** (*Center*).
  * Judul gambar di bawah gambar, 8 pt, *Times New Roman*, tidak ditebalkan. (*Gambar 1. Arsitektur Komunikasi...*)
  * Gambar tidak boleh *blur* / pecah. Resolusi harus tinggi.

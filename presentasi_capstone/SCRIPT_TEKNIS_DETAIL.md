# 🧠 SCRIPT PRESENTASI: TEKNIS & ALUR ARSITEKTUR VISIONSAFE

*Dokumen ini dirancang khusus untuk sesi teknis atau tanya jawab (Q&A) dengan dosen penguji. Tetap menggunakan bahasa teknis (IT/Engineering), namun dijelaskan secara logis dan terstruktur.*

---

## 🏗️ 1. ALUR PEMBUATAN & ARSITEKTUR SISTEM (System Architecture)

"Secara arsitektur, **VisionSafe** bukan sekadar aplikasi Flutter biasa. Kami membangunnya menggunakan pendekatan **Hybrid-Native Architecture** dengan pemisahan tugas (*Separation of Concerns*) yang sangat ketat:

1. **Presentation Layer (Flutter & GetX):** 
   Seluruh UI, animasi 60 FPS, dan *State Management* (pengelolaan data lokal) di-handle oleh Flutter dengan pola arsitektur GetX. Ini membuat perpindahan layar sangat cepat.
2. **Native Background Service (Kotlin):** 
   Bagian paling krusial dari aplikasi ini—yaitu akses Kamera dan AI—ditulis murni menggunakan **Kotlin Native** yang berjalan sebagai *Foreground Service*. Artinya, meskipun anak keluar dari aplikasi VisionSafe untuk membuka YouTube atau TikTok, mesin AI kami tetap hidup di latar belakang tanpa dibunuh oleh OS Android.
3. **Backend & Big Data (Supabase Cloud):** 
   Untuk database, autentikasi (JWT), dan telemetri (rekam jejak kesehatan), kami menggunakan infrastruktur **Supabase**. Kami mendesain skema *Row Level Security (RLS)* di PostgreSQL agar data anak terisolasi dengan aman.

---

## ⚙️ 2. BAGAIMANA FITUR UTAMA BERJALAN? (Features Under the Hood)

Ada 3 pilar teknologi utama yang membuat aplikasi ini tahan banting:

### A. Smart Telemetry Rollup (Efisiensi Big Data)
Bayangkan jika AI mengirim data jarak mata setiap detik ke *database* Cloud. Tentu *server* akan jebol dan kuota internet pengguna habis. 
**Solusi Teknis:** Kami menerapkan algoritma *Local Aggregation*. Data jarak direkam per detik di *database* lokal (SQLite/Hive), lalu setiap 15 menit, algoritma akan menggabungkannya (*rollup*) menjadi 1 baris kesimpulan data sebelum dikirim ke Cloud Supabase. Ini menghemat *bandwidth* dan baterai hingga 95%.

### B. Thermal & Hardware Safety (Mencegah HP Panas/Lag)
Saat anak bermain *game* berat seperti Genshin Impact sambil diawasi VisionSafe, HP berisiko *overheat*.
**Solusi Teknis:** Kami menanamkan sensor suhu baterai (*BatteryManager API*). Jika suhu HP mencapai 42°C, sistem secara otomatis melakukan *Throttling*—menurunkan *frame rate* analisis AI dari 1 detik sekali menjadi 10 detik sekali. Jika HP diletakkan mendatar di atas meja (terdeteksi oleh *Accelerometer*), kamera langsung "tidur" sepenuhnya untuk menghemat daya.

---

## 🧮 3. BEDAH ALGORITMA: BAGAIMANA AI MENGHITUNG JARAK (The Math)

"Ini adalah bagian paling inti: Bagaimana mengubah gambar 2D dari kamera menjadi ukuran jarak 3D yang sangat presisi dalam hitungan sentimeter?

Kami menggunakan konsep gabungan antara **Computer Vision (MediaPipe)** dan **Trigonometri (Similar Triangles Theorem / Teorema Segitiga Sebangun)**.

Berikut adalah alur perhitungannya langkah demi langkah:

**Langkah 1: Ekstraksi Titik Wajah (Landmarking)**
Kamera menangkap *frame* wajah. Kami menggunakan *Google MediaPipe Face Mesh* untuk mendeteksi 468 titik kordinat wajah. Kami secara spesifik hanya mengambil koordinat titik pupil mata kiri dan pupil mata kanan.

**Langkah 2: Mencari Jarak Piksel (Perceived Width)**
Setelah mendapat titik X dan Y dari kedua mata, algoritma menghitung jarak antara kedua mata tersebut **di dalam layar (dalam satuan piksel)**. Kita sebut ini variabel $P$ (*Perceived Width*).

**Langkah 3: Konstanta Medis (Known Width)**
Secara medis, jarak rata-rata antara pupil mata manusia (Inter-Pupillary Distance / IPD) adalah angka yang cukup konstan. Untuk anak-anak hingga dewasa, rata-rata adalah **6.3 cm**. Kita sebut ini variabel $W$ (*Known Width*).

**Langkah 4: Kalibrasi Lensa (Focal Length)**
Setiap lensa HP berbeda-beda. Kami mencari nilai *Focal Length* kamera dalam satuan piksel (Variabel $F$). Nilai ini didapatkan saat pengguna pertama kali melakukan kalibrasi (menaruh HP di jarak 30cm, lalu sistem menyimpan nilai $F$-nya).

**Langkah 5: Perhitungan Akhir (Distance Formula)**
Setelah variabel $P$, $W$, dan $F$ didapat, sistem AI mengeksekusi rumus sakti *Similar Triangles* pada setiap kedipan *frame* (30 kali per detik):

### Rumus Jarak (Distance):
# $D = (W \times F) / P$

*Keterangan Teknis:*
* **$D$ (Jarak Asli ke Wajah):** Output yang kita cari (dalam cm).
* **$W$ (Jarak Antar Mata Asli):** ~6.3 cm.
* **$F$ (Focal Length):** Nilai kalibrasi lensa perangkat.
* **$P$ (Jarak Antar Mata di Piksel):** Didapat langsung secara *real-time* dari MediaPipe.

**Kesimpulan Logika Rumus:**
Karena ukuran mata manusia aslinya ($W$) selalu sama, maka jika wajah menjauh dari layar, jarak mata dalam piksel di layar ($P$) akan semakin **mengecil**. 
Dalam rumus pecahan, jika nilai Pembagi ($P$) mengecil, maka Hasilnya ($D$ / Jarak) akan semakin **besar**. 

Itulah mengapa tanpa memancarkan sinar laser atau sensor LiDAR sekalipun, algoritma *Computer Vision* dan matematika ini mampu mendeteksi jarak anak dengan akurasi sangat tinggi dan latensi sangat rendah."

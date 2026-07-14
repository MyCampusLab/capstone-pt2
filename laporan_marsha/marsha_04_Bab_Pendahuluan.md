# PENDAHULUAN

Peningkatan intensitas penggunaan perangkat bergerak (*mobile devices*) pada anak-anak usia prasekolah dan sekolah dasar telah memicu kekhawatiran global terhadap kesehatan mata. Studi klinis memproyeksikan bahwa pada tahun 2050, hampir setengah dari populasi dunia akan mengalami miopia (rabun jauh), dengan paparan layar jarak dekat sebagai salah satu faktor risiko lingkungan yang paling dominan [11], [12]. Paparan terus-menerus pada jarak kurang dari batas aman (biasanya 30-35 cm) secara signifikan mempercepat progresi miopia dan memicu Sindrom Ketegangan Mata Digital (*Digital Eye Strain*) [13]. Untuk memitigasi hal ini, intervensi perilaku secara proaktif diperlukan agar pengguna usia dini secara otomatis menjauhkan layar dari mata mereka.

Pemanfaatan kecerdasan buatan (*Artificial Intelligence*), khususnya cabang *Computer Vision*, telah membuka jalan untuk melakukan estimasi jarak pandang secara *real-time* menggunakan kamera monokuler konvensional pada ponsel pintar. Pendekatan sebelumnya telah mencoba menggunakan algoritma pemrosesan citra untuk mendeteksi jarak wajah pengguna ke layar [4], [5], [6]. Salah satu teknologi pendorong utama dalam ekstraksi fitur wajah modern adalah MediaPipe, sebuah kerangka kerja berbasis *machine learning* yang mampu memetakan 478 titik koordinat wajah (*Face Mesh*) secara tiga dimensi dalam waktu kurang dari 20 milidetik [1], [2], [3]. Penggunaan MediaPipe pada platform *mobile* memungkinkan ekstraksi metrik wajah secara instan tanpa perlu memproses data di komputasi awan (*cloud*), sehingga menjaga privasi pengguna.

Meskipun model *Computer Vision* terapan telah terbukti akurat, implementasi praktisnya pada aplikasi perlindungan mata yang menuntut pengawasan 24 jam penuh memunculkan persoalan teknis baru. Pemrosesan inferensi AI *real-time* secara kontinu sangat membebani unit pemrosesan pusat (CPU) dan unit pemrosesan grafis (GPU) pada perangkat seluler. Beban komputasi yang tinggi ini berbanding lurus dengan peningkatan konsumsi daya baterai dan pelepasan suhu panas ekstrem (*overheating*) [8], [9]. Sistem operasi Android modern secara agresif akan membunuh paksa layanan latar belakang (*background service*) yang memonopoli sumber daya keras demi melindungi suhu perangkat keras dan masa pakai baterai [10], [14]. Akibatnya, aplikasi pelindung mata berbasis AI yang saat ini tersedia secara komersial sering kali gagal beroperasi secara persisten di latar belakang [15], [16].

Penelitian ini bertujuan untuk merancang dan mengimplementasikan sebuah sistem pemantauan jarak pandang berbasis AI yang tidak hanya akurat secara matematis, tetapi juga efisien dan aman secara arsitektur perangkat keras. Sistem yang dikembangkan dalam penelitian ini memanfaatkan kerangka MediaPipe dengan mengimplementasikan algoritma *Triangle Similarity* berdasarkan model *Pinhole Camera* untuk mengekstraksi jarak absolut dalam satuan sentimeter. Selain itu, untuk menutupi kesenjangan penelitian sebelumnya terkait efisiensi daya layanan latar belakang, penelitian ini memperkenalkan kebaruan (*novelty*) berupa implementasi algoritma *Dynamic Thermal Throttling*. Algoritma ini berjalan di dalam *Kotlin Native Foreground Service* yang secara dinamis memonitor suhu baterai perangkat, lalu menurunkan laju kecepatan deteksi bingkai (FPS) secara otomatis saat perangkat menyentuh suhu kritis, guna mencegah penghentian proses oleh sistem operasi.

Fokus pengujian dari penelitian ini adalah mengukur tingkat akurasi matematis dari estimasi jarak pandang AI serta mengevaluasi aspek Efisiensi Kinerja (*Performance Efficiency*) dari standar kualitas perangkat lunak ISO/IEC 25010 [17], [18], [19]. Evaluasi difokuskan pada kemampuan algoritma manajemen suhu (*thermal throttling*) dalam menjaga stabilitas sistem saat model kecerdasan buatan dieksekusi terus-menerus, tanpa merusak atau memperpendek usia perangkat keras ponsel pengguna.

---
---

# 🛑 PANDUAN PENYUSUNAN & FORMATTING (WAJIB DIBACA)

Agar jurnal Anda tidak terkena *Desk Rejection* (ditolak tanpa dibaca oleh Editor JPIT), pastikan Anda mengatur Microsoft Word Anda **SEBELUM** menyalin teks di atas. Berikut adalah aturan mutlak dari *Template* JPIT 2024:

### 1. Pengaturan Halaman (Page Setup)
* **Ukuran Kertas:** A4 (Lebar 21 cm x Panjang 29,7 cm). BUKAN *Letter* atau F4.
* **Kolom:** 1 Kolom (Bukan format 2 kolom seperti jurnal IEEE pada umumnya).
* **Margin (Batas Tepi):** 
  * Atas (*Top*) = 2,25 cm
  * Bawah (*Bottom*) = 2,25 cm
  * Kiri (*Left*) = 2,5 cm
  * Kanan (*Right*) = 2,0 cm

### 2. Pengaturan Teks (Font & Paragraf)
* **Jenis Huruf:** Wajib **Times New Roman**.
* **Ukuran Huruf:** 
  * Judul Makalah: 16 pt
  * Teks Paragraf Biasa: **10 pt**
  * Judul Bab (misal: PENDAHULUAN): 10 pt (Small Caps)
* **Spasi Baris (*Line Spacing*):** Tunggal (*Single*).
* **Spasi Antar Paragraf (*Spacing Before/After*):** 0 pt. (Tidak boleh ada jarak kosong antar paragraf dalam satu bab).
* **Perataan Teks (*Alignment*):** *Justified* (Rata Kiri Kanan).
* **Indentasi Awal Paragraf (*First Line Indent*):** Setiap awal paragraf wajib menjorok ke dalam (Gunakan tombol `Tab` atau atur *First Line Indent* di penggaris Word). Jangan gunakan spasi berkali-kali!

---

# 🛑 PANDUAN NAVIGASI SITASI MENDELEY

Setelah halaman Word Anda berformat sesuai panduan di atas, ikuti langkah berikut untuk menyalin teks dan memasukkan referensi Mendeley:

**Cara Pakai:**
1. Salin seluruh draf PENDAHULUAN di atas (hanya isi teksnya) ke Microsoft Word Anda.
2. Hapus teks `[11], [12]` manual bawaan dari teks.
3. Klik tab **References** di Word -> Klik **Mendeley Cite** (Atau Insert Citation).
4. Ketikkan kata kunci di bawah ini satu per satu, pilih jurnalnya, lalu tekan Enter. 

### Pemetaan Paragraf 1 (Kesehatan Mata):
* Teks Asli: `...faktor risiko lingkungan yang paling dominan [11], [12].`
  * **Ketik di Zotero:** `Holden` (Pilih: *Global Prevalence of Myopia...*)
  * **Ketik di Zotero:** `Sheppard` (Pilih: *Digital Eye Strain...*)
* Teks Asli: `...dan memicu Sindrom Ketegangan Mata Digital [13].`
  * **Ketik di Zotero:** `McBride` (Pilih: *The Impact of Screen Proximity...*)

### Pemetaan Paragraf 2 (AI & Computer Vision):
* Teks Asli: `...mendeteksi jarak wajah pengguna ke layar [4], [5], [6].`
  * **Ketik di Zotero:** `Budi Distance`
  * **Ketik di Zotero:** `Lee Eye`
  * **Ketik di Zotero:** `Nugroho 3D`
* Teks Asli: `...waktu kurang dari 20 milidetik [1], [2], [3].`
  * **Ketik di Zotero:** `Lugaresi`
  * **Ketik di Zotero:** `Kartynnik`
  * **Ketik di Zotero:** `Google MediaPipe Face`

### Pemetaan Paragraf 3 (Masalah Baterai & Overheating):
* Teks Asli: `...peningkatan konsumsi daya baterai dan pelepasan suhu panas ekstrem [8], [9].`
  * **Ketik di Zotero:** `Wang Energy`
  * **Ketik di Zotero:** `Liu Thermal`
* Teks Asli: `...demi melindungi suhu perangkat keras dan masa pakai baterai [10], [14].`
  * **Ketik di Zotero:** `Park Mitigating`
  * **Ketik di Zotero:** `Android Foreground`
* Teks Asli: `...gagal beroperasi secara persisten di latar belakang [15], [16].`
  * **Ketik di Zotero:** `Li Performance`
  * **Ketik di Zotero:** `Kim Architecting`

### Pemetaan Paragraf 5 (Evaluasi Kinerja ISO):
* Teks Asli: `...standar kualitas perangkat lunak ISO/IEC 25010 [17], [18], [19].`
  * **Ketik di Zotero:** `iso25010_2011_marsha`
  * **Ketik di Zotero:** `Morales`
  * **Ketik di Zotero:** `Singh Metrics`

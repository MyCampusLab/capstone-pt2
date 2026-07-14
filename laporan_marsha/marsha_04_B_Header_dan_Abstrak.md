# PANDUAN MENGISI HEADER & ABSTRAK JURNAL JPIT

Jangan sentuh bagian ini: `Jurnal Informatika: Jurnal pengembangan IT...` dan `Riwayat Artikel: Received...`. Biarkan teks aslinya, karena itu urusan Editor JPIT nanti.

Tugas Anda hanya mengganti teks (*copy-paste*) pada bagian-bagian di bawah ini sesuai dengan urutan di dalam dokumen Microsoft Word Anda.

---

### 1. JUDUL MAKALAH (Title)
**Aturan:** 16 pt, Times New Roman, Rata Tengah, Capitalize Each Word (Maks 20 Kata).

**Teks yang disalin:**
Implementasi Algoritma Triangle Similarity dan Dynamic Thermal Throttling pada Aplikasi Pemantau Jarak Pandang Berbasis AI

---

### 2. PENULIS & AFILIASI
**Aturan:** Nama penulis (10 pt), Afiliasi (8 pt, *Italic*), Email (9 pt, *Courier*). Tidak boleh ada gelar akademik.

**Teks yang disalin:**
Berliani Risqi Dwi Saputri 1, [Nama Dosen Pembimbing] 2
1,2 Program Studi Teknik Informatika, Politeknik Harapan Bersama, Indonesia
berlianirisqi@email.com, dosenkalian@email.com

*(Catatan: Ganti teks di dalam kurung siku dengan nama dosen pembimbing Anda tanpa gelar ST., M.Kom)*

---

### 3. INFO CORRESPONDING AUTHOR
**Teks yang disalin:**
**Corresponding Author:**
[Nama Dosen Pembimbing atau Nama Berliani]
Email: [Email yang aktif]

---

### 4. ABSTRACT (BAHASA INGGRIS)
**Aturan:** 1 Paragraf, 160-250 kata. Semua huruf dicetak Miring (*Italic*). Rata Kiri-Kanan (*Justified*). Ukuran Font 8 pt, Spasi Tunggal. TIDAK BOLEH ADA SITASI [1].

**Teks yang disalin:**
*The surge in pediatric myopia cases due to excessive mobile device usage demands real-time viewing distance monitoring solutions; however, the continuous execution of artificial intelligence on mobile devices triggers severe overheating and rapid battery depletion. This research aims to implement a viewing distance detection algorithm that is clinically safe for ocular health and architecturally resilient on hardware. The methodology involves integrating the MediaPipe framework to map a three-dimensional Face Mesh, applying the Triangle Similarity algorithm and Pinhole Camera model for absolute distance calculation, and engineering a Kotlin Native Foreground Service equipped with a Dynamic Thermal Throttling algorithm to regulate frame detection speed (FPS) based on hardware temperature. The results demonstrate that the system accurately estimates viewing distance and successfully applies visual interventions (blur overlay) instantly when the 35 cm safety threshold is breached. Furthermore, the throttling mechanism effectively maintains battery temperature below the 42°C critical threshold by dynamically decelerating the FPS from 1 Hz to 0.1 Hz, ensuring the background artificial intelligence service is not forcefully terminated by the Android operating system. It is concluded that the amalgamation of applied Computer Vision and dynamic thermal management produces a precise, responsive, and energy-efficient child eye protection application.*

**Keywords:** *Computer Vision; Dynamic Thermal Throttling; MediaPipe; Myopia; Triangle Similarity*

---

### 5. ABSTRAK (BAHASA INDONESIA)
**Aturan:** Sama seperti bahasa Inggris, tapi TIDAK dicetak miring (Teks Reguler/Biasa). Ukuran Font 8 pt, Spasi Tunggal.

**Teks yang disalin:**
Lonjakan kasus miopia pada anak akibat penggunaan gawai menuntut adanya solusi pemantauan jarak pandang secara *real-time*, namun eksekusi kecerdasan buatan secara terus-menerus pada perangkat seluler memicu masalah panas berlebih (*overheating*) dan pengurasan baterai. Penelitian ini bertujuan untuk mengimplementasikan algoritma pendeteksi jarak pandang yang aman bagi kesehatan mata sekaligus tangguh secara arsitektur perangkat keras. Metodologi yang digunakan mencakup integrasi kerangka kerja MediaPipe untuk memetakan *Face Mesh* tiga dimensi, penerapan algoritma *Triangle Similarity* dan model kamera lubang jarum (*Pinhole Camera*) untuk kalkulasi jarak absolut, serta rekayasa *Kotlin Native Foreground Service* yang dilengkapi algoritma *Dynamic Thermal Throttling* untuk mengatur laju deteksi bingkai (FPS) berdasarkan suhu perangkat. Hasil pengujian menunjukkan sistem mampu mengestimasi jarak secara akurat dan melakukan intervensi visual (*blur*) seketika saat batas aman 35 cm dilanggar. Lebih lanjut, mekanisme *throttling* terbukti efektif menahan suhu baterai di bawah ambang batas kritis 42°C dengan menurunkan FPS dari 1 Hz menjadi 0,1 Hz, memastikan layanan kecerdasan buatan tidak dihentikan secara paksa oleh sistem operasi Android. Disimpulkan bahwa penggabungan pemrosesan *Computer Vision* terapan dan manajemen suhu dinamis menghasilkan aplikasi perlindungan mata anak yang presisi, responsif, dan hemat daya.

**Kata Kunci:** Computer Vision; Dynamic Thermal Throttling; MediaPipe; Myopia; Triangle Similarity

# Phase 3: Paper Blueprint (Marsha's JPIT Article)

Kerangka penulisan ini mematuhi secara mutlak aturan *Template* JPIT 2024 (Spasi tunggal, tanpa sub-bab di Pendahuluan, penamaan tabel/gambar kapital *Small Caps*, dsb).

## 1. Meta Information
* **Usulan Judul:** Implementasi Algoritma *Triangle Similarity* dan *Dynamic Thermal Throttling* pada Aplikasi Pemantau Jarak Pandang Berbasis AI
* **Penulis:** Berliani Risqi Dwi Saputri (Marsha), [Dosen Pembimbing]
* **Target Kata:** 3500 - 7500 kata (7-15 halaman).

## 2. Abstract & Abstrak
* **Struktur:** Satu paragraf (160-250 kata). 
  - (1) Masalah: Lonjakan kasus miopia anak akibat *gadget* dan kendala *overheating* saat menjalankan AI *Computer Vision* secara terus-menerus di *smartphone*.
  - (2) Tujuan: Mengembangkan aplikasi pemantau jarak berbasis MediaPipe dengan efisiensi daya tinggi.
  - (3) Metode: Integrasi *Face Landmarker*, kalkulasi jarak *Triangle Similarity*, dan algoritma *Thermal Throttling* pada *Kotlin Foreground Service*.
  - (4) Temuan: Sistem mampu mengintervensi (*blur*) layar secara *real-time* saat jarak tidak aman, serta secara dinamis menurunkan laju *frame* (FPS) saat suhu kritis (42°C) untuk mencegah *crash* sistem.
  - (5) Simpulan.
* **Kata Kunci:** *Computer Vision*; MediaPipe; *Myopia*; *Thermal Throttling*; *Triangle Similarity*.

## 3. PENDAHULUAN
* **Tujuan:** Menyatukan latar belakang medis, teknis, dan kajian pustaka tanpa membuat sub-bab.
* **Alur Cerita (Narasi):**
  1. *Medical urgency:* Bahaya jarak pandang terlalu dekat (Ref [11], [12], [13]).
  2. *Technological solution:* Penggunaan kamera depan dan AI untuk mendeteksi jarak (Ref [3], [5], [6]).
  3. *The Big Problem (Gap):* AI seperti MediaPipe sangat memakan daya GPU/CPU. Jika dijalankan 24 jam di Android, OS akan menghentikannya paksa (*Doze Mode*) atau membuat HP meledak/sangat panas (Ref [8], [9], [10]).
  4. *The Novelty:* VisionSafe hadir dengan solusi Arsitektur *Native Background* yang dilengkapi sensor suhu. Jika suhu HP naik, AI melambat secara cerdas; jika aman, AI ngebut kembali.
* **Referensi Minimum:** 10 kutipan IEEE untuk membangun argumen kuat.

## 4. METODE
* **Tujuan:** Menjelaskan rekayasa perangkat lunak secara transparan dan bisa direproduksi (*reproducible*).
* **Isi Konten:**
  - **A. Arsitektur Sistem AI:** Diagram komunikasi antara Flutter UI dan Kotlin Native (EventChannels).
  - **B. Algoritma Kalkulasi Jarak:** Pemaparan rumus Geometri (Pinhole Camera) & Teorema Pythagoras 3D (*Z-axis compensation*). Menampilkan Rumus 1 dan Rumus 2 sesuai format penulisan rumus JPIT.
  - **C. Mekanisme Dynamic Thermal Throttling:** Penjelasan logika kondisional membaca `BatteryManager.EXTRA_TEMPERATURE` untuk mengatur ambang batas FPS deteksi (1 detik vs 10 detik).
* **Kebutuhan Visual:** 
  - *Gambar 1. Arsitektur Komunikasi Native dan Flutter.*

## 5. HASIL DAN PEMBAHASAN
* **Tujuan:** Membuktikan bahwa algoritma di Bab Metode benar-benar berfungsi dan tidak sekadar teori.
* **Isi Konten:**
  - **A. Akurasi Estimasi Jarak Pandang:** Membandingkan jarak aktual (diukur pakai penggaris/meteran) dengan jarak kalkulasi AI di layar (Tabel Deviasi).
  - **B. Evaluasi Keamanan Perangkat (Thermal State):** Membahas bagaimana sistem sukses mempertahankan suhu perangkat Android tidak melebihi ambang batas kritis (42°C) meski digunakan berjam-jam (Bukti dari metrik efisiensi).
  - **C. Respons Intervensi (Blur Overlay):** Menguji kecepatan sistem memunculkan efek *blur* saat anak melanggar jarak (kurang dari 35 cm) selama 1.5 detik.
* **Kebutuhan Visual:** 
  - *TABEL 1. Hasil Pengujian Akurasi Jarak Pandang.*
  - *TABEL 2. Dampak Algoritma Thermal Throttling pada Suhu Perangkat.*
  - *Gambar 2. Cuplikan Layar Saat Intervensi Blur Aktif.*

## 6. SIMPULAN
* **Tujuan:** Ditulis mutlak hanya 1 paragraf (Aturan JPIT).
* **Isi:** Menegaskan bahwa perpaduan MediaPipe, *Triangle Similarity*, dan manajemen suhu cerdas (*Thermal Throttling*) sukses menciptakan aplikasi pelindung mata anak yang akurat secara medis dan tangguh secara *hardware*.

## 7. DAFTAR PUSTAKA
* Akan menggunakan ke-20 referensi ilmiah dari `marsha_references.bib` yang dicetak sesuai format IEEE (ukuran font 8pt).

---
*Blueprint for Marsha validated against JPIT 2024 Template Guidelines by VisionSafe JPIT Research Agent v1.0.*

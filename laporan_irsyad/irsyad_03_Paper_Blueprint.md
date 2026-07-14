# Phase 3: Paper Blueprint (Irsyad's JPIT Article)

Kerangka penulisan ini mematuhi secara mutlak aturan *Template* JPIT 2024. Belajar dari evaluasi jurnal sebelumnya, kerangka ini dirancang sejak awal dengan bahasa yang sangat kaku, formal, dan murni akademis, tanpa sedikit pun celah tata bahasa non-baku.

## 1. Meta Information
* **Usulan Judul:** Arsitektur Sinkronisasi Telemetri Agregatif dan Implementasi *Row Level Security* (RLS) pada Platform *Backend-as-a-Service*
* **Penulis:** Muhammad Irsyad (Penulis Pertama), [Dosen Pembimbing] (Penulis Kedua)
* **Target Kata:** 3500 - 7500 kata (7-15 halaman).

## 2. Abstract & Abstrak
* **Struktur Abstrak (1 Paragraf, 160-250 kata):**
  - (1) **Masalah:** Lonjakan volume data telemetri kesehatan pada aplikasi *mobile* memicu pembengkakan biaya peladen (*server*) dan risiko kebocoran privasi data anak pada basis data multi-penyewa (*multi-tenant*).
  - (2) **Tujuan:** Mengimplementasikan arsitektur *Backend-as-a-Service* (BaaS) yang efisien dalam mengelola data dalam skala besar (*Big Data*) sekaligus terisolasi secara kriptografis.
  - (3) **Metode:** Menerapkan algoritma *Smart Telemetry Rollup* untuk mengagregasi 12 log aktivitas lokal menjadi 1 baris transmisi, serta mengimplementasikan *Row Level Security* (RLS) berbasis *JSON Web Token* (JWT) pada basis data PostgreSQL (Supabase) untuk membatasi akses data lintas peran (Orang Tua dan Anak).
  - (4) **Temuan:** Algoritma agregasi terbukti berhasil memangkas frekuensi panggilan API (*API Calls*) hingga lebih dari 90%, mengoptimalkan efisiensi *bandwidth*. Pengujian penetrasi RLS mengonfirmasi isolasi data absolut; kredensial anak tidak dapat memanipulasi maupun membaca rekaman telemetri grup keluarga lain. 
  - (5) **Simpulan.**
* **Kata Kunci:** *Backend-as-a-Service; Big Data Aggregation; Row Level Security; Supabase; Telemetry*.

## 3. PENDAHULUAN
* **Alur Cerita (Narasi Deduktif & Formal):**
  1. *The Shift to Cloud:* Pergeseran pengembangan aplikasi kesehatan bergerak (*mHealth*) menuju infrastruktur *Backend-as-a-Service* (BaaS) (Ref [1], [2], [3]).
  2. *The Data Cost Problem:* Tantangan utama BaaS adalah manajemen telemetri sinkron. Pengiriman data secara kontinu setiap detik memicu *bottleneck* jaringan, menghabiskan kuota *Rate-Limiting*, dan menggelembungkan biaya penyimpanan (*Storage Costs*) (Ref [8], [9], [11]).
  3. *The Security Gap:* Masalah kedua adalah privasi. Banyak aplikasi gagal mengimplementasikan kontrol akses butir-halus (*fine-grained access control*), sehingga rentan terhadap eskalasi hak istimewa (*Privilege Escalation*) (Ref [4], [6], [16]).
  4. *The Novelty:* Solusi yang ditawarkan adalah arsitektur hibrida: Agregasi Log Lokal (Klien) dipadukan dengan kebijakan RLS absolut (Peladen/PostgreSQL), dievaluasi menggunakan standar efisiensi jaringan ISO/IEC 25010 (Ref [17], [18], [19]).
* **Kepatuhan JPIT:** Tanpa sub-bab, 10-15 sitasi format IEEE.

## 4. METODE
* **Isi Konten:**
  - **A. Arsitektur Sinkronisasi Backend-as-a-Service:** Diagram alur aliran data dari SQLite (Lokal) -> Edge Function -> Supabase PostgreSQL.
  - **B. Algoritma Smart Telemetry Rollup:** Penjelasan matematis/logika di mana aplikasi menahan *insert* log setiap 5 detik. Log disatukan (*batching*) menjadi 1 paket berdurasi 60 detik, dan baru disinkronisasi ke *Cloud* setiap 15 menit menggunakan prokol HTTP.
  - **C. Kebijakan Row Level Security (RLS):** Pemaparan skrip relasional (*SQL Policy*) yang memverifikasi ekstensi `auth.uid()` di dalam *payload* JWT, memastikan pengguna hanya berinteraksi dengan baris data (`receiver_id` atau `user_id`) milik mereka sendiri. Membahas *WebSocket throttling* pada fitur *Nudge*.
* **Kebutuhan Visual JPIT:** 
  - *Gambar 1. Topologi Arsitektur Klien-Peladen dan Kebijakan RLS.* (Disediakan di tengah halaman).

## 5. HASIL DAN PEMBAHASAN
* **Isi Konten (Pengujian Objektif):**
  - **A. Evaluasi Efisiensi Bandwidth dan API Calls:** Komparasi volume data. (Tabel perbandingan sistem sebelum *Rollup* vs sesudah *Rollup* dalam 1 jam penggunaan). Pembuktian efisiensi ISO 25010.
  - **B. Pengujian Isolasi Data (Keamanan RLS):** Tabel Matriks Akses. Membuktikan bahwa skenario *Black-Box* (Anak mencoba menghapus grup keluarga, atau mengakses data *User* B) mengembalikan *HTTP Status 403 (Forbidden)* atau set kosong.
  - **C. Performa Real-Time WebSockets:** Evaluasi kecepatan masuknya notifikasi teguran (*Nudge*) menggunakan *Stream* tersaring (`eq('receiver_id')`).
* **Kebutuhan Visual JPIT:** 
  - *TABEL 1. Komparasi Konsumsi API Calls dan Bandwidth.* (Tanpa garis vertikal).
  - *TABEL 2. Matriks Pengujian Penetrasi Hak Akses (RLS).*

## 6. SIMPULAN
* Ditulis mutlak hanya **1 paragraf**. 
* Merangkum metrik penghematan panggilan API (*API Calls reduction rate*) dan tingkat keberhasilan isolasi basis data, membuktikan bahwa aplikasi tidak hanya aman digunakan oleh anak di bawah umur tetapi juga sangat murah untuk dikelola secara operasional oleh *developer*.

## 7. DAFTAR PUSTAKA
* Akan menggunakan ke-20 referensi ilmiah dari `irsyad_references.bib` yang dicetak sesuai format IEEE (ukuran font 8pt) menggunakan Zotero.

---
*Blueprint for Irsyad validated against JPIT 2024 Template Guidelines by VisionSafe JPIT Research Agent v2.0 (Strict Mode).*

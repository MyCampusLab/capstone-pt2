# PANDUAN MENGISI HEADER & ABSTRAK JURNAL JPIT (IRSYAD)

Jangan sentuh bagian ini: `Jurnal Informatika: Jurnal pengembangan IT...` dan `Riwayat Artikel: Received...`. Biarkan teks aslinya (itu urusan Editor).

Salin teks di bawah ini secara persis ke dalam *template* Word Anda.

---

### 1. JUDUL MAKALAH (Title)
**Aturan:** 16 pt, Times New Roman, Rata Tengah, Capitalize Each Word (Maks 20 Kata).

**Teks yang disalin:**
Arsitektur Sinkronisasi Telemetri Agregatif dan Implementasi Row Level Security (RLS) pada Platform Backend-as-a-Service

---

### 2. PENULIS & AFILIASI
**Aturan:** Nama penulis (10 pt), Afiliasi (8 pt, *Italic*), Email (9 pt, *Courier*). Tanpa gelar akademik.

**Teks yang disalin:**
Muhammad Irsyad 1, [Nama Dosen Pembimbing] 2
1,2 Program Studi Teknik Informatika, Politeknik Harapan Bersama, Indonesia
irsyad@email.com, dosenkalian@email.com

*(Catatan: Ganti email dan nama di dalam kurung siku dengan data asli)*

---

### 3. INFO CORRESPONDING AUTHOR
**Teks yang disalin:**
**Corresponding Author:**
[Nama Dosen Pembimbing atau Nama Anda]
Email: [Email yang aktif]

---

### 4. ABSTRACT (BAHASA INGGRIS)
**Aturan:** 1 Paragraf, 160-250 kata. Huruf Miring (*Italic*). Rata Kiri-Kanan (*Justified*). Font 8 pt, Spasi Tunggal. Bebas dari sitasi [1].

**Teks yang disalin:**
*The exponential growth of continuous health telemetry data in mobile applications precipitates server cost inflation and exposes pediatric privacy vulnerabilities within multi-tenant databases. This research aims to engineer a highly scalable Backend-as-a-Service (BaaS) architecture that effectively manages big data telemetry streams while ensuring cryptographic data isolation. The proposed methodology introduces a Smart Telemetry Rollup algorithm deployed on the client edge, compressing twelve localized interaction logs into a unified payload prior to transmitting via intermittent synchronization every fifteen minutes. Furthermore, robust data privacy is established by implementing Row Level Security (RLS) policies driven by JSON Web Token (JWT) on a PostgreSQL database, explicitly restricting access across distinct familial roles. The evaluation demonstrates that the aggregative algorithm successfully curtails network bandwidth consumption and Application Programming Interface (API) call frequencies by more than ninety percent, securing operational cost-efficiency. Concurrently, penetration testing on the RLS policies confirms absolute data isolation, where unauthorized privilege escalation attempts yield complete access denial (HTTP 403 Forbidden). It is concluded that the amalgamation of client-side data batching and stringent database-level security engenders an operationally economical and impregnable mobile health ecosystem for pediatric surveillance.*

**Keywords:** *Backend-as-a-Service; Big Data Aggregation; Row Level Security; Supabase; Telemetry*

---

### 5. ABSTRAK (BAHASA INDONESIA)
**Aturan:** 1 Paragraf. TIDAK dicetak miring (Teks Reguler). Font 8 pt, Spasi Tunggal. Rata Kiri-Kanan.

**Teks yang disalin:**
Pertumbuhan eksponensial data telemetri kesehatan yang kontinu pada aplikasi bergerak memicu pembengkakan biaya peladen dan mengekspos kerentanan privasi pediatrik di dalam basis data penyewa ganda (*multi-tenant*). Penelitian ini bertujuan untuk merekayasa arsitektur *Backend-as-a-Service* (BaaS) dengan skalabilitas tinggi yang efektif dalam mengelola aliran data raksasa sekaligus menjamin isolasi data secara kriptografis. Metodologi yang diusulkan memperkenalkan algoritma agregasi *Smart Telemetry Rollup* pada sisi klien (*edge*), yang mengompresi dua belas log interaksi lokal ke dalam satu muatan terpadu sebelum dikirim melalui sinkronisasi berkala setiap lima belas menit. Selain itu, privasi data tingkat tinggi dibangun dengan mengimplementasikan kebijakan *Row Level Security* (RLS) berbasis *JSON Web Token* (JWT) pada basis data PostgreSQL, yang membatasi akses secara eksplisit antar peran keluarga yang berbeda. Hasil evaluasi menunjukkan bahwa algoritma agregatif sukses memangkas konsumsi *bandwidth* jaringan dan frekuensi pemanggilan antarmuka pemrograman aplikasi (API) hingga lebih dari sembilan puluh persen, mengamankan efisiensi biaya operasional. Bersamaan dengan itu, pengujian penetrasi pada kebijakan RLS mengonfirmasi isolasi data absolut, di mana upaya eskalasi hak istimewa (*privilege escalation*) yang tidak sah sepenuhnya ditolak (*HTTP 403 Forbidden*). Disimpulkan bahwa penggabungan pemrosesan klaster data di sisi klien dan keamanan tingkat basis data yang ketat menghasilkan ekosistem aplikasi kesehatan bergerak yang ekonomis secara operasional dan tangguh untuk pengawasan anak.

**Kata Kunci:** Backend-as-a-Service; Big Data Aggregation; Row Level Security; Supabase; Telemetry

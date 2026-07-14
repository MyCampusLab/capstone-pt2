# METODE

Penelitian ini mengadopsi kerangka kerja Rekayasa Perangkat Lunak Berbasis Komputasi Awan (*Cloud-Native Software Engineering*). Fokus penelitian dialokasikan pada pengembangan arsitektur peladen tak berwujud (*serverless*) menggunakan *Backend-as-a-Service* (BaaS) Supabase, yang mengelola basis data relasional PostgreSQL. Sistem ini diintegrasikan dengan klien antarmuka seluler berbasis *Flutter* yang memanfaatkan paket manajemen status asinkron untuk operasi sinkronisasi data lintas perangkat.

## A. Arsitektur Sinkronisasi Backend-as-a-Service
Sistem pengawasan jarak pandang (*Family Squad*) dirancang menggunakan arsitektur tersinkronisasi asinkron. Data tidak dikirim secara konstan, melainkan ditampung sementara pada lapisan repositori lokal di perangkat pengguna (*Edge Storage*) menggunakan basis data SQLite. Diagram pada Gambar 1 mengilustrasikan rute perjalanan data telemetri: berawal dari modul pemantau jarak lokal klien, melalui antarmuka REST API, hingga bermuara ke tabel `telemetry_logs` di dalam *Cloud* PostgreSQL. Komunikasi *real-time* dua arah untuk fitur teguran (*Nudge*) ditangani melalui jalur terpisah menggunakan protokol *WebSockets*.

*(Tempatkan Gambar 1 Di Sini)*
*Gambar 1. Arsitektur Komunikasi Sinkronisasi Telemetri dan WebSockets pada Platform BaaS*

## B. Algoritma Smart Telemetry Rollup
Pendekatan sinkronisasi konvensional secara membabi buta (*polling/streaming* konstan) pada aplikasi kesehatan akan menghasilkan jutaan rekaman baris data tak bermakna dalam hitungan hari. Untuk mengamankan skalabilitas operasi dan menekan rasio *API Calls*, penelitian ini mengimplementasikan algoritma agregasi proaktif yang dinamakan *Smart Telemetry Rollup*. 

Alih-alih mengirim log ke *Cloud* setiap kali sistem membaca jarak wajah (setiap 5 detik), klien Flutter dikonfigurasi untuk melakukan penumpukan (*batching*) secara internal. Algoritma akan menghitung frekuensi status aman dan tidak aman selama durasi 60 detik (setara dengan 12 *event* pemantauan), lalu memadatkan kedua belas peristiwa tersebut ke dalam 1 baris objek JSON. Struktur muatan (*payload*) ini tidak lagi mencatat jarak mentah, melainkan merangkum total durasi sesi, agregasi insiden pelanggaran, dan waktu rekaman (*timestamp*). Objek yang telah teragregasi ini ditahan di ruang antrean (*Queue*), dan hanya diunggah ke peladen secara borongan setiap 15 menit menggunakan operasi penyisipan massal (*bulk insert*) *PostgREST*. Mekanisme rasionalisasi data ini dirancang untuk memangkas *bandwidth* keluar (*outbound bandwidth*) hingga 90% secara matematis tanpa menghilangkan konteks kepatuhan pengguna.

## C. Implementasi Row Level Security (RLS) dan Real-time WebSockets
Dalam ekosistem aplikasi penyewa ganda (*multi-tenant*), membiarkan klien menjalankan kueri SQL secara terbuka adalah celah fatal. Penelitian ini menggunakan kebijakan *Row Level Security* (RLS) murni pada lapisan basis data PostgreSQL untuk menjamin kerahasiaan (*confidentiality*) dan integritas (*integrity*) data lintas keluarga. Autentikasi dikendalikan oleh *JSON Web Token* (JWT). Setiap kueri pembacaan (`SELECT`) atau penulisan (`INSERT`) diintersep oleh mesin basis data, yang kemudian memverifikasi nilai klaim `auth.uid()` di dalam *header* HTTP. 

Kebijakan SQL berikut ditanamkan ke dalam tabel `groups` dan `telemetry_logs` untuk menjamin bahwa anak (*role: Child*) hanya bisa memasukkan data telemetri milik dirinya sendiri, sementara agen pengawas (*role: Supervisor*) hanya dapat mengakses data anggota yang secara eksplisit telah memvalidasi kode undangan (*Invite Code*) khusus:

`CREATE POLICY "Isolasi Data Keluarga" ON telemetry_logs FOR SELECT USING (auth.uid() = user_id OR auth.uid() IN (SELECT supervisor_id FROM group_members WHERE member_id = telemetry_logs.user_id));`

Selanjutnya, untuk mekanisme komunikasi instan (Teguran/ *Nudge*), lalu lintas *Real-Time WebSockets* disaring sejak dari hulu (*Server-side Filtering*). *Listener* klien hanya berlangganan saluran (*channel*) perubahan di mana kolom `receiver_id` bernilai identik dengan UUID JWT milik mereka sendiri, serta memberikan waktu penahanan (*cooldown*) selama 60 detik untuk memblokir indikasi serangan *spam* antar klien.

---
---

# 🛑 PANDUAN PENYUSUNAN BAB METODE IRSYAD

Silakan salin teks **METODE** di atas ke dalam *file* Word JPIT Anda. Perhatikan aturan ketat berikut:

### 1. Format Sub-Bab (Tingkat 2)
Sub-bab (A, B, dan C) harus dicetak **Miring (*Italic*)** di Word. Huruf pertamanya kapital.
* **Benar:** *A. Arsitektur Sinkronisasi Backend-as-a-Service*
* **Salah:** A. ARSITEKTUR SINKRONISASI BACKEND-AS-A-SERVICE

### 2. Format Penulisan Kode SQL (Di Sub-Bab C)
Di Sub-Bab C, saya menyertakan satu blok kueri/kode SQL asli dari Supabase (`CREATE POLICY...`). 
* Aturan Jurnal Ilmiah IT: Teks kode (*Source Code*) **WAJIB** menggunakan font khusus kode (Biasanya **Courier New**, ukuran 9pt).
* Jangan gunakan Times New Roman untuk sebaris teks kode SQL tersebut agar dosen penguji tahu itu adalah sintaks murni.

### 3. Pembuatan Gambar 1 (Pekerjaan Rumah Anda)
Di bagian `(Tempatkan Gambar 1 Di Sini)`, Anda wajib membuat satu diagram/arsitektur jaringan (Gunakan *Draw.io* atau *Visio*).
* **Isi Diagram:**
  Kotak [Aplikasi Flutter Klien] -> Panah (REST API HTTP) -> Kotak [Supabase (BaaS)] -> Di dalam kotak Supabase, gambar ikon silinder bernama [PostgreSQL + RLS]. Tambahkan juga satu panah bolak-balik bertuliskan (WebSockets) untuk fitur *Nudge*.
* **Aturan Gambar JPIT:**
  * Letakkan Rata Tengah (*Center*).
  * Judul gambar (`Gambar 1. Arsitektur...`) diletakkan di bawah gambar dengan *font* 8 pt biasa (tidak ditebalkan).

# Buku 4: Arsitektur Big Data & Optimasi Jaringan (Network Throttling)
**Fokus Presentasi:** Menjawab Dosen Big Data & Dosen Telekomunikasi.

---

## 1. Masalah Ledakan Data (Data Explosion)
Aplikasi pengawasan yang melacak orang setiap saat (*Real-Time Tracking*) memiliki masalah absolut: **Bengkak Server (Cost Overrun)** dan **Baterai Bocor (Battery Drain)**.
Bayangkan: 1 anak disensor 1x sedetik = 60 baris data semenit = 3.600 baris data sejam! Kalau ada 1.000 anak pakai bersamaan? Server akan *Down*!

## 2. Solusi Jenius: Smart Telemetry Rollup
**Pertanyaan Dosen:** *"Bagaimana caramu menghemat kuota internet dan menjaga servermu tidak meledak jika penggunamu banyak?"*
**Argumen Presentasi:**
*"Saya tidak langsung melempar data kamera mentah-mentah ke Server. Saya membangun sebuah algoritma **Smart Telemetry Rollup** di perangkat HP (Client-Side).*
*   Setiap 5 detik, HP merekam jarak mata. Tapi, data ini tidak dikirim ke internet, melainkan **dikumpulkan ke dalam Memori Lokal SQLite (Database Internal HP)**.
*   Lalu, ketika sudah terkumpul 12 data (setara 60 detik), sistem SQLite akan merangkum (Agregasi) ke-12 data tersebut menjadi **1 BARIS KESIMPULAN SAJA** (Misal: Dari jam 08:00 ke 08:01 = Status Rata-rata Bahaya).
*   Lalu, baris rangkuman itu kembali ditahan, dan baru dikirimkan secara paralel ke Supabase Cloud setiap **15 MENIT SEKALI**.
*   **Keuntungan (Dampak):** Ukuran *Database* di Cloud kami susut hingga 95% (Big Data menjadi efisien), Baterai HP anak tetap dingin, dan kuota internet yang termakan sangat kecil (sekecil mengirim pesan teks biasa)."*

## 3. WebSockets & Real-Time Nudge (Pengecualian Khusus)
**Pertanyaan Dosen:** *"Tapi kalau semuanya di-pending 15 menit, bagaimana jika orang tua mau menegur anak SAAT ITU JUGA?"*
**Argumen Presentasi:**
*"Nah, di sinilah letak spesialisasi arsitektur jaringan saya. Kami menggunakan dua jalur internet (Dual-Protocol). Data analitik menggunakan jalur HTTP biasa yang murah. Namun, untuk fitur 'Teguran' (Nudge), kami membuka gerbang khusus **WebSockets (Stream)**.*
*   *WebSockets* itu ibarat kabel pipa tersembunyi yang selalu tersambung antara Supabase Cloud dan HP anak.
*   Saat Ibu menekan 'Tegur' di HP-nya, sinyal akan melesat melalui pipa *WebSocket* itu, menembus batasan 15 menit tadi, dan seketika itu juga (dalam ±150 milidetik) memunculkan peringatan di HP anak.
*   Untuk menghindari HP diretas oleh pesan *spam*, saya menerapkan filter `.eq('receiver_id')` secara absolut di sisi *Server*, jadi HP anak hanya mau menerima pesan jika pesan itu benar-benar dari akun orang tuanya."*

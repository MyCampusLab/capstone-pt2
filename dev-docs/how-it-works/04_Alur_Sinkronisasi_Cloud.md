# Bedah Cara Kerja 4: Alur Telemetri & Sinkronisasi Cloud
**Fokus:** Menjelaskan perjalanan Big Data dari HP anak ke HP orang tua, tanpa membuat server macet.

---

## 🗃️ Tahap 1: Smart Rollup (Pemampatan Data)
*   **Cara Kerja Ringan:** Kami tidak mengirim setiap pergerakan anak ke server (itu namanya pemborosan). HP akan mengumpulkan datanya diam-diam dulu, dirangkum, baru dikirim setiap 15 menit.
*   **Penjelasan Teknis:** Data jarak 1 detik sekali dimasukkan ke *Local Database* (SQLite). Setelah terkumpul 12 rekaman data, fungsi `aggregateData()` dipanggil. Fungsi ini merata-rata 12 baris tadi menjadi 1 baris JSON utuh (Mewakili durasi 1 Menit).
*   **Bukti Nyata (Tunjukkan ke Dosen):** Buka konsol Supabase di laptop. Tunjukkan isi tabel `telemetry_logs`. Dosen akan melihat waktu (`created_at`) *log* yang masuk itu tidak berjarak detik (seperti 10:01:01, 10:01:02), melainkan masuk borongan per 15 menitan. Ini membuktikan fitur penghematan kuota (*Smart Rollup*) kita berfungsi!

## 📡 Tahap 2: Pengiriman Pararel (Batch Insert)
*   **Cara Kerja Ringan:** Rangkuman data yang sudah dikumpulkan dikirimkan sekaligus seperti sebuah "Paket Box", bukan dikirim satu-satu seperti surat.
*   **Penjelasan Teknis:** Saat masuk menit ke-15, kelas `TelemetryService` mengirim *HTTP POST Request* ke REST API Supabase. Data dikirim dalam bentuk `JSON Array`. Supabase mengeksekusinya secara efisien di level pangkalan data.
*   **Bukti Nyata (Tunjukkan ke Dosen):** Tunjukkan arsitektur Supabase Anda yang terhubung dengan API Swagger/Postman, lalu jelaskan bahwa skema *Batch Insert* inilah yang membuat aplikasi Anda berani menampung jutaan data (*Big Data Ready*).

## ⚡ Tahap 3: Peluncuran Teguran Kilat (WebSockets)
*   **Cara Kerja Ringan:** Meskipun data laporannya ditunda tiap 15 menit, pesan "Teguran Darurat" dari Orang Tua harus sampai ke HP anak saat itu juga tanpa *delay*.
*   **Penjelasan Teknis:** Kami menggunakan teknologi berbeda, yaitu *WebSockets* (Supabase Real-time Stream). Pipa ini selalu terbuka. Saat orang tua memencet tombol tegur, *Controller* mengirim sinyal sisipan. Karena filter `receiver_id` diletakkan di *Server-Side*, pesan teguran itu hanya akan menembak masuk secara spesifik ke 1 HP target saja (yaitu HP anaknya).
*   **Bukti Nyata (Tunjukkan ke Dosen):** Siapkan 2 HP (atau 1 HP dan 1 Laptop). Buka dasbor Orang Tua di HP 1, dan dasbor anak di HP 2. Tekan tombol "Tegur" di HP 1. Dalam sekejap mata (kurang dari 1 detik), akan muncul peringatan *Pop-up* merah di HP anak (HP 2). Ini membuktikan aliran *WebSocket Stream* berjalan tanpa *delay*!

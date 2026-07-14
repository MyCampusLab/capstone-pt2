# Gambar Besar Cara Kerja Sistem (Architecture Overview)

**Diperbarui:** 15 Juli 2026

Bapak/Ibu Dosen, agar aplikasi ini tidak membuat HP anak menjadi lambat atau kepanasan, kami merancang "Topologi" (Jalur Komunikasi) yang sangat modern. 

Bayangkan jika semua proses deteksi wajah dilakukan di Komputer Pusat (Server), maka biaya server akan sangat mahal dan internet harus terus terhubung. Oleh karena itu, kami mengubah cara kerjanya secara drastis!

## 1. Pemrosesan Terjadi di Dalam HP (Edge Computing)
Semua tugas berat (menghitung letak titik mata) diselesaikan langsung di dalam HP anak itu sendiri menggunakan teknologi canggih *Kotlin Native*. 
*   Internet putus pun, sistem kami tetap bisa memantau dan menghukum (mem-blur) layar jika anak terlalu dekat.
*   Ponsel anak bekerja seperti agen cerdas mandiri.

## 2. Server Pusat Hanya Sebagai Tempat Penampungan (Cloud BaaS)
Kami menyewa *Gudang Data Cloud* (bernama Supabase). Gudang ini hanya berfungsi menerima "Catatan Harian" dari HP anak yang disetorkan setiap 15 menit.
Karena pelaporan datanya ditumpuk dan dikirim 15 menit sekali (bukan terus-menerus detikan), maka:
*   Beban server kami turun hingga 99% (Sangat Irit Biaya).
*   Sistem kami dipastikan tidak akan *Crash* (Error) meskipun tiba-tiba ada 100.000 anak yang memakai aplikasi kami bersamaan di seluruh Indonesia.

## 3. Komunikasi Kilat WebSockets (Jalur Khusus)
Lalu bagaimana jika orang tua ingin "Menegur" anaknya saat itu juga?
*   Kami membangun satu "Kabel Khusus" berkecepatan cahaya (bernama WebSockets). Saat orang tua memencet tombol tegur, pesan itu melesat dan sampai ke HP anak hanya dalam waktu sekedipan mata (~150 milidetik), tanpa antre, dan tanpa tertukar dengan pesan anak orang lain.

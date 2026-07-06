# Bedah Cara Kerja 2: Alur Eksekusi Hukuman (Blur Overlay)
**Fokus:** Menjelaskan bagaimana aplikasi kita bisa "membajak" HP dan menghentikan anak bermain secara paksa.

---

## ⏱️ Tahap 1: Pencatat Dosa (Violation Timer)
*   **Cara Kerja Ringan:** Sistem tidak akan langsung menghukum jika anak cuma lewat sebentar (mendekat ke layar lalu mundur lagi). Sistem akan menghitung detik di dalam hati.
*   **Penjelasan Teknis:** Di dalam `HomeController` (Pola GetX Flutter), terdapat logika *Timer*. Jika variabel jarak *(Distance)* menyentuh angka `< 30 cm`, Timer mulai menghitung. Jika jarak kembali aman (> 30 cm), Timer di-*reset* jadi 0. Tapi jika Timer menembus **3 Detik (Treshold)**, mesin eksekusi dipanggil.
*   **Bukti Nyata (Tunjukkan ke Dosen):** Praktikkan memajukan wajah selama 2 detik lalu mundur. Layar tidak akan nge-blur. Ini membuktikan logika Timer kita presisi, bukan *False Positive* (Kesalahan Hitung) yang mengganggu kenyamanan pengguna.

## ⚔️ Tahap 2: Pembajakan OS (System Alert Window)
*   **Cara Kerja Ringan:** Saat syarat 3 detik terpenuhi, aplikasi kita yang ada di latar belakang akan melempar selimut "Kaca Buram" raksasa ke atas layar. Selimut ini menutupi apapun yang sedang anak tonton (YouTube, Game).
*   **Penjelasan Teknis:** Flutter memanggil fungsi Kotlin Native via *MethodChannel*. Kotlin akan memerintahkan `WindowManager` OS Android untuk membuat *View* tipe `TYPE_APPLICATION_OVERLAY`. *View* ini diisi dengan efek *Gaussian Blur* dan dipasang pada urutan *Z-Index* (tumpukan layar) paling tinggi sedunia Android.
*   **Bukti Nyata (Tunjukkan ke Dosen):** Tekan *Home* di HP, buka aplikasi lain seperti YouTube atau TikTok. Dekatkan wajah 3 detik. *Boom!* Kaca Blur muncul menutupi TikTok. Coba sentuh layarnya, sentuhannya tidak akan tembus ke TikTok karena terhalang lapisan aplikasi kita.

## 🔓 Tahap 3: Pembebasan Bersyarat
*   **Cara Kerja Ringan:** Kaca blur tidak bisa dihapus atau di-*swipe*. Satu-satunya cara agar layarnya bening lagi adalah dengan menjauhkan kepala.
*   **Penjelasan Teknis:** Walaupun layar nge-blur, AI Kamera tetap memantau (*Looping*). Begitu AI mendeteksi jarak kembali >30cm selama 1 detik penuh, Kotlin akan memerintahkan `WindowManager.removeView()`. Kaca blur dihancurkan dari memori HP.
*   **Bukti Nyata (Tunjukkan ke Dosen):** Saat layar sedang nge-blur, coba pencet tombol "Back" atau usap layar. Tidak akan bisa hilang. Lalu jauhkan kepala secara fisik, layar otomatis jernih kembali. Ini membuktikan hukuman kita tidak bisa diakali oleh anak kecil.

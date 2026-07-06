# Bedah Cara Kerja 3: Alur Pencetakan Poin (Gamifikasi)
**Fokus:** Menjelaskan bagaimana anak mendapatkan hadiah, membuktikan bahwa aplikasi ini punya fungsi edukasi (bukan cuma menghukum).

---

## ⏳ Tahap 1: Mesin Penghitung Waktu Aman (Safe Timer)
*   **Cara Kerja Ringan:** Kebalikan dari Timer Hukuman, sistem juga menghitung detik-detik ketaatan. Kalau anak main dengan jarak jauh dan aman, sistem akan menabung detiknya.
*   **Penjelasan Teknis:** Di dalam `RewardService`, terdapat logika *Timer Periodic*. Selama variabel *Distance* menunjukkan `> 30 cm`, variabel `safeDuration` akan bertambah. 
*   **Bukti Nyata (Tunjukkan ke Dosen):** Buka halaman *Quest* (Misi). Tunjukkan progres *bar* / lingkaran progres Misi "Menjaga Mata 5 Menit". Warnanya akan bertambah pelan-pelan selama muka Anda menjauh dari HP.

## 💥 Tahap 2: Misi Batal (Quest Failed)
*   **Cara Kerja Ringan:** Sistem mendidik anak untuk konsisten. Kalau anak sudah mengumpulkan waktu 4 menit, tapi tiba-tiba maju (melanggar) karena seru main *game*, maka tabungan 4 menit tadi hangus. Anak harus mulai lagi dari 0.
*   **Penjelasan Teknis:** Jika variabel `isViolating` menjadi `true` (anak mendekat), maka fungsi `resetSafeTimer()` akan dipanggil. Sistem akan mengosongkan *bar* misi.
*   **Bukti Nyata (Tunjukkan ke Dosen):** Saat progres *bar* misi sudah terisi setengah, dekatkan wajah ke layar. Progres *bar* itu akan langsung anjlok kembali ke 0%. Ini membuktikan bahwa mekanisme edukasi "Disiplin" di aplikasi kita benar-benar berfungsi.

## 🎁 Tahap 3: Panen XP & Gacha (Reward Claim)
*   **Cara Kerja Ringan:** Kalau anak sukses melewati misi 5 menit tanpa putus, poin XP anak akan bertambah. Jika XP penuh (naik level), anak bisa mengundi (Gacha) kotak hadiah untuk membuka Stiker/Hero baru.
*   **Penjelasan Teknis:** Fungsi `addXp(10)` akan menyimpan data ke memori permanen HP (menggunakan *database* NoSQL `Hive`). Jadi walau HP di-*restart*, poin XP anak tidak akan hilang. Setelah poin cukup, *state* `isHeroUnlocked` berubah menjadi `true`, yang memicu pemuatan (*rendering*) file animasi `Lottie` Maskot baru di UI.
*   **Bukti Nyata (Tunjukkan ke Dosen):** Klik tombol "Klaim Hadiah / Gacha". Layar akan memunculkan animasi sinar memutar layaknya buka kotak hadiah di *game*. Maskot Vizo yang tadinya terkunci (abu-abu/gembok) akan berubah menjadi karakter animasi bergerak. Ini membuktikan *State Management* (GetX) merender ulang tampilan (UI) dengan mulus sesuai perubahan data *Hive*.

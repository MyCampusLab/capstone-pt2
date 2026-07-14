# Peta Penataan Berkas Aplikasi (Module Map)

**Diperbarui:** 15 Juli 2026

Bapak/Ibu Dosen Penguji, membangun aplikasi setara perusahaan besar membutuhkan tingkat kerapian *file* yang sangat tinggi agar tidak kusut di kemudian hari. Kami membagi kode program kami seperti membagi kamar di dalam sebuah rumah sakit besar.

Berikut adalah gambaran ringkas "Denah Ruangan" kode kami:

## 1. Ruangan Depan (Flutter Mobile)
Folder ini (bernama `lib/`) berisi semua hal yang bisa dipandang mata dan disentuh jari. 
*   **Ruang `dashboard/`:** Ini adalah tempat kami menyimpan rancangan halaman utama (seperti letak tombol, tulisan, dan letak grafik jam bahaya). **(Dikelola Marsha)**
*   **Ruang `gamification/`:** Tempat kami menaruh mesin pencetak poin (Skor XP) dan animasi hadiah karakter untuk menghibur anak. **(Dikelola Marsha)**
*   **Ruang `auth/`:** Pos Satpam untuk memeriksa siapa yang masuk dan *login* ke aplikasi. **(Dikelola Irsyad)**

## 2. Ruangan Mesin Bawah Tanah (Kotlin Android)
Folder ini adalah tempat mesin-mesin berat bekerja di balik layar, berinteraksi langsung dengan baterai dan kamera HP. 
*   **Mesin `VisionCameraManager`:** Kamera pengintai jarak wajah. **(Dikelola Irsyad)**
*   **Mesin `BlurOverlayService`:** Eksekutor hukuman yang secara paksa menembakkan kabut buram ke layar jika anak terlalu dekat. **(Dikelola Irsyad)**
*   **Mesin `DeviceStateManager`:** Termometer digital penurun suhu agar HP anak tidak meledak saat kepanasan. **(Dikelola Irsyad)**

## 3. Alur Perjalanan Data (Cerita Singkat)
1. **HP Anak melihat Wajah:** Kamera memotret wajah anak (diproses sangat ringan oleh mesin AI buatan Irsyad).
2. **HP Diam-diam Menabung Data:** Jarak-jarak tersebut dicatat ke memori lokal HP (menghemat kuota).
3. **Pengiriman Borongan:** Setiap 15 Menit, kurir rahasia mengantarkan catatan tadi ke Gudang Data kami di Internet (Supabase).
4. **Disajikan ke HP Orang Tua:** Di HP orang tua, catatan tadi dijemput dan dilukis ulang menjadi grafik kotak-kotak berwarna merah/hijau oleh sistem buatan Marsha.

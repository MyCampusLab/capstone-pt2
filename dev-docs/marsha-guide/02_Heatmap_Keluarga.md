# Panduan Presentasi Marsha (Bagian 2)
**Topik:** Visualisasi Heatmap Analitik & Fitur Family Squad

---

## 🎯 Arahan untuk Marsha
Ini adalah bagian pamer **Big Data & Analitik**. Fokuslah untuk meyakinkan dosen bahwa angka-angka yang diambil oleh Irsyad tidak akan berguna jika tidak divisualisasikan dengan pintar. Kamu adalah orang yang menerjemahkan angka tersebut menjadi informasi berharga bagi orang tua.

## 🗣️ Argumen Utama (Ucapkan ini saat presentasi)

**1. Mengapa menggunakan Heatmap (Peta Suhu)?**
> *"Bapak/Ibu, data mentah telemetri dari server bentuknya adalah ribuan baris teks JSON yang membingungkan. Tugas saya di sini adalah mengubah Big Data itu menjadi wujud visual yang bisa langsung dimengerti orang tua awam dalam 1 detik. Saya membuat **Heatmap Analitik**. Dari grafik ini, orang tua tinggal melihat warna. Jika kotak di hari Minggu jam 8 malam berwarna merah gelap, artinya di jam itulah intensitas bahaya mata anak paling tinggi. Orang tua tidak perlu baca angka, cukup lihat warna."*

**2. Apa fungsi Family Squad (Grup Keluarga)?**
> *"Aplikasi ini dirancang untuk ekosistem keluarga modern. Saya mengimplementasikan fitur 'Invite Code'. Jadi, Ayah, Ibu, atau bahkan Kakek bisa bergabung dalam satu 'Grup Pengawas' menggunakan kode unik (misal: VZ-12345). Dari Dashboard masing-masing, mereka bisa memantau analitik anak secara real-time dari jarak jauh."*

**3. Bukti Keberhasilan (Data Fakta):**
> *"Visualisasi ini dikelola sepenuhnya di sisi *Client* menggunakan pustaka Fl_Chart di Flutter. Ini membuktikan bahwa pembagian beban berhasil; Server Supabase hanya mengirim data ringan, lalu HP orang tua-lah yang bertugas 'melukis' grafik Heatmap-nya, sehingga server kita tetap super ringan."*

## 💡 Jika Dosen IT Bertanya:
**Dosen:** *"Bagaimana jika data Heatmap-nya sangat banyak, apakah aplikasi tidak berat saat merender grafik?"*
**Marsha Jawab:** *"Sangat ringan, Pak. Karena Irsyad sebelumnya sudah merancang fitur 'Smart Rollup' (data sudah dipadatkan per 15 menit), data yang sampai ke tampilan saya sudah berupa agregat (rangkuman). Saya hanya perlu memetakan nilai kepadatan tersebut ke rentang warna di Fl_Chart tanpa perlu melakukan kalkulasi perulangan (looping) yang berat di sisi antarmuka."*

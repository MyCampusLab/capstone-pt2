# Panduan Presentasi Marsha (Bagian 1)
**Topik:** Desain UI/UX, Dashboard Responsif & Animasi Maskot Vizo

---

## 🎯 Arahan untuk Marsha
Saat menjelaskan bagian ini, **jangan fokus pada kode pemrogramannya**. Fokuslah pada **"Rasa (User Experience)"** dan **"Kenyamanan Mata"**. Buktikan bahwa kamu memikirkan desain ini murni agar anak-anak betah (tidak merasa diawasi) dan orang tua mudah memantau.

## 🗣️ Argumen Utama (Ucapkan ini saat presentasi)

**1. Mengapa pakai Maskot Vizo?**
> *"Bapak/Ibu Dosen, kami sadar anak-anak tidak suka diatur-atur oleh aplikasi pengawas yang kaku. Oleh karena itu, saya merancang **Maskot Vizo** menggunakan animasi Lottie (vektor ringan). Vizo bertindak sebagai 'teman virtual'. Saat anak patuh, Vizo akan tersenyum dan memberikan poin (XP). Saat melanggar, Vizo akan bereaksi sedih. Ini adalah pendekatan psikologis (Gamifikasi) agar anak patuh secara organik, bukan karena dipaksa."*

**2. Kenapa tampilan (UI) dibuat seperti ini?**
> *"Untuk tampilan, saya menggunakan bahasa desain Neobrutalism (border tebal, warna kontras). Alasannya dua: Pertama, tampilannya terlihat sangat 'Enterprise' tapi tetap 'Playful' (menyenangkan bagi anak). Kedua, saya memastikan desain ini 'Pixel-Perfect' dan responsif. Artinya, mau dibuka di HP sekecil apa pun atau tablet sebesar apa pun, layar tidak akan pernah tumpang tindih (Overflow)."*

**3. Bukti Keberhasilan (Data Fakta):**
> *"Buktinya, aplikasi kami menggunakan struktur layout berbasis Flex dan Wrap di Flutter. Hal ini diuji pada berbagai ukuran layar saat QA, dan terbukti tidak ada peringatan 'Yellow/Black Screen of Death' (layar kuning error) yang sering terjadi di aplikasi mahasiswa pada umumnya."*

## 💡 Jika Dosen IT Bertanya:
**Dosen:** *"Bagaimana cara kamu mengatur layarnya di Flutter agar tidak overflow?"*
**Marsha Jawab:** *"Saya menghindari ukuran statis (hardcode pixel), Pak. Saya menggunakan `LayoutBuilder` dan `Wrap` sehingga komponen-komponen kotak di dashboard akan otomatis turun ke bawah (menyesuaikan diri) jika layar HP-nya sempit. Untuk animasinya, saya pakai `Lottie` karena format datanya JSON, sehingga ukurannya cuma beberapa Kilobytes, tidak memberatkan memori HP."*

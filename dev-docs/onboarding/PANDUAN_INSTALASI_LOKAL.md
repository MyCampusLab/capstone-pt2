# Panduan Setup Lokal (Menjalankan Kode di Komputer)
**Tujuan:** Jika dosen atau narasumber bertanya *"Bagaimana cara saya mencoba (Run) source code ini di laptop saya sendiri?"*, Anda bisa memberikan panduan ramah ini.

---

## 🛠️ Persyaratan Sistem (Apa yang perlu disiapkan?)
Karena aplikasi kami menggabungkan dua mesin berat (Kamera Native dan Flutter), laptop Anda butuh persiapan berikut:
1.  **Flutter SDK:** Pastikan terinstal versi 3.19 ke atas.
2.  **Android Studio:** Wajib memiliki versi terbaru karena mesin AI kami menggunakan Kotlin versi mutakhir.
3.  **Memori (RAM):** Minimal 8GB agar Android Emulator tidak meledak, namun **Sangat Direkomendasikan** menggunakan *Smartphone* Android fisik (colok kabel USB) untuk menguji fitur kamera dengan akurat.

## 🚀 Langkah Menjalankan Aplikasi (Step-by-Step)

### Langkah 1: Tarik Kode dari Gudang (Clone)
Buka terminal dan ketik perintah sakti ini:
`git clone https://github.com/irsyad/visionsafe.git`
Lalu masuk ke dalam foldernya:
`cd visionsafe`

### Langkah 2: Panggil Pemasok Barang (Install Dependencies)
Aplikasi kami butuh mengambil bahan-bahan dari internet (seperti Fl_Chart, GetX, dll). Ketik:
`flutter pub get`
*(Tunggu sebentar sampai semua paket selesai diunduh).*

### Langkah 3: Pasang Kunci Rahasia (Environment Variables)
Demi keamanan data, kami tidak pernah menaruh kunci gembok (*API Key* Supabase) di dalam kode publik. 
1. Buat file baru bernama `.env` di folder utama aplikasi.
2. Isi file tersebut dengan Kunci Rahasia milik proyek (Minta akses ke tim *Developer/Irsyad*).
Formatnya seperti ini:
```
SUPABASE_URL=https://rahasia.supabase.co
SUPABASE_ANON_KEY=kunci_rahasia_panjang
```

### Langkah 4: Nyalakan Mesinnya! (Run)
Colokkan HP Android Anda menggunakan kabel data (pastikan Mode Pengembang/USB Debugging menyala). Lalu ketik:
`flutter run`

Tunggu sekitar 2-3 menit untuk proses perakitan pertama kali (*Gradle Build*). Setelah selesai, aplikasi VisionSafe akan langsung menyala di HP Anda!

---
**Catatan Khusus Emulator:** Jika Bapak/Ibu dosen memaksa mencoba di Emulator (Bukan HP Asli), fitur Kamera dan *System Blur* mungkin akan macet (nge-*blank*) karena Emulator tidak memiliki perangkat keras lensa dan sensor baterai sungguhan. Selalu gunakan HP Asli untuk menguji *Computer Vision*!

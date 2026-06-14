# PANDUAN RE-KONFIGURASI DAN MIGRASI MANDIRI SUPABASE BACKEND
## PROYEK CAPSTONE: VISIONSAFE (EYE GUARDIAN)
**Standar Keamanan, Gamifikasi, dan Sinkronisasi Data Tingkat Enterprise**

---

## 1. PENDAHULUAN & PRASYARAT

Dokumen ini disusun secara sistematis untuk memandu Anda dalam melakukan re-konfigurasi dan migrasi mandiri backend Supabase untuk aplikasi **VisionSafe**. Langkah ini diperlukan karena host server lama telah kedaluwarsa atau dinonaktifkan.

Anda dapat menggunakan **proyek aktif yang sudah ada** di akun Supabase Anda tanpa harus membuat proyek baru dari nol. Panduan ini dirancang untuk memastikan database dalam keadaan bersih (*clean slate*), aman, dan teroptimasi untuk demonstrasi sidang akademik.

---

## 2. TAHAP 1 - CLEAN SLATE (MEMBERSIHKAN DATABASE AKTIF)

Jika Anda menggunakan proyek Supabase yang sudah ada, Anda wajib membersihkan tabel-tabel lama untuk menghindari konflik relasi data (*foreign key constraints*) atau ketidaksesuaian tipe data.

### Langkah-langkah:
1. Masuk ke [Supabase Dashboard](https://supabase.com/dashboard) dan pilih proyek aktif Anda.
2. Pada bilah navigasi sebelah kiri, klik menu **SQL Editor** (ikon terminal dengan tulisan `SQL`).
3. Klik **New Query** (tombol berwarna hijau dengan ikon `+`).
4. Salin dan tempel (*paste*) perintah SQL pembersih berikut ke dalam editor:

```sql
-- ===================================================
-- SCRIPT PEMBERSIH TABEL LAMA (CLEAN SLATE)
-- ===================================================
DROP TABLE IF EXISTS public.telemetry CASCADE;
DROP TABLE IF EXISTS public.user_settings CASCADE;
DROP TABLE IF EXISTS public.user_stickers CASCADE;
DROP TABLE IF EXISTS public.notifications CASCADE;
DROP TABLE IF EXISTS public.news CASCADE;
DROP TABLE IF EXISTS public.stickers CASCADE;
DROP TABLE IF EXISTS public.profiles CASCADE;
```

5. Klik tombol **Run** (atau tekan `Ctrl + Enter`).
6. Pastikan muncul pemberitahuan sukses: `Success. No rows returned.` Database Anda kini dalam keadaan bersih sempurna.

---

## 3. TAHAP 2 - MENJALANKAN MIGRASI SKEMA `init_schema.sql`

Tahap ini akan membangun kembali seluruh struktur tabel, relasi, Row Level Security (RLS), trigger otomatis, dan data inisial stiker yang diperlukan oleh aplikasi.

### Langkah-langkah:
1. Di dalam SQL Editor Supabase, hapus kode pembersih di atas.
2. Buka file skema database lokal Anda di:
   `/home/irsyad/Gudang/EyeGuardian/visionsafe/supabase/init_schema.sql`
3. Salin seluruh isi file tersebut secara utuh (344 baris).
4. Tempelkan (*paste*) ke dalam SQL Editor di dashboard Supabase.
5. Klik tombol **Run**.
6. Sistem akan memproses pembuatan struktur berikut secara otomatis:
   * **Tabel `profiles`**: Menyimpan profil, XP, level, akumulasi fokus, dan status maskot.
   * **Tabel `telemetry`**: Menyimpan log jarak mata dan pelanggaran secara real-time.
   * **Tabel `user_settings`**: Menyimpan konfigurasi jarak aman mata (default 35cm).
   * **Tabel `stickers` & `user_stickers`**: Sistem gamifikasi stiker prestasi (s1 - s4).
   * **Tabel `notifications` & `news`**: Pusat notifikasi dan edukasi kesehatan mata.
   * **Triggers & Functions**: Logika penghitungan XP, naik level, dan pembukaan stiker otomatis langsung di sisi server untuk keamanan optimal.

---

## 4. TAHAP 3 - OPTIMALISASI AUTENTIKASI (EMAIL & GOOGLE SIGN-IN)

Agar proses demonstrasi di hadapan dosen penguji berjalan sangat mulus dan cepat, lakukan konfigurasi berikut pada panel autentikasi Supabase Anda:

### A. Menonaktifkan Konfirmasi Email (Instant Sign-Up)
Secara default, Supabase mengharuskan pengguna memverifikasi akun via tautan email. Kita perlu menonaktifkan fitur ini agar pengguna dapat langsung mendaftar dengan email dummy dan langsung login.
1. Masuk ke menu **Authentication** di bilah navigasi kiri.
2. Pilih submenu **Providers** -> pilih **Email**.
3. Matikan toggle **Confirm email**.
4. Klik **Save**.

### B. Mengaktifkan Google OAuth Provider
Aplikasi VisionSafe telah dilengkapi dengan integrasi masuk menggunakan akun Google secara native. Konfigurasikan Supabase agar mengenali token Google dari aplikasi:
1. Masuk ke menu **Authentication** -> **Providers** -> pilih **Google**.
2. Klik toggle **Enable Google Provider**.
3. Masukkan **Client ID** yang saat ini dikompilasi di dalam aplikasi Anda:
   * **Google Client ID**: 
     `353922058441-j4voev2ai15av984u7sgmd4ba78248b3.apps.googleusercontent.com`
4. Klik **Save**.

---

## 5. TAHAP 4 - PENYELARASAN KREDENSIAL PADA FLUTTER CLIENT

Setelah konfigurasi backend selesai, Anda perlu mengambil kredensial koneksi baru dan memperbarui kode sumber Flutter Anda.

### A. Mengambil Kredensial dari Supabase:
1. Masuk ke menu **Project Settings** (ikon roda gigi di kiri bawah).
2. Klik menu **API**.
3. Cari dan salin dua nilai penting berikut:
   * **Project URL**: Contoh: `https://xxxxxxxxx.supabase.co`
   * **anon public key**: String panjang yang diawali dengan `eyJhbGci...`

### B. Memperbarui Kode Flutter:
Buka file `/home/irsyad/Gudang/EyeGuardian/visionsafe/lib/main.dart` pada baris **40 dan 41**, lalu ganti dengan kredensial baru Anda:

```dart
  // 1. Inisialisasi Supabase (Pondasi Backend Baru)
  await Supabase.initialize(
    url: 'https://TAUTAN_PROYEK_BARU_ANDA.supabase.co',
    anonKey: 'KUNCI_ANON_PUBLIC_BARU_ANDA...', 
    debug: false, // Mematikan log berlebih di terminal console
  );
```

4. Simpan file tersebut.

---

## 6. TAHAP 5 - VERIFIKASI DAN TROUBLESHOOTING KONEKTIVITAS

Setelah memperbarui kode, jalankan kembali aplikasi Anda melalui terminal lokal menggunakan ponsel Android fisik Anda yang sudah terhubung melalui USB debugging:

```bash
# Menjalankan aplikasi secara langsung di perangkat terhubung
flutter run
```

### Cara Membaca Log untuk Memastikan Keberhasilan Koneksi:
* **Log Sukses**: Saat aplikasi terbuka, tidak akan ada pesan kesalahan socket, dan daftar berita kesehatan mata pada dashboard aplikasi akan terisi secara dinamis dari tabel `news` yang ada di database baru Anda.
* **Log Error**: Jika Anda melihat error seperti `Failed host lookup` atau `SocketException`, periksa kembali penulisan URL Supabase Anda di `main.dart` dan pastikan ponsel Anda terhubung ke jaringan internet yang stabil.

---
*Dokumen ini dibuat secara otomatis oleh Supreme Developer Agent untuk kelancaran pengerjaan tugas akhir akademik VisionSafe.*

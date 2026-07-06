# Buku 3: Kriptografi Jaringan & Keamanan Basis Data
**Fokus Presentasi:** Menjawab Dosen Jaringan & Keamanan Siber.

---

## 1. Arsitektur Serverless (BaaS - Supabase)
**Pertanyaan Dosen:** *"Mengapa kamu tidak pakai backend tradisional seperti PHP Laravel atau Node.js Express?"*
**Argumen Presentasi:**
*"Saya menganut pendekatan **Cloud-Native / Backend-as-a-Service (BaaS)** menggunakan Supabase. Aplikasi ini dirancang untuk kecepatan (Low Latency). Supabase menyediakan antarmuka REST API bawaan yang dibangun menggunakan **PostgREST** (bahasa C). Mengakses database melalui PostgREST jauh lebih cepat daripada harus melewati *routing* PHP atau *Event Loop* Node.js. Selain itu, dengan BaaS, masalah Skalabilitas Server jika ada lonjakan 100.000 pengguna sudah ditangani otomatis oleh pihak Cloud."*

## 2. Pengamanan Data Mutlak (Row Level Security & JWT)
**Pertanyaan Dosen:** *"Banyak aplikasi startup yang database-nya bocor ke publik. Bagaimana jaminan aplikasimu aman dari hacker?"*
**Argumen Presentasi:**
*"Bapak/Ibu, lapisan keamanan kami tidak berada di kode Flutter yang mudah diretas, melainkan **ditanam langsung di dalam mesin Database (PostgreSQL)** menggunakan teknologi **Row Level Security (RLS)**."*
*   **Siklus Kriptografinya:** Saat *user* masuk menggunakan Google OAuth (Single Sign-On), Supabase meracik sebuah kunci sandi unik bernama **JWT (JSON Web Token)**. Kunci JWT ini tidak bisa dipalsukan karena dilindungi algoritma *Hashing* tingkat tinggi (*HS256*).
*   **Penjaga Pintu (RLS):** Saat aplikasi HP mau mengambil data, JWT dikirim di *header* HTTP. Mesin Database secara otomatis mengecek: *"Apakah ID di dalam JWT ini sama dengan ID di kolom Database?"*. Jika *hacker* mencoba menembak API kita tanpa JWT yang sah, *Database* secara mentah-mentah akan membuang sinyal tersebut (HTTP 403 Forbidden). Cacat kodenya pun tidak akan tembus karena dilindungi pada tingkat *Row* (Baris Tabel).

## 3. Integrasi OTP & Verifikasi Email (Native JWT Refresh)
**Pertanyaan Dosen:** *"Bagaimana cara sistem tahu emailnya sah?"*
**Argumen Presentasi:**
*"Awalnya kami pakai OTP konvensional, tapi rawan SPAM dan mahal. Kami beralih menggunakan tautan ajaib (*Magic Link*) via SMTP Resend. Saat pengguna klik verifikasi di Email (misal di PC/Laptop), server mengesahkan emailnya.
Hebatnya, saya merancang mekanisme pintar di aplikasi (*Waiting Verification View*), di mana aplikasi melakukan *Polling* pintar ke Cloud. Begitu pengguna klik setuju di laptop, HP-nya akan mendeteksi status tersahkan dalam 3 detik layaknya WhatsApp Web, dan otomatis memasukkannya ke sistem (Login)."*

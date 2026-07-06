# Buku 5: Arsitektur Ekosistem (Sosial & Logika Permainan)
**Fokus Presentasi:** Menjawab Dosen Analisis Sistem & Dosen Produk.

---

## 1. Fitur Family Squad (Isolated SQL Joins)
**Pertanyaan Dosen:** *"Bagaimana sistemmu bisa membedakan data anak si A dan anak si B agar tidak tertukar di aplikasi ayah?"*
**Argumen Presentasi:**
*"Ini bukan sekadar pertukaran ID biasa. Saya merancang arsitektur Relasional Database (RDBMS). 
Saat paman, bibi, atau kakek memasukkan `Invite Code` anak, sistem akan memvalidasi kode tersebut. Jika tembus, Supabase akan menanamkan relasi (SQL Join) antara ID Kakek tersebut dengan tabel `group_members` yang mengikatnya ke `group` si anak.
Hasilnya, saat kakek me- *refresh* halaman berandanya, sistem mengambil (Fetching) data menggunakan teknik isolasi. Kakek hanya akan dikirimi data telemetri yang anak itu miliki (Supervisor Mode), tanpa bentrok dengan catatan kesehatan mata si kakek sendiri."*

## 2. Gamifikasi: Quest Engine
**Pertanyaan Dosen:** *"Bagaimana aplikasi tahu kapan harus ngasih poin/stiker ke anak secara otomatis?"*
**Argumen Presentasi:**
*"Saya tidak menggunakan waktu fiktif. Engine Gamifikasi (Pemberi Misi) saya suntikkan tepat di urat nadi data telemetri.
Sistem membaca Timer Presisi absolut. Jika wajah statis berada di jarak aman (>30cm) terus-menerus, maka algoritma `QuestsController` berjalan. Misalnya, misi 'Menjaga Mata 30 Menit'. Jika belum 30 menit, tapi anak menempelkan mukanya ke layar, maka timer Misi akan hangus (Tereset menjadi 0).
Tapi jika lulus, aliran data akan mengontak `RewardService`. Sistem memberikan poin (XP). Saat XP melampaui ambang batas, maka logika Leveling dieksekusi secara otomatis, dan animasi Lottie (Mascot Vizo) yang tadinya terkunci menjadi bisa dimainkan oleh si anak (Hadiah Dopamin)."*

## 3. Developer Owner Console (Manajemen Infrastruktur Utama)
**Pertanyaan Dosen:** *"Sebagai pemilik (Developer), dari mana kamu tahu aplikasimu sedang diunduh banyak orang atau sedang diserang?"*
**Argumen Presentasi:**
*"Bapak/Ibu, saya membuat *dashboard* tersembunyi beraksen 'Neobrutalism' khusus untuk SuperAdmin. Di sini, sistem mengeksekusi operasi agregasi data massal (Big Data Aggregation).
Saya menggunakan Service Role Key (Kunci Bypass yang bisa menembus RLS) khusus di sesi Admin. Dasbor ini akan menjumlahkan (COUNT) seluruh aktivitas telemetri secara anonim, menghitung Rata-Rata *Screen-Time* dunia, dan menangkap *Live Feedback* yang masuk. Inilah kokpit pusat saya untuk memastikan seluruh infrastruktur di Google Cloud (melalui Supabase) berjalan sehat dan mendeteksi jika butuh peningkatan kapasitas (Scaling)."*

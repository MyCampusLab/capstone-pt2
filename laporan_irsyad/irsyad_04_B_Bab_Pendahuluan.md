# PENDAHULUAN

Penggunaan perangkat bergerak (*mobile devices*) secara tidak terkendali pada anak-anak telah mendorong kebutuhan akan aplikasi pengawasan kesehatan mata (*mobile health* atau *mHealth*) yang mampu memantau jarak pandang layar secara presisi. Namun, pengawasan ini tidak dapat hanya bergantung pada perangkat lokal anak; orang tua membutuhkan kapabilitas untuk memantau kepatuhan dan memberikan teguran secara seketika (*real-time*) dari jarak jauh. Untuk mewujudkan ekosistem pengawasan lintas perangkat (*cross-device*) tersebut, pergeseran paradigma arsitektur modern semakin bertumpu pada infrastruktur *Backend-as-a-Service* (BaaS). Arsitektur ini memungkinkan pengembang untuk mempercepat siklus rekayasa perangkat lunak dengan mendelegasikan manajemen basis data relasional, otentikasi, dan protokol transmisi data kepada penyedia layanan komputasi awan (*Cloud Computing*) pihak ketiga [1], [2]. Pemanfaatan *platform* BaaS, seperti Supabase yang berbasis PostgreSQL, menawarkan fondasi komputasi yang *highly-available* dan skalabel untuk memfasilitasi aplikasi pemantauan keluarga. Meskipun model arsitektur *Cloud-Native* ini menawarkan efisiensi pengembangan, implementasi untuk pengawasan 24 jam penuh memicu tantangan fundamental pada manajemen telemetri data besar (*Big Data*) [3].

Tantangan operasional utama pada aplikasi pengawasan *real-time* adalah tingginya intensitas sinkronisasi log aktivitas. Pengiriman data telemetri yang dieksekusi secara kontinu, sering kali diukur dalam hitungan detik per pengguna, terbukti menciptakan efek leher botol (*bottleneck*) pada *bandwidth* jaringan seluler dan mengonsumsi daya komputasi di sisi *Edge* secara eksesif [8]. Dari sudut pandang peladen, banjir panggilan antarmuka pemrograman aplikasi (*API Calls*) yang konstan akan dengan cepat menghabiskan kuota pembatasan laju (*Rate-Limiting*) pada infrastruktur BaaS publik dan menggelembungkan biaya operasional penyimpanan (*Storage Costs*) harian hingga tingkat yang tidak berkelanjutan [9], [11]. Praktik pengelolaan aliran data yang persisten ini menuntut adanya algoritma agregasi proaktif di sisi perangkat pengguna sebelum transmisi ke komputasi awan dilakukan.

Selain kendala operasional agregasi telemetri, aplikasi pemantauan jarak pandang yang melibatkan data perilaku pediatrik (anak-anak) memiliki kerentanan privasi tingkat tinggi. Basis data relasional pada *platform* BaaS umumnya beroperasi sebagai entitas penyewa ganda (*multi-tenant*), di mana rekaman dari berbagai grup keluarga tersimpan di dalam tabel yang sama [4], [16]. Ketiadaan kontrol akses butir-halus (*fine-grained access control*) yang solid berpotensi memicu eskalasi hak istimewa (*Privilege Escalation*), memungkinkan pengguna jahat untuk memanipulasi parameter antarmuka dan membaca atau menghapus log kesehatan milik pengguna atau grup keluarga lain [5], [6]. Oleh karena itu, pengamanan tidak cukup hanya ditanamkan di lapisan aplikasi klien (*front-end*), melainkan harus diterapkan secara arsitektural pada lapisan terdalam basis data [15].

Penelitian ini bertujuan untuk merancang dan mengevaluasi arsitektur sinkronisasi telemetri yang hemat biaya sekaligus kebal terhadap serangan lintas penyewa (*cross-tenant attacks*). Kebaruan (*novelty*) dari penelitian ini terletak pada penggabungan dua mekanisme terisolasi: Pertama, algoritma *Smart Telemetry Rollup* yang mengagregasi 12 log interaksi harian secara lokal menjadi satu baris (*batching*) dan dikirimkan secara periodik setiap 15 menit untuk memangkas *API Calls*. Kedua, penerapan kebijakan *Row Level Security* (RLS) mutlak di *layer* PostgreSQL Supabase yang mengikat setiap kueri dengan verifikasi *payload JSON Web Token* (JWT), memisahkan hak intervensi antara agen pengawas (Orang Tua) dan pengguna diawasi (Anak) [7]. Selain itu, komunikasi intervensi spontan difasilitasi menggunakan *Real-Time WebSockets* yang dibatasi oleh kanal penyaringan (*Stream Filtering*) yang spesifik [12], [14].

Evaluasi kinerja difokuskan pada pengujian dua metrik utama dari standar kualitas perangkat lunak ISO/IEC 25010, yakni parameter Efisiensi Kinerja (*Performance Efficiency*) dan Keamanan (*Security*) [17]. Tingkat efisiensi diukur dari persentase penyusutan frekuensi *API Calls* serta penghematan memori, sedangkan aspek keamanan divalidasi melalui skenario pengujian penetrasi *Black-Box* untuk membuktikan keandalan logika RLS dalam menolak kueri yang tidak sah [18], [19]. 

---
---

# 🛑 PANDUAN NAVIGASI SITASI ZOTERO UNTUK IRSYAD

Anda sebelumnya menggunakan **Zotero** (bukan Mendeley seperti Marsha). File referensi Anda ada di `irsyad_references.bib`.

**Cara Pakai di Microsoft Word:**
1. Salin seluruh draf PENDAHULUAN di atas (hanya isi teksnya) ke Microsoft Word Anda. Pastikan sudah berformat *Times New Roman 10pt*, *Justified*, *Single Space*.
2. Hapus teks manual `[1], [2]` di Word Anda.
3. Klik tab **Zotero** -> Klik **Add/Edit Citation**.
4. Ketikkan kata kunci di bawah ini di kolom pencarian Zotero satu per satu, lalu tekan Enter.

### Pemetaan Paragraf 1 (BaaS & Cloud):
* Teks Asli: `...komputasi awan pihak ketiga [1], [2].`
  * **Ketik untuk [1]:** `Tariq` (Pilih: *Comparative Analysis of Backend-as-a-Service...*)
  * **Ketik untuk [2]:** `Huang Scalable` (Pilih: *Scalable Data Synchronization in Mobile...*)
* Teks Asli: `...skala produksi luas memicu tantangan fundamental pada manajemen telemetri data besar [3].`
  * **Ketik untuk [3]:** `Supabase Architecture` (Pilih: *Supabase Architecture and PostgreSQL...*)

### Pemetaan Paragraf 2 (Masalah Telemetri & Bandwidth):
* Teks Asli: `...mengonsumsi daya komputasi di sisi Edge secara eksesif [8].`
  * **Ketik untuk [8]:** `Wang Energy` (Pilih: *Energy-Efficient Data Aggregation...*)
* Teks Asli: `...biaya operasional harian hingga tingkat yang tidak berkelanjutan [9], [11].`
  * **Ketik untuk [9]:** `Chen Reducing` (Pilih: *Reducing Cloud Storage Costs via Edge-Level...*)
  * **Ketik untuk [11]:** `Baker Throttling` (Pilih: *Throttling and Rate-Limiting Strategies...*)

### Pemetaan Paragraf 3 (Masalah Keamanan Data Anak & Multi-Tenant):
* Teks Asli: `...tersimpan di dalam tabel yang sama [4], [16].`
  * **Ketik untuk [4]:** `Kim RLS` (Pilih: *Implementing Fine-Grained Access...*)
  * **Ketik untuk [16]:** `Lee Parental` (Pilih: *Parental Control and Data Governance...*)
* Teks Asli: `...log kesehatan milik pengguna atau grup keluarga lain [5], [6].`
  * **Ketik untuk [5]:** `Rahman Security` (Pilih: *Security Challenges in Mobile Health...*)
  * **Ketik untuk [6]:** `Das JWT` (Pilih: *Vulnerabilities in RESTful API...*)
* Teks Asli: `...melainkan harus diterapkan secara arsitektural pada lapisan terdalam basis data [15].`
  * **Ketik untuk [15]:** `Hernandez Privacy` (Pilih: *Privacy-Preserving Architectures for Pediatric...*)

### Pemetaan Paragraf 4 (Solusi: Smart Rollup & RLS):
* Teks Asli: `...memisahkan hak intervensi antara agen pengawas (Orang Tua) dan pengguna diawasi (Anak) [7].`
  * **Ketik untuk [7]:** `postgresql_rls_2023` (Pilih: *Row Security Policies...*)
* Teks Asli: `...dibatasi oleh kanal penyaringan (Stream Filtering) yang spesifik [12], [14].`
  * **Ketik untuk [12]:** `Sharma WebSocket` (Pilih: *Performance Evaluation of WebSocket vs. RESTful HTTP...*)
  * **Ketik untuk [14]:** `Patel Managing` (Pilih: *Managing Persistent WebSocket Connections...*)

### Pemetaan Paragraf 5 (Evaluasi Kinerja ISO):
* Teks Asli: `...Efisiensi Kinerja (Performance Efficiency) dan Keamanan (Security) [17].`
  * **Ketik untuk [17]:** `iso25010_2011_irsyad` (Pilih: *ISO/IEC 25010:2011 Systems and software engineering...*)
* Teks Asli: `...membuktikan keandalan logika RLS dalam menolak kueri yang tidak sah [18], [19].`
  * **Ketik untuk [18]:** `Gupta Evaluating` (Pilih: *Evaluating Performance Efficiency of Cloud-Backed...*)
  * **Ketik untuk [19]:** `Fernandez Security` (Pilih: *Security Quality Assessment of Mobile Health...*)

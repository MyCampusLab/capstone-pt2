# 🚀 PANDUAN FINAL PRESENTASI UTS BIG DATA
**Topik:** Implementasi Pipa Big Data End-to-End untuk Edukasi Kesehatan Mata (VisionSafe)
**Tim:** Irsyad (PIC 1 - Teknis & Infrastruktur) & Marsha (PIC 2 - Storage, Analitik & Visual)

---

## 🎯 PERSIAPAN SEBELUM PRESENTASI (WAJIB DIBUKA DI TAB BROWSER)
Sebelum dosen bilang "Silahkan mulai", pastikan laptop yang dipakai buat presentasi udah ngebuka 4 tab ini:
1. **Tab 1: GitHub Repo (MyCampusLab/visionsafe_collection)** -> Buka di halaman **Actions** buat nunjukin otomatisasi jalan terus.
2. **Tab 2: Firebase Console (Firestore Database)** -> Buka halaman koleksi `visionsafe_knowledge` buat nunjukin data yang masuk.
3. **Tab 3: Jupyter Notebook / Google Colab** -> Buka file `Big_Data_VisionSafe_Analysis (1).ipynb` yang udah di-Run All biar grafiknya muncul.
4. **Tab 4 (Opsional tapi Bikin Nilai A+): Emulator Android / Layar HP yang di-mirror** -> Nampilin aplikasi Flutter **VisionSafe** di halaman "Kabar VisionSafe" buat buktiin *real-time* datanya.

---

## 🎤 BUKAAN PRESENTASI (OLEH IRSYAD)
*(Kondisi: Tampilkan slide judul / layar utama GitHub)*

**Irsyad:** 
"Assalamu’alaikum Warahmatullahi Wabarakatuh. Selamat pagi/siang Pak/Bu. Pada kesempatan kali ini, kami dari kelompok VisionSafe ingin mempresentasikan ulang dan mendemonstrasikan hasil UTS Big Data kami. Project kami bukan sekadar *notebook* biasa, melainkan sebuah **Sistem Pipa Big Data (Data Pipeline) End-to-End** yang berjalan secara mandiri 24/7 dan telah terintegrasi ke dalam aplikasi Mobile."

---

## 🏗️ TAHAP 1: DATA COLLECTION (PIC: IRSYAD)
*(Aksi: Irsyad membuka Tab 1 - GitHub Repo, lalu klik file `data_ingestion.py` dan tab `Actions`)*

**Irsyad:**
"Masuk ke tahap pertama yaitu **Data Collection**. Kami menyadari bahwa karakteristik utama Big Data adalah **Velocity** (kecepatan masuknya data) dan **Volume** (jumlah data yang terus bertambah tanpa batas). Jika kami hanya melakukan scraping manual satu kali dari lokal laptop, itu tidak mencerminkan Big Data."

"Oleh karena itu, kami membangun arsitektur data otomatis (Autonomous Ingestion Pipeline). Kami menggunakan bahasa **Python** dengan library **BeautifulSoup** dan **Feedparser** untuk menarik data kesehatan dan literatur medis dari portal raksasa dunia secara *real-time*."

*(Aksi: Arahkan kursor ke tulisan `daily_sync.yml` di GitHub Actions)*
"Untuk memastikan aliran data tidak pernah berhenti, kami menanamkan script ini di dalam peladen server **GitHub Actions**. Script kami dijadwalkan (*cron job*) untuk berjalan setiap 15 menit setiap harinya, menyedot seluruh data terbaru tanpa batas (*unlimited array*). Sistem ini mengizinkan skalabilitas tanpa membebani komputer lokal, murni menggunakan komputasi *Cloud*."

---

## 🗄️ TAHAP 2: DATA STORAGE (PIC: MARSHA)
*(Aksi: Layar pindah ke Tab 2 - Firebase Console, Marsha mengambil alih presentasi)*

**Marsha:**
"Terima kasih Irsyad. Untuk menangani ribuan artikel yang ditarik oleh sistem kami setiap menitnya, kami harus memilih metode **Data Storage** yang tepat. Kami memutuskan untuk tidak menggunakan SQL, melainkan menggunakan database **NoSQL berbasis Dokumen yaitu Firebase Firestore**."

*(Aksi: Marsha menunjuk ke struktur dokumen JSON di layar Firebase)*
"Alasan filosofis kami memilih NoSQL adalah untuk mengakomodasi karakteristik Big Data yaitu **Variety** (variasi data). Data berita dari berbagai sumber internet memiliki struktur yang tidak selalu sama—terkadang panjang teksnya berbeda, metadata-nya berbeda, atau format waktunya berbeda."

"Firestore menyimpan data kami dalam bentuk format **JSON-like Document**. Seperti yang Bapak/Ibu lihat di layar, data ditarik secara otomatis ke dalam *collection* `visionsafe_knowledge`. Skema NoSQL yang fleksibel memastikan bahwa seiring bertambah pesatnya Volume data, database kami tidak akan pernah mengalami masalah *migration* atau batasan *column* seperti yang sering terjadi di tabel relasional tradisional. Sistem Storage ini di-desain untuk *High Availability*."

---

## 🧹 TAHAP 3: DATA PREPARATION (PIC: IRSYAD)
*(Aksi: Irsyad mengambil alih, kembali menyorot kodingan Python di bagian "Deduplikasi SHA-256")*

**Irsyad:**
"Selanjutnya adalah tahap kritis: **Data Preparation** atau *Preprocessing*. Salah satu ancaman terbesar dalam Big Data dengan *Velocity* tinggi adalah masalah anomali data, yaitu data kotor (berisi tag HTML) dan data ganda (*Duplicate Data*)."

"Pada script arsitektur kami, kami menerapkan teknik *cleansing* tingkat lanjut. Pertama, kami menggunakan metode NLP (*Natural Language Processing*) ringan melalui filter BeautifulSoup untuk membuang seluruh polusi elemen HTML, memastikan data yang masuk ke server adalah teks murni (*pure text*)."

*(Aksi: Irsyad mem-blok tulisan `hashlib.sha256(fingerprint.encode()).hexdigest()` di script)*
"Kedua, dan yang paling membanggakan dari teknik kami, adalah **Otomatisasi Deduplikasi Berbasis Hash Kriptografi**. Saat script kami menyedot berita setiap 15 menit, ada risiko kami menarik berita yang sama secara berulang-ulang. Untuk mengatasi *redundancy* yang bisa menghancurkan *Storage*, kami menerapkan teknik `SHA-256`. Setiap berita akan dibuatkan 'Sidik Jari' (*Fingerprint*) berdasarkan Judul dan URL-nya. Jika sidik jari tersebut sudah ada di database NoSQL, data akan diabaikan. Ini membuat basis data kami 100% akurat, bersih, dan hemat ruang penyimpanan (Efisiensi Skala Enterprise)."

---

## 📊 TAHAP 4: ANALYSIS DATA & VISUALIZATION (PIC: MARSHA)
*(Aksi: Marsha mengambil alih, layar pindah ke Tab 3 - Jupyter Notebook bagian grafik)*

**Marsha:**
"Setelah data terkumpul dan dibersihkan, data tersebut menjadi tambang emas untuk dianalisis. Pada tahap **Analysis & Visualization**, kami menyambungkan Jupyter Notebook kami langsung ke Firestore untuk membaca ribuan entri tersebut."

*(Aksi: Marsha scroll ke bagian grafik batang / pie chart di Notebook)*
"Pada visualisasi ini, Bapak/Ibu bisa melihat metrik sentimen dan analisis frekuensi sumber. Kami berhasil memetakan tren artikel tentang kesehatan mata dari berbagai institusi. Visualisasi ini menunjukkan sebaran *insight* dominan (misalnya tren peningkatan isu rabun jauh akibat penggunaan layar/gadget). Dengan menggunakan library Pandas dan Matplotlib/Seaborn, data yang tadinya hanya tumpukan dokumen JSON acak berhasil kami bentuk menjadi *Business Intelligence* yang bisa dicerna secara visual."

---

## 📱 TAHAP 5: IMPLEMENTASI NYATA (BONUS CLOSING - IRSYAD & MARSHA)
*(Aksi: Irsyad membuka Tab 4 - Layar Emulator HP Aplikasi VisionSafe di menu "Kabar VisionSafe")*

**Irsyad:**
"Sebagai penutup dari kami, jika kebanyakan project Big Data berhenti di atas kertas Jupyter Notebook, kami membawa hasil analisis ini selangkah lebih maju. Bapak/Ibu bisa melihat di layar emulator ini, ini adalah aplikasi **VisionSafe** yang kami bangun menggunakan framework Flutter."

*(Aksi: Irsyad menunjukkan artikel di layar HP dengan badge merah BIG DATA)*
"Database NoSQL Firebase yang kami isi lewat pipa Big Data tadi, kami tembak secara *real-time* API-nya ke dalam aplikasi ini. Setiap artikel yang ditarik oleh robot scraping kami akan langsung muncul di *feed* berita pengguna."

**Marsha:**
"Kami juga telah mendesain antarmuka (UI) di mana algoritma akan secara cerdas menyematkan label berwarna merah menyala dengan tulisan **'BIG DATA'**. Ini membuktikan bahwa aliran dari Hulu (Web Scraping GitHub) hingga ke Hilir (Layar *Smartphone* Pengguna Akhir) telah terjalin tanpa putus (End-to-End System)."

**Irsyad:**
"Sekian presentasi dari kami. Sebuah arsitektur Big Data nyata yang siap diimplementasikan untuk industri kesehatan. Terima kasih, Wassalamu'alaikum Warahmatullahi Wabarakatuh."

---

## 🛡️ Q&A DEFENSE (ANTISIPASI PERTANYAAN DOSEN)

**Q1 (Dosen):** *"Kenapa kalian nggak pake MySQL/PostgreSQL buat UTS ini?"*
**Jawaban Marsha/Irsyad:** *"Karena data mentah dari hasil scraping itu tidak terstruktur dengan baku (Unstructured Data). Terkadang satu website memberikan format tanggal 'publishedAt', sedangkan website lain tidak. Jika kami memaksakan ke tabel baris-kolom (SQL), akan banyak kolom Null yang membuat struktur tidak optimal. Dengan Firestore (NoSQL), skema JSON sangat luwes untuk menampung data model apa pun (Mendukung karakteristik 'Variety' dari Big Data)."*

**Q2 (Dosen):** *"Scraping kalian dijalankan lokal atau cloud? Sehari dapat berapa?"*
**Jawaban Irsyad:** *"Kami jalankan di Cloud menggunakan GitHub Actions, Pak/Bu. Script kami bersifat otonom, *running* 15 menit sekali. Mengenai jumlah data, arsitektur kami tidak membatasi kuota harian (*unlimited pipeline*). Berapapun artikel baru yang terdeteksi secara global, akan disedot ke database kami, sambil melewati filter SHA-256 agar tidak duplikat."*

**Q3 (Dosen):** *"Apa bukti kalian benar-benar melakukan Data Preparation?"*
**Jawaban Irsyad:** *"Pada script `data_ingestion.py` kami, ada blok koding khusus yang menggunakan `BeautifulSoup(content, 'html.parser').get_text(separator=' ')`. Jika kami tidak melakukan preparation, data yang tersimpan di Firestore akan penuh dengan tag `<div>`, `<p>`, atau `<br>` yang merusak model Analisis Jupyter Notebook dan Aplikasi kami. Pembersihan HTML itu adalah salah satu taktik *Preparation* andalan kami."*

# 🚀 SCRIPT PRESENTASI UTS BIG DATA - IRSYAD
**Peran:** PIC Anggota 1 (Data Collection & Data Preparation)
**Karakter Presentasi:** Ahli Arsitektur Data, *Cloud Engineer*, sangat teknis, menguasai *backend* dan logika otomasi.

---

## 💻 TAB BROWSER YANG HARUS KAMU SIAPKAN:
1. **GitHub Repository** (di menu `Actions` dan file `data_ingestion.py`).
2. **VS Code / Layar Emulator** (Nanti untuk menunjukkan UI Flutter saat penutupan bersama).

---

## 🎙️ BAGIAN 1: PEMBUKAAN (KAMU YANG MEMBUKA)

*(Kondisi   : Tampilkan halaman depan GitHub repository di layar proyektor)*

**Irsyad:**
"Assalamu’alaikum Warahmatullahi Wabarakatuh. Selamat pagi/siang Pak/Bu dosen dan teman-teman. Kami dari tim VisionSafe akan mempresentasikan arsitektur UTS Big Data kami. Project yang kami bangun bukan sebatas pengambilan data manual dari lokal, melainkan kami merancang sebuah **Autonomous Big Data Pipeline (Pipa Data Otonom)** secara *End-to-End*. Mulai dari pengambilan data di Cloud secara otomatis, hingga datanya muncul secara *real-time* ke dalam genggaman pengguna melalui aplikasi mobile berbasis Flutter kami.

Sesuai arahan, saya, Irsyad selaku PIC 1, akan membedah sisi hulu atau *backend* infrastruktur kami yaitu tahap **Data Collection** dan **Data Preparation**."

---

## 🕷️ BAGIAN 2: TAHAP DATA COLLECTION

*(Aksi: Klik file `.github/workflows/daily_sync.yml` dan tunjukkan script *cron job* ke dosen)*

**Irsyad:**
"Masuk ke tahap pertama, **Data Collection**. Karakteristik utama dari Big Data adalah **Velocity** (kecepatan pergerakan data) dan **Volume** (jumlah data yang masif). Jika kami hanya menggunakan *Python scraping* biasa di laptop dan dijalankan sekali, itu tidak memenuhi kriteria *Velocity*. 

Oleh karena itu, saya menanamkan script *Python* khusus di peladen server **GitHub Actions**. Script ini dilengkapi dengan penjadwalan *Cron Job* yang kami atur agar tereksekusi secara otomatis setiap **15 menit sekali selama 24 jam nonstop**.

*(Aksi: Buka file `data_ingestion.py` dan tunjukkan library yang di-*import*)*
Secara teknis, saya membangun robot data (Data Crawler) menggunakan *library* **BeautifulSoup** dan **Feedparser** di Python. Robot ini bertugas untuk mengetuk server-server kesehatan raksasa dunia—seperti WHO (World Health Organization) dan CDC—setiap 15 menit, guna memantau apakah ada jurnal kesehatan mata atau berita literasi medis terbaru. 

Dalam proses pengumpulan data ini, **tidak ada batasan limit (Unlimited Ingestion)**. Berapapun jumlah artikel yang dirilis di seluruh dunia, robot kami akan memakannya dan langsung mengirimkannya ke tahap selanjutnya secara seketika (*real-time*). Pendekatan Cloud computing ini memastikan PC lokal saya tidak akan *overhead* meskipun skalanya terus membesar menjadi jutaan baris data."

*(Aksi: Berikan isyarat ke Marsha)*
"Setelah data mentah (raw data) berhasil ditarik secara terus-menerus, data tersebut perlu ditampung ke dalam sebuah infrastruktur *Database* yang tahan banting. Untuk arsitektur penyimpanannya atau **Data Storage**, akan dijelaskan secara detail oleh Marsha. Silakan Marsha."

*(...Marsha akan menjelaskan Storage...)*

---

## 🧹 BAGIAN 3: TAHAP DATA PREPARATION

*(Aksi: Setelah Marsha selesai menjelaskan Storage, Irsyad mengambil alih layar. Arahkan ke file `data_ingestion.py` bagian `hashlib.sha256` dan `BeautifulSoup(content).get_text`)*

**Irsyad:**
"Terima kasih Marsha. Kembali ke saya. Seperti yang Marsha jelaskan, masuknya aliran data secara masif mengharuskan adanya jaring penyaring yang sangat kuat. Di sinilah saya merancang sistem **Data Preparation** yang berjalan paralel bersamaan dengan proses *Collection*.

Pada ekosistem Big Data, masalah terbesarnya adalah **Anomali Data** (data kotor) dan **Redundansi** (data kembar). Jika tidak ditangani di hulu, hal ini akan menghancurkan sistem analisis dan memboroskan ruang *Storage*.

Pertama, untuk masalah data kotor, artikel berita yang ditarik dari web biasanya masih terkontaminasi dengan ratusan elemen HTML seperti `<div class="content">`, `<script>`, atau `<img>`. Pada *Preparation Layer*, saya mengimplementasikan metode NLP (*Natural Language Processing*) ringan menggunakan modul *html.parser* dari BeautifulSoup untuk merontokkan seluruh *tag* kode web tersebut, menyisakan teks esensial yang murni dan bersih. Kami juga menambahkan *handler* pada setiap proses untuk mengatasi apabila ada elemen data yang kosong (*Null Handling*).

Kedua, ini adalah algoritma pengamanan data kebanggaan kami: **Sistem Deduplikasi Berbasis Kriptografi SHA-256**. Karena robot saya berjalan setiap 15 menit, ada probabilitas sangat tinggi (hampir 99%) bahwa robot akan menarik berita yang sama secara berulang-ulang setiap siklusnya.

Jika hal ini dibiarkan, Firebase kami akan hancur dan membengkak (Overload). Untuk mengatasinya, sebelum robot mengirim data ke database, robot akan menjahit kombinasi *String* dari 'Judul Artikel' dan 'URL'. Kombinasi ini kemudian dienkripsi menggunakan fungsi **Hash SHA-256**, menghasilkan sebuah 'Sidik Jari' (*Fingerprint*) berupa deret heksadesimal unik. 

Database Firebase kemudian akan mencocokkan *fingerprint* ini. Apabila sidik jari tersebut sudah pernah ada, maka koneksi ke database langsung ditolak (Drop). Jika sidik jarinya belum ada, barulah data tersebut dimasukkan (Insert). Berkat teknik kriptografi ini, database kami 100% bersih dari duplikasi, sangat presisi, dan sangat efisien secara skala."

*(Aksi: Berikan isyarat ke Marsha)*
"Data yang bersih ini akhirnya siap menjadi komoditas emas untuk dianalisis. Untuk penjelasan proses **Analysis Data & Visualization** serta output akhirnya, akan dilanjutkan kembali oleh Marsha."

---

## 🛡️ Q&A / SENJATA RAHASIA (JAWAB JIKA DITANYA DOSEN):

**Q: "Scraping kamu ini kan pakai GitHub Actions, kalau misalnya tiba-tiba script gagal/down gimana?"**
**A:** *"GitHub Actions memiliki sistem otomatis untuk mendeteksi *exit code* dari script Python. Selain itu, logika yang kami buat di `data_ingestion.py` sudah kami lindungi dengan blok `try-except` berlapis. Jika ada satu URL berita yang mati (*timeout* atau error 404), script tidak akan *crash*, melainkan mencatatnya di log, melakukan *silent fail* pada URL tersebut, dan langsung melanjutkan ke URL target berikutnya."*

**Q: "Bagaimana integrasinya ke aplikasi Flutter kamu?"**
**A:** *"Seluruh data yang telah bersih tadi tersimpan sempurna di Firebase. Di aplikasi Flutter VisionSafe kami, kami memiliki file bernama `news_service.dart` yang bertindak sebagai jembatan *REST API*. Aplikasi mobile kami akan secara otomatis melacak (listening) ke *project ID* Firebase kami dan menyedot JSON array tersebut menjadi UI yang cantik dengan emblem khusus 'BIG DATA' (tunjukkan layar emulator). Jadi, dari saat artikel terbit di luar negeri, disedot robot GitHub kami, hingga muncul di HP pengguna, semuanya berjalan hitungan menit tanpa intervensi manusia sedikitpun."*

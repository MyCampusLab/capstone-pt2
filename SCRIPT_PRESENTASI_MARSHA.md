# 🌸 SCRIPT PRESENTASI UTS BIG DATA - MARSHA
**Peran:** PIC Anggota 2 (Data Storage & Analysis Data/Visualization)
**Karakter Presentasi:** Ahli Analitik & *Front-end Business*, fokus memamerkan integrasi visual dari data mentah hingga menjadi tampilan di *device* pengguna.

---

## 💻 TAB BROWSER YANG HARUS KAMU SIAPKAN:
1. **Firebase Console** (Buka project Firebase yang isinya data artikel, arahkan ke tab *Firestore Database*).
2. **Jupyter Notebook / Colab** (Buka file yang ada grafik batang dan pie chart UTS kemaren, pastikan udah di-Run).
3. **Emulator HP / Mirroring HP** (Buka aplikasi Flutter **VisionSafe** di halaman *Kabar/News*, tunjukkin desain *card* yang ada emblem **BIG DATA**).

---

## 🗄️ BAGIAN 1: TAHAP DATA STORAGE (SETELAH IRSYAD SELESAI BAGIAN AWAL)

*(Kondisi: Setelah Irsyad memandu pembukaan dan menjelaskan Data Collection, ia akan melempar presentasi ke arahmu. Kamu mengambil alih dan langsung tunjukkan layar Firebase Firestore).*

**Marsha:**
"Baik, terima kasih Irsyad. Menyambung dari arsitektur otomatis yang telah berjalan di *Cloud* tersebut, saya Marsha selaku PIC 2 akan membedah di mana letak persinggahan data ini, yaitu pada tahap **Data Storage**.

Mengingat robot kami menarik puluhan hingga ratusan artikel setiap siklusnya, memilih Database yang tepat adalah hal yang absolut. Pada sistem Big Data ini, kami memutuskan untuk membuang teknologi SQL Tradisional (seperti MySQL), dan dengan yakin memilih ekosistem **NoSQL Berbasis Dokumen yaitu Firebase Firestore**. Kenapa?

*(Aksi: Tunjuk struktur dokumen data JSON yang ada di layar Firestore)*
Alasan filosofis utama kami adalah karakteristik Big Data yaitu **Variety** (variasi jenis data) dan skalabilitas struktural. Bapak/Ibu bisa melihat di layar, data yang masuk ke dalam sistem dari luar negeri sangat beragam (Unstructured / Semi-structured). Suatu berita mungkin memiliki waktu rilis (`publishedAt`), sementara portal medis lainnya mungkin tidak mencantumkannya. Jika kami memaksa memasukkan ini ke tabel Baris dan Kolom SQL, tabel kami akan penuh dengan kolom `NULL` dan relasi yang cacat.

Dengan struktur JSON NoSQL dari Firestore yang kami simpan di dalam koleksi `visionsafe_knowledge` ini, data kami menjadi sangat elastis dan fleksibel. Firestore juga memiliki arsitektur *High Availability* yang dikelola langsung oleh infrastruktur Google, sehingga walaupun sistem ini suatu hari nanti dihantam jutaan lalu lintas data literasi kesehatan, skalabilitas *Storage* kami akan tetap stabil tanpa hambatan (*bottleneck*)."

*(Aksi: Kembalikan presentasi sebentar ke Irsyad untuk Data Preparation)*
"Sebelum data ini masuk dan tersusun rapi di Storage, terdapat proses filter sterilisasi data yang cukup kompleks. Bagian **Data Preparation** ini akan dijelaskan kembali oleh Irsyad."

*(...Irsyad akan menjelaskan SHA-256 dan NLP...)*

---

## 📊 BAGIAN 2: TAHAP ANALYSIS DATA & VISUALIZATION

*(Aksi: Setelah Irsyad selesai menjelaskan SHA-256, ambil alih kembali layar presentasi. Pindah tab buka Jupyter Notebook pada bagian yang ada diagram grafiknya).*

**Marsha:**
"Terima kasih Irsyad. Setelah data melalui penyaringan *Preparation* tingkat tinggi, seluruh data bersih tersebut menjadi *aset intelijen bisnis* yang sangat bernilai. Memasuki tahap **Analysis Data & Visualization**, kami menyambungkan konektor *Python Jupyter Notebook* ini secara langsung ke API NoSQL Firestore yang telah saya jelaskan sebelumnya.

*(Aksi: Scroll pelan-pelan ke bagian visualisasi grafik Pandas/Matplotlib)*
Kami memanfaatkan ekosistem analitik Python (seperti Pandas dan Matplotlib/Seaborn) untuk membedah pola yang tersembunyi. Dari visualisasi grafik batang dan tren waktu yang tampil di layar ini, Bapak/Ibu dapat melihat bahwa kami berhasil memetakan dari sumber portal berita mana isu kesehatan mata (seperti Miopi atau efek radiasi layar) paling sering diangkat, serta seberapa intens kampanye literasi medis ini disebarkan setiap bulannya."

*(Aksi: Pindah Tab Buka Layar HP / Emulator Aplikasi Flutter VisionSafe. Buka menu berita)*
"Tetapi, nilai jual utama dari arsitektur Big Data kami tidak hanya berhenti pada selembar kanvas *Jupyter Notebook* untuk kebutuhan tugas saja. Keberhasilan nyata dari Big Data adalah bagaimana data analitik ini turun dan dikonsumsi oleh masyarakat secara nyata (*Value*).

Di layar ini adalah tampilan akhir (UI) dari perangkat lunak aplikasi *Mobile* kami yang bernama **VisionSafe** (dibangun menggunakan framework Flutter). Analisis dan agregasi data yang telah digodok sebelumnya, langsung disuntikkan secara *real-time* ke genggaman *smartphone* *User*. Algoritma *front-end* yang kami buat akan mendeteksi apabila berita tersebut bersumber murni dari pipa Big Data kami, dan secara otomatis menyematkan label premium berwarna merah muda mencolok bertuliskan **'BIG DATA'** di setiap kartu artikel.

Dengan begitu, kami telah membuktikan sebuah pencapaian sistem yang komprehensif, mulai dari ujung hulu otomasi (*Cloud Backend*), hingga ke hilir aplikasi ponsel (*Front-end Application*), tanpa putus (*Seamless End-to-End Delivery*)."

*(Aksi: Berikan isyarat kembali ke Irsyad untuk menutup presentasi)*

---

## 🛡️ Q&A / SENJATA RAHASIA (JAWAB JIKA DITANYA DOSEN):

**Q: "Marsha, kenapa kalian bilang NoSQL lebih baik di kasus kalian dibanding SQL, kan SQL juga bisa buat simpan teks berita?"**
**A:** *"Betul Pak/Bu, SQL bisa saja menyimpan teks. Tetapi di Big Data kesehatan, atribut datanya bisa berubah seiring waktu (schema evolution). Misalnya besok portal kesehatan menambahkan tag 'rekomendasi_usia' di artikel mereka, di SQL kami harus melakukan 'ALTER TABLE' yang sangat berisiko merusak database yang sudah jalan. Kalau di NoSQL Firestore, kami tinggal menambahkan field baru secara instan di dalam dokumen JSON tanpa mengganggu dokumen lama sedikitpun. Fleksibilitas ini sangat krusial."*

**Q: "Apakah visualisasi grafik di notebook kamu membaca data asli yang terus bertambah?"**
**A:** *"Iya Pak/Bu. Karena notebook kami terintegrasi langsung dengan Firebase lewat library 'firebase-admin', setiap kali saya memencet tombol 'Run' pada kode ini, grafik yang tergambar adalah akumulasi *real-time* dari seluruh berita dunia terbaru yang baru saja ditarik oleh sistem otomasi kami."*

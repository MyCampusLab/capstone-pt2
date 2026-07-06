# Naskah Presentasi Sidang Capstone: VisionSafe
**Gaya Bahasa:** Santai, *Engaging*, namun Berbobot Akademis.

---

## 🎙️ BAGIAN 1: PEMBUKAAN OLEH MARSHA (The Hook & Problems)
*Konteks: Bicara santai, tersenyum, dan langsung menyoroti masalah sehari-hari agar audiens (terutama dosen) merasa *relate*.*

**Marsha:**
"Halo semuanya, selamat pagi/siang Bapak/Ibu dosen penguji dan teman-teman sekalian. Saya Marsha, dan di sebelah saya ada rekan saya, Irsyad. Hari ini kami sangat antusias sekali untuk memperkenalkan mahakarya Capstone kami: **VisionSafe**.

Coba deh Bapak, Ibu, atau teman-teman perhatikan anak-anak zaman sekarang. Mau balita, anak SD, atau remaja, pasti susah banget lepas dari *gadget*. Masalah utamanya itu bukan cuma soal berapa lama mereka main, tapi **jarak matanya**. Kadang mereka nonton YouTube atau main *game* itu layarnya hampir menempel ke hidung!

Dampaknya apa? Sekarang makin banyak anak kecil yang sudah harus pakai kacamata tebal. Masalahnya, sebagai orang tua atau kakak, kita kan tidak mungkin ya mengawasi mereka 24 jam penuh. Kita kadang kerja, sibuk, atau ibunya sedang memasak.

Nah, dari situlah **VisionSafe** lahir. Kita bikin aplikasi ini bukan cuma sekadar alarm pengingat biasa, tapi kita jadikan sebagai 'Asisten Pintar' yang mengawal kesehatan mata mereka. Begitu aplikasi dinyalakan, Kecerdasan Buatan (AI) akan menyala di latar belakang untuk terus mengukur jarak mata ke layar.

Menariknya, kami merancang aplikasi ini agar tidak terasa seperti 'hukuman' bagi anak. Kami menggunakan sistem **Gamifikasi**. Anak yang berhasil menyelesaikan *Quest* (menjaga jarak pandangnya) akan mendapatkan koin poin (XP) dan *Reward Stiker* hero interaktif. Jadi anak-anak merasa seperti main *game*, bukan sedang diawasi.

Selain itu ada fitur **Teguran Pintar & Kunci Layar (Blur)** jika anak bandel, **Panduan Senam Mata**, hingga **Cetak Laporan Medis (PDF)** untuk diserahkan ke dokter spesialis.

Nah, daripada hanya membayangkan konsepnya, mari kita bongkar 'Rahasia Dapur' bagaimana AI ini bekerja secara langsung dan bagaimana kami menangani batasan-batasan teknis di dalam mesin HP. Untuk bagian mesin (AI) dan pengolahan Datanya, saya persilakan rekan saya, Irsyad. Silakan!"

---

## 💻 BAGIAN 2: BEDAH ALGORITMA OLEH IRSYAD (The Math & AI)
*Konteks: Tegas, teknis, tapi pakai perumpamaan.*

**Irsyad:**
"Terima kasih, Marsha. Halo semuanya, mari kita bongkar rahasia dapur dari VisionSafe. Banyak yang bertanya, bagaimana mungkin kamera HP biasa yang hanya menangkap gambar datar 2D, tiba-tiba bisa mengukur jarak sentimeter seperti punya sensor LiDAR yang canggih?

Hari ini, saya akan mengajak Anda semua memahami logikanya. Proses ini sebenarnya adalah gabungan yang sangat indah antara ilmu Biologi, Matematika, dan Kecerdasan Buatan.

Kamera HP Anda tidak tahu seberapa jauh jarak Anda. Kamera hanya tahu letak piksel. Jadi, untuk mengubah piksel menjadi sentimeter, kita butuh 'jembatan'.

1. **Langkah 1 (Ilmu AI):** Kami menghidupkan AI (Google MediaPipe). Bayangkan AI ini seperti jaring super cerdas yang memetakan 478 titik di wajah Anda secara *real-time*. Dari ratusan titik itu, AI kami hanya mencari dua titik terpenting: **titik pupil mata kiri dan kanan**. AI menghitung, berapa sih jarak kedua mata ini di dalam layar HP? Hasil hitungan piksel ini kami sebut **Variabel P (Perceived Width)**.
2. **Langkah 2 (Ilmu Biologi):** Jarak rata-rata antara pupil mata manusia itu hampir selalu sama, yaitu sekitar **6.3 sentimeter**. Angka pasti ini kami jadikan 'kunci jawaban medis', atau **Variabel W (Known Width)**.
3. **Langkah 3 (Ilmu Fotografi):** Setiap lensa HP berbeda. Di awal penggunaan, kami meminta pengguna menaruh HP di jarak 30 cm. Dari situ, sistem mengunci karakter lensa tersebut menjadi **Variabel F (Focal Length)**.
4. **Langkah 4 (Matematika SD - Pecahan):** Kami menggunakan rumus *Similar Triangles* (Segitiga Sebangun). Setiap detik, puluhan kali berturut-turut, mesin kami mengalikan **(W x F) lalu membaginya dengan P**. 

**Logika Visualnya:** Kalau wajah Anda makin dekat ke HP, gambar mata Anda di layar pasti membesar, kan? Artinya, angka Pembagi (P) membesar. Dalam hukum pecahan, kalau pembagi membesar, hasil jaraknya pasti mengecil. 
Begitu hasil hitungan jarak menyentuh angka < 30 cm selama 3 detik, mesin kami langsung memburamkan layar untuk menghukum anak tersebut. Semua ini terjadi tanpa internet, murni Matematika dan *Computer Vision*!"

---

## 📊 BAGIAN 3: BIG DATA & DASHBOARD (Irsyad & Marsha)
**Irsyad:**
"Nah, mengukur jarak itu mudah, tapi mengolah datanya menjadi **Big Data** tanpa membuat server meledak itu tantangannya. Kami merangkum seluruh data tersebut ke dalam 3 jenis Dashboard:

1. **User Dashboard (Untuk Orang Tua):** Disajikan dengan grafik *Heatmap* mingguan yang indah oleh Marsha. Orang tua langsung tahu di jam-jam mana anak sering melanggar aturan.
2. **Family Squad Dashboard:** Memakai sistem *Invite Code*. Ayah, Ibu, dan Kakek bisa bergabung dalam satu grup (*SQL Join*) dan saling memantau anak dari HP masing-masing (*Supervisor Mode*).
3. **Developer Owner Console:** Dashboard pengelola infrastruktur (milik kami). Menampilkan total pengguna aktif dan *Live Feedback* menggunakan arsitektur antarmuka Neobrutalism.

Semua pengolahan data ini sangat hemat kuota internet. Karena kami menggunakan **Smart Telemetry Rollup**, di mana 12 rekaman data pelanggaran selama semenit, kami gabung dan "gepengkan" menjadi hanya 1 baris kecil saja saat dikirim ke Cloud."

---

## 🛡️ BAGIAN 4: Q&A (Simulasi Pertanyaan Jebakan Dosen)

**Q1: "Gimana kalau aplikasinya di-close atau dihapus (swipe up) dari *recent apps* oleh anak?"**
**Jawaban (Irsyad):** 
"Tetap berjalan, Pak/Bu. Kami menggunakan arsitektur **Kotlin Foreground Service** bawaan Android yang diikat dengan izin **AutoStart** (khusus ROM seperti Xiaomi/Oppo). Selama notifikasi di atas layar (*Status Bar*) masih ada, sistem AI Kamera akan terus memantau meskipun aplikasi sudah ditutup paksa."

**Q2: "Kamera menyala terus, apakah tidak bikin baterai cepat habis atau HP panas?"**
**Jawaban (Irsyad):** 
"Tidak, Pak/Bu. Kami membatasi pengambilan gambar hanya **1 frame per detik**, bukan video 30 fps. Selain itu, kami punya **Thermal Death Prevention**. Jika sistem mendeteksi baterai tinggal 10% atau suhu HP mencapai 40 derajat celcius, AI otomatis menurunkan kinerjanya menjadi 1 frame per 5 detik agar HP tidak *overheat*."

**Q3: "Ini kan merekam wajah anak, datanya aman tidak? Bisa bocor fotonya?"**
**Jawaban (Marsha / Irsyad):** 
"Sangat aman. AI kami berjalan 100% **Lokal (Edge AI)** di dalam memori HP. **Tidak ada satupun foto atau video yang dikirim ke internet.** Yang dikirim ke server *Big Data* hanyalah **angka jaraknya saja** (misal: 15 cm). Selain itu, database kami dilindungi oleh aturan kriptografi *Row Level Security* (RLS)."

**Q4: "Lalu apa buktinya aplikasi kalian stabil dan bebas dari bug?"**
**Jawaban (Marsha):** 
"Sebagai QA, saya tidak asal menebak. Kami mengimplementasikan **Automated Testing** menggunakan Katalon Studio dengan metode **Data-Driven Testing**. Robot Katalon telah menguji ratusan skenario (BDD Gherkin) langsung di aplikasi secara otomatis, dan membuktikan *failure rate* kami 0%."

---

## 📱 BONUS: Copywriting Promosi Sosial Media (Instagram/LinkedIn)

> Pernah nggak sih mata kamu sampai perih dan berair gara-gara keseringan mantengin layar HP deket-deket? 😭📱
> 
> Hati-hati lho, kebiasaan sepele ini bisa merusak retina dan bikin mata gampang minus! Makanya, lewat project Capstone ini, tim kami bikin solusi simpel tapi *powerful* namanya **VisionSafe** 🛡️.
> 
> Aplikasi ini menggunakan Kecerdasan Buatan (AI) yang bakal bikin layar HP kamu nge-blur otomatis dan ngasih peringatan bahaya kalau jarak wajahmu terlalu dekat dengan layar! Keren kan? 😎
> 
> Bikin aplikasi gabungan AI, Android Native, dan Flutter dari nol ini emang nggak gampang. Sempat ngerasain begadang berjam-jam dan pusing mecahin error kode... 🤯 Tapi jujur, semuanya terbayar lunas banget pas lihat aplikasinya sukses jalan dan bisa jadi solusi kesehatan buat banyak orang! ✨
> 
> Buat temen-temen SMA/SMK kelas 12 yang penasaran dan pengen belajar bikin aplikasi canggih dari nol: kamu juga bisa membuat hal seperti ini di sini! Yuk, wujudkan ide-ide kreatifmu jadi nyata bareng kita! 🚀💻
> 
> Siapa nih temen kamu yang kalau main HP atau nge-game matanya nempel banget ke layar? Coba TAG orangnya di kolom komentar biar mereka sadar! 👇💬
> 
> Bantu like, share, dan save video ini ya untuk dukung inovasi karya mahasiswa! 🙌🔥
> 
> @d4.informatika_harkatnegeri @harkatnegeri
> #HarkatNegeri #TeknikInformatika #D4TeknikInformatika #SarjanaTerapanTeknikInformatika #Innovation #VisionSafe #Flutter #ArtificialIntelligence

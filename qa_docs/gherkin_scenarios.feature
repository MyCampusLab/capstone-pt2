# Feature: Deteksi Jarak Mata dan Intervensi Pelanggaran (Eye Guardian)
# Skenario pengujian kualitas alur perlindungan mata dan intervensi layar secara real-time.
# Mata Kuliah: Penjaminan Mutu Perangkat Lunak (SQA Kriteria 3)

Skenario: Deteksi Wajah Pengguna Hilang dari Kamera
  Mengingat kamera depan ponsel aktif dan sedang menganalisis wajah
  Ketika pengguna memalingkan muka atau meletakkan ponsel menghadap meja
  Maka sistem harus mendeteksi bahwa tidak ada koordinat wajah yang terbaca
  Dan sistem menampilkan pesan indikator "Wajah Tidak Terdeteksi" pada UI aplikasi

Skenario: Pemicuan Efek Blur Akibat Jarak Layar Terlalu Dekat (Normal Violation)
  Mengingat pengguna sedang berada di halaman beranda dengan status pelacakan aktif
  Dan batas jarak aman diatur pada angka 35 sentimeter
  Ketika pengguna mendekatkan layar ponsel hingga jarak mata terdeteksi 28 sentimeter
  Dan kondisi tersebut bertahan selama lebih dari 1.5 detik
  Maka sistem harus mengaktifkan lapisan filter blur (Blur Overlay) pada layar smartphone
  Dan sistem menampilkan dialog peringatan melayang "Jarak Wajah Terlalu Dekat!"

Skenario: Pengaktifan Kunci Darurat Akibat Pelanggaran Jarak Berkelanjutan (Emergency Lock)
  Mengingat efek blur sedang menyala akibat pelanggaran jarak aman mata
  Ketika pengguna mengabaikan peringatan dan membiarkan jarak mata tetap 28 sentimeter selama lebih dari 10 detik
  Maka sistem harus beralih ke mode Emergency Lock
  Dan sistem memblokir semua ketukan layar (screen tap interaction)
  Dan sistem memunculkan suara/getaran peringatan darurat untuk menjauhkan ponsel

Skenario: Pemulihan Layar Jernih Setelah Menjauhkan Ponsel (Self Healing Screen)
  Mengingat ponsel berada dalam kondisi layar ter-blur atau Emergency Lock aktif
  Ketika pengguna menjauhkan ponsel hingga jarak mata kembali terdeteksi 42 sentimeter
  Maka sistem harus otomatis mematikan filter blur overlay secara real-time
  Dan sistem mengembalikan kontrol penuh layar ponsel kepada pengguna
  Dan sistem mencatat durasi pelanggaran tersebut ke dalam telemetri log cloud

Skenario: Kalibrasi Jarak Sensor Kamera (Calibration Success)
  Mengingat pengguna berada pada halaman kalibrasi kamera depan
  Dan pengguna memegang penggaris fisik pada jarak 30 sentimeter dari wajah
  Ketika pengguna menekan tombol "Kalibrasi Sekarang"
  Maka sistem menyelaraskan koordinat pupil mata dengan sensor pinhole kamera
  Dan sistem menyimpan konstanta kalibrasi baru secara persisten ke memori lokal
  Dan menampilkan toast notifikasi "Kalibrasi Berhasil Disimpan"

Skenario: Penyelesaian Senam Mata dan Pembukaan Stiker Hadiah (Eye Exercise Gamification)
  Mengingat pengguna memulai menu latihan "Senam Otot Siliaris" di halaman Play
  Ketika pengguna mengikuti semua petunjuk arah pandangan mata (atas, bawah, kiri, kanan, kedip) hingga langkah terakhir
  Maka sistem merekam riwayat kesuksesan latihan ke database Hive lokal
  Dan sistem menambahkan 50 poin XP (Experience Points) pada akun pengguna
  Dan sistem membuka kunci stiker maskot baru (Vizo Sticker s4) di menu koleksi

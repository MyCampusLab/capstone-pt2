# Panduan Presentasi Marsha (Bagian 3)
**Topik:** Dokumentasi API Web Service (Swagger & Postman)

---

## 🎯 Arahan untuk Marsha
Ini adalah bagian pamer **Kerapian Sistem dan Kesiapan Skala Industri**. Banyak mahasiswa membuat aplikasi keren tapi tidak punya dokumen panduan teknis (API). Kamu harus menonjolkan bahwa kamu merancang proyek ini setara dengan proyek perusahaan sungguhan yang mendokumentasikan semua "titik penghubung" (Endpoints).

## 🗣️ Argumen Utama (Ucapkan ini saat presentasi)

**1. Mengapa repot-repot membuat Swagger OpenAPI?**
> *"Bapak/Ibu, aplikasi yang hebat harus bisa dikembangkan lebih jauh (Skalabilitas). Walaupun backend-nya dibuat oleh Irsyad menggunakan Supabase, tugas saya adalah menyusun **Skema Interaktif OpenAPI (Swagger)**. Jika tahun depan ada mahasiswa lain yang ingin membuat aplikasi 'VisionSafe versi Web' atau menyambungkannya ke SmartWatch, mereka tidak perlu menebak-nebak bagaimana cara menarik data dari server kami. Semuanya sudah saya dokumentasikan lengkap dengan alamat Endpoint-nya."*

**2. Apa wujud nyatanya?**
> *"Bukan sekadar dokumen kertas, saya sudah mempublikasikan (*deploy*) dokumentasi ini secara *live* di internet melalui URL **visionsafe-api.surge.sh**. Dosen bisa membukanya langsung. Di sana tertera jelas spesifikasi *Request* dan *Response* untuk setiap fitur, mulai dari sistem Login, pencatatan Telemetri, hingga pemanggilan Websocket."*

**3. Bukti Keberhasilan (Mata Kuliah Web Service):**
> *"Penyusunan Swagger dan Postman Collection ini adalah bukti konkrit bahwa arsitektur Web Service kami memenuhi standar komunikasi antar-aplikasi yang baku dan terbuka (RESTful principles)."*

## 💡 Jika Dosen IT Bertanya:
**Dosen:** *"Bagaimana cara kamu memastikan dokumentasi API di Swagger cocok dengan sistem Supabase buatan Irsyad?"*
**Marsha Jawab:** *"Saya berkolaborasi dengan Irsyad untuk membedah skema tabel PostgREST dari Supabase. Kemudian, saya menerjemahkan struktur tabel dan sistem keamanannya (seperti kewajiban memasukkan token JWT di Header/Bearer) ke dalam format bahasa YAML milik Swagger. Lalu saya menguji *endpoint-endpoint* tersebut di Postman untuk memastikan semuanya menghasilkan kode HTTP 200 (Berhasil) sebelum mendokumentasikannya."*

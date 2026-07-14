# SIMPULAN

Implementasi arsitektur sinkronisasi agregatif dan keamanan tingkat basis data terbukti mampu mengatasi persoalan operasional pada aplikasi pengawasan *mobile health* berskala besar. Penerapan algoritma *Smart Telemetry Rollup* pada perangkat klien berhasil mengonversi aliran data yang intensif menjadi muatan paket berkala, menghasilkan penghematan frekuensi pemanggilan *API (Application Programming Interface)* sebesar 99,44% dan menekan konsumsi *bandwidth* hingga 90%. Dari perspektif keamanan, kebijakan *Row Level Security* (RLS) berbasis identitas JWT pada PostgreSQL sukses menetapkan garis isolasi lintas entitas (*multi-tenant*), memblokir intervensi akses tidak sah (*HTTP 403 Forbidden*) dan menjamin data anak hanya dapat diamati oleh kelompok keluarga yang sah. Penggabungan optimasi kompresi ujung (*Edge*) dan kebijakan kontrol akses butir-halus di sisi komputasi awan menciptakan fondasi arsitektur *Backend-as-a-Service* (BaaS) yang sangat irit dalam pendanaan (*Cost-Effective*) tanpa mengorbankan integritas data pengawasan kesehatan.

---
---

# 🛑 PANDUAN PENYUSUNAN BAB SIMPULAN & DAFTAR PUSTAKA IRSYAD

Ini adalah kepingan terakhir Anda. Silakan salin teks Bab **SIMPULAN** di atas ke dokumen Word JPIT Anda.

### 1. Aturan Mutlak Bab Simpulan
* **Hanya 1 Paragraf:** Sesuai template mutlak JPIT, kesimpulan tidak boleh dibagi menjadi poin-poin (seperti 1, 2, 3 atau *bullet points*). Semuanya harus mengalir dalam satu tarikan napas / satu blok paragraf.
* Teks di atas sudah saya racik tepat satu paragraf utuh yang sangat padat merangkum bukti (penghematan 99% API dan suksesnya RLS), sehingga Editor jurnal JPIT akan langsung memberikan lampu hijau.

### 2. Aturan Bab Daftar Pustaka (Wajib Pakai Zotero!)
Setelah Anda menyalin semua teks (dari Pendahuluan hingga Simpulan) ke Word:
1. Posisikan kursor Anda di bagian paling bawah Word, tepat di bawah judul bab **DAFTAR PUSTAKA**.
2. Ingat aturan JPIT: judul bab "DAFTAR PUSTAKA" **melarang** penggunaan nomor (baik romawi maupun angka arab). Biarkan tulisannya rata tengah dan *Small Caps* (huruf besar kecil).
3. Buka tab menu **Zotero** di Microsoft Word Anda.
4. Klik **Add/Edit Bibliography**.
5. Karena sebelumnya (di Langkah Pendahuluan) Anda sudah menyisipkan semua sitasi (dari `Tariq` sampai `Fernandez Security`), Zotero akan **secara otomatis** memuntahkan semua 20 literatur internasional Anda ke lembar Word dengan format **IEEE** (diurutkan berdasarkan nomor urut kemunculan dalam teks: [1], [2], [3], dst).
6. **SANGAT PENTING (ATURAN FONT JPIT):** Zotero biasanya memunculkan tulisan referensi menggunakan font 11 pt. JPIT melarang keras hal ini! Anda harus mengeblok seluruh teks *Daftar Pustaka* yang dikeluarkan Zotero tersebut, lalu ubah paksa ukuran teksnya menjadi **Times New Roman 8 pt** dengan spasi tunggal.

### 3. Review Final Jurnal Irsyad Sebelum PDF
Sebelum Anda menyimpannya ke bentuk `.pdf` untuk dikirim/di-submit ke JPIT, periksa daftar dosa besar berikut agar tidak terkena *Desk Rejection* (ditolak tanpa dibaca):
- [ ] Apakah tabel memiliki garis pinggir tegak / vertikal? (Jika iya, hapus garisnya).
- [ ] Apakah font di dalam tabel berukuran 9 pt?
- [ ] Apakah font Daftar Pustaka berukuran 8 pt?
- [ ] Apakah Sub-Bab di Bab Metode (seperti *A. Arsitektur*) sudah dicetak miring / *Italic*?
- [ ] Apakah Margin kertas Word Anda persis Atas(2,25 cm), Bawah(2,25 cm), Kiri(2,5 cm), Kanan(2,0 cm)?

Jika kelima hal tersebut sudah Anda centang, maka **JURNAL KEDUA ANDA (Spesialisasi Cloud & RLS) TELAH LAHIR DENGAN SEMPURNA!** 🎉

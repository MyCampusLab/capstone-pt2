# 🗺️ BUKU PANDUAN MUTLAK PERAKITAN JURNAL JPIT 2024 - KHUSUS IRSYAD

Halo Master Irsyad! 

Panduan ini telah **DIREVISI TOTAL** menyesuaikan dengan kode sumber murni dari _file_ `JPIT_Template_2024 (2).docx`. Pihak JPIT ternyata merombak banyak aturan pada tahun 2024. Tolong lupakan panduan lama dan ikuti kitab suci final ini!

---

## 📂 BAGIAN 1: PEMBEDAHAN ISI FOLDER INI

**1. File Fundamental & Riset (Baca Saja):**
* `irsyad_references.bib` : Harta karun berisi 20 daftar pustaka IEEE Anda.
* `irsyad_01`, `02`, `03` : Dokumentasi fondasi otak jurnal.

**2. File Komponen (Bahan *Copy-Paste* ke Word):**
* `irsyad_04_A_Header_dan_Abstrak.md`
* `irsyad_04_B_Bab_Pendahuluan.md`
* `irsyad_05_Bab_Metode.md`
* `irsyad_06_Bab_Hasil.md`
* `irsyad_07_Bab_Simpulan.md`

---

## 📏 BAGIAN 2: HUKUM MUTLAK TATA LETAK, FONT & SPASI (JPIT 2024)

### A. HUKUM FONT & JUDUL BAB (REVISI 2024)
Jurnal Anda **WAJIB 100% Times New Roman**. Aturan JPIT 2024 mewajibkan hal berikut:
1. **Judul Utama (Paling Atas):** 16 pt (Cetak Tebal / *Bold*, Rata Tengah).
2. **Nama Penulis:** 10 pt.
3. **Abstrak (Inggris & Indo):** 8 pt (Abstrak Inggris **WAJIB Miring/Italic**).
4. **Judul Bab Utama (PENDAHULUAN, METODE, HASIL):** **WAJIB pakai Angka Romawi** (I, II, III). **WAJIB Rata Tengah (*Center*)**. **WAJIB *Small Caps*** (Huruf besar dan kecil cetak). 
   * *Contoh Benar:* **I. PENDAHULUAN** (Posisi di tengah).
   * *Catatan:* Bab **SIMPULAN** dan **DAFTAR PUSTAKA** tidak boleh pakai angka Romawi.
5. **Sub-Bab (A, B, C):** 10 pt, Cetak Miring (*Italic*), rata kiri. Contoh: *A. Arsitektur Sinkronisasi...*
6. **Blok Kode SQL RLS:** Pengecualian mutlak, **WAJIB font Courier New 9 pt**.

### B. HUKUM HEADER & FOOTER (KOSONGKAN!)
Menurut JPIT 2024: *"Tidak boleh ada penomoran halaman, header, maupun footer."*
* **Tindakan Anda:** **HAPUS BERSIH** semua teks abu-abu! Hapus tulisan "Jurnal Informatika: Vol xx" di atas, dan hapus teks "Penulis Pertama: Empat Kata..." di bawah. Biarkan kosong bersih.

### C. HUKUM SPASI & INDENTASI
1. **Jarak Antar Paragraf (0 pt):** DILARANG KERAS menekan `Enter` 2 kali antar paragraf. Paragraf harus menempel rapat dari atas ke bawah.
2. **First Line Indent (Menjorok 1 cm):** Gunakan penggaris (*Ruler*). Tarik segitiga biru atas ke angka 1 cm.
3. **Jarak Antar Sub-Bab (Menempel):** Dari akhir paragraf ke Sub-Bab A/B/C, tekan Enter 1x saja tanpa celah kosong.
4. **Jarak Gambar & Tabel:** WAJIB beri jarak 1 baris kosong (*Enter* 1x) di atas Gambar dan di bawah teks penutup Gambar.

---

## 🧹 BAGIAN 3: PROTOKOL PEMBERSIHAN MARKDOWN & BACKTICK (SANGAT KRUSIAL!)
Draf yang Anda terima dihasilkan dari sistem Markdown. JPIT akan **MENOLAK KARYA ANDA** jika terdapat sisa simbol ini:

1. **Pemusnahan Backtick ( `` ` `` ):**
   * Di dalam bab Metode dan Hasil, saya menggunakan tanda *backtick* (kutip miring tunggal) untuk menandai kueri database (contoh: `` `SELECT` `` atau `` `telemetry_logs` ``). 
   * **Tindakan:** **Hapus semua tanda backtick tersebut!** 
   * **Pengganti:** Setelah backtick dihapus, cetak miring (*Italic*) kata tersebut. Contoh hasil akhir: *SELECT* atau *telemetry_logs*.
   * *Catatan:* Di blok kode SQL panjang, backtick di awal (`CREATE...) dan di akhir (;) juga wajib dihapus.
2. **Pemusnahan Tanda Bintang (`*`):** 
   * Jika ada kata seperti `*multi-tenant*`, hapus bintangnya lalu cetak miring kata tersebut menjadi *multi-tenant*.

---

## 🚀 BAGIAN 4: LANGKAH EKSEKUSI PERAKITAN ZOTERO

1. **ZOTERO:** Masukkan `irsyad_references.bib` ke aplikasi Zotero.
2. Di MS Word, buka tab Zotero -> **Document Preferences** -> Pilih Format: **IEEE**.
3. Gunakan panduan pemetaan Zotero di akhir *file* `irsyad_04_B` untuk mengubah angka manual `[1], [2]` menjadi sitasi sistem Zotero.
4. Di halaman terakhir, ketik **DAFTAR PUSTAKA** (Rata Tengah, tanpa Romawi).
5. Klik **Add/Edit Bibliography** di menu Zotero. Zotero akan menumpahkan ke-20 referensi Anda.
6. **LANGKAH FINAL:** Blok seluruh teks daftar pustaka Zotero tersebut, ubah paksa *font*-nya menjadi **Times New Roman 8 pt** (Spasi Tunggal).

Simpan, ekspor ke `.pdf`. Anda telah selamat dari jebakan *Desk Rejection* JPIT 2024! 🔥

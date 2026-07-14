# Research Scope & Boundary (Irsyad's Paper)

## 1. PROJECT KNOWLEDGE (Kilas Balik)
Jika jurnal Marsha berfokus pada apa yang terjadi **di dalam perangkat Android (Lokal/Edge)**, maka jurnal Anda (Irsyad) berfokus penuh pada apa yang terjadi **di luar perangkat (Cloud & Ekosistem Sosial)**. Ini adalah ranah *Backend-as-a-Service* (BaaS), keamanan siber (*Cybersecurity*), dan optimasi pertukaran data (*Big Data*).

## 2. RESEARCH KNOWLEDGE (Irsyad's JPIT Article)
Jurnal ini memisahkan fitur Telemetri dan *Family Squad* dari logika AI pendeteksi wajah.

### A. Research Object & Boundaries
* **Research Scope:** *Cloud Computing, Data Aggregation, and Mobile Security Architecture*.
* **Research Object:** Arsitektur Sinkronisasi Telemetri *Real-Time* dan Keamanan Basis Data pada Aplikasi Pemantauan Jarak Pandang.
* **System Boundary:** Interaksi antara aplikasi Flutter (Klien) dengan layanan basis data *Cloud* Supabase (PostgreSQL & WebSockets).
* **Included Modules:**
  1. `TelemetryService` (Algoritma *Smart Rollup* / Agregasi Data Lokal).
  2. Supabase *Row Level Security* (RLS) untuk keamanan akses data.
  3. Supabase *Realtime WebSockets* (Fitur *Nudge* / Teguran *Real-Time* lintas *device*).
  4. Manajemen Otentikasi dan Relasi Keluarga (Family Squad).
* **Excluded Modules:** MediaPipe Face Mesh, Kalkulasi Jarak Geometri, dan Intervensi Layar (Blur).

### B. Scientific Contribution
* **Research Novelty (Kebaruan):** Mengirim log data setiap detik ke *Cloud* untuk ribuan pengguna akan menghancurkan *server* (biaya membengkak & pemblokiran *Rate-Limit*). Kebaruan riset Anda adalah merancang algoritma **Smart Telemetry Rollup**, di mana aplikasi menahan 12 log aktivitas lokal, mengompresinya, dan mengirimkannya sebagai 1 baris (*row*) data setiap 15 menit ke *Cloud*. Hal ini dikombinasikan dengan pengamanan **RLS (Row Level Security)** mutlak di tingkat *database*, menjamin data medis/perilaku anak tidak bisa diretas atau bocor ke pengguna lain.
* **Research Contribution:** Menghasilkan model arsitektur BaaS yang efisien (*Cost-Effective*) dan aman untuk aplikasi *Mobile Health* (mHealth) berkinerja tinggi.

### C. Evaluation Framework
* **Fokus Pengujian (Sesuai Standar ISO/IEC 25010):**
  1. **Performance Efficiency (Efisiensi Kinerja):** Mengukur penurunan drastis jumlah panggilan API (API *Calls*) dan beban *Bandwidth* jaringan sebelum vs. sesudah algoritma *Smart Rollup* diterapkan.
  2. **Security (Keamanan):** Pengujian Penetrasi/Akses (Metode *Black-Box*) pada aturan RLS Supabase. (Membuktikan bahwa Token JWT Anak tidak bisa dipakai untuk menghapus data Grup Keluarga, atau melihat data orang lain).

---
*Ruang Lingkup Jurnal Irsyad telah divalidasi dan dikunci agar tidak bertabrakan (overlap) 1% pun dengan jurnal Marsha.*

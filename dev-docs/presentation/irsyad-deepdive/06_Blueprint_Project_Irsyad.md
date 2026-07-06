# Buku 6: Anatomi Proyek (Blueprint), Alur, dan Pattern Arsitektur
**Fokus Presentasi:** Menjawab Dosen Pembimbing Eksekusi Teknis & Struktur Proyek.

---

## 🛠️ 1. TECH STACK (Tumpukan Teknologi)
Proyek VisionSafe menggunakan kombinasi teknologi *lintas-platform* dan *Cloud-Native* modern:
*   **Frontend Mobile:** Flutter (Dart) untuk UI/UX berkinerja tinggi (60 FPS).
*   **State Management & Routing:** GetX (Micro-framework paling ringan dan *scalable* di Flutter).
*   **Native Bridge (AI & Sensor):** Kotlin murni untuk mengakses OS Android secara langsung (Kamera, Baterai, *System Overlay*).
*   **AI Engine:** Google MediaPipe (Face Mesh).
*   **Backend Serverless (BaaS):** Supabase (PostgreSQL, PostgREST API, WebSockets, GoTrue Auth).
*   **Automation QA:** Katalon Studio (berbasis Gherkin BDD).

---

## 🧭 2. ALUR PRODUK (How The Product Works)
Bagaimana alur aplikasi berjalan dari kacamata mesin?
1. **Fase Inisiasi (Boot):** Pengguna membuka aplikasi. Flutter memuat UI *Dashboard*. Di latar belakang, Flutter membuka jembatan komunikasi (`MethodChannel`) ke Kotlin untuk membangunkan layanan OS.
2. **Fase Pengamatan (AI Tracking):** Lensa kamera menyala tanpa memunculkan layar kamera (berjalan diam-diam). MediaPipe mengekstrak 478 titik wajah, menghitung *Triangle Similarity*, dan mengirim angka jarak (cm) kembali ke Flutter setiap 1 detik.
3. **Fase Penyaringan & Gamifikasi:** Angka jarak tersebut disaring (Low-Pass Filter) di dalam *Controller*. Jika aman, mesin *Timer* Gamifikasi menambah *Quest Progress*. Jika bahaya (< 30cm), *Timer Violation* menyala.
4. **Fase Eksekusi (Punishment):** Jika *Timer Violation* tembus 3 detik, Flutter mengirim sinyal "BLUR" ke Kotlin. Kotlin membajak OS Android dan menumpahkan layar buram (*System Alert Window*).
5. **Fase Penyelematan Data (Smart Rollup):** Setiap data aman/bahaya disimpan di memori *cache* HP (SQLite). Tiap 15 menit, data dibungkus (*Batch*) dan dilempar ke Supabase Cloud lewat REST API.

---

## 🏗️ 3. ALUR PEMBUATAN (Development Workflow)
Bagaimana tim kami membangun proyek ini dari nol?
1. **Fase Riset:** Uji kelayakan (Proof of Concept) MediaPipe Face Mesh. Apakah sanggup berjalan di HP spesifikasi rendah tanpa *lag*? (Berhasil divalidasi).
2. **Fase Database & Cloud:** Saya merancang skema relasional tabel di Supabase, menulis aturan *Row Level Security (RLS)*, dan mengaktifkan Google OAuth.
3. **Fase Native Kotlin:** Membangun jantung mesin. Menulis modul *Foreground Service*, pendeteksi wajah, dan mem- *bypass* izin *Draw Over Other Apps*.
4. **Fase Flutter UI & Logic:** Menggabungkan mesin Kotlin dengan desain antarmuka (UI) Flutter, memasang grafik *Fl_Chart*, dan mengintegrasikan animasi Lottie Vizo.
5. **Fase QA & Rilis:** Marsha menguji sistem memakai Katalon (Data-Driven), lalu mengekspor *source code* menjadi format AAB (Android App Bundle) untuk dilempar ke Google Play Console.

---

## 🧩 4. ALUR ARSITEKTUR PATTERN (GetX / MVC)
Kami membuang pola arsitektur bawaan Flutter yang berantakan (*Spaghetti Code*) dan menggunakan standar Enterprise: **Pola GetX (View - Controller - Binding - Service)**.

*   **View (Tampilan):** Murni hanya berisi kode desain antarmuka (Tombol, Warna, Grafik). Sama sekali TIDAK BOLEH ADA proses hitung-hitungan atau *database* di sini.
*   **Controller (Otak Pemikir):** Tempat di mana logika berjalan. Contoh: Menerima data klik dari tombol, memanggil API, atau menyuruh mesin berhitung. 
*   **Binding (Injektor):** Sistem pengait (Dependency Injection). Menjamin bahwa *Controller* hanya akan memakan RAM (Memori) di HP ketika *View*-nya sedang dibuka. (Inilah alasan aplikasi ini sangat ringan).
*   **Service / Provider:** Agen khusus yang hanya bertugas berkomunikasi ke dunia luar (Internet/Cloud/Sensor).

---

## 📂 5. BEDAH PATTERN PER FILE (Contoh Modul Dashboard)
Jika dosen bertanya, *"Coba tunjukkan isi foldermu, bagaimana kamu menyusun 1 fitur?"*
Setiap folder fitur (misal: fitur Dasbor) dibungkus secara independen (*Split-per-Concern*).

Struktur Folder `app/modules/home/`:
1.  **`home_view.dart` (Wajah)**
    Berisi *widget* visual (Scaffold, AppBar, Text). File ini bodoh; ia hanya tahu cara menampilkan data, tidak tahu dari mana data itu berasal. Data diambil menggunakan perantara `Obx(() => controller.jarakMata)`.
2.  **`home_controller.dart` (Otak)**
    Berisi *variable state* cerdas (`var jarakMata = 0.obs;`). Jika nilai angka jarakMata berubah (karena *update* dari sensor), maka ia akan memberi tahu `home_view` untuk me- *refresh* layarnya secara otomatis (Reactive Programming).
3.  **`home_binding.dart` (Pengait Memori)**
    Hanya berisi perintah `Get.lazyPut<HomeController>(() => HomeController());`. Memastikan kelas Controller dibuang otomatis (*Disposed*) dari RAM saat pengguna berpindah ke halaman lain.

**Kelebihan Pattern Ini:** Skalabilitas tinggi. Jika kami ingin mengganti tampilan aplikasi, kami hanya menyentuh `_view.dart` tanpa takut merusak logika bisnis di `_controller.dart`. Jika terjadi *bug* (error) perhitungan jarak, kami langsung membedah `_controller.dart` tanpa perlu pusing mencari di mana letak desain tombol di kodenya.

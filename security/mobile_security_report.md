# AUDIT KEAMANAN MOBILE & LAPORAN UJI PENETRASI (PENTEST) - VISIONSAFE
## ANALISIS ANCAMAN OWASP MOBILE TOP 10, DEFENSI KRIPTOGRAFI, DAN ISOLASI DATA CLOUD
--------------------------------------------------------------------------------
**Mata Kuliah:** Keamanan Data dan Jaringan
**Dokumen:** Security Architecture & Pentest Audit Report
**Status:** CONFIDENTIAL - VERIFIED SECURE

---

## 1. STRATEGI & PEMILIHAN TEKNIK KEAMANAN (CRITERIA 1)
Keamanan data pada VisionSafe dirancang secara menyeluruh (*Defense-in-Depth*) yang mencakup tiga domain utama: perangkat lokal (*Device-side*), saluran komunikasi (*Transport-side*), dan server awan (*Cloud-side*).

### 1.1 Teknik Keamanan yang Dipilih:
1. **Lokal (Enkripsi Data At-Rest):** Menggunakan basis data lokal Hive yang diamankan dengan algoritma enkripsi **AES-256 (Advanced Encryption Standard)** dalam mode **CBC (Cipher Block Chaining)** dengan padding PKCS7. Kunci enkripsi diamankan di dalam Keychain/Keystore sistem operasi menggunakan pustaka `flutter_secure_storage`.
2. **Jaringan (Keamanan Jaringan At-Transit):** Seluruh komunikasi API diwajibkan menggunakan protokol **HTTPS (TLS v1.3)** dengan pengenalan cipher suite yang kuat untuk mencegah serangan penyadapan data.
3. **Autentikasi & Otorisasi (Cloud-Side Isolation):** Autentikasi berbasis token standar industri yaitu **JWT (JSON Web Token)** yang dikeluarkan oleh Supabase Auth. Untuk otorisasi di database PostgreSQL cloud, kami menerapkan **Row Level Security (RLS)** yang ketat secara deklaratif.

---

## 2. PENERAPAN TEKNIK KEAMANAN PADA APLIKASI (CRITERIA 2)

### 2.1 Implementasi Enkripsi Database Lokal (Hive AES-256)
Setiap kali data telemetri, XP, atau level disimpan secara lokal di Hive, data tersebut disandikan menggunakan kunci kriptografi 256-bit. 

```dart
// Snippet Konseptual Enkripsi Hive Box
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> initSecureBox() async {
  const secureStorage = FlutterSecureStorage();
  // 1. Ambil atau buat encryption key yang aman dari secure storage hardware (Android Keystore / iOS Keychain)
  var containsEncryptionKey = await secureStorage.containsKey(key: 'secureKey');
  if (!containsEncryptionKey) {
    var key = Hive.generateSecureKey();
    await secureStorage.write(key: 'secureKey', value: base64UrlEncode(key));
  }
  
  var keyString = await secureStorage.read(key: 'secureKey');
  var encryptionKey = base64Url.decode(keyString!);
  
  // 2. Buka Box Hive dengan Cipher Enkripsi AES-256
  await Hive.openBox('exercise_stats', encryptionCipher: HiveAesCipher(encryptionKey));
}
```

### 2.2 Kebijakan Row Level Security (RLS) PostgreSQL pada Supabase Cloud
Untuk mencegah kebocoran data antar pengguna (*IDOR - Insecure Direct Object Reference*), PostgreSQL dikonfigurasi agar menolak kueri silang pengguna.

```sql
-- Kebijakan RLS untuk Tabel Telemetri
ALTER TABLE public.telemetry ENABLE ROW LEVEL SECURITY;

-- Kebijakan READ: Pengguna hanya bisa melihat data miliknya sendiri berdasarkan JWT claim
CREATE POLICY "Users can only select their own telemetry data" ON public.telemetry
    FOR SELECT 
    USING (auth.uid() = user_id);

-- Kebijakan INSERT: Pengguna hanya bisa menginput data miliknya sendiri
CREATE POLICY "Users can only insert their own telemetry records" ON public.telemetry
    FOR INSERT 
    WITH CHECK (auth.uid() = user_id);
```

---

## 3. LAPORAN UJI PENETRASI / PENTEST (CRITERIA 3)
Uji penetrasi dilakukan menggunakan pendekatan kotak hitam (*Black-Box Testing*) dan kotak abu-abu (*Grey-Box Testing*) mengacu pada metodologi **OWASP Mobile Application Security Verification Standard (MASVS)**.

### 3.1 Ringkasan Temuan OWASP Mobile Top 10:

| Kategori Ancaman | Kerentanan yang Diuji | Hasil Pengujian & Status Keamanan | Mitigation / Remediasi |
| :--- | :--- | :--- | :--- |
| **M1: Improper Platform Usage** | Penyalahgunaan izin kamera belakang atau file lokal. | **SECURE (Lolos)**<br>Aplikasi hanya meminta izin kamera depan secara eksplisit di runtime ketika fitur Eye Guardian dinyalakan. | Pembatasan hak akses di file `AndroidManifest.xml` seminimal mungkin. |
| **M2: Insecure Data Storage** | Ekstraksi file basis data lokal `.hive` atau cache dari sandbox directory Android. | **SECURE (Lolos)**<br>Meskipun penyerang melakukan rooting ponsel dan menarik berkas `.hive`, file tidak dapat dibaca karena terenkripsi AES-256. | Kunci dekripsi disimpan terpisah di perangkat keras aman (Android Keystore). |
| **M3: Insecure Communication** | Serangan Man-in-the-Middle (MitM) untuk menyadap dan memanipulasi log telemetri di jaringan Wi-Fi publik. | **SECURE (Lolos)**<br>HTTPS dienkripsi dengan TLS v1.3. Upaya menggunakan sertifikat bodong (Self-Signed) ditolak otomatis oleh sistem networking Flutter. | Seluruh komunikasi mutlak melewati HTTPS SSL. |
| **M4: Insecure Authentication** | Upaya bypass otentikasi login atau brute-force token JWT di server. | **SECURE (Lolos)**<br>Sesi token valid di-refresh otomatis, token kadaluwarsa dalam 1 jam secara default, mencegah pembajakan token jangka panjang. | Implementasi Google OAuth 2.0 yang aman untuk mengalihkan otentikasi kredensial langsung ke server Google. |
| **M8: Code Tampering / Reverse Engineering** | Dekompilasi file APK menjadi kode Java asli menggunakan peralatan seperti `apktool` atau `JADX-GUI`. | **SECURE (Lolos)**<br>Kode sumber Flutter dikompilasi langsung ke kode mesin native (*AOT - Ahead Of Time Compilation*). String rahasia disamarkan. | Penerapan R8/ProGuard Obfuscation pada rilis APK Android untuk mengacak nama kelas dan fungsi penting. |

---

## 4. KESIMPULAN AUDIT
Melalui penerapan enkripsi perangkat lokal berkekuatan tinggi (AES-256), perlindungan jalur komunikasi TLS v1.3, dan kebijakan kontrol akses deklaratif (PostgreSQL Row Level Security), aplikasi VisionSafe memiliki postur keamanan yang sangat kuat untuk menangani data kesehatan sensitif pengguna, melampaui standar dasar pengembangan aplikasi mobile pada umumnya.

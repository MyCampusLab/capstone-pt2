# Contoh Refactoring Real-World

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** WAJIB — Bagian dari coding standards. Lihat [CODING_STANDARDS.md](../CODING_STANDARDS.md) untuk index lengkap.

### Kasus: HrisEmployeeController (3580 baris, 43 functions)

**Struktur yang BENAR:**

```
app/
├── Http/
│   ├── Controllers/
│   │   ├── HRIS/
│   │   │   ├── Employee/
│   │   │   │   ├── EmployeeController.php (Resource Controller - 150 baris)
│   │   │   │   ├── EmployeeDailyController.php (100 baris)
│   │   │   │   ├── EmployeeExitController.php (100 baris)
│   │   │   │   └── EmployeeAttachmentController.php (150 baris)
│   ├── Requests/
│   │   ├── HRIS/
│   │   │   ├── StoreEmployeeRequest.php
│   │   │   ├── UpdateEmployeeRequest.php
│   │   │   └── RenewEmployeeRequest.php
├── Services/
│   ├── HRIS/
│   │   ├── EmployeeService.php (300 baris)
│   │   ├── EmployeeDocumentService.php (200 baris)
│   │   ├── EmployeeNotificationService.php (150 baris)
│   │   └── EmployeeExportService.php (200 baris)
├── Repositories/
│   ├── HRIS/
│   │   └── EmployeeRepository.php (250 baris)
```

**Hasil:**
- 1 file 3580 baris → 10+ files dengan masing-masing < 300 baris
- Setiap file punya 1 tanggung jawab
- Mudah di-test
- Mudah di-maintain
- Mengikuti Laravel conventions

---

Kembali ke [Index](../CODING_STANDARDS.md)

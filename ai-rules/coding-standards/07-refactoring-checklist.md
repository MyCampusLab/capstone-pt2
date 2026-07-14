# Refactoring Checklist

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** WAJIB — Bagian dari coding standards. Lihat [CODING_STANDARDS.md](../CODING_STANDARDS.md) untuk index lengkap.

Sebelum commit, AI WAJIB memeriksa:

- [ ] **File size**: Tidak ada file yang melebihi batas maksimal
- [ ] **Function size**: Tidak ada function yang > 50 baris
- [ ] **Class responsibilities**: Setiap class hanya punya 1 tanggung jawab
- [ ] **Dependencies**: Inject dependencies, jangan instantiate langsung
- [ ] **Validation**: Gunakan Form Request (Laravel) atau validation middleware
- [ ] **Business logic**: Tidak ada business logic di Controller
- [ ] **Database queries**: Tidak ada raw queries di Controller
- [ ] **Error handling**: Proper error handling dengan specific exceptions
- [ ] **Code duplication**: Extract duplicated code ke helper/service
- [ ] **Comments**: Jelaskan WHY, bukan WHAT

---

Kembali ke [Index](../CODING_STANDARDS.md)

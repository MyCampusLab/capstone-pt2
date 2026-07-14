# Code Review Questions

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** WAJIB — Bagian dari coding standards. Lihat [CODING_STANDARDS.md](../CODING_STANDARDS.md) untuk index lengkap.

Sebelum menyelesaikan task, AI WAJIB bertanya pada diri sendiri:

1. **Apakah file ini terlalu besar?** (> 1000 baris untuk controller)
2. **Apakah function ini terlalu panjang?** (> 50 baris)
3. **Apakah class ini punya terlalu banyak tanggung jawab?**
4. **Apakah ada code yang bisa di-extract ke Service/Repository?**
5. **Apakah validation sudah dipisahkan ke Form Request?**
6. **Apakah ada business logic di Controller?**
7. **Apakah ada database queries langsung di Controller?**
8. **Apakah code ini mudah di-test?**
9. **Apakah code ini mudah dipahami developer lain?**
10. **Apakah code ini mengikuti framework conventions?**

Jika jawaban "TIDAK" untuk pertanyaan 1-4 atau "YA" untuk pertanyaan 5-8, **WAJIB refactor sebelum commit**.

---

Kembali ke [Index](../CODING_STANDARDS.md)

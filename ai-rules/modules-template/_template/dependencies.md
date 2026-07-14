# Dependencies — {Nama Modul}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** DATA FILE — Update saat dependency ke modul lain atau service eksternal berubah.

---

## Internal Module Dependencies

| Depends On | What's Used | Notes |
|-----------|------------|-------|
| `{ModulLain}` | `{model/service/helper yang dipakai}` | `{catatan}` |

---

## Modules That Depend On This

| Module | What They Use |
|--------|-------------|
| `{ModulLain}` | `{model/service/helper yang mereka pakai}` |

---

## External Service Dependencies

| Service | Package/API | Purpose | Fallback |
|---------|-----------|---------|----------|
| `{NamaService}` | `{composer/npm package}` | `{tujuan}` | `{graceful fallback behavior}` |

---

## Shared Infrastructure

| Component | Location | Used By |
|-----------|----------|---------|
| `{Middleware}` | `{path}` | `{daftar modul}` |
| `{Helper}` | `{path}` | `{daftar modul}` |
| `{BaseClass}` | `{path}` | `{daftar modul}` |

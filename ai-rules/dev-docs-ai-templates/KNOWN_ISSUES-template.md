# KNOWN_ISSUES

> **Status:** DATA FILE — AI WAJIB mengupdate saat ada issue baru atau issue terselesaikan.
> **Purpose:** Catatan issue yang diketahui. Mencegah agent berikutnya mengulang debug yang sama.

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

**What to CREATE in output folder:** Tracking board untuk semua issue teknis. Bukan pengganti Jira/GitHub Issues — catatan internal untuk konteks development.

###  CRITICAL: Anti-Monster Rule

**DILARANG** menumpuk semua issue di satu file. Hanya issue **OPEN** yang dicatat di sini. Issue yang sudah **Resolved >2 minggu** → pindahkan ke arsip. Detail issue yang kompleks → file terpisah.

| File | Isi |
|------|-----|
| `KNOWN_ISSUES.md` | Hanya issue OPEN (Investigating, Known Workaround, Waiting Fix) |
| `RESOLVED.md` | Issue yang sudah resolved — referensi historis |
| `issues/{YYYY-MM-DD}-{slug}.md` | Detail issue kompleks (jika butuh >1 paragraf) |

**When to update:**
- Saat menemukan issue baru
- Saat issue terselesaikan → pindahkan ke `RESOLVED.md` setelah 2 minggu stabil
- Saat ada uncertainty yang perlu ditandai

---

## Open Issues

| # | Area | Issue | Impact | Status |
|---|------|-------|--------|--------|
| 1 | `{modul/komponen}` | `{deskripsi}` | `{LOW/MED/HIGH/CRIT}` | `{Investigating / Known Workaround / Waiting Fix}` |

---

## Uncertainty Markers

**Hal-hal yang belum jelas dan perlu investigasi lebih lanjut:**

- Assumption based on repository analysis: `{asumsi — contoh: "belum ada CI pipeline terpusat."}`
- `{ketidakpastian_lain}`

---

## Resolved Issues

Lihat [RESOLVED.md](./RESOLVED.md) untuk daftar issue yang sudah di-resolve.

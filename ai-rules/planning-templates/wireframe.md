# Wireframe / UI Plan — {Nama Produk}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** PLANNING — Dibuat sebelum development. Jangan diubah tanpa diskusi.
> **Purpose:** Rencana UI/UX: layout halaman, struktur navigasi, flow pengguna.

---

## 1. Visual Identity

| Item | Detail |
|------|--------|
| Font | `{font family}` |
| Primary Color | `{hex code}` |
| Secondary Color | `{hex code}` |
| Logo | `{path atau deskripsi}` |
| Favicon | `{path atau deskripsi}` |

---

## 2. Navigation Structure

```text
{deskripsi struktur navigasi}

├── Dashboard
├── {Modul A}
│   ├── List {Modul A}
│   ├── Create {Modul A}
│   └── Detail {Modul A}
├── {Modul B}
│   ├── List {Modul B}
│   └── Reports
└── Settings
    ├── Profile
    └── Users
```

---

## 3. Page Layouts

### Admin Layout
```
┌─────────────────────────────────────┐
│  [Logo]           [User Menu]       │ ← Top Navbar
├─────────┬───────────────────────────┤
│         │                           │
│  Side   │     Content Area          │
│  Menu   │                           │
│         │                           │
│         │                           │
└─────────┴───────────────────────────┘
```

### Public Layout
```
┌─────────────────────────────────────┐
│  [Logo]    [Menu Items]    [CTA]    │ ← Navbar
├─────────────────────────────────────┤
│                                     │
│          Content Area               │
│                                     │
├─────────────────────────────────────┤
│  [Links]  [Social]  [Copyright]     │ ← Footer
└─────────────────────────────────────┘
```

---

## 4. Key Page Designs

### Page: {Nama Halaman}

**URL:** `/{prefix}` atau `/{prefix}/{id}`

**Komponen:**
- `{komponen_1}` — `{fungsi}`
- `{komponen_2}` — `{fungsi}`

**Interaksi:**
- `{interaksi_1}` — contoh: "Klik tombol Create → muncul modal form"
- `{interaksi_2}` — contoh: "Klik row table → navigasi ke detail"

**State yang perlu ditangani:**
- Loading: skeleton / spinner
- Empty: pesan "Belum ada data" + CTA
- Error: alert dengan pesan error
- Success: toast/flash message

---

## 5. Common Components

| Komponen | Deskripsi | Tempat Dipakai |
|----------|----------|---------------|
| `{DataTable}` | Tabel dengan server-side processing | Semua list page |
| `{ModalForm}` | Form dalam modal untuk create/edit | Form yang simple |
| `{DeleteConfirm}` | Konfirmasi sebelum hapus (SweetAlert) | Semua delete action |
| `{SearchBar}` | Input pencarian dengan debounce | Semua list page |
| `{FileUpload}` | Upload file dengan drag-drop | Form yang butuh file |

---

## 6. Responsive Breakpoints

| Breakpoint | Width | Target |
|-----------|-------|--------|
| Mobile | `< 768px` | Smartphone |
| Tablet | `768px - 1024px` | iPad |
| Desktop | `> 1024px` | Laptop/Monitor |

**Responsive strategy:**
- `{stack vertical / hide sidebar / collapse menu}`

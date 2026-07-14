# Timeline & Milestones — {Nama Produk}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** PLANNING — Dibuat sebelum development. Jangan diubah tanpa diskusi.
> **Purpose:** Rencana timeline, milestone, dan target rilis.

---

##  Project Type Declaration

| Item | Value |
|------|-------|
| Project Type | `{Monolith / Fullstack}` |

**Fullstack:** tambahkan kolom **Repo** di setiap task. Backend dan frontend bisa dikerjakan paralel — pisahkan task per repo.

---

## 1. Milestone Overview

| Milestone | Target Date | Status | Deliverables |
|-----------|------------|--------|-------------|
| `{M1}` | `{YYYY-MM-DD}` | `{Planned / In Progress / Done}` | `{output}` |
| `{M2}` | `{YYYY-MM-DD}` | `{Planned}` | `{output}` |
| `{M3}` | `{YYYY-MM-DD}` | `{Planned}` | `{output}` |

---

## 2. Phase Breakdown

### Phase 1: Foundation

| Task | Repo | Dependencies |
|------|------|-------------|
| Setup project & repo | `{both}` | — |
| Auth system (login, role, permission) | `{backend}` | Core |
| Auth pages (login, register) | `{frontend}` | Backend auth API |
| API contract finalization | `{both}` | — |
| Layout & navigation | `{frontend}` | Auth pages |
| Database migrations | `{backend}` | Core |

### Phase 2: Core Features

| Task | Repo | Dependencies |
|------|------|-------------|
| `{task}` | `{backend/frontend}` | `{dependency}` |

### Phase 3: Polish & Launch

| Task | Repo | Dependencies |
|------|------|-------------|
| UAT & bug fixing | `{both}` | All modules |
| Production deployment — backend | `{backend}` | UAT passed |
| Production deployment — frontend | `{frontend}` | Backend live |
| User training / handover | — | Deployment |

---

## 3. Release Plan

| Version | Date | Repo | Scope |
|---------|------|------|-------|
| `v0.1.0` (Alpha) | `{YYYY-MM-DD}` | `{backend}` | Core API ready for frontend dev |
| `v0.1.0` (Alpha) | `{YYYY-MM-DD}` | `{frontend}` | Skeleton pages, consume mock API |
| `v0.5.0` (Beta) | `{YYYY-MM-DD}` | `{both}` | User acceptance testing |
| `v1.0.0` (Production) | `{YYYY-MM-DD}` | `{both}` | Go live |

---

## 4. Risk Register

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|-----------|
| `{risiko}` | `{High/Med/Low}` | `{High/Med/Low}` | `{mitigasi}` |
| API contract mismatch | `{Med}` | `{High}` | Contract freeze before FE starts |
| Backend delay blocks frontend | `{Med}` | `{Med}` | Frontend uses mock API during early phase |

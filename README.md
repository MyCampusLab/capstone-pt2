# 👁️ VISIONSAFE (CAPSTONE-PT2)

## 🛡️ THE ARCHITECT-ELITE COLLABORATION
**High-Integrity Vision Intelligence Ecosystem**

AI-Powered Vision Intelligence: Advanced Image Processing & Secure Data Analytics. Mitigating Myopia with Real-time AI. Sebuah sistem mitigasi risiko mata minus berbasis Computer Vision yang berjalan di latar belakang (Background Service) untuk menjaga kesehatan mata pengguna.

---

## 🚀 PROJECT OVERVIEW
VISIONSAFE (Capstone Part 2) represents the evolution of eye-health technology. Utilizing **MediaPipe Face Mesh**, the system calculates the exact Z-coordinate of the user's eyes relative to the screen. 

When a critical distance threshold (<30cm) is breached, the **Surgical Overlay Control** triggers an intelligent Gaussian Blur intervention, ensuring the user maintains optimal ergonomic standards.

---

## 👥 THE CORE ENGINEERING TEAM
This project is a high-stakes collaboration between top-tier engineers:

| Name | Role | Profile |
| :--- | :--- | :--- |
| **M. Irsyad Fachryanto** | Lead System Architect | [@mirsydfchrynto](https://github.com/mirsydfchrynto) |
| **Marsha Dwi Lucyana** | Lead Frontend & UX Engineer | [@marshadwi](https://github.com/marshadwi) |
| **Antigravity AI** | Advanced Agentic Co-Pilot | [Google DeepMind](#) |

**Group Identity:** [Architect-Elite / Nexus-E]

---

## ✨ KEY FEATURES
- **Real-time Edge AI Detection:** Precise eye-to-screen distance measurement with sub-10ms latency.
- **Intelligent Visual Intervention:** Transparent Gaussian Blur overlay for forced ergonomic compliance.
- **Robust Background Engine:** Seamless background service operation even during high-load gaming sessions.
- **Analytics Dashboard:** Real-time health statistics and exposure monitoring via Supabase.

---

## 🛠️ TECHNICAL STACK
- **Core Engine:** Flutter (Dart) with High-Performance Android Interop.
- **AI/ML:** Google MediaPipe Face Mesh (Edge-Optimized).
- **Persistence:** Supabase (PostgreSQL) for secure user analytics.
- **System Control:** Android Foreground Service & Advanced Overlay Window permissions.

---

## 🚦 GETTING STARTED
1. Clone this repository.
2. Execute `flutter pub get`.
3. Grant "Appear on Top" (Overlay) and Camera permissions on the target Android device.
4. Initialize "Start Protection" to engage the eye-health assistant.

---

## 🌐 Live API Documentation & Testing
Untuk mempermudah integrasi dan pengujian oleh dosen penguji atau pengembang lain, dokumentasi API VisionSafe telah dipublikasikan secara interaktif dan siap pakai:
- **Interactive Swagger UI (FastAPI-style Playground):** [visionsafe-api.surge.sh](https://visionsafe-api.surge.sh)
- **Postman Collection:** File spesifikasi Postman dapat diunduh dari direktori [api_documentation/visionsafe_postman_col.json](./api_documentation/visionsafe_postman_col.json) untuk langsung diimpor ke Postman.
- **Automated API Tester:** Skrip pengujian otomatis berbasis Python dapat diakses di [scratch/test_api_supabase.py](./scratch/test_api_supabase.py) untuk memverifikasi integritas endpoint live secara real-time.

---

## 📄 LICENSE
This project is licensed under the **MIT License** - see the LICENSE file for details.

---

**© 2026 Architect-Elite. All Rights Reserved.**

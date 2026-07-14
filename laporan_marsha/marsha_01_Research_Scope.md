# Research Scope & Boundary (Marsha's Paper)

## 1. PROJECT KNOWLEDGE (Complete System)
VisionSafe is an ecosystem containing AI distance tracking, Gamification, Cloud Sync, and Family Squad monitoring.

## 2. RESEARCH KNOWLEDGE (Marsha's JPIT Article)
This paper isolates the **Core Artificial Intelligence and Intervention Subsystem**. It will not discuss the Supabase backend, Gamification, or the Squad sharing features.

### A. Research Object & Boundaries
* **Research Scope:** Applied Artificial Intelligence & Computer Vision in Mobile Devices.
* **Research Object:** Real-time Eye-to-Screen Distance Estimation and Visual Intervention.
* **System Boundary:** The local Android hardware, the camera sensor, the MediaPipe model, and the local screen overlay (Blur).
* **Included Modules:**
  1. Kotlin Foreground Service (`VisionAnalyzer.kt`).
  2. MediaPipe Face Landmarker (ID: 33 and 263).
  3. Distance Math Engine (Triangle Similarity with Z-axis compensation).
  4. Decision Support System (`BlurOverlayManager` & Emergency Lock).
  5. Thermal Throttling System (`BatteryManager.EXTRA_TEMPERATURE`).
* **Excluded Modules:** Authentication, Cloud Telemetry, Family Squad, Gamification, Automated Testing.

### B. Scientific Contribution
* **Research Novelty:** Running continuous 3D Face Landmark AI in the background of a mobile OS usually results in thermal shutdown (Overheating) or process termination by the OS (Doze mode). The novelty of this research is the implementation of a **Dynamic Thermal Throttling algorithm** (scaling from 1 FPS to 1 Frame/10s at 42°C) combined with a Kotlin Native Service to ensure 24/7 vision protection without sacrificing device integrity.
* **Research Contribution:** Providing an empirical model for applying heavy AI (MediaPipe) persistently on consumer mobile hardware for digital health interventions.

### C. Evaluation Framework
* **Variables:** 
  - Independent: Actual physical distance of the face to the screen.
  - Dependent: AI calculated distance, CPU/Thermal state.
* **Evidence Required:** 
  - `PENJELASAN_TEKNIS_VISIONSAFE.txt` (Mathematical formulas).
  - Screenshots of the Blur Intervention working.
  - Snippets of Kotlin code (`DeviceStateManager.kt` for thermal throttling).

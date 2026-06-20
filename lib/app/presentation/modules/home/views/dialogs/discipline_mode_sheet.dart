import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_button.dart';

class DisciplineModeSheet extends StatefulWidget {
  final VoidCallback onProceed;
  final VoidCallback onCancel;

  const DisciplineModeSheet({super.key, required this.onProceed, required this.onCancel});

  static void show({required VoidCallback onProceed, required VoidCallback onCancel}) {
    Get.bottomSheet(
      DisciplineModeSheet(onProceed: onProceed, onCancel: onCancel),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  State<DisciplineModeSheet> createState() => _DisciplineModeSheetState();
}

class _DisciplineModeSheetState extends State<DisciplineModeSheet> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(top: BorderSide(color: AppColors.primaryDark, width: 4)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 6, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
          const SizedBox(height: 24),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (idx) => setState(() => _currentPage = idx),
              children: [
                _buildIntroPage(),
                _buildTutorialPage(),
              ],
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildIntroPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Text("MODE DISIPLIN", style: AppTextStyles.heading1.copyWith(color: AppColors.primaryDark)),
          const SizedBox(height: 12),
          Text(
            "Perlindungan Mata Level Maksimal!",
            style: AppTextStyles.bodyBold.copyWith(color: AppColors.primary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildFeatureBox(
            icon: Icons.security_rounded,
            title: "Pengunci Layar Otomatis",
            desc: "Layar akan diblokir paksa jika wajah anak terlalu dekat. Mereka harus menjauh untuk bisa lanjut main HP.",
            color: Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildFeatureBox(
            icon: Icons.privacy_tip_rounded,
            title: "Privasi 100% Terjamin",
            desc: "Hanya menggunakan izin Overlay untuk menutup layar. Kami TIDAK merekam aktivitas layar, kamera, maupun ketikan.",
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Text("CARA AKTIVASI", style: AppTextStyles.heading1.copyWith(color: AppColors.primaryDark)),
          const SizedBox(height: 12),
          Text(
            "Ikuti langkah ini di pengaturan",
            style: AppTextStyles.bodyBold.copyWith(color: AppColors.primary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildStepRow("1", "Pilih menu 'Aplikasi yang Diunduh' atau 'Layanan Terinstal'."),
          _buildStepRow("2", "Cari dan pilih 'VisionSafe' dari daftar aplikasi."),
          _buildStepRow("3", "Nyalakan saklar (Toggle) untuk memberi izin akses."),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1), 
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lock_person_rounded, color: Colors.orange),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("PENGGUNA ANDROID 13+", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                      SizedBox(height: 4),
                      Text("Jika saklar terkunci (abu-abu), buka Info Aplikasi VisionSafe > Klik Titik Tiga Kanan Atas > Pilih 'Izinkan Pengaturan Terbatas'.", style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Abaikan peringatan bawaan Android. Sistem kami dijamin aman dan tidak melacak privasi Anda.",
                    style: TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.bold, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureBox({required IconData icon, required String title, required String desc, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyBold.copyWith(color: AppColors.primaryDark)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(fontSize: 13, height: 1.4, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepRow(String step, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              shape: BoxShape.circle,
              boxShadow: const [BoxShadow(color: AppColors.primaryDark, offset: Offset(2, 2))],
            ),
            alignment: Alignment.center,
            child: Text(step, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Colors.black12)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                Get.back();
                widget.onCancel();
              },
              child: const Text("Tolak", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: VButton(
              label: _currentPage == 0 ? "LANJUTKAN" : "BUKA PENGATURAN",
              onPressed: () {
                if (_currentPage == 0) {
                  _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                } else {
                  Get.back();
                  widget.onProceed();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:visionsafe/app/presentation/global_widgets/organisms/live_vizo_radar.dart';
import 'package:visionsafe/app/presentation/global_widgets/organisms/quick_stats_grid.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/eye_care_news_card.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_app_header.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_dialog.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import 'package:visionsafe/app/data/services/news_service.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/templates/base_screen_template.dart';
import 'package:visionsafe/app/routes/app_pages.dart';
import 'package:visionsafe/app/presentation/global_widgets/animations/fade_in_up.dart';

import 'widgets/compact_action_button.dart';

/// HomeView: The Hero Experience (Highly Refined, Simple, and World-Class UX).
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final newsService = Get.find<NewsService>();

    return BaseScreenTemplate(
      appBar: VAppHeader(
        title: "VISIONSAFE",
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.primaryDark),
            onPressed: () => _showNotificationTips(),
          ),
        ],
      ),
      bottomPadding: 160,
      topPadding: 0,
      stackLayers: [
        // Proximity Warning is built-in inside template or as overlay
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 0),
          
          // 1. Interactive Radar Assistant (Vizo Live Face Tracking Mascot)
          const FadeInUp(
            delay: Duration(milliseconds: 200),
            child: Center(child: RepaintBoundary(child: LiveVizoRadar())),
          ),
          
          const SizedBox(height: 54),

          // 2. Premium Circular Level & Online Status Panel
          FadeInUp(
            delay: const Duration(milliseconds: 250),
            child: _buildMascotStatusPanel(),
          ),
          
          const SizedBox(height: 24),
          
          // 3. Unified Power-Toggle Control Button (Full Width, Tactile, High Contrast)
          const FadeInUp(
            delay: Duration(milliseconds: 300),
            child: CompactActionButton(),
          ),
          
          const SizedBox(height: 32),
          
          // 4. Daily Health Summary
          _buildSectionTitle("RINGKASAN HARI INI"),
          const SizedBox(height: 8),
          const QuickStatsGrid(),
          
          const SizedBox(height: 24),
          
          // 5. Educational News Feed
          _buildNewsHeader(),
          const SizedBox(height: 8),
          _buildNewsList(newsService),
        ],
      ),
    );
  }

  Widget _buildMascotStatusPanel() {
    return Obx(() {
      final profile = controller.userProfile.value;
      final level = profile?.level ?? 1;
      final xp = profile?.xp ?? 0;

      final currentLevelBaseXp = (level - 1) * 100;
      final nextLevelXp = level * 100;
      final progress = (xp - currentLevelBaseXp) / (nextLevelXp - currentLevelBaseXp);
      final clampedProgress = progress.clamp(0.0, 1.0);



      return GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          _showLevelDetails(level, xp.toInt(), nextLevelXp);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primaryDark, width: 3),
            boxShadow: const [
              BoxShadow(
                color: AppColors.primaryDark,
                offset: Offset(4, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              // Left Side: Circular Progress surrounding Level
              _buildCircularLevelProgress(level, clampedProgress),
              
              const SizedBox(width: 16),
              
              // Right Side: Bold Role Title, XP, and Clean Connection Status Pill
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Pahlawan Penjaga Mata",
                      style: AppTextStyles.bodyBold.copyWith(
                        color: AppColors.primaryDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "$xp / $nextLevelXp XP",
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primaryDark.withAlpha(160),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildStatusPill(),
                          if (controller.telemetryService.isPowerSaveActive.value) ...[
                          const SizedBox(width: 8),
                          _buildPowerSaveBadge(),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCircularLevelProgress(int level, double clampedProgress) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: clampedProgress),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.elasticOut,
      builder: (context, animValue, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Background empty track circle
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withAlpha(20),
                border: Border.all(color: AppColors.primaryDark.withAlpha(40), width: 1.5),
              ),
            ),
            // Animated Progress Track Circle (Purple Violet)
            SizedBox(
              width: 64,
              height: 64,
              child: CircularProgressIndicator(
                value: animValue,
                strokeWidth: 5.5,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
              ),
            ),
            // Center text (LVL and Level count)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "LVL",
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryDark.withAlpha(140),
                    height: 1.0,
                  ),
                ),
                Text(
                  "$level",
                  style: AppTextStyles.bodyBold.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryDark,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusPill() {
    final statusText = controller.connectionStatusText;
    final statusColor = controller.connectionStatusColor;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pulse-glowing dot
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statusColor,
              boxShadow: [
                BoxShadow(
                  color: statusColor.withAlpha(150),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            statusText.toUpperCase(),
            style: AppTextStyles.caption.copyWith(
              fontSize: 8.5,
              fontWeight: FontWeight.w900,
              color: statusColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPowerSaveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.warning.withAlpha(40),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.warning,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.battery_saver_rounded,
            size: 11,
            color: AppColors.primaryDark,
          ),
          const SizedBox(width: 4),
          Text(
            "HEMAT BATERAI",
            style: AppTextStyles.caption.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryDark,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.caption.copyWith(
        fontSize: 11,
        color: AppColors.primaryDark,
        fontWeight: FontWeight.w900,
        letterSpacing: 2.0,
      ),
    );
  }

  Widget _buildNewsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionTitle("BERITA KESEHATAN"),
        TextButton(
          onPressed: () => Get.toNamed(Routes.news),
          child: Text(
            "LIHAT SEMUA",
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewsList(NewsService newsService) {
    return Obx(() {
      if (newsService.isLoading.value && newsService.newsList.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      
      if (newsService.newsList.isEmpty) {
        return const SizedBox(
          height: 150,
          child: Center(child: Text("Tidak ada berita tersedia")),
        );
      }
      
      return Column(
        children: newsService.newsList.take(3).map((news) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: EyeCareNewsCard(news: news),
        )).toList(),
      );
    });
  }

  void _showNotificationTips() {
    VDialog.show(
      title: "MISI & TIPS HARI INI",
      icon: Icons.notifications_active_rounded,
      iconColor: AppColors.secondary,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTipItem(
            Icons.tips_and_updates_rounded, 
            "ATURAN 20-20-20", 
            "Setiap 20 menit menatap layar HP, istirahatkan mata dengan melihat benda berjarak 6 meter (20 kaki) selama 20 detik.",
          ),
          const SizedBox(height: 12),
          _buildTipItem(
            Icons.wb_sunny_rounded, 
            "CAHAYA SEHAT", 
            "Hindari bermain HP di ruangan gelap gulita. Pastikan ruangan memiliki pencahayaan cukup agar mata anak tidak tegang.",
          ),
          const SizedBox(height: 12),
          _buildTipItem(
            Icons.sports_esports_rounded, 
            "MISI SPESIAL VIZO", 
            "Mainkan menu 'Latihan' senam mata seru bersama Vizo untuk meregangkan otot penglihatan dan dapatkan bonus +50 XP!",
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(IconData icon, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryDark, width: 2),
        boxShadow: const [
          BoxShadow(
            color: AppColors.primaryDark,
            offset: Offset(3, 3),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.secondary.withAlpha(20),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryDark, width: 1.5),
            ),
            child: Icon(icon, color: AppColors.secondary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyBold.copyWith(fontSize: 12, color: AppColors.primaryDark),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: AppTextStyles.caption.copyWith(fontSize: 10, color: AppColors.primaryDark.withAlpha(180), height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLevelDetails(int level, int xp, int nextLevelXp) {
    VDialog.show(
      title: "PROFIL PAHLAWAN MATA",
      icon: Icons.shield_rounded,
      iconColor: AppColors.primary,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Column(
              children: [
                Hero(
                  tag: 'vizo_thumb_dialog',
                  child: VizoMascot(size: 96, state: VizoState.happy),
                ),
                const SizedBox(height: 12),
                Text(
                  "LEVEL $level: HERO DEFENDER",
                  style: AppTextStyles.heading1.copyWith(color: AppColors.primary, fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  "Ayo kumpulkan ${(nextLevelXp - xp)} XP lagi untuk naik level!",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildMilestoneItem(Icons.task_alt_rounded, "Level Saat Ini ($level)", "Kamu telah melindungi matamu dengan sangat disiplin."),
          const SizedBox(height: 10),
          _buildMilestoneItem(Icons.lock_outline_rounded, "Target Level ${level + 1}", "Terbuka setelah mencapai $nextLevelXp XP."),
        ],
      ),
    );
  }

  Widget _buildMilestoneItem(IconData icon, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryDark, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: AppColors.primaryDark,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(20),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryDark, width: 1),
            ),
            child: Icon(icon, color: AppColors.primary, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyBold.copyWith(fontSize: 11, color: AppColors.primaryDark)),
                const SizedBox(height: 2),
                Text(desc, style: AppTextStyles.caption.copyWith(fontSize: 9, color: AppColors.primaryDark.withAlpha(150), height: 1.2)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

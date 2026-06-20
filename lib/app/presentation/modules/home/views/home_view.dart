import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:visionsafe/app/presentation/global_widgets/organisms/live_vizo_radar.dart';
import 'package:visionsafe/app/presentation/global_widgets/organisms/quick_stats_grid.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_app_header.dart';
import 'package:visionsafe/app/data/services/news_service.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/templates/base_screen_template.dart';
import 'package:visionsafe/app/presentation/global_widgets/animations/fade_in_up.dart';

import 'widgets/compact_action_button.dart';
import 'widgets/mascot_status_panel.dart';
import 'widgets/news_feed_section.dart';
import 'widgets/notification_tips_dialog.dart';

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
            icon: const Icon(Icons.lightbulb_outline_rounded, color: AppColors.primaryDark),
            onPressed: () => NotificationTipsDialog.show(),
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
            child: MascotStatusPanel(controller: controller),
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
          NewsFeedSection(newsService: newsService),
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
}

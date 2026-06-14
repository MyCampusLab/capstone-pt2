import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/stats_controller.dart';
import 'widgets/health_score_card.dart';
import 'widgets/screen_time_vs_rest_card.dart';
import 'widgets/stat_metrics_grid.dart';
import 'widgets/weekly_chart.dart';
import 'widgets/leaderboard_widget.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/templates/base_screen_template.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_app_header.dart';

class StatsView extends GetView<StatsController> {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => BaseScreenTemplate(
          appBar: const VAppHeader(title: 'LAPORAN KESEHATAN'),
          bottomPadding: 180,
          onRefresh: controller.refreshData,
          child: controller.isLoading.value && controller.hourlyViolations.every((v) => v == 0)
              ? _buildLoadingState()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HealthScoreCard(),
                    const SizedBox(height: 24),
                    _buildSectionTitle("RINGKASAN METRIK"),
                    const StatMetricsGrid(),
                    const SizedBox(height: 24),
                    const WeeklyChart(),
                    const SizedBox(height: 24),
                    _buildSectionTitle("KESEIMBANGAN WAKTU"),
                    const ScreenTimeVsRestCard(),
                    const SizedBox(height: 24),
                    _buildSectionTitle("GLOBAL RANKING"),
                    const LeaderboardWidget(),
                  ],
                ),
        ));
  }

  Widget _buildLoadingState() {
    return const SizedBox(
      height: 400,
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.primaryDark,
          fontWeight: FontWeight.w900,
          letterSpacing: 2.0,
        ),
      ),
    );
  }
}

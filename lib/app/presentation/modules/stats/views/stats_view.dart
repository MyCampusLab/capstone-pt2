import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/stats_controller.dart';
import 'widgets/health_score_card.dart';
import 'widgets/screen_time_vs_rest_card.dart';
import 'widgets/stat_metrics_grid.dart';
import 'widgets/weekly_chart.dart';
import 'widgets/leaderboard_widget.dart';
import 'widgets/violation_heatmap.dart';
import 'widgets/insight_card.dart';
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
                    _buildRealtimeHeader(),
                    const SizedBox(height: 16),
                    const HealthScoreCard(),
                    const SizedBox(height: 16),
                    const InsightCard(),
                    const SizedBox(height: 24),
                    _buildSectionTitle("RINGKASAN METRIK"),
                    const StatMetricsGrid(),
                    const SizedBox(height: 24),
                    const ViolationHeatmap(),
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

  Widget _buildRealtimeHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.success.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success.withAlpha(80), width: 1.5),
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
              color: AppColors.success,
              boxShadow: [
                BoxShadow(
                  color: AppColors.success.withAlpha(150),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "LIVE SYNC AKTIF",
            style: AppTextStyles.caption.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: AppColors.success,
              letterSpacing: 1.0,
            ),
          ),
        ],
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

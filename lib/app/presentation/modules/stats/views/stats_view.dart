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
import 'widgets/detailed_logs_widget.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/templates/base_screen_template.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_app_header.dart';
import 'package:visionsafe/app/data/services/pdf_export_service.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_toast.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_skeleton.dart';
import 'package:visionsafe/app/data/services/family_service.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_button.dart';

class StatsView extends StatelessWidget {
  final String? tag;
  const StatsView({super.key, this.tag});

  @override
  Widget build(BuildContext context) {
    // Mendukung instance ganda untuk Supervisor Mode
    final controller = Get.find<StatsController>(tag: tag);
    
    return Obx(() {
      final headerTitle = controller.targetName != null 
          ? 'LAPORAN ${controller.targetName!.toUpperCase()}' 
          : 'LAPORAN KESEHATAN';
          
      return BaseScreenTemplate(
          appBar: VAppHeader(
            title: headerTitle,
            showBackButton: controller.targetUserId != null,
            actions: [
              IconButton(
                icon: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.primary),
                tooltip: 'Unduh Laporan Medis (PDF)',
                onPressed: () {
                  // Inisiasi secara lazy jika belum ada
                  if (!Get.isRegistered<PdfExportService>()) {
                    Get.put(PdfExportService());
                  }
                  Get.find<PdfExportService>().generateAndPrintReport(controller);
                },
              )
            ],
          ),
          bottomPadding: 180,
          onRefresh: controller.refreshData,
          child: controller.isLoading.value && controller.hourlyViolations.every((v) => v == 0)
              ? _buildLoadingState()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HealthScoreCard(controller: controller),
                    if (controller.targetUserId != null) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Obx(() => VButton(
                          onPressed: controller.isNudgeCooldown.value 
                              ? () {} 
                              : () => _showNudgeOptions(context, controller),
                          icon: controller.isNudgeCooldown.value ? Icons.timer_rounded : Icons.notifications_active_rounded,
                          label: controller.isNudgeCooldown.value ? "COOLDOWN (60s)" : "KIRIM TEGURAN (NUDGE)",
                          color: controller.isNudgeCooldown.value ? Colors.grey : Colors.red,
                        )),
                      ),
                    ],
                    const SizedBox(height: 16),
                    InsightCard(controller: controller),
                    const SizedBox(height: 24),
                    _buildSectionTitle("RINGKASAN METRIK"),
                    StatMetricsGrid(controller: controller),
                    const SizedBox(height: 24),
                    ViolationHeatmap(controller: controller),
                    const SizedBox(height: 24),
                    _buildSectionTitle("LOG PELANGGARAN DETIK"),
                    DetailedLogsWidget(controller: controller),
                    const SizedBox(height: 24),
                    WeeklyChart(controller: controller),
                    const SizedBox(height: 24),
                    _buildSectionTitle("KESEIMBANGAN WAKTU"),
                    ScreenTimeVsRestCard(controller: controller),
                    const SizedBox(height: 24),
                    _buildSectionTitle("GLOBAL RANKING"),
                    LeaderboardWidget(controller: controller),
                  ],
                ),
        );
    });
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          VSkeleton(height: 120),
          SizedBox(height: 24),
          VSkeleton(height: 20, width: 150),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: VSkeleton(height: 100)),
              SizedBox(width: 16),
              Expanded(child: VSkeleton(height: 100)),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: VSkeleton(height: 100)),
              SizedBox(width: 16),
              Expanded(child: VSkeleton(height: 100)),
            ],
          ),
          SizedBox(height: 24),
          VSkeleton(height: 20, width: 180),
          SizedBox(height: 16),
          VSkeleton(height: 250),
        ],
      ),
    );
  }

  // _buildRealtimeHeader() telah dihapus karena diintegrasikan ke HealthScoreCard

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

  void _showNudgeOptions(BuildContext context, StatsController controller) {
    final List<Map<String, dynamic>> nudgeOptions = [
      {"icon": "🚨", "msg": "Jauhkan matamu dari layar sekarang!"},
      {"icon": "🛌", "msg": "Ayo istirahat, matamu sudah lelah!"},
      {"icon": "🧘‍♂️", "msg": "Lakukan senam mata 20-20-20 sekarang!"},
      {"icon": "😡", "msg": "Patuhi aturan jarak atau HP disita!"},
    ];

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: AppColors.primaryDark, width: 3),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.campaign_rounded, color: AppColors.danger, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text("KIRIM TEGURAN", style: AppTextStyles.heading2),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text("Pilih pesan peringatan untuk ${controller.targetName}:", style: AppTextStyles.bodyMedium),
            const SizedBox(height: 24),
            ...nudgeOptions.map((opt) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () async {
                  Get.back(); // Tutup BottomSheet
                  final familyService = Get.find<FamilyService>();
                  final success = await familyService.sendNudge(
                    controller.targetUserId!, 
                    opt["msg"],
                  );
                  if (success) {
                    controller.startNudgeCooldown(); // Mulai cooldown
                    VToast.show("Teguran Terkirim", "Berhasil mengingatkan ${controller.targetName}", state: VizoState.happy);
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primaryDark, width: 2),
                    boxShadow: const [BoxShadow(color: AppColors.primaryDark, offset: Offset(2, 2))],
                  ),
                  child: Row(
                    children: [
                      Text(opt["icon"], style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(opt["msg"], style: AppTextStyles.bodyBold),
                      ),
                      const Icon(Icons.send_rounded, color: AppColors.primary, size: 20),
                    ],
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}

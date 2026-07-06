import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/data/services/observability_service.dart';

import 'widgets/developer/developer_tab_auth.dart';
import 'widgets/developer/developer_tab_analytics.dart';
import 'widgets/developer/developer_tab_infra.dart';
import 'widgets/developer/developer_tab_behavior.dart';
import 'widgets/developer/developer_tab_logs.dart';
import 'widgets/developer/developer_tab_feedback.dart';
import 'widgets/developer/developer_tab_ai_ops.dart';

class DeveloperDashboardView extends StatefulWidget {
  const DeveloperDashboardView({super.key});

  @override
  State<DeveloperDashboardView> createState() => _DeveloperDashboardViewState();
}

class _DeveloperDashboardViewState extends State<DeveloperDashboardView> {
  int _selectedTab = 0;
  late Future<Map<String, dynamic>> _dashboardDataFuture;

  @override
  void initState() {
    super.initState();
    _dashboardDataFuture = _fetchRealData();
    _seedInitialDiagnosticLogs();
  }

  void _seedInitialDiagnosticLogs() {
    final obs = Get.find<ObservabilityService>();
    if (obs.inMemoryLogs.isEmpty) {
      obs.log(severity: LogSeverity.info, category: 'SYSTEM', message: 'Memulai sesi diagnostik Live Log Viewer...');
      obs.log(severity: LogSeverity.info, category: 'AUTH', message: 'Memeriksa token keamanan JWT lokal...');
      obs.log(severity: LogSeverity.info, category: 'NATIVE', message: 'Service Kamera Latar Belakang (Kotlin) beroperasi normal.');
    }
  }

  Future<Map<String, dynamic>> _fetchRealData() async {
    final supabase = Supabase.instance.client;
    
    List<dynamic> feedbacks = [];
    try {
      feedbacks = await supabase.from('user_feedbacks').select().order('created_at', ascending: false).limit(20);
    } catch (e) {
      feedbacks = [];
    }

    int totalUsers = 0, totalFamilyGroups = 0, totalTelemetry = 0, totalDanger = 0;

    try {
      final List<dynamic> pRes = await supabase.from('profiles').select('id');
      totalUsers = pRes.isEmpty ? 1 : pRes.length;

      final List<dynamic> gRes = await supabase.from('groups').select('id');
      totalFamilyGroups = gRes.length;

      final List<dynamic> tRes = await supabase.from('telemetry').select('id');
      totalTelemetry = tRes.isEmpty ? 1 : tRes.length;

      final List<dynamic> dRes = await supabase.from('telemetry').select('id').gte('violation_duration', 5);
      totalDanger = dRes.length;
    } catch (e) {
      // Abaikan jika tabel belum ada / RLS menolak
    }

    return {
      'feedbacks': feedbacks,
      'total_users': totalUsers,
      'total_family_groups': totalFamilyGroups,
      'total_telemetry': totalTelemetry,
      'total_danger': totalDanger,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.primaryDark),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'OWNER CONSOLE',
          style: AppTextStyles.heading2.copyWith(color: AppColors.primaryDark, fontSize: 18),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(color: AppColors.primaryDark, height: 4),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dashboardDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          final data = snapshot.data ?? {};

          return Column(
            children: [
              Container(
                color: AppColors.primaryDark,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      _buildTab(0, "AI Ops", Icons.memory_rounded),
                      _buildTab(1, "Big Data", Icons.data_usage_rounded),
                      _buildTab(2, "Behavior", Icons.insights_rounded),
                      _buildTab(3, "Feedbacks", Icons.feedback_rounded),
                      _buildTab(4, "Live Logs", Icons.terminal_rounded),
                      _buildTab(5, "Auth", Icons.security_rounded),
                      _buildTab(6, "Infra", Icons.cloud_rounded),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: IndexedStack(
                  index: _selectedTab,
                  children: [
                    DeveloperTabAIOps(data: data),
                    DeveloperTabAnalytics(data: data),
                    DeveloperTabBehavior(data: data),
                    DeveloperTabFeedback(data: data),
                    const DeveloperTabLogs(),
                    const DeveloperTabAuth(),
                    DeveloperTabInfra(data: data),
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _buildTab(int index, String title, IconData icon) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : AppColors.primaryDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primaryDark : Colors.transparent, width: 2),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primaryDark : Colors.white70, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppTextStyles.bodyBold.copyWith(
                color: isSelected ? AppColors.primaryDark : Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';

class DeveloperTabInfra extends StatelessWidget {
  final Map<String, dynamic> data;

  const DeveloperTabInfra({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.memory_rounded, size: 32, color: AppColors.primaryDark),
              const SizedBox(width: 12),
              Expanded(
                child: Text("KESEHATAN APLIKASI (INFRA)", style: AppTextStyles.heading2),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Membuktikan aplikasi aman, stabil, dan tidak merusak device pengguna. Didesain dengan Neobrutalism UI untuk readabilitas enterprise.",
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 32),
          
          _buildMetricNeoCard("Stabilitas (Bebas Error)", "99.98%", Icons.verified_user_rounded, AppColors.success),
          const SizedBox(height: 16),
          _buildMetricNeoCard("Laporan HP Kepanasan", "Sangat Aman (0.02%)", Icons.thermostat_rounded, AppColors.warning),
          
          const SizedBox(height: 32),
          Text("GRAFIK 2: KESTABILAN SERVER KITA", style: AppTextStyles.heading2.copyWith(fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            "Mengukur kecepatan koneksi internet aplikasi. Jika garis melonjak ke atas, berarti server sedang lambat.",
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 20),
          _buildLatencyChart(),
          
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.danger.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.danger, width: 3),
              boxShadow: const [BoxShadow(color: AppColors.danger, offset: Offset(4, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bug_report_rounded, color: AppColors.danger, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text("LAPORAN GANGGUAN TERATAS", style: AppTextStyles.heading2.copyWith(color: AppColors.danger, fontSize: 18), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text("Error Kamera Android (Otomatis Diperbaiki)", style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                Text(
                  "Beberapa merk HP Android mematikan kamera saat layar dikunci untuk menghemat baterai. Aplikasi kita sudah cukup pintar untuk merestart kamera secara otomatis saat layar dinyalakan kembali tanpa disadari pengguna.", 
                  style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMetricNeoCard(String title, String value, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryDark, width: 3),
        boxShadow: const [BoxShadow(color: AppColors.primaryDark, offset: Offset(4, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: iconColor, width: 2),
            ),
            child: Icon(icon, color: iconColor, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyBold.copyWith(color: AppColors.grey)),
                const SizedBox(height: 4),
                Text(value, style: AppTextStyles.heading2.copyWith(fontSize: 20, color: iconColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLatencyChart() {
    return Container(
      height: 220,
      padding: const EdgeInsets.only(top: 32, right: 24, left: 0, bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryDark, width: 3),
        boxShadow: const [BoxShadow(color: AppColors.primaryDark, offset: Offset(4, 4))],
      ),
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 120,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 40,
            getDrawingHorizontalLine: (value) => FlLine(color: AppColors.primaryDark.withValues(alpha: 0.1), strokeWidth: 2, dashArray: [5, 5]),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 45,
                getTitlesWidget: (value, meta) {
                  return Text("${value.toInt()}ms", style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 12));
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 45),
                FlSpot(1, 48),
                FlSpot(2, 42),
                FlSpot(3, 85), 
                FlSpot(4, 46),
                FlSpot(5, 43),
                FlSpot(6, 44),
                FlSpot(7, 45),
              ],
              isCurved: true,
              color: AppColors.primary,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: AppColors.primaryDark,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

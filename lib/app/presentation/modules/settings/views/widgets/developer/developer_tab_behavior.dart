import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';

class DeveloperTabBehavior extends StatelessWidget {
  final Map<String, dynamic> data;

  const DeveloperTabBehavior({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    int totalDanger = data['total_danger'] ?? 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.insights_rounded, size: 32, color: AppColors.primaryDark),
              const SizedBox(width: 12),
              Expanded(
                child: Text("PERILAKU PENGGUNA", style: AppTextStyles.heading2),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Menggambarkan tren perilaku anak. Bantu kembangkan program edukasi baru jika grafik merah terus meningkat.",
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 32),
          
          _buildMetricNeoCard("Total Pelanggaran Berat", "$totalDanger Insiden", Icons.warning_rounded, AppColors.danger),
          
          const SizedBox(height: 32),
          Text("GRAFIK 3: RASIO KEPATUHAN", style: AppTextStyles.heading2.copyWith(fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            "Seberapa banyak pengguna yang patuh (Jarak > 30cm) berbanding yang melanggar setiap harinya.",
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 20),
          _buildComplianceChart(),
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

  Widget _buildComplianceChart() {
    return Container(
      height: 220,
      padding: const EdgeInsets.only(top: 32, right: 24, left: 0, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryDark, width: 3),
        boxShadow: const [BoxShadow(color: AppColors.primaryDark, offset: Offset(4, 4))],
      ),
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 100,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 25,
            getDrawingHorizontalLine: (value) => FlLine(color: AppColors.primaryDark.withValues(alpha: 0.1), strokeWidth: 2, dashArray: [5, 5]),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const style = TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 10);
                  String text;
                  switch (value.toInt()) {
                    case 0: text = 'Sen'; break;
                    case 1: text = 'Sel'; break;
                    case 2: text = 'Rab'; break;
                    case 3: text = 'Kam'; break;
                    case 4: text = 'Jum'; break;
                    case 5: text = 'Sab'; break;
                    case 6: text = 'Min'; break;
                    default: text = ''; break;
                  }
                  return Padding(padding: const EdgeInsets.only(top: 8), child: Text(text, style: style));
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 45,
                getTitlesWidget: (value, meta) {
                  return Text("${value.toInt()}%", style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 12));
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
                FlSpot(0, 80),
                FlSpot(1, 85),
                FlSpot(2, 75),
                FlSpot(3, 90), 
                FlSpot(4, 88),
                FlSpot(5, 60), 
                FlSpot(6, 65),
              ],
              isCurved: true,
              color: AppColors.success,
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
            ),
            LineChartBarData(
              spots: const [
                FlSpot(0, 20),
                FlSpot(1, 15),
                FlSpot(2, 25),
                FlSpot(3, 10), 
                FlSpot(4, 12),
                FlSpot(5, 40), 
                FlSpot(6, 35),
              ],
              isCurved: true,
              color: AppColors.danger,
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
            ),
          ],
        ),
      ),
    );
  }
}

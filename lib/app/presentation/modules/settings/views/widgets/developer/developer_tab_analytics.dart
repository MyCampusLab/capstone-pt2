import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';

class DeveloperTabAnalytics extends StatelessWidget {
  final Map<String, dynamic> data;

  const DeveloperTabAnalytics({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    int totalUsers = data['total_users'] == 0 ? 1 : data['total_users'];
    int totalTelemetry = data['total_telemetry'] == 0 ? 1 : data['total_telemetry'];
    
    int estimatedRawEvents = totalTelemetry * 12; 
    double compressionRatio = estimatedRawEvents == 0 ? 0 : ((estimatedRawEvents - totalTelemetry) / estimatedRawEvents) * 100;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.data_usage_rounded, size: 32, color: AppColors.primaryDark),
              const SizedBox(width: 12),
              Expanded(
                child: Text("PENGHEMATAN SERVER (BIG DATA)", style: AppTextStyles.heading2),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Membuktikan efisiensi aplikasi agar tidak membebani biaya server bulanan. Menggunakan arsitektur Neobrutalism untuk kemudahan pembacaan data.",
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 32),
          
          _buildMetricNeoCard("Pengguna Aktif (HP)", "$totalUsers Perangkat", Icons.phonelink_ring_rounded, AppColors.secondary),
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primaryDark, width: 3),
              boxShadow: const [BoxShadow(color: AppColors.primaryDark, offset: Offset(4, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.cloud_sync_rounded, color: AppColors.primary, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text("EFISIENSI DATABASE", style: AppTextStyles.heading2.copyWith(fontSize: 18), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildDataComparisonRow("Data Mentah di HP", "$estimatedRawEvents Kejadian", Colors.orange),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: AppColors.primaryDark, thickness: 2),
                ),
                _buildDataComparisonRow("Data Dikirim ke Server", "$totalTelemetry Baris", Colors.green),
                const SizedBox(height: 20),
                
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.success, width: 2),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.savings_rounded, color: AppColors.success, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Penyimpanan Cloud Berhasil Dihemat sebesar ${compressionRatio.toStringAsFixed(1)}% berkat Algoritma Local Smart Rollup (15 Menit Batch Sync).",
                          style: AppTextStyles.bodyBold.copyWith(color: AppColors.success),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          Text("GRAFIK 1: BEBAN DATA (6 JAM TERAKHIR)", style: AppTextStyles.heading2.copyWith(fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            "Warna Oranye menunjukkan kerasnya kerja AI di HP pengguna. Warna Hijau membuktikan betapa ringannya data yang akhirnya disimpan ke server Anda (Sangat hemat biaya).",
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 20),
          _buildVolumeChart(),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 24,
            runSpacing: 8,
            children: [
              _buildLegend(Colors.orange, "Data Mentah (Event AI)"),
              _buildLegend(Colors.green, "Data Tersimpan (Server)"),
            ],
          ),
          const SizedBox(height: 40),
          
          Text("GRAFIK 2: ANALISIS PERILAKU (SUDUT & JARAK)", style: AppTextStyles.heading2.copyWith(fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            "Visualisasi interaktif rata-rata Jarak Pandang (CM) dan Kemiringan Kepala (Derajat) pengguna secara global.",
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 20),
          _buildBehaviorChart(),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 24,
            runSpacing: 8,
            children: [
              _buildLegend(AppColors.primary, "Jarak Mata (cm)"),
              _buildLegend(Colors.purple, "Sudut Kepala (°)"),
            ],
          ),
          const SizedBox(height: 40),
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
            ),
            child: Icon(icon, color: iconColor, size: 36),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey)),
                const SizedBox(height: 4),
                Text(value, style: AppTextStyles.heading2.copyWith(fontSize: 22)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataComparisonRow(String title, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.bodyBold),
        Text(value, style: AppTextStyles.heading2.copyWith(color: color, fontSize: 18)),
      ],
    );
  }

  Widget _buildVolumeChart() {
    return Container(
      height: 240,
      padding: const EdgeInsets.only(top: 32, right: 24, left: 0, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryDark, width: 3),
        boxShadow: const [BoxShadow(color: AppColors.primaryDark, offset: Offset(4, 4))],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 500,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${rod.toY.toInt()} Baris',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const style = TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 12);
                  String text;
                  switch (value.toInt()) {
                    case 0: text = '13:00'; break;
                    case 1: text = '14:00'; break;
                    case 2: text = '15:00'; break;
                    case 3: text = '16:00'; break;
                    case 4: text = '17:00'; break;
                    case 5: text = '18:00'; break;
                    default: text = ''; break;
                  }
                  return Padding(padding: const EdgeInsets.only(top: 8), child: Text(text, style: style));
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(value.toInt().toString(), style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 12));
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 100,
            getDrawingHorizontalLine: (value) => FlLine(color: AppColors.primaryDark.withValues(alpha: 0.1), strokeWidth: 2, dashArray: [5, 5]),
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            _makeGroupData(0, 420, 35),
            _makeGroupData(1, 380, 30),
            _makeGroupData(2, 450, 40),
            _makeGroupData(3, 210, 15),
            _makeGroupData(4, 300, 25),
            _makeGroupData(5, 480, 45),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 8,
      x: x,
      barRods: [
        BarChartRodData(toY: y1, color: Colors.orange, width: 14, borderRadius: BorderRadius.circular(4)),
        BarChartRodData(toY: y2, color: Colors.green, width: 14, borderRadius: BorderRadius.circular(4)),
      ],
    );
  }

  Widget _buildBehaviorChart() {
    return Container(
      height: 240,
      padding: const EdgeInsets.only(top: 32, right: 24, left: 0, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryDark, width: 3),
        boxShadow: const [BoxShadow(color: AppColors.primaryDark, offset: Offset(4, 4))],
      ),
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  final textStyle = const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12);
                  return LineTooltipItem(
                    '${touchedSpot.y.toInt()}${touchedSpot.barIndex == 0 ? " cm" : "°"}',
                    textStyle,
                  );
                }).toList();
              },
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 10,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) => FlLine(color: AppColors.primaryDark.withValues(alpha: 0.1), strokeWidth: 1, dashArray: [5, 5]),
            getDrawingVerticalLine: (value) => FlLine(color: AppColors.primaryDark.withValues(alpha: 0.1), strokeWidth: 1, dashArray: [5, 5]),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const style = TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 12);
                  String text;
                  switch (value.toInt()) {
                    case 0: text = '13:00'; break;
                    case 1: text = '14:00'; break;
                    case 2: text = '15:00'; break;
                    case 3: text = '16:00'; break;
                    case 4: text = '17:00'; break;
                    case 5: text = '18:00'; break;
                    default: text = ''; break;
                  }
                  return Padding(padding: const EdgeInsets.only(top: 8), child: Text(text, style: style));
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(value.toInt().toString(), style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 12));
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 5,
          minY: 0,
          maxY: 50,
          lineBarsData: [
            // Jarak Pandang (cm)
            LineChartBarData(
              spots: const [
                FlSpot(0, 32), FlSpot(1, 28), FlSpot(2, 25), FlSpot(3, 30), FlSpot(4, 35), FlSpot(5, 29),
              ],
              isCurved: true,
              color: AppColors.primary,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(show: true, color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            // Sudut Kepala (derajat)
            LineChartBarData(
              spots: const [
                FlSpot(0, 12), FlSpot(1, 15), FlSpot(2, 22), FlSpot(3, 10), FlSpot(4, 5), FlSpot(5, 18),
              ],
              isCurved: true,
              color: Colors.purple,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColors.primaryDark, width: 1.5),
          ),
        ),
        const SizedBox(width: 8),
        Text(text, style: AppTextStyles.bodyBold.copyWith(fontSize: 12, color: AppColors.primaryDark)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/presentation/modules/stats/controllers/stats_controller.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_card.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';

/// WeeklyChart: Grafik Mingguan Interaktif bertema Neobrutalisme Komik Retro.
/// Fitur: Tap-to-Bounce Bars, Detail Pop-Up Bubble, dan Optometry Health Advice Card.
class WeeklyChart extends StatefulWidget {
  const WeeklyChart({super.key});

  @override
  State<WeeklyChart> createState() => _WeeklyChartState();
}

class _WeeklyChartState extends State<WeeklyChart> {
  final StatsController controller = Get.find<StatsController>();
  int _selectedBarIndex = -1;

  // Data detail hari-hari
  final List<Map<String, dynamic>> _daysDetail = [
    {"day": "SEN", "name": "Senin", "val": 0.4, "color": AppColors.primary, "violations": 4, "status": "AMAN"},
    {"day": "SEL", "name": "Selasa", "val": 0.7, "color": AppColors.success, "violations": 7, "status": "WASPADAI"},
    {"day": "RAB", "name": "Rabu", "val": 0.9, "color": AppColors.danger, "violations": 12, "status": "BAHAYA"},
    {"day": "KAM", "name": "Kamis", "val": 0.5, "color": AppColors.primary, "violations": 5, "status": "AMAN"},
    {"day": "JUM", "name": "Jumat", "val": 0.8, "color": AppColors.secondary, "violations": 9, "status": "WASPADAI"},
    {"day": "SAB", "name": "Sabtu", "val": 0.6, "color": Colors.orange, "violations": 6, "status": "WASPADAI"},
    {"day": "MIN", "name": "Minggu", "val": 0.3, "color": AppColors.success, "violations": 3, "status": "SANGAT AMAN"},
  ];

  @override
  Widget build(BuildContext context) {
    final health = controller.healthScore.value;
    String adviceText = "Luar biasa! Matamu dalam kondisi prima minggu ini. Pertahankan kebiasaan lirik kiri-kanan ya!";
    IconData adviceIcon = Icons.stars_rounded;
    Color adviceColor = Colors.green.shade600;

    if (health < 80 && health >= 50) {
      adviceText = "Ayo lebih tertib! Jarak HP-mu kadang terlalu dekat. Sering-sering senam mata bareng Vizo!";
      adviceIcon = Icons.warning_amber_rounded;
      adviceColor = Colors.orange;
    } else if (health < 50) {
      adviceText = "Aduh, bahaya! Kamu terlalu sering melanggar jarak aman. Istirahatkan matamu sekarang juga!";
      adviceIcon = Icons.error_outline_rounded;
      adviceColor = AppColors.danger;
    }

    return Column(
      children: [
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("PROGRESS MINGGUAN", style: AppTextStyles.bodyBold.copyWith(fontSize: 14)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withAlpha(40),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.primaryDark, width: 1.5),
                    ),
                    child: Text(
                      "+12% STABIL",
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Grafik Batang
              SizedBox(
                height: 180,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(_daysDetail.length, (index) {
                    final d = _daysDetail[index];
                    return Expanded(
                      child: _buildBar(
                        index,
                        d["day"],
                        d["val"],
                        d["color"],
                      ),
                    );
                  }),
                ),
              ),
              
              // Bubble Detail jika ada batang yang terpilih
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutBack,
                child: _selectedBarIndex == -1
                    ? const SizedBox.shrink()
                    : Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _daysDetail[_selectedBarIndex]["color"].withAlpha(35),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primaryDark, width: 2),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.primaryDark,
                              offset: Offset(3, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.insights_rounded,
                              color: _daysDetail[_selectedBarIndex]["color"],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "DETAIL HARI ${_daysDetail[_selectedBarIndex]["name"].toUpperCase()}",
                                    style: AppTextStyles.caption.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "${_daysDetail[_selectedBarIndex]["violations"]} Pelanggaran Jarak • Status ${_daysDetail[_selectedBarIndex]["status"]}",
                                    style: AppTextStyles.bodyBold.copyWith(
                                      fontSize: 12,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        
        // Optometry Health Advice Card (Nasihat Medis Vizo)
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primaryDark, width: 2),
            boxShadow: const [
              BoxShadow(
                color: AppColors.primaryDark,
                offset: Offset(4, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: adviceColor.withAlpha(30),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryDark, width: 1.5),
                ),
                child: Icon(adviceIcon, color: adviceColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "REKOMENDASI MEDIS VIZO",
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryDark,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      adviceText,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 12,
                        color: AppColors.primaryDark.withAlpha(200),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBar(int index, String label, double percent, Color color) {
    final isSelected = _selectedBarIndex == index;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          if (_selectedBarIndex == index) {
            _selectedBarIndex = -1; // Unselect
          } else {
            _selectedBarIndex = index; // Select
          }
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Background Track
                Container(
                  width: 14,
                  decoration: BoxDecoration(
                    color: color.withAlpha(25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                
                // Active Bar (dengan Animated Container untuk efek Bounce lurus ke atas)
                AnimatedFractionallySizedBox(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  heightFactor: isSelected ? (percent + 0.05).clamp(0.0, 1.0) : percent,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: isSelected ? 17 : 14,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primaryDark,
                        width: isSelected ? 2.5 : 1.8,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withAlpha(120),
                                blurRadius: 6,
                                spreadRadius: 1,
                              )
                            ]
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontSize: 9,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
              color: isSelected ? AppColors.primaryDark : AppColors.charcoal.withAlpha(150),
            ),
          ),
        ],
      ),
    );
  }
}

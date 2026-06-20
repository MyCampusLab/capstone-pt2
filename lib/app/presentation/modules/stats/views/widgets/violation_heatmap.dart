import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_card.dart';
import '../../controllers/stats_controller.dart';

class ViolationHeatmap extends StatefulWidget {
  final StatsController controller;
  const ViolationHeatmap({super.key, required this.controller});

  @override
  State<ViolationHeatmap> createState() => _ViolationHeatmapState();
}

class _ViolationHeatmapState extends State<ViolationHeatmap> {
  int _selectedHour = -1;

  @override
  Widget build(BuildContext context) {
    return VCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("JAM RAWAN PELANGGARAN", style: AppTextStyles.bodyBold.copyWith(fontSize: 14)),
              const Icon(Icons.history_toggle_off_rounded, color: AppColors.charcoal, size: 18),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Visualisasi 24 Jam. Semakin merah kotaknya, semakin sering mata Anda dalam bahaya. Sentuh kotak untuk melihat analisis.",
            style: AppTextStyles.caption.copyWith(color: AppColors.grey, fontSize: 11),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final double itemWidth = (constraints.maxWidth - (5 * 6)) / 6; 
              
              return Wrap(
                spacing: 6,
                runSpacing: 6,
                children: List.generate(24, (index) {
                  final double intensity = widget.controller.hourlyViolations[index];
                  return _buildHeatBox(index, intensity, itemWidth);
                }),
              );
            },
          ),
          
          // Tooltip/Detail box when tapped
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutBack,
            child: _selectedHour == -1
                ? const SizedBox.shrink()
                : Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline_rounded, color: AppColors.primaryDark),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ANALISIS PUKUL ${_selectedHour.toString().padLeft(2, '0')}:00",
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Builder(builder: (context) {
                                final intensity = widget.controller.hourlyViolations[_selectedHour];
                                String analysis = "Mata dalam kondisi aman pada jam ini. Pertahankan kebiasaan baik ini!";
                                if (intensity >= 0.7) {
                                  analysis = "⚠️ Sangat Rawan! Anak Anda sangat sering melihat layar terlalu dekat pada jam ini. Saran: Dampingi anak atau aktifkan Mode Disiplin Keras.";
                                } else if (intensity >= 0.3) {
                                  analysis = "Perhatian: Cukup sering terjadi pelanggaran jarak. Ingatkan anak untuk menggunakan rumus 20-20-20.";
                                }
                                
                                return Text(
                                  analysis,
                                  style: AppTextStyles.caption.copyWith(
                                    fontSize: 11,
                                    color: AppColors.primaryDark.withAlpha(200),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),

          const SizedBox(height: 16),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildHeatBox(int hour, double intensity, double size) {
    Color boxColor = AppColors.success.withAlpha((40 + (intensity * 215)).toInt());
    if (intensity > 0.7) {
      boxColor = AppColors.danger.withAlpha((intensity * 255).toInt());
    } else if (intensity > 0.3) {
      boxColor = Colors.orange.withAlpha((intensity * 255).toInt());
    }

    final isSelected = _selectedHour == hour;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          if (_selectedHour == hour) {
            _selectedHour = -1;
          } else {
            _selectedHour = hour;
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryDark : AppColors.charcoal.withAlpha(30), 
            width: isSelected ? 2.5 : 1
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: boxColor.withAlpha(150), blurRadius: 6, spreadRadius: 1)]
              : [],
        ),
        child: Text(
          "$hour",
          style: AppTextStyles.caption.copyWith(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            color: intensity > 0.5 || isSelected ? Colors.white : AppColors.charcoal.withAlpha(150),
            height: 1.0, 
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      children: [
        Text("Tingkat Bahaya:", style: AppTextStyles.caption.copyWith(fontSize: 10, fontWeight: FontWeight.bold)),
        const Spacer(),
        _legendItem("Aman", AppColors.success.withAlpha(100)),
        const SizedBox(width: 8),
        _legendItem("Waspada", Colors.orange.withAlpha(150)),
        const SizedBox(width: 8),
        _legendItem("Bahaya", AppColors.danger.withAlpha(200)),
      ],
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8, height: 8,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.caption.copyWith(fontSize: 9)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/presentation/modules/stats/controllers/stats_controller.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';

class HealthScoreCard extends StatelessWidget {
  final StatsController controller;
  const HealthScoreCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF003366), Color(0xFF0056B3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: const Color(0xFF003366), width: 3),
        boxShadow: const [BoxShadow(color: Color(0xFF003366), offset: Offset(0, 8))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(37),
        child: Stack(
          children: [
            // Background Decorative Elements
            Positioned(
              right: -20, top: -20,
              child: Opacity(
                opacity: 0.1,
                child: Icon(Icons.shield_rounded, size: 150, color: Colors.white),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "SKOR KESEHATAN MATA",
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white70, 
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Obx(() => Text(
                          "${controller.healthScore.value}",
                          style: const TextStyle(
                            fontSize: 72, 
                            fontWeight: FontWeight.w900, 
                            color: Colors.white,
                            height: 1,
                          ),
                        )),
                        const SizedBox(height: 8),
                        Obx(() => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(50),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getScoreLabel(controller.healthScore.value),
                            style: AppTextStyles.bodyBold.copyWith(color: Colors.white, fontSize: 10),
                          ),
                        )),
                      ],
                    ),
                  ),
                  
                  // Right side illustration (Mascot Profile / Shield)
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(30),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white30, width: 2),
                        ),
                        child: const Center(
                          child: Icon(Icons.shield_rounded, color: Colors.white, size: 50),
                        ),
                      ),
                      // Indikator Live Sync (Badge)
                      Obx(() {
                        final isSyncActive = controller.isLiveSyncActive.value;
                        return Container(
                          margin: const EdgeInsets.only(top: 2, right: 2),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: isSyncActive ? const Color(0xFF00E676) : const Color(0xFFFF3D00),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF003366), width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: (isSyncActive ? const Color(0xFF00E676) : const Color(0xFFFF3D00)).withAlpha(150),
                                blurRadius: 8,
                                spreadRadius: 2,
                              )
                            ],
                          ),
                          child: Icon(
                            isSyncActive ? Icons.wifi_tethering_rounded : Icons.wifi_off_rounded,
                            color: const Color(0xFF003366),
                            size: 14,
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getScoreLabel(int score) {
    if (score >= 90) return "SANGAT BAIK";
    if (score >= 75) return "BAIK";
    if (score >= 60) return "CUKUP";
    return "PERLU PERHATIAN";
  }
}

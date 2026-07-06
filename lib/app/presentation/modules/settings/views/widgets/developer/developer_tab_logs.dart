import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';

import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/data/services/observability_service.dart';

class DeveloperTabLogs extends StatelessWidget {
  const DeveloperTabLogs({super.key});

  @override
  Widget build(BuildContext context) {
    final obs = Get.find<ObservabilityService>();
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.terminal_rounded, size: 32, color: AppColors.primaryDark),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text("MONITOR AKTIVITAS APLIKASI (LIVE)", style: AppTextStyles.heading2),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Melihat apa yang sedang dikerjakan sistem di balik layar secara Real-Time. Neobrutalism terminal UI.", 
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primaryDark, width: 3),
              boxShadow: const [
                BoxShadow(color: AppColors.primaryDark, offset: Offset(4, 4)),
              ],
            ),
            child: Obx(() {
              final logs = obs.inMemoryLogs;
              if (logs.isEmpty) {
                return const Center(
                  child: Text(
                    "> Menunggu aktivitas pengguna masuk...\n> Sistem AI berjalan normal tanpa kendala.",
                    style: TextStyle(fontFamily: 'monospace', color: Colors.greenAccent, fontSize: 13, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final logStr = logs[index];
                  Color textColor = Colors.white;
                  if (logStr.contains('[INFO]')) textColor = Colors.lightBlueAccent;
                  if (logStr.contains('[WARN]')) textColor = Colors.orangeAccent;
                  if (logStr.contains('[ERROR]')) textColor = Colors.redAccent;
                  if (logStr.contains('[CRITICAL]')) textColor = Colors.pinkAccent;
                  if (logStr.contains('[PERFORMANCE]')) textColor = Colors.greenAccent;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      logStr,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: textColor,
                        height: 1.5,
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ],
    );
  }
}

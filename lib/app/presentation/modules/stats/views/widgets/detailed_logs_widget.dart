import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import '../../controllers/stats_controller.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_button.dart';

class DetailedLogsWidget extends StatelessWidget {
  final StatsController controller;

  const DetailedLogsWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.danger,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
              border: Border(bottom: BorderSide(color: AppColors.primaryDark, width: 2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.history_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "RIWAYAT PELANGGARAN",
                    style: AppTextStyles.bodyBold.copyWith(color: Colors.white, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                // INDIKATOR REALTIME
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8, height: 8,
                        decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 6),
                      Text("LIVE SENSOR", style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Info banner for new users
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              border: const Border(bottom: BorderSide(color: Colors.black12, width: 1)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline_rounded, color: AppColors.warning, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Catatan otomatis setiap kali mata berada di bawah batas aman (30cm). Ketuk riwayat untuk melihat saran medis.",
                    style: AppTextStyles.caption.copyWith(color: AppColors.primaryDark.withValues(alpha: 0.8), fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            final logs = controller.detailedLogs;
            if (logs.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: Column(
                    children: [
                      Text("Mata Aman!", style: AppTextStyles.heading2.copyWith(color: AppColors.primaryDark, fontSize: 18)),
                      Text("Luar biasa! Tidak ada riwayat pelanggaran tercatat. Terus pertahankan jarak sehatmu.", textAlign: TextAlign.center, style: AppTextStyles.caption.copyWith(color: Colors.grey)),
                    ],
                  ),
                ),
              );
            }

            return ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 400),
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  final DateTime time = log['time'] as DateTime;
                  final double distance = (log['distance'] as num).toDouble();
                  
                  final dateStr = DateFormat('dd MMM yyyy').format(time);
                  final timeStr = DateFormat('HH:mm:ss').format(time);
                  
                  final isTampered = distance <= 0.1;
                  final isExtreme = !isTampered && distance < 20.0;
                  
                  final iconColor = isTampered ? Colors.purple : (isExtreme ? const Color(0xFF9B2C2C) : AppColors.danger);
                  final bgColor = isTampered ? Colors.purple.withValues(alpha: 0.1) : (isExtreme ? const Color(0xFF9B2C2C).withValues(alpha: 0.1) : AppColors.danger.withValues(alpha: 0.1));
                  final alertText = isTampered ? "SISTEM DIBLOKIR / TAMPERED" : (isExtreme ? "BAHAYA! Sangat Dekat" : "Jarak Terlalu Dekat");
                  
                  final durationDiff = DateTime.now().difference(time);
                  String timeAgo = "";
                  if (durationDiff.inSeconds < 60) {
                    timeAgo = "Baru Saja";
                  } else if (durationDiff.inMinutes < 60) {
                    timeAgo = "${durationDiff.inMinutes} mnt lalu";
                  } else if (durationDiff.inHours < 24) {
                    timeAgo = "${durationDiff.inHours} jam lalu";
                  } else {
                    timeAgo = dateStr;
                  }

                  final isLast = index == logs.length - 1;

                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // TIMELINE PINGGIR (Garis + Dot)
                        SizedBox(
                          width: 32,
                          child: Column(
                            children: [
                              Container(
                                width: 14,
                                height: 14,
                                margin: const EdgeInsets.only(top: 24),
                                decoration: BoxDecoration(
                                  color: iconColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: iconColor.withValues(alpha: 0.4),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    )
                                  ]
                                ),
                              ),
                              if (!isLast)
                                Expanded(
                                  child: Container(
                                    width: 2,
                                    color: Colors.black12,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // KONTEN KARTU TIMELINE
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12.0, top: 4.0),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  Get.bottomSheet(
                                    Container(
                                      padding: const EdgeInsets.all(24),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(4)))),
                                          const SizedBox(height: 24),
                                          Row(
                                            children: [
                                              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle), child: Icon(isTampered ? Icons.security_rounded : (isExtreme ? Icons.warning_rounded : Icons.warning_amber_rounded), color: iconColor, size: 28)),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(isTampered ? "Pelanggaran Keamanan" : "Detail Insiden", style: AppTextStyles.heading2.copyWith(color: AppColors.primaryDark, fontSize: 18)),
                                                    Text("$dateStr • $timeStr", style: AppTextStyles.caption.copyWith(color: Colors.grey, fontSize: 12)),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 24),
                                          Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(isTampered ? "Status Kamera" : "Jarak Mata Terdeteksi", style: AppTextStyles.bodyMedium.copyWith(color: Colors.black54)),
                                                Text(isTampered ? "DIBLOKIR / DICABUT" : "${distance.toStringAsFixed(1)} cm", style: AppTextStyles.heading2.copyWith(color: iconColor, fontSize: isTampered ? 14 : 20)),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(isTampered ? "Tindakan Curang:" : "Dampak Medis:", style: AppTextStyles.bodyBold.copyWith(color: AppColors.primaryDark)),
                                          const SizedBox(height: 8),
                                          Text(
                                            isTampered ? "Aplikasi mendeteksi bahwa perizinan kamera dicabut paksa melalui Pengaturan Android. Ini dianggap sebagai pelanggaran sistem (Anti-Cheat)." :
                                            (isExtreme ? "Ini sangat berbahaya! Otot silia mata dipaksa berkontraksi maksimal yang bisa memicu miopia (mata minus) permanen jika sering dilakukan." : "Jarak ini berpotensi menyebabkan ketegangan mata (Eye Strain) dan kelelahan visual."),
                                            style: AppTextStyles.bodyMedium.copyWith(color: Colors.black87),
                                          ),
                                          const SizedBox(height: 16),
                                          Text("Tindakan yang Disarankan:", style: AppTextStyles.bodyBold.copyWith(color: AppColors.primaryDark)),
                                          const SizedBox(height: 8),
                                          Text(
                                            isTampered ? "Tegur anak Anda dan pastikan perizinan kamera diaktifkan kembali. Layar perangkat telah dikunci secara otomatis." :
                                            "Segera jauhkan layar setidaknya sejauh rentangan siku (± 40cm). Ajak anak istirahat melihat layar (aturan 20-20-20).",
                                            style: AppTextStyles.bodyMedium.copyWith(color: Colors.black87),
                                          ),
                                          const SizedBox(height: 24),
                                          VButton(
                                            onPressed: () => Get.back(),
                                            label: "SAYA PAHAM",
                                            color: AppColors.primary,
                                          ),
                                        ],
                                      ),
                                    ),
                                    isScrollControlled: true,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: bgColor.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: iconColor.withValues(alpha: 0.2)),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              alertText,
                                              style: AppTextStyles.bodyBold.copyWith(fontSize: 13, color: iconColor),
                                            ),
                                            const SizedBox(height: 2),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: iconColor.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                "Jarak: ${distance.toStringAsFixed(1)} cm",
                                                style: AppTextStyles.bodyBold.copyWith(fontSize: 11, color: iconColor),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "Ketuk untuk melihat analisis medis.",
                                              style: AppTextStyles.caption.copyWith(fontSize: 11, color: AppColors.primaryDark.withValues(alpha: 0.6)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        timeAgo,
                                        style: AppTextStyles.caption.copyWith(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );

                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';

class DeveloperTabFeedback extends StatelessWidget {
  final Map<String, dynamic> data;

  const DeveloperTabFeedback({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> feedbacks = data['feedbacks'] ?? [];

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
                  const Icon(Icons.feedback_rounded, size: 32, color: AppColors.primaryDark),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text("UMPAN BALIK PENGGUNA", style: AppTextStyles.heading2),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Feedback dari pengguna untuk bahan pertimbangan update aplikasi di masa mendatang.",
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey),
              ),
            ],
          ),
        ),
        Expanded(
          child: feedbacks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.inbox_rounded, size: 64, color: AppColors.grey),
                      const SizedBox(height: 16),
                      Text("Belum ada feedback dari pengguna.", style: AppTextStyles.bodyBold.copyWith(color: AppColors.grey)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  itemCount: feedbacks.length,
                  itemBuilder: (context, index) {
                    final fb = feedbacks[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(fb['user_name'] ?? 'Anonim', style: AppTextStyles.bodyBold),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppColors.primaryDark, width: 2),
                                ),
                                child: Text(
                                  fb['category'] ?? 'General',
                                  style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(fb['message'] ?? '-', style: AppTextStyles.bodyMedium),
                          if (fb['created_at'] != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              fb['created_at'].toString().split('T').first,
                              style: AppTextStyles.caption.copyWith(color: AppColors.grey),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

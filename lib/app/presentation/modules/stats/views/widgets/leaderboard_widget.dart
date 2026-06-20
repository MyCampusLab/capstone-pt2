import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_card.dart';
import 'package:visionsafe/app/presentation/modules/stats/controllers/stats_controller.dart';

class LeaderboardWidget extends StatelessWidget {
  final StatsController controller;
  const LeaderboardWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.leaderboard.isEmpty) {
        return const SizedBox.shrink();
      }

      return VCard(
        color: Colors.white,
        padding: 20.0, // Fixed to double
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "TOP GUARDIANS",
                  style: AppTextStyles.bodyBold.copyWith(
                    color: AppColors.primaryDark,
                    letterSpacing: 1.2,
                    fontSize: 12,
                  ),
                ),
                const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 20),
              ],
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.leaderboard.length,
              separatorBuilder: (context, index) => Divider(
                color: AppColors.primaryDark.withAlpha(20),
                height: 1,
              ),
              itemBuilder: (context, index) {
                final user = controller.leaderboard[index];
                final isTop3 = index < 3;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        alignment: Alignment.center,
                        child: Text(
                          "${index + 1}",
                          style: AppTextStyles.bodyBold.copyWith(
                            color: isTop3 ? AppColors.secondary : AppColors.primaryDark.withAlpha(100),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primary.withAlpha(50),
                        backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
                        onBackgroundImageError: user.avatarUrl != null ? (e, s) {} : null,
                        child: user.avatarUrl == null
                            ? Text(
                                user.fullName != null && user.fullName!.isNotEmpty
                                    ? user.fullName!.substring(0, 1).toUpperCase()
                                    : "V",
                                style: AppTextStyles.bodyBold.copyWith(fontSize: 12),
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.fullName ?? "Vision Guardian",
                              style: AppTextStyles.bodyBold.copyWith(fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "Level ${user.level}",
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.primaryDark.withAlpha(150),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${user.xp}",
                            style: AppTextStyles.bodyBold.copyWith(
                              color: AppColors.secondary,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "XP",
                            style: AppTextStyles.caption.copyWith(fontSize: 9),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}

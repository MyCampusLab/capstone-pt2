import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/data/services/news_service.dart';

class EyeCareNewsCard extends StatelessWidget {
  final NewsModel news;

  const EyeCareNewsCard({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    final dateStr = "${news.publishedAt.day}/${news.publishedAt.month}/${news.publishedAt.year}";

    // Dynamic color coding for visual excellence & premium layout mapping
    Color badgeColor;
    Color badgeTextColor;
    switch (news.category) {
      case 'Mata':
        badgeColor = const Color(0xFF00D2FF).withValues(alpha: 0.08);
        badgeTextColor = const Color(0xFF00A2C2);
        break;
      case 'Postur':
        badgeColor = const Color(0xFF9D50BB).withValues(alpha: 0.08);
        badgeTextColor = const Color(0xFF823A9E);
        break;
      case 'Layar':
        badgeColor = Colors.orange.withValues(alpha: 0.08);
        badgeTextColor = Colors.orange.shade800;
        break;
      case 'Tidur':
        badgeColor = Colors.indigo.withValues(alpha: 0.08);
        badgeTextColor = Colors.indigo.shade700;
        break;
      case 'BIG DATA':
        badgeColor = const Color(0xFFFF3366).withValues(alpha: 0.1); // Pinkish Red for Big Data
        badgeTextColor = const Color(0xFFD80032);
        break;
      case 'TIPS HERO':
        badgeColor = const Color(0xFFFFD700).withValues(alpha: 0.15); // Gold for Hero Tips
        badgeTextColor = const Color(0xFFB8860B);
        break;
      default:
        badgeColor = Colors.teal.withValues(alpha: 0.08);
        badgeTextColor = Colors.teal.shade700;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryDark.withValues(alpha: 0.06),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.02),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Get.toNamed('/news-detail', arguments: news),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          news.category.toUpperCase(),
                          style: TextStyle(
                            color: badgeTextColor,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      flex: 2,
                      child: Text(
                        "${news.sourceName} • $dateStr",
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryDark.withValues(alpha: 0.5),
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        news.title,
                        style: AppTextStyles.bodyBold.copyWith(
                          fontSize: 15,
                          color: AppColors.primaryDark,
                          height: 1.35,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  news.description,
                  style: AppTextStyles.caption.copyWith(
                    height: 1.5,
                    fontSize: 12,
                    color: AppColors.primaryDark.withValues(alpha: 0.65),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Container(
                  height: 1,
                  color: AppColors.primaryDark.withValues(alpha: 0.04),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.chrome_reader_mode_outlined,
                          size: 13,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "BACA ARTIKEL",
                          style: AppTextStyles.bodyBold.copyWith(
                            fontSize: 9.5,
                            color: AppColors.primary,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${news.readingTimeMinutes} mnt baca",
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryDark.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

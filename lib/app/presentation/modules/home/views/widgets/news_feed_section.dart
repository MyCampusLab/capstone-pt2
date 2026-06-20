import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/data/services/news_service.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/eye_care_news_card.dart';
import 'package:visionsafe/app/routes/app_pages.dart';

class NewsFeedSection extends StatelessWidget {
  final NewsService newsService;

  const NewsFeedSection({super.key, required this.newsService});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNewsHeader(),
        const SizedBox(height: 8),
        _buildNewsList(newsService),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.caption.copyWith(
        fontSize: 11,
        color: AppColors.primaryDark,
        fontWeight: FontWeight.w900,
        letterSpacing: 2.0,
      ),
    );
  }

  Widget _buildNewsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionTitle("BERITA KESEHATAN"),
        TextButton(
          onPressed: () => Get.toNamed(Routes.news),
          child: Text(
            "LIHAT SEMUA",
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewsList(NewsService newsService) {
    return Obx(() {
      if (newsService.isLoading.value && newsService.newsList.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      
      if (newsService.newsList.isEmpty) {
        return const SizedBox(
          height: 150,
          child: Center(child: Text("Tidak ada berita tersedia")),
        );
      }
      
      return Column(
        children: newsService.newsList.take(3).map((news) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: EyeCareNewsCard(news: news),
        )).toList(),
      );
    });
  }
}

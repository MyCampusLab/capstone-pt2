import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/data/models/news_model.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_news_mascot.dart';

class NewsDetailView extends StatelessWidget {
  const NewsDetailView({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        Get.snackbar(
          "Gagal",
          "Tidak dapat membuka tautan artikel asli.",
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
        );
      }
    } catch (_) {
      Get.snackbar("Gagal", "Format tautan salah.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final NewsModel? news = Get.arguments as NewsModel?;

    if (news == null) {
      return Scaffold(
        appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
        body: const Center(child: Text("Artikel tidak ditemukan")),
      );
    }

    final dateStr = "${news.publishedAt.day}/${news.publishedAt.month}/${news.publishedAt.year}";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primaryDark, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          news.category.toUpperCase(),
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: AppColors.primary,
            fontSize: 10.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                news.title,
                style: AppTextStyles.heading2.copyWith(
                  fontSize: 21,
                  color: AppColors.primaryDark,
                  height: 1.35,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primaryDark.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        news.sourceName,
                        style: AppTextStyles.bodyBold.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryDark,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    flex: 2,
                    child: Text(
                       "$dateStr • ${news.readingTimeMinutes} mnt baca",
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryDark.withValues(alpha: 0.5),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildVizoInsightCard(news),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primaryDark.withValues(alpha: 0.04),
                    width: 1,
                  ),
                ),
                child: news.description.trim().isEmpty
                    ? Column(
                        children: [
                          Icon(Icons.article_outlined, size: 48, color: AppColors.primaryDark.withValues(alpha: 0.2)),
                          const SizedBox(height: 12),
                          Text(
                            "Teks artikel ini tidak tersedia dalam ringkasan Big Data kami. Silakan klik tombol verifikasi di bawah untuk membaca isi selengkapnya langsung dari sumber medis aslinya.",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 14,
                              height: 1.6,
                              color: AppColors.primaryDark.withValues(alpha: 0.6),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        news.description,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 14.5,
                          height: 1.75,
                          color: AppColors.primaryDark.withValues(alpha: 0.85),
                          letterSpacing: 0.25,
                        ),
                      ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _launchUrl(news.url),
                  icon: const Icon(Icons.open_in_browser_rounded, size: 18),
                  label: const Text(
                    "VERIFIKASI SUMBER MEDIS",
                    style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.8, fontSize: 13),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: AppColors.primaryDark, width: 2),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVizoInsightCard(NewsModel news) {
    String insightText = "Vizo siap menemani perjalanan sehat matamu hari ini!";
    if (news.mascotState == VizoState.worried) {
      insightText = "Vizo khawatir dengan topik ini. Ayo istirahatkan matamu sejenak!";
    } else if (news.mascotState == VizoState.exercise) {
      insightText = "Vizo mengajakmu meregangkan mata dan melakukan senam mata sekarang!";
    } else if (news.mascotState == VizoState.focused) {
      insightText = "Artikel bagus untuk membantumu tetap fokus dan produktif dengan sehat!";
    } else if (news.mascotState == VizoState.happy) {
      insightText = "Postur tegak dan ergonomi yang baik akan menjaga matamu tetap bugar!";
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15), width: 1.5),
      ),
      child: Row(
        children: [
          VizoNewsMascot(size: 40, state: news.mascotState),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              insightText,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.bold,
                fontSize: 11.5,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

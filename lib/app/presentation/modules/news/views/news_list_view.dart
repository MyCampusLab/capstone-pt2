import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/core/values/app_design.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/eye_care_news_card.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_shimmer.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_empty_state.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import 'package:visionsafe/app/presentation/modules/news/views/global_analytics_view.dart';
import '../controllers/news_controller.dart';

class NewsListView extends GetView<NewsController> {
  const NewsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'KABAR VISIONSAFE',
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.primaryDark,
            letterSpacing: 1.2,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primaryDark, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.pie_chart_rounded, color: AppColors.primary),
            tooltip: "Analitik Big Data",
            onPressed: () => Get.to(() => const GlobalAnalyticsView()),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Offline Mode warning banner
            Obx(() {
              if (controller.newsService.isOffline.value) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.withValues(alpha: 0.3), width: 1),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off_rounded, size: 16, color: Colors.amber),
                      const SizedBox(width: 8),
                      Text(
                        "Mode Offline: Menampilkan berita dari cache.",
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primaryDark,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            // 2. Horizontal Scrolling Category Chips
            _buildCategorySelector(),

            // 3. Main content with pull-to-refresh & list/shimmers
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refreshContent,
                color: AppColors.primary,
                backgroundColor: Colors.white,
                child: Obx(() {
                  final list = controller.displayedArticles;
                  final isLoading = controller.newsService.isLoading.value;

                  if (isLoading && list.isEmpty) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Column(
                        children: List.generate(4, (index) => const Padding(
                          padding: EdgeInsets.only(bottom: AppDesign.spaceM),
                          child: VShimmer(width: double.infinity, height: 110),
                        )),
                      ),
                    );
                  }

                  if (list.isEmpty) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: Get.height * 0.65,
                        child: const Center(
                          child: VEmptyState(
                            title: "Tidak Ada Berita",
                            description: "Kategori ini kosong atau Vizo belum menemukan artikel baru. Tarik layar untuk memuat ulang!",
                            mascotState: VizoState.sleeping,
                            useNewsMascot: true,
                          ),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: controller.scrollController,
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 80),
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    itemCount: list.length + (controller.hasMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < list.length) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppDesign.spaceM),
                          child: EyeCareNewsCard(news: list[index]),
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      height: 48,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final cat = controller.categories[index];
          return Obx(() {
            final isSelected = controller.selectedCategory.value == cat;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(
                  cat,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.primaryDark.withValues(alpha: 0.7),
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) controller.selectedCategory.value = cat;
                },
                selectedColor: AppColors.primary,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.primaryDark.withValues(alpha: 0.08),
                    width: 1.5,
                  ),
                ),
                elevation: 0,
                pressElevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            );
          });
        },
      ),
    );
  }
}

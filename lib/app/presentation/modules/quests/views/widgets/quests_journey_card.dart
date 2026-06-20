import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/modules/quests/controllers/quests_controller.dart';
import 'package:visionsafe/app/data/services/reward_service.dart';
import 'quest_task_tile.dart';
import 'sticker_grid_item.dart';
import 'hero_showcase_dialog.dart';

class QuestsJourneyCard extends StatelessWidget {
  const QuestsJourneyCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QuestsController>();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: AppColors.primaryDark, width: 3),
        boxShadow: const [BoxShadow(color: AppColors.primaryDark, offset: Offset(8, 8))],
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          _buildSpecialQuest(controller),
          _buildDivider(),
          _buildDailyQuests(controller),
          _buildDivider(),
          _buildHeroCollection(controller),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Divider(
        height: 1, 
        indent: 40, 
        endIndent: 40, 
        thickness: 2, 
        color: AppColors.primaryDark.withAlpha(20),
      ),
    );
  }

  Widget _buildSpecialQuest(QuestsController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("SPECIAL MISSION", 
            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w900, color: AppColors.secondary)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.secondary.withAlpha(15),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.secondary.withAlpha(40), width: 2),
            ),
            child: Obx(() {
              final questData = Map<String, dynamic>.from(controller.specialQuest);
              return QuestTaskTile(
                quest: questData,
                isLast: true,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyQuests(QuestsController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("DAILY QUESTS", 
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w900, 
              color: AppColors.primaryDark.withAlpha(150),
            )),
          const SizedBox(height: 16),
          Obx(() {
            final questList = controller.quests.toList();
            if (questList.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text("All quests completed, Hero!", style: AppTextStyles.caption),
                ),
              );
            }
            return Column(
              children: List.generate(questList.length, (index) {
                return QuestTaskTile(
                  quest: questList[index],
                  isLast: index == questList.length - 1,
                );
              }),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHeroCollection(QuestsController controller) {
    final rewardService = Get.find<RewardService>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("KOLEKSI HERO", 
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w900, 
              color: AppColors.primaryDark.withAlpha(150),
            )),
          const SizedBox(height: 16),
          Obx(() {
            final heroesList = controller.heroes.toList();
            final int heroCount = heroesList.length;
            return LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = (constraints.maxWidth - 36) / 4;
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.start,
                  children: List.generate(8, (index) {
                    final hero = index < heroCount ? heroesList[index] : null;
                    return SizedBox(
                      width: itemWidth,
                      child: StickerGridItem(
                        sticker: hero,
                        onTap: hero == null ? null : () {
                          if (!hero.isUnlocked) {
                            final price = rewardService.getStickerPrice(hero.id);
                            HeroShowcaseDialog.show(
                              sticker: hero,
                              isPurchase: true,
                              price: price,
                              onConfirm: () => controller.purchaseHero(hero.id),
                            );
                          } else {
                            if (hero.isEquipped) {
                              HeroShowcaseDialog.show(
                                sticker: hero,
                                onConfirm: () {},
                              );
                            } else {
                              HeroShowcaseDialog.show(
                                sticker: hero,
                                onConfirm: () {
                                  rewardService.equipSticker(hero.id);
                                  controller.refreshQuestData();
                                },
                              );
                            }
                          }
                        },
                      ),
                    );
                  }),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}

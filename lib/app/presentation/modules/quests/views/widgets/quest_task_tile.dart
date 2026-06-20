import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import '../../controllers/quests_controller.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_button.dart';

/// Tile tugas pada Quest Map (Compact Vertical Edition).
class QuestTaskTile extends GetView<QuestsController> {
  final Map<String, dynamic> quest;
  final bool isLast;

  const QuestTaskTile({super.key, required this.quest, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    final status = quest['status'] as String? ?? 'active';
    final id = quest['id'] as String;
    final isLocked = status == 'locked';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildStatusIcon(isLocked, false),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quest['title'] ?? '',
                      style: AppTextStyles.bodyBold.copyWith(
                        color: isLocked ? const Color(0xFF9E9E9E) : const Color(0xFF003366),
                        fontSize: 15,
                        height: 1.2,
                      ),
                    ),
                  Obx(() {
                      final progress = controller.getQuestProgress(id);
                      final isClaimed = controller.isQuestClaimedToday(id);
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          if (quest['type'] != 'action')
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: Colors.grey.shade200,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isClaimed ? Colors.green : (progress >= 1.0 ? Colors.orange : AppColors.primary),
                                  ),
                                  minHeight: 6,
                                ),
                              ),
                            ),
                          Text(
                            isClaimed ? "SELESAI HARI INI!" : (progress >= 1.0 ? "SIAP DIKLAIM!" : (quest['subtitle'] ?? '')),
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isClaimed ? Colors.green : (progress >= 1.0 ? Colors.orange.shade700 : AppColors.grey),
                              height: 1.2,
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              if (!isLocked)
                Obx(() {
                  final progress = controller.getQuestProgress(id);
                  final isClaimed = controller.isQuestClaimedToday(id);
                  
                  if (isClaimed) {
                    return const Icon(Icons.check_circle_rounded, color: Colors.green, size: 28);
                  } else if (progress >= 1.0) {
                    return _buildClaimButton(id);
                  }
                  return _buildStartButton();
                }),
            ],
          ),
          if (!isLast) _buildStepLine(),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(bool isLocked, bool isCompleted) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: isLocked ? Colors.grey.shade200 : (isCompleted ? Colors.blue.shade100 : Colors.orange.shade100),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF003366), width: 2),
      ),
      child: Icon(
        quest['icon'] as IconData? ?? Icons.task_alt_rounded,
        color: isLocked ? Colors.grey : (isCompleted ? Colors.blue.shade800 : Colors.orange.shade800),
        size: 20,
      ),
    );
  }
  
  Widget _buildClaimButton(String id) {
    return SizedBox(
      height: 32,
      width: 80,
      child: VButton(
        onPressed: () {
          // Use default reward logic based on quest ID
          int reward = 100;
          if (id == 'q1') reward = 200;
          if (id == 'q3') reward = 500;
          if (id == 'sq1') reward = 150;
          controller.claimQuestReward(id, reward);
        },
        label: "KLAIM!",
        color: Colors.orange.shade500,
      ),
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      height: 32,
      width: 80,
      child: VButton(
        onPressed: () => controller.startTask(quest['id']),
        label: "START",
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildStepLine() {
    return Container(
      margin: const EdgeInsets.only(left: 22),
      alignment: Alignment.centerLeft,
      child: Container(
        width: 2,
        height: 20,
        color: Colors.grey.shade300,
      ),
    );
  }
}

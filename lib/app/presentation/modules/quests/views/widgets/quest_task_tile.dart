import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import '../../controllers/quests_controller.dart';

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
                      ),
                    ),
                    Obx(() {
                      final progress = controller.getQuestProgress(id);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                progress >= 1.0 ? Colors.green : AppColors.primary,
                              ),
                              minHeight: 6,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            progress >= 1.0 ? "GOAL REACHED!" : (quest['subtitle'] ?? ''),
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: progress >= 1.0 ? Colors.green : AppColors.grey,
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              if (!isLocked)
                Obx(() {
                  final progress = controller.getQuestProgress(id);
                  if (progress >= 1.0) {
                    return const Icon(Icons.check_circle_rounded, color: Colors.green, size: 28);
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

  Widget _buildStartButton() {
    return SizedBox(
      height: 32,
      width: 80, // Fixed width for uniform alignment
      child: ElevatedButton(
        onPressed: () => controller.startTask(quest['id']),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: const Text("START", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
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

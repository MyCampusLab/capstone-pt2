import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/templates/base_screen_template.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_app_header.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_button.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_card.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_dialog.dart';
import '../controllers/family_controller.dart';
import 'package:visionsafe/app/routes/app_pages.dart';
import 'package:flutter/services.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_skeleton.dart';

class FamilyView extends GetView<FamilyController> {
  const FamilyView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreenTemplate(
      appBar: VAppHeader(
        title: "SQUAD LEADERBOARD",
        showBackButton: true,
      ),
      bottomPadding: 32,
      child: Obx(() {
        if (controller.isLoading.value && controller.myGroups.isEmpty) {
          return Column(
            children: const [
              VSkeleton(height: 100),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: VSkeleton(height: 50)),
                  SizedBox(width: 12),
                  Expanded(child: VSkeleton(height: 50)),
                ],
              ),
              SizedBox(height: 32),
              VSkeleton(height: 200),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroBanner(),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: VButton(
                    label: "BUAT GRUP",
                    icon: Icons.add_circle_outline_rounded,
                    onPressed: _showCreateGroupDialog,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: VButton(
                    onPressed: _showJoinGroupDialog,
                    icon: Icons.group_add_rounded,
                    label: "GABUNG",
                    color: AppColors.primaryDark,
                    isOutline: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              "GRUP SAYA",
              style: AppTextStyles.caption.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryDark,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            if (controller.myGroups.isEmpty)
              _buildEmptyState()
            else
              ...controller.myGroups.map((g) => _buildGroupCard(g)),
          ],
        );
      }),
    );
  }

  Widget _buildHeroBanner() {
    return VCard(
      padding: 20,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.hub_rounded, size: 32, color: AppColors.secondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pantau Bersama",
                  style: AppTextStyles.heading2.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  "Undang keluarga atau temanmu ke dalam squad untuk saling memantau kesehatan mata.",
                  style: AppTextStyles.caption.copyWith(color: AppColors.primaryDark.withValues(alpha: 0.7)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryDark.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        children: [
          Icon(Icons.group_off_rounded, size: 48, color: AppColors.primaryDark.withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          Text(
            "Kamu belum bergabung ke grup manapun.",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryDark.withValues(alpha: 0.6)),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(Map<String, dynamic> group) {
    final groupId = group['id'];
    final members = controller.groupMembers[groupId] ?? [];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: VCard(
        padding: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    group['name'].toString().toUpperCase(),
                    style: AppTextStyles.heading2.copyWith(fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Clipboard.setData(ClipboardData(text: group['invite_code']));
                      Get.snackbar("Disalin", "Invite Code ${group['invite_code']} disalin ke clipboard!");
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        children: [
                          Text(
                            group['invite_code'],
                            style: AppTextStyles.bodyBold.copyWith(color: AppColors.primary, fontSize: 12),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.copy_rounded, size: 14, color: AppColors.primary),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.primaryDark, thickness: 1),
            ...members.asMap().entries.map((entry) => _buildMemberTile(entry.value, entry.key)),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberTile(Map<String, dynamic> member, int index) {
    final profile = member['profiles'];
    if (profile == null) return const SizedBox.shrink();

    final isMe = profile['id'] == controller.currentUserId;
    final role = member['role'] ?? 'member';
    final xp = profile['xp'] ?? 0;

    // Leaderboard Ranking Logic
    Widget rankIcon;
    if (index == 0) {
      rankIcon = const Icon(Icons.workspace_premium_rounded, color: Color(0xFFFFD700), size: 32); // Gold
    } else if (index == 1) {
      rankIcon = const Icon(Icons.workspace_premium_rounded, color: Color(0xFFC0C0C0), size: 32); // Silver
    } else if (index == 2) {
      rankIcon = const Icon(Icons.workspace_premium_rounded, color: Color(0xFFCD7F32), size: 32); // Bronze
    } else {
      rankIcon = CircleAvatar(
        backgroundColor: AppColors.primaryDark.withValues(alpha: 0.1),
        radius: 14,
        child: Text(
          "${index + 1}",
          style: AppTextStyles.bodyBold.copyWith(color: AppColors.primaryDark, fontSize: 12),
        ),
      );
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: rankIcon,
      title: Row(
        children: [
          Expanded(
            child: Text(
              profile['full_name'] ?? 'Unknown Hero',
              style: AppTextStyles.bodyBold.copyWith(
                fontSize: 14, 
                color: isMe ? AppColors.primaryDark : AppColors.primaryDark.withValues(alpha: 0.8),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text("SAYA", style: AppTextStyles.caption.copyWith(fontSize: 9, color: AppColors.secondary, fontWeight: FontWeight.bold)),
            ),
          ],
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          "$xp XP • Level ${profile['level'] ?? 1} • ${(role as String).toUpperCase()}",
          style: AppTextStyles.caption.copyWith(
            color: index == 0 ? AppColors.primary : AppColors.primaryDark.withValues(alpha: 0.6),
            fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
      trailing: isMe 
          ? const SizedBox.shrink()
          : IconButton(
              icon: const Icon(Icons.analytics_outlined, color: AppColors.primary),
              onPressed: () {
                HapticFeedback.mediumImpact();
                // MASUK KE SUPERVISOR MODE
                // Buka StatsView milik anak/teman ini.
                Get.toNamed(Routes.stats, arguments: {'targetUserId': profile['id'], 'targetName': profile['full_name']});
              },
            ),
    );
  }

  void _showCreateGroupDialog() {
    final nameController = TextEditingController();
    VDialog.show(
      title: "BUAT GRUP BARU",
      icon: Icons.group_add_rounded,
      content: TextField(
        controller: nameController,
        decoration: InputDecoration(
          hintText: "Nama Grup (Contoh: Keluarga Budi)",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      confirmLabel: "BUAT",
      cancelLabel: "BATAL",
      onConfirm: () => controller.createGroup(nameController.text),
    );
  }

  void _showJoinGroupDialog() {
    final codeController = TextEditingController();
    VDialog.show(
      title: "GABUNG GRUP",
      icon: Icons.login_rounded,
      content: TextField(
        controller: codeController,
        textCapitalization: TextCapitalization.characters,
        decoration: InputDecoration(
          hintText: "Masukkan Invite Code (cth: VZ-A1B2C)",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      confirmLabel: "GABUNG",
      cancelLabel: "BATAL",
      onConfirm: () => controller.joinGroup(codeController.text),
    );
  }
}

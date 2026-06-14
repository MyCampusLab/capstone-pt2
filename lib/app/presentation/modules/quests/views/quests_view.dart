import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/quests_controller.dart';
import 'widgets/quests_header.dart';
import 'widgets/quests_journey_card.dart';
import 'package:visionsafe/app/presentation/global_widgets/templates/base_screen_template.dart';

import 'package:visionsafe/app/presentation/global_widgets/molecules/v_app_header.dart';

/// QuestsView: Gabungan Quests dan Koleksi Hero (Hero Journey).
/// Desain Premium: Bebas overflow, padat, dan mengikuti tema Retro-Glass.
/// File size strictly < 200 lines.
class QuestsView extends GetView<QuestsController> {
  const QuestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreenTemplate(
      appBar: const VAppHeader(title: 'HERO JOURNEY'),
      bottomPadding: 180,
      onRefresh: controller.refreshQuestData,
      child: Obx(() => Column(
        children: [
          const QuestsHeader(),
          const SizedBox(height: 24),
          if (controller.isLoading.value)
            const Center(child: CircularProgressIndicator())
          else
            const QuestsJourneyCard(),
        ],
      )),
    );
  }
}

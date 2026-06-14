import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/presentation/modules/main_wrapper/controllers/main_wrapper_controller.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_bottom_nav.dart';
import 'package:visionsafe/app/presentation/modules/home/views/home_view.dart';
import 'package:visionsafe/app/presentation/modules/stats/views/stats_view.dart';
import 'package:visionsafe/app/presentation/modules/quests/views/quests_view.dart';
import 'package:visionsafe/app/presentation/modules/settings/views/settings_view.dart';

/// MainWrapperView: Container utama untuk navigasi antar menu (Zero-Scroll & Compact).
/// Urutan: BUDDY (Tab 1), STATS (Tab 2), QUESTS (Tab 3).
class MainWrapperView extends GetView<MainWrapperController> {
  const MainWrapperView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeView(),    // BUDDY
      const StatsView(),   // STATS
      const QuestsView(),  // QUESTS 
      const SettingsView(), // SETTINGS
    ];

    return Scaffold(
      body: Stack(
        children: [
          Obx(() => IndexedStack(
                index: controller.currentIndex.value,
                children: pages,
              )),
          const VBottomNav(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/routes/app_pages.dart';
import 'package:visionsafe/app/data/services/config_service.dart';

import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';

/// OnboardingController: Logika navigasi slide onboarding.
class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;
  final _configService = Get.find<ConfigService>();

  final List<Map<String, dynamic>> pages = [
    {
      'title': 'HALO! AKU VIZO',
      'desc': 'Aku akan jadi sahabatmu untuk menjaga mata tetap sehat dan kuat!',
      'state': VizoState.idle,
    },
    {
      'title': 'JAGA JARAKMU',
      'desc': 'Jangan terlalu dekat ya! Vizo akan kasih tahu kalau kamu keasyikan main HP.',
      'state': VizoState.worried,
    },
    {
      'title': 'SIAP BERPETUALANG?',
      'desc': 'Ayo aktifkan penjagaan Vizo dan kumpulkan Koleksi Hero keren setiap harinya!',
      'state': VizoState.exercise,
    },
  ];

  bool get isLastPage => currentPage.value == pages.length - 1;

  void updatePageIndex(int index) => currentPage.value = index;

  void nextPage() {
    if (isLastPage) {
      _configService.completeOnboarding();
      Get.offAllNamed(Routes.login);
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

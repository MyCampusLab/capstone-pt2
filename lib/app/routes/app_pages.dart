import 'package:get/get.dart';

import '../presentation/modules/home/bindings/home_binding.dart';
import '../presentation/modules/home/views/home_view.dart';
import '../presentation/modules/onboarding/bindings/onboarding_binding.dart';
import '../presentation/modules/onboarding/views/onboarding_view.dart';
import '../presentation/modules/auth/bindings/auth_binding.dart';
import '../presentation/modules/auth/views/login_view.dart';
import '../presentation/modules/auth/views/register_view.dart';
import '../presentation/modules/intervention/views/intervention_view.dart';
import '../presentation/modules/calibration/views/calibration_view.dart';
import '../presentation/modules/calibration/bindings/calibration_binding.dart';

import '../presentation/modules/main_wrapper/views/main_wrapper_view.dart';
import '../presentation/modules/main_wrapper/bindings/main_wrapper_binding.dart';
import '../presentation/modules/play/views/eye_exercise_view.dart';
import '../presentation/modules/play/bindings/eye_exercise_binding.dart';
import '../presentation/modules/settings/views/settings_view.dart';
import '../presentation/modules/quests/views/quests_view.dart';
import '../presentation/modules/quests/bindings/quests_binding.dart';
import '../presentation/modules/stats/bindings/stats_binding.dart';
import '../presentation/modules/play/bindings/play_binding.dart';

import '../presentation/modules/splash/views/splash_view.dart';
import '../presentation/modules/news/views/news_list_view.dart';
import '../presentation/modules/news/views/news_detail_view.dart';
import '../presentation/modules/news/bindings/news_binding.dart';
import '../presentation/modules/auth/views/waiting_verification_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;
  static const newsDetail = _Paths.newsDetail;
  static const waitingVerification = _Paths.waitingVerification;

  static final routes = [
    GetPage(
      name: _Paths.splash,
      page: () => const SplashView(),
    ),
    GetPage(
      name: _Paths.mainWrapper, 
      page: () => const MainWrapperView(), 
      bindings: [
        MainWrapperBinding(),
        HomeBinding(),
        StatsBinding(),
        QuestsBinding(),
        PlayBinding(),
      ],
    ),
    GetPage(
      name: _Paths.home, 
      page: () => const HomeView(), 
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.onboarding, 
      page: () => const OnboardingView(), 
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.login, 
      page: () => const LoginView(), 
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.register, 
      page: () => const RegisterView(), 
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.intervention, 
      page: () => const InterventionView(),
    ),
    GetPage(
      name: _Paths.calibration, 
      page: () => const CalibrationView(), 
      binding: CalibrationBinding(),
    ),
    GetPage(
      name: _Paths.settings, 
      page: () => const SettingsView(),
    ),
    GetPage(
      name: _Paths.eyeExercise, 
      page: () => const EyeExerciseView(), 
      binding: EyeExerciseBinding(),
    ),
    GetPage(
      name: _Paths.quests,
      page: () => const QuestsView(),
      binding: QuestsBinding(),
    ),
    GetPage(
      name: _Paths.news,
      page: () => const NewsListView(),
      binding: NewsBinding(),
    ),
    GetPage(
      name: _Paths.newsDetail,
      page: () => const NewsDetailView(),
    ),
    GetPage(
      name: _Paths.waitingVerification,
      page: () => const WaitingVerificationView(),
    ),
  ];
}


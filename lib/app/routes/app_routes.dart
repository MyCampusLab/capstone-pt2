part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const splash = _Paths.splash;
  static const home = _Paths.home;
  static const mainWrapper = _Paths.mainWrapper;
  static const onboarding = _Paths.onboarding;
  static const login = _Paths.login;
  static const register = _Paths.register;
  static const calibration = _Paths.calibration;
  static const settings = _Paths.settings;
  static const eyeExercise = _Paths.eyeExercise;
  static const quests = _Paths.quests;
  static const news = _Paths.news;
  static const newsDetail = _Paths.newsDetail;
  static const waitingVerification = _Paths.waitingVerification;
  static const healthQuiz = _Paths.healthQuiz;
  static const family = _Paths.family;
  static const stats = _Paths.stats;
}

abstract class _Paths {
  _Paths._();
  static const splash = '/splash';
  static const home = '/home';
  static const mainWrapper = '/main-wrapper';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const calibration = '/calibration';
  static const settings = '/settings';
  static const eyeExercise = '/eye-exercise';
  static const quests = '/quests';
  static const news = '/news';
  static const newsDetail = '/news-detail';
  static const waitingVerification = '/waiting-verification';
  static const healthQuiz = '/health-quiz';
  static const family = '/family';
  static const stats = '/stats';
}

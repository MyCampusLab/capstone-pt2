import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/routes/app_pages.dart';

class PlayController extends GetxController {
  final games = <Map<String, dynamic>>[
    {
      'title': 'Senam Mata',
      'icon': Icons.visibility_rounded,
      'color': AppColors.primary,
      'route': Routes.eyeExercise,
    },
    {
      'title': 'Kuis Sehat',
      'icon': Icons.quiz,
      'color': AppColors.secondary,
      'route': null,
    },
    {
      'title': 'Cari Vizo',
      'icon': Icons.search,
      'color': Colors.orange,
      'route': null,
    },
    {
      'title': 'Tips Seru',
      'icon': Icons.lightbulb,
      'color': Colors.purple,
      'route': null,
    },
  ].obs;
}

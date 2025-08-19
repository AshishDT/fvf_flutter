import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:get/get.dart';

/// Profile Controller
class ProfileController extends GetxController {

  @override
  void onInit() {
    super.onInit();
  }

  /// highlightCards
  final List<Map<String, dynamic>> highlightCards = <Map<String, dynamic>>[
    <String, dynamic>{
      'title': 'Most likely to start an OF?',
      'subtitle': 'That no-nonsense stare made it obvious',
      'backgroundColor': AppColors.k13C4E5,
      'borderColor': AppColors.kF6FCFE,
      'avatarUrl': '',
    },
    <String, dynamic>{
      'title': 'Will become president?',
      'subtitle': 'All of the indications of a girl that knows how to lie',
      'backgroundColor': AppColors.kFF5F7F,
      'borderColor': AppColors.kF6FCFE,
      'avatarUrl': '',
    },
    <String, dynamic>{
      'title': 'Most serious?',
      'subtitle': 'She’s never heard of smiling',
      'backgroundColor': AppColors.kFFC300,
      'borderColor': AppColors.kF6FCFE,
      'avatarUrl': '',
    },
    <String, dynamic>{
      'title': 'Is the best at XYZ?',
      'subtitle': 'The reason why she won goes here!',
      'backgroundColor': AppColors.kEE4AD1,
      'borderColor': AppColors.kF6FCFE,
      'avatarUrl': '',
    },
  ];
}

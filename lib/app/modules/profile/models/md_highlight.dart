import 'dart:math';
import 'package:flutter/material.dart';

import '../../../data/config/app_colors.dart' show AppColors;

/// Highlight model for profile cards
class MdHighlight {
  /// Constructor for MdHighlight
  MdHighlight({
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.borderColor,
    required this.avatarUrl,
  });

  /// Factory constructor with random colors
  factory MdHighlight.random({
    required String title,
    required String subtitle,
    String avatarUrl = '',
  }) {
    final Random random = Random();

    final List<Color> bgColors = <Color>[
      AppColors.k13C4E5,
      AppColors.kFF5F7F,
      AppColors.kFFC300,
      AppColors.kEE4AD1,
    ];

    final List<Color> borderColors = <Color>[
      AppColors.kF6FCFE,
    ];

    return MdHighlight(
      title: title,
      subtitle: subtitle,
      backgroundColor: bgColors[random.nextInt(bgColors.length)],
      borderColor: borderColors[random.nextInt(borderColors.length)],
      avatarUrl: avatarUrl,
    );
  }

  /// Title and subtitle for the highlight
  final String title;

  /// Subtitle for the highlight
  final String subtitle;

  /// Background and border colors for the highlight
  final Color backgroundColor;

  /// Border color for the highlight
  final Color borderColor;

  /// Avatar URL for the highlight
  final String avatarUrl;
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// AiChoosingController
class AiChoosingController extends GetxController {

  /// PageController
  late PageController pageController;

  /// Timer
  late Timer timer;

  /// currentPage
  int currentPage = 0;

  /// Images
  final List<String> images = <String>[
    '',
    '',
    '',
  ];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(viewportFraction: 0.55);

    timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (currentPage < images.length - 1) {
        currentPage++;
      } else {
        currentPage = 0;
      }
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    timer.cancel();
    pageController.dispose();
    super.dispose();
  }
}

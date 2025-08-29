import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';

import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

/// Splash  view
class SplashView extends GetView<SplashController> {
  /// Splash view constructor
  SplashView({super.key});

  @override
  final SplashController controller = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.kF5FCFF,
        body: GradientCard(
          child: Center(
            child: Image(
              height: 155.h,
              width: 250.w,
              image: const AssetImage(
                AppImages.appLogo,
              ),
            ),
          ),
        ),
      );
}

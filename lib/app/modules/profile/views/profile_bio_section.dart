import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/config/app_colors.dart';
import '../../../data/config/app_images.dart';
import '../controllers/profile_controller.dart';

/// BIO + NEXT ARROW
class ProfileBioSection extends StatelessWidget {
  /// Constructor
  const ProfileBioSection({
    required this.controller, super.key,
  });

  /// Controller
  final ProfileController controller;

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          Text(
            'This is tom, he is cool. BDE frfr.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              color: AppColors.kffffff,
              fontWeight: FontWeight.w600,
            ),
          ),
          16.verticalSpace,
          IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: 56.w, minHeight: 56.w),
            onPressed: () {
              controller.pageController.jumpToPage(1);
              controller.currentIndex(1);
            },
            icon: Transform.rotate(
              angle: -math.pi / 2,
              child: SvgPicture.asset(AppImages.backwardArrow),
            ),
          ),
          24.verticalSpace,
        ],
      );
}

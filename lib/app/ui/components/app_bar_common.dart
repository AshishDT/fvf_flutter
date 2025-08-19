import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/config/app_colors.dart';

/// Onboarding app bar
class AppBarCommon extends StatelessWidget implements PreferredSizeWidget {
  /// Onboarding app bar constructor
  const AppBarCommon({
    required this.title,
    this.onBack,
    this.actions,
    this.canShowBack = true,
    this.leading,
  });

  /// On back button
  final void Function()? onBack;

  /// Actions
  final List<Widget>? actions;

  /// Can show back button
  final bool canShowBack;

  /// Title
  final String title;

  /// Leading widget
  final Widget? leading;

  @override
  Widget build(BuildContext context) => AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: AppColors.kffffff,
        surfaceTintColor: AppColors.kffffff,
        shadowColor: AppColors.kffffff,
        foregroundColor: AppColors.kffffff,
        elevation: 2,
        leadingWidth: 50.w,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: AppColors.k000000,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: leading != null
            ? leading
            : canShowBack
                ? GestureDetector(
                    onTap: onBack ?? Get.back,
                    child: Icon(
                      Icons.arrow_back,
                      size: 24.h,
                      color: AppColors.k000000,
                    ),
                  )
                : null,
        actions: actions,
      );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

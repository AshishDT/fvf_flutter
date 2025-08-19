import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Common AppBar widget
class CommonAppBar extends StatelessWidget {
  /// Creates a [CommonAppBar] widget.
  const CommonAppBar({
    super.key,
    this.actions,
    this.onBack,
  });

  /// Actions to display in the app bar.
  final List<Widget>? actions;

  /// On Back
  final void Function()? onBack;

  @override
  Widget build(BuildContext context) => Container(
        width: Get.width,
        height: 56.h,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: onBack ?? () => Get.back(),
              child: SvgPicture.asset(
                AppImages.backIcon,
                width: 24.w,
                height: 24.h,
              ),
            ),
            40.horizontalSpace,
            if (actions != null) ...actions!,
          ],
        ),
      );
}

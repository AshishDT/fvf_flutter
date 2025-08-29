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
    this.onTapOfLeading,
    this.leadingIconColor,
    this.leadingIcon,
    this.leadingIconSize,
  });

  /// Actions to display in the app bar.
  final List<Widget>? actions;

  /// On Back
  final void Function()? onTapOfLeading;

  /// leadingIconColor
  final Color? leadingIconColor;

  /// leadingIcon
  final String? leadingIcon;

  /// leadingIconSize
  final double? leadingIconSize;

  @override
  Widget build(BuildContext context) => Container(
        width: Get.width,
        height: 56.h,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: onTapOfLeading ?? () => Get.back(),
              child: SvgPicture.asset(
                leadingIcon ?? AppImages.backIcon,
                width: leadingIconSize ?? 24.w,
                height: leadingIconSize ?? 24.h,
                colorFilter: leadingIconColor != null
                    ? ColorFilter.mode(
                        leadingIconColor!,
                        BlendMode.srcIn,
                      )
                    : null,
              ),
            ),
            40.horizontalSpace,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (actions != null) ...actions!,
              ],
            )
          ],
        ),
      );
}

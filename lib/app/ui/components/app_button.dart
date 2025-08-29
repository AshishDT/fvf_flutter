import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../data/config/app_colors.dart';

/// A customizable elevated button with loading state,
/// disabled state, and smooth animated background color transition.
class AppButton extends StatelessWidget {
  /// Creates a custom button.
  const AppButton({
    required this.buttonText,
    required this.onPressed,
    this.height,
    this.style,
    this.buttonColor,
    this.borderRadius,
    this.isLoading = false,
    this.width,
    this.decoration,
    this.child,
    Key? key,
  }) : super(key: key);

  /// The text to display on the button.
  final String buttonText;

  /// Callback when the button is pressed.
  final void Function() onPressed;

  /// Height of the button (defaults to 56.h).
  final double? height;

  /// Width of the button (defaults to full screen width).
  final double? width;

  /// Optional custom text style.
  final TextStyle? style;

  /// Optional custom background color.
  final Color? buttonColor;

  /// Optional border radius (defaults to 28).
  final BorderRadius? borderRadius;

  /// Whether to show the loading animation.
  final bool isLoading;

  /// Optional decoration for the button.
  final BoxDecoration? decoration;

  /// Child
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final double btnHeight = height ?? 56.h;
    final double btnWidth = width ?? context.width;

    final Color bgColor =
        buttonColor ?? AppColors.k2A2E2F.withValues(alpha: 0.42);

    return GestureDetector(
      onTap: () {
        if (isLoading) {
          return;
        }
        onPressed.call();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        height: btnHeight,
        width: btnWidth,
        decoration: decoration ??
            BoxDecoration(
              color: bgColor,
              borderRadius: borderRadius ?? BorderRadius.circular(28).r,
            ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (!isLoading) ...<Widget>[
                Expanded(
                  child: child ??
                      Center(
                        child: Text(
                          buttonText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: style ??
                              AppTextStyle.openRunde(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.kffffff,
                              ),
                        ),
                      ),
                ),
              ],
              if (isLoading) ...<Widget>[
                15.horizontalSpace,
                Transform.scale(
                  scale: 1.7,
                  child: Lottie.asset(
                    fit: BoxFit.fitWidth,
                    AppImages.buttonLoader,
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}

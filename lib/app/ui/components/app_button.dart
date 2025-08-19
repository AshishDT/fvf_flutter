import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/config/app_colors.dart';

/// A customizable elevated button with loading state,
/// disabled state, and smooth animated background color transition.
class AppButton extends StatelessWidget {
  /// Creates a custom button.
  const AppButton({
    required this.buttonText,
    required this.onPressed,
    this.borderSide,
    this.height,
    this.style,
    this.buttonColor,
    this.borderRadius,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    Key? key,
  }) : super(key: key);

  /// The text to display on the button.
  final String buttonText;

  /// Callback when the button is pressed.
  final void Function() onPressed;

  /// Optional border side for the button.
  final BorderSide? borderSide;

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

  /// Whether the button is enabled.
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final double btnHeight = height ?? 56.h;
    final double btnWidth = width ?? context.width;

    // Determine background color based on state
    final Color bgColor = isLoading
        ? AppColors.k101928
        : isEnabled
        ? buttonColor ?? AppColors.k00A4A6
        : AppColors.k00A4A6;

    return GestureDetector(
      onTap: () {
        if (!isEnabled || isLoading) {
          return;
        }
        onPressed.call();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        height: btnHeight,
        width: btnWidth,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: borderRadius ?? BorderRadius.circular(28).r,
          border: borderSide != null
              ? Border.all(
            color: borderSide!.color,
            width: borderSide!.width,
            style: borderSide!.style,
          )
              : null,
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (!isLoading) ...<Widget>[
                Expanded(
                  child: Center(
                    child: Text(
                      buttonText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: style ??
                          GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.kffffff,
                          ),
                    ),
                  ),
                ),
              ],
              if (isLoading) ...<Widget>[
                15.horizontalSpace,
                const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.k000000,
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

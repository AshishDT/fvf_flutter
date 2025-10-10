import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import '../../data/config/app_colors.dart';
import '../../data/config/logger.dart';

/// Expandable text field widget
class ExpandableTextField extends StatelessWidget {
  /// Constructor
  ExpandableTextField({
    required this.controller,
    super.key,
    this.borderRadius = 28,
    this.hintText,
    this.minHeight = 145,
    this.readOnly = false,
    this.enabled = true,
  });

  /// Expandable text field constructor
  final TextEditingController controller;

  /// Hint text
  final String? hintText;

  /// Border radius
  final double borderRadius;

  /// Minimum height
  final double minHeight;

  /// Read only
  final bool readOnly;

  /// Enabled
  final bool enabled;

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          if (enabled && !readOnly) {
            logWTF('Focus node tapped');
            _focusNode.requestFocus();
          }
        },
        behavior: HitTestBehavior.translucent,
        child: Material(
          color: AppColors.kF1F2F2.withValues(alpha: 0.36),
          borderRadius: BorderRadius.circular(borderRadius),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: minHeight,
            ),
            child: Padding(
              padding: REdgeInsets.symmetric(
                vertical: 16,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: TextFormField(
                  readOnly: readOnly,
                  enabled: enabled,
                  controller: controller,
                  focusNode: _focusNode,
                  style: AppTextStyle.openRunde(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    height: 1.h,
                    letterSpacing: 0,
                    color: AppColors.kF1F2F2,
                  ),
                  maxLines: null,
                  cursorColor: AppColors.kF1F2F2,
                  decoration: InputDecoration.collapsed(
                    hintText: hintText,
                    hintStyle: AppTextStyle.openRunde(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      height: 1.h,
                      letterSpacing: 0,
                      color: AppColors.kF1F2F2,
                    ),
                  ).copyWith(
                    border: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    prefixIconConstraints: BoxConstraints(
                      maxWidth: 100.w,
                      minWidth: 24.w,
                      maxHeight: 24.h,
                      minHeight: 24.h,
                    ),
                    prefixIcon: Padding(
                      padding: REdgeInsets.only(left: 12, bottom: 4),
                      child: SvgPicture.asset(
                        AppImages.penIcon,
                        height: 24.h,
                        width: 24.w,
                        colorFilter: const ColorFilter.mode(
                          AppColors.kF1F2F2,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

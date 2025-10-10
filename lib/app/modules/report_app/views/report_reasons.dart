import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:fvf_flutter/app/utils/app_utils.dart';
import 'package:fvf_flutter/app/utils/widget_ext.dart';
import 'package:get/get.dart';

/// Report Reason List
class ReportReasonList extends StatelessWidget {
  /// Report reason list
  const ReportReasonList({
    required this.reasons,
    required this.selectedReason,
    required this.onSelect,
    super.key,
  });

  /// Report Reason List constructor
  final List<String> reasons;

  /// Selected reason
  final String selectedReason;

  /// On select
  final void Function(String reason) onSelect;

  @override
  Widget build(BuildContext context) => AnimationLimiter(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reasons.length,
          itemBuilder: (BuildContext context, int index) {
            final String reason = reasons[index];

            final bool isSelected = reason == selectedReason;

            return RadioGroup<String>(
              onChanged: (String? value) {
                logWTF('value: $value');
                if (value != null) {
                  onSelect(value);
                }
              },
              groupValue: selectedReason,
              child: GestureDetector(
                onTap: () {
                  lightHapticFeedback();
                  onSelect(reason);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: 48.h,
                  width: Get.width,
                  child: Row(
                    children: <Widget>[
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? AppColors.kF1F2F2
                              : Colors.transparent,
                          border: Border.all(
                            color: AppColors.kF1F2F2,
                            width: 2.w,
                          ),
                        ),
                        height: 24,
                        width: 24,
                      ),
                      8.horizontalSpace,
                      Text(
                        reason,
                        style: AppTextStyle.openRunde(
                          color: AppColors.kFAFBFB,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ).animate(
              position: index,
            );
          },
        ),
      ).paddingSymmetric(horizontal: 16);
}

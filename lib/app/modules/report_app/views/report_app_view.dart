import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/modules/report_app/views/report_reasons.dart';
import 'package:get/get.dart';
import '../../../data/config/app_colors.dart';
import '../../../ui/components/app_button.dart';
import '../../../ui/components/expandable_field.dart';
import '../../../ui/components/gradient_card.dart';
import '../../../utils/app_text_style.dart';
import '../controllers/report_app_controller.dart';

/// Report App View
class ReportAppView extends GetView<ReportAppController> {
  /// Report App View constructor
  const ReportAppView({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: GradientCard(
            padding: REdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24.r),
            ),
            child: Padding(
              padding: REdgeInsets.only(
                bottom: _bottom(context),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    child: Container(
                      height: 4.h,
                      width: 48.w,
                      decoration: BoxDecoration(
                        color: AppColors.kF1F2F2.withValues(alpha: .42),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  16.verticalSpace,
                  Center(
                    child: Obx(
                      () => Text(
                        controller.isContinueClicked()
                            ? 'Want to tell us more?'
                            : 'What’s going on?',
                        style: AppTextStyle.openRunde(
                          fontSize: 24.sp,
                          color: AppColors.kffffff,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  16.verticalSpace,
                  Center(
                    child: Obx(
                      () => Text(
                        controller.isContinueClicked()
                            ? 'It’s optional. A few details can help. Don’t include personal details or questions.'
                            : 'We’ll check it out, don’t worry about making the perfect choice.',
                        style: AppTextStyle.openRunde(
                          fontSize: 16.sp,
                          color: AppColors.kFAFBFB,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  24.verticalSpace,
                  AnimatedSize(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                    child: Obx(
                      () => Visibility(
                        visible: controller.isContinueClicked(),
                        child: ExpandableTextField(
                          controller: controller.detailsController,
                        ),
                        replacement: const SizedBox(
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                    child: Obx(
                      () => Visibility(
                        visible: !controller.isContinueClicked(),
                        child: ReportReasonList(
                          onSelect: (String reason) {
                            controller.selectedReason(reason);
                            controller.selectedReason.refresh();
                          },
                          reasons: controller.reasons,
                          selectedReason: controller.selectedReason(),
                        ),
                        replacement: const SizedBox(
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => controller.isContinueClicked()
                        ? 32.verticalSpace
                        : 16.verticalSpace,
                  ),
                  Obx(
                    () => AppButton(
                      buttonText: controller.isContinueClicked()
                          ? 'Report'
                          : 'Continue',
                      isLoading: controller.isReporting(),
                      onPressed: controller.onContinue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  double _bottom(BuildContext context) =>
      MediaQuery.of(context).systemGestureInsets.bottom > 12
          ? MediaQuery.of(context).systemGestureInsets.bottom - 12
          : MediaQuery.of(context).systemGestureInsets.bottom;
}

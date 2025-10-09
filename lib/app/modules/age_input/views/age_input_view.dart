import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:get/get.dart';
import '../../../data/config/app_colors.dart';
import '../../../ui/components/animated_list_view.dart';
import '../../../ui/components/app_button.dart';
import '../../../ui/components/common_app_bar.dart';
import '../../../ui/components/gradient_card.dart';
import '../controllers/age_input_controller.dart';
import '../widgets/cupertino_date_picker.dart';

/// Age Input View
class AgeInputView extends GetView<AgeInputController> {
  /// Constructor
  const AgeInputView({super.key});

  @override
  Widget build(BuildContext context) => Obx(
        () => PopScope(
          canPop: !controller.creatingUser(),
          child: Scaffold(
            backgroundColor: AppColors.kF5FCFF,
            resizeToAvoidBottomInset: false,
            floatingActionButton: Obx(
              () => AppButton(
                buttonText: 'Continue',
                isLoading: controller.creatingUser(),
                onPressed: () {
                  controller.onNext();
                },
              ),
            ).paddingSymmetric(horizontal: 24),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: GradientCard(
              child: Align(
                alignment: Alignment.topLeft,
                child: SafeArea(
                  child: AnimatedListView(
                    padding: REdgeInsets.symmetric(horizontal: 24),
                    children: <Widget>[
                      CommonAppBar(
                        onTapOfLeading: () {
                          if (controller.creatingUser()) {
                            return;
                          }

                          Get.back();
                        },
                      ),
                      64.verticalSpace,
                      Align(
                        child: Text(
                          'Your birthday?',
                          style: AppTextStyle.openRunde(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.kffffff,
                          ),
                        ),
                      ),
                      100.verticalSpace,
                      IntrinsicWidth(
                        child: Obx(
                          () => CupertinoDatePickerWidget(
                            initialDate: controller.selectedDate(),
                            onDateChanged: (DateTime newDate) {
                              controller.selectedDate(newDate);
                              controller.selectedDate.refresh();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

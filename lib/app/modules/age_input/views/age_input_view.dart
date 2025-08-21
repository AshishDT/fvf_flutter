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

/// Age Input View
class AgeInputView extends GetView<AgeInputController> {
  /// Constructor
  const AgeInputView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.kF5FCFF,
        resizeToAvoidBottomInset: false,
        floatingActionButton: AppButton(
          buttonText: 'Next',
          onPressed: () {
            FocusScope.of(context).unfocus();
            controller.onNext();
          },
        ).paddingSymmetric(horizontal: 24),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: GradientCard(
          child: Align(
            alignment: Alignment.topLeft,
            child: SafeArea(
              child: AnimatedListView(
                padding: REdgeInsets.symmetric(horizontal: 24),
                children: <Widget>[
                  const CommonAppBar(),
                  64.verticalSpace,
                  Align(
                    child: Text(
                      'How old are you?',
                      style: AppTextStyle.openRunde(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.kffffff,
                      ),
                    ),
                  ),
                  16.verticalSpace,
                  Align(
                    child: Text(
                      'Just to confirm you can join',
                      style: AppTextStyle.openRunde(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.kFAFBFB,
                      ),
                    ),
                  ),
                  165.verticalSpace,
                  Align(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 273.w,
                      padding:
                          REdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.kF1F2F2.withValues(alpha: 0.36),
                        borderRadius: BorderRadius.circular(28).r,
                      ),
                      child: TextFormField(
                        controller: controller.ageInputController,
                        maxLines: 7,
                        minLines: 1,
                        autofocus: true,
                        cursorColor: AppColors.kffffff,
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (String value) {
                          FocusScope.of(context).unfocus();
                          Future<void>.delayed(
                            const Duration(milliseconds: 300),
                            () {
                              controller.onNext();
                            },
                          );
                        },
                        style: AppTextStyle.openRunde(
                          color: AppColors.kffffff,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                        textAlign: TextAlign.center,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: 'Age',
                          hintTextDirection: TextDirection.ltr,
                          prefixIconConstraints: BoxConstraints(
                            maxHeight: 24.h,
                            maxWidth: 24.w,
                          ),
                          hintStyle: AppTextStyle.openRunde(
                            color: AppColors.kffffff,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

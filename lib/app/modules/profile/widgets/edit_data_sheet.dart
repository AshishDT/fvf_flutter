import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fvf_flutter/app/modules/profile/controllers/profile_controller.dart';
import 'package:fvf_flutter/app/ui/components/app_button.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:get/get.dart';

import '../../../data/config/app_colors.dart';
import '../../../data/config/app_images.dart';
import '../../../utils/app_text_style.dart';

/// EditDataSheet widget that adapts to keyboard visibility
class EditDataSheet extends GetView<ProfileController> {
  /// Constructor for EditDataSheet
  const EditDataSheet({super.key});

  @override
  Widget build(BuildContext context) {
    controller.nameInputController.text = controller.user().displayName ?? '';
    return GradientCard(
      alignment: AlignmentDirectional.topStart,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24.r),
      ),
      padding: REdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Edit your name',
            style: AppTextStyle.openRunde(
              color: AppColors.kffffff,
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          16.verticalSpace,
          AnimatedContainer(
            height: 56.h,
            duration: const Duration(milliseconds: 300),
            padding: REdgeInsets.symmetric(horizontal: 16, vertical: 1),
            decoration: BoxDecoration(
              color: AppColors.kF1F2F2.withValues(alpha: 0.36),
              borderRadius: BorderRadius.circular(28).r,
            ),
            child: TextFormField(
              focusNode: controller.nameInputFocusNode,
              controller: controller.nameInputController,
              maxLines: 7,
              minLines: 1,
              autofocus: true,
              cursorColor: AppColors.kffffff,
              style: AppTextStyle.openRunde(
                color: AppColors.kffffff,
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
              textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                hintText: 'Update your name',
                prefixIconConstraints: BoxConstraints(
                  maxHeight: 24.h,
                  maxWidth: 24.w,
                ),
                prefixIcon: SvgPicture.asset(
                  AppImages.penIcon,
                  height: 24.h,
                  width: 24.w,
                  colorFilter: const ColorFilter.mode(
                    AppColors.kffffff,
                    BlendMode.srcIn,
                  ),
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
          24.verticalSpace,
          AppButton(
            buttonText: 'Save',
            onPressed: () {
              controller.user(
                controller.user().copyWith(
                      displayName: controller.nameInputController.text.trim(),
                    ),
              );
            },
          ),
        ],
      ),
    );
  }
}

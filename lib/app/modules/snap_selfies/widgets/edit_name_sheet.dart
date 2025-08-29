import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fvf_flutter/app/modules/snap_selfies/controllers/snap_selfies_controller.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:get/get.dart';

import '../../../data/config/app_colors.dart';
import '../../../data/config/app_images.dart';
import '../../../utils/app_text_style.dart';

/// EditNameSheet widget that adapts to keyboard visibility
class EditNameSheet extends GetView<SnapSelfiesController> {
  /// Constructor for EditNameSheet
  const EditNameSheet({super.key});

  @override
  Widget build(BuildContext context) => GradientCard(
        alignment: AlignmentDirectional.topStart,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.r),
        ),
        padding: REdgeInsets.only(
          top: 24,
          left: 24,
          right: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'What’s Your Name?',
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
              padding: REdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.kF1F2F2.withValues(alpha: 0.36),
                borderRadius: BorderRadius.circular(28).r,
              ),
              child: TextFormField(
                focusNode: controller.nameInputFocusNode,
                controller: controller.nameInputController,
                maxLines: 7,
                minLines: 1,
                maxLength: 80,
                autofocus: true,
                cursorColor: AppColors.kF1F2F2,
                onFieldSubmitted: (String value) {
                  controller.nameInputFocusNode.unfocus();
                  controller.enteredName(value.trim());
                  controller.updateUser(username: value.trim());
                },
                onChanged: (String value) {
                  controller.enteredName(value.trim());
                },
                style: AppTextStyle.openRunde(
                  color: AppColors.kffffff,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
                textInputAction: TextInputAction.go,
                decoration: InputDecoration(
                  hintText: '',
                  counterText: '',
                  prefixIconConstraints: BoxConstraints(
                    maxHeight: 24.h,
                    maxWidth: 24.w,
                  ),
                  prefixIcon: SvgPicture.asset(
                    AppImages.penIcon,
                    height: 24.h,
                    width: 24.w,
                    color: AppColors.kF1F2F2,
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
            30.verticalSpace,
          ],
        ),
      );
}

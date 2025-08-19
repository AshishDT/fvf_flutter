import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fvf_flutter/app/modules/create_bet/controllers/create_bet_controller.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:get/get.dart';

import '../../../data/config/app_colors.dart';
import '../../../data/config/app_images.dart';
import '../../../utils/app_text_style.dart';

/// KeyboardAwareSheet widget that adapts to keyboard visibility
class KeyboardAwareSheet extends GetView<CreateBetController> {
  /// Constructor for KeyboardAwareSheet
  const KeyboardAwareSheet({super.key});

  @override
  Widget build(BuildContext context) => GradientCard(
        alignment: AlignmentDirectional.topStart,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.r),
        ),
        constraints: BoxConstraints(
          maxHeight: 174.h,
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
              'Write Your Own',
              style: AppTextStyle.openRunde(
                color: AppColors.kffffff,
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            16.verticalSpace,
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: REdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.kF1F2F2,
                borderRadius: BorderRadius.circular(28).r,
              ),
              child: TextFormField(
                focusNode: controller.messageInputFocusNode,
                maxLines: 7,
                minLines: 1,
                autofocus: true,
                cursorColor: AppColors.k2A2E2F,
                onFieldSubmitted: (String value) {
                  controller.messageInputFocusNode.unfocus();

                  controller.enteredBet(value);
                  controller.enteredBet.refresh();
                },
                onChanged: (String value) {
                  controller.enteredBet(value);
                  controller.enteredBet.refresh();
                },
                style: AppTextStyle.openRunde(
                  color: AppColors.k787C82,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
                textInputAction: TextInputAction.go,
                decoration: InputDecoration(
                  hintText: 'Message',
                  prefixIconConstraints: BoxConstraints(
                    maxHeight: 24.h,
                    maxWidth: 24.w,
                  ),
                  prefixIcon: SvgPicture.asset(
                    AppImages.penIcon,
                    height: 24.h,
                    width: 24.w,
                  ),
                  hintStyle: AppTextStyle.openRunde(
                    color: AppColors.k787C82,
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
          ],
        ),
      );
}

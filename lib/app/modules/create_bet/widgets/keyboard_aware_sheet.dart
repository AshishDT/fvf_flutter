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
                color: AppColors.kF1F2F2.withValues(alpha: 0.36),
                borderRadius: BorderRadius.circular(28).r,
              ),
              child: TextFormField(
                controller: controller.messageInputController,
                maxLines: 7,
                minLines: 1,
                maxLength: 80,
                autofocus: true,
                cursorColor: AppColors.kffffff,
                onFieldSubmitted: (String value) {
                  FocusScope.of(context).unfocus();

                  if (value.isNotEmpty) {
                    controller.enteredBet(value);
                  } else {
                    controller.enteredBet(
                      controller.bet(),
                    );
                  }
                  controller.enteredBet.refresh();
                },
                onChanged: (String value) {
                  if (value.isNotEmpty) {
                    controller.enteredBet(value);
                  } else {
                    controller.enteredBet(controller.bet());
                  }

                  controller.enteredBet.refresh();
                },
                style: AppTextStyle.openRunde(
                  color: AppColors.kffffff,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
                textInputAction: TextInputAction.go,
                decoration: InputDecoration(
                  hintText: 'Message',
                  counterText: '',
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
            30.verticalSpace,
          ],
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fvf_flutter/app/modules/snap_selfies/controllers/snap_selfies_controller.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:get/get.dart';

import '../../../data/config/app_colors.dart';
import '../../../data/config/app_images.dart';
import '../../../ui/components/app_snackbar.dart';
import '../../../utils/app_text_formatter.dart';
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
          bottom: _bottom(context),
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
              duration: const Duration(milliseconds: 300),
              padding: REdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.kF1F2F2.withValues(alpha: 0.36),
                borderRadius: BorderRadius.circular(28).r,
              ),
              child: TextFormField(
                focusNode: controller.nameInputFocusNode,
                controller: controller.nameInputController,
                maxLines: 7,
                minLines: 1,
                maxLength: 24,
                autofocus: true,
                inputFormatters: <TextInputFormatter>[
                  AppTextFormatter(),
                ],
                cursorColor: AppColors.kF1F2F2,
                onFieldSubmitted: (String value) {
                  final String trimmed = value.trim();
                  if (trimmed.length < 3 || trimmed.length > 24) {
                    appSnackbar(
                      message: 'Name must be between 3 and 24 characters.',
                      snackbarState: SnackbarState.danger,
                    );
                    return;
                  }
                  Navigator.maybePop(context);
                  controller.nameInputFocusNode.unfocus();
                  controller.updateUser(username: value.trim());
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
                  counter: const SizedBox(),
                  prefixIconConstraints: BoxConstraints(
                    maxHeight: 24.h,
                    maxWidth: 24.w,
                  ),
                  prefixIcon: SvgPicture.asset(
                    AppImages.penIcon,
                    height: 24.h,
                    width: 24.w,
                    colorFilter: const ColorFilter.mode(
                      AppColors.kF1F2F2,
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
          ],
        ),
      );

  /// Bottom
  double _bottom(BuildContext context) =>
      MediaQuery.of(context).systemGestureInsets.bottom > 12
          ? MediaQuery.of(context).systemGestureInsets.bottom - 12
          : MediaQuery.of(context).systemGestureInsets.bottom;
}

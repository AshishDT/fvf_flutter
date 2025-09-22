import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fvf_flutter/app/modules/profile/controllers/profile_controller.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:get/get.dart';
import '../../../data/config/app_colors.dart';
import '../../../data/config/app_images.dart';
import '../../../utils/app_text_style.dart';

/// EditDataSheet widget that adapts to keyboard visibility
class EditDataSheet extends GetView<ProfileController> {
  /// Constructor for EditDataSheet
  const EditDataSheet({
    required this.navigatorTag,
    super.key,
  });

  /// Navigator tag
  final String navigatorTag;

  @override
  String? get tag => navigatorTag;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ProfileController(), tag: navigatorTag);
    controller.nameInputController.text =
        controller.profile().user?.username ?? '';
    return GradientCard(
      alignment: AlignmentDirectional.topStart,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24.r),
      ),
      padding: REdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).systemGestureInsets.bottom + 5,
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
            padding: REdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              cursorColor: AppColors.kffffff,
              style: AppTextStyle.openRunde(
                color: AppColors.kffffff,
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
              onFieldSubmitted: (String value) {
                final String trimmed = value.trim();
                if (trimmed.length < 3 || trimmed.length > 24) {
                  return;
                }
                Navigator.maybePop(context);
                controller.enteredName(value.trim());
                controller.updateUser(
                  username: controller.nameInputController.text.trim(),
                );
              },
              onChanged: (String value) {
                controller.enteredName(value.trim());
              },
              textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                hintText: 'Name',
                prefixIconConstraints: BoxConstraints(
                  maxHeight: 24.h,
                  maxWidth: 24.w,
                ),
                counterText: '',
                counter: const SizedBox(),
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
        ],
      ),
    );
  }
}

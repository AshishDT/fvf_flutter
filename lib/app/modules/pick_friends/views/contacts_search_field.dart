import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/modules/pick_friends/controllers/pick_friends_controller.dart';
import 'package:get/get.dart';

import '../../../data/config/app_colors.dart';
import '../../../utils/app_text_style.dart';

/// Contacts Search Field
class ContactsSearchField extends GetView<PickFriendsController> {
  /// Constructor for Contacts Search Field
  const ContactsSearchField({super.key});

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 56.h,
        padding: REdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.kFAFBFB,
          borderRadius: BorderRadius.circular(28).r,
        ),
        child: Row(
          children: <Widget>[
            SvgPicture.asset(
              AppImages.searchPersonIcon,
              height: 24.h,
              width: 24.w,
            ),
            4.horizontalSpace,
            Expanded(
              child: TextFormField(
                controller: controller.searchController,
                style: AppTextStyle.openRunde(
                  color: AppColors.k899699,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                ),
                textInputAction: TextInputAction.go,
                decoration: InputDecoration(
                  hintText: 'Name, phone',
                  hintStyle: AppTextStyle.openRunde(
                    color: AppColors.k899699,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                  filled: true,
                  fillColor: AppColors.kFAFBFB,
                  disabledBorder: _border(),
                  border: _border(),
                  enabledBorder: _border(),
                  focusedBorder: _border(),
                  errorBorder: _border(),
                  focusedErrorBorder: _border(),
                ),
              ),
            ),
          ],
        ),
      );

  /// Returns the border for the input field
  OutlineInputBorder _border() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(28).r,
        borderSide: BorderSide(
          color: AppColors.kFAFBFB,
          width: 1.w,
        ),
      );
}

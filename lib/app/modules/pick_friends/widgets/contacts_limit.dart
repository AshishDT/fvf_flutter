import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';

/// Contacts Limit Widget
class ContactsLimit extends StatelessWidget {
  /// Constructor for Contacts Limit Widget
  const ContactsLimit({super.key});

  @override
  Widget build(BuildContext context) => IntrinsicWidth(
    child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: REdgeInsets.only(top: 24),
          padding: REdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.kFF5F7F,
            borderRadius: BorderRadius.circular(14).r,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(
                AppImages.tooMuchIcon,
                height: 18.h,
                width: 18.w,
              ),
              2.horizontalSpace,
              Text(
                'That’s too much chaos',
                style: AppTextStyle.openRunde(
                  color: AppColors.k2A2E2F,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              2.horizontalSpace,
              Text(
                '(max 8)',
                style: AppTextStyle.openRunde(
                  color: AppColors.k2A2E2F,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
  );
}

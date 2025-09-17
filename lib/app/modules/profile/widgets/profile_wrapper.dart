import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/ui/components/app_placeholder.dart';
import 'package:fvf_flutter/app/ui/components/placeholder_card.dart';

/// Profile Wrapper Widget
class ProfileWrapper extends StatelessWidget {
  /// Constructor
  const ProfileWrapper({
    required this.isLoading,
    required this.child,
    super.key,
  });

  /// Is loading
  final bool isLoading;

  /// Child widget
  final Widget child;

  @override
  Widget build(BuildContext context) => AppPlaceHolder(
        isLoading: isLoading,
        child: child,
        baseColor: AppColors.kffffff,
        padding: REdgeInsets.symmetric(horizontal: 24),
        placeHolder: Align(
          child: Column(
            children: <Widget>[
              75.verticalSpace,
              PlaceholderCard(
                height: 36.h,
                width: 230.w,
                radius: 28.r,
                bgColor: AppColors.kffffff.withValues(alpha: .36),
              ),
              10.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 14.w,
                children: <Widget>[
                  PlaceholderCard(
                    height: 24.h,
                    width: 90.w,
                    radius: 12.r,
                    bgColor: AppColors.kffffff.withValues(alpha: .36),
                  ),
                  PlaceholderCard(
                    height: 25.h,
                    width: 90.w,
                    radius: 12,
                    bgColor: AppColors.kffffff.withValues(alpha: .36),
                  ),
                  PlaceholderCard(
                    height: 25.h,
                    width: 90.w,
                    radius: 12,
                    bgColor: AppColors.kffffff.withValues(alpha: .36),
                  ),
                ],
              ),
              22.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 14.w,
                children: <Widget>[
                  PlaceholderCard(
                    height: 56.h,
                    width: 56.w,
                    radius: 500.r,
                    bgColor: AppColors.kffffff.withValues(alpha: .36),
                  ),
                  PlaceholderCard(
                    height: 56.h,
                    width: 56.w,
                    radius: 500.r,
                    bgColor: AppColors.kffffff.withValues(alpha: .36),
                  ),
                  PlaceholderCard(
                    height: 56.h,
                    width: 56.w,
                    radius: 500.r,
                    bgColor: AppColors.kffffff.withValues(alpha: .36),
                  ),
                ],
              ),
              const Spacer(),
              PlaceholderCard(
                height: 24.h,
                width: double.infinity,
                radius: 12.r,
                bgColor: AppColors.kffffff.withValues(alpha: .36),
              ),
              16.verticalSpace,
              PlaceholderCard(
                height: 56.h,
                width: 56.w,
                radius: 500.r,
                bgColor: AppColors.kffffff.withValues(alpha: .36),
              ),
              45.verticalSpace,
            ],
          ),
        ),
      );

}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/ui/components/app_placeholder.dart';
import 'package:fvf_flutter/app/ui/components/placeholder_card.dart';
import 'package:get/get.dart';

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
        padding: REdgeInsets.symmetric(horizontal: 24),
        placeHolder: Align(
          child: Column(
            children: <Widget>[
              36.verticalSpace,
              PlaceholderCard(
                height: 100.h,
                width: 100.w,
                radius: 500.r,
              ),
              30.verticalSpace,
              _buildPlaceholderCard(width: 100.w),
              16.verticalSpace,
              Row(
                spacing: 10.w,
                children: <Widget>[
                  const Spacer(),
                  _buildPlaceholderCard(),
                  _buildPlaceholderCard(),
                  _buildPlaceholderCard(),
                  const Spacer(),
                ],
              ),
              50.verticalSpace,
              ...List.generate(
                3,
                (int index) => PlaceholderCard(
                  height: 100.h,
                  width: 1.sw,
                  radius: 15,
                ).paddingOnly(bottom: 8.h),
              ).toList(),
            ],
          ),
        ),
      );

  Widget _buildPlaceholderCard({double? width}) => PlaceholderCard(
        height: 15.h,
        width: width ?? 80.w,
        radius: 2,
      );
}

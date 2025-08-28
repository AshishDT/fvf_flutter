import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        padding: REdgeInsets.symmetric(horizontal: 24),
        placeHolder: Align(
          child: Column(
            children: <Widget>[
              24.verticalSpace,
              PlaceholderCard(
                height: 30.h,
                width: 150.w,
                radius: 12,
              ),
              8.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  PlaceholderCard(
                    height: 25.h,
                    width: 100.w,
                    radius: 12,
                  ),
                  10.horizontalSpace,
                  PlaceholderCard(
                    height: 25.h,
                    width: 100.w,
                    radius: 12,
                  ),
                  10.horizontalSpace,
                  PlaceholderCard(
                    height: 25.h,
                    width: 100.w,
                    radius: 12,
                  ),
                ],
              ),
              24.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  PlaceholderCard(
                    height: 45.h,
                    width: 45.w,
                    radius: 5,
                  ),
                  10.horizontalSpace,
                  PlaceholderCard(
                    height: 45.h,
                    width: 45.w,
                    radius: 5,
                  ),
                  10.horizontalSpace,
                  PlaceholderCard(
                    height: 45.h,
                    width: 45.w,
                    radius: 5,
                  ),
                ],
              ),
              24.verticalSpace,
              const Expanded(
                child: PlaceholderCard(
                  height: double.infinity,
                  width: double.infinity,
                  radius: 16,
                ),
              ),
              24.verticalSpace,
              PlaceholderCard(
                height: 25.h,
                width: 200.w,
                radius: 12,
              ),
              20.verticalSpace,
              PlaceholderCard(
                height: 25.h,
                width: 25.w,
                radius: 12,
              ),
              36.verticalSpace,
            ],
          ),
        ),
      );

}

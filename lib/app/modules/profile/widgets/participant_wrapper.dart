import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/ui/components/app_placeholder.dart';
import 'package:fvf_flutter/app/ui/components/placeholder_card.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';

/// Participant Wrapper Widget
class ParticipantWrapper extends StatelessWidget {
  /// Constructor
  const ParticipantWrapper({
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
      ).paddingSymmetric(horizontal: 24.w),
    ),
  );
}

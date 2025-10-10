import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fvf_flutter/app/ui/components/app_placeholder.dart';
import 'package:fvf_flutter/app/ui/components/placeholder_card.dart';
import 'package:fvf_flutter/app/utils/widget_ext.dart';
import 'package:get/get.dart';

/// Notification Wrapper Widget
class NotificationWrapper extends StatelessWidget {
  /// Constructor
  const NotificationWrapper({
    required this.isLoading,
    required this.child,
    super.key,
  });

  /// Is loading
  final bool isLoading;

  /// Child
  final Widget child;

  @override
  Widget build(BuildContext context) => AppPlaceHolder(
        isLoading: isLoading,
        child: child,
        placeHolder: AnimationLimiter(
          child: ListView.builder(
            itemCount: 10,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) => Padding(
              padding: REdgeInsets.only(bottom: 8),
              child: PlaceholderCard(
                height: 100.h,
                width: context.width,
                radius: 24,
              ).animate(
                position: index,
              ),
            ),
          ),
        ),
      );
}

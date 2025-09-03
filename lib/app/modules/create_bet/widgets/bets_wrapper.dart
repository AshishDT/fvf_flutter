import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/ui/components/animated_column.dart';
import 'package:fvf_flutter/app/ui/components/app_placeholder.dart';
import 'package:fvf_flutter/app/ui/components/placeholder_card.dart';

/// Bets Wrapper Widget
class BetsWrapper extends StatelessWidget {
  /// Constructor
  const BetsWrapper({
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
        placeHolder: AnimatedColumn(
          showScaleAnimation: true,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PlaceholderCard(
              height: 8.h,
              width: 200.w,
              radius: 2,
            ),
            10.verticalSpace,
            PlaceholderCard(
              height: 8.h,
              width: 150.w,
              radius: 2,
            ),
            10.verticalSpace,
            PlaceholderCard(
              height: 8.h,
              width: 100.w,
              radius: 2,
            ),
          ],
        ),
      );
}

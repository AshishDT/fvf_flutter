import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/ui/components/app_placeholder.dart';
import 'package:fvf_flutter/app/ui/components/placeholder_card.dart';
import 'package:fvf_flutter/app/utils/widget_ext.dart';

/// Placeholder widget for contacts
class ContactsPlaceholder extends StatelessWidget {
  /// ContactsPlaceholder constructor
  const ContactsPlaceholder({
    required this.isLoading,
    required this.child,
    super.key,
  });

  /// Whether the placeholder is loading
  final bool isLoading;

  /// Child widget to display when not loading
  final Widget child;

  @override
  Widget build(BuildContext context) => AppPlaceHolder(
        isLoading: isLoading,
        child: child,
        placeHolder: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 20,
          itemBuilder: (BuildContext context, int index) {
            final bool isFirstItem = index == 0;

            return Container(
              color: Colors.transparent,
              child: Padding(
                padding:
                    REdgeInsets.only(bottom: 24, top: isFirstItem ? 16 : 0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    PlaceholderCard(
                      height: 24.h,
                      width: 24.w,
                      radius: 8,
                    ),
                    16.horizontalSpace,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        PlaceholderCard(
                          height: 56.h,
                          width: 56.w,
                          radius: 200,
                        ),
                        8.horizontalSpace,
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            PlaceholderCard(
                              height: 20.h,
                              width: 170.w,
                              radius: 6,
                            ),
                            8.verticalSpace,
                            PlaceholderCard(
                              height: 15.h,
                              width: 140.w,
                              radius: 6,
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ).animate(position: index),
            );
          },
        ),
      );
}

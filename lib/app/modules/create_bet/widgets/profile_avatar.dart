import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../ui/components/app_circular_progress.dart';

/// Profile Avatar Widget
class ProfileAvatar extends StatelessWidget {
  /// Constructor
  const ProfileAvatar({
    Key? key,
    this.profileUrl,
    this.onTap,
  }) : super(key: key);

  /// Profile image URL
  final String? profileUrl;

  /// Tap callback
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool hasImage = profileUrl != null && profileUrl!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: Container(
          height: 24.h,
          width: 24.h,
          color: Colors.grey.shade200,
          child: hasImage
              ? CachedNetworkImage(
                  imageUrl: profileUrl!,
                  fit: BoxFit.cover,
                  placeholder: (BuildContext context, String url) => Center(
                    child: SizedBox(
                      height: 12.h,
                      width: 12.h,
                      child: const AppCircularProgress(
                        size: 20,
                      ),
                    ),
                  ),
                  errorWidget:
                      (BuildContext context, String url, Object error) => Icon(
                    Icons.person,
                    size: 16.sp,
                    color: Colors.grey,
                  ),
                )
              : Icon(
                  Icons.person,
                  size: 16.sp,
                  color: Colors.grey,
                ),
        ),
      ),
    );
  }
}

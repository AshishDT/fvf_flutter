import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/md_user_selfie.dart';

/// Selfie Avatar widget
class SelfieAvatar extends StatelessWidget {
  /// Constructor for SelfieAvatar
  const SelfieAvatar({
    required this.user,
    required this.avatarColors,
    super.key,
    this.size = 56,
  });

  /// SelfieAvatar constructor
  final MdUserSelfie user;

  /// List of colors for avatar background
  final List<Color> avatarColors;

  /// Size of the avatar
  final double size;

  /// pick avatar color from id
  Color get _bgColor {
    final int hash = user.id.hashCode;
    final int index = hash % avatarColors.length;
    return avatarColors[index];
  }

  /// get initials
  String get _initials {
    if (user.displayName == null || user.displayName!.isEmpty) {
      return '?';
    }
    final List<String> parts = user.displayName!.trim().split(' ');
    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasNetworkImage =
        user.selfieUrl != null && user.selfieUrl!.isNotEmpty;
    final bool hasAsset =
        user.assetImage != null && user.assetImage!.isNotEmpty;

    Widget avatarContent;

    if (hasNetworkImage) {
      avatarContent = ClipOval(
        child: CachedNetworkImage(
          imageUrl: user.selfieUrl!,
          width: size.w,
          height: size.h,
          fit: BoxFit.cover,
          placeholder: (_, __) =>
              const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          errorWidget: (_, __, ___) => Center(
            child: Text(
              _initials,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    } else if (hasAsset) {
      avatarContent = ClipOval(
        child: Image.asset(
          user.assetImage!,
          width: size.w,
          height: size.h,
          fit: BoxFit.cover,
        ),
      );
    } else {
      avatarContent = Container(
        decoration: BoxDecoration(
          color: _bgColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFF6FCFE),
            width: 3.w,
          ),
        ),
        child: Center(
          child: Text(
            _initials,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return Opacity(
      opacity: user.isWaiting ? 0.66 : 1.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(width: size.w, height: size.h, child: avatarContent),
          2.verticalSpace,
          if (user.displayName != null && user.displayName!.isNotEmpty)
            Text(
              user.displayName!.split(' ').first,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}

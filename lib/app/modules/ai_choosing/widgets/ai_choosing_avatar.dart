import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/utils/app_decorations_ext.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../snap_selfies/models/md_user_selfie.dart';

/// AiChoosingAvatar widget
class AiChoosingAvatar extends StatelessWidget {
  /// Constructor for AiChoosingAvatar
  const AiChoosingAvatar({
    required this.user,
    this.showBorders = false,
    super.key,
  });

  final MdUserSelfie user;

  /// Whether to show borders around the avatar
  final bool showBorders;

  /// Pick avatar color from id
  Color get _bgColor {
    final List<Color> _avatarColors = <Color>[
      const Color(0xFF13C4E5),
      const Color(0xFF8C6BF5),
      const Color(0xFFD353DB),
      const Color(0xFF5B82FF),
      const Color(0xFFFB47CD),
      const Color(0xFF34A1FF),
      const Color(0xFF7C70F9),
    ];

    final int hash = user.id.hashCode;

    final int index = hash % _avatarColors.length;

    return _avatarColors[index];
  }

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
          width: 202.w,
          height: 202.h,
          fit: BoxFit.cover,
          placeholder: (_, __) =>
              const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          errorWidget: (_, __, ___) => Center(
            child: Text(
              _initials,
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.sp,
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
          width: 202.w,
          height: 202.h,
          fit: BoxFit.cover,
        ),
      );
    } else {
      avatarContent = Container(
        width: 202.w,
        height: 202.h,
        decoration: BoxDecoration(
          color: _bgColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            _initials,
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return Opacity(
      opacity: user.isWaiting ? 0.66 : 1.0,
      child: SizedBox(
        width: 202.w,
        height: 202.h,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            if (showBorders) ...<Widget>[
              Image(
                image: const AssetImage(AppImages.aiChoosingBorderGradient),
                width: 202.w,
                height: 202.h,
                fit: BoxFit.cover,
              ),
            ],
            ClipOval(
              child: Container(
                width: 160.w,
                height: 160.h,
                child: Center(child: avatarContent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:fvf_flutter/app/utils/emoji_ext.dart';
import 'package:get/get.dart';

/// Selfie Avatar widget
class SelfieAvatarIcon extends StatelessWidget {
  /// Constructor for SelfieAvatar
  const SelfieAvatarIcon({
    required this.participant,
    super.key,
    this.onAddName,
    this.size = 56,
    this.showStreakEmoji = false,
  });

  /// Participant data
  final MdParticipant participant;

  /// Size of the avatar
  final double size;

  /// Callback when add name is tapped
  final VoidCallback? onAddName;

  /// Show streakEmoji
  final bool showStreakEmoji;

  @override
  Widget build(BuildContext context) {
    final String? selfieUrl = participant.selfieUrl;
    final String? profileUrl = participant.userData?.profileUrl;

    final String? imageUrl = (selfieUrl != null && selfieUrl.isNotEmpty)
        ? selfieUrl
        : (profileUrl != null && profileUrl.isNotEmpty)
            ? profileUrl
            : null;

    final bool hasImage = imageUrl != null && imageUrl.isNotEmpty;

    Widget avatarContent;
    if (hasImage) {
      avatarContent = ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: size.w,
          height: size.h,
          fit: BoxFit.cover,
          placeholder: (_, __) => Center(
            child: CircularProgressIndicator(strokeWidth: 2.w),
          ),
          errorWidget: (_, __, ___) => const Center(
            child: Icon(
              Icons.error,
              color: AppColors.kffffff,
            ),
          ),
        ),
      );
    } else {
      avatarContent = _buildPlaceholder();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            if (hasImage)
              AnimatedContainer(
                duration: 300.milliseconds,
                width: size.w + 4.w,
                height: size.h + 4.w,
                padding: showStreakEmoji ? null : REdgeInsets.all(2),
                decoration: showStreakEmoji
                    ? null
                    : BoxDecoration(
                        color: AppColors.k2A2E2F.withValues(alpha: 0.20),
                        shape: BoxShape.circle,
                      ),
                child: avatarContent,
              )
            else
              SizedBox(
                width: size.w,
                height: size.h,
                child: avatarContent,
              ),
            if (showStreakEmoji)
              Positioned(
                bottom: -2,
                right: -2,
                child: Image.asset(
                  '🔥'.emojiImagePath,
                  height: 24.w,
                  width: 24.w,
                ),
              )
          ],
        ),
        6.verticalSpace,
        if (name != null && name!.isNotEmpty)
          Text(
            name!,
            style: AppTextStyle.openRunde(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
      ],
    );
  }

  /// Placeholder when no selfie/profile available
  Widget _buildPlaceholder() => Container(
        width: size.w,
        height: size.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.k2A2E2F.withValues(alpha: 0.20),
        ),
        child: Center(
          child: SvgPicture.asset(
            height: 42.h,
            width: 43.w,
            AppImages.personalPlaceholder,
            colorFilter: ColorFilter.mode(
              Colors.white.withValues(alpha: 0.20),
              BlendMode.srcIn,
            ),
          ),
        ),
      );

  /// Name
  String? get name => participant.userData?.username;
}

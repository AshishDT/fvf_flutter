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

import '../../../ui/components/app_circular_progress.dart';

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

    final String? imageUrl = (profileUrl != null && profileUrl.isNotEmpty)
        ? profileUrl
        : (selfieUrl != null && selfieUrl.isNotEmpty)
            ? selfieUrl
            : null;

    final bool hasImage = imageUrl != null && imageUrl.isNotEmpty;

    Widget avatarContent;
    if (hasImage) {
      avatarContent = ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: size.h,
          height: size.h,
          fit: BoxFit.cover,
          placeholder: (_, __) =>  const Center(
            child: AppCircularProgress(
              size: 30,
            ),
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
                width: size.h,
                height: size.h,
                decoration: showStreakEmoji
                    ? null
                    : BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.k2A2E2F.withValues(alpha: 0.20),
                          width: 2.w,
                        ),
                      ),
                child: avatarContent,
              )
            else
              SizedBox(
                width: size.h,
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
          Center(
            child: SizedBox(
              width: 70.w,
              child: Text(
                name!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextStyle.openRunde(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Placeholder when no selfie/profile available
  Widget _buildPlaceholder() => Container(
        width: size.h,
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

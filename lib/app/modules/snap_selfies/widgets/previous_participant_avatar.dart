import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_previous_participant.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:get/get.dart';

/// Previous participant Selfie Avatar widget
class PreviousParticipantAvatarIcon extends StatelessWidget {
  /// Previous participant constructor for SelfieAvatar
  const PreviousParticipantAvatarIcon({
    required this.participant,
    this.onAddTap,
    super.key,
  });

  /// Participant data
  final MdPreviousParticipant participant;

  /// Callback when add is tapped
  final void Function(MdPreviousParticipant participant)? onAddTap;

  @override
  Widget build(BuildContext context) {
    final String? profileUrl = participant.userProfileUrl;

    Widget avatarContent;
    if (profileUrl != null && profileUrl.isNotEmpty) {
      avatarContent = ClipOval(
        child: CachedNetworkImage(
          imageUrl: profileUrl,
          width: 56.w,
          height: 56.h,
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

    return GestureDetector(
      onTap: () {
        onAddTap?.call(participant);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              AnimatedContainer(
                duration: 300.milliseconds,
                width: 56.w + 4.w,
                height: 56.h + 4.w,
                padding: REdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: AppColors.k2A2E2F.withValues(alpha: 0.20),
                  shape: BoxShape.circle,
                ),
                child: avatarContent,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: (participant.isAdded ?? false)
                    ? Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                        size: 24.sp,
                      )
                    : SvgPicture.asset(
                        height: 24.h,
                        width: 24.w,
                        AppImages.plusIcon,
                      ),
              ),
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
      ),
    );
  }

  /// Placeholder when no selfie/profile available
  Widget _buildPlaceholder() => Container(
        width: 56.w,
        height: 56.h,
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
  String? get name => participant.userName;
}

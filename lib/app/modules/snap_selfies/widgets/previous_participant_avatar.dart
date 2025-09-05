import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_previous_round.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';

/// Previous participant Selfie Avatar widget
class PreviousParticipantAvatarIcon extends StatelessWidget {
  /// Previous participant constructor for SelfieAvatar
  const PreviousParticipantAvatarIcon({
    required this.participant,
    this.onAddTap,
    this.showAddIcon = true,
    this.showName = true,
    this.isSingle = true,
    this.mainInGroup = false,
    this.isAdded = false,
    super.key,
  });

  /// Participant data
  final MdPreviousParticipant participant;

  /// Whether to show add icon
  final bool showAddIcon;

  /// Whether to show name below avatar
  final bool showName;

  /// Whether it's a single avatar (not in group)
  final bool isSingle;

  /// Whether the main user is in the group
  final bool mainInGroup;

  /// Is added
  final bool isAdded;

  /// Callback when add is tapped
  final void Function()? onAddTap;

  @override
  Widget build(BuildContext context) {
    final String? profileUrl = participant.userProfileUrl;

    Widget avatarContent;
    if (profileUrl != null && profileUrl.isNotEmpty) {
      avatarContent = ClipOval(
        child: CachedNetworkImage(
          imageUrl: profileUrl,
          width: !isSingle ? 38.w : 56.w,
          height: !isSingle ? 38.h : 56.h,
          fit: BoxFit.cover,
          placeholder: (_, __) => _buildPlaceholder(),
          imageBuilder: (_, ImageProvider imageProvider) => Container(
            width: !isSingle ? 38.w : 56.w,
            height: !isSingle ? 38.h : 56.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          errorWidget: (_, __, ___) => _buildPlaceholder(),
        ),
      );
    } else {
      avatarContent = _buildPlaceholder();
    }

    return GestureDetector(
      onTap: () {
        onAddTap?.call();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              avatarContent,
              if (showAddIcon) ...<Widget>[
                Positioned(
                  bottom: -7,
                  right: 0,
                  child: isAdded
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
            ],
          ),
          if (showName) ...<Widget>[
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
        ],
      ),
    );
  }

  /// Placeholder when no selfie/profile available
  Widget _buildPlaceholder() => Container(
        width: !isSingle ? 38.w : 56.w,
        height: !isSingle ? 38.h : 56.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.k2A2E2F.withValues(alpha: 0.20),
        ),
        child: Center(
          child: SvgPicture.asset(
            height: !isSingle ? 25.h : 42.h,
            width: !isSingle ? 25.w : 42.w,
            AppImages.personalPlaceholder,
            colorFilter: ColorFilter.mode(
              Colors.white.withValues(alpha: 0.20),
              BlendMode.srcIn,
            ),
          ),
        ),
      );

  /// Name
  String? get name => participant.username;
}

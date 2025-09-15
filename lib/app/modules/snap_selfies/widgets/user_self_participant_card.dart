import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/data/local/user_provider.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';
import 'package:fvf_flutter/app/modules/snap_selfies/widgets/edit_name_sheet.dart';
import 'package:fvf_flutter/app/ui/components/chat_field_sheet_repo.dart';
import 'package:fvf_flutter/app/ui/components/vibrate_wiggle.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../routes/app_pages.dart';

/// Selfie Avatar widget
class CurrentUserSelfieAvatar extends StatelessWidget {
  /// Constructor for SelfieAvatar
  const CurrentUserSelfieAvatar({
    required this.participant,
    super.key,
    this.onAddName,
    this.userName,
    this.size = 100,
    this.isFromFailedView = false,
    this.showWiggle = false,
    this.isInvitationSend = false,
  });

  /// SelfieAvatar constructor
  final MdParticipant participant;

  /// Size of the avatar
  final double size;

  /// Callback when add name is tapped
  final VoidCallback? onAddName;

  /// User name
  final String? userName;

  /// isFromFailedView
  final bool isFromFailedView;

  /// Is from Add Friend View
  final bool isInvitationSend;

  /// Whether to show wiggle animation
  final bool showWiggle;

  @override
  Widget build(BuildContext context) {
    final String? selfieUrl = participant.selfieUrl;
    final String? profileUrl = globalUser().profileUrl;

    final bool selfieUploaded = selfieUrl?.isNotEmpty ?? false;

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
          width: size.w,
          height: size.h,
          fit: BoxFit.cover,
          placeholder: (_, __) => Center(
            child: CircularProgressIndicator(strokeWidth: 2.w),
          ),
          errorWidget: (_, __, ___) => _buildPlaceholder(),
        ),
      );
    } else {
      avatarContent = _buildPlaceholder();
    }

    return Align(
      child: Opacity(
        opacity: 1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () => Get.toNamed(Routes.PROFILE),
              child: hasImage
                  ? AnimatedContainer(
                      duration: 300.milliseconds,
                      width: size.w + 4.w,
                      height: size.h + 4.w,
                      padding: REdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(AppImages.gradientCardBg),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: avatarContent,
                    )
                  : SizedBox(
                      width: size.w,
                      height: size.h,
                      child: avatarContent,
                    ),
            ),
            if (isFromFailedView ||
                name != null && name!.isNotEmpty ||
                (!isInvitationSend && (participant.isHost ?? false)) ||
                !selfieUploaded) ...<Widget>[
              8.verticalSpace,
              Text(
                name ?? 'You',
                style: AppTextStyle.openRunde(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ] else if (!isFromFailedView) ...<Widget>[
              12.verticalSpace,
              IntrinsicWidth(
                child: GestureDetector(
                  onTap: () {
                    ChatFieldSheetRepo.openChatField(
                      const EditNameSheet(),
                    );
                  },
                  child: VibrateWiggle(
                    trigger: showWiggle,
                    child: Container(
                      height: 32.h,
                      padding: REdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: AppColors.kF1F2F2.withValues(alpha: 0.36),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset(
                            height: 20.h,
                            width: 20.w,
                            AppImages.penIcon,
                            colorFilter: const ColorFilter.mode(
                              AppColors.kffffff,
                              BlendMode.srcIn,
                            ),
                          ),
                          4.horizontalSpace,
                          Text(
                            'Your Name',
                            style: GoogleFonts.fredoka(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.kffffff,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ],
        ),
      ),
    );
  }

  /// Fallback placeholder
  Widget _buildPlaceholder() => Container(
        width: size.w,
        height: size.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.kF1F2F2.withValues(alpha: 0.36),
        ),
        child: Center(
          child: SvgPicture.asset(AppImages.personalPlaceholder),
        ),
      );

  /// Name
  String? get name => userName ?? participant.userData?.username;
}

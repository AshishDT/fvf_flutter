import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';
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
  });

  /// SelfieAvatar constructor
  final MdParticipant participant;

  /// Size of the avatar
  final double size;

  /// Callback when add name is tapped
  final VoidCallback? onAddName;

  /// User name
  final String? userName;

  @override
  Widget build(BuildContext context) {
    final bool hasNetworkImage =
        participant.selfieUrl != null && participant.selfieUrl!.isNotEmpty;

    Widget avatarContent;

    if (hasNetworkImage) {
      avatarContent = ClipOval(
        child: CachedNetworkImage(
          imageUrl: participant.selfieUrl!,
          width: size.w,
          height: size.h,
          fit: BoxFit.cover,
          placeholder: (_, __) => Center(
            child: CircularProgressIndicator(strokeWidth: 2.w),
          ),
          errorWidget: (_, __, ___) => Center(
            child: CircularProgressIndicator(strokeWidth: 2.w),
          ),
        ),
      );
    } else {
      avatarContent = Container(
        width: size.w,
        height: size.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.kF1F2F2.withValues(alpha: 0.36),
        ),
        child: Center(
          child: SvgPicture.asset(
            AppImages.personalPlaceholder,
          ),
        ),
      );
    }

    return Align(
      child: Opacity(
        opacity: 1,
        child: GestureDetector(
          onTap: () {
            Get.toNamed(
              Routes.PROFILE,
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (hasNetworkImage)
                AnimatedContainer(
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
              else
                SizedBox(
                  width: size.w,
                  height: size.h,
                  child: avatarContent,
                ),
              if (name != null && name!.isNotEmpty) ...<Widget>[
                8.verticalSpace,
                Text(
                  'You',
                  style: AppTextStyle.openRunde(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ] else ...<Widget>[
                12.verticalSpace,
                IntrinsicWidth(
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
                          'Add Name',
                          style: GoogleFonts.fredoka(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.kffffff,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Name
  String? get name => userName ?? participant.userData?.username;
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/modules/profile/widgets/profile_highlight_card.dart';
import 'package:fvf_flutter/app/ui/components/animated_list_view.dart';
import 'package:fvf_flutter/app/ui/components/common_app_bar.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/profile_controller.dart';

/// ProfileView
class ProfileView extends GetView<ProfileController> {
  /// Profile Constructor
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: GradientCard(
          bgImage: AppImages.profileBg,
          alignment: Alignment.center,
          child: SafeArea(
            child: AnimatedListView(
              padding: REdgeInsets.symmetric(horizontal: 24),
              children: <Widget>[
                CommonAppBar(
                  leadingIconColor: AppColors.k3D4445,
                  actions: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: SvgPicture.asset(
                        AppImages.shareIcon,
                        width: 24.w,
                        height: 24.h,
                      ),
                    ),
                  ],
                ),
                56.verticalSpace,
                Center(
                  child: GradientCard(
                    height: 112.w,
                    width: 112.w,
                    bgImage: AppImages.profileImgBg,
                    padding: REdgeInsets.all(12),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.kFAFBFB,
                        border: Border.all(
                          color: AppColors.kFAFBFB,
                          width: 4.w,
                        ),
                      ),
                    ),
                  ),
                ),
                18.verticalSpace,
                Center(
                  child: Text(
                    'Alice',
                    style: AppTextStyle.openRunde(
                      color: AppColors.k2A2E2F,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                8.verticalSpace,
                Row(
                  spacing: 8.w,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _streakChip(
                      icon: AppImages.trophyIcon,
                      title: '3x Winner',
                      bgColor: AppColors.k09DB84.withValues(alpha: 0.4),
                    ),
                    _streakChip(
                      icon: AppImages.fireIcon,
                      title: '52 Days',
                      bgColor: AppColors.kEE4AD1.withValues(alpha: 0.4),
                    ),
                    _streakChip(
                      icon: AppImages.emojiIcon,
                      title: 'Funniest',
                      bgColor: AppColors.kFFC300.withValues(alpha: 0.4),
                    ),
                  ],
                ),
                24.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _profileInfo(
                      value: '8',
                      title: 'Wins',
                    ),
                    _profileInfo(
                      value: '12',
                      title: 'Rounds',
                    ),
                    _profileInfo(
                      value: '91',
                      title: 'Reactions',
                    ),
                  ],
                ),
                24.verticalSpace,
                ...controller.highlightCards.map(
                  (Map<String, dynamic> card) => ProfileHighlightCard(
                    avatarUrl: card['avatarUrl'] ?? '',
                    title: card['title'] ?? '',
                    subtitle: card['subtitle'] ?? '',
                    backgroundColor: card['backgroundColor'] as Color,
                    borderColor: card['borderColor'] as Color,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _profileInfo({
    required String value,
    required String title,
  }) =>
      SizedBox(
        width: 90.w,
        child: Column(
          children: <Widget>[
            Text(
              value,
              style: GoogleFonts.fredoka(
                fontSize: 24.sp,
                color: AppColors.k2A2E2F,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              title,
              style: AppTextStyle.openRunde(
                fontSize: 14.sp,
                color: AppColors.k2A2E2F,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );

  Align _streakChip({
    required String icon,
    required String title,
    required Color bgColor,
  }) =>
      Align(
        child: Container(
          padding: REdgeInsets.symmetric(vertical: 3, horizontal: 8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(12.r),
              right: Radius.circular(12.r),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(
                icon,
                height: 18.w,
              ),
              5.horizontalSpace,
              Text(
                title,
                style: GoogleFonts.fredoka(
                  fontSize: 14.sp,
                  color: AppColors.k3D4445,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
}

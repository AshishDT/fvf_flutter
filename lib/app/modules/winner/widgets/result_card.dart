import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/modules/winner/widgets/reaction_menu.dart';
import 'package:fvf_flutter/app/modules/winner/widgets/rotate_and_wiggle.dart';
import 'package:fvf_flutter/app/routes/app_pages.dart';
import 'package:fvf_flutter/app/utils/emoji_ext.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/config/app_colors.dart';
import '../../../data/config/app_images.dart';
import '../../../ui/components/custom_type_writer.dart';
import '../../../utils/app_text_style.dart';

/// Result Card Widget
class ResultCard extends StatelessWidget {
  /// Constructor for ResultCard
  const ResultCard({
    super.key,
    this.ordinalSuffix,
    this.rank,
    this.isCurrentRankIs1,
    this.selfieUrl,
    this.userName,
    this.reason,
    this.isExposed = false,
    this.isFromProfile = false,
    this.onReactionSelected,
    this.triggerQuestionMark = false,
    this.reactions,
    this.isCurrentUser,
  });

  /// Controller
  final bool? isCurrentRankIs1;

  /// Rank
  final int? rank;

  /// Get ordinal suffix
  final String? ordinalSuffix;

  /// Selfie URL
  final String? selfieUrl;

  /// User name
  final String? userName;

  /// Reason
  final String? reason;

  /// Is exposed
  final bool isExposed;

  /// Is from profile
  final bool isFromProfile;

  /// On reaction selected
  final void Function(String)? onReactionSelected;

  /// Trigger question mark animation
  final bool triggerQuestionMark;

  /// Reactions
  final String? reactions;

  /// Is current user
  final bool? isCurrentUser;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Column(
            children: <Widget>[
              if (isFromProfile || isExposed || rank == 1)
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        '${rank ?? 0}',
                        style: AppTextStyle.openRunde(
                          fontSize: 40.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.kffffff,
                          shadows: <Shadow>[
                            const Shadow(
                              offset: Offset(0, 4),
                              blurRadius: 4,
                              color: Color(0x33000000),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: REdgeInsets.only(top: 5),
                        child: Text(
                          ordinalSuffix ?? '',
                          style: AppTextStyle.openRunde(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.kffffff,
                            shadows: <Shadow>[
                              const Shadow(
                                offset: Offset(0, 4),
                                blurRadius: 4,
                                color: Color(0x33000000),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Align(
                  alignment: Alignment.centerRight,
                  child: RotateThenWiggle(
                    trigger: triggerQuestionMark,
                    child: Text(
                      '?',
                      style: GoogleFonts.fredoka(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.kffffff,
                        shadows: <Shadow>[
                          const Shadow(
                            offset: Offset(0, 4),
                            blurRadius: 4,
                            color: Color(0x33000000),
                          ),
                        ],
                      ),
                    ).paddingOnly(right: 4.w),
                  ),
                ),
              16.verticalSpace,
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    ReactionMenu.show(
                      context: context,
                      position: details.globalPosition,
                      onReactionSelected: (String emoji) {
                        final String? activeEmoji = reactions;
                        if (activeEmoji == emoji) {
                          return;
                        }
                        onReactionSelected?.call(emoji);
                      },
                    );
                  },
                  child: reactions == null || (reactions?.isEmpty ?? true)
                      ? Image.asset(
                          AppImages.smilyIconPng,
                          height: 32.w,
                          width: 32.w,
                        )
                      : Image.asset(
                          reactions?.emojiImagePath ?? '',
                          height: 32.w,
                          width: 32.w,
                        ),
                ),
              ),
              16.verticalSpace,
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    AppImages.shareIconPng,
                    height: 32.w,
                    width: 32.w,
                  ),
                ),
              ),
              16.verticalSpace,
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      36.horizontalSpace,
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            if(isCurrentUser ?? false){
                              Get.toNamed(
                                Routes.PROFILE,
                              );
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(500.r),
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        offset: const Offset(0, 1),
                                        blurRadius: 2,
                                        color: AppColors.k000000
                                            .withValues(alpha: .75),
                                      ),
                                    ],
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: selfieUrl ?? '',
                                    width: 24.w,
                                    height: 24.w,
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) => const Center(
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2)),
                                    errorWidget: (_, __, ___) => Container(
                                      height: 24.w,
                                      width: 24.w,
                                      color: Colors.grey.shade200,
                                      child: const Icon(
                                        Icons.person,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (userName != null &&
                                  (userName?.isNotEmpty ?? false)) ...<Widget>[
                                4.horizontalSpace,
                                Flexible(
                                  child: Text(
                                    userName ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyle.openRunde(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.kffffff,
                                      shadows: <Shadow>[
                                        Shadow(
                                          offset: const Offset(0, 1),
                                          blurRadius: 2,
                                          color: AppColors.k000000
                                              .withValues(alpha: .75),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.until((Route<dynamic> route) =>
                              route.settings.name == Routes.CREATE_BET);
                        },
                        child: Image.asset(
                          AppImages.addPngIcon,
                          height: 36.w,
                        ),
                      ),
                    ],
                  ),
                  if (isFromProfile || isExposed || rank == 1) ...<Widget>[
                    16.verticalSpace,
                    CustomTypewriterText(
                      text: reason ?? '',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 20.sp,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                        color: AppColors.kffffff,
                        shadows: <Shadow>[
                          Shadow(
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                            color: AppColors.k000000.withValues(alpha: .75),
                          ),
                        ],
                      ),
                    ),
                  ]
                ],
              ),
            ],
          ),
        ],
      );
}

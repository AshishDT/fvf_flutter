import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fvf_flutter/app/data/local/user_provider.dart';
import 'package:fvf_flutter/app/modules/profile/widgets/participant_wrapper.dart';
import 'package:fvf_flutter/app/modules/winner/widgets/reaction_menu.dart';
import 'package:fvf_flutter/app/modules/winner/widgets/rotate_and_wiggle.dart';
import 'package:fvf_flutter/app/routes/app_pages.dart';
import 'package:fvf_flutter/app/utils/emoji_ext.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/config/app_colors.dart';
import '../../../data/config/app_images.dart';
import '../../../utils/app_text_style.dart';
import '../controllers/profile_controller.dart';
import '../models/md_user_rounds.dart';

/// PARTICIPANTS PAGE
class ParticipantsPage extends StatelessWidget {
  /// ParticipantsPage Constructor
  const ParticipantsPage({
    required this.controller,
    super.key,
  });

  /// Profile controller
  final ProfileController controller;

  @override
  Widget build(BuildContext context) => Obx(
        () => ParticipantWrapper(
          isLoading: controller.isRoundsLoading(),
          child: controller.rounds().isNotEmpty
              ? Stack(
                  children: <Widget>[
                    PageView.builder(
                      controller: controller.roundPageController,
                      itemCount: controller.rounds().length,
                      onPageChanged: (int i) {
                        controller.currentRound(i);
                        if (controller.rounds[i].rank == null) {
                          controller.animatedIndex(i);
                        }
                      },
                      itemBuilder: (BuildContext context, int index) => Obx(
                        () {
                          final MdRound round = controller.rounds[index];
                          final bool shouldAnimate =
                              controller.animatedIndex() == index &&
                                  controller.currentIndex() == 1;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              round.rank != null
                                  ? Align(
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            '${round.rank ?? 0}',
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
                                              getOrdinalSuffix(
                                                      round.rank ?? 0) ??
                                                  '',
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
                                  : Align(
                                      alignment: Alignment.centerRight,
                                      child: RotateThenWiggle(
                                        trigger: shouldAnimate,
                                        child: Text(
                                          '?',
                                          style: GoogleFonts.fredoka(
                                            fontSize: 36.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.kF1F2F2,
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
                                    ).paddingOnly(right: 2.w),
                              16.verticalSpace,
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTapDown: (TapDownDetails details) {
                                    ReactionMenu.show(
                                      context: context,
                                      position: details.globalPosition,
                                      onReactionSelected: (String emoji) {
                                        controller.addReaction(
                                          roundId: round.roundId ?? '',
                                          emoji: emoji,
                                          participantId: globalUser().id ?? '',
                                        );
                                        HapticFeedback.mediumImpact();
                                      },
                                    );
                                  },
                                  child: round.reactions == null
                                      ? SvgPicture.asset(
                                          AppImages.smilyIcon,
                                          height: 32.w,
                                          width: 32.w,
                                        )
                                      : Image.asset(
                                          round.reactions?.emojiImagePath ?? '',
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
                                  child: SvgPicture.asset(
                                    AppImages.shareIconShadow,
                                    height: 32.w,
                                    width: 32.w,
                                  ),
                                ),
                              ),
                              16.verticalSpace,
                              Row(
                                children: <Widget>[
                                  36.horizontalSpace,
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(500.r),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                globalUser().profileUrl ?? '',
                                            width: 24.w,
                                            height: 24.w,
                                            fit: BoxFit.cover,
                                            placeholder: (_, __) => const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        strokeWidth: 2)),
                                            errorWidget: (_, __, ___) =>
                                                Container(
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
                                        if (globalUser().username != null &&
                                            (globalUser()
                                                    .username
                                                    ?.isNotEmpty ??
                                                false)) ...<Widget>[
                                          4.horizontalSpace,
                                          Flexible(
                                            child: Text(
                                              globalUser().username ?? '',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: AppTextStyle.openRunde(
                                                fontSize: 24.sp,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.kffffff,
                                              ),
                                            ),
                                          ),
                                        ]
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.until(
                                        (Route<dynamic> route) =>
                                            route.settings.name ==
                                            Routes.CREATE_BET,
                                      );
                                    },
                                    child: Image.asset(
                                      AppImages.addPngIcon,
                                      height: 36.w,
                                    ),
                                  ),
                                ],
                              ),
                              if (round.reason != null &&
                                  round.reason!.isNotEmpty) ...<Widget>[
                                16.verticalSpace,
                                AutoSizeText(
                                  round.reason ?? '',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  // maxFontSize: 20.sp,
                                  style: GoogleFonts.inter(
                                    fontSize: 20.sp,
                                    color: AppColors.kffffff,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ],
                          ).paddingOnly(
                            right: 24.w,
                            left: 24.w,
                            bottom: 117.h,
                          );
                        },
                      ),
                    ),
                    Positioned(
                      left: 24.w,
                      right: 24.w,
                      child: AnimatedSwitcher(
                        duration: 400.milliseconds,
                        reverseDuration: 300.milliseconds,
                        transitionBuilder:
                            (Widget child, Animation<double> animation) =>
                                FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 0.7, end: 1).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeInOut,
                              ),
                            ),
                            child: child,
                          ),
                        ),
                        child: Text(
                          controller
                                  .rounds()[controller.currentRound()]
                                  .prompt ??
                              '',
                          key: ValueKey(controller.currentRound()),
                          textAlign: TextAlign.center,
                          style: AppTextStyle.openRunde(
                            fontSize: 32.sp,
                            color: AppColors.kffffff,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    /// Navigation
                    Obx(
                      () => controller.currentRound() != 0
                          ? Positioned(
                              left: 12.w,
                              top: -28.h,
                              bottom: 0,
                              child: Center(
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: controller.prevPage,
                                  icon:
                                      SvgPicture.asset(AppImages.backwardArrow),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    Obx(
                      () => controller.currentRound() <
                              controller.rounds().length - 1
                          ? Positioned(
                              right: 12.w,
                              top: -28.h,
                              bottom: 0,
                              child: Center(
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: controller.nextPage,
                                  icon:
                                      SvgPicture.asset(AppImages.forwardArrow),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      );

  /// getOrdinalSuffix
  String getOrdinalSuffix(int number) {
    if (number >= 11 && number <= 13) {
      return '${number}th';
    }
    switch (number % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}

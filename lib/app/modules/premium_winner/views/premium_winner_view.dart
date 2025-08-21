import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/modules/premium_winner/widgets/rank_card.dart';
import 'package:fvf_flutter/app/modules/premium_winner/widgets/winner_podium.dart';
import 'package:fvf_flutter/app/modules/snap_selfies/models/md_user_selfie.dart';
import 'package:fvf_flutter/app/modules/winner/models/emoji_model.dart';
import 'package:fvf_flutter/app/ui/components/animated_list_view.dart';
import 'package:fvf_flutter/app/ui/components/app_button.dart';
import 'package:fvf_flutter/app/ui/components/common_app_bar.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:get/get.dart';

import '../controllers/premium_winner_controller.dart';

/// PremiumWinnerView
class PremiumWinnerView extends GetView<PremiumWinnerController> {
  /// PremiumWinnerView Constructor
  const PremiumWinnerView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.kF5FCFF,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _dotIndicator(),
            24.verticalSpace,
            AppButton(
              buttonText: 'Share',
              onPressed: () {},
            ),
          ],
        ).paddingSymmetric(horizontal: 24.w),
        body: GradientCard(
          child: SafeArea(
            child: AnimatedListView(
              children: <Widget>[
                CommonAppBar(
                  leadingIcon: AppImages.closeIconWhite,
                  actions: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        AppImages.dice,
                        width: 40.w,
                        height: 40.h,
                      ),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 24.w),
                64.verticalSpace,
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 120.h),
                    child: Obx(
                      () => AutoSizeText(
                        controller.bet(),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 40,
                        style: AppTextStyle.openRunde(
                          fontSize: 40.sp,
                          color: AppColors.kffffff,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ).paddingSymmetric(horizontal: 24.w),
                24.verticalSpace,
                Obx(
                  () {
                    if (controller.selfies.isEmpty ||
                        controller.pageController == null) {
                      return const SizedBox.shrink();
                    }
                    return WinnersPodiumPremiumView(
                      rank1: controller.selfies[controller.currentRank()],
                      rank2: controller.currentRank() > 0
                          ? controller.selfies[controller.currentRank() - 1]
                          : null,
                      rank3: controller.currentRank() <
                              controller.selfies.length - 1
                          ? controller.selfies[controller.currentRank() + 1]
                          : null,
                    ).paddingSymmetric(horizontal: 94.w);
                  },
                ),
                16.verticalSpace,
                Obx(
                  () {
                    if (controller.selfies.isEmpty ||
                        controller.pageController == null) {
                      return const SizedBox.shrink();
                    }
                    return SizedBox(
                      height: 400.h,
                      child: Stack(
                        children: <Widget>[
                          PageView.builder(
                            controller: controller.pageController,
                            itemCount: controller.selfies().length,
                            onPageChanged: (int i) => controller.currentRank(i),
                            itemBuilder: (BuildContext context, int index) {
                              final MdUserSelfie selfie =
                                  controller.selfies[index];
                              final MdUserSelfie? rank1 =
                                  controller.selfies[index];
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  RankCard(
                                    rank: selfie.rank ?? 0,
                                  ),
                                  12.verticalSpace,
                                  Text(
                                    rank1?.displayName ?? '',
                                    style: AppTextStyle.openRunde(
                                      fontSize: 32.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.kffffff,
                                    ),
                                  ),
                                  16.verticalSpace,
                                  Text(
                                    'That no-nonsense stare made it obvious',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyle.openRunde(
                                      fontSize: 20.sp,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.kffffff,
                                    ),
                                  ),
                                  24.verticalSpace,
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: List.generate(
                                      controller.emojiReactions.length,
                                      (int i) {
                                        final EmojiReaction emojiData =
                                            controller.emojiReactions[i];
                                        return _emojiTile(
                                          emojiIcon: emojiData.emoji,
                                          value: emojiData.count.toString(),
                                        ).paddingOnly(right: 12.w);
                                      },
                                    ),
                                  ).paddingSymmetric(horizontal: 40.w),
                                ],
                              );
                            },
                          ),
                          Obx(
                            () => controller.currentRank() != 0
                                ? Positioned(
                                    left: 10.w,
                                    top: 36.w,
                                    child: Center(
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: controller.prevPage,
                                        icon: SvgPicture.asset(
                                            AppImages.backwardArrow),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          Obx(
                            () => controller.currentRank() <
                                    controller.selfies().length - 1
                                ? Positioned(
                                    right: 10.w,
                                    top: 36.w,
                                    child: Center(
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: controller.nextPage,
                                        icon: SvgPicture.asset(
                                            AppImages.forwardArrow),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );

  /// Dot indicator for the current selfie rank
  Obx _dotIndicator() => Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: controller
              .selfies()
              .asMap()
              .entries
              .map(
                (MapEntry<int, MdUserSelfie> e) => FittedBox(
                  child: AnimatedContainer(
                    duration: 300.milliseconds,
                    height: 8.w,
                    width: 8.w,
                    margin: REdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: controller.currentRank() == e.key
                          ? AppColors.kF1F2F2
                          : AppColors.kF1F2F2.withValues(alpha: .24),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );

  Widget _emojiTile({
    required String value,
    required String emojiIcon,
  }) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            emojiIcon,
            style: AppTextStyle.openRunde(
              fontSize: 30.sp,
            ),
          ),
          2.verticalSpace,
          Text(
            value,
            style: AppTextStyle.openRunde(
              fontSize: 12.sp,
              color: AppColors.kffffff,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
}

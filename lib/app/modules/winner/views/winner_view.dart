import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/modules/winner/models/emoji_model.dart';
import 'package:fvf_flutter/app/modules/winner/widgets/expose_sheet.dart';
import 'package:fvf_flutter/app/routes/app_pages.dart';
import 'package:fvf_flutter/app/ui/components/app_button.dart';
import 'package:get/get.dart';

import '../../../data/config/app_colors.dart';
import '../../../data/config/app_images.dart';
import '../../../ui/components/animated_list_view.dart';
import '../../../ui/components/common_app_bar.dart';
import '../../../ui/components/gradient_card.dart';
import '../../../utils/app_text_style.dart';
import '../controllers/winner_controller.dart';
import '../widgets/rank_card.dart';
import '../widgets/winner_podium.dart';

/// Winner View
class WinnerView extends GetView<WinnerController> {
  /// WinnerView Constructor
  const WinnerView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.kF5FCFF,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AppButton(
              buttonText: '',
              height: 57.h,
              buttonColor: AppColors.kFFC300,
              onPressed: () {
                controller.isExposed()
                    ? Get.toNamed(
                        Routes.PREMIUM_WINNER,
                        arguments: controller.selfies,
                      )
                    : ExposeSheet.openExposeSheet();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Expose Everyone 👀',
                    style: AppTextStyle.openRunde(
                      fontSize: 18.sp,
                      color: AppColors.k2A2E2F,
                      fontWeight: FontWeight.w700,
                      height: .8,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    'See how everyone placed!',
                    style: AppTextStyle.openRunde(
                      fontSize: 12.sp,
                      color: AppColors.k2A2E2F,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            16.verticalSpace,
            AppButton(
              buttonText: 'Share',
              onPressed: () {},
            ),
          ],
        ).paddingSymmetric(horizontal: 24.w),
        body: GradientCard(
          child: SafeArea(
            child: AnimatedListView(
              padding: REdgeInsets.symmetric(horizontal: 24),
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
                ),
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
                ),
                24.verticalSpace,
                Center(
                  child: Obx(
                    () => WinnersPodium(
                      rank1: controller.firstRank(),
                      rank2: controller.secondRank(),
                      rank3: controller.thirdRank(),
                    ),
                  ),
                ),
                16.verticalSpace,
                const Align(
                  child: RankCard(
                    rank: 1,
                  ),
                ),
                12.verticalSpace,
                Align(
                  child: Obx(
                    () => Text(
                      controller.firstRank().displayName ?? '',
                      style: AppTextStyle.openRunde(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.kffffff,
                      ),
                    ),
                  ),
                ),
                16.verticalSpace,
                Align(
                  child: Text(
                    'That no-nonsense stare made it obvious',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.openRunde(
                      fontSize: 20.sp,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      color: AppColors.kffffff,
                    ),
                  ),
                ),
                24.verticalSpace,
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      controller.emojiReactions().length,
                      (int index) {
                        final EmojiReaction emojiData =
                            controller.emojiReactions()[index];
                        return _emojiTile(
                          emojiIcon: emojiData.emoji,
                          value: emojiData.count.toString(),
                          onTap: () => controller.handleEmojiTap(index),
                          isSelected: controller.userReactionIndex() == index,
                        ).paddingOnly(right: 12.w);
                      },
                    ),
                  ).paddingSymmetric(horizontal: 40.w),
                ),
                300.verticalSpace,
              ],
            ),
          ),
        ),
      );

  Widget _emojiTile({
    required String value,
    required String emojiIcon,
    required bool isSelected,
    VoidCallback? onTap,
  }) =>
      GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AnimatedContainer(
              duration: 300.milliseconds,
              padding: REdgeInsets.all(isSelected ? 2 : 0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(
                        color: AppColors.kffffff,
                        width: 2.w,
                      )
                    : null,
              ),
              child: Text(
                emojiIcon,
                style: AppTextStyle.openRunde(
                  fontSize: 28.sp,
                ),
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
        ),
      );
}

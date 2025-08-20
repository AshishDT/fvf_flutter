import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        floatingActionButton: AppButton(
          buttonText: 'Share',
          onPressed: () {},
        ).paddingSymmetric(horizontal: 24),
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
                  child: AutoSizeText(
                    'Most Likely to Start an OF?',
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
              ],
            ),
          ),
        ),
      );
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/modules/create_bet/widgets/bets_wrapper.dart';
import 'package:fvf_flutter/app/modules/create_bet/widgets/keyboard_aware_sheet.dart';
import 'package:fvf_flutter/app/ui/components/animated_list_view.dart';
import 'package:fvf_flutter/app/ui/components/app_button.dart';
import 'package:fvf_flutter/app/ui/components/chat_field_sheet_repo.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:get/get.dart';
import '../../../ui/components/app_snackbar.dart';
import '../../../ui/components/common_app_bar.dart';
import '../../../ui/components/gradient_card.dart';
import '../controllers/create_bet_controller.dart';
import '../widgets/dice_roller.dart';

/// Create Bet View
class CreateBetView extends GetView<CreateBetController> {
  /// Constructor
  const CreateBetView({super.key});

  @override
  Widget build(BuildContext context) => Obx(
        () => PopScope(
          canPop: !controller.createRoundLoading(),
          child: Scaffold(
            backgroundColor: AppColors.kF5FCFF,
            floatingActionButton: Obx(
              () => AppButton(
                buttonText: 'Bet',
                isLoading: controller.createRoundLoading(),
                onPressed: controller.onBetPressed,
              ),
            ).paddingSymmetric(horizontal: 24),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: GradientCard(
              child: Align(
                alignment: Alignment.topLeft,
                child: SafeArea(
                  child: AnimatedListView(
                    padding: REdgeInsets.symmetric(horizontal: 24),
                    children: <Widget>[
                      CommonAppBar(
                        leadingIcon: AppImages.menuIcon,
                        actions: <Widget>[
                          SvgPicture.asset(
                            height: 24.h,
                            width: 24.w,
                            AppImages.notificationIcon,
                          ),
                        ],
                      ),
                      64.verticalSpace,
                      GradientCard(
                        padding: REdgeInsets.symmetric(
                          vertical: 31,
                          horizontal: 24,
                        ),
                        borderRadius: BorderRadius.circular(32.r),
                        constraints: BoxConstraints(maxHeight: 135.h),
                        bgImage: AppImages.contentCardBg,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Obx(
                                () => BetsWrapper(
                                  isLoading: controller.isLoading(),
                                  child: _question(),
                                ),
                              ),
                            ),
                            16.horizontalSpace,
                            Padding(
                              padding: REdgeInsets.only(bottom: 16.h),
                              child: Obx(
                                () => DiceRoller(
                                  isLoading: controller.isLoading(),
                                  rollTrigger: controller.rollCounter(),
                                  onTap: controller.rollDice,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      24.verticalSpace,
                      AppButton(
                        buttonText: '',
                        buttonColor: AppColors.kF1F2F2.withValues(alpha: 0.36),
                        onPressed: () {
                          if (controller.createRoundLoading()) {
                            appSnackbar(
                              message: 'Please wait, creating round...',
                              snackbarState: SnackbarState.warning,
                            );
                            return;
                          }
                          ChatFieldSheetRepo.openChatField(
                            const KeyboardAwareSheet(),
                            isDismissible: true,
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Or write your own',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.openRunde(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.kffffff,
                              ),
                            ),
                            4.horizontalSpace,
                            Image.asset(
                              AppImages.pencilIcon,
                              height: 32.h,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  /// Question widget that displays the current question
  Obx _question() => Obx(
        () => controller.enteredBet().isNotEmpty
            ? AutoSizeText(
                controller.enteredBet(),
                key: ValueKey<String>(controller.enteredBet()),
                overflow: TextOverflow.ellipsis,
                maxLines: 20,
                style: AppTextStyle.openRunde(
                  color: AppColors.kffffff,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              )
            : AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder:
                    (Widget child, Animation<double> animation) =>
                        FadeTransition(
                  opacity: animation,
                  child: child,
                ),
                child: AutoSizeText(
                  controller.bet(),
                  key: ValueKey<String>(controller.bet()),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 20,
                  style: AppTextStyle.openRunde(
                    color: AppColors.kffffff,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ),
      );
}

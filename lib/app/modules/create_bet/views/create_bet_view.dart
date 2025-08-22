import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/modules/create_bet/widgets/keyboard_aware_sheet.dart';
import 'package:fvf_flutter/app/routes/app_pages.dart';
import 'package:fvf_flutter/app/ui/components/animated_list_view.dart';
import 'package:fvf_flutter/app/ui/components/app_button.dart';
import 'package:fvf_flutter/app/ui/components/work_space_sheet_repo.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:get/get.dart';
import '../../../ui/components/common_app_bar.dart';
import '../../../ui/components/gradient_card.dart';
import '../controllers/create_bet_controller.dart';
import '../widgets/dice_roller.dart';

/// Create Bet View
class CreateBetView extends GetView<CreateBetController> {
  /// Constructor
  const CreateBetView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.kF5FCFF,
        floatingActionButton: AppButton(
          buttonText: 'Bet',
          onPressed: () {
            Get.toNamed(
              Routes.PICK_CREW,
              arguments: controller.enteredBet().isNotEmpty
                  ? controller.enteredBet()
                  : controller.question(),
            );
          },
        ).paddingSymmetric(horizontal: 24),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: GradientCard(
          child: Align(
            alignment: Alignment.topLeft,
            child: SafeArea(
              child: AnimatedListView(
                padding: REdgeInsets.symmetric(horizontal: 24),
                children: <Widget>[
                  const CommonAppBar(),
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
                          child: _question(),
                        ),
                        16.horizontalSpace,
                        Padding(
                          padding: REdgeInsets.only(bottom: 16.h),
                          child: Obx(
                            () => DiceRoller(
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
                      if (controller.enteredBet().isNotEmpty) {
                        controller.messageInputController.text =
                            controller.enteredBet();
                      }

                      ChatFieldSheetRepo.openChatField(
                        const KeyboardAwareSheet(),
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
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final Animation<Offset> inAnimation = Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(animation);

                  final Animation<Offset> outAnimation = Tween<Offset>(
                    begin: Offset.zero,
                    end: const Offset(0, -1),
                  ).animate(animation);

                  return ClipRect(
                    child: SlideTransition(
                      position:
                          child.key == ValueKey<String>(controller.question())
                              ? inAnimation
                              : outAnimation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    ),
                  );
                },
                child: AutoSizeText(
                  controller.question(),
                  key: ValueKey<String>(controller.question()),
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

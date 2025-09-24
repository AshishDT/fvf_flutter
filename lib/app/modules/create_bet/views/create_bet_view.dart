import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/modules/create_bet/widgets/bets_wrapper.dart';
import 'package:fvf_flutter/app/modules/create_bet/widgets/drawer.dart';
import 'package:fvf_flutter/app/modules/create_bet/widgets/keyboard_aware_sheet.dart';
import 'package:fvf_flutter/app/modules/profile/models/md_profile_args.dart';
import 'package:fvf_flutter/app/routes/app_pages.dart';
import 'package:fvf_flutter/app/ui/components/animated_list_view.dart';
import 'package:fvf_flutter/app/ui/components/app_button.dart';
import 'package:fvf_flutter/app/ui/components/chat_field_sheet_repo.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:get/get.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import '../../../ui/components/app_snackbar.dart';
import '../../../ui/components/common_app_bar.dart';
import '../../../ui/components/gradient_card.dart';
import '../controllers/create_bet_controller.dart';
import '../widgets/question_roller.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/question_card.dart';

/// Create Bet View
class CreateBetView extends GetView<CreateBetController> {
  /// Constructor
  const CreateBetView({super.key});

  @override
  Widget build(BuildContext context) => Obx(
        () => IgnorePointer(
          ignoring: controller.createRoundLoading(),
          child: PopScope(
            canPop: !controller.createRoundLoading(),
            child: Scaffold(
              key: controller.scaffoldKey,
              backgroundColor: AppColors.kF5FCFF,
              drawer: const MenuDrawer(),
              floatingActionButton: Obx(
                () => AppButton(
                  buttonText: !(controller.canCreateBetData().allowed ?? false)
                      ? 'Keep Slaying'
                      : 'Bet',
                  isLoading: controller.createRoundLoading() ||
                      controller.isPurchasing(),
                  onPressed: !(controller.canCreateBetData().allowed ?? false)
                      ? () {
                          controller.openPurchaseSheet();
                        }
                      : controller.onBetPressed,
                ),
              ).paddingSymmetric(horizontal: 24),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              body: GradientCard(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SafeArea(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await controller.getUser();
                        await controller.getBets();
                        await controller.checkCanCreateRound();
                      },
                      color: AppColors.k787C82,
                      backgroundColor: AppColors.kF5FCFF,
                      child: AnimatedListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: REdgeInsets.symmetric(horizontal: 24),
                        children: <Widget>[
                          CommonAppBar(
                            leadingIcon: AppImages.menuIcon,
                            onTapOfLeading: () {
                              controller.scaffoldKey.currentState?.openDrawer();
                            },
                            actions: <Widget>[
                              SvgPicture.asset(
                                height: 24.h,
                                width: 24.w,
                                AppImages.notificationIcon,
                              ),
                              Obx(
                                () => Visibility(
                                  visible: controller.canShowProfile() ||
                                      controller.isUserLoading(),
                                  child: 10.horizontalSpace,
                                ),
                              ),
                              _profileIcon(),
                            ],
                          ),
                          64.verticalSpace,
                          QuestionCard(
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
                                AnimatedSize(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  child: Obx(
                                    () => Visibility(
                                      visible: !controller.isLoading(),
                                      child: QuestionRoller(
                                        rollTrigger: controller.rollCounter(),
                                        onTap: controller.rollDice,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          24.verticalSpace,
                          AppButton(
                            buttonText: '',
                            buttonColor:
                                AppColors.kF1F2F2.withValues(alpha: 0.36),
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
                                SvgPicture.asset(
                                  height: 20.h,
                                  width: 20.w,
                                  AppImages.penIcon,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.kffffff,
                                    BlendMode.srcIn,
                                  ),
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
          ),
        ),
      );

  /// Profile icon widget
  Obx _profileIcon() => Obx(
        () => controller.isUserLoading()
            ? Center(
                child: SizedBox(
                  height: 24.h,
                  width: 24.w,
                  child: SleekCircularSlider(
                    appearance: CircularSliderAppearance(
                      spinnerMode: true,
                      size: 30,
                      customColors: CustomSliderColors(
                        dotColor: Colors.transparent,
                        trackColor: Colors.transparent,
                        progressBarColor: Colors.transparent,
                        shadowColor: Colors.black38,
                        progressBarColors: <Color>[
                          const Color(0xFFFFDBF6),
                          const Color(0xFFFF70DB),
                          const Color(0xFF6C75FF),
                          const Color(0xFF4DD0FF),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : !controller.canShowProfile()
                ? const SizedBox()
                : ProfileAvatar(
                    profileUrl: controller.profile().user?.profileUrl ?? '',
                    onTap: () {
                      _navigateToProfile();
                    },
                  ),
      );

  /// Navigate to profile
  void _navigateToProfile() {
    Get.toNamed(
      Routes.PROFILE,
      preventDuplicates: false,
      arguments: MdProfileArgs(
        tag:
            '${controller.profile().user?.id}_${DateTime.now().millisecondsSinceEpoch}',
        userId: controller.profile().user?.id ?? '',
      ),
    );
  }

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
                duration: const Duration(milliseconds: 600),
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

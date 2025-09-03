import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/modules/profile/enums/subscription_enum.dart';
import 'package:fvf_flutter/app/modules/winner/widgets/expose_sheet.dart';
import 'package:fvf_flutter/app/routes/app_pages.dart';
import 'package:fvf_flutter/app/ui/components/app_snackbar.dart';
import 'package:get/get.dart';

import '../../../data/config/app_colors.dart';
import '../../../data/config/app_images.dart';
import '../../../ui/components/app_button.dart';
import '../../../utils/app_text_style.dart';
import '../controllers/profile_controller.dart';
import '../models/md_user_rounds.dart';

/// EXPOSE BUTTON
class ExposeButton extends StatelessWidget {
  /// Expose buttons
  const ExposeButton({
    required this.controller,
    super.key,
  });

  /// Profile controller
  final ProfileController controller;

  @override
  Widget build(BuildContext context) => Obx(
        () => AnimatedSize(
          duration: 300.milliseconds,
          child: Visibility(
            visible: controller.currentIndex() == 1,
            child: AppButton(
              isLoading: controller.isPurchasing(),
              buttonText: '',
              height: 57.h,
              onPressed: () {
                controller.rounds()[controller.currentRound()].hasAccessed ??
                        false
                    ? Get.toNamed(
                        Routes.WINNER,
                        arguments: <String, dynamic>{
                          'roundId': controller
                                  .rounds()[controller.currentRound()]
                                  .roundId ??
                              '',
                          'isFromProfile': true,
                        },
                      )
                    : ExposeSheet.openExposeSheet(
                        onExposed: () async {
                          final bool _isPurchase =
                              await controller.roundSubscription(
                            roundId: controller
                                    .rounds()[controller.currentRound()]
                                    .roundId ??
                                '',
                            paymentId: '',
                            type: SubscriptionPlanEnum.WEEKLY,
                          );
                          if (_isPurchase) {
                            Get.close(0);
                            controller
                                .rounds(controller.rounds().map((MdRound r) {
                              if (r.roundId ==
                                  controller
                                      .rounds()[controller.currentRound()]
                                      .roundId) {
                                return MdRound(
                                  roundId: r.roundId,
                                  prompt: r.prompt,
                                  reason: r.reason,
                                  createdAt: r.createdAt,
                                  hasAccessed: true,
                                  result: r.result,
                                  rank: r.rank,
                                  selfieUrl: r.selfieUrl,
                                  reactions: r.reactions,
                                );
                              }
                              return r;
                            }).toList());
                            appSnackbar(
                              message:
                                  'You have successfully subscribed to the unlimited plan!',
                              snackbarState: SnackbarState.success,
                            );
                            await Get.toNamed(
                              Routes.WINNER,
                              arguments: <String, dynamic>{
                                'roundId': controller
                                        .rounds()[controller.currentRound()]
                                        .roundId ??
                                    '',
                                'isFromProfile': true,
                              },
                            );
                          } else {
                            Get.close(0);
                          }
                        },
                        onRoundExpose: () async {
                          final bool _isPurchase =
                              await controller.roundSubscription(
                            roundId: controller
                                    .rounds()[controller.currentRound()]
                                    .roundId ??
                                '',
                            paymentId: '',
                            type: SubscriptionPlanEnum.ONE_TIME,
                          );
                          if (_isPurchase) {
                            Get.close(0);
                            controller
                                .rounds(controller.rounds().map((MdRound r) {
                              if (r.roundId ==
                                  controller
                                      .rounds()[controller.currentRound()]
                                      .roundId) {
                                return MdRound(
                                  roundId: r.roundId,
                                  prompt: r.prompt,
                                  reason: r.reason,
                                  createdAt: r.createdAt,
                                  hasAccessed: true,
                                  result: r.result,
                                  rank: r.rank,
                                  selfieUrl: r.selfieUrl,
                                  reactions: r.reactions,
                                );
                              }
                              return r;
                            }).toList());
                            appSnackbar(
                              message:
                                  'You have successfully exposed this round!',
                              snackbarState: SnackbarState.success,
                            );
                            await Get.toNamed(
                              Routes.WINNER,
                              arguments: <String, dynamic>{
                                'roundId': controller
                                        .rounds()[controller.currentRound()]
                                        .roundId ??
                                    '',
                                'isFromProfile': true,
                              },
                            );
                          } else {
                            Get.close(0);
                          }
                        },
                      );
              },
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage(AppImages.buttonBg),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(28).r,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Expose Everyone 👀',
                    style: AppTextStyle.openRunde(
                      fontSize: 18.sp,
                      color: AppColors.kFAFBFB,
                      fontWeight: FontWeight.w700,
                      height: .8,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    'See how everyone placed!',
                    style: AppTextStyle.openRunde(
                      fontSize: 12.sp,
                      color: AppColors.kFAFBFB,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ).paddingAll(24.w),
          ),
        ),
      );
}

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:fvf_flutter/app/modules/ai_choosing/models/md_result.dart';
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
        () {
          final bool hasAccessed =
              controller.rounds()[controller.currentRound()].hasAccessed ??
                  false;
          return AnimatedSize(
            duration: 300.milliseconds,
            child: Visibility(
              visible: controller.currentIndex() == 1,
              child: AppButton(
                buttonText: '',
                height: 57.h,
                onPressed: () {
                  hasAccessed
                      ? Get.toNamed(
                          Routes.WINNER,
                          arguments: <String, dynamic>{
                            'roundId': controller
                                    .rounds()[controller.currentRound()]
                                    .roundId ??
                                '',
                            'isFromProfile': true,
                          },
                        )?.then((dynamic value) {
                          if (value != null && value is MdResult) {
                            final MdResult result = value;
                            final String roundId = controller
                                    .rounds()[controller.currentRound()]
                                    .roundId ??
                                '';
                            controller
                                .rounds(controller.rounds().map((MdRound r) {
                              if (r.roundId == roundId) {
                                return r.copyWith(
                                  hasAccessed: true,
                                  result: <MdResult>[result],
                                  reactions: result.reactions,
                                  rank: result.rank,
                                  reason: result.reason,
                                );
                              }
                              return r;
                            }).toList());
                          }
                        })
                      : ExposeSheet.openExposeSheet(
                          onExposedLoading: controller.isWeeklySubLoading,
                          onRoundExposeLoading: controller.isRoundSubLoading,
                          onExposed: () => _handleSubscription(
                            type: SubscriptionPlanEnum.WEEKLY,
                            successMessage:
                                'You have successfully subscribed to the weekly unlimited plan!',
                          ),
                          onRoundExpose: () => _handleSubscription(
                            type: SubscriptionPlanEnum.ONE_TIME,
                            successMessage:
                                'You have successfully exposed this round!',
                          ),
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
                      hasAccessed ? 'See Everyone 👁️' : 'Expose Everyone 👀',
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
          );
        },
      );

  Future<void> _handleSubscription({
    required SubscriptionPlanEnum type,
    required String successMessage,
  }) async {
    final String roundId =
        controller.rounds()[controller.currentRound()].roundId ?? '';

    final bool isPurchase = await controller.roundSubscription(
      roundId: roundId,
      paymentId: '',
      type: type,
    );

    if (isPurchase) {
      Get.close(0);

      /// Update hasAccessed flag
      controller.rounds(controller.rounds().map((MdRound r) {
        if (r.roundId == roundId) {
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
        message: successMessage,
        snackbarState: SnackbarState.success,
      );

      /// Navigate to Winner screen
      await Get.toNamed(
        Routes.WINNER,
        arguments: <String, dynamic>{
          'roundId': roundId,
          'isFromProfile': true,
        },
      )?.then((dynamic value) {
        if (value != null && value is MdResult) {
          final MdResult result = value;
          controller.rounds(controller.rounds().map((MdRound r) {
            if (r.roundId == roundId) {
              return r.copyWith(
                hasAccessed: true,
                result: <MdResult>[result],
                reactions: result.reactions,
                rank: result.rank,
                reason: result.reason,
              );
            }
            return r;
          }).toList());
        }
      });
    } else {
      Get.close(0);
    }
  }
}

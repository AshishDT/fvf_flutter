import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fvf_flutter/app/data/local/user_provider.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';
import 'package:fvf_flutter/app/modules/snap_selfies/widgets/selfie_avatar_icon.dart';
import 'package:fvf_flutter/app/modules/snap_selfies/widgets/user_self_participant_card.dart';
import 'package:get/get.dart';

import '../../../data/config/app_colors.dart';
import '../../../data/config/app_images.dart';
import '../../../ui/components/animated_list_view.dart';
import '../../../ui/components/app_button.dart';
import '../../../ui/components/common_app_bar.dart';
import '../../../ui/components/gradient_card.dart';
import '../../../utils/app_text_style.dart';
import '../controllers/failed_round_controller.dart';

/// Failed round view
class FailedRoundView extends GetView<FailedRoundController> {
  /// Constructor
  const FailedRoundView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.kF5FCFF,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Obx(
          () => AppButton(
            isLoading: controller.isLoading(),
            buttonText: controller.isHost ? 'Let’s Go Again' : 'Close',
            onPressed: () {
              if (controller.isHost) {
                controller.onLetsGoAgain();
                return;
              }

              Get.back();
            },
          ),
        ).paddingSymmetric(horizontal: 24),
        body: GradientCard(
          child: Align(
            alignment: Alignment.topLeft,
            child: SafeArea(
              child: AnimatedListView(
                padding: REdgeInsets.symmetric(horizontal: 24),
                children: <Widget>[
                  CommonAppBar(
                    actions: <Widget>[
                      GestureDetector(
                        onTap: () {
                          controller.shareViewOnlyLink();
                        },
                        child: SvgPicture.asset(
                          width: 24.w,
                          height: 24.h,
                          AppImages.shareIcon,
                        ),
                      )
                    ],
                  ),
                  8.verticalSpace,
                  Text(
                    controller.reason,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.openRunde(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.kffffff,
                    ),
                  ),
                  16.verticalSpace,
                  Text(
                    controller.isHost
                        ? controller.subReason
                        : 'Please ask your friend to start a new round.',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.openRunde(
                      fontSize: 20.sp,
                      color: AppColors.kF6FCFE,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  44.verticalSpace,
                  if (!controller.isViewOnly) ...<Widget>[
                    Obx(
                      () => CurrentUserSelfieAvatar(
                        participant: controller.selfParticipant(),
                        userName: globalUser().username,
                        isFromFailedView: true,
                      ),
                    ),
                    24.verticalSpace,
                  ],
                  Align(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      child: Obx(
                        () {
                          final List<MdParticipant> participants =
                              controller.participantsWithoutCurrentUser();

                          return Row(
                            spacing: 32,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List<Widget>.generate(
                              participants.length,
                              (int index) {
                                final MdParticipant participant =
                                    participants[index];

                                return SelfieAvatarIcon(
                                  participant: participant,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

import 'package:animated_digit/animated_digit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_previous_round.dart';
import 'package:fvf_flutter/app/modules/snap_selfies/widgets/animated_switcher.dart';
import 'package:fvf_flutter/app/ui/components/app_snackbar.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:fvf_flutter/app/ui/components/vibrate_wiggle.dart';
import 'package:get/get.dart';
import '../../../data/config/app_colors.dart';
import '../../../data/config/app_images.dart';
import '../../../ui/components/animated_list_view.dart';
import '../../../ui/components/app_button.dart';
import '../../../ui/components/common_app_bar.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/global_keys.dart';
import '../../create_bet/controllers/create_bet_controller.dart';
import '../controllers/snap_selfies_controller.dart';
import '../widgets/grouped_avatar_icon.dart';
import '../widgets/previous_participant_avatar.dart';
import '../widgets/selfie_avatar_icon.dart';
import '../widgets/user_self_participant_card.dart';

/// Snap selfies view
class SnapSelfiesView extends GetView<SnapSelfiesController> {
  /// Snap selfies view constructor
  const SnapSelfiesView({super.key});

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: AppColors.kF5FCFF,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _floatingActionSection(),
          body: GradientCard(
            child: Align(
              alignment: Alignment.topLeft,
              child: SafeArea(
                child: _bodyContent(context),
              ),
            ),
          ),
        ),
      );

  /// Body content
  Widget _bodyContent(BuildContext context) => AnimatedListView(
        children: <Widget>[
          Obx(
            () => Visibility(
              visible: !controller.isInvitationSend(),
              child: _appBar(),
              replacement: SizedBox(
                width: context.width,
                height: 56.h,
              ),
            ),
          ),
          8.verticalSpace,
          _promptText(),
          48.verticalSpace,
          _currentUserSelfie(context),
          24.verticalSpace,
          _emptyUsersOrParticipants(),
          _previousRoundsOrParticipants(),
          _otherParticipants(),
          16.verticalSpace,
          _resendInvites(),
        ],
      );

  /// Floating action buttons section
  Widget _floatingActionSection() => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _timerWidget(),
          _preSelfieText(),
          _addFriendsButton(),
          _snapPicButton(),
          _viewOnlyWaitingText(),
          _letsGoButton(),
        ],
      );

  /// Timer display
  Widget _timerWidget() => AnimatedSize(
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.bottomCenter,
        curve: Curves.easeInOut,
        child: Obx(
          () => Visibility(
            visible: controller.secondsLeft() > 0,
            replacement: const SizedBox(width: double.infinity),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  AppImages.timerIcon,
                  height: 24.h,
                  width: 24.w,
                ),
                Obx(
                  () => AnimatedDigitWidget(
                    duration: const Duration(milliseconds: 600),
                    separateLength: 1,
                    loop: false,
                    value: controller.secondsLeft(),
                    suffix: 's',
                    textStyle: AppTextStyle.openRunde(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.kF6FCFE,
                    ),
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: 24).paddingOnly(bottom: 16),
          ),
        ),
      );

  /// Pre-selfie text
  Widget _preSelfieText() => AnimatedSize(
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.bottomCenter,
        curve: Curves.easeInOut,
        child: Obx(
          () => Visibility(
            visible: (controller.isCurrentUserSelfieTaken() ||
                    (controller.joinedInvitationData().isViewOnly ?? false)) &&
                !controller.isTimesUp() &&
                controller.secondsLeft() > 0,
            replacement: const SizedBox(width: double.infinity),
            child: Padding(
              padding: REdgeInsets.only(
                bottom: controller.joinedInvitationData().isViewOnly ?? false
                    ? 16
                    : 32,
              ),
              child: AnimatedTextSwitcher(
                currentIndex: controller.currentIndex(),
                texts: controller.preSelfieStrings(),
              ).paddingSymmetric(horizontal: 24),
            ),
          ),
        ),
      );

  /// Add friends button
  Widget _addFriendsButton() => AnimatedSize(
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.bottomCenter,
        curve: Curves.easeInOut,
        child: Obx(
          () => Visibility(
            visible: controller.isHost() &&
                !controller.isInvitationSend() &&
                !controller.isTimesUp() &&
                !controller.isStartingRound() &&
                !(controller.joinedInvitationData().isViewOnly ?? false),
            replacement: const SizedBox(width: double.infinity),
            child: AppButton(
              buttonText: 'Add Friends',
              child: controller.isAddedFromPreviousRound()
                  ? null
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                          width: 18.w,
                          height: 18.h,
                          AppImages.shareIcon,
                          colorFilter: const ColorFilter.mode(
                            AppColors.kffffff,
                            BlendMode.srcIn,
                          ),
                        ),
                        8.horizontalSpace,
                        Text(
                          'Add Friends',
                          style: AppTextStyle.openRunde(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.kffffff,
                          ),
                        ),
                      ],
                    ),
              onPressed: () {
                if (controller.isAddedFromPreviousRound()) {
                  controller.addPreviousParticipants();
                  return;
                }
                controller.shareUri();
              },
            ).paddingSymmetric(horizontal: 24),
          ),
        ),
      );

  /// Snap Pic button
  Widget _snapPicButton() => AnimatedSize(
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.bottomCenter,
        curve: Curves.easeInOut,
        child: Obx(
          () => Visibility(
            visible: controller.isHost()
                ? controller.isInvitationSend() &&
                    !controller.isCurrentUserSelfieTaken() &&
                    controller.secondsLeft() > 0
                : !controller.isCurrentUserSelfieTaken() &&
                    controller.secondsLeft() > 0 &&
                    !(controller.joinedInvitationData().isViewOnly ?? false),
            replacement: const SizedBox(width: double.infinity),
            child: VibrateWiggle(
              trigger: controller.shouldWiggleSnapPick(),
              wiggleDuration: 800,
              child: AppButton(
                buttonText: 'Snap Pic',
                isLoading: controller.submittingSelfie(),
                onPressed: controller.onSnapSelfie,
              ).paddingSymmetric(horizontal: 24),
            ),
          ),
        ),
      );

  /// Let's Go button
  Widget _letsGoButton() => AnimatedSize(
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.bottomCenter,
        curve: Curves.easeInOut,
        child: Obx(
          () => Visibility(
            visible: ((controller.isTimesUp() && controller.isProcessing()) ||
                    controller.isStartingRound()) &&
                !(controller.joinedInvitationData().isViewOnly ?? false),
            replacement: const SizedBox(width: double.infinity),
            child: AppButton(
              buttonText: 'Let’s Go',
              isLoading:
                  controller.isProcessing() || controller.isStartingRound(),
              onPressed: () {
                if (controller.isProcessing() || controller.isStartingRound()) {
                  appSnackbar(
                    message: 'Please wait, your selfies are being processed.',
                    snackbarState: SnackbarState.warning,
                  );
                  return;
                }
                controller.onLetGo();
              },
            ).paddingSymmetric(horizontal: 24),
          ),
        ),
      );

  /// App bar
  Widget _appBar() => CommonAppBar(
        leadingIcon: AppImages.closeIconWhite,
        onTapOfLeading: () {
          Get.back();
          Get.find<CreateBetController>().refreshProfile();
        },
        actions: <Widget>[
          GestureDetector(
            onTap: controller.shareViewOnlyLink,
            child: SvgPicture.asset(
              width: 24.w,
              height: 24.h,
              AppImages.shareIcon,
            ),
          )
        ],
      ).paddingSymmetric(horizontal: 24);

  /// Prompt text
  Widget _promptText() => ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 120.h),
        child: Obx(
          () => AutoSizeText(
            controller.joinedInvitationData().prompt ?? '',
            textAlign: TextAlign.center,
            style: AppTextStyle.openRunde(
              fontSize: 40.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.kffffff,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 20,
          ),
        ).paddingSymmetric(horizontal: 24),
      );

  /// Current user selfie
  Widget _currentUserSelfie(BuildContext context) => AnimatedSize(
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.topCenter,
        curve: Curves.easeInOut,
        child: Obx(
          () => Visibility(
            visible: !(controller.joinedInvitationData().isViewOnly ?? false),
            replacement: SizedBox(width: context.width),
            child: CurrentUserSelfieAvatar(
              showWiggle: controller.shouldWiggleAddName(),
              participant: controller.selfParticipant(),
              userName: globalUser().username,
              isInvitationSend: controller.isInvitationSend(),
              onAddName: controller.onAddName,
            ),
          ),
        ),
      );

  /// Empty users or participants
  Widget _emptyUsersOrParticipants() => AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Obx(
          () => Visibility(
            visible: (!controller.isInvitationSend() &&
                    controller.previousRounds().isEmpty &&
                    controller.participantsWithoutCurrentUser().isEmpty) ||
                (controller.isInvitationSend() &&
                    controller.participantsWithoutCurrentUser().isEmpty),
            replacement: const SizedBox(width: double.infinity),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _emptyUsersPlaceholder(),
                24.horizontalSpace,
                _emptyUsersPlaceholder(),
                24.horizontalSpace,
                _emptyUsersPlaceholder(),
              ],
            ),
          ),
        ),
      );

  /// Previous rounds or added participants
  Widget _previousRoundsOrParticipants() => AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Obx(
          () => Visibility(
            visible: controller.previousRounds().isNotEmpty &&
                !controller.isInvitationSend(),
            replacement: const SizedBox(width: double.infinity),
            child: _previousParticipants(),
          ),
        ),
      );

  /// Other participants list
  Widget _otherParticipants() => Align(
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          child: Obx(
            () {
              final List<MdParticipant> participants =
                  controller.participantsWithoutCurrentUser();

              return Row(
                spacing: 24.w,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List<Widget>.generate(
                  participants.length,
                  (int index) {
                    final MdParticipant participant = participants[index];

                    return SelfieAvatarIcon(participant: participant);
                  },
                ),
              );
            },
          ),
        ),
      );

  /// Resend invites (for host)
  Widget _resendInvites() => AnimatedSize(
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.bottomCenter,
        curve: Curves.easeInOut,
        child: Obx(
          () => Visibility(
            visible: controller.secondsLeft() > 0 &&
                controller.isHost() &&
                controller.isInvitationSend(),
            child: TextButton(
              onPressed: () => controller.shareUri(fromResend: true),
              child: Text(
                'Add Invites',
                style: AppTextStyle.openRunde(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.kF1F2F2,
                ),
              ),
            ),
          ),
        ),
      );

  /// Previous participants widget
  Align _previousParticipants() => Align(
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          child: Obx(
            () {
              final List<MdPreviousRound> rounds = controller.previousRounds();
              final List<MdPreviousParticipant> added =
                  controller.previousAddedParticipants();

              final List<Widget> items = added.isEmpty
                  ? List<Widget>.generate(
                      rounds.length,
                      (int index) {
                        final MdPreviousRound participant = rounds[index];

                        return GroupAvatarIcon(
                          participants: participant.participants ??
                              <MdPreviousParticipant>[],
                          isAdded: participant.isAdded ?? false,
                          onAddTap: () => controller.onAddPreviousRound(
                            participant.id ?? '',
                          ),
                        );
                      },
                    )
                  : List<Widget>.generate(
                      added.length,
                      (int index) {
                        final MdPreviousParticipant participant = added[index];

                        return PreviousParticipantAvatarIcon(
                          participant: participant,
                          onAddTap: () =>
                              controller.onAddRemovePreviousParticipant(
                                  participant.id ?? ''),
                          isAdded: participant.isAdded ?? false,
                        );
                      },
                    );

              return Row(
                spacing: 24.w,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: items,
              );
            },
          ),
        ),
      );

  /// Empty users placeholder
  Container _emptyUsersPlaceholder() => Container(
        width: 56.w,
        height: 56.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.k2A2E2F.withValues(alpha: 0.20),
        ),
        child: Center(
          child: SvgPicture.asset(
            height: 42.h,
            width: 43.w,
            AppImages.personalPlaceholder,
            colorFilter: ColorFilter.mode(
              Colors.white.withValues(alpha: 0.20),
              BlendMode.srcIn,
            ),
          ),
        ),
      );

  Widget _viewOnlyWaitingText() => Obx(
        () => Visibility(
          visible: (controller.joinedInvitationData().isViewOnly ?? false) &&
              controller.secondsLeft() <= 0,
          replacement: const SizedBox(
            width: double.infinity,
          ),
          child: Padding(
            padding: REdgeInsets.only(
              left: 24,
              right: 24,
              bottom: 20,
            ),
            child: Text(
              'Waiting for the host to start the round...',
              textAlign: TextAlign.center,
              style: AppTextStyle.openRunde(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.kffffff.withValues(alpha: 0.80),
              ),
            ),
          ),
        ),
      );
}

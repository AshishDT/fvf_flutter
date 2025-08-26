import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';
import 'package:fvf_flutter/app/modules/winner/widgets/expose_sheet.dart';
import 'package:fvf_flutter/app/ui/components/app_button.dart';
import 'package:get/get.dart';

import '../../../data/config/app_colors.dart';
import '../../../data/config/app_images.dart';
import '../../../ui/components/animated_list_view.dart';
import '../../../ui/components/common_app_bar.dart';
import '../../../utils/app_text_style.dart';
import '../controllers/winner_controller.dart';

/// Winner View
class WinnerView extends GetView<WinnerController> {
  /// WinnerView Constructor
  const WinnerView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.kF5FCFF,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Obx(
          () => !controller.isExposed()
              ? AppButton(
                  buttonText: '',
                  height: 57.h,
                  onPressed: () {
                    ExposeSheet.openExposeSheet();
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
                ).paddingAll(24.w)
              : const SizedBox.shrink(),
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Obx(
                () => controller.participants().isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: controller
                                .participants()[controller.currentRank()]
                                .selfieUrl ??
                            '',
                        width: 1.sw,
                        height: 1.sh,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => const Center(
                            child: CircularProgressIndicator(strokeWidth: 2)),
                        errorWidget: (_, __, ___) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              AnimatedListView(
                children: <Widget>[
                  CommonAppBar(
                    leadingIcon: AppImages.closeIconWhite,
                    actions: <Widget>[
                      Container(
                        height: 34.w,
                        width: 34.w,
                        decoration: BoxDecoration(
                          color: AppColors.kFAFBFB.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          AppImages.dice,
                        ),
                      ),
                    ],
                  ).paddingOnly(left: 24.w, right: 21.w),
                  8.verticalSpace,
                  Obx(
                    () => Center(
                      child: Text(
                        controller.bet(),
                        textAlign: TextAlign.center,
                        style: AppTextStyle.openRunde(
                          fontSize: 32.sp,
                          color: AppColors.kffffff,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ).paddingSymmetric(horizontal: 24.w),
                  ),
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
                ],
              ),
              Obx(
                () {
                  if (controller.participants.isEmpty ||
                      controller.pageController == null) {
                    return const SizedBox.shrink();
                  }
                  return SizedBox(
                    height: 1.sh,
                    child: Stack(
                      children: <Widget>[
                        PageView.builder(
                          controller: controller.pageController,
                          itemCount: controller.participants().length,
                          onPageChanged: (int i) => controller.currentRank(i),
                          itemBuilder: (BuildContext context, int index) {
                            final MdParticipant participant =
                                controller.participants[index];
                            return Obx(
                              () => Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      controller.isExposed() ||
                                              participant.rank == 1
                                          ? Align(
                                              alignment: Alignment.centerRight,
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '${participant.rank ?? 0}',
                                                      style: AppTextStyle
                                                          .openRunde(
                                                        fontSize: 40.sp,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            AppColors.kffffff,
                                                      ),
                                                    ),
                                                    WidgetSpan(
                                                      alignment:
                                                          PlaceholderAlignment
                                                              .top,
                                                      child:
                                                          Transform.translate(
                                                        offset: const Offset(
                                                            2, -22),
                                                        child: Text(
                                                          getOrdinalSuffix(
                                                              participant
                                                                      .rank ??
                                                                  0),
                                                          style: AppTextStyle
                                                              .openRunde(
                                                            fontSize: 20.sp,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: AppColors
                                                                .kffffff,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                '?',
                                                style: AppTextStyle.openRunde(
                                                  fontSize: 36.sp,
                                                  color: AppColors.kffffff,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ).paddingOnly(right: 8.w),
                                      16.verticalSpace,
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: SvgPicture.asset(
                                              AppImages.smilyIcon),
                                        ),
                                      ),
                                      16.verticalSpace,
                                      Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              500.r),
                                                      child: CachedNetworkImage(
                                                        imageUrl: participant
                                                                .selfieUrl ??
                                                            '',
                                                        width: 24.w,
                                                        height: 24.w,
                                                        fit: BoxFit.cover,
                                                        placeholder: (_, __) =>
                                                            const Center(
                                                                child: CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2)),
                                                        errorWidget:
                                                            (_, __, ___) =>
                                                                const Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                                  strokeWidth:
                                                                      2),
                                                        ),
                                                      ),
                                                    ),
                                                    4.horizontalSpace,
                                                    Flexible(
                                                      child: Text(
                                                        participant.userData
                                                                ?.username ??
                                                            '',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: AppTextStyle
                                                            .openRunde(
                                                          fontSize: 24.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              AppColors.kffffff,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {},
                                                child: SvgPicture.asset(
                                                  AppImages.shareIcon,
                                                  height: 32.w,
                                                ),
                                              ),
                                            ],
                                          ),
                                          16.verticalSpace,
                                          Text(
                                            'That no-nonsense stare made it obvious',
                                            textAlign: TextAlign.center,
                                            style: AppTextStyle.openRunde(
                                              fontSize: 20.sp,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.kffffff,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ).paddingOnly(
                                  right: 24.w,
                                  left: 24.w,
                                  bottom:
                                      controller.isExposed() ? 36.h : 117.h),
                            );
                          },
                        ),
                        Obx(
                          () => controller.currentRank() != 0
                              ? Positioned(
                                  left: 6.w,
                                  top: 0,
                                  bottom: 0,
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
                                  controller.participants().length - 1
                              ? Positioned(
                                  right: 6.w,
                                  top: 0,
                                  bottom: 0,
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
      );

  /// getOrdinalSuffix
  String getOrdinalSuffix(int number) {
    if (number >= 11 && number <= 13) {
      return '${number}th';
    }
    switch (number % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}

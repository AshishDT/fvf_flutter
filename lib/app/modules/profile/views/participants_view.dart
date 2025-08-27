import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/utils.dart';

import '../../../data/config/app_colors.dart';
import '../../../data/config/app_images.dart';
import '../../../utils/app_text_style.dart';
import '../../create_bet/models/md_participant.dart';
import '../controllers/profile_controller.dart';

/// PARTICIPANTS PAGE
class ParticipantsPage extends StatelessWidget {
  /// ParticipantsPage Constructor
  const ParticipantsPage({
    required this.controller,
    super.key,
  });

  /// Profile controller
  final ProfileController controller;

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          PageView.builder(
            controller: controller.participantPageController,
            itemCount: controller.participants().length,
            onPageChanged: (int i) => controller.currentRank(i),
            itemBuilder: (BuildContext context, int index) {
              final MdParticipant participant = controller.participants[index];
              return Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Most likely to start a cult?',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.openRunde(
                        fontSize: 32.sp,
                        color: AppColors.kffffff,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {},
                            child: SvgPicture.asset(
                              AppImages.smilyIcon,
                              height: 32.w,
                            ),
                          ),
                        ),
                        16.verticalSpace,
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(500.r),
                                    child: CachedNetworkImage(
                                      imageUrl: participant.selfieUrl ?? '',
                                      width: 24.w,
                                      height: 24.w,
                                      fit: BoxFit.cover,
                                      placeholder: (_, __) => const Center(
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2)),
                                      errorWidget: (_, __, ___) => const Center(
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2)),
                                    ),
                                  ),
                                  4.horizontalSpace,
                                  Flexible(
                                    child: Text(
                                      participant.userData?.username ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyle.openRunde(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.kffffff,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: SvgPicture.asset(AppImages.shareIcon,
                                  height: 32.w),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ).paddingOnly(
                    right: 24.w,
                    left: 24.w,
                    bottom: controller.isExposed() ? 36.h : 117.h),
              );
            },
          ),

          /// Navigation
          Obx(
            () => controller.currentRank() != 0
                ? Positioned(
                    left: 12.w,
                    top: -28.h,
                    bottom: 0,
                    child: Center(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: controller.prevPage,
                        icon: SvgPicture.asset(AppImages.backwardArrow),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Obx(
            () =>
                controller.currentRank() < controller.participants().length - 1
                    ? Positioned(
                        right: 12.w,
                        top: -28.h,
                        bottom: 0,
                        child: Center(
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: controller.nextPage,
                            icon: SvgPicture.asset(AppImages.forwardArrow),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
          ),
        ],
      );
}

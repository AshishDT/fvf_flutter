import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fvf_flutter/app/routes/app_pages.dart';
import 'package:fvf_flutter/app/ui/components/app_circular_progress.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/config/app_colors.dart';
import '../../../data/config/app_images.dart';
import '../../../utils/app_text_style.dart';
import '../controllers/profile_controller.dart';
import '../repositories/edit_profile_sheet_repo.dart';
import '../widgets/edit_data_sheet.dart';
import '../widgets/profile_info_card.dart';

/// PROFILE HEADER
class ProfileHeaderSection extends StatelessWidget {
  /// Constructor
  const ProfileHeaderSection({
    required this.controller,
    super.key,
  });

  /// ProfileHeaderSection Constructor
  final ProfileController controller;

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          /// Username + Edit
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    if (controller.isCurrentUser) {
                      EditProfileSheetRepo.openEditProfile(
                        EditDataSheet(
                          navigatorTag: controller.args.tag,
                        ),
                        onComplete: controller.onAddName,
                      );
                    }
                  },
                  child: Text(
                    controller.profile().user?.username ?? 'Add Name',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.openRunde(
                      color: AppColors.kffffff,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w600,
                      shadows: <Shadow>[
                        BoxShadow(
                          offset: const Offset(0, 1),
                          blurRadius: 2,
                          color: AppColors.k000000.withValues(alpha: .75),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (controller.isCurrentUser) ...<Widget>[
                4.horizontalSpace,
                GestureDetector(
                  onTap: () {
                    if (controller.isCurrentUser) {
                      EditProfileSheetRepo.openEditProfile(
                        EditDataSheet(
                          navigatorTag: controller.args.tag,
                        ),
                        onComplete: controller.onAddName,
                      );
                    }
                  },
                  child: Obx(
                    () => controller.isLoading()
                        ? Padding(
                            padding: REdgeInsets.only(left: 10),
                            child: SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: const AppCircularProgress(
                                size: 15,
                              ),
                            ),
                          )
                        : Image.asset(
                            AppImages.shadowPen,
                            height: 18.h,
                            width: 18.w,
                          ),
                  ),
                ),
              ],
            ],
          ),
          16.verticalSpace,
          AnimatedSize(
            duration: 300.milliseconds,
            alignment: Alignment.topCenter,
            curve: Curves.easeInOut,
            child: Obx(
              () => Visibility(
                visible: !controller.isLoading() &&
                    (controller.currentBadge().badge?.isNotEmpty ?? false),
                child: Align(
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        Routes.HALL_OF_FAME,
                        arguments: controller.badges,
                      );
                    },
                    child: IntrinsicWidth(
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              8.horizontalSpace,
                              PhysicalModel(
                                color:
                                    AppColors.kF1F2F2.withValues(alpha: 0.36),
                                shadowColor:
                                    Colors.black.withValues(alpha: 0.20),
                                elevation: 2,
                                borderRadius: BorderRadius.circular(12.r),
                                child: Container(
                                  height: 22.h,
                                  padding: REdgeInsets.only(right: 8, left: 20),
                                  alignment: AlignmentDirectional.centerEnd,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(12.r),
                                      right: Radius.circular(12.r),
                                    ),
                                  ),
                                  child: Text(
                                    controller.currentBadge().badge ?? '',
                                    style: GoogleFonts.fredoka(
                                      color: AppColors.kffffff,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Container(
                              height: 24.h,
                              width: 24.w,
                              padding: REdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: <Color>[
                                    AppColors.kFB46CD,
                                    AppColors.k6C75FF,
                                    AppColors.k0DBFFF,
                                  ],
                                ),
                              ),
                              child: SvgPicture.asset(
                                controller.currentBadge().imageUrl,
                              ),
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
          Obx(
            () => Visibility(
              visible: !controller.isLoading() &&
                  (controller.currentBadge().badge?.isNotEmpty ?? false),
              child: 24.verticalSpace,
            ),
          ),

          /// Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ProfileInfoCard(
                value: '${controller.profile().round?.winsCount ?? 0}',
                title: 'Wins',
              ),
              ProfileInfoCard(
                value: '${controller.profile().round?.totalRound ?? 0}',
                title: 'Rounds',
              ),
              ProfileInfoCard(
                value: '${controller.profile().user?.emojiCount ?? 0}',
                title: 'Reactions',
              ),
            ],
          ),
          152.verticalSpace,
        ],
      );
}

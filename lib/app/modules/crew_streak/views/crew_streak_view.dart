import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';
import 'package:fvf_flutter/app/modules/crew_streak/widgets/streak_ext.dart';
import 'package:fvf_flutter/app/modules/snap_selfies/widgets/selfie_avatar_icon.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/crew_streak_controller.dart';
import '../widgets/lottie_sequence.dart';

/// CrewStreakView
class CrewStreakView extends GetView<CrewStreakController> {
  /// Constructor
  const CrewStreakView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.kF5FCFF,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: GradientCard(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                const Spacer(),
                Text(
                  'Crew Streak',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.openRunde(
                    fontSize: 40.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.kffffff,
                    height: 1,
                  ),
                ).paddingSymmetric(horizontal: 24),
                24.verticalSpace,
                Text(
                  '${30.streakInfo}',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.openRunde(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kffffff,
                  ),
                ).paddingSymmetric(horizontal: 24),
                const Spacer(),
                const LottieSequence(
                  firstLottie: AppImages.crewStreakFireSpray,
                  loopLottie: AppImages.crewStreakFire,
                ),
                16.verticalSpace,
                Container(
                  height: 24.h,
                  padding: REdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.kFB720F,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '30 Days',
                    style: GoogleFonts.fredoka(
                      color: AppColors.kffffff,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ).paddingSymmetric(horizontal: 24),
                const Spacer(),
                Align(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 32.w,
                      children: <Widget>[
                        ...controller.participants.map(
                          (MdParticipant participant) => SelfieAvatarIcon(
                            participant: participant,
                            size: 54.w,
                            showStreakEmoji: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                36.verticalSpace,
              ],
            ),
          ),
        ),
      );
}

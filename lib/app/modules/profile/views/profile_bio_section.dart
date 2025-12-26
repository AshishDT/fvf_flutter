import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fvf_flutter/app/ui/components/flying_characters.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/config/app_colors.dart';
import '../../../data/config/app_images.dart';
import '../controllers/profile_controller.dart';

/// BIO + NEXT ARROW
class ProfileBioSection extends StatelessWidget {
  /// Constructor
  const ProfileBioSection({
    required this.controller,
    super.key,
  });

  /// Controller
  final ProfileController controller;

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          if (controller.isCurrentUser) ...<Widget>[
            GestureDetector(
              onTap: () {
                controller.changeProfile();
              },
              child: Image.asset(
                AppImages.addPersonIcon,
                height: 40.h,
                color: AppColors.kF1F2F2,
              ),
            ),
            16.verticalSpace,
          ],
          if (controller.profile().user?.bio != null &&
              (controller.profile().user?.bio?.isNotEmpty ??
                  false)) ...<Widget>[
            FlyingCharacters(
              text: controller.profile().user?.bio ?? '',
              maxLines: 7,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 20.sp,
                fontStyle: FontStyle.italic,
                color: AppColors.kffffff,
                fontWeight: FontWeight.w700,
                shadows: <Shadow>[
                  BoxShadow(
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                    color: AppColors.k000000.withValues(alpha: .75),
                  ),
                ],
              ),
            ),
            16.verticalSpace,
          ],
          AnimatedSize(
            duration: 300.milliseconds,
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: Obx(
              () => Visibility(
                visible: controller.rounds().isNotEmpty,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(minWidth: 56.w, minHeight: 56.w),
                  onPressed: () {
                    controller.pageController.animateToPage(
                      1,
                      duration: 500.milliseconds,
                      curve: Curves.easeInOut,
                    );
                    controller.currentIndex(1);
                  },
                  icon: SvgPicture.asset(
                    AppImages.downSideArrow,
                    width: 42.w,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
}

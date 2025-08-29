import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/modules/profile/views/participants_view.dart';
import 'package:fvf_flutter/app/modules/profile/views/profile_bio_section.dart';
import 'package:fvf_flutter/app/modules/profile/views/profile_header.dart';
import 'package:fvf_flutter/app/modules/profile/widgets/profile_wrapper.dart';
import 'package:fvf_flutter/app/ui/components/common_app_bar.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';
import '../widgets/empty_profile_placeholder.dart';
import '../widgets/expose_button.dart';

/// ProfileView
class ProfileView extends GetView<ProfileController> {
  /// Profile view constructor
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) => Obx(
        () => PopScope(
          canPop: controller.currentIndex() == 0,
          onPopInvoked: (bool didPop) {
            if (controller.currentIndex() == 1) {
              controller.pageController.animateToPage(
                0,
                duration: 500.milliseconds,
                curve: Curves.easeInOut,
              );
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.kF5FCFF,
            resizeToAvoidBottomInset: false,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: ExposeButton(controller: controller),
            body: Stack(
              children: <Widget>[
                /// Profile Background Image
                Obx(
                  () => CachedNetworkImage(
                    imageUrl: controller.currentIndex() == 1
                        ? controller
                                .participants()[controller.currentRank()]
                                .selfieUrl ??
                            ''
                        : controller.profile().user?.profileUrl ?? '',
                    width: 1.sw,
                    height: 1.sh,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Obx(
                      () => Visibility(
                        visible: !controller.isLoading(),
                        child: const GradientCard(child: SizedBox()),
                      ),
                    ),
                    errorWidget: (_, __, ___) => Obx(
                      () => Visibility(
                        visible: !controller.isLoading(),
                        child: const GradientCard(child: SizedBox()),
                      ),
                    ),
                  ),
                ),

                /// Body
                SafeArea(
                  child: Column(
                    children: <Widget>[
                      /// AppBar
                      CommonAppBar(
                        leadingIconColor: AppColors.kFAFBFB,
                        onTapOfLeading: () {
                          if (controller.currentIndex() == 1) {
                            controller.pageController.animateToPage(
                              0,
                              duration: 500.milliseconds,
                              curve: Curves.easeInOut,
                            );
                          } else {
                            Get.back();
                          }
                        },
                        actions: <Widget>[
                          GestureDetector(
                            onTap: () {},
                            child: SvgPicture.asset(
                              AppImages.shareIcon,
                              width: 24.w,
                              height: 24.h,
                              colorFilter: const ColorFilter.mode(
                                AppColors.kFAFBFB,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 24.w),

                      /// Content
                      Expanded(
                        child: PageView(
                          controller: controller.pageController,
                          scrollDirection: Axis.vertical,
                          // physics: controller.currentIndex() == 0
                          //     ? const NeverScrollableScrollPhysics()
                          //     : null,
                          onPageChanged: (int value) {
                            controller.currentIndex(value);
                            controller.currentRank(0);
                          },
                          children: <Widget>[
                            /// Profile Page
                            Obx(
                              () => ProfileWrapper(
                                isLoading: controller.isLoading(),
                                child: Column(
                                  children: <Widget>[
                                    ProfileHeaderSection(
                                      controller: controller,
                                    ),
                                    24.verticalSpace,
                                    Obx(
                                      () => Visibility(
                                        visible: _canShowEmptyProfile(),
                                        child: const EmptyProfilePlaceholder(),
                                      ),
                                    ),
                                    const Spacer(),
                                    ProfileBioSection(
                                      controller: controller,
                                    ),
                                  ],
                                ).paddingSymmetric(horizontal: 24.w),
                              ),
                            ),

                            /// Participants Page
                            ParticipantsPage(controller: controller),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  /// Can show empty profile
  bool _canShowEmptyProfile() =>
      !controller.isLoading() &&
      (controller.profile().user?.profileUrl?.isEmpty ?? true);
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/modules/profile/views/rounds_timeline_view.dart';
import 'package:fvf_flutter/app/modules/profile/views/profile_bio_section.dart';
import 'package:fvf_flutter/app/modules/profile/views/profile_header.dart';
import 'package:fvf_flutter/app/modules/profile/widgets/profile_wrapper.dart';
import 'package:fvf_flutter/app/ui/components/common_app_bar.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:fvf_flutter/app/utils/widget_ext.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../widgets/empty_profile_placeholder.dart';

/// ProfileView
class ProfileView extends GetView<ProfileController> {
  /// Profile view constructor
  const ProfileView({
    required this.navigatorTag,
    super.key,
  });

  /// Navigator tag
  final String navigatorTag;

  @override
  String? get tag => navigatorTag;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ProfileController(), tag: navigatorTag);
    return Obx(
      () => PopScope(
        canPop: controller.currentIndex() == 0 && !controller.isLoading(),
        onPopInvokedWithResult: (bool didPop, Object? value) {
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
          body: GradientCard(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: RefreshIndicator(
                    color: AppColors.k787C82,
                    backgroundColor: AppColors.kF5FCFF,
                    onRefresh: () async {
                      await controller.getUser();
                      await controller.getRounds(
                        isRefresh: true,
                      );
                    },
                    child: PageView(
                      controller: controller.pageController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      onPageChanged: (int value) {
                        if (controller.isLoading()) {
                          return;
                        }
                        controller.currentIndex(value);
                        if (controller.rounds().isNotEmpty) {
                          controller.roundPageController.jumpToPage(
                            controller.currentRound(),
                          );
                        }
                      },
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            AnimatedSize(
                              duration: 300.milliseconds,
                              curve: Curves.easeInOut,
                              reverseDuration: 300.milliseconds,
                              child: Obx(
                                () => Visibility(
                                  visible: !controller.isLoading(),
                                  replacement: SizedBox(
                                    width: 1.sw,
                                    height: 1.sh,
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        controller.profile().user?.profileUrl ??
                                            '',
                                    width: 1.sw,
                                    height: 1.sh,
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) => Obx(
                                      () => Visibility(
                                        visible: !controller.isLoading(),
                                        child: const GradientCard(
                                            child: SizedBox()),
                                      ),
                                    ),
                                    errorWidget: (_, __, ___) => Obx(
                                      () => Visibility(
                                        visible: !controller.isLoading(),
                                        child: const GradientCard(
                                            child: SizedBox()),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Obx(
                              () => ProfileWrapper(
                                isLoading: controller.isLoading(),
                                child: Column(
                                  children: <Widget>[
                                    75.verticalSpace,
                                    ProfileHeaderSection(
                                      controller: controller,
                                    ),
                                    24.verticalSpace,
                                    Obx(
                                      () => Visibility(
                                        visible: _canShowEmptyProfile(),
                                        child: EmptyProfilePlaceholder(
                                          navigatorTag: navigatorTag,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    ProfileBioSection(
                                      controller: controller,
                                    ),
                                    20.verticalSpace,
                                  ],
                                ).paddingSymmetric(horizontal: 24.w),
                              ),
                            ),
                            Positioned(
                              top: 30,
                              left: 24,
                              right: 24,
                              child: CommonAppBar(
                                leadingIconColor: AppColors.kFAFBFB,
                                onTapOfLeading: () {
                                  if (controller.isLoading()) {
                                    return;
                                  }
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
                                      AppImages.moreVertical,
                                      width: 24.w,
                                      height: 24.h,
                                      colorFilter: const ColorFilter.mode(
                                        AppColors.kFAFBFB,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        /// Participants Page
                        if (controller.rounds().isNotEmpty)
                          RoundsTimeLinesView(controller: controller),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).withGPad(context),
      ),
    );
  }

  /// Can show empty profile
  bool _canShowEmptyProfile() =>
      !controller.isLoading() &&
      (controller.profile().user?.profileUrl?.isEmpty ?? true);
}

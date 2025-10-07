import 'dart:io';
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
            Future<void>.delayed(
              const Duration(milliseconds: 600),
              () {
                controller.getRounds(
                  isRefresh: true,
                );
              },
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
                      onPageChanged: _onPageChange,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            AnimatedSize(
                              duration: 300.milliseconds,
                              curve: Curves.easeInOut,
                              reverseDuration: 300.milliseconds,
                              child: Obx(
                                () {
                                  if (controller.isLoading()) {
                                    return SizedBox(
                                      width: 1.sw,
                                      height: 1.sh,
                                    );
                                  }

                                  final String localPath =
                                      controller.image().path;
                                  final String profileUrl =
                                      controller.profile().user?.profileUrl ??
                                          '';

                                  Widget child;

                                  if (localPath.isNotEmpty) {
                                    child = Image.file(
                                      File(localPath),
                                      width: 1.sw,
                                      height: 1.sh,
                                      fit: BoxFit.cover,
                                      key: const ValueKey<String>(
                                        'local_image',
                                      ),
                                    );
                                  } else if (profileUrl.isNotEmpty) {
                                    child = CachedNetworkImage(
                                      imageUrl: profileUrl,
                                      width: 1.sw,
                                      height: 1.sh,
                                      fit: BoxFit.cover,
                                      placeholder: (_, __) =>
                                          const GradientCard(
                                        child: SizedBox(),
                                      ),
                                      errorWidget: (_, __, ___) =>
                                          const GradientCard(
                                        child: SizedBox(),
                                      ),
                                      key: const ValueKey<String>(
                                        'network_image',
                                      ),
                                    );
                                  } else {
                                    child = const GradientCard(
                                      key: ValueKey<String>('placeholder'),
                                      child: SizedBox(),
                                    );
                                  }

                                  return AnimatedSwitcher(
                                    duration: 400.milliseconds,
                                    switchInCurve: Curves.easeInOut,
                                    switchOutCurve: Curves.easeInOut,
                                    transitionBuilder: (Widget child,
                                            Animation<double> animation) =>
                                        FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    ),
                                    child: child,
                                  );
                                },
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

                                    Future<void>.delayed(
                                      const Duration(milliseconds: 600),
                                      () {
                                        controller.getRounds(
                                          isRefresh: true,
                                        );
                                      },
                                    );

                                    controller.noScreenshot.screenshotOn();
                                  } else {
                                    Get.back();
                                    controller.noScreenshot.screenshotOn();
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

  /// On page change
  void _onPageChange(int value) {
    if (value == 0) {
      controller.noScreenshot.screenshotOn();
    }

    if (controller.isLoading()) {
      return;
    }

    controller.currentIndex(value);

    if (value == 1 && controller.rounds().isNotEmpty) {
      final int roundIndex = controller.currentRound();

      final RxInt? rxIndex = controller.roundCurrentResultIndex[roundIndex];
      final PageController? innerPC =
          controller.roundInnerPageController[roundIndex];

      if (rxIndex != null && innerPC != null) {
        rxIndex(0);
        rxIndex.refresh();
        if (innerPC.hasClients) {
          innerPC.jumpToPage(0);
        }

        controller.roundWiggleMark[roundIndex]?.call(false);
        controller.roundWiggleMark[roundIndex]?.refresh();

        controller.updateRoundScreenshotPermission(roundIndex);
      }

      controller.roundPageController.jumpToPage(roundIndex);
    }
  }
}

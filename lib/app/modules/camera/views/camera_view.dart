import 'package:animated_digit/animated_digit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/modules/camera/widgets/retake_button.dart';
import 'package:fvf_flutter/app/ui/components/common_app_bar.dart';
import 'package:fvf_flutter/app/utils/widget_ext.dart';
import 'package:get/get.dart';

import '../../../utils/app_text_style.dart';
import '../controllers/camera_controller.dart';

/// Camera View is a widget that displays the camera interface.
class CameraView extends GetView<PickSelfieCameraController> {
  /// Creates a new instance of CameraView.
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: AppColors.kF5FCFF,
          body: Obx(
            () {
              if (!controller.isCameraInitialized()) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.previewFile().path.isNotEmpty) {
                return Stack(
                  children: <Widget>[
                    SizedBox(
                      height: 1.sh,
                      child: Image.file(
                        controller.previewFile.value,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        32.verticalSpace,
                        _appBar(),
                        const Spacer(),
                        Center(
                          child: AutoSizeText(
                            controller.prompt,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: AppTextStyle.openRunde(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.kffffff,
                              shadows: <Shadow>[
                                BoxShadow(
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                  color:
                                      AppColors.k000000.withValues(alpha: .75),
                                ),
                              ],
                            ),
                          ),
                        ).paddingSymmetric(horizontal: 24.w),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          alignment: Alignment.bottomCenter,
                          curve: Curves.easeInOut,
                          child: Obx(
                            () => Visibility(
                              visible: controller.canShowRetake(),
                              child: 55.verticalSpace,
                            ),
                          ),
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          alignment: Alignment.bottomCenter,
                          curve: Curves.easeInOut,
                          child: Obx(
                            () => Visibility(
                              visible: controller.canShowRetake(),
                              child: RetakeButton(
                                onRetake: () async => controller.onRetake(),
                              ),
                            ),
                          ),
                        ),
                        49.verticalSpace,
                      ],
                    ),
                  ],
                );
              }

              return Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  CameraPreview(
                    controller.cameraController!,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        32.verticalSpace,
                        _appBar(),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        AutoSizeText(
                          controller.prompt,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.openRunde(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.kffffff,
                            shadows: <Shadow>[
                              BoxShadow(
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                                color: AppColors.k000000.withValues(alpha: .75),
                              ),
                            ],
                          ),
                        ).paddingSymmetric(horizontal: 24.w),
                        45.verticalSpace,
                        Container(
                          height: 100.h,
                          width: Get.width,
                          alignment: Alignment.topCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 24.h,
                                width: 24.w,
                              ),
                              50.horizontalSpace,
                              GestureDetector(
                                onTap: () {
                                  controller.takePicture();
                                },
                                child: SvgPicture.asset(
                                  AppImages.clickSelfieIcon,
                                ),
                              ),
                              50.horizontalSpace,
                              GestureDetector(
                                onTap: () {
                                  controller.flipCamera();
                                },
                                child: SvgPicture.asset(
                                  AppImages.flipCamera,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ).withGPad(context, color: Colors.black),
      );

  Widget _appBar() => CommonAppBar(
        onTapOfLeading: controller.onTimerFinished,
        actions: <Widget>[
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            alignment: Alignment.bottomCenter,
            curve: Curves.easeInOut,
            child: Obx(
              () => Visibility(
                visible: controller.secondsLeft() > 0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(
                      AppImages.timerIcon,
                      height: 18.h,
                      width: 18.w,
                    ),
                    Obx(
                      () => AnimatedDigitWidget(
                        duration: const Duration(milliseconds: 600),
                        separateLength: 1,
                        loop: false,
                        value: controller.secondsLeft(),
                        suffix: 's',
                        textStyle: AppTextStyle.openRunde(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.kF6FCFE,
                          shadows: <Shadow>[
                            const Shadow(
                              offset: Offset(0, 4),
                              blurRadius: 4,
                              color: Color(0x33000000),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ).paddingSymmetric(horizontal: 24);
}

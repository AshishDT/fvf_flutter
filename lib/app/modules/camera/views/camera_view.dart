import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
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
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.kF5FCFF,
        bottomNavigationBar: Container(
          height: 154.h,
          width: Get.width,
          color: AppColors.k000000,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  controller.takePicture();
                },
                child: SvgPicture.asset(
                  AppImages.clickSelfieIcon,
                ),
              ),

              Positioned(
                right: Get.width / 2 - 150,
                child: GestureDetector(
                  onTap: (){
                    controller.flipCamera();
                  },
                  child: SvgPicture.asset(
                    AppImages.flipCamera,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Obx(
          () {
            if (!controller.isCameraInitialized()) {
              return const Center(child: CircularProgressIndicator());
            }

            return CameraPreview(
              controller.cameraController!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  32.verticalSpace,
                  _appBar(),
                ],
              ),
            );
          },
        ),
      ).withGPad(context, color: Colors.black);

  Widget _appBar() => CommonAppBar(
        actions: <Widget>[
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            alignment: Alignment.bottomCenter,
            curve: Curves.easeInOut,
            child: Obx(
              () => Visibility(
                visible: controller.secondsLeft() > 0,
                child: Text(
                  '${controller.secondsLeft().toString()}s',
                  style: AppTextStyle.openRunde(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kffffff,
                  ),
                ),
              ),
            ),
          )
        ],
      ).paddingSymmetric(horizontal: 24);
}

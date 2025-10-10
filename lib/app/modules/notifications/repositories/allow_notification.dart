import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/ui/components/app_button.dart';
import 'package:fvf_flutter/app/ui/components/app_snackbar.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';

import '../../../data/config/app_colors.dart';
import '../../../data/local/store/local_store.dart';
import '../../../ui/components/gradient_card.dart';

/// Service to show allow notification permission sheet
class AllowNotification {
  /// Show permission sheet only if notifications are not granted

  /// Show the allow notification permission sheet
  static Future<void> show({
    required String roundId,
  }) async {
    final PermissionStatus currentStatus = await Permission.notification.status;

    if (currentStatus.isGranted) {
      return;
    }

    final bool alreadyShown = LocalStore.notificationSheetId() == roundId;

    if (alreadyShown) {
      return;
    }

    LocalStore.notificationSheetId(roundId);

    final RxBool isLoading = false.obs;

    await showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Obx(
        () => _AllowNotificationSheet(
          isLoading: isLoading.value,
          onAllow: () async {
            final PermissionStatus statusBeforeRequest =
                await Permission.notification.status;

            if (statusBeforeRequest.isPermanentlyDenied) {
              await AppSettings.openAppSettings(
                  type: AppSettingsType.notification);
              return;
            }

            isLoading(true);
            final PermissionStatus status =
                await Permission.notification.request();
            isLoading(false);

            if (status.isGranted) {
              Get.back();
              appSnackbar(
                message: 'Notification permission granted',
                snackbarState: SnackbarState.success,
              );
            } else {
              Get.back();
              appSnackbar(
                message: 'Notification permission denied',
                snackbarState: SnackbarState.danger,
              );
            }
          },
        ),
      ),
    );
  }
}

class _AllowNotificationSheet extends StatelessWidget {
  const _AllowNotificationSheet({
    required this.onAllow,
    required this.isLoading,
  });

  /// Callback when user taps on allow button
  final VoidCallback onAllow;

  /// Whether the permission request is in progress
  final bool isLoading;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: GradientCard(
            padding: REdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24.r),
            ),
            child: Padding(
              padding: REdgeInsets.only(
                bottom: _bottom(context),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    child: Container(
                      height: 4.h,
                      width: 48.w,
                      decoration: BoxDecoration(
                        color: AppColors.kF1F2F2.withValues(alpha: .42),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  24.verticalSpace,
                  Center(
                    child: Container(
                      height: 48.w,
                      width: 48.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.k2A2E2F.withValues(alpha: 0.16),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppImages.notificationIcon,
                        ),
                      ),
                    ),
                  ),
                  16.verticalSpace,
                  Center(
                    child: Text(
                      'Allow Notifications',
                      style: AppTextStyle.openRunde(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.kffffff,
                      ),
                    ),
                  ),
                  16.verticalSpace,
                  Center(
                    child: Text(
                      'Never miss a slay',
                      style: AppTextStyle.openRunde(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.kFAFBFB,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  24.verticalSpace,
                  const Image(
                    image: AssetImage(
                      AppImages.notificationAllowPlaceholder,
                    ),
                  ),
                  30.verticalSpace,
                  AppButton(
                    isLoading: isLoading,
                    buttonText: 'Allow Notifications',
                    onPressed: onAllow,
                  )
                ],
              ),
            ),
          ),
        ),
      );

  double _bottom(BuildContext context) =>
      MediaQuery.of(context).systemGestureInsets.bottom > 12
          ? MediaQuery.of(context).systemGestureInsets.bottom - 12
          : MediaQuery.of(context).systemGestureInsets.bottom;
}

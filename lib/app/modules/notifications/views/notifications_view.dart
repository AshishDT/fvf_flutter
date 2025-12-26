import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fvf_flutter/app/modules/notifications/models/md_notification.dart';
import 'package:fvf_flutter/app/utils/widget_ext.dart';
import 'package:get/get.dart';
import '../../../data/config/app_colors.dart';
import '../../../data/config/app_images.dart';
import '../../../ui/components/common_app_bar.dart';
import '../../../ui/components/gradient_card.dart';
import '../../../utils/app_text_style.dart';
import '../controllers/notifications_controller.dart';
import '../widgets/notification_card.dart';
import '../widgets/notification_wrapper.dart';

/// Notifications View
class NotificationsView extends GetView<NotificationsController> {
  /// Constructor
  NotificationsView({super.key});

  @override
  final NotificationsController controller =
      Get.find<NotificationsController>();

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.kF5FCFF,
        body: GradientCard(
          padding: REdgeInsets.symmetric(horizontal: 24),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const CommonAppBar(
                  leadingIcon: AppImages.closeIconWhite,
                ),
                20.verticalSpace,
                Text(
                  'Notifications',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.openRunde(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kF1F2F2,
                  ),
                ),
                22.verticalSpace,
                Expanded(
                  child: Obx(
                    () => NotificationWrapper(
                      isLoading: controller.isLoading(),
                      child: AnimationLimiter(
                        child: RefreshIndicator(
                          color: AppColors.k787C82,
                          backgroundColor: AppColors.kF5FCFF,
                          onRefresh: () async {
                            await controller.getNotifications();
                          },
                          child: controller.notifications().isNotEmpty
                              ? ListView.builder(
                                  itemCount: controller.notifications().length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final MdNotification notification =
                                        controller.notifications()[index];
                                    return NotificationCard(
                                      onTap: (){
                                        controller.onNotificationTap(
                                          notification,
                                        );
                                      },
                                      title: notification.title ??
                                          'Notification - Slay',
                                      subtitle: notification.body,
                                      time: notification.createdAt ??
                                          DateTime.now(),
                                    ).animate(
                                      position: index,
                                    );
                                  },
                                )
                              : Center(
                                  child: Text(
                                    'No notifications available',
                                    style: AppTextStyle.openRunde(
                                      fontSize: 16.sp,
                                      color: AppColors.kD9DEDF.withValues(
                                        alpha: 0.48,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

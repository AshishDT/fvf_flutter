import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/modules/claim_phone/controllers/claim_phone_controller.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:get/get.dart';
import '../../../data/config/app_colors.dart';
import '../../report_app/controllers/report_app_service.dart';

/// More Sheet widget (non-draggable, keyboard-aware)
class MoreSheet extends GetView<ClaimPhoneController> {
  /// More sheet
  const MoreSheet({super.key});

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
                  16.verticalSpace,
                  _drawerTile(
                    icon: AppImages.reportFlag,
                    title: 'Report',
                    onTap: () {
                      Get.close(0);
                      ReportAppService.open();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  /// Bottom
  double _bottom(BuildContext context) =>
      MediaQuery.of(context).systemGestureInsets.bottom > 12
          ? MediaQuery.of(context).systemGestureInsets.bottom - 12
          : MediaQuery.of(context).systemGestureInsets.bottom;

  ListTile _drawerTile({
    required String icon,
    required String title,
    VoidCallback? onTap,
  }) =>
      ListTile(
        onTap: () {
          onTap?.call();
        },
        minVerticalPadding: 0,
        contentPadding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        leading: SvgPicture.asset(
          icon,
          width: 24.w,
          height: 24.h,
        ),
        title: Text(
          title,
          style: AppTextStyle.openRunde(
            fontSize: 18.sp,
            color: AppColors.kFAFBFB,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
}

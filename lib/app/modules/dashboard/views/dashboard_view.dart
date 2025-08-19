import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/modules/dashboard/widgets/select_language.dart';
import 'package:fvf_flutter/generated/locales.g.dart';
import '../../../data/config/app_colors.dart';
import '../../../ui/components/app_bar_common.dart';
import '../controllers/dashboard_controller.dart';

/// Dashboard View
class DashboardView extends GetView<DashboardController> {
  /// Constructor for DashboardView
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.kffffff,
        appBar: AppBarCommon(
          title: LocaleKeys.dashboard.tr,
          canShowBack: false,
          leading: Center(
            child: Padding(
              padding: REdgeInsets.only(left: 10),
              child: Image(
                height: 30.h,
                width: 30.w,
                image: const AssetImage(
                  AppImages.appLogo,
                ),
              ),
            ),
          ),
          actions: <Widget>[
            SelectLanguage(
              onSelect: controller.onLanguageChange,
            ),
            10.horizontalSpace,
          ],
        ),
        body: Align(
          alignment: Alignment.topLeft,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: <Widget>[],
          ),
        ),
      );
}

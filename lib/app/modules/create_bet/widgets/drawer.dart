import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/modules/create_bet/controllers/create_bet_controller.dart';
import 'package:fvf_flutter/app/modules/create_bet/widgets/phone_number_sheet.dart';
import 'package:fvf_flutter/app/ui/components/animated_column.dart';
import 'package:fvf_flutter/app/ui/components/common_app_bar.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// Menu Drawer
class MenuDrawer extends StatelessWidget {
  /// Menu Drawer constructor
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
        width: 1.sw,
        child: GradientCard(
          padding: REdgeInsets.symmetric(horizontal: 24),
          child: SafeArea(
            child: AnimatedColumn(
              showScaleAnimation: true,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const CommonAppBar(
                  leadingIcon: AppImages.closeIconWhite,
                  leadingIconColor: AppColors.kF1F2F2,
                ),
                21.verticalSpace,
                Text(
                  'Menu',
                  style: AppTextStyle.openRunde(
                    fontSize: 24.sp,
                    color: AppColors.kF1F2F2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                22.verticalSpace,
                _drawerTile(
                  icon: AppImages.billingIcon,
                  title: 'Billing',
                  onTap: () {
                    final CreateBetController controller =
                        Get.find<CreateBetController>();
                    controller.isSmartAuthShowed(false);
                    controller.phoneController.clear();
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (BuildContext context) => const PhoneNumberSheet(),
                    );
                  },
                ),
                _drawerTile(
                  icon: AppImages.helpIcon,
                  title: 'Help',
                ),
                _drawerTile(
                  icon: AppImages.mailIcon,
                  title: 'Give us feedback!',
                ),
              ],
            ),
          ),
        ),
      );

  /// Drawer Tile
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
        leading: SvgPicture.asset(icon),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            color: AppColors.kF1F2F2,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
}

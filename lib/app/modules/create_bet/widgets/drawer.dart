import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/data/local/user_provider.dart';
import 'package:fvf_flutter/app/modules/claim_phone/controllers/phone_claim_service.dart';
import 'package:fvf_flutter/app/ui/components/animated_column.dart';
import 'package:fvf_flutter/app/ui/components/common_app_bar.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:fvf_flutter/app/utils/app_config.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:fvf_flutter/app/utils/global_keys.dart';
import 'package:fvf_flutter/app/utils/package_info.dart';
import 'package:fvf_flutter/app/utils/widget_ext.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

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
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Obx(
                    () => Visibility(
                      visible: globalUser().canShowLogin,
                      child: _drawerTile(
                        icon: AppImages.personIcon,
                        title: 'Login',
                        onTap: () {
                          PhoneClaimService.open(
                            fromLogin: true,
                            fromMenu: true,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                _drawerTile(
                  icon: AppImages.billingIcon,
                  title: 'Billing',
                  onTap: () {},
                ),
                _drawerTile(
                  icon: AppImages.chatIcon,
                  title: 'Chat with Founders!',
                  onTap: () {},
                ),
                _drawerTile(
                  icon: AppImages.shareIcon,
                  title: 'Share Slay',
                  onTap: () {
                    shareSlay();
                  },
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Obx(
                    () => Visibility(
                      visible: !globalUser().canShowLogin,
                      child: _drawerTile(
                        icon: AppImages.logOutIcon,
                        title: 'Log-out',
                        size: 22,
                        iconColor: AppColors.kffffff,
                        onTap: () {
                          UserProvider.onLogout();
                        },
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Align(
                  child: Text(
                    'v ${PackageInfoRepo.version}',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: AppColors.kF1F2F2.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ).withGPad(context);

  /// Share Slay
  void shareSlay() {
    final Uri uri = Uri.parse(AppConfig.appUrl);

    SharePlus.instance.share(
      ShareParams(
        uri: uri,
      ),
    );
  }

  /// Drawer Tile
  ListTile _drawerTile({
    required String icon,
    required String title,
    VoidCallback? onTap,
    Color? iconColor,
    double? size,
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
          height: size ?? 24,
          width: size ?? 24,
          colorFilter: iconColor != null
              ? ColorFilter.mode(
                  iconColor,
                  BlendMode.srcIn,
                )
              : null,
        ),
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/modules/profile/models/md_badge.dart';
import 'package:fvf_flutter/app/ui/components/animated_column.dart';
import 'package:fvf_flutter/app/ui/components/animated_list_view.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:get/get.dart';
import '../../../data/config/app_colors.dart';
import '../../../ui/components/common_app_bar.dart';
import '../../../ui/components/gradient_card.dart';
import '../controllers/hall_of_fame_controller.dart';
import '../widgets/fame_card.dart';

/// Hall of fame view
class HallOfFameView extends GetView<HallOfFameController> {
  /// Constructor
  const HallOfFameView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.kF5FCFF,
        body: GradientCard(
          child: SafeArea(
            child: AnimatedListView(
              children: <Widget>[
                const CommonAppBar(
                  leadingIconColor: AppColors.kFAFBFB,
                ).paddingSymmetric(horizontal: 24),
                64.verticalSpace,
                Center(
                  child: Text(
                    'Hall of Fame',
                    style: AppTextStyle.openRunde(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.kffffff,
                    ),
                  ),
                ),
                42.verticalSpace,
                Center(
                  child: AnimatedColumn(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List<Widget>.generate(
                      controller.badges().length,
                      (int index) {
                        final MdBadge badge = controller.badges()[index];
                        return FameCard(
                          description: badge.description ?? '',
                          imageUrl: badge.imageUrl,
                          name: badge.badge ?? '',
                          isActive: badge.earned ?? false,
                          isCurrent: badge.current ?? false,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

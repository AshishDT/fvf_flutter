import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/modules/hall_of_fame/models/md_hall_of_fame.dart';
import 'package:fvf_flutter/app/ui/components/animated_list_view.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:fvf_flutter/app/utils/widget_ext.dart';
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
              showScaleAnimation: true,
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List<Widget>.generate(
                      controller.hallOfFameList.length,
                          (int index) {
                        final MdHallOfFame fame = controller.hallOfFameList[index];
                        return FameCard(
                          description: fame.description ?? '',
                          imageUrl: fame.imageUrl ?? '',
                          name: fame.name ?? '',
                        ).animate(position: index);
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

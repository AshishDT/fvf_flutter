import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/ui/components/animated_list_view.dart';
import 'package:fvf_flutter/app/ui/components/app_button.dart';

import 'package:get/get.dart';

import '../../../ui/components/common_app_bar.dart';
import '../../../ui/components/gradient_card.dart';
import '../controllers/create_bet_controller.dart';

/// Create Bet View
class CreateBetView extends GetView<CreateBetController> {
  /// Constructor
  const CreateBetView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.kF5FCFF,
        body: GradientCard(
          child: Align(
            alignment: Alignment.topLeft,
            child: SafeArea(
              child: AnimatedListView(
                padding: REdgeInsets.symmetric(horizontal: 24),
                children: <Widget>[
                  const CommonAppBar(),
                  64.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      );
}

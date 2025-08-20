import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/modules/create_bet/widgets/work_space_sheet_repo.dart';
import 'package:fvf_flutter/app/routes/app_pages.dart';
import 'package:fvf_flutter/app/ui/components/animated_list_view.dart';
import 'package:fvf_flutter/app/ui/components/app_button.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
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
        floatingActionButton: AppButton(
          buttonText: 'Bet',
          onPressed: () {
            Get.toNamed(Routes.PICK_CREW);
          },
        ).paddingSymmetric(horizontal: 24),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: GradientCard(
          child: Align(
            alignment: Alignment.topLeft,
            child: SafeArea(
              child: AnimatedListView(
                padding: REdgeInsets.symmetric(horizontal: 24),
                children: <Widget>[
                  const CommonAppBar(),
                  64.verticalSpace,
                  GradientCard(
                    padding: REdgeInsets.symmetric(
                      vertical: 31,
                      horizontal: 24,
                    ),
                    borderRadius: BorderRadius.circular(32.r),
                    constraints: BoxConstraints(maxHeight: 120.h),
                    bgImage: AppImages.contentCardBg,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Obx(
                            () => AutoSizeText(
                              controller.enteredBet().isNotEmpty
                                  ? controller.enteredBet()
                                  : 'Most likely to start an OF?',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 20,
                              style: AppTextStyle.openRunde(
                                color: AppColors.kffffff,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ),
                        16.horizontalSpace,
                        Image.asset(AppImages.dice),
                      ],
                    ),
                  ),
                  24.verticalSpace,
                  AppButton(
                    buttonText: '',
                    buttonColor: AppColors.kF1F2F2.withValues(alpha: 0.36),
                    onPressed: () {
                      if (controller.enteredBet().isNotEmpty) {
                        controller.messageInputController.text =
                            controller.enteredBet();
                      }

                      WorkSpaceSheetRepo.openChatField();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Or write your own',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.openRunde(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.kffffff,
                          ),
                        ),
                        4.horizontalSpace,
                        Image.asset(
                          AppImages.pencilIcon,
                          height: 32.h,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/ui/components/app_button.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:fvf_flutter/app/utils/widget_ext.dart';
import '../../../data/enums/purchase_plans.dart';

/// SlayingSheetView
class SlayingSheetView extends StatelessWidget {
  /// SlayingSheetView Constructor
  const SlayingSheetView({
    super.key,
    this.onUnlimitedSlayed,
    this.onSlayed,
  });

  /// On Slayed callback
  final VoidCallback? onSlayed;

  /// On Unlimited Slayed callback
  final VoidCallback? onUnlimitedSlayed;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: GradientCard(
          alignment: AlignmentDirectional.topStart,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24.r),
          ),
          padding: REdgeInsets.only(
            top: 24,
            left: 24,
            right: 24,
            bottom: 36,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  'You Slayed your ass off 🚀',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.openRunde(
                    color: AppColors.kffffff,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              24.verticalSpace,
              _planInfoCard(PurchasePlan.plan1),
              24.verticalSpace,
              Row(
                children: <Widget>[
                  _divider(),
                  10.horizontalSpace,
                  Text(
                    'OR',
                    style: AppTextStyle.openRunde(
                      fontSize: 16.sp,
                      color: AppColors.kffffff.withValues(alpha: .36),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  10.horizontalSpace,
                  _divider(),
                ],
              ),
              20.verticalSpace,
              _planInfoCard(PurchasePlan.plan2),
            ],
          ),
        ).withGPad(context,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24.r),
              ),
            )),
      );

  /// _divider
  Expanded _divider() => Expanded(
        child: Divider(
          thickness: 2.h,
          radius: BorderRadius.circular(1),
          color: AppColors.kffffff.withValues(alpha: .36),
        ),
      );

  /// _planInfoCard
  Container _planInfoCard(PurchasePlan plan) => Container(
        padding: REdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28.r),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: plan == PurchasePlan.plan1
                ? <Color>[
                    AppColors.k13C4E5,
                    AppColors.k13C4E5.withValues(alpha: .36),
                  ]
                : <Color>[
                    AppColors.kF04164,
                    AppColors.kF04164.withValues(alpha: .94),
                  ],
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: const Offset(0, 1),
              blurRadius: 2,
              color: AppColors.k000000.withValues(alpha: .2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              plan == PurchasePlan.plan1
                  ? 'One More Slay - \$0.99'
                  : 'Unlimited Slays - \$5.99/w',
              style: AppTextStyle.openRunde(
                fontSize: 18.sp,
                color: AppColors.kffffff,
                fontWeight: FontWeight.w600,
              ),
            ),
            8.verticalSpace,
            Text(
              plan == PurchasePlan.plan1
                  ? 'Jump back in instantly'
                  : ' •  Slay all day 🚀\n'
                      ' •  Every ranking, every reason\n'
                      ' •  Verified badge, flex unlocked\n',
              style: AppTextStyle.openRunde(
                fontSize: 14.sp,
                color: AppColors.kffffff,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            plan == PurchasePlan.plan1 ? 16.verticalSpace : 1.verticalSpace,
            plan == PurchasePlan.plan1
                ? AppButton(
                    height: 42.h,
                    buttonText: '',
                    decoration: BoxDecoration(
                      color: AppColors.kFFC300,
                      borderRadius: BorderRadius.circular(28.r),
                    ),
                    onPressed: () {
                      onSlayed?.call();
                    },
                    style: AppTextStyle.openRunde(
                      fontSize: 16.sp,
                      color: AppColors.k2A2E2F,
                      fontWeight: FontWeight.w600,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                          AppImages.shineIcon,
                          height: 18.w,
                          width: 18.w,
                        ),
                        Text(
                          'Jump Back In',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.openRunde(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.k2A2E2F,
                          ),
                        ),
                      ],
                    ),
                  )
                : AppButton(
                    buttonText: '🔥 Go Without Limits',
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28.r),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const <double>[0, 0.0],
                        colors: <Color>[
                          AppColors.kFFC300,
                          AppColors.kFFC300.withValues(alpha: .72),
                        ],
                      ),
                    ),
                    onPressed: () {
                      onUnlimitedSlayed?.call();
                    },
                    style: AppTextStyle.openRunde(
                      fontSize: 18.sp,
                      color: AppColors.kffffff,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ],
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/ui/components/app_button.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:fvf_flutter/app/utils/widget_ext.dart';
import 'package:get/get.dart';

/// AIPlan enum
enum AIPlan {
  PLAN1,
  PLAN2,
}

/// ExposeSheetView
class ExposeSheetView extends StatelessWidget {
  /// ExposeSheetView Constructor
  ExposeSheetView({
    super.key,
    this.onExposed,
    this.onRoundExpose,
    this.onExposedLoading,
    this.onRoundExposeLoading,
  });

  /// On round expose callback
  VoidCallback? onRoundExpose;

  /// On exposed callback
  VoidCallback? onExposed;

  /// onExposedLoading
  RxBool? onExposedLoading = false.obs;

  /// onRoundExposeLoading
  RxBool? onRoundExposeLoading = false.obs;

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
              Text(
                '👀 Make the AI spill it all...',
                style: AppTextStyle.openRunde(
                  color: AppColors.kffffff,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              24.verticalSpace,
              _planInfoCard(AIPlan.PLAN1),
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
              _planInfoCard(AIPlan.PLAN2),
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
  Container _planInfoCard(AIPlan plan) => Container(
        padding: REdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28.r),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: plan == AIPlan.PLAN1
                ? <Color>[
                    AppColors.k13C4E5,
                    AppColors.k13C4E5.withValues(alpha: .36),
                  ]
                : <Color>[
                    AppColors.kF04164,
                    AppColors.kF04164.withValues(alpha: .94),
                  ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              plan == AIPlan.PLAN1
                  ? 'Expose Everyone - \$0.99'
                  : 'Always Exposed - \$5.99/w',
              style: AppTextStyle.openRunde(
                fontSize: 18.sp,
                color: AppColors.kffffff,
                fontWeight: FontWeight.w600,
              ),
            ),
            8.verticalSpace,
            Text(
              plan == AIPlan.PLAN1
                  ? ' •  Full ranking of everyone\n'
                      ' •  Instant spill, one-time only\n'
                      ' •  Another reason for them to do it now'
                  : ' •  Every round, every reason, no limits\n'
                      ' •  Instant spills\n'
                      ' •  VIP badge on your profile\n'
                      ' •  Additional modes: head-to-head, images',
              style: AppTextStyle.openRunde(
                fontSize: 14.sp,
                color: AppColors.kffffff,
                fontWeight: FontWeight.w500,
              ),
            ),
            plan == AIPlan.PLAN1 ? 16.verticalSpace : 11.verticalSpace,
            plan == AIPlan.PLAN1
                ? Obx(
                    () => AppButton(
                      height: 42.h,
                      isLoading: onRoundExposeLoading?.value ?? false,
                      buttonText: '👀 Expose This Round',
                      decoration: BoxDecoration(
                        color: AppColors.kFFC300,
                        borderRadius: BorderRadius.circular(28.r),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            offset: const Offset(0, 2),
                            blurRadius: 2,
                            color: AppColors.k000000.withValues(alpha: 0.2),
                          ),
                        ],
                      ),
                      onPressed: () {
                        onRoundExpose?.call();
                      },
                      style: AppTextStyle.openRunde(
                        fontSize: 16.sp,
                        color: AppColors.k2A2E2F,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : Obx(
                    () => AppButton(
                      buttonText: '🔥 Go Unlimited',
                      isLoading: onExposedLoading?.value ?? false,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28.r),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.0, 0.0],
                          colors: <Color>[
                            AppColors.kFFC300,
                            AppColors.kFFC300.withValues(alpha: .72),
                          ],
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            offset: const Offset(0, 2),
                            blurRadius: 2,
                            color: AppColors.k000000.withValues(alpha: 0.2),
                          ),
                        ],
                      ),
                      onPressed: () {
                        onExposed?.call();
                      },
                      style: AppTextStyle.openRunde(
                        fontSize: 18.sp,
                        color: AppColors.kffffff,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
          ],
        ),
      );
}

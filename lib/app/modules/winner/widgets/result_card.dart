import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../data/config/app_colors.dart';
import '../../../data/config/app_images.dart';
import '../../../utils/app_text_style.dart';

/// Result Card Widget
class ResultCard extends StatelessWidget {
  /// Constructor for ResultCard
  const ResultCard({
    super.key,
    this.ordinalSuffix,
    this.rank,
    this.isCurrentRankIs1,
    this.selfieUrl,
    this.userName,
    this.reason,
  });

  /// Controller
  final bool? isCurrentRankIs1;

  /// Rank
  final int? rank;

  /// Get ordinal suffix
  final String? ordinalSuffix;

  /// Selfie URL
  final String? selfieUrl;

  /// User name
  final String? userName;

  /// Reason
  final String? reason;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Column(
            children: <Widget>[
              (isCurrentRankIs1 ?? false)
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: RichText(
                        text: TextSpan(
                          children: <InlineSpan>[
                            TextSpan(
                              text: '${rank ?? 0}',
                              style: AppTextStyle.openRunde(
                                fontSize: 40.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.kffffff,
                                shadows: <Shadow>[
                                  const Shadow(
                                    offset: Offset(0, 4),
                                    blurRadius: 4,
                                    color: Color(0x33000000),
                                  ),
                                ],
                              ),
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.top,
                              child: Transform.translate(
                                offset: const Offset(2, -22),
                                child: Text(
                                  ordinalSuffix ?? '',
                                  style: AppTextStyle.openRunde(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.kffffff,
                                    shadows: <Shadow>[
                                      const Shadow(
                                        offset: Offset(0, 4),
                                        blurRadius: 4,
                                        color: Color(0x33000000),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '?',
                        style: AppTextStyle.openRunde(
                          fontSize: 36.sp,
                          color: AppColors.kffffff,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ).paddingOnly(right: 8.w),
              16.verticalSpace,
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset(
                    AppImages.smilyIcon,
                  ),
                ),
              ),
              16.verticalSpace,
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(500.r),
                              child: CachedNetworkImage(
                                imageUrl: selfieUrl ?? '',
                                width: 24.w,
                                height: 24.w,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => const Center(
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2)),
                                errorWidget: (_, __, ___) => const Center(
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                            ),
                            4.horizontalSpace,
                            Flexible(
                              child: Text(
                                userName ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.openRunde(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.kffffff,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: SvgPicture.asset(
                          AppImages.shareIconShadow,
                          height: 32.w,
                          colorFilter: const ColorFilter.mode(
                            AppColors.kffffff,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                  16.verticalSpace,
                  Text(
                    reason ?? '',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.openRunde(
                      fontSize: 20.sp,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w700,
                      color: AppColors.kffffff,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
}

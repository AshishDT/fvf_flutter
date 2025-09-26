import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';
import 'package:fvf_flutter/app/ui/components/app_circular_progress.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../profile/models/md_profile_args.dart';
import 'circular_gradient_painter.dart';

/// Selfie Avatar widget
class SelfieAvatar extends StatelessWidget {
  /// Constructor for SelfieAvatar
  const SelfieAvatar({
    required this.participant,
    super.key,
    this.size = 56,
    this.showBorder = false,
  });

  /// SelfieAvatar constructor
  final MdParticipant participant;

  /// Size of the avatar
  final double size;

  /// Show border around avatar
  final bool showBorder;

  /// pick avatar color from id
  Color get _bgColor {
    final List<Color> _avatarColors = <Color>[
      const Color(0xFF13C4E5),
      const Color(0xFF8C6BF5),
      const Color(0xFFD353DB),
      const Color(0xFF5B82FF),
      const Color(0xFFFB47CD),
      const Color(0xFF34A1FF),
      const Color(0xFF7C70F9),
    ];

    final int hash = participant.userData?.id?.hashCode ?? 0;
    final int index = hash % _avatarColors.length;
    return _avatarColors[index];
  }

  @override
  Widget build(BuildContext context) {
    final String? selfieUrl = participant.selfieUrl;
    final String? profileUrl = participant.userData?.profileUrl;

    final String? imageUrl = (profileUrl != null && profileUrl.isNotEmpty)
        ? profileUrl
        : (selfieUrl != null && selfieUrl.isNotEmpty)
            ? selfieUrl
            : null;

    final bool hasImage = imageUrl != null && imageUrl.isNotEmpty;

    Widget avatarContent;

    if (hasImage) {
      avatarContent = ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: size.h,
          height: size.h,
          fit: BoxFit.cover,
          placeholder: (_, __) => const Center(
            child: AppCircularProgress(
              size: 30,
            ),
          ),
          errorWidget: (_, __, ___) => const Center(
            child: Icon(
              Icons.error,
              color: AppColors.kffffff,
            ),
          ),
        ),
      );
    } else if (participant.isCurrentUser) {
      avatarContent = ClipOval(
        child: Image.asset(
          AppImages.youProfile,
          width: size.h,
          height: size.h,
          fit: BoxFit.cover,
        ),
      );
    } else {
      avatarContent = Container(
        decoration: BoxDecoration(
          color: _bgColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFF6FCFE),
            width: 3.w,
          ),
        ),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.w,
            color: Colors.white,
          ),
        ),
      );
    }

    return Opacity(
      opacity: 1,
      child: GestureDetector(
        onTap: () {
          if (participant.isCurrentUser) {
            _navigateToProfile();
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.30),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: CustomPaint(
                painter: showBorder ? CircularGradientBorderPainter() : null,
                child: AnimatedContainer(
                  duration: 300.milliseconds,
                  curve: Curves.easeInOut,
                  padding: REdgeInsets.all(2),
                  width: size.h,
                  height: size.h,
                  child: ClipOval(
                    child: SizedBox(
                      width: size.h,
                      height: size.h,
                      child: avatarContent,
                    ),
                  ),
                ),
              ),
            ),
            4.verticalSpace,
            Center(
              child: SizedBox(
                width: 70.w,
                child: Text(
                  participant.isCurrentUser ? 'You' : _userName(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.openRunde(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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
    );
  }

  /// Navigate to profile
  void _navigateToProfile() {
    Get.toNamed(
      Routes.PROFILE,
      preventDuplicates: false,
      arguments: MdProfileArgs(
        tag:
            '${participant.userData?.id}_${DateTime.now().millisecondsSinceEpoch}',
        userId: participant.userData?.id ?? '',
      ),
    );
  }

  /// User name
  String _userName() => participant.userData?.username != null &&
          (participant.userData?.username?.isNotEmpty ?? false)
      ? participant.userData?.username?.split(' ').first ?? ''
      : '';
}

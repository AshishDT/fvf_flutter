import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';

/// Selfie Avatar widget
class SelfieAvatar extends StatelessWidget {
  /// Constructor for SelfieAvatar
  const SelfieAvatar({
    required this.participant,
    super.key,
    this.size = 56,
  });

  /// SelfieAvatar constructor
  final MdParticipant participant;

  /// Size of the avatar
  final double size;

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

    final int hash = participant.userData?.supabaseId?.hashCode ?? 0;
    final int index = hash % _avatarColors.length;
    return _avatarColors[index];
  }

  @override
  Widget build(BuildContext context) {
    final bool hasNetworkImage =
        participant.selfieUrl != null && participant.selfieUrl!.isNotEmpty;

    Widget avatarContent;

    if (hasNetworkImage) {
      avatarContent = ClipOval(
        child: CachedNetworkImage(
          imageUrl: participant.selfieUrl!,
          width: size.w,
          height: size.h,
          fit: BoxFit.cover,
          placeholder: (_, __) => Center(
            child: CircularProgressIndicator(strokeWidth: 2.w),
          ),
          errorWidget: (_, __, ___) => Center(
            child: CircularProgressIndicator(strokeWidth: 2.w),
          ),
        ),
      );
    } else if (participant.isCurrentUser) {
      avatarContent = ClipOval(
        child: Image.asset(
          AppImages.youProfile,
          width: size.w,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(width: size.w, height: size.h, child: avatarContent),
          2.verticalSpace,
          Text(
            participant.isCurrentUser ? 'You' : _userName(),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// User name
  String _userName() => participant.userData?.username != null &&
          (participant.userData?.username?.isNotEmpty ?? false)
      ? participant.userData?.username?.split(' ').first ?? ''
      : '';
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/modules/snap_selfies/widgets/previous_participant_avatar.dart';

import '../../../utils/app_text_style.dart';
import '../../create_bet/models/md_previous_round.dart';

/// Grouped Avatar Icon widget
class GroupAvatarIcon extends StatelessWidget {
  /// Constructor
  const GroupAvatarIcon({
    required this.participants,
    super.key,
    this.onAddTap,
    this.isAdded = false,
  });

  /// Grouped Avatar Icon constructor
  final List<MdPreviousParticipant> participants;

  /// Is added
  final bool isAdded;

  /// Callback when add is tapped
  final void Function()? onAddTap;

  @override
  Widget build(BuildContext context) {
    if (participants.isEmpty) {
      return const SizedBox.shrink();
    }

    if (participants.length == 1) {
      return PreviousParticipantAvatarIcon(
        participant: participants.first,
        onAddTap: onAddTap,
        isAdded: isAdded,
      );
    }

    final List<MdPreviousParticipant> displayParticipants =
        participants.take(3).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: 80.w,
          height: 80.h,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              if (displayParticipants.length > 1)
                Positioned(
                  left: 10.w,
                  bottom: 6.h,
                  child: PreviousParticipantAvatarIcon(
                    participant: displayParticipants[0],
                    showAddIcon: false,
                    showName: false,
                    isSingle: false,
                    isAdded: isAdded,
                  ),
                ),
              if (displayParticipants.length > 2)
                Positioned(
                  left: 12.w,
                  top: 15.h,
                  child: PreviousParticipantAvatarIcon(
                    participant: displayParticipants[1],
                    showAddIcon: false,
                    showName: false,
                    isSingle: false,
                    isAdded: isAdded,
                  ),
                ),
              Positioned(
                left: 30.w,
                bottom: displayParticipants.length == 2 ? 0 : 14.h,
                child: PreviousParticipantAvatarIcon(
                  participant: displayParticipants.last,
                  onAddTap: onAddTap,
                  showName: false,
                  isSingle: false,
                  mainInGroup: true,
                  isAdded: isAdded,
                ),
              ),
            ],
          ),
        ),
        6.verticalSpace,
        Text(
          'Group',
          style: AppTextStyle.openRunde(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

/// Clipper that makes a "bite" cut outside the avatar
class CircleCutoutClipper extends CustomClipper<Path> {
  /// Constructor
  CircleCutoutClipper({
    this.cutoutRadius = 10,
    this.cutoutFrom = Alignment.centerLeft,
  });

  /// Radius of the cutout circle
  final double cutoutRadius;

  /// From which side to cut the circle
  final Alignment cutoutFrom;

  @override
  Path getClip(Size size) {
    final Path path = Path();
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2;

    // Full circle
    path.addOval(Rect.fromCircle(center: center, radius: radius));

    // Cutout position (pushed slightly outside avatar edge)
    Offset cutoutCenter = center;

    if (cutoutFrom == Alignment.centerLeft) {
      cutoutCenter = Offset(center.dx - radius * 0.9, center.dy);
    } else if (cutoutFrom == Alignment.centerRight) {
      cutoutCenter = Offset(center.dx + radius * 0.9, center.dy);
    } else if (cutoutFrom == Alignment.topCenter) {
      cutoutCenter = Offset(center.dx, center.dy - radius * 0.9);
    } else if (cutoutFrom == Alignment.bottomCenter) {
      cutoutCenter = Offset(center.dx, center.dy + radius * 0.9);
    } else if (cutoutFrom == Alignment.bottomRight) {
      cutoutCenter = Offset(center.dx + radius * 0.7, center.dy + radius * 0.7);
    }

    // Add the cutout
    path
      ..addOval(Rect.fromCircle(center: cutoutCenter, radius: cutoutRadius))
      ..fillType = PathFillType.nonZero;
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

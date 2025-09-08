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


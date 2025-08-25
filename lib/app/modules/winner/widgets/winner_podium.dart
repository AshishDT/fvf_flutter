import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';
import '../../ai_choosing/widgets/ai_choosing_avatar.dart';

/// Winners podium widget
class WinnersPodium extends StatelessWidget {
  /// Winners podium widget constructor
  const WinnersPodium({
    required this.rank1,
    required this.rank2,
    required this.rank3,
    required this.onAvatarTap,
    super.key,
  });

  /// First place user
  final MdParticipant rank1;

  /// Second place user
  final MdParticipant rank2;

  /// Third place user
  final MdParticipant rank3;

  /// Callback for when the avatar is tapped
  final void Function(MdParticipant user) onAvatarTap;

  @override
  Widget build(BuildContext context) {
    final double bigSize = 100.w;
    final double smallSize = 72.w;

    final double overlap = smallSize * 0.3;

    final double totalWidth = bigSize + (smallSize - overlap) * 2;

    return SizedBox(
      width: totalWidth,
      height: bigSize,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            left: 0,
            top: (bigSize - smallSize) / 2,
            child: GestureDetector(
              onTap: () => onAvatarTap(rank2),
              child: SizedBox(
                width: smallSize,
                height: smallSize,
                child: AiChoosingAvatar(participant: rank2),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: (bigSize - smallSize) / 2,
            child: GestureDetector(
              onTap: () => onAvatarTap(rank3),
              child: SizedBox(
                width: smallSize,
                height: smallSize,
                child: AiChoosingAvatar(participant: rank3),
              ),
            ),
          ),
          Align(
            child: GestureDetector(
              onTap: () => onAvatarTap(rank1),
              child: SizedBox(
                width: bigSize,
                height: bigSize,
                child: AiChoosingAvatar(
                  participant: rank1,
                  showBorders: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

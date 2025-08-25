import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';
import 'package:fvf_flutter/app/routes/app_pages.dart';
import 'package:get/get.dart';
import '../../ai_choosing/widgets/ai_choosing_avatar.dart';

/// Winners podium widget
class WinnersPodiumPremiumView extends StatelessWidget {
  /// Winners podium widget constructor
  const WinnersPodiumPremiumView({
    required this.rank1,
    required this.rank2,
    required this.rank3,
    super.key,
  });

  /// First place user
  final MdParticipant? rank1;

  /// Second place user
  final MdParticipant? rank2;

  /// Third place user
  final MdParticipant? rank3;

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
          if (rank2 != null)
            Positioned(
              left: 0,
              top: (bigSize - smallSize) / 2,
              child: SizedBox(
                width: smallSize,
                height: smallSize,
                child: AiChoosingAvatar(participant: rank2!),
              ),
            ),
          if (rank3 != null)
            Positioned(
              right: 0,
              top: (bigSize - smallSize) / 2,
              child: SizedBox(
                width: smallSize,
                height: smallSize,
                child: AiChoosingAvatar(participant: rank3!),
              ),
            ),
          if (rank1 != null)
            GestureDetector(
              onTap: () {
                Get.toNamed(
                  Routes.PROFILE,
                  arguments: <String, MdParticipant?>{'user': rank1},
                );
              },
              child: Align(
                child: SizedBox(
                  width: bigSize,
                  height: bigSize,
                  child: AiChoosingAvatar(
                    participant: rank1!,
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

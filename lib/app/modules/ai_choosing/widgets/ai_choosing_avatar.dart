import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';

/// AiChoosingAvatar widget
class AiChoosingAvatar extends StatelessWidget {
  /// Constructor for AiChoosingAvatar
  const AiChoosingAvatar({
    required this.participant,
    this.showBorders = false,
    super.key,
  });

  /// User for which the avatar is displayed
  final MdParticipant participant;

  /// Whether to show borders around the avatar
  final bool showBorders;

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: 1,
        child: SizedBox(
          width: 202.w,
          height: 202.h,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              if (showBorders) ...<Widget>[
                Image(
                  image: const AssetImage(AppImages.aiChoosingBorderGradient),
                  width: 202.w,
                  height: 202.h,
                  fit: BoxFit.cover,
                ),
              ],
              ClipOval(
                child: Container(
                  width: 160.w,
                  height: 160.h,
                  child: Center(
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: participant.selfieUrl!,
                        width: 202.w,
                        height: 202.h,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => const Center(
                            child: CircularProgressIndicator(strokeWidth: 2)),
                        errorWidget: (_, __, ___) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

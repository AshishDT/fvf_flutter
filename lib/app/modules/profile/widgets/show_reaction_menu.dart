import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:google_fonts/google_fonts.dart';

/// Show Reaction Menu Overlay
class ShowReactionMenu {
  static OverlayEntry? _entry;

  /// Show Reaction Menu at position
  static void show({
    required BuildContext context,
    required Offset position,
    required void Function(String emoji) onReactionSelected,
    Map<String, dynamic>? reactions,
  }) {
    final Map<String, int> staticReactions = <String, int>{
      '🔥': 0,
      '❤️': 0,
      '😂': 0,
      '😮': 0,
      '😢': 0,
    };

    final Map<String, int> mergedReactions = <String, int>{
      for (final MapEntry<String, int> entry in staticReactions.entries)
        entry.key: reactions?[entry.key] ?? entry.value,
    };
    hide();
    _entry = OverlayEntry(
      builder: (_) => Stack(
        children: <Widget>[
          Positioned.fill(
            child: GestureDetector(
              onTap: hide,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            left: position.dx - 30.w,
            top: position.dy - 258.h,
            // right: 54.w,
            // top: position.dy - 38.h,
            child: Material(
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    width: 48.w,
                    // height: 258.h,
                    // alignment: Alignment.center,
                    padding: REdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.36),
                      borderRadius: BorderRadius.circular(28.r),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: AppColors.k000000.withValues(alpha: 0.1),
                          offset: const Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      spacing: 10.h,
                      children: mergedReactions.entries
                          .map(
                            (MapEntry<String, dynamic> e) => Column(
                              children: <Widget>[
                                Text(
                                  e.key,
                                  style: GoogleFonts.fredoka(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (e.value > 0)
                                  Text(
                                    '${e.value ?? ''}',
                                    style: AppTextStyle.openRunde(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.kffffff,
                                    ),
                                  ),
                              ],
                            ),
                          )
                          .toList(),
                      /*List<Widget>.generate(
                        emojis.length,
                            (int index) {
                          final String emoji = emojis[index];
                          return GestureDetector(
                            onTap: () {
                              onReactionSelected(emoji);
                              hide();
                            },
                            child: Text(
                              emoji,
                              style: GoogleFonts.fredoka(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        },
                      ),*/
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_entry!);
  }

  /// Hide Reaction Menu
  static void hide() {
    _entry?.remove();
    _entry = null;
  }
}

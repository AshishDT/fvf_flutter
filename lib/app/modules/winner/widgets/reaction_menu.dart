import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/utils/emoji_ext.dart';

/// Reaction Menu Overlay
class ReactionMenu {
  static OverlayEntry? _entry;

  /// Show Reaction Menu at position
  static void show({
    required BuildContext context,
    required Offset position,
    required void Function(String emoji) onReactionSelected,
  }) {
    hide();

    final List<String> emojis = <String>['🔥', '❤️', '😂', '😮', '😢'];

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
            child: Material(
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    width: 48.w,
                    height: 258.h,
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
                      children: List<Widget>.generate(
                        emojis.length,
                        (int index) {
                          final String emoji = emojis[index];
                          return GestureDetector(
                            onTap: () {
                              onReactionSelected(emoji);
                              hide();
                            },
                            child: Image.asset(
                              emoji.emojiImagePath,
                              height: 36.w,
                              width: 36.w,
                            ),
                          );
                        },
                      ),
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

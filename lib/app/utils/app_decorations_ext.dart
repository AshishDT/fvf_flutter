import 'package:flutter/material.dart';

/// AppDecorations provides common decoration styles for the app.
extension AppDecorations on BoxDecoration {
  /// Gradient background same as:
  /// background: linear-gradient(134.08deg, #FB46CD 14.07%, #6C75FF 56.35%, #0DBFFF 115.5%);
  static BoxDecoration fancyGradient() => const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          transform: GradientRotation(134.08 * 3.14159265 / 180),
          colors: <Color>[
            Color(0xFFFB46CD),
            Color(0xFF6C75FF),
            Color(0xFF0DBFFF),
          ],
          stops: <double>[
            0.1407,
            0.5635,
            1.155,
          ],
        ),
      );

  /// Gradient background same as:
  /// background: linear-gradient(134.36deg, #FB46CD 11.61%, #6C75FF 47.75%, #0DBFFF 83.7%);
  static BoxDecoration fancyGradient2() => const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          transform: GradientRotation(225.64 * 3.14159265 / 180),
          colors: <Color>[
            Color(0xFFFB46CD),
            Color(0xFF6C75FF),
            Color(0xFF0DBFFF),
          ],
          stops: <double>[
            0.1161,
            0.4775,
            0.837,
          ],
        ),
      );
}


// lib/theme/frutiger_aero_theme.dart
//
// All design tokens (colors, gradients, decorations) for the Frutiger Aero
// visual style. Import this file wherever theme values are needed.

import 'package:flutter/material.dart';

class FrutigerAeroTheme {
  // ── Primary palette ────────────────────────────────────────────────────────
  static const Color lightBlue   = Color(0xFF87CEEB);
  static const Color skyBlue     = Color(0xFF00BFFF);
  static const Color deepSkyBlue = Color(0xFF00A8E8);
  static const Color oceanBlue   = Color(0xFF0984E3);
  static const Color midBlue     = Color(0xFF4A90D9);
  static const Color tealBlue    = Color(0xFF5DADE2);

  // ── Gradient base colors ───────────────────────────────────────────────────
  static const Color gradientLight = Color(0xFFE8F4FC);
  static const Color gradientMid   = Color(0xFFB8DFF5);
  static const Color gradientDark  = Color(0xFF7EC8E3);

  // ── Accent colors ──────────────────────────────────────────────────────────
  static const Color accentCyan  = Color(0xFF00D4FF);
  static const Color accentAqua  = Color(0xFF48DbfB);
  static const Color accentWhite = Color(0xFFF0F8FF);

  // ── Text colors ────────────────────────────────────────────────────────────
  static const Color textDark  = Color(0xFF1A365D);
  static const Color textMid   = Color(0xFF2C5282);
  static const Color textLight = Color(0xFF4A5568);

  // ── Semantic / status colors ───────────────────────────────────────────────
  static const Color success = Color(0xFF48BB78);
  static const Color warning = Color(0xFFECC94B);
  static const Color danger  = Color(0xFFE53E3E);
  static const Color info    = Color(0xFF4299E1);

  // ── Gradients ──────────────────────────────────────────────────────────────

  static LinearGradient get backgroundGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientLight, gradientMid, Color(0xFFA8D8F0)],
  );

  static LinearGradient get cardGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFF0F8FF), Color(0xFFE8F4FC)],
  );

  static LinearGradient get buttonGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [skyBlue, oceanBlue],
  );

  static LinearGradient get accentGradient => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [accentCyan, accentAqua],
  );

  // ── Decorations ────────────────────────────────────────────────────────────

  /// Frosted-glass card surface.
  static BoxDecoration get glassDecoration => BoxDecoration(
    color: Colors.white.withValues(alpha: 0.85),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1.5),
    boxShadow: [
      BoxShadow(
        color: skyBlue.withValues(alpha: 0.2),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ],
  );

  /// Elevated content card.
  static BoxDecoration get cardDecoration => BoxDecoration(
    gradient: cardGradient,
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
    boxShadow: [
      BoxShadow(
        color: skyBlue.withValues(alpha: 0.25),
        blurRadius: 20,
        spreadRadius: 2,
        offset: const Offset(0, 8),
      ),
    ],
  );
}

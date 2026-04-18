// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Sign Language palette (Teal / Cyan) ──────────
  static const Color slPrimary = Color(0xFF0D9488);
  static const Color slPrimaryLight = Color(0xFF0F2E2C);
  static const Color slPrimaryMid = Color(0xFF2DD4BF);
  static const Color slBackground = Color(0xFF0B1120);
  static const Color slSurface = Color(0xFF111827);

  // ── Shadow Puppet palette (Warm amber / gold) ────
  static const Color ppPrimary = Color(0xFFF59E0B);
  static const Color ppPrimaryLight = Color(0xFF2A2008);
  static const Color ppBackground = Color(0xFF09090F);
  static const Color ppSurface = Color(0xFF0F0F18);
  static const Color ppCard = Color(0xFF07070B);

  // ── Shared ────────────────────────────────────────
  static const Color scaffoldDark = Color(0xFF0B1120);
  static const Color cardDark = Color(0xFF111827);
  static const Color inkDark = Color(0xFFF1F5F9);
  static const Color ink = Color(0xFFCBD5E1);
  static const Color muted = Color(0xFF64748B);
  static const Color border = Color(0xFF1E293B);
  static const Color offWhite = Color(0xFF0F172A);
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFF052E16);
  static const Color error = Color(0xFFF43F5E);
  static const Color errorLight = Color(0xFF3B0A15);
  static const Color amber = Color(0xFFF97316);
  static const Color amberLight = Color(0xFF2A1A08);

  // ── Glass helpers ─────────────────────────────────
  static BoxDecoration glassCard({
    Color? glowColor,
    double borderRadius = 20,
    double borderOpacity = 0.12,
    double bgOpacity = 0.06,
  }) {
    final c = glowColor ?? slPrimary;
    return BoxDecoration(
      color: c.withOpacity(bgOpacity),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: c.withOpacity(borderOpacity), width: 1.5),
    );
  }

  static List<BoxShadow> glowShadow(Color color, {double blur = 18}) => [
        BoxShadow(
          color: color.withOpacity(0.25),
          blurRadius: blur,
          offset: const Offset(0, 4),
        ),
      ];

  // ── Theme data ────────────────────────────────────
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        textTheme: GoogleFonts.outfitTextTheme(
          ThemeData.dark().textTheme,
        ),
        scaffoldBackgroundColor: scaffoldDark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: slPrimary,
          brightness: Brightness.dark,
        ),
      );
}

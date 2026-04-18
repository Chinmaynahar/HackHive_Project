// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// ── Section label ──────────────────────────────
class SectionLabel extends StatelessWidget {
  final String text;
  final Color color;
  const SectionLabel(this.text, {super.key, this.color = AppTheme.muted});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 1.2,
          ),
        ),
      );
}

// ── Stat chip (glassmorphic) ───────────────────
class StatChip extends StatelessWidget {
  final IconData iconData;
  final String value;
  final String label;
  final Color bg;
  final Color textColor;
  final Color borderColor;

  const StatChip({
    super.key,
    required this.iconData,
    required this.value,
    required this.label,
    required this.bg,
    required this.textColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Column(
          children: [
            Icon(iconData, size: 16, color: textColor),
            const SizedBox(height: 3),
            Text(
              value,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 8, color: AppTheme.muted),
            ),
          ],
        ),
      );
}

// ── Pill badge ─────────────────────────────────
class PillBadge extends StatelessWidget {
  final String text;
  final Color bg;
  final Color textColor;
  final Color borderColor;
  const PillBadge({
    super.key,
    required this.text,
    required this.bg,
    required this.textColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: textColor,
            letterSpacing: 0.5,
          ),
        ),
      );
}

// ── Primary button (animated pill) ─────────────
class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final Color color1;
  final Color color2;
  final Color textColor;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color1 = AppTheme.slPrimary,
    this.color2 = const Color(0xFF2DD4BF),
    this.textColor = Colors.white,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) {
          _ctrl.reverse();
          widget.onTap();
        },
        onTapCancel: () => _ctrl.reverse(),
        child: AnimatedBuilder(
          animation: _scale,
          builder: (_, __) => Transform.scale(
            scale: _scale.value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                gradient:
                    LinearGradient(colors: [widget.color1, widget.color2]),
                borderRadius: BorderRadius.circular(100),
                boxShadow: AppTheme.glowShadow(widget.color1),
              ),
              alignment: Alignment.center,
              child: Text(
                widget.label,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: widget.textColor,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
      );
}

// ── Bottom nav bar (dark / frosted glass) ──────
class LightBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const LightBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home_rounded, 'Home'),
      (Icons.menu_book_rounded, 'Lessons'),
      (Icons.bar_chart_rounded, 'Progress'),
      (Icons.person_rounded, 'Profile'),
    ];
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardDark.withOpacity(0.85),
        border: Border(
          top: BorderSide(color: AppTheme.border.withOpacity(0.5)),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final active = i == currentIndex;
          return GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(items[i].$1, size: 18, color: active ? AppTheme.slPrimary : AppTheme.muted),
                  const SizedBox(height: 3),
                  Text(
                    items[i].$2,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: active ? AppTheme.slPrimary : AppTheme.muted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: active ? 16 : 0,
                    height: 3,
                    decoration: BoxDecoration(
                      color: active ? AppTheme.slPrimary : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── Bottom nav bar (dark — shadow puppet) ──────
class DarkBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const DarkBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home_rounded, 'Home'),
      (Icons.theater_comedy_rounded, 'Stage'),
      (Icons.auto_stories_rounded, 'Stories'),
      (Icons.person_rounded, 'Profile'),
    ];
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.ppSurface.withOpacity(0.9),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.04)),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final active = i == currentIndex;
          return GestureDetector(
            onTap: () => onTap(i),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(items[i].$1, size: 18, color: active ? AppTheme.ppPrimary : Colors.white.withOpacity(0.3)),
                const SizedBox(height: 3),
                Text(
                  items[i].$2,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: active
                        ? AppTheme.ppPrimary
                        : Colors.white.withOpacity(0.3),
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: active ? 16 : 0,
                  height: 3,
                  decoration: BoxDecoration(
                    color: active ? AppTheme.ppPrimary : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

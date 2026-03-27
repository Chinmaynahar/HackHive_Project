import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/dummy_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';

class ShadowPuppetScreen extends StatefulWidget {
  const ShadowPuppetScreen({super.key});

  @override
  State<ShadowPuppetScreen> createState() => _ShadowPuppetScreenState();
}

class _ShadowPuppetScreenState extends State<ShadowPuppetScreen>
    with TickerProviderStateMixin {
  int _navIndex = 1;
  late List<PuppetCharacter> _chars;
  final List<String> _sequence = List.from(DummyData.storySequence);
  bool _isPlayingStory = false;

  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _chars = DummyData.puppetChars
        .map((c) => PuppetCharacter(
              id: c.id,
              name: c.name,
              emoji: c.emoji,
              gestureHint: c.gestureHint,
              isUsed: c.isUsed,
            ))
        .toList();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  void _addToSequence(PuppetCharacter char) {
    if (_sequence.length >= DummyData.maxSequenceLength) return;
    setState(() {
      char.isUsed = true;
      _sequence.add(char.emoji);
    });
  }

  void _playStory() {
    setState(() => _isPlayingStory = true);
    Future.delayed(const Duration(seconds: 3),
        () => mounted ? setState(() => _isPlayingStory = false) : null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.ppBackground,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBar(),
                    _buildStage(),
                    _buildStoryBubble(),
                    _buildPaletteLabel(),
                    _buildPalette(),
                    _buildSequenceLabel(),
                    _buildSequenceBar(),
                    PrimaryButton(
                      label:
                          _isPlayingStory ? '⏸ Playing...' : '▶  Play Story',
                      onTap: _playStory,
                      color1: AppTheme.ppPrimary,
                      color2: const Color(0xFFFBBF24),
                      textColor: const Color(0xFF1A1200),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            DarkBottomNav(
              currentIndex: _navIndex,
              onTap: (i) => setState(() => _navIndex = i),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.ppPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: AppTheme.ppPrimary,
                ),
              ),
            ),
            const Spacer(),
            Text(
              '🎭 Story Stage',
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.ppPrimary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: AppTheme.ppPrimary.withOpacity(0.25),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppTheme.error,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.error.withOpacity(0.5),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'LIVE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.ppPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildStage() {
    final usedChars = _chars.where((c) => c.isUsed).take(3).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      height: 140,
      decoration: BoxDecoration(
        color: AppTheme.ppCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.ppPrimary.withOpacity(0.12),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.ppPrimary.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Spotlight
          Positioned(
            top: -20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.ppPrimary.withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Stage floor line
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppTheme.ppPrimary.withOpacity(0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Silhouettes
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (usedChars.isNotEmpty) ...[
                  _buildSilhouette(usedChars[0], 0),
                ],
                if (usedChars.length > 1) ...[
                  const SizedBox(width: 10),
                  _buildSilhouette(usedChars[1], 1),
                ],
                if (usedChars.length > 2) ...[
                  const SizedBox(width: 10),
                  _buildSilhouette(usedChars[2], 2),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSilhouette(PuppetCharacter char, int index) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (_, __) {
        final offset = Curves.easeInOut.transform(
              ((_floatController.value + index * 0.33) % 1.0),
            ) *
            6;
        return Transform.translate(
          offset: Offset(0, -offset),
          child: _SilhouettePainter(char: char),
        );
      },
    );
  }

  Widget _buildStoryBubble() => Container(
        margin: const EdgeInsets.fromLTRB(14, 6, 14, 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.ppPrimary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.ppPrimary.withOpacity(0.15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '✨ AI STORY',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: AppTheme.ppPrimary,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              DummyData.aiStory,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.7),
                fontStyle: FontStyle.italic,
                height: 1.6,
              ),
            ),
          ],
        ),
      );

  Widget _buildPaletteLabel() => const SectionLabel('Tap a gesture to add');

  Widget _buildPalette() => Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
        child: GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.0,
          children: _chars.map((c) {
            return GestureDetector(
              onTap: () => _addToSequence(c),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: c.isUsed
                      ? AppTheme.ppPrimary.withOpacity(0.15)
                      : Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: c.isUsed
                        ? AppTheme.ppPrimary.withOpacity(0.4)
                        : Colors.white.withOpacity(0.08),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(c.emoji, style: const TextStyle(fontSize: 22)),
                    const SizedBox(height: 4),
                    Text(
                      c.name,
                      style: TextStyle(
                        fontSize: 9,
                        color: c.isUsed
                            ? AppTheme.ppPrimary
                            : Colors.white.withOpacity(0.5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );

  Widget _buildSequenceLabel() => Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 4),
        child: Text(
          'STORY SEQUENCE',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.white.withOpacity(0.35),
            letterSpacing: 1.0,
          ),
        ),
      );

  Widget _buildSequenceBar() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
        child: Row(
          children: List.generate(DummyData.maxSequenceLength, (i) {
            final hasItem = i < _sequence.length;
            return Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: hasItem
                        ? AppTheme.ppPrimary.withOpacity(0.12)
                        : Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: hasItem
                          ? AppTheme.ppPrimary.withOpacity(0.35)
                          : Colors.white.withOpacity(0.1),
                      width: 1.5,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: hasItem
                      ? Text(_sequence[i],
                          style: const TextStyle(fontSize: 16))
                      : null,
                ),
                if (i < DummyData.maxSequenceLength - 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      '›',
                      style: TextStyle(
                        color: AppTheme.ppPrimary.withOpacity(0.4),
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            );
          }),
        ),
      );
}

// ── SVG-like silhouette widget ─────────────────
class _SilhouettePainter extends StatelessWidget {
  final PuppetCharacter char;
  const _SilhouettePainter({required this.char});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PuppetPainter(char.id),
      size: const Size(50, 80),
    );
  }
}

class _PuppetPainter extends CustomPainter {
  final String id;
  _PuppetPainter(this.id);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..style = PaintingStyle.fill;

    final shadow = Paint()
      ..color = const Color(0xFFF59E0B).withOpacity(0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    switch (id) {
      case 'tree':
        _drawTree(canvas, size, paint, shadow);
        break;
      case 'deer':
        _drawDeer(canvas, size, paint, shadow);
        break;
      case 'bird':
        _drawBird(canvas, size, paint, shadow);
        break;
      default:
        final center = Offset(size.width / 2, size.height / 2);
        canvas.drawCircle(center, 20, shadow);
        canvas.drawCircle(center, 20, paint);
    }
  }

  void _drawTree(Canvas c, Size s, Paint p, Paint sh) {
    c.drawPath(
        Path()
          ..moveTo(s.width / 2, 4)
          ..lineTo(s.width - 4, s.height * 0.6)
          ..lineTo(4, s.height * 0.6)
          ..close(),
        sh);
    c.drawPath(
        Path()
          ..moveTo(s.width / 2, 4)
          ..lineTo(s.width - 4, s.height * 0.6)
          ..lineTo(4, s.height * 0.6)
          ..close(),
        p);
    c.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
              s.width / 2 - 6, s.height * 0.58, 12, s.height * 0.38),
          const Radius.circular(4),
        ),
        p);
  }

  void _drawDeer(Canvas c, Size s, Paint p, Paint sh) {
    c.drawOval(
        Rect.fromCenter(
            center: Offset(s.width / 2, s.height * 0.65),
            width: s.width * 0.7,
            height: s.height * 0.3),
        p);
    c.drawCircle(Offset(s.width / 2, s.height * 0.38), 12, p);
    for (final x in [s.width * 0.32, s.width * 0.52]) {
      c.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x, s.height * 0.72, 6, s.height * 0.26),
            const Radius.circular(3),
          ),
          p);
    }
    final antlerPaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    c.drawLine(Offset(s.width * 0.38, s.height * 0.28),
        Offset(s.width * 0.2, s.height * 0.08), antlerPaint);
    c.drawLine(Offset(s.width * 0.2, s.height * 0.08),
        Offset(s.width * 0.12, s.height * 0.02), antlerPaint);
    c.drawLine(Offset(s.width * 0.62, s.height * 0.28),
        Offset(s.width * 0.8, s.height * 0.08), antlerPaint);
    c.drawLine(Offset(s.width * 0.8, s.height * 0.08),
        Offset(s.width * 0.9, s.height * 0.02), antlerPaint);
  }

  void _drawBird(Canvas c, Size s, Paint p, Paint sh) {
    c.drawOval(
        Rect.fromCenter(
            center: Offset(s.width / 2, s.height * 0.52),
            width: s.width * 0.6,
            height: s.height * 0.28),
        p);
    c.drawCircle(Offset(s.width / 2, s.height * 0.32), 10, p);
    final beak = Path()
      ..moveTo(s.width / 2 + 8, s.height * 0.3)
      ..lineTo(s.width / 2 + 16, s.height * 0.32)
      ..lineTo(s.width / 2 + 8, s.height * 0.35)
      ..close();
    c.drawPath(beak, p);
    final leftWing = Path()
      ..moveTo(s.width * 0.3, s.height * 0.5)
      ..quadraticBezierTo(
          s.width * 0.1, s.height * 0.35, s.width * 0.15, s.height * 0.28)
      ..quadraticBezierTo(
          s.width * 0.22, s.height * 0.42, s.width * 0.32, s.height * 0.5)
      ..close();
    c.drawPath(leftWing, p);
    final rightWing = Path()
      ..moveTo(s.width * 0.7, s.height * 0.5)
      ..quadraticBezierTo(
          s.width * 0.9, s.height * 0.35, s.width * 0.85, s.height * 0.28)
      ..quadraticBezierTo(
          s.width * 0.78, s.height * 0.42, s.width * 0.68, s.height * 0.5)
      ..close();
    c.drawPath(rightWing, p);
    for (final x in [s.width * 0.42, s.width * 0.56]) {
      c.drawLine(Offset(x, s.height * 0.64), Offset(x, s.height * 0.88),
          Paint()
            ..color = const Color(0xFFF59E0B)
            ..strokeWidth = 3
            ..strokeCap = StrokeCap.round);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

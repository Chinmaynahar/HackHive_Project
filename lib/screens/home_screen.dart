// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../services/firebase_gesture_service.dart';
import './sign_language/sign_home_screen.dart';
import './story_game/story_select_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseGestureService _gestureService = FirebaseGestureService();
  StreamSubscription<Map<String, dynamic>?>? _sub;
  bool _gloveConnected = false;
  String? _lastGesture;
  DateTime? _lastTimestamp;

  @override
  void initState() {
    super.initState();
    _gestureService.startListening();
    _sub = _gestureService.onProcessedData.listen((data) {
      if (!mounted) return;
      if (data != null) {
        final ts = data['timestamp'] as int?;
        final prediction = data['prediction'] as String?;
        final crossValidated = data['crossValidated'] == true;
        final now = DateTime.now().millisecondsSinceEpoch;

        debugPrint('[HomeScreen] Gesture: prediction=$prediction, crossValidated=$crossValidated, ts=$ts');

        setState(() {
          _lastGesture = prediction?.toUpperCase();
          _lastTimestamp = ts != null ? DateTime.fromMillisecondsSinceEpoch(ts) : null;
          // Consider connected if last update was within 30 seconds
          _gloveConnected = ts != null && (now - ts) < 30000;
        });
      } else {
        debugPrint('[HomeScreen] No data — glove offline');
        setState(() => _gloveConnected = false);
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _gestureService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo row
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.slPrimary, Color(0xFF2DD4BF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: AppTheme.glowShadow(AppTheme.slPrimary),
                    ),
                    alignment: Alignment.center,
                    child:
                        const Icon(Icons.back_hand_rounded, size: 20, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Glove',
                          style: GoogleFonts.outfit(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.inkDark,
                          ),
                        ),
                        TextSpan(
                          text: 'AI',
                          style: GoogleFonts.outfit(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.slPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Live glove connection status
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: (_gloveConnected ? AppTheme.slPrimary : AppTheme.error).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                          color: (_gloveConnected ? AppTheme.slPrimary : AppTheme.error).withOpacity(0.3),
                          width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: _gloveConnected ? AppTheme.success : AppTheme.error,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (_gloveConnected ? AppTheme.success : AppTheme.error).withOpacity(0.5),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _gloveConnected
                              ? 'Glove Connected'
                              : 'Glove Offline',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _gloveConnected ? AppTheme.slPrimary : AppTheme.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 44),

              Text(
                'Choose your\nexperience',
                style: GoogleFonts.outfit(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.inkDark,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Put on the glove and pick a mode to begin.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.muted,
                  fontWeight: FontWeight.w400,
                ),
              ),

              // Live gesture card (only when connected)
              if (_gloveConnected && _lastGesture != null) ...[
                const SizedBox(height: 20),
                _buildLiveGestureCard(),
              ],

              const SizedBox(height: 32),

              // Sign Language Card
              _ModeCard(
                iconData: Icons.sign_language_rounded,
                tag: 'Module 01',
                title: 'Sign Language Learning',
                description:
                    'Practice sign language gestures with instant feedback and levelled lessons.',
                color1: AppTheme.slPrimary,
                color2: const Color(0xFF2DD4BF),
                glowColor: AppTheme.slPrimary,
                features: const [
                  'Guided lessons',
                  'Instant feedback',
                  'Streaks & XP'
                ],
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SignHomeScreen())),
              ),

              const SizedBox(height: 16),

              // Interactive Story Game Card
              _ModeCard(
                iconData: Icons.auto_stories_rounded,
                tag: 'Module 02',
                title: 'Indian Interactive Story Game',
                description:
                    'Play through Indian tales and make gesture choices at checkpoints to shape the narrative.',
                color1: AppTheme.ppPrimary,
                color2: const Color(0xFFFBBF24),
                glowColor: AppTheme.ppPrimary,
                features: const [
                  'Indian stories',
                  'Gesture choices',
                ],
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const StorySelectScreen())),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLiveGestureCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.slPrimary.withOpacity(0.08),
            AppTheme.slPrimary.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.slPrimary.withOpacity(0.2), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.slPrimary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.slPrimary.withOpacity(0.3)),
            ),
            alignment: Alignment.center,
            child: Text(
              _lastGesture ?? '?',
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppTheme.slPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Last Detected Gesture',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppTheme.muted.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Letter: $_lastGesture',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.inkDark,
                  ),
                ),
                if (_lastTimestamp != null)
                  Text(
                    '${_lastTimestamp!.hour.toString().padLeft(2, '0')}:${_lastTimestamp!.minute.toString().padLeft(2, '0')}:${_lastTimestamp!.second.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppTheme.muted,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.success.withOpacity(0.12),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: AppTheme.success.withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.sensors_rounded, size: 12, color: AppTheme.success),
                SizedBox(width: 4),
                Text(
                  'LIVE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeCard extends StatefulWidget {
  final IconData iconData;
  final String tag, title, description;
  final Color color1, color2, glowColor;
  final List<String> features;
  final VoidCallback onTap;

  const _ModeCard({
    required this.iconData,
    required this.tag,
    required this.title,
    required this.description,
    required this.color1,
    required this.color2,
    required this.glowColor,
    required this.features,
    required this.onTap,
  });

  @override
  State<_ModeCard> createState() => _ModeCardState();
}

class _ModeCardState extends State<_ModeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
            decoration: BoxDecoration(
              color: widget.glowColor.withOpacity(0.06),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                  color: widget.glowColor.withOpacity(0.15), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: widget.glowColor.withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                // Top accent gradient bar
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [widget.color1, widget.color2]),
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(22)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(widget.iconData,
                              size: 32, color: widget.color1),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: widget.glowColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                  color:
                                      widget.glowColor.withOpacity(0.25),
                                  width: 1),
                            ),
                            child: Text(
                              widget.tag,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: widget.color2,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.title,
                        style: GoogleFonts.outfit(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.inkDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.muted,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Flexible(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: widget.features
                                    .map((f) => Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8),
                                          child: Container(
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
                                            decoration: BoxDecoration(
                                              color: widget.glowColor
                                                  .withOpacity(0.08),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10),
                                              border: Border.all(
                                                  color: widget.glowColor
                                                      .withOpacity(0.18),
                                                  width: 1),
                                            ),
                                            child: Text(
                                              f,
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                                color: widget.color2,
                                              ),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 9),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [widget.color1, widget.color2]),
                              borderRadius: BorderRadius.circular(100),
                              boxShadow:
                                  AppTheme.glowShadow(widget.color1),
                            ),
                            child: Text(
                              'Open →',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: widget.color1 == AppTheme.ppPrimary
                                    ? const Color(0xFF1A1200)
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

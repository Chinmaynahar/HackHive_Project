import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/dummy_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import 'story_play_screen.dart';

class StorySelectScreen extends StatelessWidget {
  const StorySelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stories = DummyData.stories;

    return Scaffold(
      backgroundColor: AppTheme.ppBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose your\nstory',
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.inkDark,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Ramayana tales — make gestures at checkpoints to shape the story.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.45),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ...stories.map((story) => _StoryCard(
                          story: story,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StoryPlayScreen(story: story),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) => Padding(
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
              'Story Mode',
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
              child: Text(
                '${DummyData.stories.length} stories',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.ppPrimary,
                ),
              ),
            ),
          ],
        ),
      );
}

class _StoryCard extends StatefulWidget {
  final Story story;
  final VoidCallback onTap;

  const _StoryCard({required this.story, required this.onTap});

  @override
  State<_StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<_StoryCard>
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

  Color get _difficultyColor {
    switch (widget.story.difficulty) {
      case 'Easy':
        return AppTheme.success;
      case 'Medium':
        return AppTheme.ppPrimary;
      case 'Hard':
        return AppTheme.error;
      default:
        return AppTheme.muted;
    }
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
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: AppTheme.ppPrimary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(22),
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
            child: Column(
              children: [
                // Top accent bar
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.ppPrimary, Color(0xFFFBBF24)],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(22),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      // Story icon
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppTheme.ppPrimary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.ppPrimary.withOpacity(0.25),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.auto_stories_rounded,
                          size: 28,
                          color: AppTheme.ppPrimary,
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Text content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.story.title,
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.inkDark,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _difficultyColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      color:
                                          _difficultyColor.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    widget.story.difficulty,
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: _difficultyColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.story.description,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.45),
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                _InfoChip(
                                  iconData: Icons.menu_book_rounded,
                                  text: '${widget.story.sceneCount} scenes',
                                ),
                                const SizedBox(width: 8),
                                const _InfoChip(
                                  iconData: Icons.back_hand_rounded,
                                  text: 'Gesture input',
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 7,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppTheme.ppPrimary,
                                        Color(0xFFFBBF24),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                    boxShadow:
                                        AppTheme.glowShadow(AppTheme.ppPrimary),
                                  ),
                                  child: Text(
                                    'Play →',
                                    style: GoogleFonts.outfit(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1A1200),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData iconData;
  final String text;
  const _InfoChip({required this.iconData, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, size: 10, color: Colors.white.withOpacity(0.5)),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}

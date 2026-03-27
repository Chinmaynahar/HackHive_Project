import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';

class StoryPlayScreen extends StatefulWidget {
  final Story story;
  const StoryPlayScreen({super.key, required this.story});

  @override
  State<StoryPlayScreen> createState() => _StoryPlayScreenState();
}

class _StoryPlayScreenState extends State<StoryPlayScreen>
    with TickerProviderStateMixin {
  int _currentSceneIndex = 0;
  bool _showCheckpoint = false;
  bool _isNarrating = true;
  String _displayedText = '';
  int _charIndex = 0;
  Timer? _typeTimer;
  String? _selectedLetter;
  bool _optionLocked = false;
  int _choicesMade = 0;
  final Stopwatch _stopwatch = Stopwatch();
  bool _showChapterCard = false;
  String? _chapterTitle;

  // Choice timer
  Timer? _choiceTimer;
  int _choiceTimeLeft = 0;

  // Cinematic transition
  bool _fadeToBlack = false;

  // Animations
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;
  late AnimationController _emojiFloatController;
  late AnimationController _particleController;
  late AnimationController _chapterFadeCtrl;
  late Animation<double> _chapterFadeAnim;

  @override
  void initState() {
    super.initState();
    _stopwatch.start();

    _fadeController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    _pulseController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _emojiFloatController = AnimationController(
      vsync: this, duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this, duration: const Duration(seconds: 8),
    )..repeat();

    _chapterFadeCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 800),
    );
    _chapterFadeAnim = CurvedAnimation(
      parent: _chapterFadeCtrl, curve: Curves.easeInOut,
    );

    _startScene();
  }

  @override
  void dispose() {
    _typeTimer?.cancel();
    _choiceTimer?.cancel();
    _fadeController.dispose();
    _pulseController.dispose();
    _emojiFloatController.dispose();
    _particleController.dispose();
    _chapterFadeCtrl.dispose();
    _stopwatch.stop();
    super.dispose();
  }

  StoryScene get _currentScene => widget.story.scenes[_currentSceneIndex];

  void _startScene() {
    _fadeController.reset();

    setState(() {
      _displayedText = '';
      _charIndex = 0;
      _isNarrating = true;
      _showCheckpoint = false;
      _selectedLetter = null;
      _optionLocked = false;
      _fadeToBlack = false;
    });

    _choiceTimer?.cancel();

    // Show chapter card if applicable
    if (_currentScene.chapterTitle != null) {
      setState(() {
        _showChapterCard = true;
        _chapterTitle = _currentScene.chapterTitle;
      });
      _chapterFadeCtrl.reset();
      _chapterFadeCtrl.forward();
      Future.delayed(const Duration(milliseconds: 2200), () {
        if (!mounted) return;
        _chapterFadeCtrl.reverse().then((_) {
          if (mounted) {
            setState(() => _showChapterCard = false);
            _beginNarration();
          }
        });
      });
    } else {
      _beginNarration();
    }
  }

  void _beginNarration() {
    _fadeController.forward();
    final text = _currentScene.narration;
    if (text.isEmpty) {
      // Skip empty scenes (gap placeholders)
      _advanceScene();
      return;
    }
    _typeTimer?.cancel();
    _typeTimer = Timer.periodic(const Duration(milliseconds: 28), (timer) {
      if (_charIndex < text.length) {
        setState(() {
          _charIndex++;
          _displayedText = text.substring(0, _charIndex);
        });
      } else {
        timer.cancel();
        setState(() => _isNarrating = false);
        if (_currentScene.checkpoint != null) {
          Future.delayed(const Duration(milliseconds: 400), () {
            if (mounted) {
              setState(() => _showCheckpoint = true);
              _startChoiceTimer();
            }
          });
        }
      }
    });
  }

  void _skipNarration() {
    _typeTimer?.cancel();
    setState(() {
      _displayedText = _currentScene.narration;
      _charIndex = _currentScene.narration.length;
      _isNarrating = false;
    });
    if (_currentScene.checkpoint != null) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() => _showCheckpoint = true);
          _startChoiceTimer();
        }
      });
    }
  }

  void _startChoiceTimer() {
    final seconds = _currentScene.checkpoint?.timerSeconds;
    if (seconds == null) return;
    setState(() => _choiceTimeLeft = seconds);
    _choiceTimer?.cancel();
    _choiceTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_choiceTimeLeft <= 1 || _optionLocked) {
        timer.cancel();
        if (!_optionLocked && _currentScene.checkpoint != null) {
          // Auto-select first option on timeout
          _selectOption(_currentScene.checkpoint!.options.first);
        }
        return;
      }
      setState(() => _choiceTimeLeft--);
    });
  }

  void _selectOption(StoryOption option) {
    if (_optionLocked) return;
    _choiceTimer?.cancel();
    setState(() {
      _selectedLetter = option.letter;
      _optionLocked = true;
      _choicesMade++;
    });

    // Cinematic fade to black transition
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() => _fadeToBlack = true);
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        _currentSceneIndex = option.nextSceneIndex;
        _fadeToBlack = false;
      });
      _startScene();
    });
  }

  void _advanceScene() {
    if (_isNarrating) {
      _skipNarration();
      return;
    }
    if (_currentScene.isEnding) {
      _showCompletionDialog();
      return;
    }
    if (_currentScene.checkpoint != null) return;

    // Cinematic transition
    setState(() => _fadeToBlack = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      final nextIndex = _currentSceneIndex + 1;
      if (nextIndex < widget.story.scenes.length) {
        setState(() {
          _currentSceneIndex = nextIndex;
          _fadeToBlack = false;
        });
        _startScene();
      }
    });
  }

  void _showCompletionDialog() {
    _stopwatch.stop();
    final minutes = _stopwatch.elapsed.inMinutes;
    final seconds = _stopwatch.elapsed.inSeconds % 60;
    final endingTitle = _currentScene.endingTitle ?? 'Story Complete';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1028), Color(0xFF0A0818)],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppTheme.ppPrimary.withOpacity(0.3), width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.ppPrimary.withOpacity(0.15),
                blurRadius: 40,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🏆', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 10),
              Text(
                endingTitle,
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.ppPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                widget.story.title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _CompletionStat(
                    emoji: '🎯', value: '$_choicesMade', label: 'Choices',
                  ),
                  _CompletionStat(
                    emoji: '⏱️',
                    value: '${minutes}m ${seconds}s',
                    label: 'Time',
                  ),
                  _CompletionStat(
                    emoji: '📖',
                    value: '${widget.story.scenes.length}',
                    label: 'Scenes',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.ppPrimary, Color(0xFFFBBF24)],
                    ),
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: AppTheme.glowShadow(AppTheme.ppPrimary),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Continue',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1200),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // BUILD
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  @override
  Widget build(BuildContext context) {
    final scene = _currentScene;
    final bgStart = Color(int.parse(scene.bgGradientStart.isNotEmpty
        ? scene.bgGradientStart : '0xFF0B1120'));
    final bgEnd = Color(int.parse(scene.bgGradientEnd.isNotEmpty
        ? scene.bgGradientEnd : '0xFF1A1A2E'));

    return Scaffold(
      backgroundColor: bgStart,
      body: Stack(
        children: [
          // Background gradient
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [bgStart, bgEnd],
              ),
            ),
          ),

          // Particle effects
          if (scene.particles != ParticleType.none)
            _ParticleOverlay(
              type: scene.particles,
              controller: _particleController,
            ),

          // Cinematic top/bottom bars
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main content
          GestureDetector(
            onTap: _advanceScene,
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    _buildTopBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            // Character portraits
                            if (scene.characters.isNotEmpty)
                              _buildCharacterPortraits(scene),
                            const SizedBox(height: 16),
                            // Scene emoji
                            _buildSceneEmoji(scene),
                            const SizedBox(height: 20),
                            // Dialogue box
                            _buildDialogueBox(scene),
                            // Checkpoint
                            if (_showCheckpoint &&
                                scene.checkpoint != null) ...[
                              const SizedBox(height: 16),
                              _buildCheckpointUI(scene.checkpoint!),
                            ],
                            // Tap to continue
                            if (!_isNarrating &&
                                scene.checkpoint == null &&
                                !scene.isEnding) ...[
                              const SizedBox(height: 20),
                              _buildTapHint(),
                            ],
                            // Ending button
                            if (scene.isEnding && !_isNarrating) ...[
                              const SizedBox(height: 20),
                              _buildEndingButton(),
                            ],
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Chapter title card overlay
          if (_showChapterCard)
            _buildChapterCard(),

          // Fade to black transition
          AnimatedOpacity(
            opacity: _fadeToBlack ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: IgnorePointer(
              child: Container(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  // ━━ TOP BAR ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Widget _buildTopBar() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Icon(Icons.close_rounded,
                    size: 16, color: Colors.white.withOpacity(0.6)),
              ),
            ),
            const Spacer(),
            // Scene counter
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Text(
                widget.story.title,
                style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.ppPrimary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                    color: AppTheme.ppPrimary.withOpacity(0.25)),
              ),
              child: Text(
                'Scene ${_currentSceneIndex + 1}',
                style: const TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w700,
                  color: AppTheme.ppPrimary,
                ),
              ),
            ),
          ],
        ),
      );

  // ━━ CHARACTER PORTRAITS ━━━━━━━━━━━━━━━━━━━━━━

  Widget _buildCharacterPortraits(StoryScene scene) {
    return SizedBox(
      height: 80,
      child: Stack(
        children: scene.characters.map((char) {
          return AnimatedBuilder(
            animation: _emojiFloatController,
            builder: (_, __) {
              final floatVal = Curves.easeInOut.transform(
                _emojiFloatController.value,
              );
              final offset = floatVal * 4 + (char.position * 2);
              return Positioned(
                left: (MediaQuery.of(context).size.width - 36) *
                        char.position -
                    18,
                bottom: offset,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.ppPrimary.withOpacity(0.1),
                        border: Border.all(
                          color: AppTheme.ppPrimary.withOpacity(0.2),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.ppPrimary.withOpacity(0.08),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(char.emoji,
                          style: const TextStyle(fontSize: 24)),
                    ),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        char.name,
                        style: TextStyle(
                          fontSize: 7,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  // ━━ SCENE EMOJI ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Widget _buildSceneEmoji(StoryScene scene) {
    if (scene.sceneEmoji.isEmpty) return const SizedBox.shrink();
    return AnimatedBuilder(
      animation: _emojiFloatController,
      builder: (_, __) {
        final offset = Curves.easeInOut.transform(
                _emojiFloatController.value) * 8;
        return Transform.translate(
          offset: Offset(0, -offset),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.ppPrimary.withOpacity(0.06),
              border: Border.all(
                color: AppTheme.ppPrimary.withOpacity(0.12), width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.ppPrimary.withOpacity(0.1),
                  blurRadius: 24,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(scene.sceneEmoji,
                style: const TextStyle(fontSize: 32)),
          ),
        );
      },
    );
  }

  // ━━ DIALOGUE BOX (Visual Novel style) ━━━━━━━━

  Widget _buildDialogueBox(StoryScene scene) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: AppTheme.ppPrimary.withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Speaker name tag
          if (scene.speakerName != null)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.ppPrimary.withOpacity(0.3),
                    AppTheme.ppPrimary.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: AppTheme.ppPrimary.withOpacity(0.3)),
              ),
              child: Text(
                scene.speakerName!,
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.ppPrimary,
                ),
              ),
            )
          else
            Row(
              children: [
                Container(
                  width: 5, height: 5,
                  decoration: BoxDecoration(
                    color: _isNarrating
                        ? AppTheme.ppPrimary
                        : AppTheme.ppPrimary.withOpacity(0.4),
                    shape: BoxShape.circle,
                    boxShadow: _isNarrating
                        ? [BoxShadow(
                            color: AppTheme.ppPrimary.withOpacity(0.5),
                            blurRadius: 6)]
                        : [],
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _isNarrating ? 'NARRATING...' : 'STORY',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.ppPrimary.withOpacity(0.6),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          const SizedBox(height: 4),
          // Narration text
          Text(
            _displayedText,
            style: GoogleFonts.outfit(
              fontSize: 15,
              color: Colors.white.withOpacity(0.9),
              height: 1.7,
              fontWeight: FontWeight.w400,
            ),
          ),
          if (_isNarrating) ...[
            const SizedBox(height: 10),
            AnimatedBuilder(
              animation: _pulseAnim,
              builder: (_, __) => Opacity(
                opacity: _pulseAnim.value,
                child: Text(
                  '▸ Tap to skip',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.25),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ━━ CHAPTER TITLE CARD ━━━━━━━━━━━━━━━━━━━━━━

  Widget _buildChapterCard() {
    return AnimatedBuilder(
      animation: _chapterFadeAnim,
      builder: (_, __) => Opacity(
        opacity: _chapterFadeAnim.value,
        child: Container(
          color: Colors.black.withOpacity(0.85),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 2,
                decoration: BoxDecoration(
                  color: AppTheme.ppPrimary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _chapterTitle ?? '',
                style: GoogleFonts.outfit(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.ppPrimary,
                  letterSpacing: 1.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                widget.story.title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.35),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 40, height: 2,
                decoration: BoxDecoration(
                  color: AppTheme.ppPrimary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ━━ CHECKPOINT UI ━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Widget _buildCheckpointUI(StoryCheckpoint checkpoint) {
    return AnimatedOpacity(
      opacity: _showCheckpoint ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: Column(
        children: [
          // Timer + question header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                AppTheme.ppPrimary.withOpacity(0.12),
                AppTheme.ppPrimary.withOpacity(0.04),
              ]),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: AppTheme.ppPrimary.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Text('🤚', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GESTURE CHECKPOINT',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.ppPrimary.withOpacity(0.7),
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        checkpoint.question,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                // Timer badge
                if (checkpoint.timerSeconds != null && !_optionLocked)
                  AnimatedBuilder(
                    animation: _pulseAnim,
                    builder: (_, __) => Container(
                      width: 38, height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _choiceTimeLeft <= 5
                            ? AppTheme.error.withOpacity(0.2)
                            : AppTheme.ppPrimary.withOpacity(0.15),
                        border: Border.all(
                          color: _choiceTimeLeft <= 5
                              ? AppTheme.error.withOpacity(0.5)
                              : AppTheme.ppPrimary.withOpacity(0.4),
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$_choiceTimeLeft',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: _choiceTimeLeft <= 5
                              ? AppTheme.error
                              : AppTheme.ppPrimary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Make gesture for the letter, or tap to select',
            style: TextStyle(
              fontSize: 9,
              color: Colors.white.withOpacity(0.25),
            ),
          ),
          const SizedBox(height: 8),
          ...checkpoint.options.map((opt) => _buildOptionCard(opt)),
        ],
      ),
    );
  }

  Widget _buildOptionCard(StoryOption option) {
    final isSelected = _selectedLetter == option.letter;
    final isOther = _selectedLetter != null && !isSelected;

    return GestureDetector(
      onTap: () => _selectOption(option),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.ppPrimary.withOpacity(0.18)
              : Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppTheme.ppPrimary.withOpacity(0.5)
                : Colors.white.withOpacity(0.08),
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected
              ? [BoxShadow(
                  color: AppTheme.ppPrimary.withOpacity(0.12),
                  blurRadius: 16)]
              : [],
        ),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: isOther ? 0.3 : 1.0,
          child: Row(
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.ppPrimary
                      : AppTheme.ppPrimary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: AppTheme.ppPrimary.withOpacity(0.3)),
                ),
                alignment: Alignment.center,
                child: Text(
                  option.letter,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: isSelected
                        ? const Color(0xFF1A1200)
                        : AppTheme.ppPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${option.emoji} ${option.text}',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppTheme.ppPrimary
                            : Colors.white.withOpacity(0.8),
                      ),
                    ),
                    Text(
                      'Gesture: Sign "${option.letter}"',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.white.withOpacity(0.25),
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Text('✅', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  // ━━ HELPERS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Widget _buildTapHint() {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (_, __) => Opacity(
        opacity: _pulseAnim.value,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: Text(
            '▸ Tap to continue',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.35),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEndingButton() {
    return GestureDetector(
      onTap: _showCompletionDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.ppPrimary, Color(0xFFFBBF24)],
          ),
          borderRadius: BorderRadius.circular(100),
          boxShadow: AppTheme.glowShadow(AppTheme.ppPrimary),
        ),
        child: Text(
          '🏆 Complete Story',
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1200),
          ),
        ),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PARTICLE OVERLAY
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _ParticleOverlay extends StatelessWidget {
  final ParticleType type;
  final AnimationController controller;

  const _ParticleOverlay({
    required this.type,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) => CustomPaint(
        painter: _ParticlePainter(
          type: type,
          progress: controller.value,
        ),
        size: MediaQuery.of(context).size,
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final ParticleType type;
  final double progress;
  final Random _rng = Random(42);

  _ParticlePainter({required this.type, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case ParticleType.fireflies:
        _drawFireflies(canvas, size);
        break;
      case ParticleType.stars:
        _drawStars(canvas, size);
        break;
      case ParticleType.snow:
        _drawSnow(canvas, size);
        break;
      case ParticleType.embers:
        _drawEmbers(canvas, size);
        break;
      case ParticleType.rain:
        _drawRain(canvas, size);
        break;
      default:
        break;
    }
  }

  void _drawFireflies(Canvas c, Size s) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 20; i++) {
      final x = (_rng.nextDouble() * s.width +
              sin((progress * 2 * pi) + i) * 20) %
          s.width;
      final y = (_rng.nextDouble() * s.height +
              cos((progress * 2 * pi) + i * 0.7) * 15) %
          s.height;
      final opacity = (sin((progress * 4 * pi) + i * 1.3) * 0.5 + 0.5)
          .clamp(0.0, 1.0);
      paint.color = const Color(0xFFFFD700).withOpacity(opacity * 0.6);
      c.drawCircle(Offset(x, y), 2 + _rng.nextDouble() * 2, paint);
      // Glow
      paint.color = const Color(0xFFFFD700).withOpacity(opacity * 0.15);
      c.drawCircle(Offset(x, y), 8 + _rng.nextDouble() * 4, paint);
    }
  }

  void _drawStars(Canvas c, Size s) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 30; i++) {
      final x = _rng.nextDouble() * s.width;
      final y = _rng.nextDouble() * s.height * 0.6;
      final twinkle = (sin((progress * 6 * pi) + i * 2.1) * 0.5 + 0.5)
          .clamp(0.0, 1.0);
      paint.color = Colors.white.withOpacity(twinkle * 0.5);
      c.drawCircle(Offset(x, y), 1 + _rng.nextDouble(), paint);
    }
  }

  void _drawSnow(Canvas c, Size s) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withOpacity(0.4);
    for (int i = 0; i < 25; i++) {
      final x = (_rng.nextDouble() * s.width +
              sin(progress * 2 * pi + i) * 30) %
          s.width;
      final y = ((_rng.nextDouble() + progress) * s.height * 1.2) %
          s.height;
      final sz = 1.5 + _rng.nextDouble() * 2;
      c.drawCircle(Offset(x, y), sz, paint);
    }
  }

  void _drawEmbers(Canvas c, Size s) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 15; i++) {
      final x = (_rng.nextDouble() * s.width +
              sin(progress * 2 * pi + i * 1.5) * 20) %
          s.width;
      final y = (s.height -
              ((_rng.nextDouble() + progress * 0.5) * s.height * 0.5) %
                  (s.height * 0.5));
      final opacity = (sin(progress * 4 * pi + i) * 0.5 + 0.5)
          .clamp(0.0, 1.0);
      paint.color = const Color(0xFFFF6B00).withOpacity(opacity * 0.5);
      c.drawCircle(Offset(x, y), 1.5 + _rng.nextDouble(), paint);
      paint.color = const Color(0xFFFF6B00).withOpacity(opacity * 0.1);
      c.drawCircle(Offset(x, y), 6 + _rng.nextDouble() * 3, paint);
    }
  }

  void _drawRain(Canvas c, Size s) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 30; i++) {
      final x = _rng.nextDouble() * s.width;
      final y = ((progress + _rng.nextDouble()) * s.height * 1.5) %
          s.height;
      c.drawLine(Offset(x, y), Offset(x - 2, y + 12), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) => true;
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// COMPLETION STAT
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _CompletionStat extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;

  const _CompletionStat({
    required this.emoji,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppTheme.ppPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: Colors.white.withOpacity(0.35),
          ),
        ),
      ],
    );
  }
}

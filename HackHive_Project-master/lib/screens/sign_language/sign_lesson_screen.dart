import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/dummy_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';

class SignLessonScreen extends StatefulWidget {
  const SignLessonScreen({super.key});

  @override
  State<SignLessonScreen> createState() => _SignLessonScreenState();
}

class _SignLessonScreenState extends State<SignLessonScreen>
    with SingleTickerProviderStateMixin {
  int _currentStep = 2;
  bool _isCorrect = true;
  bool _isScanning = false;
  int _navIndex = 1;
  late AnimationController _scanController;
  late Animation<double> _scanAnim;

  final _steps = DummyData.greetingSteps;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _scanAnim = Tween<double>(begin: -0.6, end: 1.1).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  void _simulateGesture() {
    setState(() {
      _isScanning = true;
      _isCorrect = false;
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        _isScanning = false;
        _isCorrect = true;
      });
    });
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
        _isCorrect = false;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentStep];
    final progress = (_currentStep + 1) / _steps.length;

    return Scaffold(
      backgroundColor: AppTheme.scaffoldDark,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTopBar(),
                    _buildProgressBar(progress),
                    _buildGestureCard(step),
                    const SizedBox(height: 10),
                    _buildStepChips(),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            PrimaryButton(
              label: _isCorrect ? 'NEXT →' : 'CHECKING...',
              onTap: _isCorrect ? _nextStep : _simulateGesture,
            ),
            LightBottomNav(
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
                  color: AppTheme.slPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: AppTheme.slPrimary,
                ),
              ),
            ),
            const Spacer(),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.amberLight,
                borderRadius: BorderRadius.circular(100),
                border:
                    Border.all(color: AppTheme.amber.withOpacity(0.3), width: 1.5),
              ),
              child: const Row(
                children: [
                  Text('🔥', style: TextStyle(fontSize: 12)),
                  SizedBox(width: 4),
                  Text(
                    '14',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.amber,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Text('❤️❤️❤️', style: TextStyle(fontSize: 13)),
          ],
        ),
      );

  Widget _buildProgressBar(double value) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${_currentStep + 1} of ${_steps.length}',
                  style:
                      const TextStyle(fontSize: 10, color: AppTheme.muted),
                ),
                const Text(
                  'Greetings',
                  style: TextStyle(fontSize: 10, color: AppTheme.muted),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: value),
                duration: const Duration(milliseconds: 400),
                builder: (_, v, __) => LinearProgressIndicator(
                  value: v,
                  backgroundColor: AppTheme.slPrimaryLight,
                  valueColor:
                      const AlwaysStoppedAnimation(AppTheme.slPrimary),
                  minHeight: 8,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildGestureCard(GestureStep step) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
              color: AppTheme.slPrimary.withOpacity(0.2), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppTheme.slPrimary.withOpacity(0.06),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            const Text(
              'PERFORM THIS SIGN',
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.muted,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${step.emoji} ${step.word}',
              style: GoogleFonts.outfit(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppTheme.inkDark,
              ),
            ),
            const SizedBox(height: 14),
            // Gesture capture box
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 100,
                color: AppTheme.scaffoldDark,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.slPrimary.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                    ),
                    // Scan line animation
                    AnimatedBuilder(
                      animation: _scanAnim,
                      builder: (_, __) => Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Align(
                          alignment:
                              Alignment(_scanAnim.value * 2 - 1, 0),
                          child: Container(
                            width: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  AppTheme.slPrimary.withOpacity(0.25),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Text('🤚',
                        style: TextStyle(fontSize: 48)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              step.instruction,
              style: const TextStyle(fontSize: 11, color: AppTheme.muted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            _buildFeedback(),
          ],
        ),
      );

  Widget _buildFeedback() {
    if (_isScanning) {
      return Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.amberLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: AppTheme.amber.withOpacity(0.3), width: 1.5),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppTheme.amber,
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Analysing gesture...',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.amber,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _isCorrect ? AppTheme.successLight : AppTheme.errorLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isCorrect
              ? AppTheme.success.withOpacity(0.3)
              : AppTheme.error.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _isCorrect ? '✅ Correct! Great job!' : '❌ Try again',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _isCorrect ? AppTheme.success : AppTheme.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepChips() {
    LessonStatus statusForIndex(int i) {
      if (i < _currentStep) return LessonStatus.completed;
      if (i == _currentStep) return LessonStatus.inProgress;
      return LessonStatus.locked;
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: List.generate(_steps.length, (i) {
          final s = statusForIndex(i);
          final isDone = s == LessonStatus.completed;
          final isNow = s == LessonStatus.inProgress;
          return Container(
            margin: const EdgeInsets.only(right: 8),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDone
                  ? AppTheme.slPrimary
                  : isNow
                      ? AppTheme.slPrimary.withOpacity(0.1)
                      : AppTheme.cardDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDone
                    ? AppTheme.slPrimary
                    : isNow
                        ? AppTheme.slPrimary.withOpacity(0.4)
                        : AppTheme.border,
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Text(
                  isDone ? '✅' : isNow ? _steps[i].emoji : '🔒',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 2),
                Text(
                  _steps[i].word,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: isDone
                        ? Colors.white
                        : isNow
                            ? AppTheme.slPrimaryMid
                            : AppTheme.muted,
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

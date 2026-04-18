// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/dummy_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import '../../services/firebase_gesture_service.dart';

class SignLessonScreen extends StatefulWidget {
  const SignLessonScreen({super.key});

  @override
  State<SignLessonScreen> createState() => _SignLessonScreenState();
}

class _SignLessonScreenState extends State<SignLessonScreen>
    with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  bool _isCorrect = false;
  bool _isScanning = true;
  int _navIndex = 1;
  late AnimationController _scanController;
  late Animation<double> _scanAnim;

  final _steps = DummyData.alphabetSteps;

  // Firebase live gesture detection
  final FirebaseGestureService _gestureService = FirebaseGestureService();
  StreamSubscription<Map<String, dynamic>?>? _gestureSub;
  String? _lastPrediction;
  double? _lastConfidence;

  // Debounce: require 2 consecutive matching predictions
  static const int _requiredMatches = 2;
  static const double _confidenceThreshold = 0.7;
  int _consecutiveMatches = 0;
  String? _lastMatchedLetter;

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

    // Start listening to Firebase processed data
    _gestureService.startListening();
    _gestureSub = _gestureService.onProcessedData.listen(_onGestureData);
  }

  @override
  void dispose() {
    _gestureSub?.cancel();
    _gestureService.dispose();
    _scanController.dispose();
    super.dispose();
  }

  void _onGestureData(Map<String, dynamic>? data) {
    if (!mounted || data == null) return;
    if (_isCorrect) return; // Already confirmed correct, ignore further data

    final prediction = (data['prediction'] as String?)?.toUpperCase();
    final confidence = (data['confidence'] as num?)?.toDouble();
    final crossValidated = data['crossValidated'] == true;
    final hardcoded = data['hardcodedLetter'] as String?;

    debugPrint('[LessonScreen] Gesture: prediction=$prediction, confidence=$confidence, crossValidated=$crossValidated, hardcoded=$hardcoded');

    setState(() {
      _lastPrediction = prediction;
      _lastConfidence = confidence;
      _isScanning = false;
    });

    // Check if detected gesture matches current step with debounce
    final targetLetter = _steps[_currentStep].word.toUpperCase();

    // When cross-validated (ML + hardcoded agree), lower confidence bar for extra accuracy
    final effectiveThreshold = crossValidated ? 0.5 : _confidenceThreshold;

    if (prediction != null &&
        prediction == targetLetter &&
        confidence != null &&
        confidence >= effectiveThreshold) {
      // Track consecutive matches for debounce
      if (_lastMatchedLetter == prediction) {
        _consecutiveMatches++;
      } else {
        _lastMatchedLetter = prediction;
        _consecutiveMatches = 1;
      }

      debugPrint('[LessonScreen] MATCH: $prediction == $targetLetter | consecutive=$_consecutiveMatches/$_requiredMatches | threshold=$effectiveThreshold');

      if (_consecutiveMatches >= _requiredMatches) {
        debugPrint('[LessonScreen] ✅ CONFIRMED CORRECT');
        setState(() => _isCorrect = true);
      }
    } else {
      if (prediction != null) {
        debugPrint('[LessonScreen] MISS: got=$prediction want=$targetLetter conf=${confidence ?? 0} < $effectiveThreshold');
      }
      // Reset consecutive match count on mismatch
      _consecutiveMatches = 0;
      _lastMatchedLetter = null;
    }
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
        _isCorrect = false;
        _isScanning = true;
        _lastPrediction = null;
        _lastConfidence = null;
        _consecutiveMatches = 0;
        _lastMatchedLetter = null;
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
              label: _isCorrect ? 'NEXT →' : 'WAITING FOR GESTURE...',
              onTap: _isCorrect ? _nextStep : () {},
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
            // Live indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.slPrimary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: AppTheme.slPrimary.withOpacity(0.25)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6, height: 6,
                    decoration: BoxDecoration(
                      color: _lastPrediction != null ? AppTheme.success : AppTheme.error,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (_lastPrediction != null ? AppTheme.success : AppTheme.error).withOpacity(0.5),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _lastPrediction != null ? 'LIVE: $_lastPrediction' : 'WAITING...',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.slPrimary,
                    ),
                  ),
                ],
              ),
            ),
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
                  'Alphabets A-Z',
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
              step.word,
              style: GoogleFonts.outfit(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppTheme.inkDark,
              ),
            ),
            const SizedBox(height: 14),
            // Gesture reference image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 240,
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
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/images/sign_lang/${step.word.toUpperCase()}.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported, size: 48, color: AppTheme.slPrimary);
                            },
                          ),
                        ),
                      ),
                    ),
                    // Scan line animation
                    if (_isScanning || !_isCorrect)
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
    // State 1: Confirmed correct
    if (_isCorrect) {
      return Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.successLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.success.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_rounded, size: 16, color: AppTheme.success),
            SizedBox(width: 8),
            Text(
              'Correct! Great job! ✅',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.success,
              ),
            ),
          ],
        ),
      );
    }

    // State 2: Prediction received but not yet matching
    if (_lastPrediction != null && !_isScanning) {
      final isPartialMatch = _lastPrediction == _steps[_currentStep].word.toUpperCase();
      return Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isPartialMatch ? AppTheme.slPrimaryLight : AppTheme.amberLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: (isPartialMatch ? AppTheme.slPrimary : AppTheme.amber).withOpacity(0.3), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPartialMatch ? Icons.sensors_rounded : Icons.sensors_rounded,
              size: 14,
              color: isPartialMatch ? AppTheme.slPrimary : AppTheme.amber,
            ),
            const SizedBox(width: 8),
            Text(
              isPartialMatch
                  ? 'Detecting: $_lastPrediction (${((_lastConfidence ?? 0) * 100).toStringAsFixed(0)}%) — hold steady...'
                  : 'Detected: $_lastPrediction (${((_lastConfidence ?? 0) * 100).toStringAsFixed(0)}%) — try "${_steps[_currentStep].word}"',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isPartialMatch ? AppTheme.slPrimary : AppTheme.amber,
              ),
            ),
          ],
        ),
      );
    }

    // State 3: Scanning / waiting for first data
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
            'Waiting for glove gesture...',
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

  Widget _buildStepChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: List.generate(_steps.length, (i) {
          final isSelected = i == _currentStep;
          return GestureDetector(
            onTap: () {
              setState(() {
                _currentStep = i;
                _isCorrect = false;
                _isScanning = true;
                _lastPrediction = null;
                _lastConfidence = null;
                _consecutiveMatches = 0;
                _lastMatchedLetter = null;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.slPrimary.withOpacity(0.15)
                    : AppTheme.cardDark,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.slPrimary
                      : AppTheme.border,
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Opacity(
                    opacity: isSelected ? 1.0 : 0.5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.asset(
                        'assets/images/sign_lang/${_steps[i].word.toUpperCase()}.png',
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          isSelected ? Icons.image : Icons.image_outlined,
                          size: 16,
                          color: isSelected ? AppTheme.slPrimary : AppTheme.muted.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _steps[i].word,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? AppTheme.slPrimary
                          : AppTheme.muted,
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

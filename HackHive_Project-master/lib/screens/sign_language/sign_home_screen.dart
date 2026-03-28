import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/dummy_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import 'sign_lesson_screen.dart';

class SignHomeScreen extends StatefulWidget {
  const SignHomeScreen({super.key});

  @override
  State<SignHomeScreen> createState() => _SignHomeScreenState();
}

class _SignHomeScreenState extends State<SignHomeScreen> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    const user = DummyData.user;

    return Scaffold(
      backgroundColor: AppTheme.scaffoldDark,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(user),
                    _buildXpBar(user),
                    _buildDailyGoal(),
                    const SectionLabel('Continue Learning'),
                    _buildLessonList(),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
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

  Widget _buildHeader(UserStats user) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 4),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${user.name}'s Learning",
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.inkDark,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.amberLight,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: AppTheme.amber.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_fire_department_rounded, size: 13, color: AppTheme.amber),
                  const SizedBox(width: 4),
                  Text(
                    '${user.streakDays}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.amber,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildXpBar(UserStats user) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                value: user.xpProgress,
                backgroundColor: AppTheme.slPrimaryLight,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppTheme.slPrimary),
                minHeight: 7,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Level ${user.level} · ${user.currentXp} XP',
                  style:
                      const TextStyle(fontSize: 10, color: AppTheme.muted),
                ),
                Text(
                  '${user.nextLevelXp} XP →',
                  style:
                      const TextStyle(fontSize: 10, color: AppTheme.muted),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _buildDailyGoal() => Container(
        margin: const EdgeInsets.fromLTRB(14, 6, 14, 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: AppTheme.glowShadow(AppTheme.slPrimary, blur: 24),
        ),
        child: Row(
          children: [
            const Icon(Icons.track_changes_rounded, size: 28, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Goal',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Practice ${DummyData.dailyGoalTotal} gestures today',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: LinearProgressIndicator(
                      value: DummyData.dailyGoalDone / DummyData.dailyGoalTotal,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${DummyData.dailyGoalDone}/${DummyData.dailyGoalTotal}',
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      );

  Widget _buildLessonList() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: DummyData.lessons.map((lesson) {
            return _LessonRow(
              lesson: lesson,
              onTap: lesson.status == LessonStatus.locked
                  ? null
                  : () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignLessonScreen(),
                        ),
                      ),
            );
          }).toList(),
        ),
      );
}

class _LessonRow extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback? onTap;

  const _LessonRow({required this.lesson, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isActive = lesson.status == LessonStatus.inProgress;
    final isLocked = lesson.status == LessonStatus.locked;
    final isDone = lesson.status == LessonStatus.completed;

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isLocked ? 0.4 : 1.0,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.slPrimary.withOpacity(0.08)
                : AppTheme.cardDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive
                  ? AppTheme.slPrimary.withOpacity(0.3)
                  : AppTheme.border,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isDone
                      ? AppTheme.slPrimary
                      : AppTheme.slPrimary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(
                  isLocked ? Icons.lock_rounded : Icons.back_hand_rounded,
                  size: 17,
                  color: isDone ? Colors.white : AppTheme.slPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.inkDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isDone
                          ? 'Completed · ${lesson.totalGestures} gestures'
                          : isActive
                              ? 'In progress · ${lesson.completedGestures} of ${lesson.totalGestures} done'
                              : 'Locked',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.muted,
                      ),
                    ),
                  ],
                ),
              ),
              if (isDone)
                const Icon(Icons.star_rounded, size: 14, color: AppTheme.slPrimary)
              else if (isActive)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.slPrimary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Text(
                    'GO →',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.slPrimaryMid,
                    ),
                  ),
                )
              else
                const Icon(Icons.lock_rounded, size: 13, color: AppTheme.muted),
            ],
          ),
        ),
      ),
    );
  }
}

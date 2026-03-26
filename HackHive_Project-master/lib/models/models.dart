// ── Lesson model ──────────────────────────────
class Lesson {
  final String id;
  final String title;
  final String emoji;
  final int totalGestures;
  final int completedGestures;
  final LessonStatus status;

  const Lesson({
    required this.id,
    required this.title,
    required this.emoji,
    required this.totalGestures,
    required this.completedGestures,
    required this.status,
  });

  double get progress =>
      totalGestures == 0 ? 0 : completedGestures / totalGestures;
}

enum LessonStatus { completed, inProgress, locked }

// ── Gesture step inside a lesson ──────────────
class GestureStep {
  final String word;
  final String emoji;
  final String instruction;

  const GestureStep({
    required this.word,
    required this.emoji,
    required this.instruction,
  });
}

// ── Puppet character ───────────────────────────
class PuppetCharacter {
  final String id;
  final String name;
  final String emoji;
  final String gestureHint;
  bool isUsed;

  PuppetCharacter({
    required this.id,
    required this.name,
    required this.emoji,
    required this.gestureHint,
    this.isUsed = false,
  });
}

// ── User stats ─────────────────────────────────
class UserStats {
  final String name;
  final int level;
  final int currentXp;
  final int nextLevelXp;
  final int streakDays;
  final int totalCompleted;
  final String badge;

  const UserStats({
    required this.name,
    required this.level,
    required this.currentXp,
    required this.nextLevelXp,
    required this.streakDays,
    required this.totalCompleted,
    required this.badge,
  });

  double get xpProgress => currentXp / nextLevelXp;
}

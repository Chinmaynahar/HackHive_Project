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

// ── Visual Novel Story models ──────────────────

enum ParticleType { none, fireflies, snow, stars, rain, embers }
enum SceneTransition { fade, slideLeft, slideUp }

class Story {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final String difficulty;
  final String coverGradientStart;
  final String coverGradientEnd;
  final int sceneCount;
  final List<StoryScene> scenes;

  const Story({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.difficulty,
    this.coverGradientStart = '0xFF0B1120',
    this.coverGradientEnd = '0xFF1A1A2E',
    required this.sceneCount,
    required this.scenes,
  });
}

class StoryScene {
  final String narration;
  final String? speakerName;
  final String sceneEmoji;
  final String? videoAsset;
  final String bgGradientStart;
  final String bgGradientEnd;
  final ParticleType particles;
  final SceneTransition transition;
  final String? chapterTitle;
  final List<StoryCharacter> characters;
  final StoryCheckpoint? checkpoint;
  final bool isEnding;
  final String? endingTitle;
  final int? retrySceneIndex;

  const StoryScene({
    required this.narration,
    this.speakerName,
    required this.sceneEmoji,
    this.videoAsset,
    this.bgGradientStart = '0xFF0B1120',
    this.bgGradientEnd = '0xFF1A1A2E',
    this.particles = ParticleType.none,
    this.transition = SceneTransition.fade,
    this.chapterTitle,
    this.characters = const [],
    this.checkpoint,
    this.isEnding = false,
    this.endingTitle,
    this.retrySceneIndex,
  });
}

class StoryCharacter {
  final String emoji;
  final String name;
  final String mood;
  final double position; // 0.0 = left, 0.5 = center, 1.0 = right

  const StoryCharacter({
    required this.emoji,
    required this.name,
    this.mood = 'neutral',
    this.position = 0.5,
  });
}

class StoryCheckpoint {
  final String question;
  final List<StoryOption> options;
  final int? timerSeconds;

  const StoryCheckpoint({
    required this.question,
    required this.options,
    this.timerSeconds,
  });
}

class StoryOption {
  final String letter;
  final String text;
  final String emoji;
  final int nextSceneIndex;

  const StoryOption({
    required this.letter,
    required this.text,
    required this.emoji,
    required this.nextSceneIndex,
  });
}


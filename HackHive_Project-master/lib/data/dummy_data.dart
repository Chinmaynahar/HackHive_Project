import '../models/models.dart';

class DummyData {
  // ── User ──────────────────────────────────────
  static const UserStats user = UserStats(
    name: "Rahul",
    level: 4,
    currentXp: 700,
    nextLevelXp: 1000,
    streakDays: 14,
    totalCompleted: 42,
    badge: "Fast Learner ⚡",
  );

  // ── Daily goal ────────────────────────────────
  static const int dailyGoalTotal = 5;
  static const int dailyGoalDone = 2;

  // ── Lessons ───────────────────────────────────
  static final List<Lesson> lessons = [
    const Lesson(
      id: 'l1',
      title: 'Alphabets A–F',
      emoji: '✅',
      totalGestures: 6,
      completedGestures: 6,
      status: LessonStatus.completed,
    ),
    const Lesson(
      id: 'l2',
      title: 'Greetings',
      emoji: '🖐️',
      totalGestures: 6,
      completedGestures: 3,
      status: LessonStatus.inProgress,
    ),
    const Lesson(
      id: 'l3',
      title: 'Numbers 1–10',
      emoji: '🔢',
      totalGestures: 10,
      completedGestures: 0,
      status: LessonStatus.locked,
    ),
    const Lesson(
      id: 'l4',
      title: 'Common Words',
      emoji: '💬',
      totalGestures: 8,
      completedGestures: 0,
      status: LessonStatus.locked,
    ),
  ];

  // ── Gesture steps (active lesson) ─────────────
  static final List<GestureStep> greetingSteps = [
    const GestureStep(word: 'Hi',    emoji: '👋', instruction: 'Wave your hand side to side'),
    const GestureStep(word: 'Bye',   emoji: '🤚', instruction: 'Open palm, move outward'),
    const GestureStep(word: 'Hello', emoji: '🤚', instruction: 'Flat hand at forehead, move outward'),
    const GestureStep(word: 'Thanks',emoji: '🙏', instruction: 'Touch chin, move hand outward'),
    const GestureStep(word: 'Sorry', emoji: '✊', instruction: 'Fist on chest, circular motion'),
    const GestureStep(word: 'Please',emoji: '🖐️', instruction: 'Flat hand on chest, circular motion'),
  ];

  // ── Puppet characters ─────────────────────────
  static final List<PuppetCharacter> puppetChars = [
    PuppetCharacter(id: 'deer',     name: 'Deer',      emoji: '🦌', gestureHint: 'Antlers pose',   isUsed: true),
    PuppetCharacter(id: 'tree',     name: 'Tree',      emoji: '🌲', gestureHint: 'Arms raised up', isUsed: true),
    PuppetCharacter(id: 'bird',     name: 'Bird',      emoji: '🐦', gestureHint: 'Flapping hands', isUsed: true),
    PuppetCharacter(id: 'snake',    name: 'Snake',     emoji: '🐍', gestureHint: 'Wrist wave',     isUsed: false),
    PuppetCharacter(id: 'butterfly',name: 'Butterfly', emoji: '🦋', gestureHint: 'Wing flap',      isUsed: false),
    PuppetCharacter(id: 'mountain', name: 'Mountain',  emoji: '🏔️', gestureHint: 'Peak shape',     isUsed: false),
    PuppetCharacter(id: 'wave',     name: 'Wave',      emoji: '🌊', gestureHint: 'Rolling hand',   isUsed: false),
    PuppetCharacter(id: 'lion',     name: 'Lion',      emoji: '🦁', gestureHint: 'Claw hands',     isUsed: false),
  ];

  // ── Story sequence ────────────────────────────
  static const List<String> storySequence = ['🦌', '🌲', '🐦'];
  static const int maxSequenceLength = 5;

  // ── AI Story text ─────────────────────────────
  static const String aiStory =
      '"In a quiet forest, a deer rested beneath a tall tree as a bird sang from above..."';
}

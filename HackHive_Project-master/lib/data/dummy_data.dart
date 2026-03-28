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
      title: 'Alphabets A-Z',
      emoji: '✅',
      totalGestures: 26,
      completedGestures: 0,
      status: LessonStatus.inProgress,
    ),
    const Lesson(
      id: 'l3',
      title: 'Numbers 1–10',
      emoji: '🔢',
      totalGestures: 10,
      completedGestures: 0,
      status: LessonStatus.inProgress,
    ),
  ];

  // ── Gesture steps (active lesson) ─────────────
  static final List<GestureStep> alphabetSteps = [
    const GestureStep(word: 'A', emoji: '', instruction: 'Fist with thumb resting against the index finger'),
    const GestureStep(word: 'B', emoji: '', instruction: 'Flat hand with fingers together, thumb tucked over palm'),
    const GestureStep(word: 'C', emoji: '', instruction: 'Fingers and thumb curved to form a C shape'),
    const GestureStep(word: 'D', emoji: '', instruction: 'Index finger pointing up, thumb touching curved middle fingers'),
    const GestureStep(word: 'E', emoji: '', instruction: 'Fingers curled inward touching the thumb resting across palm'),
    const GestureStep(word: 'F', emoji: '', instruction: 'Tip of index finger touching tip of thumb, other fingers straight'),
    const GestureStep(word: 'G', emoji: '', instruction: 'Index finger and thumb pointing forward parallel, others curled'),
    const GestureStep(word: 'H', emoji: '', instruction: 'Index and middle fingers pointing forward together, thumb tucked'),
    const GestureStep(word: 'I', emoji: '', instruction: 'Pinky finger pointing straight up, fist closed'),
    const GestureStep(word: 'J', emoji: '', instruction: 'Pinky finger points up and scoops down in a J curve'),
    const GestureStep(word: 'K', emoji: '', instruction: 'Index and middle fingers form a V, thumb placed between them'),
    const GestureStep(word: 'L', emoji: '', instruction: 'Thumb and index finger form an L shape, other fingers curled'),
    const GestureStep(word: 'M', emoji: '', instruction: 'Fist with thumb tucked under first three fingers'),
    const GestureStep(word: 'N', emoji: '', instruction: 'Fist with thumb tucked under first two fingers'),
    const GestureStep(word: 'O', emoji: '', instruction: 'Fingers curve to touch thumb forming an O shape'),
    const GestureStep(word: 'P', emoji: '', instruction: 'Like a K but pointing downward'),
    const GestureStep(word: 'Q', emoji: '', instruction: 'Like a G but pointing downward'),
    const GestureStep(word: 'R', emoji: '', instruction: 'Index and middle fingers crossed, other fingers closed'),
    const GestureStep(word: 'S', emoji: '', instruction: 'Fist with thumb wrapped across the front of fingers'),
    const GestureStep(word: 'T', emoji: '', instruction: 'Fist with thumb tucked under index finger'),
    const GestureStep(word: 'U', emoji: '', instruction: 'Index and middle fingers straight up and together'),
    const GestureStep(word: 'V', emoji: '', instruction: 'Index and middle fingers straight up and apart (V shape)'),
    const GestureStep(word: 'W', emoji: '', instruction: 'Index, middle, and ring fingers straight up and apart'),
    const GestureStep(word: 'X', emoji: '', instruction: 'Fist with index finger bent into a hook'),
    const GestureStep(word: 'Y', emoji: '', instruction: 'Thumb and pinky extended out, other fingers curled in'),
    const GestureStep(word: 'Z', emoji: '', instruction: 'Index finger points and traces a Z shape in the air'),
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

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // ── Interactive Stories (Ramayana Visual Novel) ─
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  static final List<Story> stories = [
    // ⭐ STORY 1 — THE GOLDEN DEER
    Story(
      id: 'golden_deer',
      title: 'The Golden Deer',
      description: 'A tale of deception and consequences. Can you protect Sita from Ravana\'s trap?',
      emoji: '🦌',
      difficulty: 'Hard',
      coverGradientStart: '0xFF1A0A08',
      coverGradientEnd: '0xFF2A1A0A',
      sceneCount: 10,
      scenes: [
        const StoryScene(
          chapterTitle: 'Chapter 1: The Golden Illusion',
          narration: 'Deep in the forest of Panchavati, Rama, Sita, and Lakshman live peacefully in their humble hut. The morning sun filters through the dense canopy...',
          sceneEmoji: '🏡',
          bgGradientStart: '0xFF1A2810',
          bgGradientEnd: '0xFF0A1808',
          particles: ParticleType.fireflies,
          characters: [
            StoryCharacter(emoji: '🏹', name: 'Rama', position: 0.2),
            StoryCharacter(emoji: '👸', name: 'Sita', position: 0.5),
            StoryCharacter(emoji: '⚔️', name: 'Lakshman', position: 0.8),
          ],
        ),
        const StoryScene(
          narration: '"Look! A golden deer with jeweled antlers! Its hide shimmers like molten gold!" Sita\'s eyes light up. The deer prances at the edge of the clearing, almost inviting pursuit...',
          speakerName: 'Sita',
          sceneEmoji: '🦌✨',
          bgGradientStart: '0xFF1A2810',
          bgGradientEnd: '0xFF2A1A08',
          particles: ParticleType.fireflies,
          characters: [
            StoryCharacter(emoji: '👸', name: 'Sita', position: 0.3, mood: 'excited'),
            StoryCharacter(emoji: '🦌', name: 'Maricha', position: 0.7),
          ],
          checkpoint: StoryCheckpoint(
            question: 'What should Sita do?',
            timerSeconds: 15,
            options: [
              StoryOption(letter: 'A', text: 'Ask Rama to catch it', emoji: '⚠️', nextSceneIndex: 2),
              StoryOption(letter: 'B', text: 'Ignore the deer wisely', emoji: '✅', nextSceneIndex: 8),
              StoryOption(letter: 'C', text: 'Go after it alone', emoji: '❌', nextSceneIndex: 9),
              StoryOption(letter: 'D', text: 'Call Lakshman to check', emoji: '🤔', nextSceneIndex: 2),
            ],
          ),
        ),
        const StoryScene(
          chapterTitle: 'Chapter 2: The Chase',
          narration: 'Rama picks up his mighty bow and follows the golden deer deep into the forest. "Stay with Lakshman, Sita. I will return soon." The deer leads him further and further away...',
          speakerName: 'Rama',
          sceneEmoji: '🏹',
          bgGradientStart: '0xFF0A1808',
          bgGradientEnd: '0xFF1A2810',
          particles: ParticleType.fireflies,
          characters: [
            StoryCharacter(emoji: '🏹', name: 'Rama', position: 0.3),
            StoryCharacter(emoji: '🦌', name: 'Golden Deer', position: 0.8),
          ],
        ),
        const StoryScene(
          narration: 'A cry echoes — "Lakshman! Help me!" It sounds exactly like Rama. Sita panics. But Lakshman senses something is wrong...',
          speakerName: 'Narrator',
          sceneEmoji: '😰',
          bgGradientStart: '0xFF1A0A08',
          bgGradientEnd: '0xFF2A1008',
          particles: ParticleType.embers,
          characters: [
            StoryCharacter(emoji: '👸', name: 'Sita', position: 0.3, mood: 'panicked'),
            StoryCharacter(emoji: '⚔️', name: 'Lakshman', position: 0.7, mood: 'alert'),
          ],
          checkpoint: StoryCheckpoint(
            question: 'What should Lakshman do?',
            timerSeconds: 12,
            options: [
              StoryOption(letter: 'A', text: 'Stay and protect Sita', emoji: '✅', nextSceneIndex: 4),
              StoryOption(letter: 'B', text: 'Go help Rama', emoji: '⚠️', nextSceneIndex: 5),
              StoryOption(letter: 'C', text: 'Ignore the cry', emoji: '🤔', nextSceneIndex: 4),
              StoryOption(letter: 'D', text: 'Call others for help', emoji: '📢', nextSceneIndex: 5),
            ],
          ),
        ),
        const StoryScene(
          narration: '"This is not Rama\'s voice. It is a trick. My brother cannot be defeated." Lakshman draws the Lakshman Rekha — a sacred protective line around the hut.',
          speakerName: 'Lakshman',
          sceneEmoji: '🛡️',
          bgGradientStart: '0xFF1A1820',
          bgGradientEnd: '0xFF2A2030',
          particles: ParticleType.embers,
          characters: [
            StoryCharacter(emoji: '⚔️', name: 'Lakshman', position: 0.3),
            StoryCharacter(emoji: '👸', name: 'Sita', position: 0.7),
          ],
          checkpoint: StoryCheckpoint(
            question: 'Ravana arrives disguised as a sage. Sita should:',
            timerSeconds: 10,
            options: [
              StoryOption(letter: 'A', text: 'Stay inside the hut', emoji: '✅', nextSceneIndex: 8),
              StoryOption(letter: 'B', text: 'Cross the Lakshman Rekha', emoji: '❌', nextSceneIndex: 6),
              StoryOption(letter: 'C', text: 'Call for help loudly', emoji: '📢', nextSceneIndex: 8),
              StoryOption(letter: 'D', text: 'Hide deeper inside', emoji: '🫣', nextSceneIndex: 8),
            ],
          ),
        ),
        const StoryScene(
          narration: 'Lakshman reluctantly leaves. Before going, he draws the sacred Lakshman Rekha. "Do NOT cross this line!" Minutes later, a frail sage approaches asking for food...',
          speakerName: 'Lakshman',
          sceneEmoji: '✨',
          bgGradientStart: '0xFF1A0A08',
          bgGradientEnd: '0xFF2A1008',
          particles: ParticleType.embers,
          characters: [
            StoryCharacter(emoji: '👸', name: 'Sita', position: 0.3),
            StoryCharacter(emoji: '🧙', name: 'Ravana', position: 0.7),
          ],
          checkpoint: StoryCheckpoint(
            question: 'Should Sita cross the Lakshman Rekha?',
            timerSeconds: 10,
            options: [
              StoryOption(letter: 'A', text: 'Stay inside the line', emoji: '✅', nextSceneIndex: 8),
              StoryOption(letter: 'B', text: 'Cross to help the sage', emoji: '❌', nextSceneIndex: 6),
              StoryOption(letter: 'C', text: 'Offer food from inside', emoji: '🤔', nextSceneIndex: 8),
              StoryOption(letter: 'D', text: 'Refuse and close door', emoji: '🚪', nextSceneIndex: 8),
            ],
          ),
        ),
        const StoryScene(
          narration: 'The sage transforms into the ten-headed RAVANA! He seizes Sita and lifts her into his flying chariot! But the mighty eagle Jatayu attacks — "Release her, demon!"',
          speakerName: 'Jatayu',
          sceneEmoji: '🦅',
          bgGradientStart: '0xFF2A0808',
          bgGradientEnd: '0xFF1A0408',
          particles: ParticleType.embers,
          characters: [
            StoryCharacter(emoji: '👹', name: 'Ravana', position: 0.2),
            StoryCharacter(emoji: '👸', name: 'Sita', position: 0.5),
            StoryCharacter(emoji: '🦅', name: 'Jatayu', position: 0.8),
          ],
          isEnding: true,
          endingTitle: '⚔️ The Price of Choices',
        ),
        // index 7 unused gap
        const StoryScene(
          narration: '',
          sceneEmoji: '',
          isEnding: true,
          endingTitle: '',
        ),
        const StoryScene(
          narration: 'Wisdom prevails! By staying protected, Sita remains safe. Rama returns victorious after slaying demon Maricha. The family is reunited in peace. 🙏',
          sceneEmoji: '🙏',
          bgGradientStart: '0xFF1A2818',
          bgGradientEnd: '0xFF0A1808',
          particles: ParticleType.fireflies,
          isEnding: true,
          endingTitle: '🕉️ Wisdom Triumphs',
          characters: [
            StoryCharacter(emoji: '🏹', name: 'Rama', position: 0.2),
            StoryCharacter(emoji: '👸', name: 'Sita', position: 0.5),
            StoryCharacter(emoji: '⚔️', name: 'Lakshman', position: 0.8),
          ],
        ),
        const StoryScene(
          narration: 'Going alone was dangerous. Without protection, the forest\'s dangers are overwhelming. One must never act impulsively. Think before you act!',
          sceneEmoji: '⚠️',
          bgGradientStart: '0xFF1A0808',
          bgGradientEnd: '0xFF2A1010',
          particles: ParticleType.embers,
          isEnding: true,
          endingTitle: '📖 Think Before You Act',
          characters: [
            StoryCharacter(emoji: '👸', name: 'Sita', position: 0.5),
          ],
        ),
      ],
    ),

    // ⭐ STORY 2 — HANUMAN'S LEAP TO LANKA
    Story(
      id: 'hanuman_leap',
      title: 'Hanuman\'s Leap to Lanka',
      description: 'The mighty Hanuman must cross the ocean to find Sita. Face obstacles with courage and intelligence!',
      emoji: '🐒',
      difficulty: 'Medium',
      coverGradientStart: '0xFF1A0A18',
      coverGradientEnd: '0xFF0A1828',
      sceneCount: 8,
      scenes: [
        const StoryScene(
          chapterTitle: 'Chapter 1: The Mighty Ocean',
          narration: 'The Vanara army stands at the southern shore, staring at the endless ocean. Lanka lies beyond. "Who among you can cross this mighty sea?" asks Jambavan, the wise bear king.',
          speakerName: 'Jambavan',
          sceneEmoji: '🌊',
          bgGradientStart: '0xFF0A1828',
          bgGradientEnd: '0xFF081020',
          particles: ParticleType.stars,
          characters: [
            StoryCharacter(emoji: '🐻', name: 'Jambavan', position: 0.2),
            StoryCharacter(emoji: '🐒', name: 'Hanuman', position: 0.5),
            StoryCharacter(emoji: '🐵', name: 'Angad', position: 0.8),
          ],
        ),
        const StoryScene(
          narration: '"Son of Vayu, the wind god — you possess limitless strength! Remember who you are!" Jambavan reminds Hanuman of his divine powers. Energy surges through him.',
          speakerName: 'Jambavan',
          sceneEmoji: '💪',
          bgGradientStart: '0xFF1A0A28',
          bgGradientEnd: '0xFF0A1838',
          particles: ParticleType.embers,
          characters: [
            StoryCharacter(emoji: '🐒', name: 'Hanuman', position: 0.5, mood: 'determined'),
          ],
          checkpoint: StoryCheckpoint(
            question: 'What should Hanuman do?',
            options: [
              StoryOption(letter: 'A', text: 'Leap with full confidence', emoji: '✅', nextSceneIndex: 2),
              StoryOption(letter: 'B', text: 'Try to swim across', emoji: '🏊', nextSceneIndex: 7),
              StoryOption(letter: 'C', text: 'Give up — too far', emoji: '❌', nextSceneIndex: 7),
              StoryOption(letter: 'D', text: 'Ask others to go', emoji: '🤔', nextSceneIndex: 7),
            ],
          ),
        ),
        const StoryScene(
          chapterTitle: 'Chapter 2: The Great Leap',
          narration: 'Hanuman grows enormous! He crouches on Mount Mahendra, and with a thunderous roar — "JAI SHRI RAM!" — he leaps! The mountain trembles and the ocean parts below!',
          speakerName: 'Narrator',
          sceneEmoji: '🐒🌊',
          bgGradientStart: '0xFF0A1838',
          bgGradientEnd: '0xFF1A0A28',
          particles: ParticleType.stars,
          characters: [
            StoryCharacter(emoji: '🐒', name: 'Hanuman', position: 0.5),
          ],
        ),
        const StoryScene(
          narration: 'Mid-flight, the demoness Surasa opens her enormous mouth to swallow him! "None may pass without entering my jaws!" she roars.',
          speakerName: 'Surasa',
          sceneEmoji: '🐉',
          bgGradientStart: '0xFF1A1028',
          bgGradientEnd: '0xFF0A0818',
          particles: ParticleType.embers,
          characters: [
            StoryCharacter(emoji: '🐒', name: 'Hanuman', position: 0.3),
            StoryCharacter(emoji: '🐉', name: 'Surasa', position: 0.7),
          ],
          checkpoint: StoryCheckpoint(
            question: 'How should Hanuman defeat Surasa?',
            timerSeconds: 12,
            options: [
              StoryOption(letter: 'A', text: 'Fight with brute strength', emoji: '💪', nextSceneIndex: 4),
              StoryOption(letter: 'B', text: 'Shrink and escape cleverly', emoji: '✅', nextSceneIndex: 4),
              StoryOption(letter: 'C', text: 'Run away', emoji: '❌', nextSceneIndex: 7),
              StoryOption(letter: 'D', text: 'Hide from her', emoji: '🫣', nextSceneIndex: 7),
            ],
          ),
        ),
        const StoryScene(
          chapterTitle: 'Chapter 3: Ashok Vatika',
          narration: 'Hanuman enters Lanka at night, tiny as a bee. The golden city gleams under moonlight. He finally finds Sita in the Ashok Vatika, guarded by fierce demonesses.',
          speakerName: 'Narrator',
          sceneEmoji: '🌙',
          bgGradientStart: '0xFF0A0A18',
          bgGradientEnd: '0xFF1A1028',
          particles: ParticleType.fireflies,
          characters: [
            StoryCharacter(emoji: '🐒', name: 'Hanuman', position: 0.3),
            StoryCharacter(emoji: '👸', name: 'Sita', position: 0.7, mood: 'sorrowful'),
          ],
          checkpoint: StoryCheckpoint(
            question: 'How should Hanuman reveal himself?',
            timerSeconds: 15,
            options: [
              StoryOption(letter: 'A', text: 'Reveal identity calmly', emoji: '✅', nextSceneIndex: 5),
              StoryOption(letter: 'B', text: 'Attack the guards', emoji: '⚠️', nextSceneIndex: 5),
              StoryOption(letter: 'C', text: 'Leave without meeting', emoji: '❌', nextSceneIndex: 7),
              StoryOption(letter: 'D', text: 'Take Sita immediately', emoji: '⚠️', nextSceneIndex: 7),
            ],
          ),
        ),
        const StoryScene(
          narration: 'Hanuman descends gently, chanting Rama\'s name. He presents Rama\'s ring. Tears of joy fill Sita\'s eyes — "Rama has not forgotten me!" Hope returns to her heart.',
          speakerName: 'Sita',
          sceneEmoji: '💍',
          bgGradientStart: '0xFF1A1828',
          bgGradientEnd: '0xFF0A1020',
          particles: ParticleType.fireflies,
          characters: [
            StoryCharacter(emoji: '🐒', name: 'Hanuman', position: 0.3),
            StoryCharacter(emoji: '👸', name: 'Sita', position: 0.7, mood: 'hopeful'),
          ],
        ),
        const StoryScene(
          narration: 'Mission accomplished! Hanuman carries Sita\'s message back to Rama. Self-belief, intelligence, and devotion conquer any obstacle! Jai Hanuman! 🙏',
          sceneEmoji: '🙏',
          bgGradientStart: '0xFF1A1828',
          bgGradientEnd: '0xFF2A1838',
          particles: ParticleType.stars,
          isEnding: true,
          endingTitle: '🙏 Jai Hanuman!',
          characters: [
            StoryCharacter(emoji: '🐒', name: 'Hanuman', position: 0.3),
            StoryCharacter(emoji: '🏹', name: 'Rama', position: 0.7),
          ],
        ),
        const StoryScene(
          narration: 'Without self-belief and courage, even the mightiest cannot succeed. "You are stronger than you think!" Remember Jambavan\'s words — know your true power.',
          sceneEmoji: '📖',
          bgGradientStart: '0xFF1A0A18',
          bgGradientEnd: '0xFF0A0808',
          particles: ParticleType.embers,
          isEnding: true,
          endingTitle: '📖 Believe in Yourself',
          characters: [
            StoryCharacter(emoji: '🐻', name: 'Jambavan', position: 0.5),
          ],
        ),
      ],
    ),

    // ⭐ STORY 3 — SITA SWAYAMVAR
    Story(
      id: 'sita_swayamvar',
      title: 'Sita Swayamvar',
      description: 'Rama must lift the mighty Shiva Dhanush to win Sita\'s hand. A story of calm strength and humility.',
      emoji: '🏹',
      difficulty: 'Easy',
      coverGradientStart: '0xFF180A1A',
      coverGradientEnd: '0xFF281828',
      sceneCount: 7,
      scenes: [
        const StoryScene(
          chapterTitle: 'Chapter 1: The Grand Assembly',
          narration: 'King Janak\'s court is filled with mighty kings from across Aryavart. In the center stands the legendary Shiva Dhanush — a divine bow so heavy no mortal has ever lifted it.',
          speakerName: 'Narrator',
          sceneEmoji: '🏛️',
          bgGradientStart: '0xFF1A1028',
          bgGradientEnd: '0xFF281830',
          particles: ParticleType.embers,
          characters: [
            StoryCharacter(emoji: '👑', name: 'King Janak', position: 0.2),
            StoryCharacter(emoji: '👸', name: 'Sita', position: 0.5),
            StoryCharacter(emoji: '🏹', name: 'Shiva Dhanush', position: 0.8),
          ],
        ),
        const StoryScene(
          narration: 'One by one, the mightiest kings try. They strain, they grunt, they push... but the bow does not move an inch. Even Ravana once failed here. Young Rama watches quietly from the side.',
          speakerName: 'Narrator',
          sceneEmoji: '💪',
          bgGradientStart: '0xFF1A1028',
          bgGradientEnd: '0xFF281830',
          particles: ParticleType.embers,
          characters: [
            StoryCharacter(emoji: '💪', name: 'Kings', position: 0.3),
            StoryCharacter(emoji: '🏹', name: 'Rama', position: 0.7, mood: 'calm'),
          ],
          checkpoint: StoryCheckpoint(
            question: 'What should Rama do?',
            options: [
              StoryOption(letter: 'A', text: 'Try lifting with calm devotion', emoji: '✅', nextSceneIndex: 2),
              StoryOption(letter: 'B', text: 'Show aggressive strength', emoji: '⚠️', nextSceneIndex: 5),
              StoryOption(letter: 'C', text: 'Refuse to participate', emoji: '❌', nextSceneIndex: 6),
              StoryOption(letter: 'D', text: 'Ask Lakshman to try first', emoji: '🤔', nextSceneIndex: 2),
            ],
          ),
        ),
        const StoryScene(
          chapterTitle: 'Chapter 2: The Divine Moment',
          narration: 'Guided by Guru Vishwamitra\'s blessing, Rama walks calmly toward the bow. He bows to Lord Shiva, then touches the bow with gentle reverence. The entire court holds its breath...',
          speakerName: 'Narrator',
          sceneEmoji: '🙏',
          bgGradientStart: '0xFF180A28',
          bgGradientEnd: '0xFF2A1838',
          particles: ParticleType.embers,
          characters: [
            StoryCharacter(emoji: '🏹', name: 'Rama', position: 0.3),
            StoryCharacter(emoji: '🧘', name: 'Vishwamitra', position: 0.7),
          ],
        ),
        const StoryScene(
          narration: 'With effortless grace, Rama lifts the massive bow with ONE HAND! The court gasps. Sita\'s heart fills with joy. King Janak\'s eyes well with tears of happiness.',
          speakerName: 'Narrator',
          sceneEmoji: '😲',
          bgGradientStart: '0xFF1A0A28',
          bgGradientEnd: '0xFF2A1A38',
          particles: ParticleType.embers,
          characters: [
            StoryCharacter(emoji: '🏹', name: 'Rama', position: 0.3),
            StoryCharacter(emoji: '👸', name: 'Sita', position: 0.5, mood: 'joyful'),
            StoryCharacter(emoji: '👑', name: 'Janak', position: 0.8),
          ],
          checkpoint: StoryCheckpoint(
            question: 'What should Rama do next?',
            options: [
              StoryOption(letter: 'A', text: 'String the bow carefully', emoji: '🤔', nextSceneIndex: 4),
              StoryOption(letter: 'B', text: 'Bend it with divine force', emoji: '✅', nextSceneIndex: 4),
              StoryOption(letter: 'C', text: 'Put it down', emoji: '❌', nextSceneIndex: 6),
              StoryOption(letter: 'D', text: 'Hand it to someone', emoji: '❌', nextSceneIndex: 6),
            ],
          ),
        ),
        const StoryScene(
          narration: 'A THUNDEROUS CRACK splits the air! The Shiva Dhanush shatters! Flowers rain from the heavens! The gods celebrate! Sita places the victory garland around Rama\'s neck. 💐',
          speakerName: 'Narrator',
          sceneEmoji: '💐',
          bgGradientStart: '0xFF1A1838',
          bgGradientEnd: '0xFF2A1848',
          particles: ParticleType.embers,
          isEnding: true,
          endingTitle: '🕉️ Jai Shri Ram!',
          characters: [
            StoryCharacter(emoji: '🏹', name: 'Rama', position: 0.3),
            StoryCharacter(emoji: '👸', name: 'Sita', position: 0.5, mood: 'blissful'),
            StoryCharacter(emoji: '👑', name: 'Janak', position: 0.8),
          ],
        ),
        const StoryScene(
          narration: 'True strength is not about force — it is about inner calm and devotion. The bow responds to purity of heart. "Strength without peace is like a river without direction."',
          sceneEmoji: '🧘',
          bgGradientStart: '0xFF1A0A18',
          bgGradientEnd: '0xFF0A0808',
          particles: ParticleType.embers,
          isEnding: true,
          endingTitle: '📖 Calm Strength Wins',
          characters: [
            StoryCharacter(emoji: '🧘', name: 'Vishwamitra', position: 0.5),
          ],
        ),
        const StoryScene(
          narration: 'A warrior never shies away from dharma. Rama\'s destiny was to lift the bow — as yours is to face your challenges. "Arise, and fulfill your purpose!"',
          speakerName: 'Vishwamitra',
          sceneEmoji: '📖',
          bgGradientStart: '0xFF1A0A18',
          bgGradientEnd: '0xFF0A0808',
          particles: ParticleType.stars,
          isEnding: true,
          endingTitle: '📖 Never Give Up',
          characters: [
            StoryCharacter(emoji: '🧘', name: 'Vishwamitra', position: 0.5),
          ],
        ),
      ],
    ),
  ];
}

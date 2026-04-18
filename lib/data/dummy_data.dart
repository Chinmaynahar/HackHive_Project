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
    const Story(
      id: 'golden_deer',
      title: 'The Golden Deer',
      description: 'Follow the true Ramayana tale of Maricha\'s deception and Ravana\'s plot to abduct Sita.',
      emoji: '🦌',
      difficulty: 'Hard',
      coverGradientStart: '0xFF1A0A08',
      coverGradientEnd: '0xFF2A1A0A',
      sceneCount: 10,
      scenes: [
        StoryScene(
          chapterTitle: 'Chapter 1: The Golden Illusion',
          narration: 'Deep in the forest of Panchavati, Rama, Sita, and Lakshman live peacefully in their humble hut. The morning sun filters through the dense canopy...',
          sceneEmoji: '🏡',
          sceneImage: 'assets/images/story_scenes/story1images/Gemini_Generated_Image_f4woumf4woumf4wo.png',
          bgGradientStart: '0xFF1A2810',
          bgGradientEnd: '0xFF0A1808',
          particles: ParticleType.fireflies,
          characters: [
            StoryCharacter(emoji: '🏹', name: 'Rama', position: 0.2),
            StoryCharacter(emoji: '👸', name: 'Sita', position: 0.5),
            StoryCharacter(emoji: '⚔️', name: 'Lakshman', position: 0.8),
          ],
        ),
        StoryScene(
          narration: '"Look! A golden deer with jeweled antlers! Its hide shimmers like molten gold!" Sita\'s eyes light up. Unknown to her, this enchanting creature is the demon Maricha — sent by Ravana to lure Rama away...',
          speakerName: 'Sita',
          sceneEmoji: '🦌✨',
          sceneImage: 'assets/images/story_scenes/story1images/Gemini_Generated_Image_v8vbabv8vbabv8vb.png',
          bgGradientStart: '0xFF1A2810',
          bgGradientEnd: '0xFF2A1A08',
          particles: ParticleType.fireflies,
          characters: [
            StoryCharacter(emoji: '👸', name: 'Sita', position: 0.3, mood: 'excited'),
            StoryCharacter(emoji: '🦌', name: 'Maricha', position: 0.7),
          ],
          checkpoint: StoryCheckpoint(
            question: 'What did Sita do in the Ramayana?',
            timerSeconds: 20,
            options: [
              StoryOption(letter: 'A', text: 'Asked Rama to catch the deer', emoji: '', nextSceneIndex: 2),
              StoryOption(letter: 'B', text: 'Ignored the deer wisely', emoji: '', nextSceneIndex: 9),
              StoryOption(letter: 'C', text: 'Went after it herself', emoji: '', nextSceneIndex: 9),
              StoryOption(letter: 'D', text: 'Called Lakshman to check', emoji: '', nextSceneIndex: 9),
            ],
          ),
        ),
        StoryScene(
          chapterTitle: 'Chapter 2: The Chase',
          narration: 'Rama picks up his mighty bow and follows the golden deer deep into the forest. "Stay with Lakshman, Sita. I will return soon." The deer leads him further and further away. Finally, Rama strikes it with an arrow — and as the demon Maricha falls, he cries out mimicking Rama\'s voice: "Ha Sita! Ha Lakshman!"',
          speakerName: 'Rama',
          sceneEmoji: '🏹',
          sceneImage: 'assets/images/story_scenes/story1images/Gemini_Generated_Image_sywb20sywb20sywb.png',
          bgGradientStart: '0xFF0A1808',
          bgGradientEnd: '0xFF1A2810',
          particles: ParticleType.fireflies,
          characters: [
            StoryCharacter(emoji: '🏹', name: 'Rama', position: 0.3),
            StoryCharacter(emoji: '🦌', name: 'Maricha', position: 0.8),
          ],
        ),
        StoryScene(
          narration: 'Maricha\'s dying cry reaches the hut — "Ha Sita! Ha Lakshman!" Sita is overcome with terror. "Go! Save your brother!" she screams. Lakshman knows it is a trap: "Rama is invincible." But Sita, blinded by fear, accuses him bitterly — "Do you wish harm upon Rama so you can have me for yourself?" Lakshman is devastated by her cruel words...',
          speakerName: 'Narrator',
          sceneEmoji: '😰',
          sceneImage: 'assets/images/story_scenes/story1images/Gemini_Generated_Image_mvx4a1mvx4a1mvx4.png',
          bgGradientStart: '0xFF1A0A08',
          bgGradientEnd: '0xFF2A1008',
          particles: ParticleType.embers,
          characters: [
            StoryCharacter(emoji: '👸', name: 'Sita', position: 0.3, mood: 'panicked'),
            StoryCharacter(emoji: '⚔️', name: 'Lakshman', position: 0.7, mood: 'alert'),
          ],
          checkpoint: StoryCheckpoint(
            question: 'What happened in the Ramayana?',
            timerSeconds: 20,
            options: [
              StoryOption(letter: 'A', text: 'Lakshman leaves reluctantly', emoji: '', nextSceneIndex: 4),
              StoryOption(letter: 'B', text: 'Lakshman stays firm', emoji: '', nextSceneIndex: 8),
              StoryOption(letter: 'C', text: 'Lakshman ignores the cry', emoji: '', nextSceneIndex: 8),
              StoryOption(letter: 'D', text: 'Lakshman calls for help', emoji: '', nextSceneIndex: 8),
            ],
          ),
        ),
        StoryScene(
          narration: 'With tears in his eyes, Lakshman draws a sacred protective line around the hut — the Lakshman Rekha. "Do NOT step beyond this line, no matter what happens! No evil can cross it." He departs to find Rama. Soon after, a frail old sage appears at the boundary, begging for food and water. It is Ravana in disguise...',
          speakerName: 'Lakshman',
          sceneEmoji: '🛡️',
          sceneImage: 'assets/images/story_scenes/story1images/Gemini_Generated_Image_bbiwoybbiwoybbiw.png',
          bgGradientStart: '0xFF1A1820',
          bgGradientEnd: '0xFF2A2030',
          particles: ParticleType.embers,
          characters: [
            StoryCharacter(emoji: '⚔️', name: 'Lakshman', position: 0.3),
            StoryCharacter(emoji: '👸', name: 'Sita', position: 0.7),
          ],
          checkpoint: StoryCheckpoint(
            question: 'What did Sita do in the Ramayana?',
            timerSeconds: 20,
            options: [
              StoryOption(letter: 'A', text: 'Stayed inside the Rekha', emoji: '', nextSceneIndex: 8),
              StoryOption(letter: 'B', text: 'Crossed the Rekha to give alms', emoji: '', nextSceneIndex: 5),
              StoryOption(letter: 'C', text: 'Called for help', emoji: '', nextSceneIndex: 8),
              StoryOption(letter: 'D', text: 'Refused the sage', emoji: '', nextSceneIndex: 8),
            ],
          ),
        ),
        StoryScene(
          narration: 'Moved by compassion and dharma of hospitality, Sita steps beyond the Lakshman Rekha to offer food to the sage. The instant her foot crosses the sacred line, the frail sage\'s form dissolves — revealing the towering, ten-headed RAVANA, king of Lanka! He seizes Sita and lifts her into his flying chariot, Pushpak Vimana!',
          speakerName: 'Narrator',
          sceneEmoji: '✨',
          sceneImage: 'assets/images/story_scenes/story1images/Gemini_Generated_Image_33d1h533d1h533d1.png',
          bgGradientStart: '0xFF1A0A08',
          bgGradientEnd: '0xFF2A1008',
          particles: ParticleType.embers,
          characters: [
            StoryCharacter(emoji: '👸', name: 'Sita', position: 0.3),
            StoryCharacter(emoji: '👹', name: 'Ravana', position: 0.7),
          ],
        ),
        StoryScene(
          narration: 'As Ravana\'s chariot soars through the sky, the mighty eagle Jatayu — old friend of King Dasharatha — swoops to rescue Sita! "Release her, villain!" A fierce battle rages in the skies. Ravana cuts Jatayu\'s wings with his sword. The brave warrior falls, mortally wounded. Sita drops her jewels as a trail for Rama. When Rama finds the dying Jatayu, he learns of Sita\'s fate — setting in motion the great war of Lanka!',
          speakerName: 'Narrator',
          sceneEmoji: '🦅',
          sceneImage: 'assets/images/story_scenes/story1images/Gemini_Generated_Image_d6h1epd6h1epd6h1.png',
          bgGradientStart: '0xFF2A0808',
          bgGradientEnd: '0xFF1A0408',
          particles: ParticleType.embers,
          characters: [
            StoryCharacter(emoji: '👹', name: 'Ravana', position: 0.2),
            StoryCharacter(emoji: '👸', name: 'Sita', position: 0.5),
            StoryCharacter(emoji: '🦅', name: 'Jatayu', position: 0.8),
          ],
          isEnding: true,
          endingTitle: '📜 The Saga of Lanka Begins',
        ),
        // index 7 unused gap
        StoryScene(
          narration: '',
          sceneEmoji: '',
          isEnding: true,
          endingTitle: '',
        ),
        StoryScene(
          narration: 'That is not what happened in the Ramayana. In the great epic, these events unfolded as destiny willed — each step leading to the grand battle between Rama and Ravana, the ultimate triumph of dharma over adharma. Try again and follow the true mythology!',
          sceneImage: 'assets/images/story_scenes/story1images/Gemini_Generated_Image_zbi5dszbi5dszbi5.png',
          sceneEmoji: '📜',
          bgGradientStart: '0xFF1A2818',
          bgGradientEnd: '0xFF0A1808',
          particles: ParticleType.fireflies,
          isEnding: true,
          endingTitle: '📜 Not Quite Right!',
          retrySceneIndex: 3,
          characters: [
            StoryCharacter(emoji: '🏹', name: 'Rama', position: 0.2),
            StoryCharacter(emoji: '👸', name: 'Sita', position: 0.5),
            StoryCharacter(emoji: '⚔️', name: 'Lakshman', position: 0.8),
          ],
        ),
        StoryScene(
          narration: 'That is not what happened! In the Ramayana, Sita was enchanted by the golden deer\'s beauty and asked Rama to capture it for her. This set in motion Ravana\'s carefully planned trap. Follow the true story!',
          sceneImage: 'assets/images/story_scenes/story1images/Gemini_Generated_Image_3qa64f3qa64f3qa6.png',
          sceneEmoji: '📜',
          bgGradientStart: '0xFF1A0808',
          bgGradientEnd: '0xFF2A1010',
          particles: ParticleType.embers,
          isEnding: true,
          endingTitle: '📜 Not Quite Right!',
          retrySceneIndex: 1,
          characters: [
            StoryCharacter(emoji: '👸', name: 'Sita', position: 0.5),
          ],
        ),
      ],
    ),

    // ⭐ STORY 2 — HANUMAN'S LEAP TO LANKA
    const Story(
      id: 'hanuman_leap',
      title: 'Hanuman\'s Leap to Lanka',
      description: 'The mighty Hanuman must cross the ocean to find Sita. Face obstacles with courage and intelligence!',
      emoji: '🐒',
      difficulty: 'Medium',
      coverGradientStart: '0xFF1A0A18',
      coverGradientEnd: '0xFF0A1828',
      sceneCount: 8,
      scenes: [
        StoryScene(
          chapterTitle: 'Chapter 1: The Mighty Ocean',
          narration: 'The Vanara army stands at the southern shore, staring at the endless ocean. Lanka lies beyond. "Who among you can cross this mighty sea?" asks Jambavan, the wise bear king.',
          speakerName: 'Jambavan',
          sceneEmoji: '🌊',
          sceneImage: 'assets/images/story_scenes/story2images/Gemini_Generated_Image_6vkiqn6vkiqn6vki.png',
          bgGradientStart: '0xFF0A1828',
          bgGradientEnd: '0xFF081020',
          particles: ParticleType.stars,
          characters: [
            StoryCharacter(emoji: '🐻', name: 'Jambavan', position: 0.2),
            StoryCharacter(emoji: '🐒', name: 'Hanuman', position: 0.5),
            StoryCharacter(emoji: '🐵', name: 'Angad', position: 0.8),
          ],
        ),
        StoryScene(
          narration: '"Son of Vayu, the wind god — you possess limitless strength! Remember who you are!" Jambavan reminds Hanuman of his divine powers. Energy surges through him.',
          speakerName: 'Jambavan',
          sceneEmoji: '💪',
          sceneImage: 'assets/images/story_scenes/story2images/Gemini_Generated_Image_zef883zef883zef8.png',
          bgGradientStart: '0xFF1A0A28',
          bgGradientEnd: '0xFF0A1838',
          particles: ParticleType.embers,
          characters: [
            StoryCharacter(emoji: '🐒', name: 'Hanuman', position: 0.5, mood: 'determined'),
          ],
          checkpoint: StoryCheckpoint(
            question: 'What should Hanuman do?',
            options: [
              StoryOption(letter: 'A', text: 'Leap with full confidence', emoji: '', nextSceneIndex: 2),
              StoryOption(letter: 'B', text: 'Try to swim across', emoji: '', nextSceneIndex: 7),
              StoryOption(letter: 'C', text: 'Give up — too far', emoji: '', nextSceneIndex: 7),
              StoryOption(letter: 'D', text: 'Ask others to go', emoji: '', nextSceneIndex: 7),
            ],
          ),
        ),
        StoryScene(
          chapterTitle: 'Chapter 2: The Great Leap',
          narration: 'Hanuman grows enormous! He crouches on Mount Mahendra, and with a thunderous roar — "JAI SHRI RAM!" — he leaps! The mountain trembles and the ocean parts below!',
          speakerName: 'Narrator',
          sceneEmoji: '🐒🌊',
          sceneImage: 'assets/images/story_scenes/story2images/Gemini_Generated_Image_rohf4orohf4orohf.png',
          bgGradientStart: '0xFF0A1838',
          bgGradientEnd: '0xFF1A0A28',
          particles: ParticleType.stars,
          characters: [
            StoryCharacter(emoji: '🐒', name: 'Hanuman', position: 0.5),
          ],
        ),
        StoryScene(
          narration: 'Mid-flight, the demoness Surasa — sent by the gods to test Hanuman\'s wit — opens her enormous mouth. "It is ordained that none may pass without entering my jaws!" Each time Hanuman grows larger, she grows larger too!',
          speakerName: 'Surasa',
          sceneEmoji: '🐉',
          sceneImage: 'assets/images/story_scenes/story2images/Gemini_Generated_Image_6orubc6orubc6oru.png',
          bgGradientStart: '0xFF1A1028',
          bgGradientEnd: '0xFF0A0818',
          particles: ParticleType.embers,
          characters: [
            StoryCharacter(emoji: '🐒', name: 'Hanuman', position: 0.3),
            StoryCharacter(emoji: '🐉', name: 'Surasa', position: 0.7),
          ],
          checkpoint: StoryCheckpoint(
            question: 'How did Hanuman outsmart Surasa?',
            timerSeconds: 20,
            options: [
              StoryOption(letter: 'A', text: 'Fought her with brute force', emoji: '', nextSceneIndex: 7),
              StoryOption(letter: 'B', text: 'Shrank tiny, entered and exited her mouth', emoji: '', nextSceneIndex: 4),
              StoryOption(letter: 'C', text: 'Flew around her', emoji: '', nextSceneIndex: 7),
              StoryOption(letter: 'D', text: 'Asked her to let him pass', emoji: '', nextSceneIndex: 7),
            ],
          ),
        ),
        StoryScene(
          chapterTitle: 'Chapter 3: Ashok Vatika',
          narration: 'Hanuman enters Lanka at night, shrinking to the size of a bee. The golden city gleams under moonlight. He searches every palace until he finds Sita in the Ashok Vatika garden, sitting under a tree, guarded by fierce Rakshasis. She weeps, refusing Ravana\'s threats and temptations.',
          speakerName: 'Narrator',
          sceneEmoji: '🌙',
          sceneImage: 'assets/images/story_scenes/story2images/Gemini_Generated_Image_4atgoh4atgoh4atg.png',
          bgGradientStart: '0xFF0A0A18',
          bgGradientEnd: '0xFF1A1028',
          particles: ParticleType.fireflies,
          characters: [
            StoryCharacter(emoji: '🐒', name: 'Hanuman', position: 0.3),
            StoryCharacter(emoji: '👸', name: 'Sita', position: 0.7, mood: 'sorrowful'),
          ],
          checkpoint: StoryCheckpoint(
            question: 'How did Hanuman approach Sita?',
            timerSeconds: 20,
            options: [
              StoryOption(letter: 'A', text: 'Sang Rama\'s glory from a tree, then revealed himself', emoji: '', nextSceneIndex: 5),
              StoryOption(letter: 'B', text: 'Attacked the Rakshasi guards', emoji: '', nextSceneIndex: 7),
              StoryOption(letter: 'C', text: 'Left without meeting her', emoji: '', nextSceneIndex: 7),
              StoryOption(letter: 'D', text: 'Carried Sita away immediately', emoji: '', nextSceneIndex: 7),
            ],
          ),
        ),
        StoryScene(
          narration: 'From a branch above, Hanuman softly chants Rama\'s glories. Sita looks up, startled! He descends gently and presents Rama\'s signet ring as proof. Tears of joy stream down Sita\'s face — "Rama has not forgotten me!" She gives Hanuman her Chudamani (hair jewel) to take back to Rama as proof she is alive.',
          speakerName: 'Sita',
          sceneEmoji: '💍',
          sceneImage: 'assets/images/story_scenes/story2images/Gemini_Generated_Image_xirmz5xirmz5xirm.png',
          bgGradientStart: '0xFF1A1828',
          bgGradientEnd: '0xFF0A1020',
          particles: ParticleType.fireflies,
          characters: [
            StoryCharacter(emoji: '🐒', name: 'Hanuman', position: 0.3),
            StoryCharacter(emoji: '👸', name: 'Sita', position: 0.7, mood: 'hopeful'),
          ],
        ),
        StoryScene(
          narration: 'Before returning, Hanuman burns Lanka with his tail set ablaze by Ravana\'s soldiers! He leaps back across the ocean, carrying Sita\'s Chudamani and her message. Rama is overjoyed and begins preparing the great army to rescue Sita. Intelligence, devotion, and courage — Hanuman embodied them all! Jai Hanuman! 🙏',
          sceneImage: 'assets/images/story_scenes/story2images/Gemini_Generated_Image_ipqym5ipqym5ipqy.png',
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
        StoryScene(
          narration: 'That is not what happened in the Ramayana! Hanuman used divine intelligence and unwavering devotion to Rama to overcome every obstacle. Try again and follow the true story!',
          sceneImage: 'assets/images/story_scenes/story2images/Gemini_Generated_Image_l1f3epl1f3epl1f3.png',
          sceneEmoji: '📜',
          bgGradientStart: '0xFF1A0A18',
          bgGradientEnd: '0xFF0A0808',
          particles: ParticleType.embers,
          isEnding: true,
          endingTitle: '📜 Not Quite Right!',
          retrySceneIndex: 1,
          characters: [
            StoryCharacter(emoji: '🐻', name: 'Jambavan', position: 0.5),
          ],
        ),
      ],
    ),

    // ⭐ STORY 3 — SITA SWAYAMVAR
    const Story(
      id: 'sita_swayamvar',
      title: 'Sita Swayamvar',
      description: 'Rama must lift the mighty Shiva Dhanush to win Sita\'s hand. A story of calm strength and humility.',
      emoji: '🏹',
      difficulty: 'Easy',
      coverGradientStart: '0xFF180A1A',
      coverGradientEnd: '0xFF281828',
      sceneCount: 7,
      scenes: [
        StoryScene(
          chapterTitle: 'Chapter 1: The Grand Assembly',
          narration: 'King Janak\'s court is filled with mighty kings from across Aryavart. In the center stands the legendary Shiva Dhanush — a divine bow so heavy no mortal has ever lifted it. "Whoever strings this bow shall marry my daughter, Sita," declares King Janak.',
          speakerName: 'Narrator',
          sceneEmoji: '🏛️',
          sceneImage: 'assets/images/story_scenes/story3images/Gemini_Generated_Image_np8r4anp8r4anp8r.png',
          bgGradientStart: '0xFF1A1028',
          bgGradientEnd: '0xFF281830',
          particles: ParticleType.embers,
          characters: [
            StoryCharacter(emoji: '👑', name: 'King Janak', position: 0.2),
            StoryCharacter(emoji: '👸', name: 'Sita', position: 0.5),
            StoryCharacter(emoji: '🏹', name: 'Shiva Dhanush', position: 0.8),
          ],
        ),
        StoryScene(
          narration: 'One by one, the mightiest kings try. They strain, they grunt, they push... but the bow does not move an inch. Even Ravana once failed here. King Janak laments, "Is the earth devoid of true heroes?" Young Rama watches quietly from the side, waiting for his Guru\'s command.',
          speakerName: 'Narrator',
          sceneEmoji: '💪',
          sceneImage: 'assets/images/story_scenes/story3images/Gemini_Generated_Image_lhfddilhfddilhfd.png',
          bgGradientStart: '0xFF1A1028',
          bgGradientEnd: '0xFF281830',
          particles: ParticleType.embers,
          characters: [
            StoryCharacter(emoji: '💪', name: 'Kings', position: 0.3),
            StoryCharacter(emoji: '🏹', name: 'Rama', position: 0.7, mood: 'calm'),
          ],
          checkpoint: StoryCheckpoint(
            question: 'How did Rama approach the bow in the Ramayana?',
            options: [
              StoryOption(letter: 'A', text: 'With calm devotion and his Guru\'s blessing', emoji: '', nextSceneIndex: 2),
              StoryOption(letter: 'B', text: 'With aggressive, arrogant strength', emoji: '', nextSceneIndex: 5),
              StoryOption(letter: 'C', text: 'He refused to participate', emoji: '', nextSceneIndex: 6),
              StoryOption(letter: 'D', text: 'He asked Lakshman to try first', emoji: '', nextSceneIndex: 6),
            ],
          ),
        ),
        StoryScene(
          chapterTitle: 'Chapter 2: The Divine Moment',
          narration: 'Guru Vishwamitra finally speaks: "Rise, Rama, and relieve Janak of his sorrow." Rama walks calmly toward the bow. He humbly bows to Lord Shiva, then touches the bow with gentle reverence. The entire court holds its breath...',
          speakerName: 'Narrator',
          sceneEmoji: '🙏',
          sceneImage: 'assets/images/story_scenes/story3images/Gemini_Generated_Image_3cgqvb3cgqvb3cgq.png',
          bgGradientStart: '0xFF180A28',
          bgGradientEnd: '0xFF2A1838',
          particles: ParticleType.embers,
          characters: [
            StoryCharacter(emoji: '🏹', name: 'Rama', position: 0.3),
            StoryCharacter(emoji: '🧘', name: 'Vishwamitra', position: 0.7),
          ],
        ),
        StoryScene(
          narration: 'With effortless grace, Rama lifts the massive bow! The court gasps. He places the string on one end and bends the bow to tie the other. "He lifts it as easily as a garland of flowers," King Janak marvels. Sita\'s heart fills with joy, her prayers to Gauri answered.',
          speakerName: 'Narrator',
          sceneEmoji: '😲',
          sceneImage: 'assets/images/story_scenes/story3images/Gemini_Generated_Image_q3w8xbq3w8xbq3w8.png',
          bgGradientStart: '0xFF1A0A28',
          bgGradientEnd: '0xFF2A1A38',
          particles: ParticleType.embers,
          characters: [
            StoryCharacter(emoji: '🏹', name: 'Rama', position: 0.3),
            StoryCharacter(emoji: '👸', name: 'Sita', position: 0.5, mood: 'joyful'),
            StoryCharacter(emoji: '👑', name: 'Janak', position: 0.8),
          ],
          checkpoint: StoryCheckpoint(
            question: 'What happened when Rama tried to string the bow?',
            options: [
              StoryOption(letter: 'A', text: 'The divine bow snapped in half!', emoji: '', nextSceneIndex: 4),
              StoryOption(letter: 'B', text: 'He strung it perfectly without breaking it', emoji: '', nextSceneIndex: 5),
              StoryOption(letter: 'C', text: 'He put it down gently', emoji: '', nextSceneIndex: 6),
              StoryOption(letter: 'D', text: 'He handed it to someone else', emoji: '', nextSceneIndex: 6),
            ],
          ),
        ),
        StoryScene(
          narration: 'A THUNDEROUS CRACK splits the air, shaking the three worlds! The mighty Shiva Dhanush has shattered from the immense tension! Flowers rain from the heavens, and the gods celebrate. With tears of bliss, Sita places the Jayamala (victory garland) around Rama\'s neck. 💐',
          speakerName: 'Narrator',
          sceneImage: 'assets/images/story_scenes/story3images/Gemini_Generated_Image_ik97aik97aik97ai.png',
          sceneEmoji: '💐',
          bgGradientStart: '0xFF1A1838',
          bgGradientEnd: '0xFF2A1848',
          particles: ParticleType.embers,
          isEnding: true,
          endingTitle: '🕉️ The Divine Union',
          characters: [
            StoryCharacter(emoji: '🏹', name: 'Rama', position: 0.3),
            StoryCharacter(emoji: '👸', name: 'Sita', position: 0.5, mood: 'blissful'),
            StoryCharacter(emoji: '👑', name: 'Janak', position: 0.8),
          ],
        ),
        StoryScene(
          narration: 'That is not what happened in the Ramayana! Rama did not act out of pride, arrogance, or show mere physical strength. He acted out of pure devotion, humility, and duty to his Guru. Try again and choose the path of dharma!',
          sceneEmoji: '📜',
          sceneImage: 'assets/images/story_scenes/story3images/Gemini_Generated_Image_l7yny4l7yny4l7yn.png',
          bgGradientStart: '0xFF1A0A18',
          bgGradientEnd: '0xFF0A0808',
          particles: ParticleType.embers,
          isEnding: true,
          endingTitle: '📜 Not Quite Right!',
          retrySceneIndex: 1,
          characters: [
            StoryCharacter(emoji: '🧘', name: 'Vishwamitra', position: 0.5),
          ],
        ),
        StoryScene(
          narration: 'That is not true to the epic. Rama would never shirk his duty (dharma) or disobey his Guru\'s command. As a warrior prince, it was his destiny to lift the bow. Follow the true story!',
          speakerName: 'Narrator',
          sceneEmoji: '📜',
          sceneImage: 'assets/images/story_scenes/story3images/Gemini_Generated_Image_yl1v18yl1v18yl1v.png',
          bgGradientStart: '0xFF1A0A18',
          bgGradientEnd: '0xFF0A0808',
          particles: ParticleType.stars,
          isEnding: true,
          endingTitle: '📜 Follow the Dharma!',
          retrySceneIndex: 1,
          characters: [
            StoryCharacter(emoji: '🧘', name: 'Vishwamitra', position: 0.5),
          ],
        ),
      ],
    ),
  ];
}

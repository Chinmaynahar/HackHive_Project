"""
Pre-generate all ElevenLabs narration audio as MP3 files.
Uses only Python built-in modules (no pip install needed).

Usage:  python generate_audio.py
"""

import os
import json
import time
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError

API_KEY = "sk_60c955853e27c0e7b38a0359b1ab278d49111d97782a3194"
VOICE_ID = "pNInz6obpgDQGcFmaJgB"  # Adam
BASE_URL = f"https://api.elevenlabs.io/v1/text-to-speech/{VOICE_ID}"

OUTPUT_DIR = os.path.join("assets", "audio", "narration")

# All narration texts from dummy_data.dart
NARRATIONS = [
    # Story 1: The Golden Deer
    ("story1_scene0", "Deep in the forest of Panchavati, Rama, Sita, and Lakshman live peacefully in their humble hut. The morning sun filters through the dense canopy..."),
    ("story1_scene1", "Look! A golden deer with jeweled antlers! Its hide shimmers like molten gold! Sita's eyes light up. Unknown to her, this enchanting creature is the demon Maricha, sent by Ravana to lure Rama away..."),
    ("story1_scene2", "Rama picks up his mighty bow and follows the golden deer deep into the forest. Stay with Lakshman, Sita. I will return soon. The deer leads him further and further away. Finally, Rama strikes it with an arrow, and as the demon Maricha falls, he cries out mimicking Rama's voice: Ha Sita! Ha Lakshman!"),
    ("story1_scene3", "Maricha's dying cry reaches the hut. Ha Sita! Ha Lakshman! Sita is overcome with terror. Go! Save your brother! she screams. Lakshman knows it is a trap: Rama is invincible. But Sita, blinded by fear, accuses him bitterly. Do you wish harm upon Rama so you can have me for yourself? Lakshman is devastated by her cruel words..."),
    ("story1_scene4", "With tears in his eyes, Lakshman draws a sacred protective line around the hut, the Lakshman Rekha. Do NOT step beyond this line, no matter what happens! No evil can cross it. He departs to find Rama. Soon after, a frail old sage appears at the boundary, begging for food and water. It is Ravana in disguise..."),
    ("story1_scene5", "Moved by compassion and dharma of hospitality, Sita steps beyond the Lakshman Rekha to offer food to the sage. The instant her foot crosses the sacred line, the frail sage's form dissolves, revealing the towering, ten-headed RAVANA, king of Lanka! He seizes Sita and lifts her into his flying chariot, Pushpak Vimana!"),
    ("story1_scene6", "As Ravana's chariot soars through the sky, the mighty eagle Jatayu, old friend of King Dasharatha, swoops to rescue Sita! Release her, villain! A fierce battle rages in the skies. Ravana cuts Jatayu's wings with his sword. The brave warrior falls, mortally wounded. Sita drops her jewels as a trail for Rama. When Rama finds the dying Jatayu, he learns of Sita's fate, setting in motion the great war of Lanka!"),
    ("story1_scene8", "That is not what happened in the Ramayana. In the great epic, these events unfolded as destiny willed, each step leading to the grand battle between Rama and Ravana, the ultimate triumph of dharma over adharma. Try again and follow the true mythology!"),
    ("story1_scene9", "That is not what happened! In the Ramayana, Sita was enchanted by the golden deer's beauty and asked Rama to capture it for her. This set in motion Ravana's carefully planned trap. Follow the true story!"),

    # Story 2: Hanuman's Leap to Lanka
    ("story2_scene0", "The Vanara army stands at the southern shore, staring at the endless ocean. Lanka lies beyond. Who among you can cross this mighty sea? asks Jambavan, the wise bear king."),
    ("story2_scene1", "Son of Vayu, the wind god, you possess limitless strength! Remember who you are! Jambavan reminds Hanuman of his divine powers. Energy surges through him."),
    ("story2_scene2", "Hanuman grows enormous! He crouches on Mount Mahendra, and with a thunderous roar, JAI SHRI RAM! he leaps! The mountain trembles and the ocean parts below!"),
    ("story2_scene3", "Mid-flight, the demoness Surasa, sent by the gods to test Hanuman's wit, opens her enormous mouth. It is ordained that none may pass without entering my jaws! Each time Hanuman grows larger, she grows larger too!"),
    ("story2_scene4", "Hanuman enters Lanka at night, shrinking to the size of a bee. The golden city gleams under moonlight. He searches every palace until he finds Sita in the Ashok Vatika garden, sitting under a tree, guarded by fierce Rakshasis. She weeps, refusing Ravana's threats and temptations."),
    ("story2_scene5", "From a branch above, Hanuman softly chants Rama's glories. Sita looks up, startled! He descends gently and presents Rama's signet ring as proof. Tears of joy stream down Sita's face. Rama has not forgotten me! She gives Hanuman her Chudamani, a hair jewel, to take back to Rama as proof she is alive."),
    ("story2_scene6", "Before returning, Hanuman burns Lanka with his tail set ablaze by Ravana's soldiers! He leaps back across the ocean, carrying Sita's Chudamani and her message. Rama is overjoyed and begins preparing the great army to rescue Sita. Intelligence, devotion, and courage, Hanuman embodied them all! Jai Hanuman!"),
    ("story2_scene7", "That is not what happened in the Ramayana! Hanuman used divine intelligence and unwavering devotion to Rama to overcome every obstacle. Try again and follow the true story!"),

    # Story 3: Sita Swayamvar
    ("story3_scene0", "King Janak's court is filled with mighty kings from across Aryavart. In the center stands the legendary Shiva Dhanush, a divine bow so heavy no mortal has ever lifted it. Whoever strings this bow shall marry my daughter, Sita, declares King Janak."),
    ("story3_scene1", "One by one, the mightiest kings try. They strain, they grunt, they push... but the bow does not move an inch. Even Ravana once failed here. King Janak laments, Is the earth devoid of true heroes? Young Rama watches quietly from the side, waiting for his Guru's command."),
    ("story3_scene2", "Guru Vishwamitra finally speaks: Rise, Rama, and relieve Janak of his sorrow. Rama walks calmly toward the bow. He humbly bows to Lord Shiva, then touches the bow with gentle reverence. The entire court holds its breath..."),
    ("story3_scene3", "With effortless grace, Rama lifts the massive bow! The court gasps. He places the string on one end and bends the bow to tie the other. He lifts it as easily as a garland of flowers, King Janak marvels. Sita's heart fills with joy, her prayers to Gauri answered."),
    ("story3_scene4", "A THUNDEROUS CRACK splits the air, shaking the three worlds! The mighty Shiva Dhanush has shattered from the immense tension! Flowers rain from the heavens, and the gods celebrate. With tears of bliss, Sita places the Jayamala, the victory garland, around Rama's neck."),
    ("story3_scene5", "That is not what happened in the Ramayana! Rama did not act out of pride, arrogance, or show mere physical strength. He acted out of pure devotion, humility, and duty to his Guru. Try again and choose the path of dharma!"),
    ("story3_scene6", "That is not true to the epic. Rama would never shirk his duty, his dharma, or disobey his Guru's command. As a warrior prince, it was his destiny to lift the bow. Follow the true story!"),
]


def generate_audio(name, text):
    out_path = os.path.join(OUTPUT_DIR, f"{name}.mp3")

    if os.path.exists(out_path) and os.path.getsize(out_path) > 1000:
        print(f"  [SKIP] {name}.mp3 already exists")
        return True

    print(f"  [GEN]  {name} ({len(text)} chars)...", end=" ", flush=True)

    payload = json.dumps({
        "text": text,
        "model_id": "eleven_multilingual_v2",
        "voice_settings": {
            "stability": 0.50,
            "similarity_boost": 0.75,
        }
    }).encode("utf-8")

    req = Request(BASE_URL, data=payload, method="POST")
    req.add_header("xi-api-key", API_KEY)
    req.add_header("Content-Type", "application/json")
    req.add_header("Accept", "audio/mpeg")

    try:
        with urlopen(req, timeout=30) as resp:
            audio = resp.read()
            with open(out_path, "wb") as f:
                f.write(audio)
            print(f"OK ({len(audio)} bytes)")
            return True
    except HTTPError as e:
        body = e.read().decode("utf-8", errors="replace")
        print(f"HTTP {e.code}: {body[:150]}")
        return False
    except URLError as e:
        print(f"Network error: {e.reason}")
        return False
    except Exception as e:
        print(f"Error: {e}")
        return False


def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    print(f"\n  ElevenLabs Audio Pre-Generator")
    print(f"  Voice: Rachel ({VOICE_ID})")
    print(f"  Output: {OUTPUT_DIR}/")
    print(f"  Total: {len(NARRATIONS)} narrations\n")

    ok = 0
    fail = 0

    for name, text in NARRATIONS:
        if not text.strip():
            continue
        if generate_audio(name, text):
            ok += 1
        else:
            fail += 1
        time.sleep(1.0)  # rate limit buffer

    print(f"\n  Done! {ok} generated, {fail} failed\n")


if __name__ == "__main__":
    main()

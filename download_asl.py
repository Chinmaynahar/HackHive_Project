import urllib.request
import os
import string
import time

DIR = "assets/images/asl"
os.makedirs(DIR, exist_ok=True)

for c in string.ascii_uppercase:
    if os.path.exists(f"{DIR}/{c}.png") and os.path.getsize(f"{DIR}/{c}.png") > 1000:
        continue
    url = f"https://commons.wikimedia.org/wiki/Special:FilePath/Sign_language_{c}.svg?width=256"
    print(f"Downloading {c}...")
    headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"}
    req = urllib.request.Request(url, headers=headers)
    success = False
    for attempt in range(3):
        try:
            with urllib.request.urlopen(req) as resp, open(f"{DIR}/{c}.png", 'wb') as f:
                f.write(resp.read())
            success = True
            break
        except Exception as e:
            print(f"Attempt {attempt+1} failed for {c}: {e}")
            time.sleep(2)
    if success:
        time.sleep(1)
print("Done!")

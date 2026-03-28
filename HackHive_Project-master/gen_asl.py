import urllib.request, json, string
with open('lib/data/asl_images.dart', 'w', encoding='utf-8') as f:
    f.write('class ASLImages {\n')
    f.write('  static const Map<String, String> urls = {\n')
    for c in string.ascii_uppercase:
        url = f"https://en.wikipedia.org/w/api.php?action=query&titles=File:Sign_language_{c}.svg&prop=imageinfo&iiprop=url&format=json"
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        try:
            data = json.loads(urllib.request.urlopen(req).read().decode())
            pages = data['query']['pages']
            img_url = list(pages.values())[0]['imageinfo'][0]['url']
            hash_part = img_url.split('/commons/')[1].split(f'/Sign_')[0]
            thumb_url = f"https://upload.wikimedia.org/wikipedia/commons/thumb/{hash_part}/Sign_language_{c}.svg/512px-Sign_language_{c}.svg.png"
            f.write(f"    '{c}': '{thumb_url}',\n")
        except Exception as e:
            f.write(f"    // Error {c} {e}\n")
    f.write('  };\n')
    f.write('}\n')

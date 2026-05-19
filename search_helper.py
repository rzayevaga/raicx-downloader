#!/usr/bin/env python3
import sys, subprocess, json

def search(query):
    try:
        result = subprocess.check_output(
            ['yt-dlp', '-j', '--flat-playlist', f'ytsearch10:{query}'],
            stderr=subprocess.DEVNULL
        )
        lines = result.strip().splitlines()
        videos = []
        for line in lines:
            info = json.loads(line)
            videos.append({
                'id': info.get('id'),
                'title': info.get('title', ''),
                'duration': info.get('duration', 0)
            })
        return videos
    except Exception as e:
        print(f"[Xəta] {e}", file=sys.stderr)
        return []

def main():
    if len(sys.argv) < 2:
        print("İstifadə: python search_helper.py <axtarış sözü>")
        sys.exit(1)
    query = ' '.join(sys.argv[1:])
    videos = search(query)
    if not videos:
        print("NƏTİCƏ_YOXDUR")
        sys.exit(1)
    for i, v in enumerate(videos, 1):
        print(f"{i}::{v['title']}")
    print("SEÇİM")
    try:
        choice = input("Nəticə nömrəsini seçin (1-10): ").strip()
        if choice.isdigit():
            idx = int(choice) - 1
            if 0 <= idx < len(videos):
                print(f"LINK:https://youtu.be/{videos[idx]['id']}")
                return
    except (EOFError, KeyboardInterrupt):
        pass
    print("LINK:İPTAL")

if __name__ == "__main__":
    main()

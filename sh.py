#!/usr/bin/env python3
import sys
import subprocess
import json
import time

def search_fast(query, max_results=20):
    try:
        result = subprocess.check_output(
            ['yt-dlp', '-j', '--flat-playlist', f'ytsearch{max_results}:{query}'],
            stderr=subprocess.DEVNULL,
            timeout=15
        )
        lines = result.strip().splitlines()
        videos = []
        for line in lines:
            info = json.loads(line)
            videos.append({
                'id': info.get('id'),
                'title': info.get('title', '')[:80],
                'duration': info.get('duration', 0)
            })
        return videos
    except subprocess.TimeoutExpired:
        return []
    except Exception:
        return []

def main():
    if len(sys.argv) < 2:
        print("NƏTİCƏ_YOXDUR")
        sys.exit(1)
    
    query = ' '.join(sys.argv[1:])
    videos = search_fast(query, 20)
    
    if not videos:
        print("NƏTİCƏ_YOXDUR")
        sys.exit(1)
    
    for i, v in enumerate(videos, 1):
        dur = v['duration']
        dur_str = f"{dur//60}:{dur%60:02d}" if dur else "?"
        print(f"{i}::[{dur_str}] {v['title']}")
    
    print("SEÇİM")
    try:
        choice = input("Nəticə nömrəsini seçin (1-20): ").strip()
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

#!/usr/bin/env python3
import sys
import subprocess
import json

def search_fast(query, max_results=20):
    try:
        result = subprocess.check_output(
            [sys.executable, '-m', 'yt_dlp', '-j', '--flat-playlist', f'ytsearch{max_results}:{query}'],
            stderr=subprocess.DEVNULL,
            timeout=15
        )
        
        result_str = result.decode('utf-8', errors='ignore')
        lines = result_str.strip().splitlines()
        
        videos = []
        for line in lines:
            if not line.strip():
                continue
            try:
                info = json.loads(line)
                if info.get('_type') == 'url' or info.get('id'):
                    videos.append({
                        'id': info.get('id'),
                        'title': info.get('title', '')[:80],
                        'duration': info.get('duration', 0)
                    })
            except json.JSONDecodeError:
                continue
        return videos
        
    except subprocess.TimeoutExpired:
        print("XƏTA: Axtarış vaxtı keçdi (Timeout).", file=sys.stderr)
        return []
    except Exception as e:
        print(f"Sistem xətası: {e}", file=sys.stderr)
        return []

def main():
    if len(sys.argv) < 2:
        print("İstifadə qaydası: python sh.py <axtarış sözü>")
        sys.exit(1)
    
    query = ' '.join(sys.argv[1:])
    videos = search_fast(query, 20)
    
    if not videos:
        print("NƏTİCƏ_YOXDUR")
        sys.exit(1)
    
    for i, v in enumerate(videos, 1):
        dur = v.get('duration')
        try:
            dur = int(dur) if dur else 0
            dur_str = f"{dur//60}:{dur%60:02d}" if dur > 0 else "?"
        except Exception:
            dur_str = "?"
            
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

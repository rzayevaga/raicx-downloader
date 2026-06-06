#!/usr/bin/env python3
import sys
import subprocess
import json

def search_fast(query, max_results=20):
    try:
        # stderr=subprocess.DEVNULL hissəsini sildik ki, yt-dlp-nin daxili xətalarını görə bilək
        result = subprocess.check_output(
            ['yt-dlp', '-j', '--flat-playlist', f'ytsearch{max_results}:{query}'],
            timeout=15
        )
        
        # Alınan nəticəni baytdan (bytes) mətnə (utf-8) çeviririk
        result_str = result.decode('utf-8', errors='ignore')
        lines = result_str.strip().splitlines()
        
        videos = []
        for line in lines:
            if not line.strip():
                continue
            try:
                info = json.loads(line)
                videos.append({
                    'id': info.get('id'),
                    'title': info.get('title', '')[:80],
                    'duration': info.get('duration', 0)
                })
            except json.JSONDecodeError:
                continue
        return videos
        
    except FileNotFoundError:
        print("XƏTA: 'yt-dlp' sistemi tapılmadı! Terminalda 'pip install yt-dlp' yazaraq quraşdırın.", file=sys.stderr)
        return []
    except subprocess.CalledProcessError as e:
        print(f"XƏTA: yt-dlp işləyərkən xəta verdi (Çıxış kodu: {e.returncode}).", file=sys.stderr)
        return []
    except subprocess.TimeoutExpired:
        print("XƏTA: Axtarış vaxtı keçdi (Timeout). İnternet sürətini yoxlayın.", file=sys.stderr)
        return []
    except Exception as e:
        print(f"Gözlənilməz xəta baş verdi: {e}", file=sys.stderr)
        return []

def main():
    if len(sys.argv) < 2:
        print("İstifadə qaydası: python script_adı.py <axtarış sözü>")
        sys.exit(1)
    
    query = ' '.join(sys.argv[1:])
    videos = search_fast(query, 20)
    
    if not videos:
        print("NƏTİCƏ_YOXDUR")
        sys.exit(1)
    
    for i, v in enumerate(videos, 1):
        dur = v['duration']
        # Müddəti (duration) təhlükəsiz şəkildə hesablamaq
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

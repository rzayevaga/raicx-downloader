#!/usr/bin/env python3
import os
import sys
import json
import shutil
import subprocess
import requests
from tqdm import tqdm
from concurrent.futures import ThreadPoolExecutor, as_completed

API_URL = "https://tikwm.com/api/"

def clean_filename(text):
    import re
    return re.sub(r'[<>:"/\\|?*]', '_', str(text).strip())[:100]

def download_file(url, path, desc=None):
    headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"}
    resp = requests.get(url, headers=headers, stream=True, timeout=30)
    resp.raise_for_status()
    total = int(resp.headers.get('content-length', 0))
    desc = desc or os.path.basename(path)
    with open(path, 'wb') as f, tqdm(desc=desc, total=total, unit='B', unit_scale=True, colour='green', leave=False) as bar:
        for chunk in resp.iter_content(chunk_size=8192):
            f.write(chunk)
            bar.update(len(chunk))
    return True

def download_video(url, path):
    headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"}
    resp = requests.get(url, headers=headers, stream=True, timeout=60)
    resp.raise_for_status()
    total = int(resp.headers.get('content-length', 0))
    with open(path, 'wb') as f, tqdm(desc="Video", total=total, unit='B', unit_scale=True, colour='green', leave=False) as bar:
        for chunk in resp.iter_content(chunk_size=8192):
            f.write(chunk)
            bar.update(len(chunk))
    return path

def download_image(url, path):
    headers = {"User-Agent": "Mozilla/5.0"}
    resp = requests.get(url, headers=headers, timeout=30)
    resp.raise_for_status()
    with open(path, 'wb') as f:
        f.write(resp.content)
    return path

def download_images_parallel(urls, folder):
    paths = []
    with ThreadPoolExecutor(max_workers=8) as executor:
        futures = {}
        for i, url in enumerate(urls):
            path = os.path.join(folder, f"slide_{i+1:02d}.jpg")
            futures[executor.submit(download_image, url, path)] = path
        for future in tqdm(as_completed(futures), total=len(futures), desc="Şəkillər", unit="img", colour='green'):
            paths.append(future.result())
    return paths

def run_ffmpeg(cmd):
    proc = subprocess.Popen(cmd, stderr=subprocess.PIPE, universal_newlines=True)
    for line in proc.stderr:
        if "time=" in line:
            pass
    proc.wait()
    return proc.returncode

def combine_slideshow(images, audio, out):
    duration_cmd = ['ffprobe', '-v', 'error', '-show_entries', 'format=duration',
                    '-of', 'default=noprint_wrappers=1:nokey=1', audio]
    try:
        dur = float(subprocess.check_output(duration_cmd).strip())
    except Exception:
        dur = 5.0
    per_img = dur / len(images)
    concat_file = os.path.join(os.path.dirname(out), "slideshow_list.txt")
    with open(concat_file, 'w') as f:
        for img in images:
            f.write(f"file '{os.path.abspath(img)}'\n")
            f.write(f"duration {per_img}\n")
        f.write(f"file '{os.path.abspath(images[-1])}'\n")
    cmd = ['ffmpeg', '-y', '-f', 'concat', '-safe', '0', '-i', concat_file, '-i', audio,
           '-vf', "scale=trunc(iw/2)*2:trunc(ih/2)*2,format=yuv420p",
           '-c:v', 'libx264', '-c:a', 'aac', '-b:a', '192k', '-shortest', out]
    ret = run_ffmpeg(cmd)
    if os.path.exists(concat_file):
        os.remove(concat_file)
    return ret == 0

def main():
    url = sys.argv[1]
    mode = sys.argv[2]
    output_dir = sys.argv[3] if len(sys.argv) > 3 else "TikTok_Downloads"
    try:
        r = requests.get(API_URL, params={"url": url}, headers={"User-Agent": "Mozilla/5.0"}, timeout=15)
        data = r.json()
        if data.get("code") != 0:
            print("API xətası")
            sys.exit(1)
        post = data["data"]
        post_id = post.get("id", "unknown")
        author = post.get("author", {}).get("nickname", "unknown")
        folder = os.path.join(output_dir, f"{clean_filename(author)}_{post_id}")
        os.makedirs(folder, exist_ok=True)
        images = post.get("images", [])
        music_url = post.get("music")
        video_url = post.get("play")
        image_paths = []
        music_path = None
        video_path = None
        if mode == "1":
            if images:
                image_paths = download_images_parallel(images, folder)
                print(f"[✓] {len(image_paths)} şəkil endirildi.")
        elif mode == "2":
            if music_url:
                music_path = os.path.join(folder, "music.mp3")
                download_file(music_url, music_path, "Musiqi")
                print(f"[✓] Musiqi endirildi: {music_path}")
        elif mode == "3":
            if images and music_url and shutil.which("ffmpeg"):
                image_paths = download_images_parallel(images, folder)
                music_path = os.path.join(folder, "music.mp3")
                download_file(music_url, music_path, "Musiqi")
                video_out = os.path.join(folder, "combined_video.mp4")
                if combine_slideshow(image_paths, music_path, video_out):
                    print(f"[✓] Birləşdirilmiş video hazır: {video_out}")
                    for img in image_paths:
                        os.remove(img)
                    os.remove(music_path)
                else:
                    print("[✗] FFmpeg xətası")
            elif video_url:
                video_path = os.path.join(folder, "video.mp4")
                download_video(video_url, video_path)
                print(f"[✓] Video endirildi: {video_path}")
        elif mode == "4":
            if images:
                image_paths = download_images_parallel(images, folder)
                print(f"[✓] {len(image_paths)} şəkil endirildi.")
            if music_url:
                music_path = os.path.join(folder, "music.mp3")
                download_file(music_url, music_path, "Musiqi")
                print(f"[✓] Musiqi endirildi: {music_path}")
            if video_url:
                video_path = os.path.join(folder, "video.mp4")
                download_video(video_url, video_path)
                print(f"[✓] Video endirildi: {video_path}")
        elif mode == "5":
            if images:
                image_paths = download_images_parallel(images, folder)
                print(f"[✓] {len(image_paths)} şəkil endirildi.")
            if music_url:
                music_path = os.path.join(folder, "music.mp3")
                download_file(music_url, music_path, "Musiqi")
                print(f"[✓] Musiqi endirildi: {music_path}")
            if video_url:
                video_path = os.path.join(folder, "video.mp4")
                download_video(video_url, video_path)
                print(f"[✓] Video endirildi: {video_path}")
            if image_paths and music_path and shutil.which("ffmpeg"):
                video_out = os.path.join(folder, "slideshow_video.mp4")
                if combine_slideshow(image_paths, music_path, video_out):
                    print(f"[✓] Slayd-video hazır: {video_out}")
                else:
                    print("[✗] FFmpeg xətası")
        print(f"[✓] Əməliyyat tamam. Qovluq: {folder}")
    except Exception as e:
        print(f"[✗] Xəta: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()

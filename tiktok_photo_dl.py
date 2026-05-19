#!/usr/bin/env python3
import os, sys, json, shutil, subprocess, requests
from tqdm import tqdm
from tqdm.contrib.concurrent import thread_map

API_URL = "https://tikwm.com/api/"

def clean_filename(text):
    import re
    return re.sub(r'[<>:"/\\|?*]', '_', str(text).strip())[:100]

def download_silent(args):
    url, path = args
    headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"}
    resp = requests.get(url, headers=headers, stream=True, timeout=30)
    resp.raise_for_status()
    with open(path, 'wb') as f:
        for chunk in resp.iter_content(chunk_size=8192):
            f.write(chunk)
    return path

def download_file(url, path, desc=None):
    headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"}
    resp = requests.get(url, headers=headers, stream=True)
    total = int(resp.headers.get('content-length', 0))
    desc = desc or os.path.basename(path)
    with open(path, 'wb') as f, tqdm(desc=desc, total=total, unit='B', unit_scale=True, colour='green') as bar:
        for chunk in resp.iter_content(chunk_size=8192):
            f.write(chunk)
            bar.update(len(chunk))
    return True

def download_images_parallel(urls_paths, desc="Images"):
    thread_map(download_silent, urls_paths, max_workers=8, desc=desc, unit='img')
    print()

def run_ffmpeg(cmd):
    proc = subprocess.Popen(cmd, stderr=subprocess.PIPE, universal_newlines=True)
    for line in proc.stderr:
        if "time=" in line:
            pass
    proc.wait()
    return proc.returncode

def combine_image_audio(img, audio, out):
    cmd = ['ffmpeg', '-y', '-loop', '1', '-i', img, '-i', audio,
           '-vf', "scale=trunc(iw/2)*2:trunc(ih/2)*2,format=yuv420p",
           '-c:v', 'libx264', '-c:a', 'aac', '-b:a', '192k', '-shortest', out]
    ret = run_ffmpeg(cmd)
    if ret == 0:
        print(f"[✓] Video hazır: {out}")
    else:
        print("[✗] FFmpeg xətası")

def combine_slideshow(images, audio, out):
    duration_cmd = ['ffprobe', '-v', 'error', '-show_entries', 'format=duration',
                    '-of', 'default=noprint_wrappers=1:nokey=1', audio]
    try:
        dur = float(subprocess.check_output(duration_cmd).strip())
    except:
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
    if ret == 0:
        print(f"[✓] Slayd-video hazır: {out}")
    else:
        print("[✗] FFmpeg xətası")

def main():
    url = sys.argv[1]
    mode = sys.argv[2]
    output_dir = sys.argv[3] if len(sys.argv) > 3 else "TikTok_Downloads"
    try:
        r = requests.get(API_URL, params={"url": url}, headers={"User-Agent": "Mozilla/5.0"})
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
        image_paths = []
        if mode in ("1", "3", "4"):
            urls_paths = [(images[i], os.path.join(folder, f"slide_{i+1:02d}.jpg")) for i in range(len(images))]
            download_images_parallel(urls_paths, "Şəkillər")
            image_paths = [os.path.join(folder, f"slide_{i+1:02d}.jpg") for i in range(len(images))]
        if mode in ("2", "3", "4") and music_url:
            music_path = os.path.join(folder, "music.mp3")
            download_file(music_url, music_path, "Musiqi")
            if mode == "4" and image_paths:
                if shutil.which("ffmpeg") is None:
                    print("ffmpeg tapılmadı, birləşdirmə keçildi.")
                else:
                    video_out = os.path.join(folder, "combined_video.mp4")
                    if len(image_paths) == 1:
                        combine_image_audio(image_paths[0], music_path, video_out)
                    else:
                        combine_slideshow(image_paths, music_path, video_out)
        print(f"[✓] Əməliyyat tamam. Qovluq: {folder}")
    except Exception as e:
        print(f"[✗] Xəta: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()

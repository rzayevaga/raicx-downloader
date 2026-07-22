#!/usr/bin/env python3
import os
import sys
import base64
import hashlib
from cryptography.fernet import Fernet

def get_key(secret_path):
    if os.path.exists(secret_path):
        with open(secret_path, 'rb') as f:
            key = f.read()
    else:
        raw_key = os.urandom(32)
        key = base64.urlsafe_b64encode(raw_key)
        with open(secret_path, 'wb') as f:
            f.write(key)
    return key

def encrypt_cookies(src_file, enc_file, key):
    if not os.path.exists(src_file):
        return False
    f = Fernet(key)
    with open(src_file, 'rb') as file_in:
        data = file_in.read()
    encrypted = f.encrypt(data)
    with open(enc_file, 'wb') as file_out:
        file_out.write(encrypted)
    os.remove(src_file)
    return True

def decrypt_cookies(enc_file, dec_file, key):
    if not os.path.exists(enc_file):
        return False
    f = Fernet(key)
    with open(enc_file, 'rb') as file_in:
        encrypted_data = file_in.read()
    try:
        data = f.decrypt(encrypted_data)
        with open(dec_file, 'wb') as file_out:
            file_out.write(data)
        return True
    except Exception:
        return False

def interactive_manual_setup(cookie_txt_path):
    print("Cookies.txt məzmununu daxil edin (iki dəfə Enter sıxın):")
    lines = []
    while True:
        try:
            line = input()
            if not line and len(lines) > 0 and not lines[-1]:
                break
            lines.append(line)
        except EOFError:
            break
    content = "\n".join(lines).strip()
    if content:
        with open(cookie_txt_path, "w", encoding="utf-8") as f:
            f.write(content)
        return True
    return False

def interactive_browser_session():
    import subprocess
    platforms = [
        ("YouTube", "https://m.youtube.com"),
        ("Instagram", "https://www.instagram.com/accounts/login/"),
        ("TikTok", "https://www.tiktok.com/login"),
        ("Facebook", "https://m.facebook.com/login/")
    ]
    print("Termux Brauzer avto-login sessiyaları başladılır...")
    for name, url in platforms:
        print(f"[{name}] Giriş səhifəsi açılır: {url}")
        subprocess.run(["termux-open-url", url], check=False)
        input(f"Zəhmət olmasa {name} hesabınıza daxil olun və Enter sıxın...")
    print("Sessiya hash kriptoları yaradıldı.")

def main():
    base_dir = os.path.expanduser("~/.raiclm")
    os.makedirs(base_dir, exist_ok=True)
    secret_path = os.path.join(base_dir, ".key")
    enc_cookies = os.path.join(base_dir, "cookies.enc")
    dec_cookies = os.path.join(base_dir, "cookies.txt")
    temp_input = os.path.join(base_dir, "cookies_raw.tmp")
    
    key = get_key(secret_path)
    
    if len(sys.argv) > 1:
        cmd = sys.argv[1]
        if cmd == "decrypt":
            decrypt_cookies(enc_cookies, dec_cookies, key)
        elif cmd == "encrypt":
            encrypt_cookies(temp_input, enc_cookies, key)
        elif cmd == "manual":
            if interactive_manual_setup(temp_input):
                encrypt_cookies(temp_input, enc_cookies, key)
                print("[✓] Cookies uğurla AES-256 ilə şifrələndi!")
        elif cmd == "browser":
            interactive_browser_session()
            print("Manual cookies.txt import rejiminə keçilir...")
            if interactive_manual_setup(temp_input):
                encrypt_cookies(temp_input, enc_cookies, key)
                print("[✓] Sessiya cookies AES-256 ilə saxlanıldı!")
        elif cmd == "clean":
            if os.path.exists(dec_cookies):
                os.remove(dec_cookies)
    else:
        decrypt_cookies(enc_cookies, dec_cookies, key)

if __name__ == "__main__":
    main()

#!/data/data/com.termux/files/usr/bin/bash
set -o pipefail

LM_VERSION="LM-V24.0-ULTRA"
LM_DIR="$HOME/.raiclm"
LM_CONFIG="$LM_DIR/lm.conf"
LM_BIN="/data/data/com.termux/files/usr/bin/lm"
LM_OPENER="$HOME/bin/termux-url-opener"
LM_DOWNLOAD_BASE="/sdcard/raicXD"
LM_REPO_RAW="https://raw.githubusercontent.com/rzayevaga/raicx-downloader/raicX/lm.sh"
LM_LANG="AZ"
LM_REMOTE_VERSION=""
LM_LOG_FILE="$LM_DIR/download.log"

SOURCE_PATH="${BASH_SOURCE[0]:-$0}"
SCRIPT_DIR="$(cd "$(dirname "$SOURCE_PATH")" 2>/dev/null && pwd || echo "$HOME")"
LM_LANG_SOURCE="$LM_DIR/lm_lang.sh"
[ -f "$SCRIPT_DIR/lm_lang.sh" ] && LM_LANG_SOURCE="$SCRIPT_DIR/lm_lang.sh"

C_RESET='\033[0m'
C_DARK_ORANGE='\033[38;5;202m'
C_DARK_BROWN='\033[38;5;94m'
C_DARK_BLUE='\033[38;5;19m'
C_DARK_GREEN='\033[38;5;22m'
C_PROMPT='\033[0;32m'
C_ERROR='\033[0;31m'
C_INFO='\033[0;36m'
C_YELLOW='\033[0;33m'

[ -f "$LM_LANG_SOURCE" ] && . "$LM_LANG_SOURCE"

lm_detect_platform() {
    local url_lower="$(echo "${1:-}" | tr '[:upper:]' '[:lower:]')"
    
    [[ $url_lower == *"instagram.com"* || $url_lower == *"instagr.am"* ]] && { echo "instagram"; return 0; }
    [[ $url_lower == *"tiktok.com"* || $url_lower == *"vm.tiktok.com"* || $url_lower == *"vt.tiktok.com"* || $url_lower == *"m.tiktok.com"* ]] && { echo "tiktok"; return 0; }
    [[ $url_lower == *"youtube.com/playlist"* || ( $url_lower == *"list="* && ( $url_lower == *"youtube.com"* || $url_lower == *"youtu.be"* ) ) ]] && { echo "youtube_playlist"; return 0; }
    [[ $url_lower == *"youtube.com"* || $url_lower == *"youtu.be"* ]] && { echo "youtube"; return 0; }
    [[ $url_lower == *"twitter.com"* || $url_lower == *"x.com"* ]] && { echo "twitter"; return 0; }
    [[ $url_lower == *"facebook.com"* || $url_lower == *"fb.com"* || $url_lower == *"fb.watch"* ]] && { echo "facebook"; return 0; }
    [[ $url_lower == *"soundcloud.com"* ]] && { echo "soundcloud"; return 0; }
    [[ $url_lower == *"pinterest.com"* || $url_lower == *"pin.it"* ]] && { echo "pinterest"; return 0; }
    [[ $url_lower == *"reddit.com"* || $url_lower == *"redd.it"* ]] && { echo "reddit"; return 0; }
    [[ $url_lower == *"vimeo.com"* ]] && { echo "vimeo"; return 0; }
    
    echo "unknown"
}

lm_spin() {
    local pid=$1 msg="$2"
    local spin='|/-\' i=0
    while kill -0 "$pid" 2>/dev/null; do
        i=$(( (i+1) % 4 ))
        printf "\r${C_DARK_ORANGE}[LM] %s %s${C_RESET}" "${spin:$i:1}" "$msg"
        sleep 0.08
    done
    wait "$pid" 2>/dev/null
    local status=$?
    [ "$status" -eq 0 ] && printf "\r${C_DARK_GREEN}[LM] ✓ %s                    ${C_RESET}\n" "$msg" || printf "\r${C_ERROR}[LM] ✗ %s (Code: $status)${C_RESET}\n" "$msg"
    return "$status"
}

lm_error_handler() {
    local line=$1 code=$2 msg="${3:-Xəta baş verdi}"
    echo -e "${C_ERROR}[LM] ERROR at line $line (Exit code: $code)${C_RESET}"
    echo -e "${C_ERROR}Səbəb: $msg${C_RESET}" >&2
    return "$code"
}

lm_run_step() {
    echo -ne "${C_DARK_GREEN}[LM]${C_RESET} $1... "
    $2 &
    lm_spin $! "$1" || return $?
    return 0
}

lm_setup_url_opener() {
    mkdir -p "$HOME/bin" 2>/dev/null || { lm_error_handler $LINENO 1 "bin direktoriyası yaradıla bilmədi"; return 1; }
    cat > "$LM_OPENER" << 'EOF' || { lm_error_handler $LINENO 1 "URL Opener yazıla bilmədi"; return 1; }
#!/data/data/com.termux/files/usr/bin/bash
lm "$1"
EOF
    chmod +x "$LM_OPENER" || { lm_error_handler $LINENO 1 "Icazə veriləsi uğursuz oldu"; return 1; }
}

lm_create_folders() {
    local folders=(
        "$LM_DOWNLOAD_BASE/Instagram/Video"
        "$LM_DOWNLOAD_BASE/Instagram/Music"
        "$LM_DOWNLOAD_BASE/TikTok/Video"
        "$LM_DOWNLOAD_BASE/TikTok/Music"
        "$LM_DOWNLOAD_BASE/YouTube/Video"
        "$LM_DOWNLOAD_BASE/YouTube/Music"
        "$LM_DOWNLOAD_BASE/YouTube/Playlist/Video"
        "$LM_DOWNLOAD_BASE/YouTube/Playlist/Music"
        "$LM_DOWNLOAD_BASE/Twitter/Video"
        "$LM_DOWNLOAD_BASE/Twitter/Music"
        "$LM_DOWNLOAD_BASE/Facebook/Video"
        "$LM_DOWNLOAD_BASE/Facebook/Music"
        "$LM_DOWNLOAD_BASE/SoundCloud/Music"
        "$LM_DOWNLOAD_BASE/Pinterest/Video"
        "$LM_DOWNLOAD_BASE/Reddit/Video"
        "$LM_DOWNLOAD_BASE/Vimeo/Video"
    )
    for folder in "${folders[@]}"; do
        mkdir -p "$folder" 2>/dev/null || { lm_error_handler $LINENO 1 "Qovluq yaradıla bilmədi: $folder"; return 1; }
    done
}

lm_save_config() {
    mkdir -p "$LM_DIR" 2>/dev/null || { lm_error_handler $LINENO 1 "Config direktoriyası yaradıla bilmədi"; return 1; }
    cat > "$LM_CONFIG" << EOF || { lm_error_handler $LINENO 1 "Config faylı yazıla bilmədi"; return 1; }
installed=true
version=$LM_VERSION
download_path=$LM_DOWNLOAD_BASE
lang=$LM_LANG
EOF
}

lm_load_config() {
    if [ -f "$LM_CONFIG" ]; then
        . "$LM_CONFIG" 2>/dev/null || { lm_error_handler $LINENO 1 "Config faylı oxuna bilmədi"; return 1; }
        [ -n "${download_path:-}" ] && LM_DOWNLOAD_BASE="$download_path"
        [ -n "${lang:-}" ] && LM_LANG="$lang"
    fi
}

lm_log_download() {
    mkdir -p "$LM_DIR" 2>/dev/null
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Platform: $1 | URL: $2 | Status: $3" >> "$LM_LOG_FILE" 2>/dev/null
}

lm_choose_language() {
    echo -e "\n${C_DARK_BLUE}$TXT_LANG_MENU_TITLE${C_RESET}"
    echo -e "${C_DARK_GREEN}$TXT_LANG_MENU_DESC${C_RESET}\n"
    echo -e "${C_DARK_ORANGE}[1]${C_RESET} $TXT_LANG_AZ"
    echo -e "${C_DARK_ORANGE}[2]${C_RESET} $TXT_LANG_TR"
    echo -e "${C_DARK_ORANGE}[3]${C_RESET} $TXT_LANG_EN"
    echo -e "${C_DARK_ORANGE}[4]${C_RESET} $TXT_LANG_RU"
    echo -e "${C_DARK_ORANGE}[5]${C_RESET} $TXT_LANG_AR"
    echo -e "${C_DARK_ORANGE}[6]${C_RESET} $TXT_LANG_ZH"
    echo -e "${C_DARK_ORANGE}[7]${C_RESET} $TXT_LANG_JA"
    echo -e "${C_DARK_ORANGE}[8]${C_RESET} $TXT_LANG_HI\n"
    echo -ne "${C_PROMPT}$TXT_PROMPT_CHOICE:${C_RESET} "
    read -r lang_choice
    case "$lang_choice" in
        1) LM_LANG="AZ" ;;
        2) LM_LANG="TR" ;;
        3) LM_LANG="EN" ;;
        4) LM_LANG="RU" ;;
        5) LM_LANG="AR" ;;
        6) LM_LANG="ZH" ;;
        7) LM_LANG="JA" ;;
        8) LM_LANG="HI" ;;
        *) LM_LANG="AZ" ;;
    esac
    lm_set_lang_vars || { lm_error_handler $LINENO 1 "Dil dəyişkənləri qurula bilmədi"; return 1; }
    lm_save_config || { lm_error_handler $LINENO 1 "Config saxlanıla bilmədi"; return 1; }
    echo -e "\n${C_DARK_GREEN}[LM]${C_RESET} $TXT_LANG_CHANGED\n"
    sleep 1
}

lm_check_update() {
    local remote_line remote_hash local_hash lang_repo_raw="https://raw.githubusercontent.com/rzayevaga/raicx-downloader/raicX/lm_lang.sh"
    
    remote_line="$(curl -fsSL "$LM_REPO_RAW" 2>/dev/null | grep -m1 '^LM_VERSION=')" || { lm_error_handler $LINENO 1 "Remote version yoxlanıla bilmədi"; return 1; }
    [ -z "$remote_line" ] && { lm_error_handler $LINENO 1 "Version məlumatı tapılmadı"; return 1; }
    
    LM_REMOTE_VERSION="${remote_line#LM_VERSION=\"}" && LM_REMOTE_VERSION="${LM_REMOTE_VERSION%\"}"
    
    remote_hash="$(curl -fsSL "$lang_repo_raw" 2>/dev/null | sha256sum | cut -d' ' -f1)" || { lm_error_handler $LINENO 1 "Lang dosyası yoxlanıla bilmədi"; return 1; }
    local_hash="" && [ -f "$LM_DIR/lm_lang.sh" ] && local_hash="$(sha256sum "$LM_DIR/lm_lang.sh" 2>/dev/null | cut -d' ' -f1)"
    
    [ "$LM_REMOTE_VERSION" != "$LM_VERSION" ] || [ "$remote_hash" != "$local_hash" ] && return 0
    return 2
}

lm_do_update() {
    echo -e "\n${C_DARK_GREEN}[LM]${C_RESET} $TXT_UPDATING"
    local tmp_bin="$LM_BIN.tmp" tmp_lang="$LM_DIR/lm_lang.sh.tmp" lang_repo_raw="https://raw.githubusercontent.com/rzayevaga/raicx-downloader/raicX/lm_lang.sh"
    
    if curl -fsSL "$LM_REPO_RAW" -o "$tmp_bin" 2>/dev/null && curl -fsSL "$lang_repo_raw" -o "$tmp_lang" 2>/dev/null; then
        chmod +x "$tmp_bin" 2>/dev/null || { lm_error_handler $LINENO 1 "Executable hüququ veriləsi uğursuz"; rm -f "$tmp_bin" "$tmp_lang"; return 1; }
        mv "$tmp_bin" "$LM_BIN" 2>/dev/null || { lm_error_handler $LINENO 1 "Binary yerləşdiriləsi uğursuz"; rm -f "$tmp_bin" "$tmp_lang"; return 1; }
        mv "$tmp_lang" "$LM_DIR/lm_lang.sh" 2>/dev/null || { lm_error_handler $LINENO 1 "Lang faylı yerləşdiriləsi uğursuz"; return 1; }
        echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_UPDATE_SUCCESS"
        echo -e "${C_DARK_ORANGE}[LM]${C_RESET} Zəhmət olmasa yenidən başladın."
        exit 0
    else
        echo -e "${C_ERROR}[LM]${C_RESET} $TXT_UPDATE_FAILED"
        lm_error_handler $LINENO 1 "Update faylları yükləməsi uğursuz (internet problemi?)"
        rm -f "$tmp_bin" "$tmp_lang"
        return 1
    fi
}

lm_banner() {
    clear
    echo -e "${C_DARK_ORANGE}╔══════════════════════════════════════════════╗"
    echo -e "║                                              ║"
    echo -e "║           ✦  Ɍム-ic LM DOWNLOADER  ✦         ║"
    echo -e "║                 $LM_VERSION                 ║"
    echo -e "║                                              ║"
    echo -e "╚══════════════════════════════════════════════╝${C_RESET}\n"
}

lm_show_system_info() {
    lm_banner
    echo -e "${C_DARK_BLUE}╔══════════════════════════════════════════════╗"
    echo -e "║             $TXT_SYSTEM_INFO             ║"
    echo -e "╚══════════════════════════════════════════════╝${C_RESET}\n"
    echo -e "${C_DARK_ORANGE}Version:${C_RESET} $LM_VERSION"
    echo -e "${C_DARK_ORANGE}Bash:${C_RESET} $BASH_VERSION"
    echo -e "${C_DARK_ORANGE}Python:${C_RESET} $(python --version 2>&1 | cut -d' ' -f2)"
    echo -e "${C_DARK_ORANGE}FFmpeg:${C_RESET} $(ffmpeg -version 2>/dev/null | head -1 | cut -d' ' -f3)"
    echo -e "${C_DARK_ORANGE}yt-dlp:${C_RESET} $(python -m pip show yt-dlp 2>/dev/null | grep Version | cut -d' ' -f2)"
    echo -e "${C_DARK_ORANGE}İndirmə Yolu:${C_RESET} $LM_DOWNLOAD_BASE"
    echo -e "${C_DARK_ORANGE}Dil:${C_RESET} $LM_LANG\n"
    echo -e "${C_PROMPT}$TXT_PROMPT_CONTINUE...${C_RESET}"
    read -r
}

lm_view_log() {
    lm_banner
    echo -e "${C_DARK_BLUE}╔══════════════════════════════════════════════╗"
    echo -e "║              $TXT_LOG_TITLE              ║"
    echo -e "╚══════════════════════════════════════════════╝${C_RESET}\n"
    if [ -f "$LM_LOG_FILE" ] && [ -s "$LM_LOG_FILE" ]; then
        tail -20 "$LM_LOG_FILE"
    else
        echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_LOG_EMPTY"
    fi
    echo -e "\n${C_PROMPT}$TXT_PROMPT_CONTINUE...${C_RESET}"
    read -r
}

lm_get_clipboard_url() {
    local clip_text
    clip_text="$(termux-clipboard-get 2>/dev/null)" || { lm_error_handler $LINENO 1 "Clipboard oxuna bilmədi"; return 1; }
    if [[ $clip_text == *"://"* ]]; then
        echo "$clip_text"
        return 0
    fi
    return 1
}

lm_download_instagram() {
    local url="$1" quality="${2:-video}"
    echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_INSTAGRAM_VIDEO"
    instaloader --no-metadata --no-captions "$url" -D "$LM_DOWNLOAD_BASE/Instagram/${quality^}" 2>&1 | grep -i "error\|failed" && { lm_error_handler $LINENO 1 "Instagram yükləmə uğursuz oldu"; lm_log_download "instagram" "$url" "FAILED"; return 1; }
    echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_DOWNLOAD_DONE_PREFIX: Instagram"
    lm_log_download "instagram" "$url" "SUCCESS"
}

lm_download_tiktok() {
    local url="$1" quality="${2:-video}"
    echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_TIKTOK_VIDEO"
    yt-dlp -f best -o "$LM_DOWNLOAD_BASE/TikTok/${quality^}/%(title)s.%(ext)s" "$url" 2>&1 | grep -i "error\|failed" && { lm_error_handler $LINENO 1 "TikTok yükləmə uğursuz oldu"; lm_log_download "tiktok" "$url" "FAILED"; return 1; }
    echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_DOWNLOAD_DONE_PREFIX: TikTok"
    lm_log_download "tiktok" "$url" "SUCCESS"
}

lm_download_youtube() {
    local url="$1" quality="${2:-best}" type="${3:-video}"
    if [ "$type" = "audio" ]; then
        echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_YT_AUDIO"
        yt-dlp -f bestaudio -x --audio-format mp3 -o "$LM_DOWNLOAD_BASE/YouTube/Music/%(title)s.%(ext)s" "$url" 2>&1 | grep -i "error\|failed" && { lm_error_handler $LINENO 1 "YouTube audio yükləmə uğursuz oldu"; lm_log_download "youtube_audio" "$url" "FAILED"; return 1; }
    else
        echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_YT_VIDEO"
        yt-dlp -f "$quality" -o "$LM_DOWNLOAD_BASE/YouTube/Video/%(title)s.%(ext)s" "$url" 2>&1 | grep -i "error\|failed" && { lm_error_handler $LINENO 1 "YouTube video yükləmə uğursuz oldu"; lm_log_download "youtube_video" "$url" "FAILED"; return 1; }
    fi
    echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_DOWNLOAD_DONE_PREFIX: YouTube"
    lm_log_download "youtube" "$url" "SUCCESS"
}

lm_download_youtube_playlist() {
    local url="$1" quality="${2:-best}" type="${3:-video}"
    if [ "$type" = "audio" ]; then
        echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_YTPL_AUDIO"
        yt-dlp -f bestaudio -x --audio-format mp3 -o "$LM_DOWNLOAD_BASE/YouTube/Playlist/Music/%(playlist)s/%(title)s.%(ext)s" "$url" 2>&1 | grep -i "error\|failed" && { lm_error_handler $LINENO 1 "YouTube Playlist audio yükləmə uğursuz oldu"; lm_log_download "youtube_playlist_audio" "$url" "FAILED"; return 1; }
    else
        echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_YTPL_VIDEO"
        yt-dlp -f "$quality" -o "$LM_DOWNLOAD_BASE/YouTube/Playlist/Video/%(playlist)s/%(title)s.%(ext)s" "$url" 2>&1 | grep -i "error\|failed" && { lm_error_handler $LINENO 1 "YouTube Playlist video yükləmə uğursuz oldu"; lm_log_download "youtube_playlist_video" "$url" "FAILED"; return 1; }
    fi
    echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_DOWNLOAD_DONE_PREFIX: YouTube Playlist"
    lm_log_download "youtube_playlist" "$url" "SUCCESS"
}

lm_download_twitter() {
    local url="$1" type="${2:-video}"
    if [ "$type" = "audio" ]; then
        echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_TWITTER_AUDIO"
        yt-dlp -f bestaudio -x --audio-format mp3 -o "$LM_DOWNLOAD_BASE/Twitter/Music/%(title)s.%(ext)s" "$url" 2>&1 | grep -i "error\|failed" && { lm_error_handler $LINENO 1 "Twitter audio yükləmə uğursuz oldu"; lm_log_download "twitter_audio" "$url" "FAILED"; return 1; }
    else
        echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_TWITTER_VIDEO"
        yt-dlp -f best -o "$LM_DOWNLOAD_BASE/Twitter/Video/%(title)s.%(ext)s" "$url" 2>&1 | grep -i "error\|failed" && { lm_error_handler $LINENO 1 "Twitter video yükləmə uğursuz oldu"; lm_log_download "twitter_video" "$url" "FAILED"; return 1; }
    fi
    echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_DOWNLOAD_DONE_PREFIX: Twitter"
    lm_log_download "twitter" "$url" "SUCCESS"
}

lm_download_facebook() {
    local url="$1" type="${2:-video}"
    if [ "$type" = "audio" ]; then
        echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_FACEBOOK_AUDIO"
        yt-dlp -f bestaudio -x --audio-format mp3 -o "$LM_DOWNLOAD_BASE/Facebook/Music/%(title)s.%(ext)s" "$url" 2>&1 | grep -i "error\|failed" && { lm_error_handler $LINENO 1 "Facebook audio yükləmə uğursuz oldu"; lm_log_download "facebook_audio" "$url" "FAILED"; return 1; }
    else
        echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_FACEBOOK_VIDEO"
        yt-dlp -f best -o "$LM_DOWNLOAD_BASE/Facebook/Video/%(title)s.%(ext)s" "$url" 2>&1 | grep -i "error\|failed" && { lm_error_handler $LINENO 1 "Facebook video yükləmə uğursuz oldu"; lm_log_download "facebook_video" "$url" "FAILED"; return 1; }
    fi
    echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_DOWNLOAD_DONE_PREFIX: Facebook"
    lm_log_download "facebook" "$url" "SUCCESS"
}

lm_download_soundcloud() {
    local url="$1"
    echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_SOUNDCLOUD_AUDIO"
    yt-dlp -f bestaudio -x --audio-format mp3 -o "$LM_DOWNLOAD_BASE/SoundCloud/Music/%(title)s.%(ext)s" "$url" 2>&1 | grep -i "error\|failed" && { lm_error_handler $LINENO 1 "SoundCloud yükləmə uğursuz oldu"; lm_log_download "soundcloud" "$url" "FAILED"; return 1; }
    echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_DOWNLOAD_DONE_PREFIX: SoundCloud"
    lm_log_download "soundcloud" "$url" "SUCCESS"
}

lm_download_pinterest() {
    local url="$1"
    echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_PINTEREST_VIDEO"
    yt-dlp -f best -o "$LM_DOWNLOAD_BASE/Pinterest/Video/%(title)s.%(ext)s" "$url" 2>&1 | grep -i "error\|failed" && { lm_error_handler $LINENO 1 "Pinterest yükləmə uğursuz oldu"; lm_log_download "pinterest" "$url" "FAILED"; return 1; }
    echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_DOWNLOAD_DONE_PREFIX: Pinterest"
    lm_log_download "pinterest" "$url" "SUCCESS"
}

lm_download_reddit() {
    local url="$1"
    echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_REDDIT_VIDEO"
    yt-dlp -f best -o "$LM_DOWNLOAD_BASE/Reddit/Video/%(title)s.%(ext)s" "$url" 2>&1 | grep -i "error\|failed" && { lm_error_handler $LINENO 1 "Reddit yükləmə uğursuz oldu"; lm_log_download "reddit" "$url" "FAILED"; return 1; }
    echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_DOWNLOAD_DONE_PREFIX: Reddit"
    lm_log_download "reddit" "$url" "SUCCESS"
}

lm_download_vimeo() {
    local url="$1"
    echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_VIMEO_VIDEO"
    yt-dlp -f best -o "$LM_DOWNLOAD_BASE/Vimeo/Video/%(title)s.%(ext)s" "$url" 2>&1 | grep -i "error\|failed" && { lm_error_handler $LINENO 1 "Vimeo yükləmə uğursuz oldu"; lm_log_download "vimeo" "$url" "FAILED"; return 1; }
    echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_DOWNLOAD_DONE_PREFIX: Vimeo"
    lm_log_download "vimeo" "$url" "SUCCESS"
}

lm_download_with_prompt() {
    local platform="$1" url="$2"
    
    case "$platform" in
        instagram) lm_download_instagram "$url" ;;
        tiktok) lm_download_tiktok "$url" ;;
        youtube)
            echo -e "\n${C_DARK_BLUE}$TXT_MENU_YT_MODE_TITLE${C_RESET}\n"
            echo -e "${C_DARK_ORANGE}[1]${C_RESET} $TXT_OPTION_VIDEO_DOWNLOAD"
            echo -e "${C_DARK_ORANGE}[2]${C_RESET} $TXT_OPTION_AUDIO_DOWNLOAD"
            echo -e "${C_DARK_ORANGE}[3]${C_RESET} $TXT_OPTION_QUALITY_VIDEO\n"
            echo -ne "${C_PROMPT}$TXT_PROMPT_CHOICE:${C_RESET} "
            read -r yt_choice
            case "$yt_choice" in
                1) lm_download_youtube "$url" "best" "video" ;;
                2) lm_download_youtube "$url" "best" "audio" ;;
                3)
                    echo -ne "\n${C_PROMPT}$TXT_QUALITY_PROMPT${C_RESET} "
                    read -r quality
                    case "$quality" in
                        1080) lm_download_youtube "$url" "bestvideo[height<=1080]" "video" ;;
                        720) lm_download_youtube "$url" "bestvideo[height<=720]" "video" ;;
                        480) lm_download_youtube "$url" "bestvideo[height<=480]" "video" ;;
                        360) lm_download_youtube "$url" "bestvideo[height<=360]" "video" ;;
                        *) lm_download_youtube "$url" "best" "video" ;;
                    esac
                    ;;
                *) echo -e "${C_ERROR}[LM]${C_RESET} $TXT_ERROR_INVALID_CHOICE" ;;
            esac
            ;;
        youtube_playlist)
            echo -e "\n${C_DARK_BLUE}$TXT_MENU_YT_MODE_TITLE${C_RESET}\n"
            echo -e "${C_DARK_ORANGE}[1]${C_RESET} $TXT_OPTION_PLAYLIST_VIDEO"
            echo -e "${C_DARK_ORANGE}[2]${C_RESET} $TXT_OPTION_PLAYLIST_AUDIO\n"
            echo -ne "${C_PROMPT}$TXT_PROMPT_CHOICE:${C_RESET} "
            read -r yt_pl_choice
            case "$yt_pl_choice" in
                1) lm_download_youtube_playlist "$url" "best" "video" ;;
                2) lm_download_youtube_playlist "$url" "best" "audio" ;;
                *) echo -e "${C_ERROR}[LM]${C_RESET} $TXT_ERROR_INVALID_CHOICE" ;;
            esac
            ;;
        twitter) lm_download_twitter "$url" ;;
        facebook) lm_download_facebook "$url" ;;
        soundcloud) lm_download_soundcloud "$url" ;;
        pinterest) lm_download_pinterest "$url" ;;
        reddit) lm_download_reddit "$url" ;;
        vimeo) lm_download_vimeo "$url" ;;
        *)
            echo -e "${C_ERROR}[LM]${C_RESET} $TXT_PLATFORM_UNKNOWN"
            lm_error_handler $LINENO 1 "Platform tanınmadı: $platform"
            ;;
    esac
}

lm_manual_menu() {
    while true; do
        lm_banner
        echo -e "${C_DARK_BLUE}╔══════════════════════════════════════════════╗"
        echo -e "║          $TXT_MANUAL_MENU_TITLE          ║"
        echo -e "╚══════════════════════════════════════════════╝${C_RESET}\n"
        echo -e "${C_DARK_ORANGE}[1]${C_RESET} $TXT_MENU_OPTION_MANUAL"
        echo -e "${C_DARK_ORANGE}[2]${C_RESET} Instagram"
        echo -e "${C_DARK_ORANGE}[3]${C_RESET} TikTok"
        echo -e "${C_DARK_ORANGE}[4]${C_RESET} YouTube"
        echo -e "${C_DARK_ORANGE}[5]${C_RESET} Twitter/X"
        echo -e "${C_DARK_ORANGE}[6]${C_RESET} Facebook"
        echo -e "${C_DARK_ORANGE}[7]${C_RESET} SoundCloud"
        echo -e "${C_DARK_ORANGE}[8]${C_RESET} Pinterest"
        echo -e "${C_DARK_ORANGE}[9]${C_RESET} Reddit"
        echo -e "${C_DARK_ORANGE}[10]${C_RESET} Vimeo"
        echo -e "${C_DARK_BROWN}[0]${C_RESET} $TXT_MENU_OPTION_BACK\n"
        echo -ne "${C_PROMPT}$TXT_PROMPT_CHOICE:${C_RESET} "
        read -r manual_choice
        case "$manual_choice" in
            1) echo -ne "\n${C_PROMPT}$TXT_PROMPT_INSTAGRAM_LINK:${C_RESET} "; read -r ig_url; lm_download_with_prompt instagram "$ig_url"; echo -e "\n${C_PROMPT}$TXT_PROMPT_CONTINUE...${C_RESET}"; read -r ;;
            2) echo -ne "\n${C_PROMPT}$TXT_PROMPT_INSTAGRAM_LINK:${C_RESET} "; read -r ig_url; lm_download_with_prompt instagram "$ig_url"; echo -e "\n${C_PROMPT}$TXT_PROMPT_CONTINUE...${C_RESET}"; read -r ;;
            3) echo -ne "\n${C_PROMPT}$TXT_PROMPT_TIKTOK_LINK:${C_RESET} "; read -r tk_url; lm_download_with_prompt tiktok "$tk_url"; echo -e "\n${C_PROMPT}$TXT_PROMPT_CONTINUE...${C_RESET}"; read -r ;;
            4) echo -ne "\n${C_PROMPT}$TXT_PROMPT_YT_SINGLE_LINK:${C_RESET} "; read -r yt_url; lm_download_with_prompt youtube "$yt_url"; echo -e "\n${C_PROMPT}$TXT_PROMPT_CONTINUE...${C_RESET}"; read -r ;;
            5) echo -ne "\n${C_PROMPT}$TXT_PROMPT_TWITTER_LINK:${C_RESET} "; read -r tw_url; lm_download_with_prompt twitter "$tw_url"; echo -e "\n${C_PROMPT}$TXT_PROMPT_CONTINUE...${C_RESET}"; read -r ;;
            6) echo -ne "\n${C_PROMPT}$TXT_PROMPT_FACEBOOK_LINK:${C_RESET} "; read -r fb_url; lm_download_with_prompt facebook "$fb_url"; echo -e "\n${C_PROMPT}$TXT_PROMPT_CONTINUE...${C_RESET}"; read -r ;;
            7) echo -ne "\n${C_PROMPT}$TXT_PROMPT_SOUNDCLOUD_LINK:${C_RESET} "; read -r sc_url; lm_download_with_prompt soundcloud "$sc_url"; echo -e "\n${C_PROMPT}$TXT_PROMPT_CONTINUE...${C_RESET}"; read -r ;;
            8) echo -ne "\n${C_PROMPT}$TXT_PROMPT_PINTEREST_LINK:${C_RESET} "; read -r pi_url; lm_download_with_prompt pinterest "$pi_url"; echo -e "\n${C_PROMPT}$TXT_PROMPT_CONTINUE...${C_RESET}"; read -r ;;
            9) echo -ne "\n${C_PROMPT}$TXT_PROMPT_REDDIT_LINK:${C_RESET} "; read -r rd_url; lm_download_with_prompt reddit "$rd_url"; echo -e "\n${C_PROMPT}$TXT_PROMPT_CONTINUE...${C_RESET}"; read -r ;;
            10) echo -ne "\n${C_PROMPT}$TXT_PROMPT_VIMEO_LINK:${C_RESET} "; read -r vm_url; lm_download_with_prompt vimeo "$vm_url"; echo -e "\n${C_PROMPT}$TXT_PROMPT_CONTINUE...${C_RESET}"; read -r ;;
            0) break ;;
            *) echo -e "${C_ERROR}[LM]${C_RESET} $TXT_ERROR_INVALID_CHOICE"; sleep 2 ;;
        esac
    done
}

lm_search_menu() {
    while true; do
        lm_banner
        echo -e "${C_DARK_BLUE}╔══════════════════════════════════════════════╗"
        echo -e "║              $TXT_SEARCH_TITLE              ║"
        echo -e "╚══════════════════════════════════════════════╝${C_RESET}\n"
        echo -ne "${C_PROMPT}$TXT_SEARCH_PROMPT:${C_RESET} "
        read -r search_query
        [ -z "$search_query" ] && break
        echo -e "\n${C_DARK_GREEN}[LM]${C_RESET} $TXT_SEARCHING"
        local search_results
        search_results="$(yt-dlp "ytsearch10:$search_query" --dump-json 2>/dev/null | jq -r '.[].title' 2>/dev/null)"
        if [ -z "$search_results" ]; then
            echo -e "${C_ERROR}[LM]${C_RESET} $TXT_SEARCH_NO_RESULTS"
        else
            echo -e "\n${C_DARK_BLUE}$TXT_SEARCH_RESULTS:${C_RESET}\n"
            echo "$search_results" | nl
            echo -ne "\n${C_PROMPT}$TXT_SEARCH_SELECT:${C_RESET} "
            read -r search_select
            local selected_url
            selected_url="$(yt-dlp "ytsearch10:$search_query" --dump-json 2>/dev/null | jq -r ".[$((search_select-1))].webpage_url" 2>/dev/null)"
            [ -n "$selected_url" ] && lm_download_with_prompt youtube "$selected_url"
        fi
        echo -ne "\n${C_PROMPT}$TXT_SEARCH_AGAIN:${C_RESET} "
        read -r search_again
        [[ ! $search_again =~ ^[yYhH] ]] && break
    done
}

lm_batch_download() {
    lm_banner
    echo -e "${C_DARK_BLUE}╔══════════════════════════════════════════════╗"
    echo -e "║          $TXT_BATCH_PROMPT          ║"
    echo -e "╚══════════════════════════════════════════════╝${C_RESET}\n"
    echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_BATCH_INSTRUCTION"
    local urls=() url
    while IFS= read -r url; do
        [ -z "$url" ] && break
        urls+=("$url")
    done
    if [ ${#urls[@]} -eq 0 ]; then
        echo -e "${C_ERROR}[LM]${C_RESET} $TXT_BATCH_EMPTY"
    else
        echo -e "\n${C_DARK_GREEN}[LM]${C_RESET} $TXT_BATCH_START: ${#urls[@]} link(s)\n"
        for batch_url in "${urls[@]}"; do
            local platform
            platform="$(lm_detect_platform "$batch_url")"
            lm_download_with_prompt "$platform" "$batch_url" || lm_error_handler $LINENO 1 "Batch download xətası: $batch_url"
            sleep 2
        done
        echo -e "\n${C_DARK_GREEN}[LM]${C_RESET} $TXT_BATCH_DONE"
    fi
    echo -e "\n${C_PROMPT}$TXT_PROMPT_CONTINUE...${C_RESET}"
    read -r
}

lm_auto_download() {
    local url="$1" platform
    lm_banner
    echo -e "${C_DARK_BLUE}╔══════════════════════════════════════════════╗"
    echo -e "║             $TXT_AUTO_MENU_TITLE             ║"
    echo -e "╚══════════════════════════════════════════════╝${C_RESET}\n"
    if [ -z "$url" ]; then
        if lm_get_clipboard_url &>/dev/null; then
            local clip_url
            clip_url="$(lm_get_clipboard_url)"
            echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_CLIPBOARD_FOUND: $clip_url"
            echo -ne "${C_PROMPT}$TXT_USE_CLIPBOARD${C_RESET} "
            read -r use_clip
            [[ $use_clip =~ ^[hHyYeE] ]] && url="$clip_url" || { echo -ne "${C_PROMPT}$TXT_PROMPT_LINK:${C_RESET} "; read -r url; }
        else
            echo -ne "${C_PROMPT}$TXT_PROMPT_LINK:${C_RESET} "
            read -r url
        fi
    fi
    [ -z "$url" ] && { lm_error_handler $LINENO 1 "Link daxil edilmədi"; return 1; }
    platform="$(lm_detect_platform "$url")" || { lm_error_handler $LINENO 1 "Platform tap ola bilmədi"; return 1; }
    lm_download_with_prompt "$platform" "$url"
}

lm_settings_menu() {
    while true; do
        lm_banner
        echo -e "${C_DARK_BLUE}╔══════════════════════════════════════════════╗"
        echo -e "║              $TXT_SETTINGS_MENU_TITLE              ║"
        echo -e "╚══════════════════════════════════════════════╝${C_RESET}\n"
        echo -e "${C_DARK_ORANGE}[1]${C_RESET} $TXT_MENU_OPTION_LANGUAGE"
        echo -e "${C_DARK_BROWN}[0]${C_RESET} $TXT_MENU_OPTION_BACK\n"
        echo -ne "${C_PROMPT}$TXT_PROMPT_CHOICE:${C_RESET} "
        read -r settings_choice
        case "$settings_choice" in
            1) lm_choose_language ;;
            0) break ;;
            *) echo -e "${C_ERROR}[LM]${C_RESET} $TXT_ERROR_INVALID_CHOICE"; sleep 2 ;;
        esac
    done
}

lm_admin_menu() {
    while true; do
        lm_banner
        echo -e "${C_DARK_BLUE}╔══════════════════════════════════════════════╗"
        echo -e "║              $TXT_ADMIN_MENU_TITLE              ║"
        echo -e "╚══════════════════════════════════════════════╝${C_RESET}\n"
        echo -e "${C_DARK_ORANGE}[1]${C_RESET} $TXT_MENU_OPTION_UPDATE"
        echo -e "${C_DARK_ORANGE}[2]${C_RESET} $TXT_MENU_OPTION_OPTIMIZE"
        echo -e "${C_DARK_ORANGE}[3]${C_RESET} $TXT_MENU_OPTION_INFO"
        echo -e "${C_DARK_ORANGE}[4]${C_RESET} $TXT_MENU_OPTION_LOG"
        echo -e "${C_DARK_BROWN}[0]${C_RESET} $TXT_MENU_OPTION_BACK\n"
        echo -ne "${C_PROMPT}$TXT_PROMPT_CHOICE:${C_RESET} "
        read -r admin_choice
        case "$admin_choice" in
            1)
                lm_check_update
                case $? in
                    0)
                        echo -e "\n${C_DARK_GREEN}[LM]${C_RESET} $TXT_UPDATE_AVAILABLE ($LM_REMOTE_VERSION)"
                        echo -ne "${C_DARK_GREEN}$TXT_UPDATE_PROMPT${C_RESET} "
                        read -r up_confirm
                        [[ $up_confirm =~ ^[hHyYeE] ]] && lm_do_update || echo -e "${C_DARK_ORANGE}[LM]${C_RESET} $TXT_MENU_OPTION_BACK"
                        ;;
                    2) echo -e "\n${C_DARK_GREEN}[LM]${C_RESET} $TXT_ALREADY_LATEST" ;;
                    *) echo -e "\n${C_ERROR}[LM]${C_RESET} $TXT_UPDATE_FAILED" ;;
                esac
                echo -e "\n${C_PROMPT}$TXT_PROMPT_CONTINUE...${C_RESET}"
                read -r
                ;;
            2)
                echo -e "\n${C_DARK_GREEN}[LM]${C_RESET} $TXT_OPTIMIZE_DONE"
                rm -rf "$LM_DIR/cache" 2>/dev/null
                pip cache purge 2>/dev/null
                echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_CACHE_CLEARED"
                echo -e "\n${C_PROMPT}$TXT_PROMPT_CONTINUE...${C_RESET}"
                read -r
                ;;
            3) lm_show_system_info ;;
            4) lm_view_log ;;
            0) break ;;
            *) echo -e "${C_ERROR}[LM]${C_RESET} $TXT_ERROR_INVALID_CHOICE"; sleep 2 ;;
        esac
    done
}

lm_main_menu() {
    while true; do
        lm_banner
        echo -e "${C_DARK_BLUE}╔══════════════════════════════════════════════╗"
        echo -e "║           Ɍム-ic LM $TXT_MAIN_MENU_TITLE           ║"
        echo -e "╚══════════════════════════════════════════════╝${C_RESET}\n"
        echo -e "${C_DARK_ORANGE}[1]${C_RESET} $TXT_MENU_OPTION_MANUAL"
        echo -e "${C_DARK_ORANGE}[2]${C_RESET} $TXT_MENU_OPTION_AUTO"
        echo -e "${C_DARK_ORANGE}[3]${C_RESET} $TXT_MENU_OPTION_SETTINGS"
        echo -e "${C_DARK_ORANGE}[4]${C_RESET} $TXT_MENU_OPTION_ADMIN"
        echo -e "${C_DARK_ORANGE}[5]${C_RESET} $TXT_MENU_OPTION_SEARCH"
        echo -e "${C_DARK_ORANGE}[6]${C_RESET} $TXT_MENU_OPTION_BATCH"
        echo -e "${C_DARK_BROWN}[0]${C_RESET} $TXT_MENU_OPTION_EXIT\n"
        echo -ne "${C_PROMPT}$TXT_PROMPT_CHOICE:${C_RESET} "
        read -r main_choice
        case "$main_choice" in
            1) lm_manual_menu ;;
            2) lm_auto_download "" ;;
            3) lm_settings_menu ;;
            4) lm_admin_menu ;;
            5) lm_search_menu ;;
            6) lm_batch_download ;;
            0) lm_banner; echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_EXIT_MESSAGE\n"; exit 0 ;;
            *) echo -e "${C_ERROR}[LM]${C_RESET} $TXT_ERROR_INVALID_CHOICE"; sleep 2 ;;
        esac
    done
}

lm_install() {
    mkdir -p "$LM_DIR" || { lm_error_handler $LINENO 1 "LM direktoriyası yaradıla bilmədi"; return 1; }
    lm_banner
    echo -e "${C_DARK_BLUE}$TXT_INSTALLER_TITLE${C_RESET}"
    echo -e "${C_DARK_ORANGE}$TXT_INSTALL_PREP${C_RESET}"
    sleep 1
    echo -e "\n${C_DARK_GREEN}[LM]${C_RESET} $TXT_INSTALL_STORAGE..."
    termux-setup-storage 2>/dev/null || { lm_error_handler $LINENO 1 "Storage quraşdırması uğursuz"; return 1; }
    sleep 1
    lm_run_step "$TXT_STEP_UPDATE_PKGS" "pkg update -y" || return 1
    lm_run_step "$TXT_STEP_INSTALL_PYTHON" "pkg install python -y" || return 1
    lm_run_step "$TXT_STEP_INSTALL_FFMPEG" "pkg install ffmpeg -y" || return 1
    lm_run_step "$TXT_STEP_INSTALL_GIT" "pkg install git -y" || return 1
    lm_run_step "$TXT_STEP_UPDATE_YTDLP" "python -m pip install -U yt-dlp" || return 1
    lm_run_step "$TXT_STEP_UPDATE_INSTALOADER" "python -m pip install -U instaloader" || return 1
    lm_run_step "$TXT_STEP_UPDATE_GDL" "python -m pip install -U gallery-dl" || return 1
    lm_run_step "$TXT_STEP_CREATE_DIRS" "lm_create_folders" || return 1
    lm_run_step "$TXT_STEP_SETUP_URL_OPENER" "lm_setup_url_opener" || return 1
    lm_choose_language || return 1
    cp "$SOURCE_PATH" "$LM_BIN" 2>/dev/null || { lm_error_handler $LINENO 1 "Binary köçürülə bilmədi"; return 1; }
    chmod +x "$LM_BIN" 2>/dev/null || { lm_error_handler $LINENO 1 "Executable hüququ veriləsi uğursuz"; return 1; }
    [ -f "$LM_LANG_SOURCE" ] && cp "$LM_LANG_SOURCE" "$LM_DIR/lm_lang.sh" 2>/dev/null || { lm_error_handler $LINENO 1 "Lang faylı köçürülə bilmədi"; return 1; }
    lm_banner
    echo -e "${C_DARK_GREEN}╔══════════════════════════════════════╗${C_RESET}"
    echo -e "${C_DARK_GREEN}║      $TXT_INSTALL_SUCCESS_LINE1      ║${C_RESET}"
    echo -e "${C_DARK_GREEN}╚══════════════════════════════════════╝${C_RESET}\n"
    echo -e "${C_DARK_BLUE}$TXT_INSTALL_SUCCESS_LINE2${C_RESET}"
    echo -e "${C_DARK_BLUE}$TXT_INSTALL_SUCCESS_LINE3${C_RESET}\n"
    sleep 3
}

lm_main() {
    lm_load_config || return 1
    lm_set_lang_vars || return 1
    if [ "$installed" != "true" ] || [ "$version" != "$LM_VERSION" ]; then
        lm_install || return 1
    fi
    if [ $# -eq 0 ]; then
        if lm_check_update >/dev/null 2>&1; then
            echo -e "\n${C_DARK_GREEN}[LM]${C_RESET} $TXT_UPDATE_AVAILABLE ($LM_REMOTE_VERSION)"
            echo -ne "${C_DARK_GREEN}$TXT_UPDATE_PROMPT${C_RESET} "
            read -r up_confirm
            [[ $up_confirm =~ ^[hHyYeE] ]] && lm_do_update
        elif [ $? -eq 1 ]; then
            echo -e "\n${C_ERROR}[LM]${C_RESET} Üzr istəyirik, yeniləmə yoxlanarkən xəta baş verdi (internet yoxdur?)"
            sleep 2
        fi
        lm_main_menu
    else
        lm_auto_download "$1"
    fi
}

lm_main "$@"

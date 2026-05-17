#!/data/data/com.termux/files/usr/bin/bash
set -o pipefail

LM_VERSION="LM-V25.0-ULTRA"
LM_DIR="$HOME/.raiclm"
LM_CONFIG="$LM_DIR/lm.conf"
LM_BIN="/data/data/com.termux/files/usr/bin/lm"
LM_OPENER="$HOME/bin/termux-url-opener"
LM_DOWNLOAD_BASE="/sdcard/raicXD"
LM_REPO_RAW="https://raw.githubusercontent.com/rzayevaga/raicx-downloader/raicX/lm.sh"

LM_LANG="AZ"
LM_REMOTE_VERSION=""
LM_LOG_DIR="$LM_DIR/logs"

SOURCE_PATH="${BASH_SOURCE[0]:-$0}"
SCRIPT_DIR="$(cd "$(dirname "$SOURCE_PATH")" && pwd)"
LM_LANG_SOURCE="$LM_DIR/lm_lang.sh"
if [ -f "$SCRIPT_DIR/lm_lang.sh" ]; then
    LM_LANG_SOURCE="$SCRIPT_DIR/lm_lang.sh"
fi

C_RESET='\033[0m'
C_DARK_ORANGE='\033[38;5;202m'
C_DARK_BROWN='\033[38;5;94m'
C_DARK_BLUE='\033[38;5;19m'
C_DARK_GREEN='\033[38;5;22m'
C_PROMPT='\033[0;32m'
C_ERROR='\033[0;31m'
C_INFO='\033[0;36m'
C_BOLD='\033[1m'
C_DIM='\033[2m'
C_ITALIC='\033[3m'
C_UNDERLINE='\033[4m'

if [ -f "$LM_LANG_SOURCE" ]; then
    . "$LM_LANG_SOURCE"
fi

lm_animate_border() {
    local text="$1"
    local width=50
    local -a frames=("█" "▓" "▒" "░")
    for i in {1..2}; do
        for frame in "${frames[@]}"; do
            printf "\r${C_DARK_ORANGE}%s${C_RESET} %s ${C_DARK_ORANGE}%s${C_RESET}" "$frame" "$text" "$frame"
            sleep 0.03
        done
    done
    echo
}

lm_hide_cursor() { printf "\e[?25l"; }
lm_show_cursor() { printf "\e[?25h"; }

lm_spin() {
    local pid=$1
    local msg="$2"
    local -a spin=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
    local i=0
    lm_hide_cursor
    while kill -0 "$pid" 2>/dev/null; do
        i=$(( (i+1) % ${#spin[@]} ))
        printf "\r${C_DARK_ORANGE}[LM] %s %s${C_RESET}" "${spin[$i]}" "$msg"
        sleep 0.08
    done
    wait "$pid" 2>/dev/null
    local status=$?
    lm_show_cursor
    if [ "$status" -eq 0 ]; then
        printf "\r${C_DARK_GREEN}[LM] ✓ %s                    ${C_RESET}\n" "$msg"
    else
        printf "\r${C_ERROR}[LM] ✗ %s                    ${C_RESET}\n" "$msg"
    fi
    return "$status"
}

lm_setup_url_opener() {
    mkdir -p "$HOME/bin"
    cat > "$LM_OPENER" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
lm "$1"
EOF
    chmod +x "$LM_OPENER"
}

lm_create_folders() {
    mkdir -p "$LM_DOWNLOAD_BASE/Instagram/Video"
    mkdir -p "$LM_DOWNLOAD_BASE/Instagram/Music"
    mkdir -p "$LM_DOWNLOAD_BASE/TikTok/Video"
    mkdir -p "$LM_DOWNLOAD_BASE/TikTok/Music"
    mkdir -p "$LM_DOWNLOAD_BASE/YouTube/Video"
    mkdir -p "$LM_DOWNLOAD_BASE/YouTube/Music"
    mkdir -p "$LM_DOWNLOAD_BASE/YouTube/Playlist/Video"
    mkdir -p "$LM_DOWNLOAD_BASE/YouTube/Playlist/Music"
    mkdir -p "$LM_DOWNLOAD_BASE/Twitter/Video"
    mkdir -p "$LM_DOWNLOAD_BASE/Twitter/Music"
    mkdir -p "$LM_DOWNLOAD_BASE/Facebook/Video"
    mkdir -p "$LM_DOWNLOAD_BASE/Facebook/Music"
    mkdir -p "$LM_DOWNLOAD_BASE/SoundCloud/Music"
    mkdir -p "$LM_DOWNLOAD_BASE/Pinterest/Video"
    mkdir -p "$LM_DOWNLOAD_BASE/Reddit/Video"
    mkdir -p "$LM_DOWNLOAD_BASE/Vimeo/Video"
    mkdir -p "$LM_DOWNLOAD_BASE/YouTube/Channel/Video"
}

lm_save_config() {
    mkdir -p "$LM_DIR"
    {
        echo "installed=true"
        echo "version=$LM_VERSION"
        echo "download_path=$LM_DOWNLOAD_BASE"
        echo "lang=$LM_LANG"
    } > "$LM_CONFIG"
}

lm_load_config() {
    if [ -f "$LM_CONFIG" ]; then
        . "$LM_CONFIG"
        if [ -n "${download_path:-}" ]; then
            LM_DOWNLOAD_BASE="$download_path"
        fi
        if [ -n "${lang:-}" ]; then
            LM_LANG="$lang"
        fi
    fi
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
    lm_set_lang_vars
    lm_save_config
    echo -e "\n${C_DARK_GREEN}[LM]${C_RESET} $TXT_LANG_CHANGED\n"
    sleep 1
}

lm_detect_platform() {
    local url_lower
    url_lower="$(echo "${1:-}" | tr '[:upper:]' '[:lower:]')"
    if [[ $url_lower == *"instagram.com"* ]] || [[ $url_lower == *"instagr.am"* ]]; then
        echo "instagram"
    elif [[ $url_lower == *"tiktok.com"* ]] || [[ $url_lower == *"vm.tiktok.com"* ]] || [[ $url_lower == *"vt.tiktok.com"* ]] || [[ $url_lower == *"m.tiktok.com"* ]]; then
        echo "tiktok"
    elif [[ $url_lower == *"youtube.com/playlist"* ]] || { [[ $url_lower == *"list="* ]] && { [[ $url_lower == *"youtube.com"* ]] || [[ $url_lower == *"youtu.be"* ]]; }; }; then
        echo "youtube_playlist"
    elif [[ $url_lower == *"youtube.com/@*"* ]] || [[ $url_lower == *"youtube.com/channel/"* ]] || [[ $url_lower == *"youtube.com/c/"* ]]; then
        echo "youtube_channel"
    elif [[ $url_lower == *"youtube.com"* ]] || [[ $url_lower == *"youtu.be"* ]]; then
        echo "youtube"
    elif [[ $url_lower == *"twitter.com"* ]] || [[ $url_lower == *"x.com"* ]]; then
        echo "twitter"
    elif [[ $url_lower == *"facebook.com"* ]] || [[ $url_lower == *"fb.com"* ]] || [[ $url_lower == *"fb.watch"* ]]; then
        echo "facebook"
    elif [[ $url_lower == *"soundcloud.com"* ]]; then
        echo "soundcloud"
    elif [[ $url_lower == *"pinterest.com"* ]] || [[ $url_lower == *"pin.it"* ]]; then
        echo "pinterest"
    elif [[ $url_lower == *"reddit.com"* ]] || [[ $url_lower == *"redd.it"* ]]; then
        echo "reddit"
    elif [[ $url_lower == *"vimeo.com"* ]]; then
        echo "vimeo"
    else
        echo "unknown"
    fi
}

lm_check_update() {
    LM_REMOTE_VERSION=""
    local remote_line
    remote_line="$(curl -fsSL "$LM_REPO_RAW" 2>/dev/null | grep -m1 '^LM_VERSION=')"
    if [ -z "$remote_line" ]; then
        return 1
    fi
    LM_REMOTE_VERSION="${remote_line#LM_VERSION=}"
    LM_REMOTE_VERSION="${LM_REMOTE_VERSION%\"}"
    LM_REMOTE_VERSION="${LM_REMOTE_VERSION#\"}"

    local lang_repo_raw="https://raw.githubusercontent.com/rzayevaga/raicx-downloader/raicX/lm_lang.sh"
    local remote_lang_hash
    remote_lang_hash="$(curl -fsSL "$lang_repo_raw" 2>/dev/null | sha256sum | cut -d' ' -f1)"
    local local_lang_hash=""
    if [ -f "$LM_DIR/lm_lang.sh" ]; then
        local_lang_hash="$(sha256sum "$LM_DIR/lm_lang.sh" | cut -d' ' -f1)"
    fi

    if [ "$LM_REMOTE_VERSION" != "$LM_VERSION" ] || [ "$remote_lang_hash" != "$local_lang_hash" ]; then
        return 0
    fi
    return 2
}

lm_do_update() {
    echo -e "\n${C_DARK_GREEN}[LM]${C_RESET} $TXT_UPDATING"
    local tmp_bin="$LM_BIN.tmp"
    local tmp_lang="$LM_DIR/lm_lang.sh.tmp"
    local lang_repo_raw="https://raw.githubusercontent.com/rzayevaga/raicx-downloader/raicX/lm_lang.sh"

    if curl -fsSL "$LM_REPO_RAW" -o "$tmp_bin" && \
       curl -fsSL "$lang_repo_raw" -o "$tmp_lang"; then
        chmod +x "$tmp_bin"
        mv "$tmp_bin" "$LM_BIN"
        mv "$tmp_lang" "$LM_DIR/lm_lang.sh"
        echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_UPDATE_SUCCESS"
        echo -e "${C_DARK_ORANGE}[LM]${C_RESET} Zəhmət olmasa yenidən başladın."
        exit 0
    else
        echo -e "${C_ERROR}[LM]${C_RESET} $TXT_UPDATE_FAILED"
        rm -f "$tmp_bin" "$tmp_lang"
        return 1
    fi
}

lm_startup_animation() {
    lm_hide_cursor
    clear
    local bar=""
    for i in {1..20}; do
        bar+="█"
        printf "\r${C_DARK_ORANGE}[${bar}"
        for j in $(seq $((20 - i))); do printf " "; done
        printf "] %d%%" $((i * 5))
        sleep 0.03
    done
    printf "${C_RESET}\n\n"
    lm_animate_border "Ɍム-ic LM  Starting"
    sleep 0.3
    lm_show_cursor
}

lm_banner() {
    clear
    echo -e "${C_DARK_ORANGE}╔══════════════════════════════════════════════╗"
    echo -e "║                                              ║"
    echo -e "║           ✦  Ɍム-ic LM DOWNLOADER  ✦         ║"
    echo -e "║              $LM_VERSION                  ║"
    echo -e "║        Created by Agha (lamvav)              ║"
    echo -e "║                                              ║"
    echo -e "╚══════════════════════════════════════════════╝${C_RESET}"
}

lm_run_step() {
    local message="$1"
    shift
    echo -e "${C_DARK_GREEN}[LM]${C_RESET} $message..."
    "$@" &
    local pid=$!
    lm_spin "$pid" "$message"
    return $?
}

lm_now_iso() {
    date '+%Y-%m-%d %H:%M:%S %Z'
}

lm_log_kv() {
    local file="$1"
    local key="$2"
    local value="${3:-}"
    mkdir -p "$(dirname "$file")"
    printf '[%s] %s=%s\n' "$(lm_now_iso)" "$key" "$value" >> "$file"
}

lm_quote_command() {
    local arg
    for arg in "$@"; do
        printf '%q ' "$arg"
    done
}

lm_log_download() {
    local status="$1"
    local platform="$2"
    local mode="$3"
    local url="$4"
    local output_dir="$5"
    local detail_log="$6"
    local reason="${7:-}"
    local logfile="$LM_DIR/history.log"
    mkdir -p "$LM_DIR" "$LM_LOG_DIR"
    printf '[%s] Status: %s | Platform: %s | Mode: %s | Output: %s | Reason: %s | DetailLog: %s | URL: %s\n' "$(lm_now_iso)" "$status" "$platform" "$mode" "$output_dir" "$reason" "$detail_log" "$url" >> "$logfile"
}

lm_validate_url() {
    local url="$1"
    if [ -z "$url" ]; then
        echo "$TXT_ERROR_EMPTY_URL"
        return 1
    fi
    if [[ ! "$url" =~ ^https?:// ]]; then
        echo "$TXT_ERROR_INVALID_URL"
        return 1
    fi
    return 0
}

lm_require_command() {
    local cmd="$1"
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "$TXT_ERROR_MISSING_COMMAND: $cmd"
        return 1
    fi
    return 0
}

lm_prepare_output_dir() {
    local output_dir="$1"
    mkdir -p "$output_dir" 2>/dev/null || return 1
    if [ ! -w "$output_dir" ]; then
        return 1
    fi
    return 0
}

lm_error_reason_from_log() {
    local ret="$1"
    local log_file="$2"
    if [ -f "$log_file" ]; then
        if grep -qiE 'unsupported url|no suitable extractor|not a valid url' "$log_file"; then
            echo "$TXT_ERROR_REASON_UNSUPPORTED"
            return 0
        fi
        if grep -qiE 'private|login|sign in|cookies|authentication' "$log_file"; then
            echo "$TXT_ERROR_REASON_AUTH"
            return 0
        fi
        if grep -qiE 'copyright|blocked|not available|unavailable|removed|deleted' "$log_file"; then
            echo "$TXT_ERROR_REASON_UNAVAILABLE"
            return 0
        fi
        if grep -qiE 'network|timed out|timeout|connection|http error|temporary failure|unable to download' "$log_file"; then
            echo "$TXT_ERROR_REASON_NETWORK"
            return 0
        fi
        if grep -qiE 'ffmpeg|ffprobe|postprocessing|post-process' "$log_file"; then
            echo "$TXT_ERROR_REASON_FFMPEG"
            return 0
        fi
        if grep -qiE 'permission denied|no space left|read-only file system|cannot write|unable to open' "$log_file"; then
            echo "$TXT_ERROR_REASON_STORAGE"
            return 0
        fi
    fi
    echo "$TXT_ERROR_REASON_UNKNOWN (exit=$ret)"
}

lm_print_error_details() {
    local ret="$1"
    local detail_log="$2"
    local reason="$3"
    echo -e "\n${C_ERROR}[LM]${C_RESET} $TXT_DOWNLOAD_FAILED"
    echo -e "${C_ERROR}[LM]${C_RESET} $TXT_ERROR_EXIT_CODE: $ret"
    echo -e "${C_ERROR}[LM]${C_RESET} $TXT_ERROR_REASON: $reason"
    echo -e "${C_DARK_ORANGE}[LM]${C_RESET} $TXT_ERROR_LOG_FILE: $detail_log"
    if [ -f "$detail_log" ]; then
        echo -e "${C_DARK_ORANGE}[LM]${C_RESET} $TXT_ERROR_LAST_LINES"
        tail -n 12 "$detail_log"
    fi
    echo
}

lm_select_quality() {
    echo -e "\n${C_DARK_BLUE}$TXT_QUALITY_PROMPT${C_RESET}"
    echo -e "${C_DARK_ORANGE}[1]${C_RESET} 1080p"
    echo -e "${C_DARK_ORANGE}[2]${C_RESET} 720p"
    echo -e "${C_DARK_ORANGE}[3]${C_RESET} 480p"
    echo -e "${C_DARK_ORANGE}[4]${C_RESET} 360p"
    echo -ne "${C_PROMPT}$TXT_PROMPT_CHOICE:${C_RESET} "
    read -r qchoice
    case "$qchoice" in
        1) echo "bestvideo[height<=1080]+bestaudio/best[height<=1080]" ;;
        2) echo "bestvideo[height<=720]+bestaudio/best[height<=720]" ;;
        3) echo "bestvideo[height<=480]+bestaudio/best[height<=480]" ;;
        4) echo "bestvideo[height<=360]+bestaudio/best[height<=360]" ;;
        *) echo "bestvideo[height<=1080]+bestaudio/best[height<=1080]" ;;
    esac
}

lm_prompt_subtitles() {
    echo -ne "\n${C_PROMPT}$TXT_PROMPT_SUBTITLES${C_RESET} "
    read -r sub_ans
    case "$sub_ans" in
        y|Y|yes|YES|Yes|h|H)
            echo -ne "${C_PROMPT}$TXT_PROMPT_SUB_LANG${C_RESET} "
            read -r sub_lang
            if [ -n "$sub_lang" ]; then
                echo "--write-subs --sub-lang $sub_lang"
            else
                echo "--write-subs"
            fi
            ;;
        *) echo "" ;;
    esac
}

lm_download_common() {
    local platform="$1"
    local mode="$2"
    local url="$3"
    local quality_format=""
    local output_dir template format extra_opts_str
    local -a opts=()

    if [ "$mode" = "video_quality" ] && { [ "$platform" = "youtube" ] || [ "$platform" = "youtube_playlist" ] || [ "$platform" = "youtube_channel" ]; }; then
        quality_format="$(lm_select_quality)"
        mode="video"
    fi

    if { [ "$platform" = "youtube" ] || [ "$platform" = "youtube_playlist" ] || [ "$platform" = "youtube_channel" ]; } && [ "$mode" = "video" ]; then
        extra_opts_str="$(lm_prompt_subtitles)"
    fi

    case "${platform}:${mode}" in
        instagram:video)
            output_dir="$LM_DOWNLOAD_BASE/Instagram/Video"
            template="$output_dir/%(title)s.%(ext)s"
            format="best"
            opts=(--merge-output-format mp4 --concurrent-fragments 4)
            echo -e "\n${C_DARK_ORANGE}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_INSTAGRAM_VIDEO\n"
            ;;
        instagram:audio)
            output_dir="$LM_DOWNLOAD_BASE/Instagram/Music"
            template="$output_dir/%(title)s.%(ext)s"
            format="bestaudio/best"
            opts=(--extract-audio --audio-format mp3 --audio-quality 0)
            echo -e "\n${C_DARK_ORANGE}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_INSTAGRAM_AUDIO\n"
            ;;
        tiktok:video)
            output_dir="$LM_DOWNLOAD_BASE/TikTok/Video"
            template="$output_dir/%(title)s.%(ext)s"
            format="best"
            opts=(--merge-output-format mp4 --concurrent-fragments 4)
            echo -e "\n${C_DARK_ORANGE}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_TIKTOK_VIDEO\n"
            ;;
        tiktok:audio)
            output_dir="$LM_DOWNLOAD_BASE/TikTok/Music"
            template="$output_dir/%(title)s.%(ext)s"
            format="bestaudio/best"
            opts=(--extract-audio --audio-format mp3 --audio-quality 0)
            echo -e "\n${C_DARK_ORANGE}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_TIKTOK_AUDIO\n"
            ;;
        youtube:video)
            output_dir="$LM_DOWNLOAD_BASE/YouTube/Video"
            template="$output_dir/%(title)s.%(ext)s"
            if [ -n "$quality_format" ]; then
                format="$quality_format"
            else
                format="bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"
            fi
            opts=(--merge-output-format mp4 --concurrent-fragments 4)
            [ -n "$extra_opts_str" ] && opts+=($extra_opts_str)
            echo -e "\n${C_DARK_ORANGE}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_YT_VIDEO\n"
            ;;
        youtube:audio)
            output_dir="$LM_DOWNLOAD_BASE/YouTube/Music"
            template="$output_dir/%(title)s.%(ext)s"
            format="bestaudio/best"
            opts=(--extract-audio --audio-format mp3 --audio-quality 0 --embed-thumbnail --embed-metadata)
            echo -e "\n${C_DARK_ORANGE}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_YT_AUDIO\n"
            ;;
        youtube_playlist:video)
            output_dir="$LM_DOWNLOAD_BASE/YouTube/Playlist/Video"
            template="$output_dir/%(playlist_title)s - %(playlist_index)s - %(title)s.%(ext)s"
            if [ -n "$quality_format" ]; then
                format="$quality_format"
            else
                format="bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"
            fi
            opts=(--yes-playlist --merge-output-format mp4 --concurrent-fragments 4)
            [ -n "$extra_opts_str" ] && opts+=($extra_opts_str)
            echo -e "\n${C_DARK_ORANGE}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_YTPL_VIDEO\n"
            ;;
        youtube_playlist:audio)
            output_dir="$LM_DOWNLOAD_BASE/YouTube/Playlist/Music"
            template="$output_dir/%(playlist_title)s - %(playlist_index)s - %(title)s.%(ext)s"
            format="bestaudio/best"
            opts=(--yes-playlist --extract-audio --audio-format mp3 --audio-quality 0 --embed-thumbnail --embed-metadata)
            echo -e "\n${C_DARK_ORANGE}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_YTPL_AUDIO\n"
            ;;
        youtube_channel:video)
            output_dir="$LM_DOWNLOAD_BASE/YouTube/Channel/Video"
            template="$output_dir/%(uploader)s - %(title)s.%(ext)s"
            if [ -n "$quality_format" ]; then
                format="$quality_format"
            else
                format="bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"
            fi
            opts=(--merge-output-format mp4 --concurrent-fragments 4)
            [ -n "$extra_opts_str" ] && opts+=($extra_opts_str)
            echo -e "\n${C_DARK_ORANGE}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_YT_CHANNEL_VIDEO\n"
            ;;
        youtube_channel:audio)
            output_dir="$LM_DOWNLOAD_BASE/YouTube/Channel/Music"
            template="$output_dir/%(uploader)s - %(title)s.%(ext)s"
            format="bestaudio/best"
            opts=(--extract-audio --audio-format mp3 --audio-quality 0 --embed-thumbnail --embed-metadata)
            echo -e "\n${C_DARK_ORANGE}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_YT_CHANNEL_AUDIO\n"
            ;;
        twitter:video)
            output_dir="$LM_DOWNLOAD_BASE/Twitter/Video"
            template="$output_dir/%(title)s.%(ext)s"
            format="best"
            opts=(--merge-output-format mp4 --concurrent-fragments 4)
            echo -e "\n${C_DARK_ORANGE}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_TWITTER_VIDEO\n"
            ;;
        twitter:audio)
            output_dir="$LM_DOWNLOAD_BASE/Twitter/Music"
            template="$output_dir/%(title)s.%(ext)s"
            format="bestaudio/best"
            opts=(--extract-audio --audio-format mp3 --audio-quality 0)
            echo -e "\n${C_DARK_ORANGE}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_TWITTER_AUDIO\n"
            ;;
        facebook:video)
            output_dir="$LM_DOWNLOAD_BASE/Facebook/Video"
            template="$output_dir/%(title)s.%(ext)s"
            format="best"
            opts=(--merge-output-format mp4 --concurrent-fragments 4)
            echo -e "\n${C_DARK_ORANGE}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_FACEBOOK_VIDEO\n"
            ;;
        facebook:audio)
            output_dir="$LM_DOWNLOAD_BASE/Facebook/Music"
            template="$output_dir/%(title)s.%(ext)s"
            format="bestaudio/best"
            opts=(--extract-audio --audio-format mp3 --audio-quality 0)
            echo -e "\n${C_DARK_ORANGE}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_FACEBOOK_AUDIO\n"
            ;;
        soundcloud:audio)
            output_dir="$LM_DOWNLOAD_BASE/SoundCloud/Music"
            template="$output_dir/%(title)s.%(ext)s"
            format="bestaudio/best"
            opts=(--extract-audio --audio-format mp3 --audio-quality 0 --embed-thumbnail --embed-metadata)
            echo -e "\n${C_DARK_ORANGE}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_SOUNDCLOUD_AUDIO\n"
            ;;
        pinterest:video)
            output_dir="$LM_DOWNLOAD_BASE/Pinterest/Video"
            template="$output_dir/%(title)s.%(ext)s"
            format="best"
            opts=(--merge-output-format mp4 --concurrent-fragments 4)
            echo -e "\n${C_DARK_ORANGE}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_PINTEREST_VIDEO\n"
            ;;
        reddit:video)
            output_dir="$LM_DOWNLOAD_BASE/Reddit/Video"
            template="$output_dir/%(title)s.%(ext)s"
            format="best"
            opts=(--merge-output-format mp4 --concurrent-fragments 4)
            echo -e "\n${C_DARK_ORANGE}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_REDDIT_VIDEO\n"
            ;;
        vimeo:video)
            output_dir="$LM_DOWNLOAD_BASE/Vimeo/Video"
            template="$output_dir/%(title)s.%(ext)s"
            format="best"
            opts=(--merge-output-format mp4 --concurrent-fragments 4)
            echo -e "\n${C_DARK_ORANGE}[LM]${C_RESET} $TXT_DOWNLOAD_STARTED_VIMEO_VIDEO\n"
            ;;
        *)
            echo -e "${C_ERROR}[LM]${C_RESET} $TXT_PLATFORM_UNKNOWN"
            echo -e "${C_DARK_ORANGE}$TXT_SUPPORTED_PLATFORMS${C_RESET}"
            return 1
            ;;
    esac

    local validation_error
    if ! validation_error="$(lm_validate_url "$url")"; then
        echo -e "\n${C_ERROR}[LM]${C_RESET} $validation_error\n"
        return 1
    fi

    local command_error
    if ! command_error="$(lm_require_command yt-dlp)"; then
        echo -e "\n${C_ERROR}[LM]${C_RESET} $command_error\n"
        return 127
    fi

    if ! lm_prepare_output_dir "$output_dir"; then
        echo -e "\n${C_ERROR}[LM]${C_RESET} $TXT_ERROR_OUTPUT_DIR: $output_dir\n"
        return 1
    fi

    mkdir -p "$LM_LOG_DIR"
    local request_id detail_log started_at finished_at ret reason
    request_id="$(date '+%Y%m%d-%H%M%S')-$$-${RANDOM:-0}"
    detail_log="$LM_LOG_DIR/download-$request_id.log"
    started_at="$(lm_now_iso)"

    local -a cmd=(yt-dlp --newline --write-info-json --embed-metadata --no-overwrites -f "$format" "${opts[@]}" -o "$template" "$url")
    lm_log_kv "$detail_log" "request_id" "$request_id"
    lm_log_kv "$detail_log" "version" "$LM_VERSION"
    lm_log_kv "$detail_log" "started_at" "$started_at"
    lm_log_kv "$detail_log" "platform" "$platform"
    lm_log_kv "$detail_log" "mode" "$mode"
    lm_log_kv "$detail_log" "output_dir" "$output_dir"
    lm_log_kv "$detail_log" "template" "$template"
    lm_log_kv "$detail_log" "format" "$format"
    lm_log_kv "$detail_log" "url" "$url"
    lm_log_kv "$detail_log" "yt_dlp_version" "$(yt-dlp --version 2>/dev/null || echo unknown)"
    lm_log_kv "$detail_log" "ffmpeg_version" "$(ffmpeg -version 2>/dev/null | head -1 || echo unknown)"
    lm_log_kv "$detail_log" "command" "$(lm_quote_command "${cmd[@]}")"
    echo -e "${C_DARK_ORANGE}[LM]${C_RESET} $TXT_LOG_DETAIL_FILE: $detail_log"

    "${cmd[@]}" 2>&1 | tee -a "$detail_log"
    ret=${PIPESTATUS[0]}
    finished_at="$(lm_now_iso)"
    lm_log_kv "$detail_log" "finished_at" "$finished_at"
    lm_log_kv "$detail_log" "exit_code" "$ret"

    if [ "$ret" -eq 0 ]; then
        lm_log_kv "$detail_log" "status" "success"
        echo -e "\n${C_DARK_GREEN}[LM]${C_RESET} $TXT_DOWNLOAD_DONE_PREFIX: $output_dir\n"
        lm_log_download "SUCCESS" "$platform" "$mode" "$url" "$output_dir" "$detail_log" "$TXT_LOG_REASON_SUCCESS"
    else
        reason="$(lm_error_reason_from_log "$ret" "$detail_log")"
        lm_log_kv "$detail_log" "status" "failed"
        lm_log_kv "$detail_log" "reason" "$reason"
        lm_log_download "FAILED" "$platform" "$mode" "$url" "$output_dir" "$detail_log" "$reason"
        lm_print_error_details "$ret" "$detail_log" "$reason"
    fi
    return "$ret"
}

lm_download_for_platform() {
    local platform="$1"
    local url="$2"
    local kind="$3"
    local quality_opt=""

    if [ "$platform" = "unknown" ]; then
        echo -e "${C_ERROR}[LM]${C_RESET} $TXT_PLATFORM_UNKNOWN"
        echo -e "${C_DARK_ORANGE}$TXT_SUPPORTED_PLATFORMS${C_RESET}"
        return 1
    fi

    if [ "$platform" = "youtube_playlist" ] && [ "$kind" != "video" ] && [ "$kind" != "audio" ]; then
        kind="video"
    fi

    lm_download_common "$platform" "$kind" "$url"
}

lm_download_with_prompt() {
    local platform="$1"
    local url="$2"

    case "$platform" in
        instagram)
            echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_AUTO_PLATFORM_INSTAGRAM\n" ;;
        tiktok)
            echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_AUTO_PLATFORM_TIKTOK\n" ;;
        youtube)
            echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_AUTO_PLATFORM_YT_SINGLE\n" ;;
        youtube_playlist)
            echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_AUTO_PLATFORM_YT_PLAYLIST\n" ;;
        youtube_channel)
            echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_AUTO_PLATFORM_YT_CHANNEL\n" ;;
        twitter)
            echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_AUTO_PLATFORM_TWITTER\n" ;;
        facebook)
            echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_AUTO_PLATFORM_FACEBOOK\n" ;;
        soundcloud)
            echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_AUTO_PLATFORM_SOUNDCLOUD\n" ;;
        pinterest)
            echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_AUTO_PLATFORM_PINTEREST\n" ;;
        reddit)
            echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_AUTO_PLATFORM_REDDIT\n" ;;
        vimeo)
            echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_AUTO_PLATFORM_VIMEO\n" ;;
        *)
            echo -e "${C_ERROR}[LM]${C_RESET} $TXT_PLATFORM_UNKNOWN"
            echo -e "${C_DARK_ORANGE}$TXT_SUPPORTED_PLATFORMS${C_RESET}"
            return 1
            ;;
    esac

    local opt1 opt2 opt3 opt4
    if [ "$platform" = "youtube_playlist" ]; then
        opt1="$TXT_OPTION_PLAYLIST_VIDEO"
        opt2="$TXT_OPTION_PLAYLIST_AUDIO"
        opt3="$TXT_OPTION_QUALITY_PLAYLIST"
        echo -e "${C_DARK_ORANGE}[1]${C_RESET} $opt1"
        echo -e "${C_DARK_ORANGE}[2]${C_RESET} $opt2"
        echo -e "${C_DARK_ORANGE}[3]${C_RESET} $opt3"
    elif [ "$platform" = "youtube" ]; then
        opt1="$TXT_OPTION_VIDEO_DOWNLOAD"
        opt2="$TXT_OPTION_AUDIO_DOWNLOAD"
        opt3="$TXT_OPTION_QUALITY_VIDEO"
        echo -e "${C_DARK_ORANGE}[1]${C_RESET} $opt1"
        echo -e "${C_DARK_ORANGE}[2]${C_RESET} $opt2"
        echo -e "${C_DARK_ORANGE}[3]${C_RESET} $opt3"
    elif [ "$platform" = "youtube_channel" ]; then
        opt1="$TXT_OPTION_CHANNEL_VIDEO"
        opt2="$TXT_OPTION_CHANNEL_AUDIO"
        opt3="$TXT_OPTION_QUALITY_CHANNEL"
        echo -e "${C_DARK_ORANGE}[1]${C_RESET} $opt1"
        echo -e "${C_DARK_ORANGE}[2]${C_RESET} $opt2"
        echo -e "${C_DARK_ORANGE}[3]${C_RESET} $opt3"
    elif [ "$platform" = "soundcloud" ]; then
        opt1="$TXT_OPTION_AUDIO_DOWNLOAD"
        echo -e "${C_DARK_ORANGE}[1]${C_RESET} $opt1"
    elif [ "$platform" = "pinterest" ] || [ "$platform" = "reddit" ] || [ "$platform" = "vimeo" ]; then
        opt1="$TXT_OPTION_VIDEO_DOWNLOAD"
        echo -e "${C_DARK_ORANGE}[1]${C_RESET} $opt1"
    else
        opt1="$TXT_OPTION_VIDEO_DOWNLOAD"
        opt2="$TXT_OPTION_AUDIO_DOWNLOAD"
        echo -e "${C_DARK_ORANGE}[1]${C_RESET} $opt1"
        echo -e "${C_DARK_ORANGE}[2]${C_RESET} $opt2"
    fi
    echo -ne "\n${C_PROMPT}$TXT_PROMPT_CHOICE:${C_RESET} "
    read -r choice

    case "$choice" in
        1)
            if [ "$platform" = "soundcloud" ]; then
                lm_download_for_platform "$platform" "$url" "audio"
            else
                lm_download_for_platform "$platform" "$url" "video"
            fi
            ;;
        2)
            if [ "$platform" = "pinterest" ] || [ "$platform" = "reddit" ] || [ "$platform" = "vimeo" ] || [ "$platform" = "soundcloud" ]; then
                echo -e "${C_ERROR}[LM]${C_RESET} $TXT_ERROR_INVALID_CHOICE"
            else
                lm_download_for_platform "$platform" "$url" "audio"
            fi
            ;;
        3)
            if [ "$platform" = "youtube" ] || [ "$platform" = "youtube_playlist" ] || [ "$platform" = "youtube_channel" ]; then
                lm_download_common "$platform" "video_quality" "$url"
            else
                echo -e "${C_ERROR}[LM]${C_RESET} $TXT_ERROR_INVALID_CHOICE"
            fi
            ;;
        *) echo -e "${C_ERROR}[LM]${C_RESET} $TXT_ERROR_INVALID_CHOICE" ;;
    esac
}

lm_batch_download() {
    local urls=()
    echo -e "\n${C_DARK_BLUE}$TXT_BATCH_PROMPT${C_RESET}"
    echo -e "${C_DARK_ORANGE}$TXT_BATCH_INSTRUCTION${C_RESET}"
    echo -e "${C_DARK_ORANGE}$TXT_BATCH_FILE_HINT${C_RESET}"
    echo -ne "${C_PROMPT}$TXT_BATCH_FILE_PATH${C_RESET} "
    read -r file_path
    if [ -n "$file_path" ]; then
        if [ -f "$file_path" ]; then
            mapfile -t urls < "$file_path"
            echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_BATCH_FILE_LOADED ($(wc -l < "$file_path") link)"
        else
            echo -e "${C_ERROR}[LM]${C_RESET} $TXT_BATCH_FILE_NOT_FOUND"
            return 1
        fi
    else
        while IFS= read -r line; do
            [ -z "$line" ] && break
            urls+=("$line")
        done
    fi
    if [ ${#urls[@]} -eq 0 ]; then
        echo -e "${C_ERROR}[LM]${C_RESET} $TXT_BATCH_EMPTY"
        return 1
    fi
    echo -e "\n${C_DARK_GREEN}[LM]${C_RESET} $TXT_BATCH_START (${#urls[@]} link)"
    for idx in "${!urls[@]}"; do
        echo -e "\n${C_DARK_BROWN}[$((idx + 1))/${#urls[@]}]${C_RESET} ${urls[$idx]}"
        local platform
        platform="$(lm_detect_platform "${urls[$idx]}")"
        lm_download_with_prompt "$platform" "${urls[$idx]}"
    done
    echo -e "\n${C_DARK_GREEN}[LM]${C_RESET} $TXT_BATCH_DONE"
}

lm_get_clipboard_url() {
    local url
    if command -v termux-clipboard-get &>/dev/null; then
        url="$(termux-clipboard-get 2>/dev/null)"
        if [[ "$url" =~ ^https?:// ]]; then
            echo "$url"
            return 0
        fi
    fi
    return 1
}

lm_search_fetch() {
    local query="$1"
    local tmp="$LM_DIR/search_results.tmp"
    mkdir -p "$LM_DIR"
    yt-dlp -O "%(id)s|%(title)s" "ytsearch30:${query}" 2>/dev/null > "$tmp"
}

lm_search_apply_filter() {
    local filter="$1"
    local in_file="$2"
    local out_file="$3"
    if [ -z "$filter" ]; then
        cp "$in_file" "$out_file"
        return 0
    fi
    : > "$out_file"
    while IFS= read -r line; do
        title="${line#*|}"
        if printf '%s\n' "$title" | grep -i -F -- "$filter" >/dev/null 2>&1; then
            printf '%s\n' "$line" >> "$out_file"
        fi
    done < "$in_file"
}

lm_search_menu() {
    local page_size=10
    local query filter
    local tmp_raw="$LM_DIR/search_results_raw.tmp"
    local tmp_filtered="$LM_DIR/search_results_filtered.tmp"
    while true; do
        lm_banner
        echo -e "${C_DARK_BLUE}╔══════════════════════════════════════════════╗"
        echo -e "║                  $TXT_SEARCH_TITLE                  ║"
        echo -e "╚══════════════════════════════════════════════╝${C_RESET}\n"
        echo -ne "${C_PROMPT}$TXT_SEARCH_PROMPT:${C_RESET} "
        read -r query
        if [ -z "$query" ]; then
            echo -e "\n${C_ERROR}[LM]${C_RESET} $TXT_ERROR_INVALID_CHOICE"
            sleep 1
            continue
        fi
        echo -ne "\n${C_PROMPT}Filter (optional, Enter to skip):${C_RESET} "
        read -r filter
        echo -e "\n${C_DARK_GREEN}[LM]${C_RESET} $TXT_SEARCHING"
        lm_search_fetch "$query" &
        local pid=$!
        lm_spin "$pid" "$TXT_SEARCHING"
        wait "$pid"
        if [ ! -s "$LM_DIR/search_results.tmp" ]; then
            rm -f "$LM_DIR/search_results.tmp" "$tmp_raw" "$tmp_filtered"
            echo -e "\n${C_ERROR}[LM]${C_RESET} $TXT_SEARCH_NO_RESULTS"
            sleep 1
            continue
        fi
        cp "$LM_DIR/search_results.tmp" "$tmp_raw"
        rm -f "$LM_DIR/search_results.tmp"
        lm_search_apply_filter "$filter" "$tmp_raw" "$tmp_filtered"
        mapfile -t search_results < "$tmp_filtered"
        rm -f "$tmp_raw" "$tmp_filtered"
        if [ "${#search_results[@]}" -eq 0 ]; then
            echo -e "\n${C_ERROR}[LM]${C_RESET} $TXT_SEARCH_NO_RESULTS"
            echo -ne "\n${C_PROMPT}$TXT_SEARCH_AGAIN${C_RESET} "
            read -r again
            case "$again" in
                h|H|y|Y|e|E|yes|YES|Yes) continue ;;
                *) break ;;
            esac
            continue
        fi
        local page=0
        while true; do
            local start=$((page * page_size))
            local end=$((start + page_size))
            local total=${#search_results[@]}
            if [ "$start" -ge "$total" ]; then
                page=0
                start=0
                end=$page_size
            fi
            echo -e "\n${C_DARK_BLUE}─── $TXT_SEARCH_RESULTS ───${C_RESET}\n"
            local idx page_index=1
            local page_ids=()
            for ((idx=start; idx<end && idx<total; idx++)); do
                local line="${search_results[$idx]}"
                local id="${line%%|*}"
                local title="${line#*|}"
                page_ids+=("$id")
                printf "${C_DARK_ORANGE}[%2d]${C_RESET} %s\n" "$page_index" "$title"
                page_index=$((page_index + 1))
            done
            echo -e "\n${C_DARK_BROWN}[n] next  [p] prev  [f] new filter  [q] quit${C_RESET}"
            echo -ne "${C_PROMPT}Select 1-10:${C_RESET} "
            read -r num
            case "$num" in
                n|N)
                    if (( end < total )); then
                        page=$((page + 1))
                    else
                        echo -e "${C_DARK_ORANGE}[LM]${C_RESET} No more pages."
                        sleep 1
                    fi
                    continue
                    ;;
                p|P)
                    if (( page > 0 )); then
                        page=$((page - 1))
                    else
                        echo -e "${C_DARK_ORANGE}[LM]${C_RESET} Already on first page."
                        sleep 1
                    fi
                    continue
                    ;;
                f|F)
                    echo -ne "${C_PROMPT}Filter (optional, Enter to skip):${C_RESET} "
                    read -r filter
                    lm_search_apply_filter "$filter" "$tmp_raw" "$tmp_filtered"
                    mapfile -t search_results < "$tmp_filtered"
                    rm -f "$tmp_filtered"
                    page=0
                    continue
                    ;;
                q|Q)
                    rm -f "$tmp_raw" "$tmp_filtered"
                    return 0
                    ;;
                *)
                    if [[ "$num" =~ ^[1-9]$|^10$ ]]; then
                        local choice=$((10#$num - 1))
                        if [ "$choice" -ge 0 ] && [ "$choice" -lt "${#page_ids[@]}" ]; then
                            local selected_id="${page_ids[$choice]}"
                            local video_url="https://youtu.be/$selected_id"
                            echo -e "\n${C_DARK_GREEN}[LM]${C_RESET} $TXT_AUTO_PLATFORM_YT_SINGLE"
                            echo -e "${C_DARK_ORANGE}[1]${C_RESET} $TXT_OPTION_VIDEO_DOWNLOAD"
                            echo -e "${C_DARK_ORANGE}[2]${C_RESET} $TXT_OPTION_AUDIO_DOWNLOAD"
                            echo -e "${C_DARK_ORANGE}[3]${C_RESET} $TXT_OPTION_QUALITY_VIDEO"
                            echo -ne "\n${C_PROMPT}$TXT_PROMPT_CHOICE:${C_RESET} "
                            read -r vtype
                            case "$vtype" in
                                1) lm_download_common youtube video "$video_url" ;;
                                2) lm_download_common youtube audio "$video_url" ;;
                                3) lm_download_common youtube video_quality "$video_url" ;;
                                *) echo -e "${C_ERROR}[LM]${C_RESET} $TXT_ERROR_INVALID_CHOICE" ;;
                            esac
                            echo -ne "\n${C_PROMPT}$TXT_SEARCH_AGAIN${C_RESET} "
                            read -r again
                            case "$again" in
                                h|H|y|Y|e|E|yes|YES|Yes) break ;;
                                *) rm -f "$tmp_raw" "$tmp_filtered"; return 0 ;;
                            esac
                        else
                            echo -e "${C_ERROR}[LM]${C_RESET} $TXT_ERROR_INVALID_CHOICE"
                            sleep 1
                        fi
                    else
                        echo -e "${C_ERROR}[LM]${C_RESET} $TXT_ERROR_INVALID_CHOICE"
                        sleep 1
                    fi
                    ;;
            esac
        done
    done
}

lm_show_system_info() {
    lm_banner
    echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_SYSTEM_INFO\n"
    echo -e "${C_DARK_ORANGE}Device Model:${C_RESET} $(getprop ro.product.model 2>/dev/null || echo 'N/A')"
    echo -e "${C_DARK_ORANGE}Manufacturer:${C_RESET} $(getprop ro.product.manufacturer 2>/dev/null || echo 'N/A')"
    echo -e "${C_DARK_ORANGE}Android Version:${C_RESET} $(getprop ro.build.version.release 2>/dev/null || echo 'N/A')"
    echo -e "${C_DARK_ORANGE}SDK Level:${C_RESET} $(getprop ro.build.version.sdk 2>/dev/null || echo 'N/A')"
    echo -e "${C_DARK_ORANGE}Architecture:${C_RESET} $(uname -m)"
    echo -e "${C_DARK_ORANGE}CPU Cores:${C_RESET} $(nproc)"
    local load
    load="$(awk '{print $1, $2, $3}' /proc/loadavg 2>/dev/null)"
    [ -n "$load" ] && echo -e "${C_DARK_ORANGE}CPU Load (1,5,15 min):${C_RESET} $load"
    echo -e "${C_DARK_ORANGE}RAM Usage:${C_RESET}"
    free -h 2>/dev/null | grep -v "Swap" | sed 's/^/  /'
    echo -e "${C_DARK_ORANGE}Storage (/data):${C_RESET}"
    df -h /data 2>/dev/null | tail -1 | awk '{print "  Total: "$2" Used: "$3" Free: "$4" Use%: "$5}'
    echo -e "${C_DARK_ORANGE}Shell:${C_RESET} ${SHELL:-N/A}"
    echo -e "${C_DARK_ORANGE}Termux Version:${C_RESET} ${TERMUX_VERSION:-N/A}"
    echo -e "${C_DARK_ORANGE}Python:${C_RESET} $(python --version 2>&1 | awk '{print $2}')"
    echo -e "${C_DARK_ORANGE}yt-dlp:${C_RESET} $(yt-dlp --version 2>/dev/null || echo 'Not installed')"
    echo -e "${C_DARK_ORANGE}FFmpeg:${C_RESET} $(ffmpeg -version 2>/dev/null | head -1 | awk '{print $3}' || echo 'Not installed')"
    echo -e "${C_DARK_ORANGE}gallery-dl:${C_RESET} $(gallery-dl --version 2>/dev/null || echo 'Not installed')"
    echo -e "${C_DARK_ORANGE}pip:${C_RESET} $(pip --version 2>/dev/null | awk '{print $2}')"
    echo -e "\n${C_PROMPT}$TXT_PROMPT_CONTINUE...${C_RESET}"
    read -r
}

lm_view_log() {
    local logfile="$LM_DIR/history.log"
    if [ ! -f "$logfile" ]; then
        echo -e "\n${C_ERROR}[LM]${C_RESET} $TXT_LOG_EMPTY"
        sleep 2
        return
    fi
    lm_banner
    echo -e "${C_DARK_BLUE}╔══════════════════════════════════════════════╗"
    echo -e "║                 $TXT_LOG_TITLE                 ║"
    echo -e "╚══════════════════════════════════════════════╝${C_RESET}\n"
    cat "$logfile"
    echo -e "\n${C_PROMPT}$TXT_PROMPT_CONTINUE...${C_RESET}"
    read -r
}

lm_manual_menu() {
    while true; do
        lm_banner
        echo -e "${C_DARK_BLUE}╔══════════════════════════════════════════════╗"
        echo -e "║           $TXT_MANUAL_MENU_TITLE             ║"
        echo -e "╚══════════════════════════════════════════════╝${C_RESET}\n"
        echo -e "${C_DARK_ORANGE}[1]${C_RESET} Instagram"
        echo -e "${C_DARK_ORANGE}[2]${C_RESET} TikTok"
        echo -e "${C_DARK_ORANGE}[3]${C_RESET} YouTube"
        echo -e "${C_DARK_ORANGE}[4]${C_RESET} Twitter/X"
        echo -e "${C_DARK_ORANGE}[5]${C_RESET} Facebook"
        echo -e "${C_DARK_ORANGE}[6]${C_RESET} SoundCloud"
        echo -e "${C_DARK_ORANGE}[7]${C_RESET} Pinterest"
        echo -e "${C_DARK_ORANGE}[8]${C_RESET} Reddit"
        echo -e "${C_DARK_ORANGE}[9]${C_RESET} Vimeo"
        echo -e "${C_DARK_BROWN}[0]${C_RESET} $TXT_MENU_OPTION_BACK\n"
        echo -ne "${C_PROMPT}$TXT_PROMPT_CHOICE:${C_RESET} "
        read -r platform_choice
        case "$platform_choice" in
            1)
                echo -ne "\n${C_PROMPT}$TXT_PROMPT_INSTAGRAM_LINK:${C_RESET} "
                read -r ig_url
                lm_download_with_prompt instagram "$ig_url"
                echo -e "\n${C_PROMPT}$TXT_PROMPT_CONTINUE...${C_RESET}"
                read -r
                ;;
            2)
                echo -ne "\n${C_PROMPT}$TXT_PROMPT_TIKTOK_LINK:${C_RESET} "
                read -r tt_url
                lm_download_with_prompt tiktok "$tt_url"
                echo -e "\n${C_PROMPT}$TXT_PROMPT_CONTINUE...${C_RESET}"
                read -r
                ;;
            3)
                while true; do
                    echo -e "\n${C_DARK_BLUE}$TXT_MENU_YT_MODE_TITLE:${C_RESET}"
                    echo -e "${C_DARK_ORANGE}[1]${C_RESET} $TXT_MENU_YT_MODE_SINGLE"
                    echo -e "${C_DARK_ORANGE}[2]${C_RESET} $TXT_MENU_YT_MODE_PLAYLIST"
                    echo -e "${C_DARK_ORANGE}[3]${C_RESET} $TXT_MENU_YT_MODE_CHANNEL"
                    echo -e "${C_DARK_BROWN}[0]${C_RESET} $TXT_MENU_OPTION_BACK\n"
                    echo -ne "${C_PROMPT}$TXT_PROMPT_CHOICE:${C_RESET} "
                    read -r yt_mode
                    case "$yt_mode" in
                        1)
                            echo -ne "\n${C_PROMPT}$TXT_PROMPT_YT_SINGLE_LINK:${C_RESET} "
                            read -r yt_single_url
                            lm_download_with_prompt youtube "$yt_single_url"
                            echo -e "\n${C_PROMPT}$TXT_PROMPT_CONTINUE...${C_RESET}"
                            read -r
                            break
                            ;;
                        2)
                            echo -ne "\n${C_PROMPT}$TXT_PROMPT_YT_PLAYLIST_LINK:${C_RESET} "
                            read -r yt_pl_url
                            lm_download_with_prompt youtube_playlist "$yt_pl_url"
                            echo -e "\n${C_PROMPT}$TXT_PROMPT_CONTINUE...${C_RESET}"
                            read -r
                            break
                            ;;
                        3)
                            echo -ne "\n${C_PROMPT}$TXT_PROMPT_YT_CHANNEL_LINK:${C_RESET} "
                            read -r yt_ch_url
                            lm_download_with_prompt youtube_channel "$yt_ch_url"
                            echo -e "\n${C_PROMPT}$TXT_PROMPT_CONTINUE...${C_RESET}"
                            read -r
                            break
                            ;;
                        0) break ;;
                        *) echo -e "${C_ERROR}[LM]${C_RESET} $TXT_ERROR_INVALID_CHOICE" ;;
                    esac
                done
                ;;
            4)
                echo -ne "\n${C_PROMPT}$TXT_PROMPT_TWITTER_LINK:${C_RESET} "
                read -r tw_url
                lm_download_with_prompt twitter "$tw_url"
                echo -e "\n${C_PROMPT}$TXT_PROMPT_CONTINUE...${C_RESET}"
                read -r
                ;;
            5)
                echo -ne "\n${C_PROMPT}$TXT_PROMPT_FACEBOOK_LINK:${C_RESET} "
                read -r fb_url
                lm_download_with_prompt facebook "$fb_url"
                echo -e "\n${C_PROMPT}$TXT_PROMPT_CONTINUE...${C_RESET}"
                read -r
                ;;
            6)
                echo -ne "\n${C_PROMPT}$TXT_PROMPT_SOUNDCLOUD_LINK:${C_RESET} "
                read -r sc_url
                lm_download_with_prompt soundcloud "$sc_url"
                echo -e "\n${C_PROMPT}$TXT_PROMPT_CONTINUE...${C_RESET}"
                read -r
                ;;
            7)
                echo -ne "\n${C_PROMPT}$TXT_PROMPT_PINTEREST_LINK:${C_RESET} "
                read -r pi_url
                lm_download_with_prompt pinterest "$pi_url"
                echo -e "\n${C_PROMPT}$TXT_PROMPT_CONTINUE...${C_RESET}"
                read -r
                ;;
            8)
                echo -ne "\n${C_PROMPT}$TXT_PROMPT_REDDIT_LINK:${C_RESET} "
                read -r rd_url
                lm_download_with_prompt reddit "$rd_url"
                echo -e "\n${C_PROMPT}$TXT_PROMPT_CONTINUE...${C_RESET}"
                read -r
                ;;
            9)
                echo -ne "\n${C_PROMPT}$TXT_PROMPT_VIMEO_LINK:${C_RESET} "
                read -r vm_url
                lm_download_with_prompt vimeo "$vm_url"
                echo -e "\n${C_PROMPT}$TXT_PROMPT_CONTINUE...${C_RESET}"
                read -r
                ;;
            0) break ;;
            *) echo -e "${C_ERROR}[LM]${C_RESET} $TXT_ERROR_INVALID_CHOICE"; sleep 2 ;;
        esac
    done
}

lm_auto_download() {
    local url="$1"
    local platform
    lm_banner
    echo -e "${C_DARK_BLUE}╔══════════════════════════════════════════════╗"
    echo -e "║             $TXT_AUTO_MENU_TITLE             ║"
    echo -e "╚══════════════════════════════════════════════╝${C_RESET}\n"
    if [ -z "$url" ]; then
        local clip_url
        if clip_url="$(lm_get_clipboard_url)"; then
            echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_CLIPBOARD_FOUND: $clip_url"
            echo -ne "${C_PROMPT}$TXT_USE_CLIPBOARD${C_RESET} "
            read -r use_clip
            case "$use_clip" in
                h|H|y|Y|e|E|yes|YES|Yes) url="$clip_url" ;;
                *) echo -ne "${C_PROMPT}$TXT_PROMPT_LINK:${C_RESET} "; read -r url ;;
            esac
        else
            echo -ne "${C_PROMPT}$TXT_PROMPT_LINK:${C_RESET} "
            read -r url
        fi
    fi
    platform="$(lm_detect_platform "$url")"
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
                        case "$up_confirm" in
                            h|H|y|Y|e|E|yes|YES|Yes) lm_do_update ;;
                            *) echo -e "${C_DARK_ORANGE}[LM]${C_RESET} $TXT_MENU_OPTION_BACK" ;;
                        esac
                        ;;
                    2)
                        echo -e "\n${C_DARK_GREEN}[LM]${C_RESET} $TXT_ALREADY_LATEST"
                        ;;
                    *)
                        echo -e "\n${C_ERROR}[LM]${C_RESET} $TXT_UPDATE_FAILED"
                        ;;
                esac
                echo -e "\n${C_PROMPT}$TXT_PROMPT_CONTINUE...${C_RESET}"
                read -r
                ;;
            2)
                echo -e "\n${C_DARK_GREEN}[LM]${C_RESET} $TXT_OPTIMIZE_DONE"
                rm -rf "$LM_DIR/cache" 2>/dev/null
                pip cache purge >/dev/null 2>&1
                echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_CACHE_CLEARED"
                echo -e "\n${C_PROMPT}$TXT_PROMPT_CONTINUE...${C_RESET}"
                read -r
                ;;
            3)
                lm_show_system_info
                ;;
            4)
                lm_view_log
                ;;
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
            0)
                lm_banner
                echo -e "${C_DARK_GREEN}[LM]${C_RESET} $TXT_EXIT_MESSAGE\n"
                exit 0
                ;;
            *) echo -e "${C_ERROR}[LM]${C_RESET} $TXT_ERROR_INVALID_CHOICE"; sleep 2 ;;
        esac
    done
}

lm_install() {
    mkdir -p "$LM_DIR"
    lm_banner
    echo -e "${C_DARK_BLUE}$TXT_INSTALLER_TITLE${C_RESET}"
    echo -e "${C_DARK_ORANGE}$TXT_INSTALL_PREP${C_RESET}"
    sleep 1
    echo -e "\n${C_DARK_GREEN}[LM]${C_RESET} $TXT_INSTALL_STORAGE..."
    termux-setup-storage
    sleep 1
    lm_run_step "$TXT_STEP_UPDATE_PKGS" pkg update -y
    lm_run_step "$TXT_STEP_INSTALL_PYTHON" pkg install python -y
    lm_run_step "$TXT_STEP_INSTALL_FFMPEG" pkg install ffmpeg -y
    lm_run_step "$TXT_STEP_INSTALL_GIT" pkg install git -y
    lm_run_step "$TXT_STEP_UPDATE_YTDLP" python -m pip install -U yt-dlp
    lm_run_step "$TXT_STEP_UPDATE_INSTALOADER" python -m pip install -U instaloader
    lm_run_step "$TXT_STEP_UPDATE_GDL" python -m pip install -U gallery-dl
    lm_run_step "$TXT_STEP_CREATE_DIRS" lm_create_folders
    lm_run_step "$TXT_STEP_SETUP_URL_OPENER" lm_setup_url_opener
    lm_choose_language
    cp "$SOURCE_PATH" "$LM_BIN"
    chmod +x "$LM_BIN"
    if [ -f "$LM_LANG_SOURCE" ]; then
        cp "$LM_LANG_SOURCE" "$LM_DIR/lm_lang.sh"
    fi
    lm_banner
    echo -e "${C_DARK_GREEN}╔══════════════════════════════════════╗${C_RESET}"
    echo -e "${C_DARK_GREEN}║      $TXT_INSTALL_SUCCESS_LINE1      ║${C_RESET}"
    echo -e "${C_DARK_GREEN}╚══════════════════════════════════════╝${C_RESET}\n"
    echo -e "${C_DARK_BLUE}$TXT_INSTALL_SUCCESS_LINE2${C_RESET}"
    echo -e "${C_DARK_BLUE}$TXT_INSTALL_SUCCESS_LINE3${C_RESET}\n"
    sleep 3
}

lm_main() {
    lm_load_config
    lm_set_lang_vars
    if [ "$installed" != "true" ] || [ "$version" != "$LM_VERSION" ]; then
        lm_install
    fi
    if [ $# -eq 0 ]; then
        lm_startup_animation
        if lm_check_update; then
            echo -e "\n${C_DARK_GREEN}[LM]${C_RESET} $TXT_UPDATE_AVAILABLE ($LM_REMOTE_VERSION)"
            echo -ne "${C_DARK_GREEN}$TXT_UPDATE_PROMPT${C_RESET} "
            read -r up_confirm
            case "$up_confirm" in
                h|H|y|Y|e|E|yes|YES|Yes) lm_do_update ;;
            esac
        else
            status=$?
            if [ "$status" -eq 1 ]; then
                echo -e "\n${C_ERROR}[LM]${C_RESET} Üzr istəyirik, yeniləmə yoxlanarkən xəta baş verdi (internet yoxdur?)"
                sleep 2
            fi
        fi
        lm_main_menu
    else
        lm_startup_animation
        lm_auto_download "$1"
    fi
}

lm_main "$@"

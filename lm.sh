#!/data/data/com.termux/files/usr/bin/bash
set +e
trap 'lm_auto_recover' ERR

LM_VERSION="lamvavNE-v3.2.2.0"
LM_VERSION_CODE=322020260722
LM_DIR="$HOME/.raiclm"
LM_CONFIG="$LM_DIR/lm.conf"
LM_BIN="/data/data/com.termux/files/usr/bin/lm"
LM_OPENER="$HOME/bin/termux-url-opener"
LM_DOWNLOAD_BASE="/storage/emulated/0/lamvavNE/downloads"
LM_REPO_RAW="https://raw.githubusercontent.com/rzayevaga/raicx-downloader/raicX/lm.sh"
LM_LANG_RAW="https://raw.githubusercontent.com/rzayevaga/raicx-downloader/raicX/lm-lang.sh"
LM_TIKTOK_PHOTO_DL_RAW="https://raw.githubusercontent.com/rzayevaga/raicx-downloader/raicX/ttpdl.py"
LM_LANG="AZ"
LM_REMOTE_VERSION=""
LM_REMOTE_VERSION_CODE=0
LM_MAX_PARALLEL=12
LM_SPEED_LIMIT="unlimited"

C_RESET='\033[0m'
C_BG_BLACK='\033[40m'
C_RGB1='\033[38;2;255;100;100m'
C_RGB2='\033[38;2;100;255;100m'
C_RGB3='\033[38;2;100;100;255m'
C_RGB4='\033[38;2;255;215;0m'
C_RGB5='\033[38;2;255;105;180m'
C_BOLD='\033[1m'
C_DIM='\033[2m'
C_ITALIC='\033[3m'
C_UNDERLINE='\033[4m'

SOURCE_PATH="${BASH_SOURCE[0]:-$0}"
SCRIPT_DIR="$(cd "$(dirname "$SOURCE_PATH")" && pwd)"
LM_LANG_SOURCE="$LM_DIR/lm-lang.sh"
if [ -f "$SCRIPT_DIR/lm-lang.sh" ]; then
    LM_LANG_SOURCE="$SCRIPT_DIR/lm-lang.sh"
fi

if [ -f "$LM_LANG_SOURCE" ]; then
    . "$LM_LANG_SOURCE"
else
    echo "ERROR: Language file not found"
    exit 1
fi

declare -A LM_ACTIVE_JOBS
LM_JOB_COUNT=0

lm_auto_recover() {
    lm_show_cursor
    echo -e "${C_RGB1}[NEURAL AUTO-HEAL] Xəta ləğv edildi, sistem bərpa olunur...${C_RESET}"
    sleep 0.2
    return 0
}

lm_background_auto_update() {
    (
        python -m pip install -U yt-dlp instaloader gallery-dl requests tqdm cryptography >/dev/null 2>&1
        python "$LM_DIR/cookies_manager.py" clean >/dev/null 2>&1
    ) &
}

lm_hide_cursor() { printf "\e[?25l"; }
lm_show_cursor() { printf "\e[?25h"; }

lm_toast() {
    local msg="$1"
    if command -v termux-toast >/dev/null 2>&1; then
        termux-toast "$msg"
    fi
    echo -e "${C_RGB4}➤${C_RESET} ${C_DIM}$msg${C_RESET}"
}

lm_get_clipboard_url() {
    local url
    if command -v termux-clipboard-get >/dev/null 2>&1; then
        url=$(termux-clipboard-get 2>/dev/null)
        if [[ "$url" =~ ^https?:// ]]; then
            echo "$url"
            return 0
        fi
    fi
    return 1
}

lm_animate_border_fast() {
    local text="$1"
    local -a frames=("▓" "▒" "░" "█")
    for i in {1..1}; do
        for frame in "${frames[@]}"; do
            printf "\r${C_RGB4}%s${C_RESET} ${C_BOLD}${C_RGB3}%s${C_RESET} ${C_RGB4}%s${C_RESET}" "$frame" "$text" "$frame"
            sleep 0.015
        done
    done
    echo
}

lm_spin_fast() {
    local pid=$1
    local msg="$2"
    local -a spin=('⣾' '⣽' '⣻' '⢿' '⡿' '⣟' '⣯' '⣷')
    local i=0
    lm_hide_cursor
    while kill -0 "$pid" 2>/dev/null; do
        i=$(( (i+1) % ${#spin[@]} ))
        printf "\r${C_RGB2}[lamvavNE] ${spin[$i]} %s${C_RESET}" "$msg"
        sleep 0.04
    done
    wait "$pid" 2>/dev/null
    local status=$?
    lm_show_cursor
    if [ "$status" -eq 0 ]; then
        printf "\r${C_RGB2}[lamvavNE] ✓ %s                    ${C_RESET}\n" "$msg"
    else
        printf "\r${C_RGB1}[lamvavNE] ✗ %s                    ${C_RESET}\n" "$msg"
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
    local dirs=(
        "$LM_DOWNLOAD_BASE/Instagram/Video" "$LM_DOWNLOAD_BASE/Instagram/Music"
        "$LM_DOWNLOAD_BASE/TikTok/Video" "$LM_DOWNLOAD_BASE/TikTok/Music"
        "$LM_DOWNLOAD_BASE/YouTube/Video" "$LM_DOWNLOAD_BASE/YouTube/Music"
        "$LM_DOWNLOAD_BASE/YouTube/Playlist/Video" "$LM_DOWNLOAD_BASE/YouTube/Playlist/Music"
        "$LM_DOWNLOAD_BASE/Twitter/Video" "$LM_DOWNLOAD_BASE/Twitter/Music"
        "$LM_DOWNLOAD_BASE/Facebook/Video" "$LM_DOWNLOAD_BASE/Facebook/Music"
        "$LM_DOWNLOAD_BASE/SoundCloud/Music"
        "$LM_DOWNLOAD_BASE/YouTube/Channel/Video" "$LM_DOWNLOAD_BASE/YouTube/Channel/Music"
    )
    for d in "${dirs[@]}"; do mkdir -p "$d" 2>/dev/null; done
}

lm_save_config() {
    mkdir -p "$LM_DIR"
    {
        echo "installed=true"
        echo "version='$LM_VERSION'"
        echo "version_code=$LM_VERSION_CODE"
        echo "download_path='$LM_DOWNLOAD_BASE'"
        echo "lang='$LM_LANG'"
        echo "max_parallel='$LM_MAX_PARALLEL'"
        echo "speed_limit='$LM_SPEED_LIMIT'"
    } > "$LM_CONFIG"
}

lm_load_config() {
    if [ -f "$LM_CONFIG" ]; then
        . "$LM_CONFIG"
        [[ -n "${download_path:-}" ]] && LM_DOWNLOAD_BASE="$download_path"
        [[ -n "${lang:-}" ]] && LM_LANG="$lang"
        [[ -n "${max_parallel:-}" ]] && LM_MAX_PARALLEL="$max_parallel"
        [[ -n "${speed_limit:-}" ]] && LM_SPEED_LIMIT="$speed_limit"
    fi
}

lm_choose_language() {
    while true; do
        echo -e "\n${C_RGB3}$TXT_LANG_MENU_TITLE${C_RESET}"
        echo -e "${C_RGB2}$TXT_LANG_MENU_DESC${C_RESET}\n"
        echo -e "${C_RGB4}[1]${C_RESET} $TXT_LANG_AZ"
        echo -e "${C_RGB4}[2]${C_RESET} $TXT_LANG_TR"
        echo -e "${C_RGB4}[3]${C_RESET} $TXT_LANG_EN"
        echo -e "${C_RGB4}[4]${C_RESET} $TXT_LANG_RU\n"
        echo -ne "${C_RGB2}$TXT_PROMPT_CHOICE:${C_RESET} "
        read -r lang_choice
        case "$lang_choice" in
            1) LM_LANG="AZ"; break ;;
            2) LM_LANG="TR"; break ;;
            3) LM_LANG="EN"; break ;;
            4) LM_LANG="RU"; break ;;
            *) lm_toast "$TXT_ERROR_INVALID_CHOICE" ;;
        esac
    done
    lm_set_lang_vars
    lm_save_config
    lm_toast "$TXT_LANG_CHANGED"
    sleep 0.5
}

lm_detect_platform() {
    local url_lower
    url_lower="$(echo "${1:-}" | tr '[:upper:]' '[:lower:]')"
    if [[ $url_lower == *"instagram.com"* ]] || [[ $url_lower == *"instagr.am"* ]]; then echo "instagram"
    elif [[ $url_lower == *"tiktok.com"* ]] || [[ $url_lower == *"vm.tiktok.com"* ]] || [[ $url_lower == *"vt.tiktok.com"* ]] || [[ $url_lower == *"m.tiktok.com"* ]]; then echo "tiktok"
    elif [[ $url_lower == *"youtube.com/playlist"* ]] || { [[ $url_lower == *"list="* ]] && { [[ $url_lower == *"youtube.com"* ]] || [[ $url_lower == *"youtu.be"* ]]; }; }; then echo "youtube_playlist"
    elif [[ $url_lower == *"youtube.com/@"* ]] || [[ $url_lower == *"youtube.com/channel/"* ]] || [[ $url_lower == *"youtube.com/c/"* ]]; then echo "youtube_channel"
    elif [[ $url_lower == *"youtube.com"* ]] || [[ $url_lower == *"youtu.be"* ]]; then echo "youtube"
    elif [[ $url_lower == *"twitter.com"* ]] || [[ $url_lower == *"x.com"* ]]; then echo "twitter"
    elif [[ $url_lower == *"facebook.com"* ]] || [[ $url_lower == *"fb.com"* ]] || [[ $url_lower == *"fb.watch"* ]]; then echo "facebook"
    elif [[ $url_lower == *"soundcloud.com"* ]]; then echo "soundcloud"
    else echo "unknown"; fi
}

lm_detect_content_type() {
    local url="$1"
    local resp
    resp=$(curl -fsSL --connect-timeout 3 "https://tikwm.com/api/?url=$url" 2>/dev/null)
    if [ -z "$resp" ]; then
        echo "unknown"
        return 1
    fi
    local has_images
    has_images=$(echo "$resp" | jq -r '.data.images // empty' 2>/dev/null)
    if [ -n "$has_images" ]; then
        echo "slideshow"
    else
        echo "video"
    fi
}

lm_check_update() {
    LM_REMOTE_VERSION=""
    LM_REMOTE_VERSION_CODE=0
    local remote_line
    remote_line="$(curl -fsSL --connect-timeout 3 "$LM_REPO_RAW" 2>/dev/null | grep -m1 '^LM_VERSION_CODE=')"
    [[ -z "$remote_line" ]] && return 1
    LM_REMOTE_VERSION_CODE="${remote_line#LM_VERSION_CODE=}"
    LM_REMOTE_VERSION_CODE="${LM_REMOTE_VERSION_CODE%\"}"
    LM_REMOTE_VERSION_CODE="${LM_REMOTE_VERSION_CODE#\"}"
    if [ "$LM_REMOTE_VERSION_CODE" -gt "$LM_VERSION_CODE" ]; then
        remote_line="$(curl -fsSL --connect-timeout 3 "$LM_REPO_RAW" 2>/dev/null | grep -m1 '^LM_VERSION=')"
        LM_REMOTE_VERSION="${remote_line#LM_VERSION=}"
        LM_REMOTE_VERSION="${LM_REMOTE_VERSION%\"}"
        LM_REMOTE_VERSION="${LM_REMOTE_VERSION#\"}"
        return 0
    fi
    return 2
}

lm_do_update() {
    echo -e "\n${C_RGB2}[lamvavNE]${C_RESET} $TXT_UPDATING"
    local tmp_bin="$LM_BIN.tmp" tmp_lang="$LM_DIR/lm-lang.sh.tmp"
    if curl -fsSL --connect-timeout 5 "$LM_REPO_RAW" -o "$tmp_bin" && curl -fsSL --connect-timeout 5 "$LM_LANG_RAW" -o "$tmp_lang"; then
        chmod +x "$tmp_bin"
        rm -f "$LM_BIN" "$LM_DIR/lm-lang.sh"
        mv "$tmp_bin" "$LM_BIN"
        mv "$tmp_lang" "$LM_DIR/lm-lang.sh"
        curl -fsSL --connect-timeout 5 "$LM_TIKTOK_PHOTO_DL_RAW" -o "$LM_DIR/ttpdl.py"
        chmod +x "$LM_DIR/ttpdl.py"
        echo -e "${C_RGB2}[lamvavNE]${C_RESET} $TXT_UPDATE_SUCCESS"
        exit 0
    else
        echo -e "${C_RGB1}[lamvavNE]${C_RESET} $TXT_UPDATE_FAILED"
        rm -f "$tmp_bin" "$tmp_lang"
        return 1
    fi
}

lm_startup_animation_fast() {
    lm_hide_cursor
    clear
    echo -ne "\n${C_BOLD}"
    for i in {1..30}; do
        printf "${C_RGB4}✦${C_RESET}"
        sleep 0.003
    done
    echo
    lm_animate_border_fast "lamvavNE [Media Downloader]"
    sleep 0.05
    lm_show_cursor
}

lm_banner() {
    clear
    local border=$(printf '═%.0s' {1..52})
    echo -e "${C_RGB4}╔${border}╗${C_RESET}"
    echo -e "${C_RGB4}║${C_RESET}  ${C_BOLD}${C_RGB5}◢◤ lamvavNE [Media Downloader] ◥◣${C_RESET}  ${C_RGB4}║${C_RESET}"
    echo -e "${C_RGB4}║${C_RESET}  ${C_DIM}${C_RGB2}⚡ Mega Ultra Max ++ 2026 Engine ⚡${C_RESET}  ${C_RGB4}║${C_RESET}"
    echo -e "${C_RGB4}║${C_RESET}  ${C_RGB3}Version: $LM_VERSION | Crypto Active${C_RESET}  ${C_RGB4}║${C_RESET}"
    echo -e "${C_RGB4}╚${border}╝${C_RESET}"
    echo
}

lm_run_step_fast() {
    local message="$1"
    shift
    echo -e "${C_RGB2}[lamvavNE]${C_RESET} $message..."
    "$@" &
    local pid=$!
    lm_spin_fast "$pid" "$message"
    return $?
}

lm_validate_url() {
    local url="$1"
    [[ -z "$url" ]] && { echo "$TXT_ERROR_EMPTY_URL"; return 1; }
    [[ ! "$url" =~ ^https?:// ]] && { echo "$TXT_ERROR_INVALID_URL"; return 1; }
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
    [[ ! -w "$output_dir" ]] && return 1
    return 0
}

lm_get_speed_limit_opt() {
    case "$LM_SPEED_LIMIT" in
        "1M") echo "--limit-rate 1M" ;;
        "2M") echo "--limit-rate 2M" ;;
        "3M") echo "--limit-rate 3M" ;;
        "4M") echo "--limit-rate 4M" ;;
        "5M") echo "--limit-rate 5M" ;;
        "10M") echo "--limit-rate 10M" ;;
        "20M") echo "--limit-rate 20M" ;;
        "50M") echo "--limit-rate 50M" ;;
        "100M") echo "--limit-rate 100M" ;;
        *) echo "" ;;
    esac
}

lm_select_video_quality() {
    while true; do
        echo -e "\n${C_RGB3}$TXT_QUALITY_PROMPT${C_RESET}"
        echo -e "${C_RGB4}[1]${C_RESET} ${TXT_QUALITY_144P}"
        echo -e "${C_RGB4}[2]${C_RESET} ${TXT_QUALITY_240P}"
        echo -e "${C_RGB4}[3]${C_RESET} ${TXT_QUALITY_360P}"
        echo -e "${C_RGB4}[4]${C_RESET} ${TXT_QUALITY_480P}"
        echo -e "${C_RGB4}[5]${C_RESET} ${TXT_QUALITY_720P}"
        echo -e "${C_RGB4}[6]${C_RESET} ${TXT_QUALITY_1080P}"
        echo -ne "${C_RGB2}$TXT_PROMPT_CHOICE:${C_RESET} "
        read -r qchoice
        case "$qchoice" in
            1) echo "best[height<=144]"; return 0 ;;
            2) echo "best[height<=240]"; return 0 ;;
            3) echo "best[height<=360]"; return 0 ;;
            4) echo "best[height<=480]"; return 0 ;;
            5) echo "best[height<=720]"; return 0 ;;
            6) echo "best[height<=1080]"; return 0 ;;
            *) lm_toast "$TXT_ERROR_INVALID_CHOICE" ;;
        esac
    done
}

lm_select_audio_quality() {
    while true; do
        echo -e "\n${C_RGB3}$TXT_AUDIO_PROMPT${C_RESET}"
        echo -e "${C_RGB4}[1]${C_RESET} ${TXT_AUDIO_M4A_128K}"
        echo -e "${C_RGB4}[2]${C_RESET} ${TXT_AUDIO_MP3_70K}"
        echo -e "${C_RGB4}[3]${C_RESET} ${TXT_AUDIO_MP3_128K}"
        echo -e "${C_RGB4}[4]${C_RESET} ${TXT_AUDIO_MP3_160K}"
        echo -e "${C_RGB4}[5]${C_RESET} ${TXT_AUDIO_MP3_320K}"
        echo -ne "${C_RGB2}$TXT_PROMPT_CHOICE:${C_RESET} "
        read -r achoice
        case "$achoice" in
            1) echo "m4a"; return 0 ;;
            2) echo "mp3:70"; return 0 ;;
            3) echo "mp3:128"; return 0 ;;
            4) echo "mp3:160"; return 0 ;;
            5) echo "mp3:320"; return 0 ;;
            *) lm_toast "$TXT_ERROR_INVALID_CHOICE" ;;
        esac
    done
}

lm_download_with_quality_fallback() {
    local format_opt="$1"
    shift
    local -a cmd=("$@")
    if [[ "$format_opt" == best\[height\<=* ]]; then
        "${cmd[@]}"
        local ret=$?
        if [ $ret -ne 0 ]; then
            echo -e "${C_RGB2}[lamvavNE]${C_RESET} Neyron bərpa: Ən optimal format seçilir..."
            local fallback_cmd=("${cmd[@]:0:${#cmd[@]}-2}" "-f" "best" "${cmd[@]:${#cmd[@]}-1}")
            "${fallback_cmd[@]}"
            ret=$?
        fi
        return $ret
    else
        "${cmd[@]}"
        return $?
    fi
}

lm_download_common() {
    local platform="$1" mode="$2" url="$3"
    local quality_format="" audio_quality="" output_dir template format opts_str
    local -a opts=()

    if [ "$mode" = "video_quality" ]; then
        quality_format="$(lm_select_video_quality)"
        mode="video"
    elif [ "$mode" = "audio_quality" ]; then
        audio_quality="$(lm_select_audio_quality)"
        mode="audio"
    fi

    local speed_opt=$(lm_get_speed_limit_opt)

    python "$LM_DIR/cookies_manager.py" decrypt >/dev/null 2>&1
    local cookie_opt=""
    if [ -f "$LM_DIR/cookies.txt" ]; then
        cookie_opt="--cookies $LM_DIR/cookies.txt"
    fi

    case "${platform}:${mode}" in
        instagram:video) output_dir="$LM_DOWNLOAD_BASE/Instagram/Video"; template="$output_dir/%(title)s.%(ext)s"; format="best"; opts=(--merge-output-format mp4 --concurrent-fragments 8); lm_toast "$TXT_DOWNLOAD_STARTED_INSTAGRAM_VIDEO" ;;
        instagram:audio) output_dir="$LM_DOWNLOAD_BASE/Instagram/Music"; template="$output_dir/%(title)s.%(ext)s"; format="bestaudio"; opts=(--extract-audio --audio-format mp3 --audio-quality 0 --no-write-info-json); lm_toast "$TXT_DOWNLOAD_STARTED_INSTAGRAM_AUDIO" ;;
        tiktok:video) output_dir="$LM_DOWNLOAD_BASE/TikTok/Video"; template="$output_dir/%(title)s.%(ext)s"; format="best"; opts=(--merge-output-format mp4 --concurrent-fragments 8 --no-write-info-json); lm_toast "$TXT_DOWNLOAD_STARTED_TIKTOK_VIDEO" ;;
        tiktok:audio) output_dir="$LM_DOWNLOAD_BASE/TikTok/Music"; template="$output_dir/%(title)s.%(ext)s"; format="bestaudio"; opts=(--extract-audio --audio-format mp3 --audio-quality 0 --no-write-info-json); lm_toast "$TXT_DOWNLOAD_STARTED_TIKTOK_AUDIO" ;;
        youtube:video)
            output_dir="$LM_DOWNLOAD_BASE/YouTube/Video"; template="$output_dir/%(title)s.%(ext)s"
            if [ -n "$quality_format" ]; then format="$quality_format"; else format="best"; fi
            opts=(--merge-output-format mp4 --concurrent-fragments 8 --no-write-info-json)
            lm_toast "$TXT_DOWNLOAD_STARTED_YT_VIDEO" ;;
        youtube:audio)
            output_dir="$LM_DOWNLOAD_BASE/YouTube/Music"; template="$output_dir/%(title)s.%(ext)s"
            format="bestaudio"
            opts=(--extract-audio --no-write-info-json --embed-thumbnail --embed-metadata)
            if [ "$audio_quality" = "m4a" ]; then
                opts+=(--audio-format m4a --audio-quality 0)
            elif [[ "$audio_quality" =~ ^mp3:([0-9]+)$ ]]; then
                local br="${BASH_REMATCH[1]}"
                opts+=(--audio-format mp3 --audio-quality 0)
                opts+=(--postprocessor-args "ffmpeg:-b:a ${br}k")
            else
                opts+=(--audio-format mp3 --audio-quality 0)
            fi
            lm_toast "$TXT_DOWNLOAD_STARTED_YT_AUDIO" ;;
        youtube_playlist:video)
            output_dir="$LM_DOWNLOAD_BASE/YouTube/Playlist/Video"; template="$output_dir/%(playlist_title)s - %(playlist_index)s - %(title)s.%(ext)s"
            if [ -n "$quality_format" ]; then format="$quality_format"; else format="best"; fi
            opts=(--yes-playlist --merge-output-format mp4 --concurrent-fragments 8 --no-write-info-json)
            lm_toast "$TXT_DOWNLOAD_STARTED_YTPL_VIDEO" ;;
        youtube_playlist:audio)
            output_dir="$LM_DOWNLOAD_BASE/YouTube/Playlist/Music"; template="$output_dir/%(playlist_title)s - %(playlist_index)s - %(title)s.%(ext)s"
            format="bestaudio"
            opts=(--yes-playlist --extract-audio --no-write-info-json --embed-thumbnail --embed-metadata)
            if [ "$audio_quality" = "m4a" ]; then
                opts+=(--audio-format m4a --audio-quality 0)
            elif [[ "$audio_quality" =~ ^mp3:([0-9]+)$ ]]; then
                local br="${BASH_REMATCH[1]}"
                opts+=(--audio-format mp3 --audio-quality 0)
                opts+=(--postprocessor-args "ffmpeg:-b:a ${br}k")
            else
                opts+=(--audio-format mp3 --audio-quality 0)
            fi
            lm_toast "$TXT_DOWNLOAD_STARTED_YTPL_AUDIO" ;;
        youtube_channel:video)
            output_dir="$LM_DOWNLOAD_BASE/YouTube/Channel/Video"; template="$output_dir/%(uploader)s - %(title)s.%(ext)s"
            if [ -n "$quality_format" ]; then format="$quality_format"; else format="best"; fi
            opts=(--merge-output-format mp4 --concurrent-fragments 8 --no-write-info-json)
            lm_toast "$TXT_DOWNLOAD_STARTED_YT_CHANNEL_VIDEO" ;;
        youtube_channel:audio)
            output_dir="$LM_DOWNLOAD_BASE/YouTube/Channel/Music"; template="$output_dir/%(uploader)s - %(title)s.%(ext)s"
            format="bestaudio"
            opts=(--extract-audio --no-write-info-json --embed-thumbnail --embed-metadata)
            if [ "$audio_quality" = "m4a" ]; then
                opts+=(--audio-format m4a --audio-quality 0)
            elif [[ "$audio_quality" =~ ^mp3:([0-9]+)$ ]]; then
                local br="${BASH_REMATCH[1]}"
                opts+=(--audio-format mp3 --audio-quality 0)
                opts+=(--postprocessor-args "ffmpeg:-b:a ${br}k")
            else
                opts+=(--audio-format mp3 --audio-quality 0)
            fi
            lm_toast "$TXT_DOWNLOAD_STARTED_YT_CHANNEL_AUDIO" ;;
        twitter:video) output_dir="$LM_DOWNLOAD_BASE/Twitter/Video"; template="$output_dir/%(title)s.%(ext)s"; format="best"; opts=(--merge-output-format mp4 --concurrent-fragments 8 --no-write-info-json); lm_toast "$TXT_DOWNLOAD_STARTED_TWITTER_VIDEO" ;;
        twitter:audio) output_dir="$LM_DOWNLOAD_BASE/Twitter/Music"; template="$output_dir/%(title)s.%(ext)s"; format="bestaudio"; opts=(--extract-audio --audio-format mp3 --audio-quality 0 --no-write-info-json); lm_toast "$TXT_DOWNLOAD_STARTED_TWITTER_AUDIO" ;;
        facebook:video) output_dir="$LM_DOWNLOAD_BASE/Facebook/Video"; template="$output_dir/%(title)s.%(ext)s"; format="best"; opts=(--merge-output-format mp4 --concurrent-fragments 8 --no-write-info-json); lm_toast "$TXT_DOWNLOAD_STARTED_FACEBOOK_VIDEO" ;;
        facebook:audio) output_dir="$LM_DOWNLOAD_BASE/Facebook/Music"; template="$output_dir/%(title)s.%(ext)s"; format="bestaudio"; opts=(--extract-audio --audio-format mp3 --audio-quality 0 --no-write-info-json); lm_toast "$TXT_DOWNLOAD_STARTED_FACEBOOK_AUDIO" ;;
        soundcloud:audio) output_dir="$LM_DOWNLOAD_BASE/SoundCloud/Music"; template="$output_dir/%(title)s.%(ext)s"; format="bestaudio"; opts=(--extract-audio --audio-format mp3 --audio-quality 0 --embed-thumbnail --embed-metadata --no-write-info-json); lm_toast "$TXT_DOWNLOAD_STARTED_SOUNDCLOUD_AUDIO" ;;
        *) echo -e "${C_RGB1}[lamvavNE]${C_RESET} $TXT_PLATFORM_UNKNOWN"; echo -e "${C_RGB4}$TXT_SUPPORTED_PLATFORMS${C_RESET}"; return 1 ;;
    esac

    local validation_error
    if ! validation_error="$(lm_validate_url "$url")"; then echo -e "\n${C_RGB1}[lamvavNE]${C_RESET} $validation_error\n"; return 1; fi
    if ! command_error="$(lm_require_command yt-dlp)"; then echo -e "\n${C_RGB1}[lamvavNE]${C_RESET} $command_error\n"; return 127; fi
    if ! lm_prepare_output_dir "$output_dir"; then echo -e "\n${C_RGB1}[lamvavNE]${C_RESET} $TXT_ERROR_OUTPUT_DIR: $output_dir\n"; return 1; fi

    local -a base_cmd=(yt-dlp ${cookie_opt} --no-write-info-json --no-overwrites -f "$format" ${opts[@]} ${speed_opt} -o "$template" "$url")
    local ret=0
    if [[ "$format" =~ ^best\[height\<=[0-9]+\] ]]; then
        lm_download_with_quality_fallback "$format" "${base_cmd[@]}"
        ret=$?
    else
        "${base_cmd[@]}"
        ret=$?
    fi

    python "$LM_DIR/cookies_manager.py" clean >/dev/null 2>&1

    if [ "$ret" -eq 0 ]; then
        echo -e "\n${C_RGB2}[lamvavNE]${C_RESET} $TXT_DOWNLOAD_DONE_PREFIX: $output_dir\n"
        lm_toast "$TXT_DOWNLOAD_DONE_PREFIX"
    else
        echo -e "\n${C_RGB1}[lamvavNE]${C_RESET} $TXT_DOWNLOAD_FAILED\n"
    fi
    return "$ret"
}

lm_download_for_platform() {
    local platform="$1" url="$2" kind="$3"
    if [ "$platform" = "unknown" ]; then echo -e "${C_RGB1}[lamvavNE]${C_RESET} $TXT_PLATFORM_UNKNOWN"; echo -e "${C_RGB4}$TXT_SUPPORTED_PLATFORMS${C_RESET}"; return 1; fi
    if [ "$platform" = "youtube_playlist" ] && [ "$kind" != "video" ] && [ "$kind" != "audio" ]; then kind="video"; fi
    lm_download_common "$platform" "$kind" "$url"
}

lm_download_tiktok_slideshow() {
    local url="$1" output_base="${2:-$LM_DOWNLOAD_BASE/TikTok}"
    local choice
    while true; do
        echo -e "\n${C_RGB3}${TXT_SLIDESHOW_TITLE}${C_RESET}"
        echo -e "${C_RGB4}[1]${C_RESET} ${TXT_SLIDESHOW_OPT_1}"
        echo -e "${C_RGB4}[2]${C_RESET} ${TXT_SLIDESHOW_OPT_2}"
        echo -e "${C_RGB4}[3]${C_RESET} ${TXT_SLIDESHOW_OPT_3}"
        echo -e "${C_RGB4}[4]${C_RESET} ${TXT_SLIDESHOW_OPT_4}"
        echo -e "${C_RGB4}[5]${C_RESET} ${TXT_SLIDESHOW_OPT_5}"
        echo -ne "${C_RGB2}$TXT_PROMPT_CHOICE:${C_RESET} "
        read -r choice
        case "$choice" in
            1|2|3|4|5) break ;;
            *) lm_toast "$TXT_ERROR_INVALID_CHOICE" ;;
        esac
    done
    lm_toast "Yükləmə başlayır..."
    python "$LM_DIR/ttpdl.py" "$url" "$choice" "$output_base"
    echo -e "\n${C_RGB2}$TXT_PROMPT_CONTINUE...${C_RESET}"
    read -r
}

lm_download_with_prompt() {
    local platform="$1" url="$2"
    case "$platform" in
        instagram) lm_toast "$TXT_AUTO_PLATFORM_INSTAGRAM" ;;
        tiktok)
            local content_type
            content_type=$(lm_detect_content_type "$url")
            if [ "$content_type" = "slideshow" ]; then
                lm_download_tiktok_slideshow "$url"
                return
            else
                lm_toast "$TXT_AUTO_PLATFORM_TIKTOK"
                while true; do
                    echo -e "${C_RGB4}[1]${C_RESET} $TXT_OPTION_VIDEO_DOWNLOAD"
                    echo -e "${C_RGB4}[2]${C_RESET} $TXT_OPTION_AUDIO_DOWNLOAD"
                    echo -ne "\n${C_RGB2}$TXT_PROMPT_CHOICE:${C_RESET} "
                    read -r tiktok_choice
                    case "$tiktok_choice" in
                        1) lm_download_for_platform "$platform" "$url" "video"; return ;;
                        2) lm_download_for_platform "$platform" "$url" "audio"; return ;;
                        *) lm_toast "$TXT_ERROR_INVALID_CHOICE" ;;
                    esac
                done
            fi
            return ;;
        youtube) lm_toast "$TXT_AUTO_PLATFORM_YT_SINGLE" ;;
        youtube_playlist) lm_toast "$TXT_AUTO_PLATFORM_YT_PLAYLIST" ;;
        youtube_channel) lm_toast "$TXT_AUTO_PLATFORM_YT_CHANNEL" ;;
        twitter) lm_toast "$TXT_AUTO_PLATFORM_TWITTER" ;;
        facebook) lm_toast "$TXT_AUTO_PLATFORM_FACEBOOK" ;;
        soundcloud) lm_toast "$TXT_AUTO_PLATFORM_SOUNDCLOUD" ;;
        *) echo -e "${C_RGB1}[lamvavNE]${C_RESET} $TXT_PLATFORM_UNKNOWN"; echo -e "${C_RGB4}$TXT_SUPPORTED_PLATFORMS${C_RESET}"; return 1 ;;
    esac

    while true; do
        if [ "$platform" = "youtube_playlist" ]; then
            echo -e "${C_RGB4}[1]${C_RESET} $TXT_OPTION_PLAYLIST_VIDEO"
            echo -e "${C_RGB4}[2]${C_RESET} $TXT_OPTION_PLAYLIST_AUDIO"
            echo -e "${C_RGB4}[3]${C_RESET} ${TXT_OPTION_QUALITY_SELECT}"
        elif [ "$platform" = "youtube" ]; then
            echo -e "${C_RGB4}[1]${C_RESET} $TXT_OPTION_VIDEO_DOWNLOAD"
            echo -e "${C_RGB4}[2]${C_RESET} $TXT_OPTION_AUDIO_DOWNLOAD"
            echo -e "${C_RGB4}[3]${C_RESET} ${TXT_OPTION_QUALITY_SELECT}"
        elif [ "$platform" = "youtube_channel" ]; then
            echo -e "${C_RGB4}[1]${C_RESET} $TXT_OPTION_CHANNEL_VIDEO"
            echo -e "${C_RGB4}[2]${C_RESET} $TXT_OPTION_CHANNEL_AUDIO"
            echo -e "${C_RGB4}[3]${C_RESET} ${TXT_OPTION_QUALITY_SELECT}"
        elif [ "$platform" = "soundcloud" ]; then
            echo -e "${C_RGB4}[1]${C_RESET} $TXT_OPTION_AUDIO_DOWNLOAD"
        else
            echo -e "${C_RGB4}[1]${C_RESET} $TXT_OPTION_VIDEO_DOWNLOAD"
            echo -e "${C_RGB4}[2]${C_RESET} $TXT_OPTION_AUDIO_DOWNLOAD"
        fi
        echo -ne "\n${C_RGB2}$TXT_PROMPT_CHOICE:${C_RESET} "
        read -r choice
        case "$choice" in
            1)
                if [ "$platform" = "soundcloud" ]; then
                    lm_download_for_platform "$platform" "$url" "audio"
                else
                    lm_download_for_platform "$platform" "$url" "video"
                fi
                return ;;
            2)
                if [ "$platform" = "soundcloud" ]; then
                    lm_toast "$TXT_ERROR_INVALID_CHOICE"
                else
                    lm_download_for_platform "$platform" "$url" "audio"
                fi
                return ;;
            3)
                if [ "$platform" = "youtube" ] || [ "$platform" = "youtube_playlist" ] || [ "$platform" = "youtube_channel" ]; then
                    while true; do
                        echo -e "\n${C_RGB3}${TXT_QUALITY_TYPE_SELECT}${C_RESET}"
                        echo -e "${C_RGB4}[1]${C_RESET} $TXT_OPTION_VIDEO_DOWNLOAD"
                        echo -e "${C_RGB4}[2]${C_RESET} $TXT_OPTION_AUDIO_DOWNLOAD"
                        echo -ne "${C_RGB2}$TXT_PROMPT_CHOICE:${C_RESET} "
                        read -r qtype
                        case "$qtype" in
                            1) lm_download_common "$platform" "video_quality" "$url"; return ;;
                            2) lm_download_common "$platform" "audio_quality" "$url"; return ;;
                            *) lm_toast "$TXT_ERROR_INVALID_CHOICE" ;;
                        esac
                    done
                else
                    lm_toast "$TXT_ERROR_INVALID_CHOICE"
                fi
                return ;;
            *) lm_toast "$TXT_ERROR_INVALID_CHOICE" ;;
        esac
    done
}

lm_cookies_menu() {
    while true; do
        lm_banner
        echo -e "${C_RGB3}╔══════════════════════════════════════════════╗"
        echo -e "║          $TXT_COOKIES_MENU_TITLE             ║"
        echo -e "╚══════════════════════════════════════════════╝${C_RESET}\n"
        echo -e "${C_RGB4}[1]${C_RESET} Manual cookies.txt Daxil Et (AES-256 Şifrələmə)"
        echo -e "${C_RGB4}[2]${C_RESET} Termux Browser Avto-Login və Sessiya Yoxlama"
        echo -e "${C_RGB4}[3]${C_RESET} Kriptoqrafik Açar İnteqrasiyasını Sıfırla"
        echo -e "${C_RGB1}[0]${C_RESET} $TXT_MENU_OPTION_BACK\n"
        echo -ne "${C_RGB2}$TXT_PROMPT_CHOICE:${C_RESET} "
        read -r cchoice
        case "$cchoice" in
            1) python "$LM_DIR/cookies_manager.py" manual; lm_toast "$TXT_COOKIE_SUCCESS"; sleep 1 ;;
            2) python "$LM_DIR/cookies_manager.py" browser; lm_toast "$TXT_COOKIE_SUCCESS"; sleep 1 ;;
            3) rm -f "$LM_DIR/.key" "$LM_DIR/cookies.enc"; lm_toast "Kriptoqrafiya yeniləndi"; sleep 1 ;;
            0) break ;;
            *) lm_toast "$TXT_ERROR_INVALID_CHOICE" ;;
        esac
    done
}

lm_active_sessions() {
    local pids
    pids=$(pgrep -f "lm .*https?://" 2>/dev/null)
    if [ -z "$pids" ]; then
        echo -e "${C_RGB4}[lamvavNE]${C_RESET} ${TXT_QUEUE_EMPTY}"
        return 1
    fi
    echo -e "\n${C_RGB3}─── ${TXT_QUEUE_TITLE} ───${C_RESET}\n"
    printf "${C_RGB4}%-8s %-12s %-20s %s${C_RESET}\n" "PID" "Platform" "Status" "URL"
    echo "----------------------------------------------------------------"
    for pid in $pids; do
        local cmdline
        cmdline=$(ps -p "$pid" -o args= 2>/dev/null)
        local url=$(echo "$cmdline" | grep -oE 'https?://[^ ]+' | head -1)
        local platform=$(lm_detect_platform "$url")
        local status="Yüklənir (Neural Stream)"
        echo -e "${C_RGB2}%-8s ${C_RGB5}%-12s ${C_RGB3}%-20s ${C_DIM}%s${C_RESET}" "$pid" "$platform" "$status" "$url"
    done
    echo
}

lm_active_menu() {
    while true; do
        lm_banner
        echo -e "${C_RGB3}╔══════════════════════════════════════════════╗"
        echo -e "║           ${TXT_ACTIVE_MENU_TITLE}           ║"
        echo -e "╚══════════════════════════════════════════════╝${C_RESET}\n"
        lm_active_sessions
        echo -e "${C_RGB1}[0]${C_RESET} $TXT_MENU_OPTION_BACK\n"
        echo -ne "${C_RGB2}$TXT_PROMPT_CHOICE:${C_RESET} "
        read -r achoice
        case "$achoice" in
            0) break ;;
            *) lm_toast "$TXT_ERROR_INVALID_CHOICE" ;;
        esac
    done
}

lm_search_menu() {
    while true; do
        lm_banner
        echo -e "${C_RGB3}╔══════════════════════════════════════════════╗"
        echo -e "║                  $TXT_SEARCH_TITLE                  ║"
        echo -e "╚══════════════════════════════════════════════╝${C_RESET}\n"
        echo -ne "${C_RGB2}$TXT_SEARCH_PROMPT:${C_RESET} "
        read -r query
        if [[ -z "$query" ]]; then
            lm_toast "$TXT_ERROR_INVALID_CHOICE"
            continue
        fi
        lm_toast "$TXT_SEARCHING"
        local search_output
        search_output=$(yt-dlp -j --flat-playlist "ytsearch20:$query" 2>/dev/null)
        if [[ -z "$search_output" ]]; then
            echo -e "\n${C_RGB1}[lamvavNE]${C_RESET} $TXT_SEARCH_NO_RESULTS"
            echo -ne "\n${C_RGB2}$TXT_SEARCH_AGAIN${C_RESET} "
            read -r again
            case "$again" in h|H|y|Y|e|E|yes|YES|Yes) continue ;; *) break ;; esac
        fi
        local i=1
        local -a titles=()
        local -a ids=()
        while IFS= read -r line; do
            if [[ -n "$line" ]]; then
                local title=$(echo "$line" | jq -r '.title' 2>/dev/null)
                local id=$(echo "$line" | jq -r '.id' 2>/dev/null)
                if [[ -n "$title" && -n "$id" ]]; then
                    titles+=("$title")
                    ids+=("$id")
                    echo -e "${C_RGB4}[$i]${C_RESET} $title"
                    ((i++))
                fi
            fi
        done <<< "$search_output"
        if [[ ${#titles[@]} -eq 0 ]]; then
            echo -e "\n${C_RGB1}[lamvavNE]${C_RESET} $TXT_SEARCH_NO_RESULTS"
            echo -ne "\n${C_RGB2}$TXT_SEARCH_AGAIN${C_RESET} "
            read -r again
            case "$again" in h|H|y|Y|e|E|yes|YES|Yes) continue ;; *) break ;; esac
        fi
        echo -ne "\n${C_RGB2}Seçim nömrəsi (1-${#titles[@]}) və ya 0 çıxış:${C_RESET} "
        read -r idx
        if [[ "$idx" =~ ^[0-9]+$ ]] && [ "$idx" -ge 1 ] && [ "$idx" -le "${#titles[@]}" ]; then
            local selected_id="${ids[$((idx-1))]}"
            local link="https://youtu.be/$selected_id"
            lm_toast "Yükləmə başlayır: $link"
            lm_download_with_prompt "youtube" "$link"
        elif [ "$idx" = "0" ]; then
            break
        else
            lm_toast "$TXT_ERROR_INVALID_CHOICE"
        fi
        echo -ne "\n${C_RGB2}$TXT_SEARCH_AGAIN${C_RESET} "
        read -r again
        case "$again" in h|H|y|Y|e|E|yes|YES|Yes) continue ;; *) break ;; esac
    done
}

lm_settings_menu() {
    while true; do
        lm_banner
        echo -e "${C_RGB3}╔══════════════════════════════════════════════╗"
        echo -e "║              $TXT_SETTINGS_MENU_TITLE              ║"
        echo -e "╚══════════════════════════════════════════════╝${C_RESET}\n"
        echo -e "${C_RGB4}[1]${C_RESET} $TXT_MENU_OPTION_LANGUAGE"
        echo -e "${C_RGB4}[2]${C_RESET} ${TXT_SETTINGS_PARALLEL} [${C_RGB5}$LM_MAX_PARALLEL${C_RESET}]"
        echo -e "${C_RGB4}[3]${C_RESET} ${TXT_SETTINGS_SPEED_LIMIT} [${C_RGB5}$LM_SPEED_LIMIT${C_RESET}]"
        echo -e "${C_RGB4}[4]${C_RESET} ${TXT_SETTINGS_DOWNLOAD_PATH}"
        echo -e "${C_RGB1}[0]${C_RESET} $TXT_MENU_OPTION_BACK\n"
        echo -ne "${C_RGB2}$TXT_PROMPT_CHOICE:${C_RESET} "
        read -r settings_choice
        case "$settings_choice" in
            1) lm_choose_language ;;
            2)
                while true; do
                    echo -ne "${C_RGB2}${TXT_SETTINGS_PARALLEL_NUM}:${C_RESET} "
                    read -r new_parallel
                    if [[ "$new_parallel" =~ ^[0-9]+$ ]] && [ "$new_parallel" -ge 1 ] && [ "$new_parallel" -le 16 ]; then
                        LM_MAX_PARALLEL=$new_parallel
                        lm_save_config
                        lm_toast "${TXT_SETTINGS_SAVED}: $LM_MAX_PARALLEL"
                        break
                    else
                        lm_toast "$TXT_ERROR_INVALID_CHOICE"
                    fi
                done
                sleep 1 ;;
            3)
                while true; do
                    echo -e "\n${C_RGB3}${TXT_SETTINGS_SPEED_LIMIT_SELECT}${C_RESET}"
                    echo -e "${C_RGB4}[1]${C_RESET} 1M   ${C_RGB4}[2]${C_RESET} 2M   ${C_RGB4}[3]${C_RESET} 3M   ${C_RGB4}[4]${C_RESET} 4M"
                    echo -e "${C_RGB4}[5]${C_RESET} 5M   ${C_RGB4}[6]${C_RESET} 10M  ${C_RGB4}[7]${C_RESET} 20M  ${C_RGB4}[8]${C_RESET} 50M"
                    echo -e "${C_RGB4}[9]${C_RESET} 100M ${C_RGB4}[10]${C_RESET} ${TXT_SETTINGS_SPEED_UNLIMITED}"
                    echo -ne "${C_RGB2}$TXT_PROMPT_CHOICE:${C_RESET} "
                    read -r speed_choice
                    case "$speed_choice" in
                        1) LM_SPEED_LIMIT="1M"; break ;;
                        2) LM_SPEED_LIMIT="2M"; break ;;
                        3) LM_SPEED_LIMIT="3M"; break ;;
                        4) LM_SPEED_LIMIT="4M"; break ;;
                        5) LM_SPEED_LIMIT="5M"; break ;;
                        6) LM_SPEED_LIMIT="10M"; break ;;
                        7) LM_SPEED_LIMIT="20M"; break ;;
                        8) LM_SPEED_LIMIT="50M"; break ;;
                        9) LM_SPEED_LIMIT="100M"; break ;;
                        10) LM_SPEED_LIMIT="unlimited"; break ;;
                        *) lm_toast "$TXT_ERROR_INVALID_CHOICE" ;;
                    esac
                done
                lm_save_config
                lm_toast "${TXT_SETTINGS_SAVED}: $LM_SPEED_LIMIT"
                sleep 1 ;;
            4)
                echo -ne "${C_RGB2}${TXT_SETTINGS_DOWNLOAD_PATH_PROMPT}:${C_RESET} "
                read -r new_path
                if [[ -n "$new_path" ]]; then
                    LM_DOWNLOAD_BASE="$new_path"
                    lm_create_folders
                    lm_save_config
                    lm_toast "${TXT_SETTINGS_SAVED}: $LM_DOWNLOAD_BASE"
                fi
                sleep 1 ;;
            0) break ;;
            *) lm_toast "$TXT_ERROR_INVALID_CHOICE"; sleep 1 ;;
        esac
    done
}

lm_admin_menu() {
    while true; do
        lm_banner
        echo -e "${C_RGB3}╔══════════════════════════════════════════════╗"
        echo -e "║              $TXT_ADMIN_MENU_TITLE              ║"
        echo -e "╚══════════════════════════════════════════════╝${C_RESET}\n"
        echo -e "${C_RGB4}[1]${C_RESET} $TXT_MENU_OPTION_UPDATE"
        echo -e "${C_RGB4}[2]${C_RESET} $TXT_MENU_OPTION_OPTIMIZE"
        echo -e "${C_RGB1}[0]${C_RESET} $TXT_MENU_OPTION_BACK\n"
        echo -ne "${C_RGB2}$TXT_PROMPT_CHOICE:${C_RESET} "
        read -r admin_choice
        case "$admin_choice" in
            1)
                lm_check_update
                case $? in
                    0) echo -e "\n${C_RGB2}[lamvavNE]${C_RESET} $TXT_UPDATE_AVAILABLE ($LM_REMOTE_VERSION)"
                       while true; do
                           echo -ne "${C_RGB2}$TXT_UPDATE_PROMPT${C_RESET} "
                           read -r up_confirm
                           case "$up_confirm" in h|H|y|Y|e|E|yes|YES|Yes) lm_do_update; break ;; n|N|no|NO|No) break ;; *) lm_toast "$TXT_ERROR_INVALID_CHOICE" ;; esac
                       done ;;
                    2) echo -e "\n${C_RGB2}[lamvavNE]${C_RESET} $TXT_ALREADY_LATEST" ;;
                    *) echo -e "\n${C_RGB1}[lamvavNE]${C_RESET} $TXT_UPDATE_FAILED" ;;
                esac
                echo -e "\n${C_RGB2}$TXT_PROMPT_CONTINUE...${C_RESET}"; read -r ;;
            2)
                echo -e "\n${C_RGB2}[lamvavNE]${C_RESET} $TXT_OPTIMIZE_DONE"
                rm -rf "$LM_DIR/cache" 2>/dev/null
                pip cache purge >/dev/null 2>&1
                lm_toast "$TXT_CACHE_CLEARED"
                echo -e "\n${C_RGB2}$TXT_PROMPT_CONTINUE...${C_RESET}"; read -r ;;
            0) break ;;
            *) lm_toast "$TXT_ERROR_INVALID_CHOICE"; sleep 1 ;;
        esac
    done
}

lm_manual_menu() {
    while true; do
        lm_banner
        echo -e "${C_RGB3}╔══════════════════════════════════════════════╗"
        echo -e "║           $TXT_MANUAL_MENU_TITLE             ║"
        echo -e "╚══════════════════════════════════════════════╝${C_RESET}\n"
        echo -e "${C_RGB4}[1]${C_RESET} Instagram"
        echo -e "${C_RGB4}[2]${C_RESET} TikTok"
        echo -e "${C_RGB4}[3]${C_RESET} YouTube"
        echo -e "${C_RGB4}[4]${C_RESET} Twitter/X"
        echo -e "${C_RGB4}[5]${C_RESET} Facebook"
        echo -e "${C_RGB4}[6]${C_RESET} SoundCloud"
        echo -e "${C_RGB1}[0]${C_RESET} $TXT_MENU_OPTION_BACK\n"
        echo -ne "${C_RGB2}$TXT_PROMPT_CHOICE:${C_RESET} "
        read -r platform_choice
        case "$platform_choice" in
            1) echo -ne "\n${C_RGB2}$TXT_PROMPT_INSTAGRAM_LINK:${C_RESET} "; read -r ig_url; lm_download_with_prompt instagram "$ig_url"; echo -e "\n${C_RGB2}$TXT_PROMPT_CONTINUE...${C_RESET}"; read -r ;;
            2) echo -ne "\n${C_RGB2}$TXT_PROMPT_TIKTOK_LINK:${C_RESET} "; read -r tt_url; lm_download_with_prompt tiktok "$tt_url"; echo -e "\n${C_RGB2}$TXT_PROMPT_CONTINUE...${C_RESET}"; read -r ;;
            3)
                while true; do
                    echo -e "\n${C_RGB3}$TXT_MENU_YT_MODE_TITLE:${C_RESET}"
                    echo -e "${C_RGB4}[1]${C_RESET} $TXT_MENU_YT_MODE_SINGLE"
                    echo -e "${C_RGB4}[2]${C_RESET} $TXT_MENU_YT_MODE_PLAYLIST"
                    echo -e "${C_RGB4}[3]${C_RESET} $TXT_MENU_YT_MODE_CHANNEL"
                    echo -e "${C_RGB1}[0]${C_RESET} $TXT_MENU_OPTION_BACK\n"
                    echo -ne "${C_RGB2}$TXT_PROMPT_CHOICE:${C_RESET} "; read -r yt_mode
                    case "$yt_mode" in
                        1) echo -ne "\n${C_RGB2}$TXT_PROMPT_YT_SINGLE_LINK:${C_RESET} "; read -r yt_single_url; lm_download_with_prompt youtube "$yt_single_url"; echo -e "\n${C_RGB2}$TXT_PROMPT_CONTINUE...${C_RESET}"; read -r; break ;;
                        2) echo -ne "\n${C_RGB2}$TXT_PROMPT_YT_PLAYLIST_LINK:${C_RESET} "; read -r yt_pl_url; lm_download_with_prompt youtube_playlist "$yt_pl_url"; echo -e "\n${C_RGB2}$TXT_PROMPT_CONTINUE...${C_RESET}"; read -r; break ;;
                        3) echo -ne "\n${C_RGB2}$TXT_PROMPT_YT_CHANNEL_LINK:${C_RESET} "; read -r yt_ch_url; lm_download_with_prompt youtube_channel "$yt_ch_url"; echo -e "\n${C_RGB2}$TXT_PROMPT_CONTINUE...${C_RESET}"; read -r; break ;;
                        0) break ;;
                        *) lm_toast "$TXT_ERROR_INVALID_CHOICE" ;;
                    esac
                done ;;
            4) echo -ne "\n${C_RGB2}$TXT_PROMPT_TWITTER_LINK:${C_RESET} "; read -r tw_url; lm_download_with_prompt twitter "$tw_url"; echo -e "\n${C_RGB2}$TXT_PROMPT_CONTINUE...${C_RESET}"; read -r ;;
            5) echo -ne "\n${C_RGB2}$TXT_PROMPT_FACEBOOK_LINK:${C_RESET} "; read -r fb_url; lm_download_with_prompt facebook "$fb_url"; echo -e "\n${C_RGB2}$TXT_PROMPT_CONTINUE...${C_RESET}"; read -r ;;
            6) echo -ne "\n${C_RGB2}$TXT_PROMPT_SOUNDCLOUD_LINK:${C_RESET} "; read -r sc_url; lm_download_with_prompt soundcloud "$sc_url"; echo -e "\n${C_RGB2}$TXT_PROMPT_CONTINUE...${C_RESET}"; read -r ;;
            0) break ;;
            *) lm_toast "$TXT_ERROR_INVALID_CHOICE"; sleep 1 ;;
        esac
    done
}

lm_auto_download() {
    local url="$1" platform
    lm_banner
    echo -e "${C_RGB3}╔══════════════════════════════════════════════╗"
    echo -e "║             $TXT_AUTO_MENU_TITLE             ║"
    echo -e "╚══════════════════════════════════════════════╝${C_RESET}\n"
    if [ -z "$url" ]; then
        local clip_url
        if clip_url="$(lm_get_clipboard_url)"; then
            echo -e "${C_RGB2}[lamvavNE]${C_RESET} $TXT_CLIPBOARD_FOUND: $clip_url"
            while true; do
                echo -ne "${C_RGB2}$TXT_USE_CLIPBOARD${C_RESET} "
                read -r use_clip
                case "$use_clip" in h|H|y|Y|e|E|yes|YES|Yes) url="$clip_url"; break ;; n|N|no|NO|No) echo -ne "${C_RGB2}$TXT_PROMPT_LINK:${C_RESET} "; read -r url; break ;; *) lm_toast "$TXT_ERROR_INVALID_CHOICE" ;; esac
            done
        else
            echo -ne "${C_RGB2}$TXT_PROMPT_LINK:${C_RESET} "; read -r url
        fi
    fi
    platform="$(lm_detect_platform "$url")"
    lm_download_with_prompt "$platform" "$url"
}

lm_main_menu() {
    while true; do
        lm_banner
        echo -e "${C_RGB3}╔══════════════════════════════════════════════╗"
        echo -e "║          lamvavNE $TXT_MAIN_MENU_TITLE        ║"
        echo -e "╚══════════════════════════════════════════════╝${C_RESET}\n"
        echo -e "${C_RGB4}[1]${C_RESET} $TXT_MENU_OPTION_MANUAL"
        echo -e "${C_RGB4}[2]${C_RESET} $TXT_MENU_OPTION_AUTO"
        echo -e "${C_RGB4}[3]${C_RESET} $TXT_MENU_OPTION_COOKIES"
        echo -e "${C_RGB4}[4]${C_RESET} $TXT_MENU_OPTION_SETTINGS"
        echo -e "${C_RGB4}[5]${C_RESET} $TXT_MENU_OPTION_ADMIN"
        echo -e "${C_RGB4}[6]${C_RESET} $TXT_MENU_OPTION_SEARCH"
        echo -e "${C_RGB4}[7]${C_RESET} ${TXT_ACTIVE_MENU_TITLE}"
        echo -e "${C_RGB1}[0]${C_RESET} $TXT_MENU_OPTION_EXIT\n"
        echo -ne "${C_RGB2}$TXT_PROMPT_CHOICE:${C_RESET} "
        read -r main_choice
        case "$main_choice" in
            1) lm_manual_menu ;;
            2) lm_auto_download "" ;;
            3) lm_cookies_menu ;;
            4) lm_settings_menu ;;
            5) lm_admin_menu ;;
            6) lm_search_menu ;;
            7) lm_active_menu ;;
            0) lm_banner; echo -e "${C_RGB2}[lamvavNE]${C_RESET} $TXT_EXIT_MESSAGE\n"; exit 0 ;;
            *) lm_toast "$TXT_ERROR_INVALID_CHOICE"; sleep 1 ;;
        esac
    done
}

lm_install() {
    mkdir -p "$LM_DIR"
    lm_banner
    echo -e "${C_RGB3}$TXT_INSTALLER_TITLE${C_RESET}"
    lm_toast "$TXT_INSTALL_PREP"
    sleep 0.5
    lm_toast "$TXT_INSTALL_STORAGE"
    termux-setup-storage
    sleep 0.5
    lm_run_step_fast "$TXT_STEP_UPDATE_PKGS" pkg update -y
    lm_run_step_fast "$TXT_STEP_INSTALL_PYTHON" pkg install python -y
    lm_run_step_fast "$TXT_STEP_INSTALL_FFMPEG" pkg install ffmpeg -y
    lm_run_step_fast "$TXT_STEP_INSTALL_GIT" pkg install git -y
    lm_run_step_fast "$TXT_STEP_INSTALL_JQ" pkg install jq -y
    lm_run_step_fast "$TXT_STEP_UPDATE_YTDLP" python -m pip install -U yt-dlp
    lm_run_step_fast "$TXT_STEP_UPDATE_INSTALOADER" python -m pip install -U instaloader
    lm_run_step_fast "$TXT_STEP_UPDATE_GDL" python -m pip install -U gallery-dl
    lm_run_step_fast "$TXT_STEP_PYTHON_PKGS" python -m pip install -U requests tqdm cryptography
    lm_run_step_fast "$TXT_STEP_CREATE_DIRS" lm_create_folders
    lm_run_step_fast "$TXT_STEP_SETUP_URL_OPENER" lm_setup_url_opener
    lm_run_step_fast "$TXT_STEP_GH_PHOTO_DL" curl -fsSL --connect-timeout 5 "$LM_TIKTOK_PHOTO_DL_RAW" -o "$LM_DIR/ttpdl.py" && chmod +x "$LM_DIR/ttpdl.py"

    lm_choose_language
    cp "$SOURCE_PATH" "$LM_BIN"
    chmod +x "$LM_BIN"
    if [ -f "$LM_LANG_SOURCE" ]; then
        cp "$LM_LANG_SOURCE" "$LM_DIR/lm-lang.sh"
    else
        curl -fsSL --connect-timeout 5 "$LM_LANG_RAW" -o "$LM_DIR/lm-lang.sh"
    fi
    lm_save_config
    lm_banner
    echo -e "${C_RGB2}╔══════════════════════════════════════╗${C_RESET}"
    echo -e "${C_RGB2}║      $TXT_INSTALL_SUCCESS_LINE1      ║${C_RESET}"
    echo -e "${C_RGB2}╚══════════════════════════════════════╝${C_RESET}\n"
    lm_toast "$TXT_INSTALL_SUCCESS_LINE2"
    lm_toast "$TXT_INSTALL_SUCCESS_LINE3"
    sleep 2
}

lm_main() {
    lm_background_auto_update
    lm_load_config
    lm_set_lang_vars
    if [ "$installed" != "true" ] || [ "$version_code" -lt 3210202607 ]; then
        lm_install
    fi
    if [ $# -eq 0 ]; then
        lm_startup_animation_fast
        lm_main_menu
    else
        lm_startup_animation_fast
        lm_auto_download "$1"
    fi
}

lm_main "$@"

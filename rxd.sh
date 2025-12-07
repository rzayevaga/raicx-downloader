#!/data/data/com.termux/files/usr/bin/bash

RXD_VERSION="X-5.5"
RXD_DIR="$HOME/.raicxd"
RXD_CONFIG="$RXD_DIR/rxd.conf"
RXD_BIN="/data/data/com.termux/files/usr/bin/rxd"
RXD_OPENER="$HOME/bin/termux-url-opener"
RXD_DOWNLOAD_BASE="/sdcard/raicXD"

RXD_LANG="AZ"

TXT_INSTALLER_TITLE=""
TXT_INSTALL_PREP=""
TXT_INSTALL_STORAGE=""
TXT_STEP_UPDATE_PKGS=""
TXT_STEP_INSTALL_PYTHON=""
TXT_STEP_INSTALL_FFMPEG=""
TXT_STEP_INSTALL_GIT=""
TXT_STEP_UPDATE_YTDLP=""
TXT_STEP_UPDATE_INSTALOADER=""
TXT_STEP_UPDATE_GDL=""
TXT_STEP_CREATE_DIRS=""
TXT_STEP_SETUP_URL_OPENER=""
TXT_INSTALL_SUCCESS_LINE1=""
TXT_INSTALL_SUCCESS_LINE2=""
TXT_INSTALL_SUCCESS_LINE3=""

TXT_MAIN_MENU_TITLE=""
TXT_MANUAL_MENU_TITLE=""
TXT_AUTO_MENU_TITLE=""
TXT_SETTINGS_MENU_TITLE=""
TXT_MENU_OPTION_MANUAL=""
TXT_MENU_OPTION_AUTO=""
TXT_MENU_OPTION_SETTINGS=""
TXT_MENU_OPTION_EXIT=""
TXT_MENU_OPTION_BACK=""
TXT_MENU_OPTION_LANGUAGE=""
TXT_PROMPT_CHOICE=""
TXT_PROMPT_LINK=""
TXT_PROMPT_INSTAGRAM_LINK=""
TXT_PROMPT_TIKTOK_LINK=""
TXT_PROMPT_YT_SINGLE_LINK=""
TXT_PROMPT_YT_PLAYLIST_LINK=""
TXT_PROMPT_CONTINUE=""
TXT_ERROR_INVALID_CHOICE=""
TXT_EXIT_MESSAGE=""
TXT_AUTO_PLATFORM_INSTAGRAM=""
TXT_AUTO_PLATFORM_TIKTOK=""
TXT_AUTO_PLATFORM_YT_SINGLE=""
TXT_AUTO_PLATFORM_YT_PLAYLIST=""
TXT_PLATFORM_UNKNOWN=""
TXT_SUPPORTED_PLATFORMS=""
TXT_MENU_YT_MODE_TITLE=""
TXT_MENU_YT_MODE_SINGLE=""
TXT_MENU_YT_MODE_PLAYLIST=""
TXT_OPTION_VIDEO_DOWNLOAD=""
TXT_OPTION_AUDIO_DOWNLOAD=""
TXT_OPTION_PLAYLIST_VIDEO=""
TXT_OPTION_PLAYLIST_AUDIO=""
TXT_DOWNLOAD_STARTED_INSTAGRAM_VIDEO=""
TXT_DOWNLOAD_STARTED_INSTAGRAM_AUDIO=""
TXT_DOWNLOAD_STARTED_TIKTOK_VIDEO=""
TXT_DOWNLOAD_STARTED_TIKTOK_AUDIO=""
TXT_DOWNLOAD_STARTED_YT_VIDEO=""
TXT_DOWNLOAD_STARTED_YT_AUDIO=""
TXT_DOWNLOAD_STARTED_YTPL_VIDEO=""
TXT_DOWNLOAD_STARTED_YTPL_AUDIO=""
TXT_DOWNLOAD_DONE_PREFIX=""
TXT_LANG_MENU_TITLE=""
TXT_LANG_MENU_DESC=""
TXT_LANG_AZ=""
TXT_LANG_TR=""
TXT_LANG_EN=""
TXT_LANG_RU=""
TXT_LANG_AR=""
TXT_LANG_ZH=""
TXT_LANG_JA=""
TXT_LANG_HI=""
TXT_LANG_CHANGED=""

rxd_set_lang_vars() {
    case "$RXD_LANG" in
        AZ)
            TXT_INSTALLER_TITLE="Ɍム-ic [✘] Quraşdırıcı"
            TXT_INSTALL_PREP="Hazırlıq gedir"
            TXT_INSTALL_STORAGE="Storage icazəsi tələb olunur"
            TXT_STEP_UPDATE_PKGS="Paketlər yenilənir"
            TXT_STEP_INSTALL_PYTHON="Python quraşdırılır"
            TXT_STEP_INSTALL_FFMPEG="FFmpeg quraşdırılır"
            TXT_STEP_INSTALL_GIT="Git quraşdırılır"
            TXT_STEP_UPDATE_YTDLP="yt-dlp yenilənir"
            TXT_STEP_UPDATE_INSTALOADER="instaloader yenilənir"
            TXT_STEP_UPDATE_GDL="gallery-dl yenilənir"
            TXT_STEP_CREATE_DIRS="Qovluqlar yaradılır"
            TXT_STEP_SETUP_URL_OPENER="Termux URL Opener quraşdırılır"
            TXT_INSTALL_SUCCESS_LINE1="Ɍム-ic [✘] UĞURLA QURAŞDIRILDI!"
            TXT_INSTALL_SUCCESS_LINE2="İndi terminalda rxd yazaraq panelə daxil ola bilərsiniz."
            TXT_INSTALL_SUCCESS_LINE3="Həmçinin istənilən linki Termux ilə paylaşa bilərsiniz."

            TXT_MAIN_MENU_TITLE="ƏSAS MENYU"
            TXT_MANUAL_MENU_TITLE="MANUAL YÜKLƏMƏ MENYUSU"
            TXT_AUTO_MENU_TITLE="AUTO YÜKLƏMƏ MENYUSU"
            TXT_SETTINGS_MENU_TITLE="PARAMETRLƏR"
            TXT_MENU_OPTION_MANUAL="Manual Yükləmə"
            TXT_MENU_OPTION_AUTO="Auto Yükləmə (Link yapışdır)"
            TXT_MENU_OPTION_SETTINGS="Parametrlər"
            TXT_MENU_OPTION_EXIT="Çıxış"
            TXT_MENU_OPTION_BACK="Geri"
            TXT_MENU_OPTION_LANGUAGE="Dil"
            TXT_PROMPT_CHOICE="Seçim edin"
            TXT_PROMPT_LINK="Link daxil edin"
            TXT_PROMPT_INSTAGRAM_LINK="Instagram link daxil edin"
            TXT_PROMPT_TIKTOK_LINK="TikTok link daxil edin"
            TXT_PROMPT_YT_SINGLE_LINK="YouTube video link daxil edin"
            TXT_PROMPT_YT_PLAYLIST_LINK="YouTube Playlist link daxil edin"
            TXT_PROMPT_CONTINUE="Davam etmək üçün Enter basın"
            TXT_ERROR_INVALID_CHOICE="Səhv seçim!"
            TXT_EXIT_MESSAGE="Sağ olun!"
            TXT_AUTO_PLATFORM_INSTAGRAM="Platform: Instagram"
            TXT_AUTO_PLATFORM_TIKTOK="Platform: TikTok"
            TXT_AUTO_PLATFORM_YT_SINGLE="Platform: YouTube (Tək Video)"
            TXT_AUTO_PLATFORM_YT_PLAYLIST="Platform: YouTube Playlist"
            TXT_PLATFORM_UNKNOWN="Platform tanınmadı!"
            TXT_SUPPORTED_PLATFORMS="Dəstəklənən platformalar: Instagram, TikTok, YouTube (tək və Playlist)"
            TXT_MENU_YT_MODE_TITLE="YouTube rejimi seçin"
            TXT_MENU_YT_MODE_SINGLE="Tək Video"
            TXT_MENU_YT_MODE_PLAYLIST="Playlist"
            TXT_OPTION_VIDEO_DOWNLOAD="Video yüklə"
            TXT_OPTION_AUDIO_DOWNLOAD="Musiqi yüklə (MP3)"
            TXT_OPTION_PLAYLIST_VIDEO="Playlist Video yüklə"
            TXT_OPTION_PLAYLIST_AUDIO="Playlist Musiqi yüklə (MP3)"
            TXT_DOWNLOAD_STARTED_INSTAGRAM_VIDEO="Instagram video yükləmə başlayır..."
            TXT_DOWNLOAD_STARTED_INSTAGRAM_AUDIO="Instagram musiqi yükləmə başlayır..."
            TXT_DOWNLOAD_STARTED_TIKTOK_VIDEO="TikTok video yükləmə başlayır..."
            TXT_DOWNLOAD_STARTED_TIKTOK_AUDIO="TikTok musiqi yükləmə başlayır..."
            TXT_DOWNLOAD_STARTED_YT_VIDEO="YouTube video yükləmə başlayır..."
            TXT_DOWNLOAD_STARTED_YT_AUDIO="YouTube musiqi (MP3) yükləmə başlayır..."
            TXT_DOWNLOAD_STARTED_YTPL_VIDEO="YouTube Playlist video yükləmə başlayır..."
            TXT_DOWNLOAD_STARTED_YTPL_AUDIO="YouTube Playlist musiqi (MP3) yükləmə başlayır..."
            TXT_DOWNLOAD_DONE_PREFIX="Yükləmə tamamlandı"
            TXT_LANG_MENU_TITLE="Dil seçimi"
            TXT_LANG_MENU_DESC="Zəhmət olmasa dil seçin"
            TXT_LANG_AZ="Azərbaycan dili"
            TXT_LANG_TR="Türkçe"
            TXT_LANG_EN="English"
            TXT_LANG_RU="Русский"
            TXT_LANG_AR="اللغة العربية"
            TXT_LANG_ZH="中國人"
            TXT_LANG_JA="日本語"
            TXT_LANG_HI="हिंद भाषा"
            TXT_LANG_CHANGED="Dil uğurla dəyişdirildi"
            ;;
        TR)
            TXT_INSTALLER_TITLE="Ɍム-ic [✘] Yükleyici"
            TXT_INSTALL_PREP="Hazırlık yapılıyor"
            TXT_INSTALL_STORAGE="Depolama izni gerekiyor"
            TXT_STEP_UPDATE_PKGS="Paketler güncelleniyor"
            TXT_STEP_INSTALL_PYTHON="Python kuruluyor"
            TXT_STEP_INSTALL_FFMPEG="FFmpeg kuruluyor"
            TXT_STEP_INSTALL_GIT="Git kuruluyor"
            TXT_STEP_UPDATE_YTDLP="yt-dlp güncelleniyor"
            TXT_STEP_UPDATE_INSTALOADER="instaloader güncelleniyor"
            TXT_STEP_UPDATE_GDL="gallery-dl güncelleniyor"
            TXT_STEP_CREATE_DIRS="Klasörler oluşturuluyor"
            TXT_STEP_SETUP_URL_OPENER="Termux URL Opener ayarlanıyor"
            TXT_INSTALL_SUCCESS_LINE1="Ɍム-ic [✘] BAŞARIYLA KURULDU!"
            TXT_INSTALL_SUCCESS_LINE2="Artık terminalde rxd yazarak panele girebilirsiniz."
            TXT_INSTALL_SUCCESS_LINE3="Ayrıca herhangi bir linki Termux ile paylaşabilirsiniz."

            TXT_MAIN_MENU_TITLE="ANA MENÜ"
            TXT_MANUAL_MENU_TITLE="MANUEL İNDİRME MENÜSÜ"
            TXT_AUTO_MENU_TITLE="OTOMATİK İNDİRME MENÜSÜ"
            TXT_SETTINGS_MENU_TITLE="AYARLAR"
            TXT_MENU_OPTION_MANUAL="Manuel İndirme"
            TXT_MENU_OPTION_AUTO="Otomatik İndirme (Link yapıştır)"
            TXT_MENU_OPTION_SETTINGS="Ayarlar"
            TXT_MENU_OPTION_EXIT="Çıkış"
            TXT_MENU_OPTION_BACK="Geri"
            TXT_MENU_OPTION_LANGUAGE="Dil"
            TXT_PROMPT_CHOICE="Seçim yapın"
            TXT_PROMPT_LINK="Link girin"
            TXT_PROMPT_INSTAGRAM_LINK="Instagram link girin"
            TXT_PROMPT_TIKTOK_LINK="TikTok link girin"
            TXT_PROMPT_YT_SINGLE_LINK="YouTube video link girin"
            TXT_PROMPT_YT_PLAYLIST_LINK="YouTube Playlist link girin"
            TXT_PROMPT_CONTINUE="Devam etmek için Enter'a basın"
            TXT_ERROR_INVALID_CHOICE="Hatalı seçim!"
            TXT_EXIT_MESSAGE="Hoşçakal!"
            TXT_AUTO_PLATFORM_INSTAGRAM="Platform: Instagram"
            TXT_AUTO_PLATFORM_TIKTOK="Platform: TikTok"
            TXT_AUTO_PLATFORM_YT_SINGLE="Platform: YouTube (Tek Video)"
            TXT_AUTO_PLATFORM_YT_PLAYLIST="Platform: YouTube Playlist"
            TXT_PLATFORM_UNKNOWN="Platform tanınmadı!"
            TXT_SUPPORTED_PLATFORMS="Desteklenen platformlar: Instagram, TikTok, YouTube (tek ve Playlist)"
            TXT_MENU_YT_MODE_TITLE="YouTube modunu seçin"
            TXT_MENU_YT_MODE_SINGLE="Tek Video"
            TXT_MENU_YT_MODE_PLAYLIST="Playlist"
            TXT_OPTION_VIDEO_DOWNLOAD="Video indir"
            TXT_OPTION_AUDIO_DOWNLOAD="Müzik indir (MP3)"
            TXT_OPTION_PLAYLIST_VIDEO="Playlist Video indir"
            TXT_OPTION_PLAYLIST_AUDIO="Playlist Müzik indir (MP3)"
            TXT_DOWNLOAD_STARTED_INSTAGRAM_VIDEO="Instagram video indiriliyor..."
            TXT_DOWNLOAD_STARTED_INSTAGRAM_AUDIO="Instagram müzik indiriliyor..."
            TXT_DOWNLOAD_STARTED_TIKTOK_VIDEO="TikTok video indiriliyor..."
            TXT_DOWNLOAD_STARTED_TIKTOK_AUDIO="TikTok müzik indiriliyor..."
            TXT_DOWNLOAD_STARTED_YT_VIDEO="YouTube video indiriliyor..."
            TXT_DOWNLOAD_STARTED_YT_AUDIO="YouTube müzik (MP3) indiriliyor..."
            TXT_DOWNLOAD_STARTED_YTPL_VIDEO="YouTube Playlist video indiriliyor..."
            TXT_DOWNLOAD_STARTED_YTPL_AUDIO="YouTube Playlist müzik (MP3) indiriliyor..."
            TXT_DOWNLOAD_DONE_PREFIX="İndirme tamamlandı"
            TXT_LANG_MENU_TITLE="Dil seçimi"
            TXT_LANG_MENU_DESC="Lütfen dil seçin"
            TXT_LANG_AZ="Azərbaycan dili"
            TXT_LANG_TR="Türkçe"
            TXT_LANG_EN="English"
            TXT_LANG_RU="Русский"
            TXT_LANG_AR="اللغة العربية"
            TXT_LANG_ZH="中國人"
            TXT_LANG_JA="日本語"
            TXT_LANG_HI="हिंद भाषा"
            TXT_LANG_CHANGED="Dil başarıyla değiştirildi"
            ;;
        EN)
            TXT_INSTALLER_TITLE="Ɍム-ic [✘] Installer"
            TXT_INSTALL_PREP="Preparing"
            TXT_INSTALL_STORAGE="Storage permission required"
            TXT_STEP_UPDATE_PKGS="Updating packages"
            TXT_STEP_INSTALL_PYTHON="Installing Python"
            TXT_STEP_INSTALL_FFMPEG="Installing FFmpeg"
            TXT_STEP_INSTALL_GIT="Installing Git"
            TXT_STEP_UPDATE_YTDLP="Updating yt-dlp"
            TXT_STEP_UPDATE_INSTALOADER="Updating instaloader"
            TXT_STEP_UPDATE_GDL="Updating gallery-dl"
            TXT_STEP_CREATE_DIRS="Creating folders"
            TXT_STEP_SETUP_URL_OPENER="Setting up Termux URL Opener"
            TXT_INSTALL_SUCCESS_LINE1="Ɍム-ic [✘] INSTALLED SUCCESSFULLY!"
            TXT_INSTALL_SUCCESS_LINE2="Now you can run rxd in terminal to open the panel."
            TXT_INSTALL_SUCCESS_LINE3="You can also share any link directly to Termux."

            TXT_MAIN_MENU_TITLE="MAIN MENU"
            TXT_MANUAL_MENU_TITLE="MANUAL DOWNLOAD MENU"
            TXT_AUTO_MENU_TITLE="AUTO DOWNLOAD MENU"
            TXT_SETTINGS_MENU_TITLE="SETTINGS"
            TXT_MENU_OPTION_MANUAL="Manual Download"
            TXT_MENU_OPTION_AUTO="Auto Download (Paste link)"
            TXT_MENU_OPTION_SETTINGS="Settings"
            TXT_MENU_OPTION_EXIT="Exit"
            TXT_MENU_OPTION_BACK="Back"
            TXT_MENU_OPTION_LANGUAGE="Language"
            TXT_PROMPT_CHOICE="Choose an option"
            TXT_PROMPT_LINK="Enter link"
            TXT_PROMPT_INSTAGRAM_LINK="Enter Instagram link"
            TXT_PROMPT_TIKTOK_LINK="Enter TikTok link"
            TXT_PROMPT_YT_SINGLE_LINK="Enter YouTube video link"
            TXT_PROMPT_YT_PLAYLIST_LINK="Enter YouTube Playlist link"
            TXT_PROMPT_CONTINUE="Press Enter to continue"
            TXT_ERROR_INVALID_CHOICE="Invalid choice!"
            TXT_EXIT_MESSAGE="Goodbye!"
            TXT_AUTO_PLATFORM_INSTAGRAM="Platform: Instagram"
            TXT_AUTO_PLATFORM_TIKTOK="Platform: TikTok"
            TXT_AUTO_PLATFORM_YT_SINGLE="Platform: YouTube (Single Video)"
            TXT_AUTO_PLATFORM_YT_PLAYLIST="Platform: YouTube Playlist"
            TXT_PLATFORM_UNKNOWN="Unknown platform!"
            TXT_SUPPORTED_PLATFORMS="Supported platforms: Instagram, TikTok, YouTube (single and playlist)"
            TXT_MENU_YT_MODE_TITLE="Select YouTube mode"
            TXT_MENU_YT_MODE_SINGLE="Single Video"
            TXT_MENU_YT_MODE_PLAYLIST="Playlist"
            TXT_OPTION_VIDEO_DOWNLOAD="Download Video"
            TXT_OPTION_AUDIO_DOWNLOAD="Download Audio (MP3)"
            TXT_OPTION_PLAYLIST_VIDEO="Download Playlist Video"
            TXT_OPTION_PLAYLIST_AUDIO="Download Playlist Audio (MP3)"
            TXT_DOWNLOAD_STARTED_INSTAGRAM_VIDEO="Starting Instagram video download..."
            TXT_DOWNLOAD_STARTED_INSTAGRAM_AUDIO="Starting Instagram audio download..."
            TXT_DOWNLOAD_STARTED_TIKTOK_VIDEO="Starting TikTok video download..."
            TXT_DOWNLOAD_STARTED_TIKTOK_AUDIO="Starting TikTok audio download..."
            TXT_DOWNLOAD_STARTED_YT_VIDEO="Starting YouTube video download..."
            TXT_DOWNLOAD_STARTED_YT_AUDIO="Starting YouTube audio (MP3) download..."
            TXT_DOWNLOAD_STARTED_YTPL_VIDEO="Starting YouTube playlist video download..."
            TXT_DOWNLOAD_STARTED_YTPL_AUDIO="Starting YouTube playlist audio (MP3) download..."
            TXT_DOWNLOAD_DONE_PREFIX="Download finished"
            TXT_LANG_MENU_TITLE="Language selection"
            TXT_LANG_MENU_DESC="Please choose a language"
            TXT_LANG_AZ="Azərbaycan dili"
            TXT_LANG_TR="Türkçe"
            TXT_LANG_EN="English"
            TXT_LANG_RU="Русский"
            TXT_LANG_AR="اللغة العربية"
            TXT_LANG_ZH="中國人"
            TXT_LANG_JA="日本語"
            TXT_LANG_HI="हिंद भाषा"
            TXT_LANG_CHANGED="Language changed successfully"
            ;;
        RU)
            TXT_INSTALLER_TITLE="Ɍム-ic [✘] Установщик"
            TXT_INSTALL_PREP="Подготовка"
            TXT_INSTALL_STORAGE="Требуется доступ к памяти"
            TXT_STEP_UPDATE_PKGS="Обновление пакетов"
            TXT_STEP_INSTALL_PYTHON="Установка Python"
            TXT_STEP_INSTALL_FFMPEG="Установка FFmpeg"
            TXT_STEP_INSTALL_GIT="Установка Git"
            TXT_STEP_UPDATE_YTDLP="Обновление yt-dlp"
            TXT_STEP_UPDATE_INSTALOADER="Обновление instaloader"
            TXT_STEP_UPDATE_GDL="Обновление gallery-dl"
            TXT_STEP_CREATE_DIRS="Создание папок"
            TXT_STEP_SETUP_URL_OPENER="Настройка Termux URL Opener"
            TXT_INSTALL_SUCCESS_LINE1="Ɍム-ic [✘] УСПЕШНО УСТАНОВЛЕН!"
            TXT_INSTALL_SUCCESS_LINE2="Теперь вы можете запустить rxd в терминале."
            TXT_INSTALL_SUCCESS_LINE3="Также можете делиться ссылками через Termux."

            TXT_MAIN_MENU_TITLE="ГЛАВНОЕ МЕНЮ"
            TXT_MANUAL_MENU_TITLE="МЕНЮ РУЧНОЙ ЗАГРУЗКИ"
            TXT_AUTO_MENU_TITLE="МЕНЮ АВТОЗАГРУЗКИ"
            TXT_SETTINGS_MENU_TITLE="НАСТРОЙКИ"
            TXT_MENU_OPTION_MANUAL="Ручная загрузка"
            TXT_MENU_OPTION_AUTO="Авто-загрузка (вставить ссылку)"
            TXT_MENU_OPTION_SETTINGS="Настройки"
            TXT_MENU_OPTION_EXIT="Выход"
            TXT_MENU_OPTION_BACK="Назад"
            TXT_MENU_OPTION_LANGUAGE="Язык"
            TXT_PROMPT_CHOICE="Сделайте выбор"
            TXT_PROMPT_LINK="Введите ссылку"
            TXT_PROMPT_INSTAGRAM_LINK="Введите ссылку Instagram"
            TXT_PROMPT_TIKTOK_LINK="Введите ссылку TikTok"
            TXT_PROMPT_YT_SINGLE_LINK="Введите ссылку YouTube видео"
            TXT_PROMPT_YT_PLAYLIST_LINK="Введите ссылку YouTube плейлиста"
            TXT_PROMPT_CONTINUE="Нажмите Enter для продолжения"
            TXT_ERROR_INVALID_CHOICE="Неверный выбор!"
            TXT_EXIT_MESSAGE="До свидания!"
            TXT_AUTO_PLATFORM_INSTAGRAM="Платформа: Instagram"
            TXT_AUTO_PLATFORM_TIKTOK="Платформа: TikTok"
            TXT_AUTO_PLATFORM_YT_SINGLE="Платформа: YouTube (одно видео)"
            TXT_AUTO_PLATFORM_YT_PLAYLIST="Платформа: YouTube плейлист"
            TXT_PLATFORM_UNKNOWN="Неизвестная платформа!"
            TXT_SUPPORTED_PLATFORMS="Поддерживаемые платформы: Instagram, TikTok, YouTube (видео и плейлисты)"
            TXT_MENU_YT_MODE_TITLE="Выберите режим YouTube"
            TXT_MENU_YT_MODE_SINGLE="Одно видео"
            TXT_MENU_YT_MODE_PLAYLIST="Плейлист"
            TXT_OPTION_VIDEO_DOWNLOAD="Скачать видео"
            TXT_OPTION_AUDIO_DOWNLOAD="Скачать аудио (MP3)"
            TXT_OPTION_PLAYLIST_VIDEO="Скачать видео плейлиста"
            TXT_OPTION_PLAYLIST_AUDIO="Скачать аудио плейлиста (MP3)"
            TXT_DOWNLOAD_STARTED_INSTAGRAM_VIDEO="Начинается загрузка видео Instagram..."
            TXT_DOWNLOAD_STARTED_INSTAGRAM_AUDIO="Начинается загрузка аудио Instagram..."
            TXT_DOWNLOAD_STARTED_TIKTOK_VIDEO="Начинается загрузка видео TikTok..."
            TXT_DOWNLOAD_STARTED_TIKTOK_AUDIO="Начинается загрузка аудио TikTok..."
            TXT_DOWNLOAD_STARTED_YT_VIDEO="Начинается загрузка видео YouTube..."
            TXT_DOWNLOAD_STARTED_YT_AUDIO="Начинается загрузка аудио YouTube (MP3)..."
            TXT_DOWNLOAD_STARTED_YTPL_VIDEO="Начинается загрузка видео плейлиста YouTube..."
            TXT_DOWNLOAD_STARTED_YTPL_AUDIO="Начинается загрузка аудио плейлиста YouTube (MP3)..."
            TXT_DOWNLOAD_DONE_PREFIX="Загрузка завершена"
            TXT_LANG_MENU_TITLE="Выбор языка"
            TXT_LANG_MENU_DESC="Пожалуйста, выберите язык"
            TXT_LANG_AZ="Azərbaycan dili"
            TXT_LANG_TR="Türkçe"
            TXT_LANG_EN="English"
            TXT_LANG_RU="Русский"
            TXT_LANG_AR="اللغة العربية"
            TXT_LANG_ZH="中國人"
            TXT_LANG_JA="日本語"
            TXT_LANG_HI="हिंद भाषा"
            TXT_LANG_CHANGED="Язык успешно изменён"
            ;;
        AR)
            TXT_INSTALLER_TITLE="Ɍム-ic [✘] المُثَبِّت"
            TXT_INSTALL_PREP="جارِ التحضير"
            TXT_INSTALL_STORAGE="يلزم إذن الوصول للتخزين"
            TXT_STEP_UPDATE_PKGS="جارِ تحديث الحزم"
            TXT_STEP_INSTALL_PYTHON="جارِ تثبيت Python"
            TXT_STEP_INSTALL_FFMPEG="جارِ تثبيت FFmpeg"
            TXT_STEP_INSTALL_GIT="جارِ تثبيت Git"
            TXT_STEP_UPDATE_YTDLP="جارِ تحديث yt-dlp"
            TXT_STEP_UPDATE_INSTALOADER="جارِ تحديث instaloader"
            TXT_STEP_UPDATE_GDL="جارِ تحديث gallery-dl"
            TXT_STEP_CREATE_DIRS="جارِ إنشاء المجلدات"
            TXT_STEP_SETUP_URL_OPENER="جارِ إعداد Termux URL Opener"
            TXT_INSTALL_SUCCESS_LINE1="Ɍム-ic [✘] تَمَّ التثبيت بنجاح!"
            TXT_INSTALL_SUCCESS_LINE2="الآن يمكنك تشغيل rxd من الطرفية."
            TXT_INSTALL_SUCCESS_LINE3="ويمكنك أيضًا مشاركة أي رابط إلى Termux."

            TXT_MAIN_MENU_TITLE="القائمة الرئيسية"
            TXT_MANUAL_MENU_TITLE="قائمة التحميل اليدوي"
            TXT_AUTO_MENU_TITLE="قائمة التحميل التلقائي"
            TXT_SETTINGS_MENU_TITLE="الإعدادات"
            TXT_MENU_OPTION_MANUAL="تحميل يدوي"
            TXT_MENU_OPTION_AUTO="تحميل تلقائي (لصق الرابط)"
            TXT_MENU_OPTION_SETTINGS="الإعدادات"
            TXT_MENU_OPTION_EXIT="خروج"
            TXT_MENU_OPTION_BACK="رجوع"
            TXT_MENU_OPTION_LANGUAGE="اللغة"
            TXT_PROMPT_CHOICE="اختر خياراً"
            TXT_PROMPT_LINK="أدخل الرابط"
            TXT_PROMPT_INSTAGRAM_LINK="أدخل رابط Instagram"
            TXT_PROMPT_TIKTOK_LINK="أدخل رابط TikTok"
            TXT_PROMPT_YT_SINGLE_LINK="أدخل رابط فيديو YouTube"
            TXT_PROMPT_YT_PLAYLIST_LINK="أدخل رابط قائمة YouTube"
            TXT_PROMPT_CONTINUE="اضغط Enter للمتابعة"
            TXT_ERROR_INVALID_CHOICE="اختيار غير صالح!"
            TXT_EXIT_MESSAGE="إلى اللقاء!"
            TXT_AUTO_PLATFORM_INSTAGRAM="المنصة: Instagram"
            TXT_AUTO_PLATFORM_TIKTOK="المنصة: TikTok"
            TXT_AUTO_PLATFORM_YT_SINGLE="المنصة: YouTube (فيديو واحد)"
            TXT_AUTO_PLATFORM_YT_PLAYLIST="المنصة: قائمة YouTube"
            TXT_PLATFORM_UNKNOWN="منصة غير معروفة!"
            TXT_SUPPORTED_PLATFORMS="المنصات المدعومة: Instagram, TikTok, YouTube (فيديو وقوائم)"
            TXT_MENU_YT_MODE_TITLE="اختر وضع YouTube"
            TXT_MENU_YT_MODE_SINGLE="فيديو واحد"
            TXT_MENU_YT_MODE_PLAYLIST="قائمة تشغيل"
            TXT_OPTION_VIDEO_DOWNLOAD="تحميل فيديو"
            TXT_OPTION_AUDIO_DOWNLOAD="تحميل صوت (MP3)"
            TXT_OPTION_PLAYLIST_VIDEO="تحميل فيديو القائمة"
            TXT_OPTION_PLAYLIST_AUDIO="تحميل صوت القائمة (MP3)"
            TXT_DOWNLOAD_STARTED_INSTAGRAM_VIDEO="بدء تحميل فيديو Instagram..."
            TXT_DOWNLOAD_STARTED_INSTAGRAM_AUDIO="بدء تحميل صوت Instagram..."
            TXT_DOWNLOAD_STARTED_TIKTOK_VIDEO="بدء تحميل فيديو TikTok..."
            TXT_DOWNLOAD_STARTED_TIKTOK_AUDIO="بدء تحميل صوت TikTok..."
            TXT_DOWNLOAD_STARTED_YT_VIDEO="بدء تحميل فيديو YouTube..."
            TXT_DOWNLOAD_STARTED_YT_AUDIO="بدء تحميل صوت YouTube (MP3)..."
            TXT_DOWNLOAD_STARTED_YTPL_VIDEO="بدء تحميل فيديو قائمة YouTube..."
            TXT_DOWNLOAD_STARTED_YTPL_AUDIO="بدء تحميل صوت قائمة YouTube (MP3)..."
            TXT_DOWNLOAD_DONE_PREFIX="اكتمل التحميل"
            TXT_LANG_MENU_TITLE="اختيار اللغة"
            TXT_LANG_MENU_DESC="يرجى اختيار اللغة"
            TXT_LANG_AZ="Azərbaycan dili"
            TXT_LANG_TR="Türkçe"
            TXT_LANG_EN="English"
            TXT_LANG_RU="Русский"
            TXT_LANG_AR="اللغة العربية"
            TXT_LANG_ZH="中國人"
            TXT_LANG_JA="日本語"
            TXT_LANG_HI="हिंद भाषा"
            TXT_LANG_CHANGED="تم تغيير اللغة بنجاح"
            ;;
        ZH)
            TXT_INSTALLER_TITLE="Ɍム-ic [✘] 安装程序"
            TXT_INSTALL_PREP="正在准备"
            TXT_INSTALL_STORAGE="需要存储权限"
            TXT_STEP_UPDATE_PKGS="正在更新软件包"
            TXT_STEP_INSTALL_PYTHON="正在安装 Python"
            TXT_STEP_INSTALL_FFMPEG="正在安装 FFmpeg"
            TXT_STEP_INSTALL_GIT="正在安装 Git"
            TXT_STEP_UPDATE_YTDLP="正在更新 yt-dlp"
            TXT_STEP_UPDATE_INSTALOADER="正在更新 instaloader"
            TXT_STEP_UPDATE_GDL="正在更新 gallery-dl"
            TXT_STEP_CREATE_DIRS="正在创建文件夹"
            TXT_STEP_SETUP_URL_OPENER="正在配置 Termux URL Opener"
            TXT_INSTALL_SUCCESS_LINE1="Ɍム-ic [✘] 安装成功!"
            TXT_INSTALL_SUCCESS_LINE2="现在可以在终端中运行 rxd 打开面板。"
            TXT_INSTALL_SUCCESS_LINE3="也可以从其他应用分享链接到 Termux。"

            TXT_MAIN_MENU_TITLE="主菜单"
            TXT_MANUAL_MENU_TITLE="手动下载菜单"
            TXT_AUTO_MENU_TITLE="自动下载菜单"
            TXT_SETTINGS_MENU_TITLE="设置"
            TXT_MENU_OPTION_MANUAL="手动下载"
            TXT_MENU_OPTION_AUTO="自动下载（粘贴链接）"
            TXT_MENU_OPTION_SETTINGS="设置"
            TXT_MENU_OPTION_EXIT="退出"
            TXT_MENU_OPTION_BACK="返回"
            TXT_MENU_OPTION_LANGUAGE="语言"
            TXT_PROMPT_CHOICE="请选择"
            TXT_PROMPT_LINK="输入链接"
            TXT_PROMPT_INSTAGRAM_LINK="输入 Instagram 链接"
            TXT_PROMPT_TIKTOK_LINK="输入 TikTok 链接"
            TXT_PROMPT_YT_SINGLE_LINK="输入 YouTube 视频链接"
            TXT_PROMPT_YT_PLAYLIST_LINK="输入 YouTube 播放列表链接"
            TXT_PROMPT_CONTINUE="按 Enter 继续"
            TXT_ERROR_INVALID_CHOICE="无效的选择!"
            TXT_EXIT_MESSAGE="再见!"
            TXT_AUTO_PLATFORM_INSTAGRAM="平台: Instagram"
            TXT_AUTO_PLATFORM_TIKTOK="平台: TikTok"
            TXT_AUTO_PLATFORM_YT_SINGLE="平台: YouTube（单个视频）"
            TXT_AUTO_PLATFORM_YT_PLAYLIST="平台: YouTube 播放列表"
            TXT_PLATFORM_UNKNOWN="未知平台!"
            TXT_SUPPORTED_PLATFORMS="支持平台: Instagram, TikTok, YouTube（视频和播放列表）"
            TXT_MENU_YT_MODE_TITLE="选择 YouTube 模式"
            TXT_MENU_YT_MODE_SINGLE="单个视频"
            TXT_MENU_YT_MODE_PLAYLIST="播放列表"
            TXT_OPTION_VIDEO_DOWNLOAD="下载视频"
            TXT_OPTION_AUDIO_DOWNLOAD="下载音频 (MP3)"
            TXT_OPTION_PLAYLIST_VIDEO="下载播放列表视频"
            TXT_OPTION_PLAYLIST_AUDIO="下载播放列表音频 (MP3)"
            TXT_DOWNLOAD_STARTED_INSTAGRAM_VIDEO="开始下载 Instagram 视频..."
            TXT_DOWNLOAD_STARTED_INSTAGRAM_AUDIO="开始下载 Instagram 音频..."
            TXT_DOWNLOAD_STARTED_TIKTOK_VIDEO="开始下载 TikTok 视频..."
            TXT_DOWNLOAD_STARTED_TIKTOK_AUDIO="开始下载 TikTok 音频..."
            TXT_DOWNLOAD_STARTED_YT_VIDEO="开始下载 YouTube 视频..."
            TXT_DOWNLOAD_STARTED_YT_AUDIO="开始下载 YouTube 音频 (MP3)..."
            TXT_DOWNLOAD_STARTED_YTPL_VIDEO="开始下载 YouTube 播放列表视频..."
            TXT_DOWNLOAD_STARTED_YTPL_AUDIO="开始下载 YouTube 播放列表音频 (MP3)..."
            TXT_DOWNLOAD_DONE_PREFIX="下载完成"
            TXT_LANG_MENU_TITLE="语言选择"
            TXT_LANG_MENU_DESC="请选择语言"
            TXT_LANG_AZ="Azərbaycan dili"
            TXT_LANG_TR="Türkçe"
            TXT_LANG_EN="English"
            TXT_LANG_RU="Русский"
            TXT_LANG_AR="اللغة العربية"
            TXT_LANG_ZH="中國人"
            TXT_LANG_JA="日本語"
            TXT_LANG_HI="हिंद भाषा"
            TXT_LANG_CHANGED="语言已成功更改"
            ;;
        JA)
            TXT_INSTALLER_TITLE="Ɍム-ic [✘] インストーラー"
            TXT_INSTALL_PREP="準備中"
            TXT_INSTALL_STORAGE="ストレージ権限が必要です"
            TXT_STEP_UPDATE_PKGS="パッケージを更新中"
            TXT_STEP_INSTALL_PYTHON="Python をインストール中"
            TXT_STEP_INSTALL_FFMPEG="FFmpeg をインストール中"
            TXT_STEP_INSTALL_GIT="Git をインストール中"
            TXT_STEP_UPDATE_YTDLP="yt-dlp を更新中"
            TXT_STEP_UPDATE_INSTALOADER="instaloader を更新中"
            TXT_STEP_UPDATE_GDL="gallery-dl を更新中"
            TXT_STEP_CREATE_DIRS="フォルダを作成中"
            TXT_STEP_SETUP_URL_OPENER="Termux URL Opener を設定中"
            TXT_INSTALL_SUCCESS_LINE1="Ɍム-ic [✘] のインストールが完了しました!"
            TXT_INSTALL_SUCCESS_LINE2="ターミナルで rxd と入力してパネルを開けます。"
            TXT_INSTALL_SUCCESS_LINE3="他のアプリからリンクを Termux に共有することもできます。"

            TXT_MAIN_MENU_TITLE="メインメニュー"
            TXT_MANUAL_MENU_TITLE="手動ダウンロードメニュー"
            TXT_AUTO_MENU_TITLE="自動ダウンロードメニュー"
            TXT_SETTINGS_MENU_TITLE="設定"
            TXT_MENU_OPTION_MANUAL="手動ダウンロード"
            TXT_MENU_OPTION_AUTO="自動ダウンロード（リンク貼り付け）"
            TXT_MENU_OPTION_SETTINGS="設定"
            TXT_MENU_OPTION_EXIT="終了"
            TXT_MENU_OPTION_BACK="戻る"
            TXT_MENU_OPTION_LANGUAGE="言語"
            TXT_PROMPT_CHOICE="選択してください"
            TXT_PROMPT_LINK="リンクを入力"
            TXT_PROMPT_INSTAGRAM_LINK="Instagram リンクを入力"
            TXT_PROMPT_TIKTOK_LINK="TikTok リンクを入力"
            TXT_PROMPT_YT_SINGLE_LINK="YouTube 動画リンクを入力"
            TXT_PROMPT_YT_PLAYLIST_LINK="YouTube プレイリストリンクを入力"
            TXT_PROMPT_CONTINUE="続行するには Enter を押してください"
            TXT_ERROR_INVALID_CHOICE="無効な選択です!"
            TXT_EXIT_MESSAGE="さようなら!"
            TXT_AUTO_PLATFORM_INSTAGRAM="プラットフォーム: Instagram"
            TXT_AUTO_PLATFORM_TIKTOK="プラットフォーム: TikTok"
            TXT_AUTO_PLATFORM_YT_SINGLE="プラットフォーム: YouTube（単一動画）"
            TXT_AUTO_PLATFORM_YT_PLAYLIST="プラットフォーム: YouTube プレイリスト"
            TXT_PLATFORM_UNKNOWN="不明なプラットフォームです!"
            TXT_SUPPORTED_PLATFORMS="対応プラットフォーム: Instagram, TikTok, YouTube（動画とプレイリスト）"
            TXT_MENU_YT_MODE_TITLE="YouTube モードを選択"
            TXT_MENU_YT_MODE_SINGLE="単一動画"
            TXT_MENU_YT_MODE_PLAYLIST="プレイリスト"
            TXT_OPTION_VIDEO_DOWNLOAD="動画をダウンロード"
            TXT_OPTION_AUDIO_DOWNLOAD="音声をダウンロード (MP3)"
            TXT_OPTION_PLAYLIST_VIDEO="プレイリスト動画をダウンロード"
            TXT_OPTION_PLAYLIST_AUDIO="プレイリスト音声をダウンロード (MP3)"
            TXT_DOWNLOAD_STARTED_INSTAGRAM_VIDEO="Instagram 動画のダウンロードを開始..."
            TXT_DOWNLOAD_STARTED_INSTAGRAM_AUDIO="Instagram 音声のダウンロードを開始..."
            TXT_DOWNLOAD_STARTED_TIKTOK_VIDEO="TikTok 動画のダウンロードを開始..."
            TXT_DOWNLOAD_STARTED_TIKTOK_AUDIO="TikTok 音声のダウンロードを開始..."
            TXT_DOWNLOAD_STARTED_YT_VIDEO="YouTube 動画のダウンロードを開始..."
            TXT_DOWNLOAD_STARTED_YT_AUDIO="YouTube 音声 (MP3) のダウンロードを開始..."
            TXT_DOWNLOAD_STARTED_YTPL_VIDEO="YouTube プレイリスト動画のダウンロードを開始..."
            TXT_DOWNLOAD_STARTED_YTPL_AUDIO="YouTube プレイリスト音声 (MP3) のダウンロードを開始..."
            TXT_DOWNLOAD_DONE_PREFIX="ダウンロード完了"
            TXT_LANG_MENU_TITLE="言語選択"
            TXT_LANG_MENU_DESC="言語を選択してください"
            TXT_LANG_AZ="Azərbaycan dili"
            TXT_LANG_TR="Türkçe"
            TXT_LANG_EN="English"
            TXT_LANG_RU="Русский"
            TXT_LANG_AR="اللغة العربية"
            TXT_LANG_ZH="中國人"
            TXT_LANG_JA="日本語"
            TXT_LANG_HI="हिंद भाषा"
            TXT_LANG_CHANGED="言語が変更されました"
            ;;
        HI)
            TXT_INSTALLER_TITLE="Ɍム-ic [✘] इंस्टॉलर"
            TXT_INSTALL_PREP="तैयारी हो रही है"
            TXT_INSTALL_STORAGE="स्टोरेज की अनुमति आवश्यक है"
            TXT_STEP_UPDATE_PKGS="पैकेज अपडेट हो रहे हैं"
            TXT_STEP_INSTALL_PYTHON="Python इंस्टॉल हो रहा है"
            TXT_STEP_INSTALL_FFMPEG="FFmpeg इंस्टॉल हो रहा है"
            TXT_STEP_INSTALL_GIT="Git इंस्टॉल हो रहा है"
            TXT_STEP_UPDATE_YTDLP="yt-dlp अपडेट हो रहा है"
            TXT_STEP_UPDATE_INSTALOADER="instaloader अपडेट हो रहा है"
            TXT_STEP_UPDATE_GDL="gallery-dl अपडेट हो रहा है"
            TXT_STEP_CREATE_DIRS="फ़ोल्डर बनाए जा रहे हैं"
            TXT_STEP_SETUP_URL_OPENER="Termux URL Opener सेट किया जा रहा है"
            TXT_INSTALL_SUCCESS_LINE1="Ɍム-ic [✘] सफलतापूर्वक इंस्टॉल हो गया!"
            TXT_INSTALL_SUCCESS_LINE2="अब टर्मिनल में rxd लिखकर पैनल खोल सकते हैं।"
            TXT_INSTALL_SUCCESS_LINE3="आप किसी भी ऐप से लिंक को Termux के साथ शेयर कर सकते हैं।"

            TXT_MAIN_MENU_TITLE="मुख्य मेनू"
            TXT_MANUAL_MENU_TITLE="मैन्युअल डाउनलोड मेनू"
            TXT_AUTO_MENU_TITLE="ऑटो डाउनलोड मेनू"
            TXT_SETTINGS_MENU_TITLE="सेटिंग्स"
            TXT_MENU_OPTION_MANUAL="मैन्युअल डाउनलोड"
            TXT_MENU_OPTION_AUTO="ऑटो डाउनलोड (लिंक पेस्ट)"
            TXT_MENU_OPTION_SETTINGS="सेटिंग्स"
            TXT_MENU_OPTION_EXIT="बाहर निकलें"
            TXT_MENU_OPTION_BACK="पीछे"
            TXT_MENU_OPTION_LANGUAGE="भाषा"
            TXT_PROMPT_CHOICE="कृपया विकल्प चुनें"
            TXT_PROMPT_LINK="लिंक दर्ज करें"
            TXT_PROMPT_INSTAGRAM_LINK="Instagram लिंक दर्ज करें"
            TXT_PROMPT_TIKTOK_LINK="TikTok लिंक दर्ज करें"
            TXT_PROMPT_YT_SINGLE_LINK="YouTube वीडियो लिंक दर्ज करें"
            TXT_PROMPT_YT_PLAYLIST_LINK="YouTube प्लेलिस्ट लिंक दर्ज करें"
            TXT_PROMPT_CONTINUE="जारी रखने के लिए Enter दबाएँ"
            TXT_ERROR_INVALID_CHOICE="गलत विकल्प!"
            TXT_EXIT_MESSAGE="अलविदा!"
            TXT_AUTO_PLATFORM_INSTAGRAM="प्लैटफ़ॉर्म: Instagram"
            TXT_AUTO_PLATFORM_TIKTOK="प्लैटफ़ॉर्म: TikTok"
            TXT_AUTO_PLATFORM_YT_SINGLE="प्लैटफ़ॉर्म: YouTube (एकल वीडियो)"
            TXT_AUTO_PLATFORM_YT_PLAYLIST="प्लैटफ़ॉर्म: YouTube प्लेलिस्ट"
            TXT_PLATFORM_UNKNOWN="अज्ञात प्लैटफ़ॉर्म!"
            TXT_SUPPORTED_PLATFORMS="समर्थित प्लैटफ़ॉर्म: Instagram, TikTok, YouTube (वीडियो और प्लेलिस्ट)"
            TXT_MENU_YT_MODE_TITLE="YouTube मोड चुनें"
            TXT_MENU_YT_MODE_SINGLE="एकल वीडियो"
            TXT_MENU_YT_MODE_PLAYLIST="प्लेलिस्ट"
            TXT_OPTION_VIDEO_DOWNLOAD="वीडियो डाउनलोड"
            TXT_OPTION_AUDIO_DOWNLOAD="संगीत डाउनलोड (MP3)"
            TXT_OPTION_PLAYLIST_VIDEO="प्लेलिस्ट वीडियो डाउनलोड"
            TXT_OPTION_PLAYLIST_AUDIO="प्लेलिस्ट संगीत डाउनलोड (MP3)"
            TXT_DOWNLOAD_STARTED_INSTAGRAM_VIDEO="Instagram वीडियो डाउनलोड शुरू..."
            TXT_DOWNLOAD_STARTED_INSTAGRAM_AUDIO="Instagram संगीत डाउनलोड शुरू..."
            TXT_DOWNLOAD_STARTED_TIKTOK_VIDEO="TikTok वीडियो डाउनलोड शुरू..."
            TXT_DOWNLOAD_STARTED_TIKTOK_AUDIO="TikTok संगीत डाउनलोड शुरू..."
            TXT_DOWNLOAD_STARTED_YT_VIDEO="YouTube वीडियो डाउनलोड शुरू..."
            TXT_DOWNLOAD_STARTED_YT_AUDIO="YouTube संगीत (MP3) डाउनलोड शुरू..."
            TXT_DOWNLOAD_STARTED_YTPL_VIDEO="YouTube प्लेलिस्ट वीडियो डाउनलोड शुरू..."
            TXT_DOWNLOAD_STARTED_YTPL_AUDIO="YouTube प्लेलिस्ट संगीत (MP3) डाउनलोड शुरू..."
            TXT_DOWNLOAD_DONE_PREFIX="डाउनलोड पूरा हुआ"
            TXT_LANG_MENU_TITLE="भाषा चयन"
            TXT_LANG_MENU_DESC="कृपया भाषा चुनें"
            TXT_LANG_AZ="Azərbaycan dili"
            TXT_LANG_TR="Türkçe"
            TXT_LANG_EN="English"
            TXT_LANG_RU="Русский"
            TXT_LANG_AR="اللغة العربية"
            TXT_LANG_ZH="中國人"
            TXT_LANG_JA="日本語"
            TXT_LANG_HI="हिंद भाषा"
            TXT_LANG_CHANGED="भाषा सफलतापूर्वक बदल दी गई"
            ;;
        *)
            RXD_LANG="AZ"
            rxd_set_lang_vars
            ;;
    esac
}

rxd_set_lang_vars

rxd_banner() {
    clear
    echo -e "\033[1;36m"
    echo "╔══════════════════════════════════════════════╗"
    echo "║                                              ║"
    echo "║            Ɍム-ic [✘] DOWNLOADER             ║"
    echo "║                 $RXD_VERSION                      ║"
    echo "║             Created by Rzayeff Agha          ║"
    echo "║                                              ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "\033[0m"
}

rxd_pulse() {
    local text="$1"
    for i in 1 2 3; do
        printf "\r\033[1;35m$text   \033[0m"
        sleep 0.15
        printf "\r\033[1;35m$text . \033[0m"
        sleep 0.15
        printf "\r\033[1;35m$text ..\033[0m"
        sleep 0.15
        printf "\r\033[1;35m$text ...\033[0m"
        sleep 0.15
    done
    echo
}

rxd_run_step() {
    local message="$1"
    shift
    echo -e "\033[1;33m[RXD]\033[0m $message..."
    ("$@" > /dev/null 2>&1) &
    local pid=$!
    local spin='|/-\'
    local i=0
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) % 4 ))
        printf "\r\033[1;36m[RXD] %s %s\033[0m" "${spin:$i:1}" "$message"
        sleep 0.15
    done
    wait $pid
    printf "\r\033[1;32m[RXD] ✓ %s                          \033[0m\n" "$message"
}

rxd_setup_url_opener() {
    mkdir -p "$HOME/bin"
    cat > "$RXD_OPENER" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
rxd "$1"
EOF
    chmod +x "$RXD_OPENER"
}

rxd_create_folders() {
    mkdir -p "$RXD_DOWNLOAD_BASE/Instagram/Video"
    mkdir -p "$RXD_DOWNLOAD_BASE/Instagram/Music"
    mkdir -p "$RXD_DOWNLOAD_BASE/TikTok/Video"
    mkdir -p "$RXD_DOWNLOAD_BASE/TikTok/Music"
    mkdir -p "$RXD_DOWNLOAD_BASE/YouTube/Video"
    mkdir -p "$RXD_DOWNLOAD_BASE/YouTube/Music"
    mkdir -p "$RXD_DOWNLOAD_BASE/YouTube/Playlist/Video"
    mkdir -p "$RXD_DOWNLOAD_BASE/YouTube/Playlist/Music"
}

rxd_save_config() {
    mkdir -p "$RXD_DIR"
    {
        echo "installed=true"
        echo "version=$RXD_VERSION"
        echo "download_path=$RXD_DOWNLOAD_BASE"
        echo "lang=$RXD_LANG"
    } > "$RXD_CONFIG"
}

rxd_choose_language() {
    echo -e "\n\033[1;36m$TXT_LANG_MENU_TITLE\033[0m"
    echo -e "\033[1;32m$TXT_LANG_MENU_DESC\033[0m\n"
    echo -e "\033[1;33m[1]\033[0m $TXT_LANG_AZ"
    echo -e "\033[1;33m[2]\033[0m $TXT_LANG_TR"
    echo -e "\033[1;33m[3]\033[0m $TXT_LANG_EN"
    echo -e "\033[1;33m[4]\033[0m $TXT_LANG_RU"
    echo -e "\033[1;33m[5]\033[0m $TXT_LANG_AR"
    echo -e "\033[1;33m[6]\033[0m $TXT_LANG_ZH"
    echo -e "\033[1;33m[7]\033[0m $TXT_LANG_JA"
    echo -e "\033[1;33m[8]\033[0m $TXT_LANG_HI\n"
    echo -ne "\033[1;32m$TXT_PROMPT_CHOICE:\033[0m "
    read lang_choice
    case "$lang_choice" in
        1) RXD_LANG="AZ" ;;
        2) RXD_LANG="TR" ;;
        3) RXD_LANG="EN" ;;
        4) RXD_LANG="RU" ;;
        5) RXD_LANG="AR" ;;
        6) RXD_LANG="ZH" ;;
        7) RXD_LANG="JA" ;;
        8) RXD_LANG="HI" ;;
        *) RXD_LANG="AZ" ;;
    esac
    rxd_set_lang_vars
    rxd_save_config
    echo -e "\n\033[1;32m[RXD]\033[0m $TXT_LANG_CHANGED\n"
    sleep 1
}

rxd_install() {
    mkdir -p "$RXD_DIR"
    rxd_banner
    echo -e "\033[1;36m$TXT_INSTALLER_TITLE\033[0m"
    rxd_pulse "$TXT_INSTALL_PREP"

    echo -e "\n\033[1;32m[RXD]\033[0m $TXT_INSTALL_STORAGE..."
    termux-setup-storage
    sleep 1

    rxd_run_step "$TXT_STEP_UPDATE_PKGS" pkg update -y
    rxd_run_step "$TXT_STEP_INSTALL_PYTHON" pkg install python -y
    rxd_run_step "$TXT_STEP_INSTALL_FFMPEG" pkg install ffmpeg -y
    rxd_run_step "$TXT_STEP_INSTALL_GIT" pkg install git -y
    rxd_run_step "$TXT_STEP_UPDATE_YTDLP" python -m pip install -U yt-dlp
    rxd_run_step "$TXT_STEP_UPDATE_INSTALOADER" python -m pip install -U instaloader
    rxd_run_step "$TXT_STEP_UPDATE_GDL" python -m pip install -U gallery-dl
    rxd_run_step "$TXT_STEP_CREATE_DIRS" rxd_create_folders
    rxd_run_step "$TXT_STEP_SETUP_URL_OPENER" rxd_setup_url_opener

    rxd_choose_language

    cp "$0" "$RXD_BIN"
    chmod +x "$RXD_BIN"

    rxd_banner
    echo -e "\033[1;32m╔══════════════════════════════════════╗\033[0m"
    echo -e "\033[1;32m║      ${TXT_INSTALL_SUCCESS_LINE1}      \033[0m"
    echo -e "\033[1;32m╚══════════════════════════════════════╝\033[0m\n"
    echo -e "\033[1;36m${TXT_INSTALL_SUCCESS_LINE2}\033[0m"
    echo -e "\033[1;36m${TXT_INSTALL_SUCCESS_LINE3}\033[0m\n"
    sleep 3
}

rxd_detect_platform() {
    local url="$1"
    if [[ $url == *"instagram.com"* ]] || [[ $url == *"instagr.am"* ]]; then
        echo "instagram"
    elif [[ $url == *"tiktok.com"* ]] || [[ $url == *"vm.tiktok.com"* ]] || [[ $url == *"vt.tiktok.com"* ]]; then
        echo "tiktok"
    elif [[ $url == *"youtube.com/playlist"* ]] || { [[ $url == *"list="* ]] && [[ $url == *"youtube.com"* ]]; }; then
        echo "youtube_playlist"
    elif [[ $url == *"youtube.com"* ]] || [[ $url == *"youtu.be"* ]]; then
        echo "youtube"
    else
        echo "unknown"
    fi
}

rxd_download_instagram() {
    local url="$1"
    local type="$2"
    if [ "$type" = "video" ]; then
        local output_dir="$RXD_DOWNLOAD_BASE/Instagram/Video"
        mkdir -p "$output_dir"
        echo -e "\n\033[1;33m[RXD]\033[0m $TXT_DOWNLOAD_STARTED_INSTAGRAM_VIDEO\n"
        yt-dlp --newline -f "best" --merge-output-format mp4 -o "$output_dir/%(title)s.%(ext)s" "$url"
    else
        local output_dir="$RXD_DOWNLOAD_BASE/Instagram/Music"
        mkdir -p "$output_dir"
        echo -e "\n\033[1;33m[RXD]\033[0m $TXT_DOWNLOAD_STARTED_INSTAGRAM_AUDIO\n"
        yt-dlp --newline -f "bestaudio/best" --extract-audio --audio-format mp3 --audio-quality 0 -o "$output_dir/%(title)s.%(ext)s" "$url"
    fi
    echo -e "\n\033[1;32m[RXD]\033[0m $TXT_DOWNLOAD_DONE_PREFIX: $output_dir\n"
}

rxd_download_tiktok() {
    local url="$1"
    local type="$2"
    if [ "$type" = "video" ]; then
        local output_dir="$RXD_DOWNLOAD_BASE/TikTok/Video"
        mkdir -p "$output_dir"
        echo -e "\n\033[1;33m[RXD]\033[0m $TXT_DOWNLOAD_STARTED_TIKTOK_VIDEO\n"
        yt-dlp --newline -f "best" --merge-output-format mp4 -o "$output_dir/%(title)s.%(ext)s" "$url"
    else
        local output_dir="$RXD_DOWNLOAD_BASE/TikTok/Music"
        mkdir -p "$output_dir"
        echo -e "\n\033[1;33m[RXD]\033[0m $TXT_DOWNLOAD_STARTED_TIKTOK_AUDIO\n"
        yt-dlp --newline -f "bestaudio/best" --extract-audio --audio-format mp3 --audio-quality 0 -o "$output_dir/%(title)s.%(ext)s" "$url"
    fi
    echo -e "\n\033[1;32m[RXD]\033[0m $TXT_DOWNLOAD_DONE_PREFIX: $output_dir\n"
}

rxd_download_youtube_single() {
    local url="$1"
    local type="$2"
    if [ "$type" = "video" ]; then
        local output_dir="$RXD_DOWNLOAD_BASE/YouTube/Video"
        mkdir -p "$output_dir"
        echo -e "\n\033[1;33m[RXD]\033[0m $TXT_DOWNLOAD_STARTED_YT_VIDEO\n"
        yt-dlp --newline -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" --merge-output-format mp4 -o "$output_dir/%(title)s.%(ext)s" "$url"
    else
        local output_dir="$RXD_DOWNLOAD_BASE/YouTube/Music"
        mkdir -p "$output_dir"
        echo -e "\n\033[1;33m[RXD]\033[0m $TXT_DOWNLOAD_STARTED_YT_AUDIO\n"
        yt-dlp --newline -f "bestaudio/best" --extract-audio --audio-format mp3 --audio-quality 0 -o "$output_dir/%(title)s.%(ext)s" "$url"
    fi
    echo -e "\n\033[1;32m[RXD]\033[0m $TXT_DOWNLOAD_DONE_PREFIX: $output_dir\n"
}

rxd_download_youtube_playlist() {
    local url="$1"
    local type="$2"
    if [ "$type" = "video" ]; then
        local output_dir="$RXD_DOWNLOAD_BASE/YouTube/Playlist/Video"
        mkdir -p "$output_dir"
        echo -e "\n\033[1;33m[RXD]\033[0m $TXT_DOWNLOAD_STARTED_YTPL_VIDEO\n"
        yt-dlp --newline --yes-playlist -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" --merge-output-format mp4 -o "$output_dir/%(playlist_title)s - %(playlist_index)s - %(title)s.%(ext)s" "$url"
    else
        local output_dir="$RXD_DOWNLOAD_BASE/YouTube/Playlist/Music"
        mkdir -p "$output_dir"
        echo -e "\n\033[1;33m[RXD]\033[0m $TXT_DOWNLOAD_STARTED_YTPL_AUDIO\n"
        yt-dlp --newline --yes-playlist -f "bestaudio/best" --extract-audio --audio-format mp3 --audio-quality 0 -o "$output_dir/%(playlist_title)s - %(playlist_index)s - %(title)s.%(ext)s" "$url"
    fi
    echo -e "\n\033[1;32m[RXD]\033[0m $TXT_DOWNLOAD_DONE_PREFIX: $output_dir\n"
}

rxd_manual_menu() {
    while true; do
        rxd_banner
        echo -e "\033[1;36m╔══════════════════════════════════════════════╗\033[0m"
        echo -e "\033[1;36m║           $TXT_MANUAL_MENU_TITLE             ║\033[0m"
        echo -e "\033[1;36m╚══════════════════════════════════════════════╝\033[0m\n"
        echo -e "\033[1;33m[1]\033[0m Instagram"
        echo -e "\033[1;33m[2]\033[0m TikTok"
        echo -e "\033[1;33m[3]\033[0m YouTube"
        echo -e "\033[1;31m[0]\033[0m $TXT_MENU_OPTION_BACK\n"
        echo -ne "\033[1;32m$TXT_PROMPT_CHOICE:\033[0m "
        read platform_choice

        case $platform_choice in
            1)
                echo -ne "\n\033[1;36m$TXT_PROMPT_INSTAGRAM_LINK:\033[0m "
                read ig_url
                echo -e "\n\033[1;33m[1]\033[0m $TXT_OPTION_VIDEO_DOWNLOAD"
                echo -e "\033[1;33m[2]\033[0m $TXT_OPTION_AUDIO_DOWNLOAD\n"
                echo -ne "\033[1;32m$TXT_PROMPT_CHOICE:\033[0m "
                read ig_type
                case $ig_type in
                    1) rxd_download_instagram "$ig_url" "video" ;;
                    2) rxd_download_instagram "$ig_url" "audio" ;;
                    *) echo -e "\033[1;31m[RXD]\033[0m $TXT_ERROR_INVALID_CHOICE" ;;
                esac
                echo -e "\n\033[1;36m$TXT_PROMPT_CONTINUE...\033[0m"
                read
                ;;
            2)
                echo -ne "\n\033[1;36m$TXT_PROMPT_TIKTOK_LINK:\033[0m "
                read tt_url
                echo -e "\n\033[1;33m[1]\033[0m $TXT_OPTION_VIDEO_DOWNLOAD"
                echo -e "\033[1;33m[2]\033[0m $TXT_OPTION_AUDIO_DOWNLOAD\n"
                echo -ne "\033[1;32m$TXT_PROMPT_CHOICE:\033[0m "
                read tt_type
                case $tt_type in
                    1) rxd_download_tiktok "$tt_url" "video" ;;
                    2) rxd_download_tiktok "$tt_url" "audio" ;;
                    *) echo -e "\033[1;31m[RXD]\033[0m $TXT_ERROR_INVALID_CHOICE" ;;
                esac
                echo -e "\n\033[1;36m$TXT_PROMPT_CONTINUE...\033[0m"
                read
                ;;
            3)
                while true; do
                    echo -e "\n\033[1;36m$TXT_MENU_YT_MODE_TITLE:\033[0m"
                    echo -e "\033[1;33m[1]\033[0m $TXT_MENU_YT_MODE_SINGLE"
                    echo -e "\033[1;33m[2]\033[0m $TXT_MENU_YT_MODE_PLAYLIST"
                    echo -e "\033[1;31m[0]\033[0m $TXT_MENU_OPTION_BACK\n"
                    echo -ne "\033[1;32m$TXT_PROMPT_CHOICE:\033[0m "
                    read yt_mode
                    case $yt_mode in
                        1)
                            echo -ne "\n\033[1;36m$TXT_PROMPT_YT_SINGLE_LINK:\033[0m "
                            read yt_single_url
                            echo -e "\n\033[1;33m[1]\033[0m $TXT_OPTION_VIDEO_DOWNLOAD"
                            echo -e "\033[1;33m[2]\033[0m $TXT_OPTION_AUDIO_DOWNLOAD\n"
                            echo -ne "\033[1;32m$TXT_PROMPT_CHOICE:\033[0m "
                            read yt_type
                            case $yt_type in
                                1) rxd_download_youtube_single "$yt_single_url" "video" ;;
                                2) rxd_download_youtube_single "$yt_single_url" "audio" ;;
                                *) echo -e "\033[1;31m[RXD]\033[0m $TXT_ERROR_INVALID_CHOICE" ;;
                            esac
                            echo -e "\n\033[1;36m$TXT_PROMPT_CONTINUE...\033[0m"
                            read
                            break
                            ;;
                        2)
                            echo -ne "\n\033[1;36m$TXT_PROMPT_YT_PLAYLIST_LINK:\033[0m "
                            read yt_pl_url
                            echo -e "\n\033[1;33m[1]\033[0m $TXT_OPTION_PLAYLIST_VIDEO"
                            echo -e "\033[1;33m[2]\033[0m $TXT_OPTION_PLAYLIST_AUDIO\n"
                            echo -ne "\033[1;32m$TXT_PROMPT_CHOICE:\033[0m "
                            read yt_pl_type
                            case $yt_pl_type in
                                1) rxd_download_youtube_playlist "$yt_pl_url" "video" ;;
                                2) rxd_download_youtube_playlist "$yt_pl_url" "audio" ;;
                                *) echo -e "\033[1;31m[RXD]\033[0m $TXT_ERROR_INVALID_CHOICE" ;;
                            esac
                            echo -e "\n\033[1;36m$TXT_PROMPT_CONTINUE...\033[0m"
                            read
                            break
                            ;;
                        0)
                            break
                            ;;
                        *)
                            echo -e "\033[1;31m[RXD]\033[0m $TXT_ERROR_INVALID_CHOICE"
                            ;;
                    esac
                done
                ;;
            0)
                break
                ;;
            *)
                echo -e "\033[1;31m[RXD]\033[0m $TXT_ERROR_INVALID_CHOICE"
                sleep 2
                ;;
        esac
    done
}

rxd_auto_download() {
    local url="$1"
    rxd_banner
    echo -e "\033[1;36m╔══════════════════════════════════════════════╗\033[0m"
    echo -e "\033[1;36m║             $TXT_AUTO_MENU_TITLE             ║\033[0m"
    echo -e "\033[1;36m╚══════════════════════════════════════════════╝\033[0m\n"

    local platform
    platform=$(rxd_detect_platform "$url")

    case $platform in
        instagram)
            echo -e "\033[1;32m[RXD]\033[0m $TXT_AUTO_PLATFORM_INSTAGRAM\n"
            echo -e "\033[1;33m[1]\033[0m $TXT_OPTION_VIDEO_DOWNLOAD"
            echo -e "\033[1;33m[2]\033[0m $TXT_OPTION_AUDIO_DOWNLOAD\n"
            echo -ne "\033[1;32m$TXT_PROMPT_CHOICE:\033[0m "
            read choice
            case $choice in
                1) rxd_download_instagram "$url" "video" ;;
                2) rxd_download_instagram "$url" "audio" ;;
                *) echo -e "\033[1;31m[RXD]\033[0m $TXT_ERROR_INVALID_CHOICE" ;;
            esac
            ;;
        tiktok)
            echo -e "\033[1;32m[RXD]\033[0m $TXT_AUTO_PLATFORM_TIKTOK\n"
            echo -e "\033[1;33m[1]\033[0m $TXT_OPTION_VIDEO_DOWNLOAD"
            echo -e "\033[1;33m[2]\033[0m $TXT_OPTION_AUDIO_DOWNLOAD\n"
            echo -ne "\033[1;32m$TXT_PROMPT_CHOICE:\033[0m "
            read choice
            case $choice in
                1) rxd_download_tiktok "$url" "video" ;;
                2) rxd_download_tiktok "$url" "audio" ;;
                *) echo -e "\033[1;31m[RXD]\033[0m $TXT_ERROR_INVALID_CHOICE" ;;
            esac
            ;;
        youtube)
            echo -e "\033[1;32m[RXD]\033[0m $TXT_AUTO_PLATFORM_YT_SINGLE\n"
            echo -e "\033[1;33m[1]\033[0m $TXT_OPTION_VIDEO_DOWNLOAD"
            echo -e "\033[1;33m[2]\033[0m $TXT_OPTION_AUDIO_DOWNLOAD\n"
            echo -ne "\033[1;32m$TXT_PROMPT_CHOICE:\033[0m "
            read choice
            case $choice in
                1) rxd_download_youtube_single "$url" "video" ;;
                2) rxd_download_youtube_single "$url" "audio" ;;
                *) echo -e "\033[1;31m[RXD]\033[0m $TXT_ERROR_INVALID_CHOICE" ;;
            esac
            ;;
        youtube_playlist)
            echo -e "\033[1;32m[RXD]\033[0m $TXT_AUTO_PLATFORM_YT_PLAYLIST\n"
            echo -e "\033[1;33m[1]\033[0m $TXT_OPTION_PLAYLIST_VIDEO"
            echo -e "\033[1;33m[2]\033[0m $TXT_OPTION_PLAYLIST_AUDIO\n"
            echo -ne "\033[1;32m$TXT_PROMPT_CHOICE:\033[0m "
            read choice
            case $choice in
                1) rxd_download_youtube_playlist "$url" "video" ;;
                2) rxd_download_youtube_playlist "$url" "audio" ;;
                *) echo -e "\033[1;31m[RXD]\033[0m $TXT_ERROR_INVALID_CHOICE" ;;
            esac
            ;;
        *)
            echo -e "\033[1;31m[RXD]\033[0m $TXT_PLATFORM_UNKNOWN"
            echo -e "\033[1;33m$TXT_SUPPORTED_PLATFORMS\033[0m"
            ;;
    esac
}

rxd_settings_menu() {
    while true; do
        rxd_banner
        echo -e "\033[1;36m╔══════════════════════════════════════════════╗\033[0m"
        echo -e "\033[1;36m║              $TXT_SETTINGS_MENU_TITLE              ║\033[0m"
        echo -e "\033[1;36m╚══════════════════════════════════════════════╝\033[0m\n"
        echo -e "\033[1;33m[1]\033[0m $TXT_MENU_OPTION_LANGUAGE"
        echo -e "\033[1;31m[0]\033[0m $TXT_MENU_OPTION_BACK\n"
        echo -ne "\033[1;32m$TXT_PROMPT_CHOICE:\033[0m "
        read settings_choice
        case "$settings_choice" in
            1)
                rxd_choose_language
                ;;
            0)
                break
                ;;
            *)
                echo -e "\033[1;31m[RXD]\033[0m $TXT_ERROR_INVALID_CHOICE"
                sleep 2
                ;;
        esac
    done
}

rxd_main_menu() {
    while true; do
        rxd_banner
        echo -e "\033[1;36m╔══════════════════════════════════════════════╗\033[0m"
        echo -e "\033[1;36m║           Ɍム-ic [✘] $TXT_MAIN_MENU_TITLE           ║\033[0m"
        echo -e "\033[1;36m╚══════════════════════════════════════════════╝\033[0m\n"
        echo -e "\033[1;33m[1]\033[0m $TXT_MENU_OPTION_MANUAL"
        echo -e "\033[1;33m[2]\033[0m $TXT_MENU_OPTION_AUTO"
        echo -e "\033[1;33m[3]\033[0m $TXT_MENU_OPTION_SETTINGS"
        echo -e "\033[1;31m[0]\033[0m $TXT_MENU_OPTION_EXIT\n"
        echo -ne "\033[1;32m$TXT_PROMPT_CHOICE:\033[0m "
        read main_choice

        case $main_choice in
            1)
                rxd_manual_menu
                ;;
            2)
                echo -ne "\n\033[1;36m$TXT_PROMPT_LINK:\033[0m "
                read auto_url
                rxd_auto_download "$auto_url"
                echo -e "\n\033[1;36m$TXT_PROMPT_CONTINUE...\033[0m"
                read
                ;;
            3)
                rxd_settings_menu
                ;;
            0)
                rxd_banner
                echo -e "\033[1;32m[RXD]\033[0m $TXT_EXIT_MESSAGE\n"
                exit 0
                ;;
            *)
                echo -e "\033[1;31m[RXD]\033[0m $TXT_ERROR_INVALID_CHOICE"
                sleep 2
                ;;
        esac
    done
}

if [ -f "$RXD_CONFIG" ]; then
    . "$RXD_CONFIG"
    if [ -n "$download_path" ]; then
        RXD_DOWNLOAD_BASE="$download_path"
    fi
    if [ -n "$lang" ]; then
        RXD_LANG="$lang"
    fi
fi

rxd_set_lang_vars

if [ "$installed" != "true" ] || [ "$version" != "$RXD_VERSION" ]; then
    rxd_install
fi

if [ $# -eq 0 ]; then
    rxd_main_menu
else
    rxd_auto_download "$1"
fi

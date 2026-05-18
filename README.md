> [BETA]
> `bəzi buglar ola bilər`

# Ɍム-ic LM Downloader 

Android + Termux üçün hazırlanmış çoxplatformalı media yükləyici.  
Instagram, TikTok, YouTube, Twitter, Facebook, SoundCloud, Pinterest, Reddit, Vimeo və daha çox platformadan video və audio endirir.

> Versiya: **LM-V26.0-ULTRA (BETA)**  
> Əsas əmr: **`lm`**  
> ![Platform](https://img.shields.io/badge/platform-Termux-green.svg)
> ![Status](https://img.shields.io/badge/status-beta-orange.svg)

---

## 🧩 Nədir bu Ɍム-ic LM Downloader?

`Ɍム-ic LM Downloader` – konsol əsaslı, sürətli, modern və rəngli interfeysə sahib media yükləmə panelidir.  
Məqsəd: reklamsız, ağır tətbiqlərsiz, sadə bir terminal paneli ilə istədiyin videonu və ya audionu endirmək.

---

## ✨ Əsas Xüsusiyyətlər

- 🎯 **Geniş platforma dəstəyi:**
  - Instagram (video + audio)
  - TikTok (video + audio)
  - YouTube:
    - Tək video (video + audio + keyfiyyət seçimi)
    - Playlist (video + audio + keyfiyyət seçimi)
    - Kanal (video + audio + keyfiyyət seçimi)
  - Twitter/X (video + audio)
  - Facebook (video + audio)
  - SoundCloud (audio)
  - Pinterest (video)
  - Reddit (video)
  - Vimeo (video)

- ⚡ **Paralel Növbə Meneceri:**
  - Linkləri növbəyə əlavə edib, eyni anda birdən çox (tənzimlənən sayda) yükləmə
  - Növbəni idarə etmə (sil, təmizlə, siyahıya bax)

- 🔗 **Qısayol Sistemi:**
  - Tez-tez istifadə etdiyin platforma/rejim kombinasiyalarını saxla
  - Bir əmrlə qısayolu işə sal

- 🤖 **Telegram Bot İnteqrasiyası:**
  - Telegram botu vasitəsilə uzaqdan link göndərərək yükləmə
  - `/stats` əmri ilə statistikaya baxış

- 📊 **Statistika Panelı:**
  - Platformalar üzrə ümumi, uğurlu, uğursuz yükləmə statistikası
  - Uğur nisbəti göstəricisi

- 📁 **Fayl Meneceri:**
  - Yüklənmiş faylları platformalara görə siyahıya baxma
  - Qovluq yolu və fayl ölçülərini göstərmə

- 🧠 **Ağıllı Keyfiyyət Seçimi:**
  - Şəbəkə sürətinə görə avtomatik uyğun keyfiyyət tövsiyəsi
  - Manual seçim (1080p/720p/480p/360p) və ya avtomatik rejim

- 🔄 **Auto-share dəstəyi:**
  - İstənilən tətbiqdən “Paylaş / Share → Termux” edərək linki birbaşa `lm` panelinə ötürmə

- 🌐 **Çoxdilli sistem (8 dil):**
  - Azərbaycan dili (defolt)
  - Türkçe
  - English
  - Русский
  - اللغة العربية
  - 中國人
  - 日本語
  - हिंद भाषा  
  İlk quraşdırmada dil soruşulur, sonradan menyudan dəyişmək olur.

- 📁 **Avtomatik təşkil:**
  - Yüklənən fayllar telefon yaddaşında xüsusi qovluq strukturunda saxlanılır

- 🔍 **Daxili YouTube Axtarış:**
  - Mahnı və ya açar söz ilə birbaşa terminaldan axtarış edib yükləmə

- 🎬 **Altyazı dəstəyi (YouTube):**
  - Video ilə birlikdə altyazı endirmə (dil seçimi ilə)

---

## ⚙️ Tələblər

- Android cihaz
- [Termux](https://termux.dev/)
- Stabil internet bağlantısı

---

## 🚀 Quraşdırma (qısa təlimat)

> Birbaşa [BETA]
  
     bash <(curl -s https://raw.githubusercontent.com/rzayevaga/raicx-downloader/main/lm.sh)


1. **Termux-u aç:**
   - İlk dəfə açırsansa, storage icazəsi üçün:
     ```bash
     termux-setup-storage
     ```

2. **Repo-nu klonla:**
   ```bash
   git clone https://github.com/rzayevaga/raicx-downloader.git
   cd raicx-downloader
    ```

1. Skripti icra oluna bilən et:
   ```bash
   chmod +x lm.sh
   ```
2. Quraşdırmanı işə sal:
   ```bash
   ./lm.sh
   ```
   Quraşdırma bitdikdən sonra sistem lm əmrini tanıyır.
3. Panelə daxil ol:
   ```bash
   lm
   ```
   və ya hər hansı linki Termux ilə paylaş.

---

🧭 Menyu Strukturu

# Menyu Açıqlama
- 1 Manual Yükləmə Platforma seçib əl ilə link daxil etmə
- 2 Auto Yükləmə Linki yapışdır, avtomatik tanıyıb endir
- 3 Parametrlər Dil və paralel yükləmə sayı tənzimləmə
- 4 Admin Panel Yeniləmə, keş təmizləmə, sistem məlumatı, Telegram Bot
- 5 Axtarış YouTube-da açar sözlə axtarış edib yükləmə
- 6 Çoxlu Link Yüklə Birdən çox linki fayldan və ya əl ilə yükləmə
- 7 Növbə Meneceri Link növbəsi yarat, paralel işlə
- 8 Qısayollar Platforma/rejim qısayollarını idarə et
- 9 Fayl Meneceri Platformalar üzrə yüklənmiş fayllara baxış
- 10 Statistika Yükləmə tarixçəsinin analitikası

---

👤 Müəllif

· Author: Rzayeff Agha
· Project: Ɍム-ic LM Downloader (raicx-downloader)
· Platform: Termux / Android

---

⚠️ Hüquqi Qaydalar və Məhdudiyyətlər

Bu layihə:

· şəxsi istifadən üçün nəzərdə tutulub;
· üçüncü tərəf platformaların (YouTube, Instagram, TikTok və s.) istifadə şərtlərinə əməl etmək məsuliyyəti tamamilə istifadəçiyə aiddir;
· müəllif hüquqları ilə qorunan kontentin icazəsiz yüklənməsi və paylaşılması qanunvericiliyə zidd ola bilər.

🔒 Modifikasiya və yenidən paylaşma

Bu repo ictimai açıq kod kimi görünsə də:

Kodun icazəsiz:

· dəyişdirilməsi,
· başqa adla paylaşılması,
· yeni layihə kimi təqdim edilməsi

Qadağandır.

Layihə şəxsi istifadə üçündür. Özün üçün lokalda düzəliş edə bilərsən, amma onu public fork, yenidən yayımlama və ya rebranding etmək müəllif icazəsi olmadan qəti şəkildə icazəli deyil.

---

⭐ Dəstək

Layihə xoşuna gəlibsə:

· Repo-ya star verə bilərsən
· Bug / xəta ilə qarşılaşsan, Issues bölməsindən yaza bilərsən

---

Ɍム-ic LM Downloader – sadəcə lm yaz, qalanını özü həll edir.

> License: Custom, All Rights Reserved – personal use only, no modification or redistribution without permission.

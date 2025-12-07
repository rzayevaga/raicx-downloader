# Ɍム-ic [✘] Downloader

Android + Termux üçün hazırlanmış çoxplatformalı media yükləyici.  
Instagram, TikTok və YouTube kontentini (video + audio, YouTube playlist daxil olmaqla) birbaşa telefonuna endirir.

> Versiya: **X-5.5**  
> Əsas əmr: **`rxd`**  
> ![Platform](https://img.shields.io/badge/platform-Termux-green.svg)
> ![Status](https://img.shields.io/badge/status-active-success.svg)
---

## 🧩 Nədir bu Ɍム-ic [✘]?

`Ɍム-ic [✘] Downloader` – konsol əsaslı, sürətli, modern və rəngli interfeysə sahib media yükləmə panelidir.  
Məqsəd: reklamsız, ağır tətbiqlərsiz, sadə bir terminal paneli ilə istədiyin videonu və ya audionu endirmək.

---

## ✨ Əsas Xüsusiyyətlər

- 🎯 **Dəstəklənən platformalar:**
  - Instagram (video + audio)
  - TikTok (video + audio)
  - YouTube:
    - Tək video (video + audio)
    - Playlist (bütün video və ya bütün audio)

- 🎵 **Audio çıxarma:**
  - Videolardan MP3 formatında səs çıxarma

- ⚡ **Sürətli konsol interfeysi:**
  - Rəngli menyular
  - Animasiya ilə quraşdırma addımları
  - Sadə və anlaşılan seçim sistemi

- 🔄 **Auto-share dəstəyi:**
  - İstənilən tətbiqdən “Paylaş / Share → Termux” edərək linki birbaşa `rxd` panelinə ötürmə

- 🌐 **Çoxdilli sistem:**
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
    (istifadəçi üçün əlçatan, lakin README-də dəqiq path göstərilmir)

---

## ⚙️ Tələblər

- Android cihaz
- [Termux](https://termux.dev/)
- Stabil internet bağlantısı

---

## 🚀 Quraşdırma (qısa təlimat)

1. **Termux-u aç:**
   - İlk dəfə açırsansa, storage icazəsi üçün:
     ```bash
     termux-setup-storage
     ```

2. **Repo-nu klonla:**
   ```bash
   git clone https://github.com/rzayevaga/raicx-downloader.git
   cd raicx-downloader

3. Skripti icra oluna bilən et:

chmod +x rxd.sh


4. Quraşdırmanı işə sal:

./rxd.sh



Quraşdırma bitdikdən sonra sistem rxd əmrini tanıyır və panelə daxil olmaq üçün sadəcə:

rxd

yazmağın kifayətdir.


---

🖥 İşləmə Prinsipi

1. Əsas menyu

rxd yazdıqda qarşına 3 əsas seçim çıxır:

[1] Manual Yükləmə

[2] Auto Yükləmə (Link yapışdır və ya Share → Termux)

[3] Parametrlər (Dil və s.)

[0] Çıxış



---

2. Manual Yükləmə

Menu → [1] Manual Yükləmə

Buradan:

Instagram

TikTok

YouTube


seçirsən.

Hər platformada:

Link daxil edirsən

Video və ya Audio (MP3) seçirsən

YouTube üçün əlavə olaraq:

Tək Video

Playlist



Seçimdən sonra fayllar avtomatik yüklənir və telefon yaddaşında saxlanılır.


---

3. Auto Yükləmə

Menu → [2] Auto Yükləmə

İki istifadə forması var:

1. Termux-da birbaşa linki yapışdırırsan:

Skript linkdən platformanı özü tanıyır

Səndən yalnız video / audio seçimi istəyir



2. Hər hansı tətbiqdən (Instagram, TikTok, YouTube, browser və s.)

Paylaş / Share → Termux seçirsən

Termux avtomatik rxd ilə açılır

Paneldə videonu və ya audionu seçib yükləyirsən





---

4. Dil Parametri

Menu → [3] Parametrlər → Dil

Mövcud dillərdən birini seçməklə bütün menyu, mesajlar və promtlar həmin dilə keçir.

İlkin quraşdırmada da dil soruşulur və yadda saxlanılır.



---

👤 Müəllif

Author: Rzayeff Agha

Project: Ɍム-ic [✘] Downloader (raicx-downloader)

Platform: Termux / Android



---

⚠️ Hüquqi Qaydalar və Məhdudiyyətlər

Bu layihə:

şəxsi istifadən üçün nəzərdə tutulub;

üçüncü tərəf platformaların (YouTube, Instagram, TikTok və s.) istifadə şərtlərinə əməl etmək məsuliyyəti tamamilə istifadəçiyə aiddir;

müəllif hüquqları ilə qorunan kontentin icazəsiz yüklənməsi və paylaşılması qanunvericiliyə zidd ola bilər.


🔒 Modifikasiya və yenidən paylaşma

Bu repo ictimai açıq kod kimi görünsə də:

Kodun icazəsiz:

dəyişdirilməsi,

başqa adla paylaşılması,

yeni layihə kimi təqdim edilməsi


Qadağandır.


Layihə şəxsi istifadə üçündür. Özün üçün lokalda düzəliş edə bilərsən, amma onu public fork, yenidən yayımlama və ya rebranding etmək müəllif icazəsi olmadan qəti şəkildə icazəli deyil.


---

⭐ Dəstək

Layihə xoşuna gəlibsə:

Repo-ya star verə bilərsən

Bug / xəta ilə qarşılaşsan, Issues bölməsindən yaza bilərsən


Ɍム-ic [✘] Downloader – sadəcə rxd yaz, qalanını özü həll edir.

> License: Custom, All Rights Reserved – personal use only, no modification or redistribution without permission.

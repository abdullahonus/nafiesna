# NafieSna — Firebase Cloud Functions

YouTube canlı yayın kontrolü ve FCM push bildirim gönderimi.

## Kurulum

```bash
cd functions
npm install
```

## YouTube API Key Ayarı

```bash
firebase functions:config:set youtube.api_key="YOUR_YOUTUBE_DATA_API_V3_KEY"
```

Veya Firebase Functions v2 parametreleri ile:

```bash
firebase functions:params:set YOUTUBE_API_KEY
```

## Deploy

```bash
firebase deploy --only functions
```

## Nasıl Çalışır?

1. `checkYouTubeLive` fonksiyonu her **5 dakikada** bir çalışır
2. YouTube Data API v3 ile `@NafiEsna` kanalının canlı yayın durumunu kontrol eder
3. Eğer yeni bir canlı yayın başladıysa (önceki kontrol "offline" idi):
   - `live_stream` topic'ine FCM push bildirim gönderir
   - Firestore'da durumu günceller
4. Zaten canlıysa tekrar bildirim göndermez (duplicate engeli)

## Firestore Yapısı

```
config/live_state
├── isLive: boolean
├── lastCheck: timestamp
├── videoId: string (eğer canlıysa)
└── title: string (eğer canlıysa)
```

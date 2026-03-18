const { onSchedule } = require("firebase-functions/v2/scheduler");
const { defineString } = require("firebase-functions/params");
const admin = require("firebase-admin");
const fetch = require("node-fetch");

admin.initializeApp();

const YOUTUBE_API_KEY = defineString("YOUTUBE_API_KEY");
const CHANNEL_HANDLE = "@NafiEsna";
const BASE_URL = "https://www.googleapis.com/youtube/v3";

let cachedChannelId = null;

async function getChannelId(apiKey) {
  if (cachedChannelId) return cachedChannelId;

  const url =
    `${BASE_URL}/channels?part=id&forHandle=${CHANNEL_HANDLE}&key=${apiKey}`;
  const res = await fetch(url);
  const data = await res.json();

  if (!data.items || data.items.length === 0) {
    throw new Error(`Channel not found: ${CHANNEL_HANDLE}`);
  }

  cachedChannelId = data.items[0].id;
  return cachedChannelId;
}

// Her 5 dakikada bir çalışır
exports.checkYouTubeLive = onSchedule(
  {
    schedule: "every 5 minutes",
    timeZone: "Europe/Istanbul",
    region: "europe-west1",
  },
  async () => {
    const apiKey = YOUTUBE_API_KEY.value();

    try {
      const channelId = await getChannelId(apiKey);

      const searchUrl =
        `${BASE_URL}/search?part=snippet&channelId=${channelId}` +
        `&type=video&eventType=live&key=${apiKey}&maxResults=1`;

      const res = await fetch(searchUrl);
      const data = await res.json();

      const isLive = data.items && data.items.length > 0;

      // Firestore'da son durumu kontrol et (tekrar bildirim göndermemek için)
      const db = admin.firestore();
      const stateRef = db.collection("config").doc("live_state");
      const stateDoc = await stateRef.get();
      const wasLive = stateDoc.exists ? stateDoc.data().isLive : false;

      if (isLive && !wasLive) {
        // Yeni yayın başladı — bildirim gönder
        const title = data.items[0].snippet.title || "Canlı Yayın";
        const videoId = data.items[0].id.videoId;

        await admin.messaging().send({
          topic: "live_stream",
          notification: {
            title: "🔴 NafiEsna Canlı Yayında!",
            body: title,
          },
          data: {
            type: "live_stream",
            videoId: videoId,
            url: `https://www.youtube.com/watch?v=${videoId}`,
          },
          android: {
            priority: "high",
            notification: {
              channelId: "live_stream",
              priority: "max",
              sound: "default",
            },
          },
          apns: {
            payload: {
              aps: {
                sound: "default",
                badge: 1,
              },
            },
          },
        });

        console.log(`Notification sent for: ${title}`);
      }

      // Durumu güncelle
      await stateRef.set({
        isLive: isLive,
        lastCheck: admin.firestore.FieldValue.serverTimestamp(),
        ...(isLive && {
          videoId: data.items[0].id.videoId,
          title: data.items[0].snippet.title,
        }),
      });

      console.log(`Live check: ${isLive ? "LIVE" : "offline"}`);
    } catch (error) {
      console.error("YouTube live check error:", error);
    }
  }
);

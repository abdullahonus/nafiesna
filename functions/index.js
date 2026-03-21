const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");
const { onDocumentCreated } = require("firebase-functions/v2/firestore");

initializeApp();

/**
 * Broadcast Chat Bildirimi
 *
 * Tetikleyici: broadcast_chat/room/messages/{msgId} koleksiyonuna
 *              yeni belge eklendiğinde çalışır.
 *
 * Aksiyon: Tüm "chat_messages" topic abonelerine FCM push gönderir.
 *
 * Not: Message data'ya type:"chat" ekleniyor.
 *      Flutter tarafı bu alana bakarak bildirim kanalını seçer
 *      ve sohbet ekranı açıksa bildirimi bastırır.
 */
exports.onNewChatMessage = onDocumentCreated(
  "broadcast_chat/room/messages/{msgId}",
  async (event) => {
    const data = event.data?.data();
    if (!data) return;

    const text = data.text ?? "";
    const sender = data.senderEmail ?? "sultan";

    // Kısa önizleme: 80 karakterden fazlaysa kes
    const preview = text.length > 80 ? text.substring(0, 77) + "…" : text;

    const message = {
      topic: "chat_messages",
      notification: {
        title: "🕌 Sohbet Odası — sultan",
        body: preview,
      },
      data: {
        type: "chat",   // Flutter'da bildirim kanalını ve suppression'ı belirler
        msgId: event.params.msgId,
      },
      android: {
        priority: "high",
        notification: {
          channelId: "chat_channel_v1",
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
    };

    try {
      const response = await getMessaging().send(message);
      console.log("Chat bildirimi gönderildi:", response);
    } catch (err) {
      console.error("Chat bildirimi gönderilemedi:", err);
    }
  }
);

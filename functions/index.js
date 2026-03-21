const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");
const { getAuth } = require("firebase-admin/auth");
const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { onCall, HttpsError } = require("firebase-functions/v2/https");

initializeApp();

// ── Yeni şifre (ilk girişten sonra kullanıcının şifresi buna değişir) ──────
const NEW_PASSWORD_AFTER_ACTIVATION = "Abdullah.0547";

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

/**
 * Tek Cihaz Kilitleme — İlk Giriş Aktivasyonu
 *
 * Flutter'dan callable olarak çağrılır.
 * - Kullanıcı uid'sine ait Firestore belgesi yoksa oluşturur.
 * - deviceId'yi kaydeder.
 * - Kullanıcının şifresini değiştirir.
 *
 * data: { deviceId: string }
 */
exports.activateAccount = onCall(async (request) => {
  // Oturum açmış kullanıcı gerekli
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Giriş yapılmamış.");
  }

  const uid = request.auth.uid;
  const deviceId = request.data?.deviceId;

  if (!deviceId || typeof deviceId !== "string") {
    throw new HttpsError("invalid-argument", "deviceId gereklidir.");
  }

  const db = getFirestore();
  const userRef = db.collection("users").doc(uid);
  const userDoc = await userRef.get();

  if (userDoc.exists) {
    const existingDeviceId = userDoc.data()?.deviceId;
    if (existingDeviceId && existingDeviceId !== deviceId) {
      throw new HttpsError(
        "permission-denied",
        "Bu hesap başka bir cihazda zaten aktif edilmiş."
      );
    }
    // Aynı cihaz — sorun yok, devam et
    return { status: "already_activated", message: "Hesap zaten aktif." };
  }

  // İlk giriş — hesabı aktive et
  try {
    // 1. Firestore'a kayıt yaz
    await userRef.set({
      activated: true,
      activatedAt: new Date().toISOString(),
      deviceId: deviceId,
      email: request.auth.token.email || "",
    });

    // 2. Şifreyi değiştir (kullanıcı bir daha eski şifreyle giremez)
    await getAuth().updateUser(uid, {
      password: NEW_PASSWORD_AFTER_ACTIVATION,
    });

    console.log(`Hesap aktive edildi: uid=${uid}, deviceId=${deviceId}`);
    return { status: "activated", message: "Hesap başarıyla aktive edildi." };
  } catch (err) {
    console.error("Hesap aktivasyonu başarısız:", err);
    throw new HttpsError("internal", "Hesap aktive edilemedi.");
  }
});

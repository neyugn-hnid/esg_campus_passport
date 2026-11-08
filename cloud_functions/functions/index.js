// Cloud Functions cho ESG Campus Passport
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();
const storage = admin.storage();

// ==================== GÁN NHIỆM VỤ HÀNG NGÀY ====================
exports.assignDailyQuests = functions.pubsub
  .schedule('every day 00:00')
  .timeZone('Asia/Ho_Chi_Minh')
  .onRun(async (context) => {
    // Logic gán lại nhiệm vụ hàng ngày cho sinh viên
    console.log('Assigning daily quests...');
    return null;
  });

// ==================== KIỂM TRA ẢNH TRÙNG LẶP ====================
exports.checkDuplicateImage = functions.firestore
  .document('proofs/{proofId}')
  .onCreate(async (snap, context) => {
    const proof = snap.data();
    console.log(`New proof submitted: ${context.params.proofId}`);
    // Trong tương lai: tích hợp AI để kiểm tra ảnh trùng lặp
    return null;
  });

// ==================== CẬP NHẬT ĐIỂM KHI PROOF ĐƯỢC DUYỆT ====================
exports.onProofApproved = functions.firestore
  .document('proofs/{proofId}')
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();

    // Chỉ xử lý khi trạng thái chuyển từ pending -> approved
    if (before.status === 'pending' && after.status === 'approved') {
      const taskDoc = await db.collection('tasks').doc(after.taskId).get();
      const task = taskDoc.data();
      const userId = after.userId;

      if (!task) return;

      // Cập nhật điểm ESG
      await db.collection('users').doc(userId).update({
        [`esgPoints.${task.pillar}`]: admin.firestore.FieldValue.increment(task.points),
        greenPoints: admin.firestore.FieldValue.increment(task.greenPoints || 0),
        completedTaskIds: admin.firestore.FieldValue.arrayUnion(after.taskId),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      // Ghi nhận activity
      await db.collection('activities').add({
        userId: userId,
        taskId: after.taskId,
        taskTitle: task.title,
        pillar: task.pillar,
        pointsEarned: task.points,
        greenPointsEarned: task.greenPoints || 0,
        proofId: context.params.proofId,
        completedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      // Xóa khỏi moderation queue
      await db.collection('moderation_queue').doc(context.params.proofId).delete();

      console.log(`✅ Points awarded to ${userId} for task ${task.title}`);
    }
    return null;
  });

// ==================== KIỂM TRA HUY HIỆU ====================
exports.checkBadges = functions.firestore
  .document('users/{userId}')
  .onUpdate(async (change, context) => {
    const after = change.after.data();
    const esgPoints = after.esgPoints || {};
    const total = (esgPoints.environment || 0) + (esgPoints.social || 0) + (esgPoints.governance || 0);

    const badges = [];
    if (total >= 100) badges.push('bronze');
    if (total >= 500) badges.push('silver');
    if (total >= 1000) badges.push('gold');
    if (total >= 3000) badges.push('platinum');

    if (badges.length > 0) {
      await db.collection('users').doc(context.params.userId).update({
        badgeIds: badges,
      });
    }
    return null;
  });

// ==================== GỬI THÔNG BÁO ====================
exports.sendNotification = functions.https.onCall(async (data, context) => {
  const { userId, title, body } = data;

  // Lấy FCM token của user
  const userDoc = await db.collection('users').doc(userId).get();
  const fcmToken = userDoc.data().fcmToken;

  if (fcmToken) {
    await admin.messaging().send({
      token: fcmToken,
      notification: {
        title: title,
        body: body,
      },
    });
  }

  // Lưu vào notifications collection
  await db.collection('notifications').add({
    userId: userId,
    title: title,
    body: body,
    read: false,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  return { success: true };
});

// ==================== GENERATE PASSPORT ====================
exports.generatePassport = functions.https.onCall(async (data, context) => {
  const userId = data.userId || (context.auth ? context.auth.uid : null);
  if (!userId) throw new functions.https.HttpsError('unauthenticated', 'User must be logged in');

  const userDoc = await db.collection('users').doc(userId).get();
  const userData = userDoc.data();

  // Lấy danh sách activities
  const activitiesSnapshot = await db.collection('activities')
    .where('userId', '==', userId)
    .orderBy('completedAt', 'desc')
    .limit(50)
    .get();

  const activities = activitiesSnapshot.docs.map(d => d.data());

  return {
    user: userData,
    activities: activities,
    generatedAt: new Date().toISOString(),
  };
});

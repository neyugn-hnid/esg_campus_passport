// Cấu hình Firebase cho ESG Campus Passport
// Sau khi tạo Firebase project, thay thế bằng file google-services.json / GoogleService-Info.plist

class FirebaseConfig {
  // Firestore Collections
  static const String usersCollection = 'users';
  static const String tasksCollection = 'tasks';
  static const String dailyQuestsCollection = 'daily_quests';
  static const String activitiesCollection = 'activities';
  static const String proofsCollection = 'proofs';
  static const String communityItemsCollection = 'community_items';
  static const String eventsCollection = 'events';
  static const String badgesCollection = 'badges';
  static const String rewardsCollection = 'rewards';
  static const String notificationsCollection = 'notifications';
  static const String moderationQueueCollection = 'moderation_queue';

  // Storage paths
  static const String proofImagesPath = 'proofs/';
  static const String communityImagesPath = 'community/';
  static const String avatarImagesPath = 'avatars/';
  static const String eventImagesPath = 'events/';
  static const String badgeImagesPath = 'badges/';

  // Cloud Functions
  static const String assignDailyQuests = 'assignDailyQuests';
  static const String verifyProof = 'verifyProof';
  static const String calculatePoints = 'calculatePoints';
  static const String generatePassport = 'generatePassport';
  static const String checkDuplicateImage = 'checkDuplicateImage';
  static const String sendNotification = 'sendNotification';
}

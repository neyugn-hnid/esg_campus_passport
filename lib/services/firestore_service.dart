import 'dart:async';
import 'dart:io';
import '../models/user_model.dart';
import '../models/task_model.dart';
import '../models/activity_model.dart';
import '../models/proof_model.dart';
import '../models/community_item_model.dart';
import '../utils/constants.dart';

class FirestoreService {
  final bool demoMode;

  FirestoreService({this.demoMode = false});

  // ==================== DEMO DATA ====================
  static final List<TaskModel> _demoTasks = [
    TaskModel(id: 'task_001', title: 'Mang bình nước cá nhân', description: 'Chụp ảnh bình nước cá nhân của bạn khi đi học', pillar: ESGPillar.environment, verificationType: TaskVerificationType.photoProof, points: 10, greenPoints: 5, sdgTag: 'SDG 12', photoGuide: 'Chỉ cần chụp bình nước, không cần chụp mặt', maxPhotos: 1),
    TaskModel(id: 'task_002', title: 'Từ chối đồ nhựa dùng 1 lần', description: 'Nói không với ống hút nhựa, cốc nhựa hôm nay', pillar: ESGPillar.environment, verificationType: TaskVerificationType.selfConfirm, points: 5, greenPoints: 3, sdgTag: 'SDG 12'),
    TaskModel(id: 'task_003', title: 'Phân loại rác đúng quy định', description: 'Bỏ rác vào đúng thùng phân loại', pillar: ESGPillar.environment, verificationType: TaskVerificationType.photoProof, points: 10, greenPoints: 5, sdgTag: 'SDG 12', photoGuide: 'Chụp rác đã được phân loại', maxPhotos: 1),
    TaskModel(id: 'task_004', title: 'Tắt đèn khi rời phòng', description: 'Tắt hết điện, quạt, điều hòa khi rời khỏi phòng học hoặc KTX', pillar: ESGPillar.environment, verificationType: TaskVerificationType.selfConfirm, points: 5, greenPoints: 3, sdgTag: 'SDG 7'),
    TaskModel(id: 'task_005', title: 'Chia sẻ mẹo phòng tránh lừa đảo', description: 'Chia sẻ 1 mẹo phòng tránh lừa đảo tài chính cho bạn bè/người thân', pillar: ESGPillar.social, verificationType: TaskVerificationType.selfConfirm, points: 10, greenPoints: 5, sdgTag: 'SDG 4'),
    TaskModel(id: 'task_006', title: 'Hỗ trợ bạn học', description: 'Giúp đỡ 1 bạn trong lớp về bài tập hoặc kiến thức', pillar: ESGPillar.social, verificationType: TaskVerificationType.selfConfirm, points: 10, greenPoints: 5, sdgTag: 'SDG 4'),
    TaskModel(id: 'task_007', title: 'Tham gia hoạt động tình nguyện', description: 'Đăng ký và tham gia 1 hoạt động tình nguyện', pillar: ESGPillar.social, verificationType: TaskVerificationType.qrCheckIn, points: 20, greenPoints: 10, sdgTag: 'SDG 11'),
    TaskModel(id: 'task_008', title: 'Hiến máu nhân đạo', description: 'Tham gia hiến máu tại trường hoặc địa phương', pillar: ESGPillar.social, verificationType: TaskVerificationType.organizerConfirm, points: 30, greenPoints: 15, sdgTag: 'SDG 3'),
    TaskModel(id: 'task_009', title: 'Công khai thu chi nhóm', description: 'Cập nhật bảng thu chi minh bạch cho nhóm học tập hoặc CLB', pillar: ESGPillar.governance, verificationType: TaskVerificationType.photoProof, points: 10, greenPoints: 5, sdgTag: 'SDG 16', photoGuide: 'Chụp bảng thu chi, che thông tin nhạy cảm', maxPhotos: 1),
    TaskModel(id: 'task_010', title: 'Hoàn thành quiz đạo đức nghề nghiệp', description: 'Trả lời 5 câu hỏi tình huống về đạo đức nghề nghiệp', pillar: ESGPillar.governance, verificationType: TaskVerificationType.selfConfirm, points: 10, greenPoints: 5, sdgTag: 'SDG 16'),
    TaskModel(id: 'task_011', title: 'Đăng đồ không dùng lên Community', description: 'Đăng 1 món đồ còn dùng tốt lên khu trao đổi', pillar: ESGPillar.environment, verificationType: TaskVerificationType.selfConfirm, points: 10, greenPoints: 5, sdgTag: 'SDG 12'),
    TaskModel(id: 'task_012', title: 'Tham gia workshop ESG', description: 'Đăng ký tham gia 1 buổi workshop về ESG do trường tổ chức', pillar: ESGPillar.governance, verificationType: TaskVerificationType.qrCheckIn, points: 15, greenPoints: 8, sdgTag: 'SDG 17'),
  ];

  static final List<CommunityItemModel> _demoItems = [
    CommunityItemModel(id: 'item_001', ownerId: 'demo_uid_002', ownerName: 'Trần Thị B', title: 'Giáo trình Tài chính doanh nghiệp', description: 'Còn mới 90%, tặng các em khóa dưới', type: CommunityItemType.giveaway),
    CommunityItemModel(id: 'item_002', ownerId: 'demo_uid_003', ownerName: 'Lê Văn C', title: 'Máy tính Casio FX-580VN', description: 'Còn dùng tốt, trao đổi lấy sách Marketing', type: CommunityItemType.exchange),
    CommunityItemModel(id: 'item_003', ownerId: 'demo_uid_004', ownerName: 'Phạm Thị D', title: 'Đồng phục Khoa size M', description: 'Tặng đồng phục còn mới, không dùng nữa', type: CommunityItemType.giveaway),
    CommunityItemModel(id: 'item_004', ownerId: 'demo_uid_005', ownerName: 'Hoàng Văn E', title: 'Bộ sách CFA Level 1', description: 'Bán giá 200K cho sinh viên', type: CommunityItemType.sell, price: 200000),
    CommunityItemModel(id: 'item_005', ownerId: 'demo_uid_006', ownerName: 'Ngô Thị F', title: 'Bình nước giữ nhiệt', description: 'Quyên góp cho sv khó khăn', type: CommunityItemType.donate),
  ];

  static final List<ActivityModel> _demoActivities = [
    ActivityModel(id: 'act_001', userId: 'demo_uid_001', taskId: 'task_001', taskTitle: 'Mang bình nước cá nhân', pillar: ESGPillar.environment, pointsEarned: 10, greenPointsEarned: 5, completedAt: DateTime.now().subtract(const Duration(days: 1))),
    ActivityModel(id: 'act_002', userId: 'demo_uid_001', taskId: 'task_005', taskTitle: 'Chia sẻ mẹo phòng tránh lừa đảo', pillar: ESGPillar.social, pointsEarned: 10, greenPointsEarned: 5, completedAt: DateTime.now().subtract(const Duration(days: 2))),
    ActivityModel(id: 'act_003', userId: 'demo_uid_001', taskId: 'task_009', taskTitle: 'Công khai thu chi nhóm', pillar: ESGPillar.governance, pointsEarned: 10, greenPointsEarned: 5, completedAt: DateTime.now().subtract(const Duration(days: 3))),
    ActivityModel(id: 'act_004', userId: 'demo_uid_001', taskId: 'task_003', taskTitle: 'Phân loại rác đúng quy định', pillar: ESGPillar.environment, pointsEarned: 10, greenPointsEarned: 5, completedAt: DateTime.now().subtract(const Duration(days: 4))),
    ActivityModel(id: 'act_005', userId: 'demo_uid_001', taskId: 'task_007', taskTitle: 'Tham gia hoạt động tình nguyện', pillar: ESGPillar.social, pointsEarned: 20, greenPointsEarned: 10, completedAt: DateTime.now().subtract(const Duration(days: 5))),
  ];

  // ==================== STREAM HELPERS ====================
  Stream<List<T>> _streamFromList<T>(List<T> list) {
    return Stream.value(list);
  }

  Stream<Map<String, dynamic>> _streamFromMap(Map<String, dynamic> map) {
    return Stream.value(map);
  }

  // ==================== TASKS ====================
  Stream<List<TaskModel>> getActiveDailyTasks() {
    if (demoMode) return _streamFromList(_demoTasks);
    return const Stream.empty();
  }

  Stream<List<TaskModel>> getTasksByPillar(ESGPillar pillar) {
    if (demoMode) return _streamFromList(_demoTasks.where((t) => t.pillar == pillar).toList());
    return const Stream.empty();
  }

  Future<void> createTask(TaskModel task) async {
    // Demo: không cần lưu
  }

  // ==================== ACTIVITIES ====================
  Stream<List<ActivityModel>> getUserActivities(String userId) {
    if (demoMode) return _streamFromList(_demoActivities);
    return const Stream.empty();
  }

  Future<void> recordActivity(ActivityModel activity) async {
    // Demo: không cần lưu
  }

  // ==================== PROOFS ====================
  Future<String> submitProof({
    required String taskId,
    required String userId,
    required List<File> images,
  }) async {
    // Demo: trả về ID giả
    return 'proof_${DateTime.now().millisecondsSinceEpoch}';
  }

  Stream<List<ProofModel>> getPendingProofs() {
    return _streamFromList(<ProofModel>[]);
  }

  Future<void> reviewProof({
    required String proofId,
    required ProofStatus status,
    required String moderatorNote,
    required TaskModel task,
    required String userId,
  }) async {}

  // ==================== COMMUNITY ====================
  Stream<List<CommunityItemModel>> getCommunityItems() {
    if (demoMode) return _streamFromList(_demoItems);
    return const Stream.empty();
  }

  Future<void> createCommunityItem(CommunityItemModel item, List<File>? images) async {}

  // ==================== DASHBOARD ====================
  Stream<Map<String, dynamic>> getDashboardStats() {
    return _streamFromMap({
      'totalStudents': 1245,
      'totalActivities': 3850,
      'totalCommunityItems': 156,
      'totalEPoints': 15200,
      'totalSPoints': 12300,
      'totalGPoints': 8900,
    });
  }
}

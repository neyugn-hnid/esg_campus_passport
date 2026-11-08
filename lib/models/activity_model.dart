import 'package:esg_campus_passport/utils/constants.dart';

class ActivityModel {
  final String id;
  final String userId;
  final String taskId;
  final String taskTitle;
  final ESGPillar pillar;
  final int pointsEarned;
  final int greenPointsEarned;
  final String? proofId;
  final DateTime completedAt;

  ActivityModel({
    required this.id,
    required this.userId,
    required this.taskId,
    required this.taskTitle,
    required this.pillar,
    this.pointsEarned = 0,
    this.greenPointsEarned = 0,
    this.proofId,
    DateTime? completedAt,
  }) : completedAt = completedAt ?? DateTime.now();

  factory ActivityModel.fromMap(Map<String, dynamic> map, String id) {
    return ActivityModel(
      id: id,
      userId: map['userId'] ?? '',
      taskId: map['taskId'] ?? '',
      taskTitle: map['taskTitle'] ?? '',
      pillar: ESGPillar.values.firstWhere(
        (p) => p.name == (map['pillar'] ?? 'environment'),
        orElse: () => ESGPillar.environment,
      ),
      pointsEarned: map['pointsEarned'] ?? 0,
      greenPointsEarned: map['greenPointsEarned'] ?? 0,
      proofId: map['proofId'],
      completedAt: (map['completedAt'] as dynamic).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'taskId': taskId,
      'taskTitle': taskTitle,
      'pillar': pillar.name,
      'pointsEarned': pointsEarned,
      'greenPointsEarned': greenPointsEarned,
      'proofId': proofId,
      'completedAt': completedAt,
    };
  }
}

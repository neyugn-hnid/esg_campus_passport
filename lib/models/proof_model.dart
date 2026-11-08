import 'package:esg_campus_passport/utils/constants.dart';

class ProofModel {
  final String id;
  final String taskId;
  final String userId;
  final List<String> imageUrls;
  final ProofStatus status;
  final String? moderatorNote;
  final DateTime submittedAt;
  final DateTime? reviewedAt;

  ProofModel({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.imageUrls,
    this.status = ProofStatus.pending,
    this.moderatorNote,
    DateTime? submittedAt,
    this.reviewedAt,
  }) : submittedAt = submittedAt ?? DateTime.now();

  factory ProofModel.fromMap(Map<String, dynamic> map, String id) {
    return ProofModel(
      id: id,
      taskId: map['taskId'] ?? '',
      userId: map['userId'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      status: ProofStatus.values.firstWhere(
        (s) => s.name == (map['status'] ?? 'pending'),
        orElse: () => ProofStatus.pending,
      ),
      moderatorNote: map['moderatorNote'],
      submittedAt: (map['submittedAt'] as dynamic).toDate(),
      reviewedAt: map['reviewedAt'] != null
          ? (map['reviewedAt'] as dynamic).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'userId': userId,
      'imageUrls': imageUrls,
      'status': status.name,
      'moderatorNote': moderatorNote,
      'submittedAt': submittedAt,
      'reviewedAt': reviewedAt,
    };
  }
}

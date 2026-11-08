import 'package:esg_campus_passport/utils/constants.dart';

class UserModel {
  final String uid;
  final String studentId;
  final String email;
  final String fullName;
  final String department;
  final String className;
  final UserRole role;
  final String? avatarUrl;
  final Map<String, int> esgPoints; // {'environment': 0, 'social': 0, 'governance': 0}
  final int greenPoints; // điểm tiêu dùng xanh
  final List<String> badgeIds;
  final List<String> completedTaskIds;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.uid,
    required this.studentId,
    required this.email,
    required this.fullName,
    required this.department,
    required this.className,
    this.role = UserRole.student,
    this.avatarUrl,
    Map<String, int>? esgPoints,
    this.greenPoints = 0,
    List<String>? badgeIds,
    List<String>? completedTaskIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : esgPoints = esgPoints ?? {'environment': 0, 'social': 0, 'governance': 0},
        badgeIds = badgeIds ?? [],
        completedTaskIds = completedTaskIds ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  int get totalESGPoints =>
      (esgPoints['environment'] ?? 0) +
      (esgPoints['social'] ?? 0) +
      (esgPoints['governance'] ?? 0);

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      studentId: map['studentId'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      department: map['department'] ?? '',
      className: map['className'] ?? '',
      role: UserRole.values.firstWhere(
        (r) => r.name == (map['role'] ?? 'student'),
        orElse: () => UserRole.student,
      ),
      avatarUrl: map['avatarUrl'],
      esgPoints: Map<String, int>.from(map['esgPoints'] ?? {}),
      greenPoints: map['greenPoints'] ?? 0,
      badgeIds: List<String>.from(map['badgeIds'] ?? []),
      completedTaskIds: List<String>.from(map['completedTaskIds'] ?? []),
      createdAt: (map['createdAt'] as dynamic).toDate(),
      updatedAt: (map['updatedAt'] as dynamic).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'email': email,
      'fullName': fullName,
      'department': department,
      'className': className,
      'role': role.name,
      'avatarUrl': avatarUrl,
      'esgPoints': esgPoints,
      'greenPoints': greenPoints,
      'badgeIds': badgeIds,
      'completedTaskIds': completedTaskIds,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

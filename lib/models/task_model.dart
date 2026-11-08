import 'package:esg_campus_passport/utils/constants.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final ESGPillar pillar;
  final TaskVerificationType verificationType;
  final int points;
  final int greenPoints;
  final String? sdgTag;
  final String? photoGuide; // hướng dẫn chụp ảnh
  final int? maxPhotos;
  final bool isActive;
  final bool isDaily;
  final DateTime createdAt;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.pillar,
    this.verificationType = TaskVerificationType.selfConfirm,
    this.points = 10,
    this.greenPoints = 5,
    this.sdgTag,
    this.photoGuide,
    this.maxPhotos = 1,
    this.isActive = true,
    this.isDaily = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory TaskModel.fromMap(Map<String, dynamic> map, String id) {
    return TaskModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      pillar: ESGPillar.values.firstWhere(
        (p) => p.name == (map['pillar'] ?? 'environment'),
        orElse: () => ESGPillar.environment,
      ),
      verificationType: TaskVerificationType.values.firstWhere(
        (v) => v.name == (map['verificationType'] ?? 'selfConfirm'),
        orElse: () => TaskVerificationType.selfConfirm,
      ),
      points: map['points'] ?? 10,
      greenPoints: map['greenPoints'] ?? 5,
      sdgTag: map['sdgTag'],
      photoGuide: map['photoGuide'],
      maxPhotos: map['maxPhotos'] ?? 1,
      isActive: map['isActive'] ?? true,
      isDaily: map['isDaily'] ?? true,
      createdAt: (map['createdAt'] as dynamic).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'pillar': pillar.name,
      'verificationType': verificationType.name,
      'points': points,
      'greenPoints': greenPoints,
      'sdgTag': sdgTag,
      'photoGuide': photoGuide,
      'maxPhotos': maxPhotos,
      'isActive': isActive,
      'isDaily': isDaily,
      'createdAt': createdAt,
    };
  }
}

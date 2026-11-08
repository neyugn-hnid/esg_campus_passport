import 'package:esg_campus_passport/utils/constants.dart';

class CommunityItemModel {
  final String id;
  final String ownerId;
  final String ownerName;
  final String title;
  final String description;
  final List<String> imageUrls;
  final CommunityItemType type;
  final double? price; // nếu type = sell
  final bool isReserved;
  final bool isCompleted;
  final String? reservedBy;
  final DateTime createdAt;

  CommunityItemModel({
    required this.id,
    required this.ownerId,
    required this.ownerName,
    required this.title,
    required this.description,
    this.imageUrls = const [],
    this.type = CommunityItemType.giveaway,
    this.price,
    this.isReserved = false,
    this.isCompleted = false,
    this.reservedBy,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory CommunityItemModel.fromMap(Map<String, dynamic> map, String id) {
    return CommunityItemModel(
      id: id,
      ownerId: map['ownerId'] ?? '',
      ownerName: map['ownerName'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      type: CommunityItemType.values.firstWhere(
        (t) => t.name == (map['type'] ?? 'giveaway'),
        orElse: () => CommunityItemType.giveaway,
      ),
      price: (map['price'] as num?)?.toDouble(),
      isReserved: map['isReserved'] ?? false,
      isCompleted: map['isCompleted'] ?? false,
      reservedBy: map['reservedBy'],
      createdAt: (map['createdAt'] as dynamic).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'ownerName': ownerName,
      'title': title,
      'description': description,
      'imageUrls': imageUrls,
      'type': type.name,
      'price': price,
      'isReserved': isReserved,
      'isCompleted': isCompleted,
      'reservedBy': reservedBy,
      'createdAt': createdAt,
    };
  }
}

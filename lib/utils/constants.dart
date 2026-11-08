// Hằng số & enums dùng trong toàn app

class AppConstants {
  static const String appName = 'ESG Campus Passport';
  static const String universityName = 'TUEBA';
  static const String appVersion = '1.0.0';

  // ESG Pillar colors
  static const int environmentColor = 0xFF4CAF50; // Green
  static const int socialColor = 0xFF2196F3; // Blue
  static const int governanceColor = 0xFFFF9800; // Orange

  // Điểm
  static const int maxDailyPoints = 100;
  static const int maxDailyTasks = 10;

  // Ảnh minh chứng
  static const int maxProofImages = 3;
  static const int maxImageSizeMB = 5;

  // Huy hiệu
  static const int bronzeThreshold = 100;
  static const int silverThreshold = 500;
  static const int goldThreshold = 1000;
  static const int platinumThreshold = 3000;
}

enum ESGPillar {
  environment,
  social,
  governance;

  String get label {
    switch (this) {
      case ESGPillar.environment:
        return 'E - Môi trường';
      case ESGPillar.social:
        return 'S - Xã hội';
      case ESGPillar.governance:
        return 'G - Quản trị';
    }
  }

  String get icon {
    switch (this) {
      case ESGPillar.environment:
        return '🌿';
      case ESGPillar.social:
        return '🤝';
      case ESGPillar.governance:
        return '⚖️';
    }
  }

  int get colorValue {
    switch (this) {
      case ESGPillar.environment:
        return AppConstants.environmentColor;
      case ESGPillar.social:
        return AppConstants.socialColor;
      case ESGPillar.governance:
        return AppConstants.governanceColor;
    }
  }
}

enum TaskVerificationType {
  selfConfirm, // Tự xác nhận
  photoProof, // Ảnh minh chứng
  qrCheckIn, // QR check-in
  organizerConfirm, // Ban tổ chức xác nhận
}

enum ProofStatus {
  pending,
  approved,
  rejected;

  String get label {
    switch (this) {
      case ProofStatus.pending:
        return 'Đang kiểm duyệt';
      case ProofStatus.approved:
        return 'Đã duyệt';
      case ProofStatus.rejected:
        return 'Từ chối';
    }
  }
}

enum UserRole {
  student,
  moderator,
  department,
  admin;

  String get label {
    switch (this) {
      case UserRole.student:
        return 'Sinh viên';
      case UserRole.moderator:
        return 'Kiểm duyệt viên';
      case UserRole.department:
        return 'Khoa/Phòng ban';
      case UserRole.admin:
        return 'Quản trị viên';
    }
  }
}

enum CommunityItemType {
  giveaway, // Tặng miễn phí
  exchange, // Trao đổi
  sell, // Bán giá thấp
  donate, // Quyên góp
}

enum BadgeLevel {
  bronze,
  silver,
  gold,
  platinum;

  String get label {
    switch (this) {
      case BadgeLevel.bronze:
        return 'Đồng';
      case BadgeLevel.silver:
        return 'Bạc';
      case BadgeLevel.gold:
        return 'Vàng';
      case BadgeLevel.platinum:
        return 'Bạch kim';
    }
  }
}

// SDG Mapping
class SDGMapping {
  static const Map<String, String> sdgMap = {
    'E_WASTE': 'SDG 12 - Tiêu dùng có trách nhiệm',
    'E_ENERGY': 'SDG 7 - Năng lượng sạch',
    'E_CLIMATE': 'SDG 13 - Hành động vì khí hậu',
    'E_GREEN': 'SDG 15 - Sự sống trên cạn',
    'S_EDUCATION': 'SDG 4 - Giáo dục chất lượng',
    'S_EQUALITY': 'SDG 5 - Bình đẳng giới',
    'S_COMMUNITY': 'SDG 11 - Cộng đồng bền vững',
    'S_HEALTH': 'SDG 3 - Sức khỏe tốt',
    'G_TRANSPARENCY': 'SDG 16 - Hòa bình, công lý',
    'G_PARTNERSHIP': 'SDG 17 - Hợp tác phát triển',
  };
}

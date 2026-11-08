# 🌿 ESG Campus Passport - Hộ chiếu ESG Sinh viên

> Ứng dụng Flutter + Firebase cho cuộc thi "Sinh viên với Sáng kiến ESG" 2026  
> Trường Đại học Kinh tế và Quản trị Kinh doanh - TUEBA, Thái Nguyên

---

## 📋 Tổng quan

ESG Campus Passport là nền tảng số giúp sinh viên tiếp cận, thực hành và ghi nhận hoạt động ESG (Môi trường - Xã hội - Quản trị) thông qua:

- ✅ **Nhiệm vụ ESG hằng ngày** (Daily Quest)
- 📸 **Gửi minh chứng bằng ảnh** (Photo Proof)
- 🏅 **Tích điểm, huy hiệu ESG** (Passport)
- 🔄 **Trao đổi đồ không dùng** (Community)
- 📊 **Dashboard thống kê** (Dashboard)

---

## 🏗️ Kiến trúc

```
┌──────────────────────────────────────────────────┐
│                  Flutter App                      │
│  ┌──────────┐ ┌──────────┐ ┌──────────────────┐  │
│  │  Auth    │ │  Quest   │ │   Community      │  │
│  │  Screen  │ │  Screen  │ │   Screen          │  │
│  └────┬─────┘ └────┬─────┘ └───────┬──────────┘  │
│       │             │               │             │
│  ┌────┴─────────────┴───────────────┴──────────┐  │
│  │              Providers                       │  │
│  │   AuthService | FirestoreService             │  │
│  └────────────────────┬────────────────────────┘  │
└───────────────────────┼───────────────────────────┘
                        │
┌───────────────────────┼───────────────────────────┐
│                   Firebase                         │
│  ┌──────────┐ ┌────────┐ ┌──────────┐            │
│  │   Auth   │ │Firestore│ │ Storage  │            │
│  └──────────┘ └────────┘ └──────────┘            │
│  ┌──────────────────────────────────────┐        │
│  │       Cloud Functions                 │        │
│  │  • assignDailyQuests                  │        │
│  │  • checkDuplicateImage                │        │
│  │  • onProofApproved                    │        │
│  │  • checkBadges                        │        │
│  │  • sendNotification                   │        │
│  │  • generatePassport                   │        │
│  └──────────────────────────────────────┘        │
└───────────────────────────────────────────────────┘
```

---

## 🚀 Cài đặt & Chạy

### Yêu cầu
- Flutter SDK >= 3.1.0
- Firebase CLI (`npm install -g firebase-tools`)
- Node.js 18+ (cho Cloud Functions)

### Bước 1: Cài đặt Flutter dependencies
```bash
cd esg_campus_passport
flutter pub get
```

### Bước 2: Cấu hình Firebase
1. Tạo project trên [Firebase Console](https://console.firebase.google.com)
2. Bật **Authentication** (Email/Password)
3. Bật **Cloud Firestore**
4. Bật **Firebase Storage**
5. Bật **Cloud Functions**
6. Cài đặt Firebase CLI:
```bash
firebase login
firebase init
```
7. Thêm file `google-services.json` (Android) và `GoogleService-Info.plist` (iOS)

### Bước 3: Deploy Firebase
```bash
# Deploy Firestore rules
firebase deploy --only firestore:rules

# Deploy Storage rules
firebase deploy --only storage

# Deploy Cloud Functions
cd cloud_functions/functions
npm install
cd ../..
firebase deploy --only functions
```

### Bước 4: Chạy app
```bash
flutter run
```

---

## 📁 Cấu trúc thư mục

```
lib/
├── main.dart                    # Entry point
├── app.dart                     # App root widget
├── config/
│   └── firebase_config.dart     # Firebase collection paths
├── models/
│   ├── user_model.dart          # User data model
│   ├── task_model.dart          # ESG Task model
│   ├── activity_model.dart      # Activity record model
│   ├── proof_model.dart         # Photo proof model
│   └── community_item_model.dart # Community item model
├── services/
│   ├── auth_service.dart        # Firebase Auth
│   └── firestore_service.dart   # Firestore CRUD + Storage
├── screens/
│   ├── auth/login_screen.dart   # Login/Register
│   ├── home/home_screen.dart    # Main tab navigation
│   ├── quest/                   # Daily Quest screens
│   ├── passport/                # ESG Passport screens
│   ├── community/               # Community screens
│   ├── proof/                   # Photo proof submission
│   ├── dashboard/               # Analytics dashboard
│   └── admin/                   # Admin moderation
├── widgets/
│   ├── task_card.dart           # Task card widget
│   └── community_item_card.dart # Community item card
└── utils/
    ├── constants.dart           # Enums, constants
    └── theme.dart               # App theme
```

---

## 🔐 Phân quyền

| Role | Quyền |
|------|-------|
| **Student** | Làm nhiệm vụ, gửi minh chứng, đăng đồ, xem dashboard cá nhân |
| **Moderator** | Kiểm duyệt ảnh minh chứng, duyệt/từ chối proof |
| **Department** | Xem dashboard khoa, tạo nhiệm vụ riêng cho khoa |
| **Admin** | Quản lý toàn bộ hệ thống, tạo task, quản lý user |

---

## 🎯 5 Phân hệ chính

### 1. ESG Daily Quest
Nhiệm vụ ESG hằng ngày phân loại theo E/S/G:
- 🌿 **E - Môi trường**: mang bình nước, từ chối nhựa, phân loại rác...
- 🤝 **S - Xã hội**: chia sẻ kiến thức, tình nguyện, hỗ trợ bạn bè...
- ⚖️ **G - Quản trị**: công khai thu chi, minh bạch tài chính CLB...

### 2. ESG Activity Passport
Hộ chiếu cá nhân ghi nhận toàn bộ hoạt động ESG, điểm số, huy hiệu.

### 3. ESG Community
Không gian trao đổi đồ không dùng: tặng, trao đổi, bán giá thấp, quyên góp.

### 4. ESG Photo Proof
Cơ chế chụp ảnh minh chứng trong app → kiểm duyệt → cộng điểm.

### 5. ESG Dashboard & Career Passport
- Dashboard cá nhân: biểu đồ điểm ESG, lịch sử hoạt động
- Dashboard quản trị: thống kê toàn trường
- Xuất hồ sơ ESG (mã QR)

---

## 🌍 SDG Mapping

Hệ thống đối chiếu hoạt động ESG với SDGs của Liên Hợp Quốc:

| Hoạt động | SDG |
|-----------|-----|
| Giảm rác thải, tái chế | SDG 12 - Tiêu dùng có trách nhiệm |
| Tiết kiệm năng lượng | SDG 7 - Năng lượng sạch |
| Hoạt động khí hậu | SDG 13 - Hành động vì khí hậu |
| Giáo dục, chia sẻ kiến thức | SDG 4 - Giáo dục chất lượng |
| Tình nguyện, hỗ trợ | SDG 11 - Cộng đồng bền vững |
| Minh bạch quản trị | SDG 16 - Hòa bình, công lý |

---

## 📝 License

Dự án thuộc cuộc thi "Sinh viên với Sáng kiến ESG" 2026 - TUEBA

---

**Nhóm thực hiện:** Nguyễn Minh An & cộng sự  
**Khoa Ngân hàng - Tài chính, Trường Đại học Kinh tế và QTKD Thái Nguyên**

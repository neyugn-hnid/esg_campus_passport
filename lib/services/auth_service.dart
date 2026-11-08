import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

class AuthService extends ChangeNotifier {
  final bool demoMode;

  AuthService({this.demoMode = false});

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.role == UserRole.admin;
  bool get isModerator => _currentUser?.role == UserRole.moderator;

  static final _demoUser = UserModel(
    uid: 'demo_uid_001',
    studentId: 'SV2024001',
    email: 'demo@tueba.edu.vn',
    fullName: 'Nguyễn Minh Anh',
    department: 'Khoa Ngân hàng - Tài chính',
    className: 'K17TCDN',
    role: UserRole.student,
    avatarUrl: 'https://i.pravatar.cc/160?img=47',
    esgPoints: {'environment': 95, 'social': 110, 'governance': 75},
    greenPoints: 250,
    badgeIds: ['bronze'],
    completedTaskIds: ['task_001', 'task_003'],
  );

  Future<UserModel?> signInWithEmail(String email, String password) async {
    if (demoMode) {
      _currentUser = _demoUser;
      notifyListeners();
      return _currentUser;
    }
    // Firebase auth sẽ ở đây khi có config thật
    return null;
  }

  Future<UserModel?> registerStudent({
    required String studentId,
    required String email,
    required String password,
    required String fullName,
    required String department,
    required String className,
  }) async {
    if (demoMode) {
      _currentUser = UserModel(
        uid: 'demo_${DateTime.now().millisecondsSinceEpoch}',
        studentId: studentId,
        email: email,
        fullName: fullName,
        department: department,
        className: className,
      );
      notifyListeners();
      return _currentUser;
    }
    return null;
  }

  Future<void> signOut() async {
    _currentUser = null;
    notifyListeners();
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    if (_currentUser == null) return;
    _currentUser = UserModel(
      uid: _currentUser!.uid,
      studentId: data['studentId'] ?? _currentUser!.studentId,
      email: data['email'] ?? _currentUser!.email,
      fullName: data['fullName'] ?? _currentUser!.fullName,
      department: data['department'] ?? _currentUser!.department,
      className: data['className'] ?? _currentUser!.className,
      role: _currentUser!.role,
      esgPoints: _currentUser!.esgPoints,
      greenPoints: _currentUser!.greenPoints,
      badgeIds: _currentUser!.badgeIds,
      completedTaskIds: _currentUser!.completedTaskIds,
    );
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../models/activity_model.dart';
import '../../utils/theme.dart';

class PassportScreen extends StatelessWidget {
  const PassportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final firestoreService = context.read<FirestoreService>();
    final user = authService.currentUser!;

    return StreamBuilder<List<ActivityModel>>(
      stream: firestoreService.getUserActivities(user.uid),
      builder: (context, snapshot) {
        final activities = snapshot.data ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Passport Card
              _PassportCard(user: user),
              const SizedBox(height: 24),

              // Badges
              Text('🏅 Huy hiệu ESG', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _BadgesRow(user: user),
              const SizedBox(height: 24),

              // Recent Activities
              Text('📋 Hoạt động gần đây', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              if (activities.isEmpty)
                _EmptyState(message: 'Bắt đầu thực hiện nhiệm vụ ESG\ntrong tab Nhiệm vụ nhé!')
              else
                ...activities.take(20).map((a) => _ActivityTile(activity: a)),

              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }
}

class _PassportCard extends StatelessWidget {
  final dynamic user;
  const _PassportCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final esgPoints = user.esgPoints as Map<String, dynamic>;
    final total = (esgPoints['environment'] ?? 0) +
        (esgPoints['social'] ?? 0) +
        (esgPoints['governance'] ?? 0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryGreen, Color(0xFF1B5E20)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.airplane_ticket, color: Colors.white70, size: 20),
              const SizedBox(width: 8),
              const Text('ESG CAREER PASSPORT', style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1)),
              const Spacer(),
              GestureDetector(
                onTap: () => _showQRCode(context),
                child: const Icon(Icons.qr_code_2, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            user.fullName ?? 'Sinh viên',
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text('${user.studentId} · ${user.department}',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _MiniPillar(label: 'E', points: esgPoints['environment'] ?? 0, color: Colors.greenAccent),
              const SizedBox(width: 16),
              _MiniPillar(label: 'S', points: esgPoints['social'] ?? 0, color: Colors.lightBlueAccent),
              const SizedBox(width: 16),
              _MiniPillar(label: 'G', points: esgPoints['governance'] ?? 0, color: Colors.orangeAccent),
              const Spacer(),
              Column(
                children: [
                  Text('$total', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const Text('TỔNG', style: TextStyle(color: Colors.white70, fontSize: 10)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showQRCode(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Mã QR Hồ sơ ESG', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),
              QrImageView(
                data: 'ESG_PASSPORT:${user.uid}:${user.studentId}',
                version: QrVersions.auto,
                size: 200,
              ),
              const SizedBox(height: 16),
              const Text('Quét mã để xem hồ sơ ESG', style: TextStyle(color: AppTheme.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniPillar extends StatelessWidget {
  final String label;
  final int points;
  final Color color;
  const _MiniPillar({required this.label, required this.points, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
        Text('$points', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        const Text('điểm', style: TextStyle(color: Colors.white60, fontSize: 10)),
      ],
    );
  }
}

class _BadgesRow extends StatelessWidget {
  final dynamic user;
  const _BadgesRow({required this.user});

  @override
  Widget build(BuildContext context) {
    final total = ((user.esgPoints as Map<String, int>)['environment'] ?? 0) +
        ((user.esgPoints as Map<String, int>)['social'] ?? 0) +
        ((user.esgPoints as Map<String, int>)['governance'] ?? 0);

    final badges = [
      {'label': 'Đồng', 'icon': '🥉', 'earned': total >= 100},
      {'label': 'Bạc', 'icon': '🥈', 'earned': total >= 500},
      {'label': 'Vàng', 'icon': '🥇', 'earned': total >= 1000},
      {'label': 'BK', 'icon': '💎', 'earned': total >= 3000},
    ];

    return Row(
      children: badges.map((b) {
        final earned = b['earned'] as bool;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: earned ? AppTheme.primaryGreen.withOpacity(0.1) : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: earned ? AppTheme.primaryGreen : Colors.grey[300]!),
            ),
            child: Column(
              children: [
                Text(b['icon'] as String, style: TextStyle(fontSize: 28, color: earned ? null : Colors.grey[400])),
                Text(b['label'] as String, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: earned ? AppTheme.primaryGreen : Colors.grey[400])),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final ActivityModel activity;
  const _ActivityTile({required this.activity});

  @override
  Widget build(BuildContext context) {
    final color = Color(activity.pillar.colorValue);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Text(activity.pillar.icon, style: const TextStyle(fontSize: 20))),
        ),
        title: Text(activity.taskTitle, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(
          '${activity.pointsEarned} điểm ESG · ${activity.greenPointsEarned} XP xanh',
          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
        trailing: Text(
          '+${activity.pointsEarned}',
          style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.hourglass_empty, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[400])),
          ],
        ),
      ),
    );
  }
}

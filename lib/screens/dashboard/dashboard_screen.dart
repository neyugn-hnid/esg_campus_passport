import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final firestoreService = context.read<FirestoreService>();
    final user = authService.currentUser!;
    final esgPoints = user.esgPoints as Map<String, int>;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Personal ESG Stats
          Text('📊 Thống kê cá nhân', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _PersonalStatsCard(esgPoints: esgPoints),
          const SizedBox(height: 16),

          // ESG Pie Chart
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Phân bổ điểm ESG', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: _ESGPieChart(esgPoints: esgPoints),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Overall Dashboard (for all roles)
          Text('📈 Tổng quan TUEBA', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          StreamBuilder<Map<String, dynamic>>(
            stream: firestoreService.getDashboardStats(),
            builder: (context, snapshot) {
              final data = snapshot.data ?? {};
              return _OverallStatsGrid(data: data);
            },
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _PersonalStatsCard extends StatelessWidget {
  final Map<String, int> esgPoints;
  const _PersonalStatsCard({required this.esgPoints});

  @override
  Widget build(BuildContext context) {
    final total = (esgPoints['environment'] ?? 0) +
        (esgPoints['social'] ?? 0) +
        (esgPoints['governance'] ?? 0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _StatItem(
              icon: '🌿',
              label: 'Môi trường',
              value: '${esgPoints['environment'] ?? 0}',
              color: const Color(AppConstants.environmentColor),
            ),
            _StatItem(
              icon: '🤝',
              label: 'Xã hội',
              value: '${esgPoints['social'] ?? 0}',
              color: const Color(AppConstants.socialColor),
            ),
            _StatItem(
              icon: '⚖️',
              label: 'Quản trị',
              value: '${esgPoints['governance'] ?? 0}',
              color: const Color(AppConstants.governanceColor),
            ),
            _StatItem(
              icon: '⭐',
              label: 'Tổng',
              value: '$total',
              color: AppTheme.primaryGreen,
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color color;
  final bool isBold;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 22 : 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}

class _ESGPieChart extends StatelessWidget {
  final Map<String, int> esgPoints;
  const _ESGPieChart({required this.esgPoints});

  @override
  Widget build(BuildContext context) {
    final e = (esgPoints['environment'] ?? 0).toDouble();
    final s = (esgPoints['social'] ?? 0).toDouble();
    final g = (esgPoints['governance'] ?? 0).toDouble();
    final total = e + s + g;

    if (total == 0) return const Center(child: Text('Bắt đầu tích điểm ESG!'));

    return Row(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: e,
                  title: 'E\n${(e / total * 100).toInt()}%',
                  color: const Color(AppConstants.environmentColor),
                  radius: 50,
                  titleStyle: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                PieChartSectionData(
                  value: s,
                  title: 'S\n${(s / total * 100).toInt()}%',
                  color: const Color(AppConstants.socialColor),
                  radius: 50,
                  titleStyle: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                PieChartSectionData(
                  value: g,
                  title: 'G\n${(g / total * 100).toInt()}%',
                  color: const Color(AppConstants.governanceColor),
                  radius: 50,
                  titleStyle: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Legend(color: const Color(AppConstants.environmentColor), label: 'E - Môi trường'),
            _Legend(color: const Color(AppConstants.socialColor), label: 'S - Xã hội'),
            _Legend(color: const Color(AppConstants.governanceColor), label: 'G - Quản trị'),
          ],
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}

class _OverallStatsGrid extends StatelessWidget {
  final Map<String, dynamic> data;
  const _OverallStatsGrid({required this.data});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.6,
      children: [
        _StatCard(label: 'Sinh viên', value: '${data['totalStudents'] ?? 0}', icon: '👥'),
        _StatCard(label: 'Hoạt động', value: '${data['totalActivities'] ?? 0}', icon: '✅'),
        _StatCard(label: 'Điểm E', value: '${data['totalEPoints'] ?? 0}', icon: '🌿'),
        _StatCard(label: 'Điểm S', value: '${data['totalSPoints'] ?? 0}', icon: '🤝'),
        _StatCard(label: 'Điểm G', value: '${data['totalGPoints'] ?? 0}', icon: '⚖️'),
        _StatCard(label: 'Đồ trao đổi', value: '${data['totalCommunityItems'] ?? 0}', icon: '🔄'),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  const _StatCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
            Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }
}

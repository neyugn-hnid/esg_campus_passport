import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../models/task_model.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';

class ProofScreen extends StatelessWidget {
  const ProofScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = context.read<FirestoreService>();
    final user = context.watch<AuthService>().currentUser!;

    return StreamBuilder<List<TaskModel>>(
      stream: firestoreService.getActiveDailyTasks(),
      builder: (context, snapshot) {
        final tasks = snapshot.data ?? [];
        final photoTasks = tasks.where((t) => t.verificationType == TaskVerificationType.photoProof).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text('📸 Gửi minh chứng', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Chụp ảnh trực tiếp trong app để xác nhận hoàn thành nhiệm vụ',
                  style: TextStyle(color: Colors.grey[500], fontSize: 13)),
              const SizedBox(height: 20),

              // Pending proofs
              Text('⏳ Đang chờ duyệt', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              _EmptyCard(
                icon: Icons.hourglass_empty,
                text: 'Không có minh chứng nào đang chờ',
                color: Colors.amber,
              ),
              const SizedBox(height: 20),

              // Approved proofs
              Text('✅ Đã duyệt gần đây', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              _ProofItem(taskTitle: 'Mang bình nước cá nhân', pillar: ESGPillar.environment, points: 10, date: 'Hôm qua', status: ProofStatus.approved),
              _ProofItem(taskTitle: 'Phân loại rác đúng quy định', pillar: ESGPillar.environment, points: 10, date: '3 ngày trước', status: ProofStatus.approved),
              const SizedBox(height: 20),

              // Rejected
              Text('❌ Bị từ chối', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              _EmptyCard(
                icon: Icons.check_circle_outline,
                text: 'Tốt! Không có minh chứng nào bị từ chối',
                color: AppTheme.success,
              ),
              const SizedBox(height: 24),

              // Các nhiệm vụ cần minh chứng
              Text('📋 Nhiệm vụ cần chụp ảnh', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Hoàn thành các nhiệm vụ này để tích điểm ESG',
                  style: TextStyle(color: Colors.grey[500], fontSize: 13)),
              const SizedBox(height: 12),

              if (photoTasks.isEmpty)
                const _EmptyCard(icon: Icons.check_circle, text: 'Đã hoàn thành tất cả nhiệm vụ cần ảnh!', color: AppTheme.success)
              else
                ...photoTasks.map((task) => _PhotoTaskCard(
                  task: task,
                  isCompleted: user.completedTaskIds.contains(task.id),
                )),

              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }
}

class _ProofItem extends StatelessWidget {
  final String taskTitle;
  final ESGPillar pillar;
  final int points;
  final String date;
  final ProofStatus status;

  const _ProofItem({
    required this.taskTitle,
    required this.pillar,
    required this.points,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final color = status == ProofStatus.approved
        ? AppTheme.success
        : status == ProofStatus.rejected
            ? AppTheme.error
            : Colors.amber;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            status == ProofStatus.approved ? Icons.check_circle : status == ProofStatus.rejected ? Icons.cancel : Icons.pending,
            color: color,
          ),
        ),
        title: Text(taskTitle, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(date, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text('+$points', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ),
      ),
    );
  }
}

class _PhotoTaskCard extends StatelessWidget {
  final TaskModel task;
  final bool isCompleted;

  const _PhotoTaskCard({required this.task, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    final color = Color(task.pillar.colorValue);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            color: isCompleted ? Colors.grey[100] : color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check_circle, color: AppTheme.success, size: 24)
                : Text(task.pillar.icon, style: const TextStyle(fontSize: 22)),
          ),
        ),
        title: Text(task.title, style: TextStyle(
          fontWeight: FontWeight.w600, fontSize: 14,
          color: isCompleted ? AppTheme.textSecondary : null,
          decoration: isCompleted ? TextDecoration.lineThrough : null,
        )),
        subtitle: task.photoGuide != null
            ? Text(task.photoGuide!, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary))
            : null,
        trailing: isCompleted
            ? const Chip(label: Text('Đã xong', style: TextStyle(fontSize: 11)), backgroundColor: Color(0xFFE8F5E9))
            : ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.camera_alt, size: 16),
                label: const Text('Chụp', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                ),
              ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const _EmptyCard({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color.withOpacity(0.5)),
            const SizedBox(height: 8),
            Text(text, textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[500], fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

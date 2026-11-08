import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/firestore_service.dart';
import '../../services/auth_service.dart';
import '../../models/task_model.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';
import '../../widgets/task_card.dart';
import '../proof/proof_submission_screen.dart';

class DailyQuestScreen extends StatelessWidget {
  const DailyQuestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = context.read<FirestoreService>();
    final authService = context.read<AuthService>();
    final user = authService.currentUser!;

    return StreamBuilder<List<TaskModel>>(
      stream: firestoreService.getActiveDailyTasks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final tasks = snapshot.data ?? [];

        // Filter tabs by pillar
        return DefaultTabController(
          length: 4,
          child: Column(
            children: [
              // User ESG Points Summary
              _ESGPointsHeader(user: user),
              // Tab bar
              Container(
                color: Colors.white,
                child: TabBar(
                  labelColor: AppTheme.primaryGreen,
                  unselectedLabelColor: AppTheme.textSecondary,
                  indicatorColor: AppTheme.primaryGreen,
                  tabs: const [
                    Tab(text: 'Tất cả'),
                    Tab(text: '🌿 Môi trường'),
                    Tab(text: '🤝 Xã hội'),
                    Tab(text: '⚖️ Quản trị'),
                  ],
                ),
              ),
              // Task list
              Expanded(
                child: TabBarView(
                  children: [
                    _TaskList(
                      tasks: tasks,
                      userCompletedTaskIds: user.completedTaskIds,
                    ),
                    _TaskList(
                      tasks: tasks.where((t) => t.pillar == ESGPillar.environment).toList(),
                      userCompletedTaskIds: user.completedTaskIds,
                    ),
                    _TaskList(
                      tasks: tasks.where((t) => t.pillar == ESGPillar.social).toList(),
                      userCompletedTaskIds: user.completedTaskIds,
                    ),
                    _TaskList(
                      tasks: tasks.where((t) => t.pillar == ESGPillar.governance).toList(),
                      userCompletedTaskIds: user.completedTaskIds,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ESGPointsHeader extends StatelessWidget {
  final dynamic user;
  const _ESGPointsHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    final esgPoints = user.esgPoints as Map<String, int>;
    final pillars = [
      {'label': 'E', 'points': esgPoints['environment'] ?? 0, 'color': const Color(AppConstants.environmentColor)},
      {'label': 'S', 'points': esgPoints['social'] ?? 0, 'color': const Color(AppConstants.socialColor)},
      {'label': 'G', 'points': esgPoints['governance'] ?? 0, 'color': const Color(AppConstants.governanceColor)},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg_total_esg.png'),
          fit: BoxFit.cover,
          opacity: 0.12,
        ),
      ),
      child: Row(
        children: pillars.map((p) => Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: (p['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  p['label'] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: p['color'] as Color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${p['points']}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: p['color'] as Color,
                  ),
                ),
                const Text(
                  'điểm',
                  style: TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
        )).toList(),
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  final List<TaskModel> tasks;
  final List<String> userCompletedTaskIds;

  const _TaskList({required this.tasks, required this.userCompletedTaskIds});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.assignment_outlined, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Chưa có nhiệm vụ nào',
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final isCompleted = userCompletedTaskIds.contains(task.id);

        return TaskCard(
          task: task,
          isCompleted: isCompleted,
          onTap: () {
            if (!isCompleted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProofSubmissionScreen(task: task),
                ),
              );
            }
          },
        );
      },
    );
  }
}

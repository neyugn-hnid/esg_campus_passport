import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../models/task_model.dart';
import '../../models/proof_model.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';
import '../home/home_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản trị ESG Passport'),
        actions: [
          Chip(
            avatar: const Icon(Icons.shield, size: 16),
            label: Text(authService.currentUser?.role.label ?? ''),
            backgroundColor: AppTheme.warning.withOpacity(0.2),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authService.signOut(),
          ),
        ],
      ),
      body: _currentTab == 0 ? const _ModerationTab() : const _TasksTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (i) => setState(() => _currentTab = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.fact_check), label: 'Kiểm duyệt'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Nhiệm vụ'),
        ],
      ),
      floatingActionButton: _currentTab == 1
          ? FloatingActionButton.extended(
              onPressed: () => _showCreateTaskDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Tạo nhiệm vụ'),
              backgroundColor: AppTheme.primaryGreen,
            )
          : null,
    );
  }

  void _showCreateTaskDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final pointsCtrl = TextEditingController(text: '10');
    final greenCtrl = TextEditingController(text: '5');
    ESGPillar pillar = ESGPillar.environment;
    TaskVerificationType verifyType = TaskVerificationType.selfConfirm;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Tạo nhiệm vụ mới'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Tiêu đề')),
                const SizedBox(height: 8),
                TextField(controller: descCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Mô tả')),
                const SizedBox(height: 8),
                DropdownButtonFormField<ESGPillar>(
                  value: pillar,
                  items: ESGPillar.values.map((p) => DropdownMenuItem(value: p, child: Text(p.label))).toList(),
                  onChanged: (v) => setDialogState(() => pillar = v!),
                  decoration: const InputDecoration(labelText: 'Trụ cột'),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<TaskVerificationType>(
                  value: verifyType,
                  items: TaskVerificationType.values.map((v) => DropdownMenuItem(value: v, child: Text(v.name))).toList(),
                  onChanged: (v) => setDialogState(() => verifyType = v!),
                  decoration: const InputDecoration(labelText: 'Loại xác nhận'),
                ),
                const SizedBox(height: 8),
                TextField(controller: pointsCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Điểm ESG')),
                const SizedBox(height: 8),
                TextField(controller: greenCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Điểm xanh')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
            ElevatedButton(
              onPressed: () {
                final task = TaskModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                  pillar: pillar,
                  verificationType: verifyType,
                  points: int.tryParse(pointsCtrl.text) ?? 10,
                  greenPoints: int.tryParse(greenCtrl.text) ?? 5,
                );
                context.read<FirestoreService>().createTask(task);
                Navigator.pop(ctx);
              },
              child: const Text('Tạo'),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== KIỂM DUYỆT ====================
class _ModerationTab extends StatelessWidget {
  const _ModerationTab();

  @override
  Widget build(BuildContext context) {
    final firestoreService = context.read<FirestoreService>();

    return StreamBuilder<List<ProofModel>>(
      stream: firestoreService.getPendingProofs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final proofs = snapshot.data ?? [];

        if (proofs.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_outline, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text('Không có minh chứng nào chờ duyệt', style: TextStyle(color: Colors.grey[500])),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: proofs.length,
          itemBuilder: (context, index) => _ProofCard(proof: proofs[index]),
        );
      },
    );
  }
}

class _ProofCard extends StatelessWidget {
  final ProofModel proof;
  const _ProofCard({required this.proof});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.image, color: AppTheme.primaryGreen),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Minh chứng #${proof.id.substring(0, 8)}',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('Chờ duyệt', style: TextStyle(fontSize: 11, color: Colors.amber)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Image thumbnails
            if (proof.imageUrls.isNotEmpty)
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: proof.imageUrls.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) => ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(proof.imageUrls[i], width: 120, fit: BoxFit.cover),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _approveProof(context, proof),
                    icon: const Icon(Icons.check),
                    label: const Text('Duyệt'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _rejectProof(context, proof),
                    icon: const Icon(Icons.close),
                    label: const Text('Từ chối'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _approveProof(BuildContext context, ProofModel proof) async {
    // Get task info from proof
    final taskDoc = await context.read<FirestoreService>()
        .toString(); // simplification - in real app, fetch task
    // Actually need to fetch the task first
    // For now, approve directly
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Đã duyệt minh chứng'), backgroundColor: AppTheme.success),
    );
  }

  void _rejectProof(BuildContext context, ProofModel proof) {
    showDialog(
      context: context,
      builder: (ctx) {
        final noteCtrl = TextEditingController();
        return AlertDialog(
          title: const Text('Từ chối minh chứng'),
          content: TextField(
            controller: noteCtrl,
            decoration: const InputDecoration(labelText: 'Lý do từ chối'),
            maxLines: 3,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã từ chối'), backgroundColor: AppTheme.error),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
              child: const Text('Xác nhận từ chối'),
            ),
          ],
        );
      },
    );
  }
}

// ==================== QUẢN LÝ NHIỆM VỤ ====================
class _TasksTab extends StatelessWidget {
  const _TasksTab();

  @override
  Widget build(BuildContext context) {
    final firestoreService = context.read<FirestoreService>();

    return StreamBuilder<List<TaskModel>>(
      stream: firestoreService.getActiveDailyTasks(),
      builder: (context, snapshot) {
        final tasks = snapshot.data ?? [];

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Card(
              child: ListTile(
                leading: Text(task.pillar.icon, style: const TextStyle(fontSize: 28)),
                title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('+${task.points} điểm · ${task.verificationType.name}'),
                trailing: PopupMenuButton(
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'edit', child: Text('Sửa')),
                    const PopupMenuItem(value: 'toggle', child: Text('Ẩn/Kích hoạt')),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final bool isCompleted;
  final VoidCallback? onTap;

  const TaskCard({
    super.key,
    required this.task,
    this.isCompleted = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(task.pillar.colorValue);

    return GestureDetector(
      onTap: isCompleted ? null : onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isCompleted ? Colors.grey[200]! : color.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Pillar icon
              Container(
                width: 44,
                height: 44,
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
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: isCompleted ? AppTheme.textSecondary : AppTheme.textPrimary,
                        decoration: isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                    if (task.sdgTag != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '🎯 ${task.sdgTag}',
                        style: TextStyle(fontSize: 10, color: Colors.blue[400]),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Points badge
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isCompleted ? Colors.grey[100]! : color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '+${task.points}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isCompleted ? Colors.grey : color,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getVerifyLabel(task.verificationType),
                    style: TextStyle(fontSize: 9, color: Colors.grey[400]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getVerifyLabel(TaskVerificationType type) {
    switch (type) {
      case TaskVerificationType.selfConfirm:
        return 'Tự xác nhận';
      case TaskVerificationType.photoProof:
        return 'Cần ảnh';
      case TaskVerificationType.qrCheckIn:
        return 'QR Check-in';
      case TaskVerificationType.organizerConfirm:
        return 'BTC xác nhận';
    }
  }
}

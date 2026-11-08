import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../models/task_model.dart';
import '../../utils/theme.dart';

class ProofSubmissionScreen extends StatefulWidget {
  final TaskModel task;
  const ProofSubmissionScreen({super.key, required this.task});

  @override
  State<ProofSubmissionScreen> createState() => _ProofSubmissionScreenState();
}

class _ProofSubmissionScreenState extends State<ProofSubmissionScreen> {
  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  Future<void> _pickImage(ImageSource source) async {
    if (_images.length >= (widget.task.maxPhotos ?? 3)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tối đa ${widget.task.maxPhotos} ảnh')),
      );
      return;
    }

    final XFile? image = await _picker.pickImage(
      source: source,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() => _images.add(File(image.path)));
    }
  }

  void _removeImage(int index) {
    setState(() => _images.removeAt(index));
  }

  Future<void> _submit() async {
    if (_images.isEmpty && widget.task.verificationType.name == 'photoProof') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chụp ít nhất 1 ảnh minh chứng')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final authService = context.read<AuthService>();
      final firestoreService = context.read<FirestoreService>();

      await firestoreService.submitProof(
        taskId: widget.task.id,
        userId: authService.currentUser!.uid,
        images: _images,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Đã gửi minh chứng! Đang chờ kiểm duyệt.'),
            backgroundColor: AppTheme.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e'), backgroundColor: AppTheme.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return Scaffold(
      appBar: AppBar(title: const Text('Gửi minh chứng')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(task.pillar.icon, style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(task.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        Chip(label: Text('+${task.points} điểm')),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(task.description, style: const TextStyle(color: AppTheme.textSecondary)),
                    if (task.sdgTag != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('🎯 ${task.sdgTag}', style: TextStyle(fontSize: 11, color: Colors.blue[700])),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Photo guide
            if (task.photoGuide != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.amber),
                    const SizedBox(width: 8),
                    Expanded(child: Text(task.photoGuide!, style: const TextStyle(fontSize: 13))),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // Photos
            Text('Ảnh minh chứng (${_images.length}/${task.maxPhotos ?? 3})',
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._images.asMap().entries.map((entry) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          entry.value,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: -4,
                        right: -4,
                        child: IconButton(
                          icon: const Icon(Icons.remove_circle, color: AppTheme.error),
                          onPressed: () => _removeImage(entry.key),
                        ),
                      ),
                    ],
                  );
                }),
                if (_images.length < (task.maxPhotos ?? 3))
                  _AddPhotoButton(
                    onCamera: () => _pickImage(ImageSource.camera),
                    onGallery: () => _pickImage(ImageSource.gallery),
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('GỬI MINH CHỨNG'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddPhotoButton extends StatelessWidget {
  final VoidCallback onCamera;
  final VoidCallback onGallery;

  const _AddPhotoButton({required this.onCamera, required this.onGallery});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Chọn ảnh minh chứng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.camera_alt, color: AppTheme.primaryGreen),
                    title: const Text('Chụp ảnh mới'),
                    subtitle: const Text('Ưu tiên chụp trực tiếp trong app'),
                    onTap: () {
                      Navigator.pop(context);
                      onCamera();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_library, color: AppTheme.primaryBlue),
                    title: const Text('Chọn từ thư viện'),
                    onTap: () {
                      Navigator.pop(context);
                      onGallery();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!, width: 2),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[100],
        ),
        child: const Icon(Icons.add_a_photo, color: AppTheme.textSecondary, size: 32),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../models/community_item_model.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();
  CommunityItemType _type = CommunityItemType.giveaway;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (image != null) setState(() => _images.add(File(image.path)));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng thêm ít nhất 1 ảnh')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final authService = context.read<AuthService>();
      final firestoreService = context.read<FirestoreService>();
      final user = authService.currentUser!;

      final item = CommunityItemModel(
        id: '', // will be generated
        ownerId: user.uid,
        ownerName: user.fullName,
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        type: _type,
        price: _type == CommunityItemType.sell ? double.tryParse(_priceController.text) : null,
      );

      await firestoreService.createCommunityItem(
        CommunityItemModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          ownerId: item.ownerId,
          ownerName: item.ownerName,
          title: item.title,
          description: item.description,
          type: item.type,
          price: item.price,
        ),
        _images,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Đã đăng bài thành công!'), backgroundColor: AppTheme.success),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng đồ trao đổi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type selection
              Text('Loại bài đăng', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: CommunityItemType.values.map((type) {
                  final isSelected = _type == type;
                  return ChoiceChip(
                    label: Text(_getTypeLabel(type)),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _type = type),
                    selectedColor: AppTheme.primaryGreen.withOpacity(0.2),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Tiêu đề', hintText: 'VD: Giáo trình Tài chính doanh nghiệp'),
                validator: (v) => v?.isEmpty == true ? 'Vui lòng nhập tiêu đề' : null,
              ),
              const SizedBox(height: 12),

              // Description
              TextFormField(
                controller: _descController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Mô tả',
                  hintText: 'Mô tả tình trạng, lý do trao đổi...',
                ),
                validator: (v) => v?.isEmpty == true ? 'Vui lòng nhập mô tả' : null,
              ),
              const SizedBox(height: 12),

              // Price (only for sell)
              if (_type == CommunityItemType.sell)
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Giá (VNĐ)',
                    hintText: 'Giá ưu đãi cho sinh viên',
                    prefixIcon: Icon(Icons.monetization_on_outlined),
                  ),
                ),
              const SizedBox(height: 16),

              // Images
              Text('Ảnh sản phẩm', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ..._images.asMap().entries.map((entry) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(entry.value, width: 100, height: 100, fit: BoxFit.cover),
                        ),
                        Positioned(
                          top: -4,
                          right: -4,
                          child: IconButton(
                            icon: const Icon(Icons.remove_circle, color: AppTheme.error),
                            onPressed: () => setState(() => _images.removeAt(entry.key)),
                          ),
                        ),
                      ],
                    );
                  }),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.add_photo_alternate, color: AppTheme.textSecondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('ĐĂNG BÀI'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTypeLabel(CommunityItemType type) {
    switch (type) {
      case CommunityItemType.giveaway:
        return '🎁 Tặng miễn phí';
      case CommunityItemType.exchange:
        return '🔄 Trao đổi';
      case CommunityItemType.sell:
        return '💰 Bán giá thấp';
      case CommunityItemType.donate:
        return '💝 Quyên góp';
    }
  }
}

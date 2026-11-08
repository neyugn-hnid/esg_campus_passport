import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../models/community_item_model.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';
import '../../widgets/community_item_card.dart';
import 'create_post_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  CommunityItemType? _filterType;

  @override
  Widget build(BuildContext context) {
    final firestoreService = context.read<FirestoreService>();
    final authService = context.read<AuthService>();
    final user = authService.currentUser!;

    return Stack(
      children: [
        Column(
          children: [
            // Filter chips
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'Tất cả',
                      isSelected: _filterType == null,
                      onTap: () => setState(() => _filterType = null),
                    ),
                    ...CommunityItemType.values.map((type) => _FilterChip(
                      label: _getTypeLabel(type),
                      isSelected: _filterType == type,
                      onTap: () => setState(() => _filterType = type),
                    )),
                  ],
                ),
              ),
            ),

            // Items list
            Expanded(
              child: StreamBuilder<List<CommunityItemModel>>(
                stream: firestoreService.getCommunityItems(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var items = snapshot.data ?? [];
                  if (_filterType != null) {
                    items = items.where((i) => i.type == _filterType).toList();
                  }

                  if (items.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.volunteer_activism, size: 64, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text('Chưa có bài đăng nào', style: TextStyle(color: Colors.grey[500])),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return CommunityItemCard(item: items[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreatePostScreen()),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Đăng đồ'),
            backgroundColor: AppTheme.primaryGreen,
          ),
        ),
      ],
    );
  }

  String _getTypeLabel(CommunityItemType type) {
    switch (type) {
      case CommunityItemType.giveaway:
        return '🎁 Tặng';
      case CommunityItemType.exchange:
        return '🔄 Trao đổi';
      case CommunityItemType.sell:
        return '💰 Bán';
      case CommunityItemType.donate:
        return '💝 Quyên góp';
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: AppTheme.primaryGreen.withOpacity(0.2),
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.primaryGreen : AppTheme.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}

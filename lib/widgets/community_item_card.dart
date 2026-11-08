import 'package:flutter/material.dart';
import '../models/community_item_model.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';

class CommunityItemCard extends StatelessWidget {
  final CommunityItemModel item;
  const CommunityItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Navigate to item detail
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: item.imageUrls.isNotEmpty
                    ? Image.network(
                        item.imageUrls.first,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholderImage(),
                      )
                    : _placeholderImage(),
              ),
              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                        ),
                        _TypeBadge(type: item.type),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.person_outline, size: 14, color: Colors.grey[400]),
                        const SizedBox(width: 4),
                        Text(item.ownerName, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                        const SizedBox(width: 12),
                        if (item.type == CommunityItemType.sell && item.price != null)
                          Text(
                            '${item.price!.toInt()}đ',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryOrange,
                              fontSize: 14,
                            ),
                          ),
                        if (item.type == CommunityItemType.giveaway)
                          const Text('🎁 Miễn phí', style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.image, color: Colors.grey),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final CommunityItemType type;
  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;

    switch (type) {
      case CommunityItemType.giveaway:
        label = 'Tặng';
        color = AppTheme.success;
        break;
      case CommunityItemType.exchange:
        label = 'Đổi';
        color = AppTheme.primaryBlue;
        break;
      case CommunityItemType.sell:
        label = 'Bán';
        color = AppTheme.primaryOrange;
        break;
      case CommunityItemType.donate:
        label = 'Quyên góp';
        color = Colors.purple;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
    );
  }
}

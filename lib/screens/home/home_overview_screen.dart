import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../utils/theme.dart';

class HomeOverviewScreen extends StatelessWidget {
  const HomeOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().currentUser!;
    final esg = user.esgPoints;
    final environment = esg['environment'] ?? 0;
    final social = esg['social'] ?? 0;
    final governance = esg['governance'] ?? 0;
    final total = environment + social + governance;

    return SafeArea(
      bottom: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 390),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(user: user),
                const SizedBox(height: 14),
                _Greeting(user: user),
                const SizedBox(height: 10),
                _ScoreCard(
                  total: total,
                  verified: user.greenPoints,
                  pending: 30,
                  environment: environment,
                  social: social,
                  governance: governance,
                ),
                const SizedBox(height: 12),
                const _ProofCard(),
                const SizedBox(height: 12),
                _SectionTitle(
                  title: 'Nhiệm vụ hôm nay',
                  action: 'Xem tất cả',
                  onTap: () {},
                ),
                const SizedBox(height: 8),
                const _TodayTasks(),
                const SizedBox(height: 16),
                const Text(
                  'Lối tắt cộng đồng',
                  style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 10),
                const _CommunityShortcuts(),
                const SizedBox(height: 14),
                _SectionTitle(
                  title: 'Hoạt động gần đây',
                  action: 'Xem tất cả',
                  onTap: () {},
                ),
                const SizedBox(height: 8),
                const _RecentActivities(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final UserModel user;

  const _Header({required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/images/logo_header.png',
          width: 64,
          height: 64,
          fit: BoxFit.contain,
        ),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ESG Campus Passport',
                style: TextStyle(
                  fontSize: 20,
                  height: 1.1,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF07515B),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Hộ chiếu ESG sinh viên',
                style: TextStyle(
                    fontSize: 12.5,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        _Avatar(user: user),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final UserModel user;

  const _Avatar({required this.user});

  @override
  Widget build(BuildContext context) {
    final initials = user.fullName.trim().isEmpty
        ? 'SV'
        : user.fullName.trim().characters.first.toUpperCase();

    return Container(
      width: 50,
      height: 50,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFEAF8F1),
        border: Border.all(color: const Color(0xFFD5F0E4), width: 1.4),
      ),
      child: CircleAvatar(
        backgroundColor: const Color(0xFFDDF4EA),
        backgroundImage: user.avatarUrl == null
            ? null
            : CachedNetworkImageProvider(user.avatarUrl!),
        child: user.avatarUrl == null
            ? Text(initials,
                style: const TextStyle(
                    color: Color(0xFF07515B), fontWeight: FontWeight.w800))
            : null,
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  final UserModel user;

  const _Greeting({required this.user});

  @override
  Widget build(BuildContext context) {
    final name = user.fullName.trim().isEmpty
        ? 'Sinh viên'
        : user.fullName.trim().split(' ').last;

    return Row(
      children: [
        const Text('👋', style: TextStyle(fontSize: 19)),
        const SizedBox(width: 6),
        Text.rich(
          TextSpan(
            text: 'Chào, ',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary),
            children: [
              TextSpan(
                text: name,
                style: const TextStyle(
                    fontWeight: FontWeight.w900, color: Color(0xFF132E64)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final int total;
  final int verified;
  final int pending;
  final int environment;
  final int social;
  final int governance;

  const _ScoreCard({
    required this.total,
    required this.verified,
    required this.pending,
    required this.environment,
    required this.social,
    required this.governance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/bg_total_esg.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFBDECD8)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF07965E).withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tổng điểm ESG',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$total',
                      style: const TextStyle(
                        fontSize: 40,
                        height: 1,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF08784E),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _StatusPill(
                          icon: Icons.check_circle_rounded,
                          label: 'Đã xác thực: $verified',
                          color: const Color(0xFF099268),
                          background: const Color(0xFFE5F8EF),
                        ),
                        _StatusPill(
                          icon: Icons.hourglass_bottom_rounded,
                          label: 'Chờ duyệt: $pending',
                          color: const Color(0xFFD97706),
                          background: const Color(0xFFFFF1DA),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _EsgBars(
              environment: environment, social: social, governance: governance),
        ],
      ),
    );
  }
}

class _EarthBadge extends StatelessWidget {
  const _EarthBadge();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 122,
      height: 92,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              width: 112,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFFDFF4E9),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          const Positioned(
              left: 8,
              bottom: 8,
              child: _LeafStem(color: Color(0xFF42B883), flip: true)),
          const Positioned(
              right: 6, bottom: 7, child: _LeafStem(color: Color(0xFF65C98E))),
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF42C5B6), Color(0xFF0E8A8A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFF0E8A8A).withValues(alpha: 0.16),
                    blurRadius: 16,
                    offset: const Offset(0, 8)),
              ],
            ),
            child: const Icon(Icons.public_rounded,
                color: Color(0xFFBFF3CB), size: 58),
          ),
        ],
      ),
    );
  }
}

class _LeafStem extends StatelessWidget {
  final Color color;
  final bool flip;

  const _LeafStem({required this.color, this.flip = false});

  @override
  Widget build(BuildContext context) {
    final leaves = Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        4,
        (index) => Padding(
          padding: EdgeInsets.only(left: index.isEven ? 0 : 12, bottom: 2),
          child: Icon(Icons.eco_rounded,
              color: color.withValues(alpha: 0.78),
              size: 16 - index.toDouble()),
        ),
      ),
    );
    return Transform.scale(scaleX: flip ? -1 : 1, child: leaves);
  }
}

class _EsgBars extends StatelessWidget {
  final int environment;
  final int social;
  final int governance;

  const _EsgBars(
      {required this.environment,
      required this.social,
      required this.governance});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _EsgMetric(
            icon: Icons.eco_rounded,
            label: 'E - Môi trường',
            value: environment,
            color: const Color(0xFF13A36F),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _EsgMetric(
            icon: Icons.groups_rounded,
            label: 'S - Xã hội',
            value: social,
            color: const Color(0xFF2D7DE8),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _EsgMetric(
            icon: Icons.account_balance_rounded,
            label: 'G - Quản trị',
            value: governance,
            color: const Color(0xFF8F76D8),
          ),
        ),
      ],
    );
  }
}

class _EsgMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final Color color;

  const _EsgMetric(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    final progress = (value / 120).clamp(0.12, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            color: color,
            backgroundColor: color.withValues(alpha: 0.12),
          ),
        ),
        const SizedBox(height: 7),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Icon(icon, color: color, size: 15),
              const SizedBox(width: 4),
              Text(
                '$label: $value',
                style: TextStyle(
                    fontSize: 10.8, fontWeight: FontWeight.w800, color: color),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProofCard extends StatelessWidget {
  const _ProofCard();

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
                color: Color(0xFFDDF5EA), shape: BoxShape.circle),
            child: const Icon(Icons.camera_alt_rounded,
                color: Color(0xFF087060), size: 30),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Minh chứng ESG',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textPrimary),
                ),
                SizedBox(height: 5),
                Text(
                  'Chụp trực tiếp trong app để xác nhận nhiệm vụ hoặc hoạt động',
                  style: TextStyle(
                      fontSize: 10.8,
                      height: 1.35,
                      color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.camera_alt_rounded, size: 15),
            label: const Text('Chụp minh chứng'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              textStyle:
                  const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800),
              backgroundColor: const Color(0xFF07965E),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback onTap;

  const _SectionTitle(
      {required this.title, required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w900,
                color: AppTheme.textPrimary),
          ),
        ),
        TextButton.icon(
          onPressed: onTap,
          label: Text(action),
          icon: const Icon(Icons.chevron_right_rounded),
          iconAlignment: IconAlignment.end,
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
            foregroundColor: const Color(0xFF0B62C4),
            textStyle:
                const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _TodayTasks extends StatelessWidget {
  const _TodayTasks();

  @override
  Widget build(BuildContext context) {
    const tasks = [
      _TaskData(Icons.water_drop_outlined, 'Mang bình\nnước cá nhân', 'E',
          '+5 điểm', Color(0xFF13A36F), Color(0xFFD9F4E4)),
      _TaskData(Icons.inventory_2_outlined, 'Đăng 1 món đồ\nkhông dùng', 'E/S',
          '+10 điểm', Color(0xFF2D7DE8), Color(0xFFDCEAFF)),
      _TaskData(Icons.receipt_long_outlined, 'Lưu hóa đơn\nchi tiêu nhóm', 'G',
          '+10 điểm', Color(0xFF8F76D8), Color(0xFFE8E1FF)),
    ];

    return Row(
      children: [
        for (var i = 0; i < tasks.length; i++) ...[
          Expanded(child: _TaskCard(data: tasks[i])),
          if (i != tasks.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _TaskCard extends StatelessWidget {
  final _TaskData data;

  const _TaskCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE7EAF0)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(data.icon, color: data.color, size: 22),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 3),
          Expanded(
            child: Text(
              data.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 10.2,
                  height: 1.12,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary),
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                    color: data.background,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(data.tag,
                    style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: data.color)),
              ),
              const Spacer(),
              FittedBox(
                child: Text(
                  data.points,
                  style: const TextStyle(
                      fontSize: 10.8,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF08784E)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CommunityShortcuts extends StatelessWidget {
  const _CommunityShortcuts();

  @override
  Widget build(BuildContext context) {
    const items = [
      _ShortcutData(Icons.autorenew_rounded, Icons.checkroom_rounded,
          'Trao đổi đồ cũ', Color(0xFF16A085), Color(0xFFD9FBEE)),
      _ShortcutData(Icons.pan_tool_alt_outlined, Icons.favorite_rounded,
          'Tình nguyện', Color(0xFFE74C3C), Color(0xFFFFE8E8)),
      _ShortcutData(Icons.tips_and_updates_outlined, Icons.eco_rounded,
          'Ý tưởng xanh', Color(0xFF7CB342), Color(0xFFEAF8D8)),
      _ShortcutData(Icons.account_balance_rounded, Icons.flag_rounded,
          'Hoạt động trường', Color(0xFF2376C9), Color(0xFFE2F0FF)),
    ];

    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          Expanded(child: _ShortcutItem(data: items[i])),
          if (i != items.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _ShortcutItem extends StatelessWidget {
  final _ShortcutData data;

  const _ShortcutItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: data.background,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                  color: data.color.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 5)),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(data.baseIcon, color: data.color, size: 31),
              Positioned(
                  right: 13,
                  top: 10,
                  child: Icon(data.accentIcon, color: data.color, size: 17)),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          data.label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontSize: 10.8,
              height: 1.2,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary),
        ),
      ],
    );
  }
}

class _RecentActivities extends StatelessWidget {
  const _RecentActivities();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8ECF1)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 14,
              offset: const Offset(0, 6)),
        ],
      ),
      child: const Column(
        children: [
          _ActivityRow(
            image:
                'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?auto=format&fit=crop&w=240&q=80',
            title: 'Ngày hội trồng cây xanh',
            meta: '18/05/2025  •  Campus Green',
            status: 'Chờ duyệt',
            statusIcon: Icons.hourglass_bottom_rounded,
            statusColor: Color(0xFFD97706),
            statusBackground: Color(0xFFFFF1DA),
          ),
          Divider(height: 1, color: Color(0xFFE8ECF1)),
          _ActivityRow(
            image:
                'https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&w=240&q=80',
            title: 'Tặng giáo trình cũ',
            meta: '15/05/2025  •  Thư viện',
            status: 'Đã xác thực',
            statusIcon: Icons.check_circle_rounded,
            statusColor: Color(0xFF099268),
            statusBackground: Color(0xFFE5F8EF),
          ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final String image;
  final String title;
  final String meta;
  final String status;
  final IconData statusIcon;
  final Color statusColor;
  final Color statusBackground;

  const _ActivityRow({
    required this.image,
    required this.title,
    required this.meta,
    required this.status,
    required this.statusIcon,
    required this.statusColor,
    required this.statusBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: image,
              width: 74,
              height: 50,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                  width: 74, height: 50, color: const Color(0xFFE8F2ED)),
              errorWidget: (_, __, ___) => Container(
                width: 74,
                height: 50,
                color: const Color(0xFFE8F2ED),
                child: const Icon(Icons.image_outlined,
                    color: AppTheme.textSecondary),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 12.2,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined,
                        size: 12, color: AppTheme.textSecondary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        meta,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 9.8,
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          _StatusPill(
              icon: statusIcon,
              label: status,
              color: statusColor,
              background: statusBackground),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right_rounded,
              color: AppTheme.textSecondary),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color background;

  const _StatusPill(
      {required this.icon,
      required this.label,
      required this.color,
      required this.background});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
          color: background, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 10.5, fontWeight: FontWeight.w800, color: color)),
        ],
      ),
    );
  }
}

class _SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _SoftCard({required this.child, required this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF4FFFA), Color(0xFFFFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFBDECD8)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF07965E).withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _TaskData {
  final IconData icon;
  final String title;
  final String tag;
  final String points;
  final Color color;
  final Color background;

  const _TaskData(this.icon, this.title, this.tag, this.points, this.color,
      this.background);
}

class _ShortcutData {
  final IconData baseIcon;
  final IconData accentIcon;
  final String label;
  final Color color;
  final Color background;

  const _ShortcutData(
      this.baseIcon, this.accentIcon, this.label, this.color, this.background);
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../utils/theme.dart';
import 'home_overview_screen.dart';
import '../quest/daily_quest_screen.dart';
import '../community/community_screen.dart';
import '../proof/proof_screen.dart';
import '../passport/passport_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final _pages = const [
    HomeOverviewScreen(),
    DailyQuestScreen(),
    CommunityScreen(),
    ProofScreen(),
    PassportScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final user = authService.currentUser;
    final isHome = _currentIndex == 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isHome
          ? null
          : AppBar(
              title: Row(
                children: [
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: ClipRect(
                      child: Transform.scale(
                        scale: 1.6,
                        child: Image.asset(
                          'assets/images/logo_header.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getAppBarTitle(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      if (user != null)
                        Text(
                          '${user.fullName} · ${user.greenPoints} XP xanh',
                          style: const TextStyle(
                              fontSize: 11, color: AppTheme.textSecondary),
                        ),
                    ],
                  ),
                ],
              ),
              actions: [
                if (user != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Chip(
                      avatar: const Icon(Icons.eco,
                          size: 16, color: AppTheme.primaryGreen),
                      label: Text(
                        '${user.greenPoints} XP',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      backgroundColor:
                          AppTheme.primaryGreen.withValues(alpha: 0.1),
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => authService.signOut(),
                  tooltip: 'Đăng xuất',
                ),
              ],
            ),
      body: _pages[_currentIndex],
      bottomNavigationBar: SafeArea(
        top: false,
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 390),
            child: Container(
              padding: const EdgeInsets.fromLTRB(8, 7, 8, 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 14,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _NavItem(
                    icon: Icons.home_rounded,
                    label: 'Trang chủ',
                    selected: _currentIndex == 0,
                    onTap: () => setState(() => _currentIndex = 0),
                  ),
                  _NavItem(
                    icon: Icons.fact_check_outlined,
                    label: 'Daily Quest',
                    selected: _currentIndex == 1,
                    onTap: () => setState(() => _currentIndex = 1),
                  ),
                  _NavItem(
                    icon: Icons.groups_2_outlined,
                    label: 'Cộng đồng',
                    selected: _currentIndex == 2,
                    onTap: () => setState(() => _currentIndex = 2),
                  ),
                  _NavItem(
                    icon: Icons.camera_alt_outlined,
                    label: 'Minh chứng',
                    selected: _currentIndex == 3,
                    onTap: () => setState(() => _currentIndex = 3),
                  ),
                  _NavItem(
                    icon: Icons.badge_outlined,
                    label: 'Passport',
                    selected: _currentIndex == 4,
                    onTap: () => setState(() => _currentIndex = 4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Trang chủ';
      case 1:
        return 'ESG Daily Quest';
      case 2:
        return 'ESG Cộng đồng';
      case 3:
        return 'Minh chứng';
      case 4:
        return 'ESG Passport';
      default:
        return 'ESG Campus';
    }
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppTheme.primaryGreen : AppTheme.textSecondary;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 22, color: color),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 10.2,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: selected ? 38 : 0,
                height: 3,
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

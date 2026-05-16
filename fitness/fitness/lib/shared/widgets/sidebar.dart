import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitpulse_gym/features/auth/repositories/auth_repository.dart';
import 'package:fitpulse_gym/core/providers/firebase_providers.dart';
import 'dart:ui';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitpulse_gym/config/theme/app_theme.dart';

class FitPulseSidebar extends ConsumerStatefulWidget {
  const FitPulseSidebar({super.key});

  @override
  ConsumerState<FitPulseSidebar> createState() => _FitPulseSidebarState();
}

class _FitPulseSidebarState extends ConsumerState<FitPulseSidebar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getMenuItems(String? role) {
    if (role == 'admin') {
      return [
        {'icon': LucideIcons.layoutDashboard, 'label': 'Dashboard', 'route': '/admin'},
        {'icon': LucideIcons.users, 'label': 'Members', 'route': '/admin/members'},
        {'icon': LucideIcons.userCheck, 'label': 'Trainers', 'route': '/admin/trainers'},
        {'icon': LucideIcons.creditCard, 'label': 'Membership Plans', 'route': '/admin/plans'},
        {'icon': LucideIcons.calendarCheck, 'label': 'Attendance', 'route': '/admin/attendance'},
        {'icon': LucideIcons.banknote, 'label': 'Payments', 'route': '/admin/payments'},
        {'icon': LucideIcons.dumbbell, 'label': 'Workouts', 'route': '/admin/workouts'},
        {'icon': LucideIcons.apple, 'label': 'Nutrition', 'route': '/admin/nutrition'},
        {'icon': LucideIcons.bell, 'label': 'Notifications', 'route': '/admin/notifications'},
        {'icon': LucideIcons.settings, 'label': 'Settings', 'route': '/admin/settings'},
      ];
    } else {
      return [
        {'icon': LucideIcons.home, 'label': 'Dashboard', 'route': '/'},
        {'icon': LucideIcons.user, 'label': 'My Profile', 'route': '/profile'},
        {'icon': LucideIcons.dumbbell, 'label': 'Workouts', 'route': '/workouts'},
        {'icon': LucideIcons.utensils, 'label': 'Nutrition', 'route': '/nutrition'},
        {'icon': LucideIcons.trendingUp, 'label': 'Progress', 'route': '/analytics'},
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.toString();
    final role = ref.watch(userRoleProvider);
    final user = ref.watch(authStateProvider).value;
    final menuItems = _getMenuItems(role);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      width: 300,
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark 
                    ? [const Color(0xFF0B0F14).withOpacity(0.95), const Color(0xFF1E2630).withOpacity(0.9)]
                    : [const Color(0xFFF8FAFC).withOpacity(0.95), const Color(0xFFE2E8F0).withOpacity(0.9)],
              ),
              border: Border(
                right: BorderSide(color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05), width: 1.5),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context, user, role),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Divider(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.1)),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: menuItems.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = menuItems[index];
                          final isSelected = currentPath == item['route'];
                          return _buildMenuItem(context, item, isSelected);
                        },
                      ),
                    ),
                  ),
                  _buildBottomSection(context, ref),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic user, String? role) {
    final isAdmin = role == 'admin';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isAdmin 
                        ? [Colors.redAccent, Colors.orangeAccent] 
                        : [AppTheme.primary, AppTheme.secondary],
                  ),
                ),
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: isDark ? const Color(0xFF0B0F14) : Colors.white,
                  backgroundImage: NetworkImage(
                    user?.photoURL ?? (isAdmin 
                        ? 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=200' 
                        : 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=200'),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isAdmin ? Colors.redAccent : AppTheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: isDark ? const Color(0xFF0B0F14) : Colors.white, width: 2),
                ),
                child: Icon(
                  isAdmin ? LucideIcons.shieldCheck : LucideIcons.check,
                  size: 12,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            isAdmin ? 'ADMIN CONSOLE' : (user?.displayName ?? 'FitPulse Member'),
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              fontFamily: 'Outfit',
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isAdmin ? Colors.red.withOpacity(0.1) : AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isAdmin ? Colors.redAccent.withOpacity(0.3) : AppTheme.primary.withOpacity(0.3),
              ),
            ),
            child: Text(
              isAdmin ? 'SUPER ADMIN' : 'ELITE MEMBER',
              style: TextStyle(
                color: isAdmin ? Colors.redAccent : AppTheme.primary,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, Map<String, dynamic> item, bool isSelected) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        context.go(item['route']);
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? (isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05)) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? (isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)) : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(
              item['icon'],
              size: 20,
              color: isSelected ? AppTheme.primary : (isDark ? Colors.white60 : Colors.black45),
            ),
            const SizedBox(width: 16),
            Text(
              item['label'],
              style: TextStyle(
                color: isSelected ? (isDark ? Colors.white : Colors.black) : (isDark ? Colors.white60 : Colors.black54),
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
            if (isSelected) ...[
              const Spacer(),
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: AppTheme.primary, blurRadius: 4)],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              await ref.read(authRepositoryProvider).signOut();
              ref.read(userRoleProvider.notifier).setRole(null);
              if (mounted) context.go('/login');
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.redAccent.withOpacity(0.1)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.logOut, color: Colors.redAccent, size: 18),
                  SizedBox(width: 12),
                  Text(
                    'Terminate Session',
                    style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'SYSTEM SECURE • V4.8.0',
            style: TextStyle(
              color: isDark ? Colors.white24 : Colors.black26,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}

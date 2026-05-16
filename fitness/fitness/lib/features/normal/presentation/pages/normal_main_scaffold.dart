import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitpulse_gym/config/theme/app_theme.dart';
import 'dart:ui';

class NormalMainScaffold extends ConsumerWidget {
  final Widget child;
  const NormalMainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    int currentIndex = 0;
    if (location == '/') currentIndex = 0;
    else if (location == '/workouts') currentIndex = 1;
    else if (location == '/nutrition') currentIndex = 2;
    else if (location == '/analytics') currentIndex = 3;
    else if (location == '/profile') currentIndex = 4;

    return Scaffold(
      extendBody: true, // Allows content to flow behind bottom nav
      body: child,
      bottomNavigationBar: Container(
        height: 100,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: isDark 
                    ? Colors.white.withOpacity(0.05) 
                    : Colors.black.withOpacity(0.02),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: currentIndex,
                onTap: (index) {
                  switch (index) {
                    case 0: context.go('/'); break;
                    case 1: context.go('/workouts'); break;
                    case 2: context.go('/nutrition'); break;
                    case 3: context.go('/analytics'); break;
                    case 4: context.go('/profile'); break;
                  }
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: AppTheme.primary,
                unselectedItemColor: isDark ? Colors.white38 : Colors.black26,
                selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
                unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                items: [
                  _buildNavItem(LucideIcons.home, 'HOME'),
                  _buildNavItem(LucideIcons.dumbbell, 'WORKOUTS'),
                  _buildNavItem(LucideIcons.utensils, 'DIET'),
                  _buildNavItem(LucideIcons.trendingUp, 'STATS'),
                  _buildNavItem(LucideIcons.user, 'ME'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon, size: 22),
      activeIcon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 22, color: AppTheme.primary),
      ),
      label: label,
    );
  }
}

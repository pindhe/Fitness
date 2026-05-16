import 'package:fitpulse_gym/features/auth/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitpulse_gym/features/normal/home/presentation/pages/dashboard_page.dart';
import 'package:fitpulse_gym/features/normal/presentation/pages/normal_main_scaffold.dart';
import 'package:fitpulse_gym/features/normal/workouts/presentation/pages/workout_plans_page.dart';
import 'package:fitpulse_gym/features/auth/presentation/pages/login_page.dart';
import 'package:fitpulse_gym/features/auth/presentation/pages/register_page.dart';
import 'package:fitpulse_gym/features/normal/analytics/presentation/pages/analytics_page.dart';
import 'package:fitpulse_gym/features/normal/nutrition/presentation/pages/nutrition_page.dart';
import 'package:fitpulse_gym/features/normal/profile/presentation/pages/profile_page.dart';
import 'package:fitpulse_gym/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:fitpulse_gym/features/admin/presentation/pages/member_management_page.dart';
import 'package:fitpulse_gym/features/admin/presentation/pages/workout_management_page.dart';
import 'package:fitpulse_gym/features/admin/presentation/pages/admin_trainers_page.dart';
import 'package:fitpulse_gym/features/admin/presentation/pages/admin_plans_page.dart';
import 'package:fitpulse_gym/features/admin/presentation/pages/admin_attendance_page.dart';
import 'package:fitpulse_gym/features/admin/presentation/pages/admin_payments_page.dart';
import 'package:fitpulse_gym/features/admin/presentation/pages/admin_nutrition_page.dart';
import 'package:fitpulse_gym/features/admin/presentation/pages/admin_notifications_page.dart';
import 'package:fitpulse_gym/features/admin/presentation/pages/admin_reports_page.dart';
import 'package:fitpulse_gym/features/admin/presentation/pages/admin_analytics_page.dart';
import 'package:fitpulse_gym/features/admin/presentation/pages/admin_settings_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final authRepo = ref.read(authRepositoryProvider);
      final isLoggedIn = authRepo.currentUser != null;
      final role = ref.read(userRoleProvider);
      final isLoggingIn = state.uri.toString() == '/login';
      final isRegistering = state.uri.toString() == '/register';

      // Admin hardcoded logic (role set during login)
      if (role == 'admin') {
        if (state.uri.toString().startsWith('/admin')) return null;
        return '/admin';
      }

      if (!isLoggedIn && !isLoggingIn && !isRegistering) {
        return '/login';
      }

      if (isLoggedIn && (isLoggingIn || isRegistering)) {
        return '/';
      }

      return null;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) => NormalMainScaffold(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'dashboard',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: '/workouts',
            name: 'workouts',
            builder: (context, state) => const WorkoutPlansPage(),
          ),
          GoRoute(
            path: '/nutrition',
            name: 'nutrition',
            builder: (context, state) => const NutritionPage(),
          ),
          GoRoute(
            path: '/analytics',
            name: 'analytics',
            builder: (context, state) => const AnalyticsPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/admin',
        name: 'admin_dashboard',
        builder: (context, state) => const AdminDashboardPage(),
      ),
      GoRoute(
        path: '/admin/members',
        name: 'member_management',
        builder: (context, state) => const MemberManagementPage(),
      ),
      GoRoute(
        path: '/admin/workouts',
        name: 'workout_management',
        builder: (context, state) => const WorkoutManagementPage(),
      ),
      GoRoute(
        path: '/admin/trainers',
        name: 'admin_trainers',
        builder: (context, state) => const AdminTrainersPage(),
      ),
      GoRoute(
        path: '/admin/plans',
        name: 'admin_plans',
        builder: (context, state) => const AdminPlansPage(),
      ),
      GoRoute(
        path: '/admin/attendance',
        name: 'admin_attendance',
        builder: (context, state) => const AdminAttendancePage(),
      ),
      GoRoute(
        path: '/admin/payments',
        name: 'admin_payments',
        builder: (context, state) => const AdminPaymentsPage(),
      ),
      GoRoute(
        path: '/admin/nutrition',
        name: 'admin_nutrition',
        builder: (context, state) => const AdminNutritionPage(),
      ),
      GoRoute(
        path: '/admin/notifications',
        name: 'admin_notifications',
        builder: (context, state) => const AdminNotificationsPage(),
      ),
      GoRoute(
        path: '/admin/reports',
        name: 'admin_reports',
        builder: (context, state) => const AdminReportsPage(),
      ),
      GoRoute(
        path: '/admin/analytics',
        name: 'admin_analytics',
        builder: (context, state) => const AdminAnalyticsPage(),
      ),
      GoRoute(
        path: '/admin/settings',
        name: 'admin_settings',
        builder: (context, state) => const AdminSettingsPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
    ],
  );
});

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitpulse_gym/shared/widgets/glass_card.dart';
import 'package:fitpulse_gym/config/theme/app_theme.dart';
import 'package:fitpulse_gym/core/providers/firebase_providers.dart';
import 'package:fitpulse_gym/features/auth/repositories/auth_repository.dart';
import 'package:fitpulse_gym/features/admin/repositories/member_repository.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final memberState = ref.watch(currentMemberProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark 
                    ? [const Color(0xFF0B0F14), const Color(0xFF1E2630), const Color(0xFF0B0F14)]
                    : [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0), const Color(0xFFF8FAFC)],
                ),
              ),
            ),
          ),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      memberState.when(
                        data: (member) => Column(
                          children: [
                            _buildProfileHeader(context, user, member),
                            const SizedBox(height: 35),
                            _buildStatsRow(context, member),
                            const SizedBox(height: 35),
                            _buildInfoSection(context, member),
                          ],
                        ),
                        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primary)),
                        error: (e, __) => Text('Error: $e'),
                      ),
                      const SizedBox(height: 35),
                      _buildSettingsSection(context, ref),
                      const SizedBox(height: 50),
                      _buildLogoutButton(context, ref),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 0,
      toolbarHeight: 90,
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      title: const Text('BIOMETRIC PROFILE', style: TextStyle(letterSpacing: 3, fontSize: 18, fontWeight: FontWeight.w900, fontFamily: 'Outfit')),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
          ),
          child: IconButton(
            icon: const Icon(LucideIcons.check, size: 20, color: AppTheme.primary),
            onPressed: () {},
            tooltip: 'Save Profile',
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: IconButton(
            icon: const Icon(LucideIcons.edit3, size: 20),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context, dynamic user, dynamic member) {
    final workouts = member?.totalWorkouts ?? 0;
    final plan = member?.membershipPlan ?? 'Basic';
    final level = (workouts / 5).floor() + 1; // Simple level logic

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.secondary]),
                boxShadow: [
                  BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 25, spreadRadius: -5)
                ],
              ),
              child: CircleAvatar(
                radius: 65,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                backgroundImage: NetworkImage(user?.photoURL ?? 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=200'),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 3),
              ),
              child: const Icon(LucideIcons.camera, size: 18, color: Colors.black),
            ),
          ],
        ).animate().scale(curve: Curves.easeOutBack),
        const SizedBox(height: 24),
        Text(
          member?.name ?? user?.displayName ?? 'Warrior',
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.5),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
          ),
          child: Text(
            'ELITE LEVEL $level • ${plan.toUpperCase()}',
            style: const TextStyle(color: AppTheme.primary, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context, dynamic member) {
    return Row(
      children: [
        _buildMiniStat(context, 'SESSIONS', '${member?.totalWorkouts ?? 0}', 'qty'),
        const SizedBox(width: 14),
        _buildMiniStat(context, 'WEIGHT', '74.5', 'kg'),
        const SizedBox(width: 14),
        _buildMiniStat(context, 'GOAL', 'SHRED', ''),
      ],
    );
  }

  Widget _buildMiniStat(BuildContext context, String label, String value, String unit) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4), letterSpacing: 1)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                if (unit.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3, left: 2),
                    child: Text(unit, style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.3), fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, dynamic member) {
    final plan = member?.membershipPlan ?? 'Basic';
    final since = member != null ? '${member.createdAt.day}/${member.createdAt.month}/${member.createdAt.year}' : 'N/A';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('VAULT DETAILS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.primary, letterSpacing: 2)),
        const SizedBox(height: 16),
        GlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildInfoTile(context, LucideIcons.creditCard, 'Subscription', 'Protocol $plan'),
              const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: Colors.white10, height: 1)),
              _buildInfoTile(context, LucideIcons.calendar, 'Joined Hub', since),
              const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: Colors.white10, height: 1)),
              _buildInfoTile(context, LucideIcons.shieldCheck, 'Access Level', 'Root Verified'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 18, color: AppTheme.primary),
        ),
        const SizedBox(width: 18),
        Text(label, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6), fontWeight: FontWeight.bold)),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PREFERENCES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.primary, letterSpacing: 2)),
        const SizedBox(height: 16),
        GlassCard(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _buildSettingsTile(context, LucideIcons.moon, 'Adaptive Dark Mode', trailing: Switch(value: true, onChanged: (v) {}, activeColor: AppTheme.primary)),
              _buildSettingsTile(context, LucideIcons.languages, 'System Language', trailing: const Text('EN-US', style: TextStyle(color: Colors.white38, fontWeight: FontWeight.w900, fontSize: 11))),
              _buildSettingsTile(context, LucideIcons.lock, 'Privacy Protocol'),
              _buildSettingsTile(context, LucideIcons.bell, 'Neural Alerts'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(BuildContext context, IconData icon, String label, {Widget? trailing}) {
    return ListTile(
      leading: Icon(icon, size: 20, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5)),
      title: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      trailing: trailing ?? Icon(LucideIcons.chevronRight, size: 16, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.2)),
      onTap: () {},
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () async {
        await ref.read(authRepositoryProvider).signOut();
        ref.read(userRoleProvider.notifier).setRole(null);
        if (context.mounted) context.go('/login');
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.redAccent.withOpacity(0.2)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.logOut, color: Colors.redAccent, size: 20),
            const SizedBox(width: 14),
            Text('TERMINATE SESSION', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

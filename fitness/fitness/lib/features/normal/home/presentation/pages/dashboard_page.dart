import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitpulse_gym/shared/widgets/glass_card.dart';
import 'package:fitpulse_gym/core/providers/firebase_providers.dart';
import 'package:fitpulse_gym/features/admin/repositories/member_repository.dart';
import 'package:fitpulse_gym/features/normal/attendance/presentation/pages/attendance_page.dart';
import 'package:fitpulse_gym/features/normal/membership/presentation/pages/membership_page.dart';
import 'package:fitpulse_gym/features/normal/trainers/presentation/pages/trainer_booking_page.dart';
import 'package:fitpulse_gym/config/theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final memberState = ref.watch(currentMemberProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Dynamic Background Gradients
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
          
          // Floating Glow Orbs for Micro-interactions
          _buildFloatingGlow(context),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context, authState.value),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      memberState.when(
                        data: (member) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildGreeting(context, member?.username ?? authState.value?.displayName ?? 'Warrior'),
                            const SizedBox(height: 30),
                            _buildQuickActions(context),
                            const SizedBox(height: 35),
                            _buildMainStats(context, member),
                            const SizedBox(height: 35),
                            _buildPerformanceChart(context),
                            const SizedBox(height: 35),
                            _buildUpcomingSession(context),
                            const SizedBox(height: 35),
                            _buildMembershipStatus(context, member),
                          ],
                        ),
                        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primary)),
                        error: (e, __) => _buildGreeting(context, 'Error Loading'),
                      ),
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

  Widget _buildFloatingGlow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Positioned(
      top: -100,
      right: -50,
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.primary.withOpacity(isDark ? 0.05 : 0.1),
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true))
       .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 4.seconds)
       .blur(begin: const Offset(50, 50), end: const Offset(80, 80)),
    );
  }

  Widget _buildAppBar(BuildContext context, dynamic user) {
    final textTheme = Theme.of(context).textTheme;
    return SliverAppBar(
      expandedHeight: 0,
      toolbarHeight: 90,
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.secondary]),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: -2,
                )
              ],
            ),
            child: CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage(user?.photoURL ?? 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=100'),
            ),
          ).animate().scale(delay: 200.ms, curve: Curves.easeOutBack),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FITPULSE',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                  color: Theme.of(context).colorScheme.primary,
                  fontFamily: 'Outfit',
                ),
              ),
              Text(
                'Elite Protocol',
                style: TextStyle(
                  fontSize: 10, 
                  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5), 
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        _buildAppBarAction(
          context, 
          LucideIcons.bell, 
          onPressed: () => _showNotifications(context),
        ),
        const SizedBox(width: 10),
        _buildAppBarAction(
          context, 
          LucideIcons.settings, 
          onPressed: () => context.go('/profile'),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  void _showNotifications(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassCard(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('NEURAL ALERTS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1)),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(LucideIcons.x, size: 20)),
              ],
            ),
            const SizedBox(height: 20),
            _buildNotificationItem(context, 'Protocol Updated', 'New HIIT Shred routines available.', LucideIcons.zap, AppTheme.primary),
            _buildNotificationItem(context, 'Achievement Unlocked', '7-day metabolic streak achieved!', LucideIcons.award, Colors.amberAccent),
            _buildNotificationItem(context, 'System Alert', 'Trainer Marcus is online for neural sync.', LucideIcons.activity, Colors.blueAccent),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, String title, String sub, IconData icon, Color color) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 18),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(sub, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5), fontSize: 12)),
      trailing: Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
    );
  }

  Widget _buildAppBarAction(BuildContext context, IconData icon, {required VoidCallback onPressed}) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildGreeting(BuildContext context, String name) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Hello, $name',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.secondary]),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.2), blurRadius: 10)],
                  ),
                  child: const Text(
                    'PRO',
                    style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w900),
                  ),
                ).animate().fadeIn(delay: 300.ms).scale(curve: Curves.easeOutBack),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Your metabolism is peaked today. Ready to push?',
              style: textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.5),
              ),
            ).animate().fadeIn(delay: 200.ms),
          ],
        ),
        IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Dashboard Customization Protocol Initiated...'),
                backgroundColor: AppTheme.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          icon: const Icon(LucideIcons.pencil, size: 16),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.05),
            padding: const EdgeInsets.all(12),
          ),
          tooltip: 'Customize Dashboard',
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildActionItem(context, 'Workouts', LucideIcons.play, AppTheme.primary, () => context.go('/workouts')),
          _buildActionItem(context, 'Nutrition', LucideIcons.apple, Colors.orangeAccent, () => context.go('/nutrition')),
          _buildActionItem(context, 'Scan QR', LucideIcons.qrCode, Colors.blueAccent, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AttendancePage()))),
          _buildActionItem(context, 'Trainers', LucideIcons.calendar, Colors.purpleAccent, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TrainerBookingPage()))),
          _buildActionItem(context, 'Analysis', LucideIcons.lineChart, Colors.pinkAccent, () => context.go('/analytics')),
        ],
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, String label, IconData icon, Color color, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        child: Column(
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: color.withOpacity(isDark ? 0.1 : 0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: color.withOpacity(isDark ? 0.2 : 0.1)),
                boxShadow: [
                  if (!isDark) BoxShadow(color: color.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
                ],
              ),
              child: Icon(icon, color: color, size: 26),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
             .shimmer(delay: 2.seconds, duration: 1.seconds, color: Colors.white.withOpacity(0.2)),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 11, 
                color: Theme.of(context).textTheme.bodySmall?.color, 
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _buildMainStats(BuildContext context, dynamic member) {
    final workouts = member?.totalWorkouts ?? 0;
    final progress = (workouts / 50).clamp(0.1, 1.0); // Assuming 50 is a goal

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('TOTAL SESSIONS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4), letterSpacing: 1.5)),
                    const Icon(LucideIcons.activity, size: 18, color: AppTheme.primary),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('$workouts', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900, letterSpacing: -1)),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8, left: 4),
                      child: Text('units', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.3))),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 8,
                    width: double.infinity,
                    color: Theme.of(context).dividerColor.withOpacity(0.05),
                    child: Stack(
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) => Container(
                            width: constraints.maxWidth * progress,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.secondary]),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 10)],
                            ),
                          ),
                        ).animate().shimmer(duration: 2.seconds),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(workouts >= 50 ? 'Elite target reached.' : '${50 - workouts} sessions to next rank.', style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6))),
              ],
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildSmallStatCard(context, 'Energy', '1.2k', LucideIcons.flame, Colors.orangeAccent),
              const SizedBox(height: 20),
              _buildSmallStatCard(context, 'Rank', workouts > 20 ? 'Master' : 'Novice', LucideIcons.shield, Colors.blueAccent),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSmallStatCard(BuildContext context, String label, String value, IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4), fontWeight: FontWeight.bold)),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Biometric Performance',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.5),
        ),
        const SizedBox(height: 20),
        GlassCard(
          height: 240,
          padding: const EdgeInsets.fromLTRB(10, 30, 20, 10),
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    const FlSpot(0, 3), const FlSpot(1, 4.5), const FlSpot(2, 3.8),
                    const FlSpot(3, 6), const FlSpot(4, 5.2), const FlSpot(5, 7),
                    const FlSpot(6, 6.5),
                  ],
                  isCurved: true,
                  color: AppTheme.primary,
                  barWidth: 6,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppTheme.primary.withOpacity(0.3), AppTheme.primary.withOpacity(0)],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingSession(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Neural Training',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.5),
        ),
        const SizedBox(height: 20),
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1594381898411-846e7d193883?w=200'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Hyper-Focus HIIT', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                    Text('Coach Marcus • Master Level', style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5), fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                          child: const Text('17:30', style: TextStyle(color: AppTheme.primary, fontSize: 12, fontWeight: FontWeight.w900)),
                        ),
                        const SizedBox(width: 12),
                        Icon(LucideIcons.mapPin, size: 14, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.3)),
                        const SizedBox(width: 4),
                        Text('Studio Alpha', style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4), fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle),
                child: const Icon(LucideIcons.chevronRight, size: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMembershipStatus(BuildContext context, dynamic member) {
    final plan = member?.membershipPlan ?? 'Basic';
    final isActive = member?.status == 'Active';

    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('STATUS: ${isActive ? 'ACTIVE' : 'INACTIVE'}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: isActive ? AppTheme.primary.withOpacity(0.8) : Colors.redAccent, letterSpacing: 2)),
                  const SizedBox(height: 6),
                  Text('Protocol $plan', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                ],
              ),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: plan == 'Elite' ? [Colors.amberAccent, Colors.orangeAccent] : [Colors.blueAccent, Colors.purpleAccent]),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: plan == 'Elite' ? Colors.amberAccent.withOpacity(0.3) : Colors.blueAccent.withOpacity(0.3), blurRadius: 10)],
                ),
                child: Icon(plan == 'Elite' ? LucideIcons.crown : LucideIcons.shield, color: Colors.black, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('MEMBER SINCE', style: TextStyle(fontSize: 9, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4), fontWeight: FontWeight.w900, letterSpacing: 1)),
                    Text(member != null ? '${member.createdAt.day} ${_getMonth(member.createdAt.month)} ${member.createdAt.year}' : 'Not Available', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MembershipPage())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('MANAGE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}

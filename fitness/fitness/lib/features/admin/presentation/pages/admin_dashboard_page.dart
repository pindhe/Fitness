import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitpulse_gym/shared/widgets/glass_card.dart';
import 'package:fitpulse_gym/shared/widgets/sidebar.dart';
import 'package:fitpulse_gym/core/providers/firebase_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fitpulse_gym/shared/widgets/admin_footer.dart';
import 'package:fitpulse_gym/shared/widgets/footer.dart';
import 'dart:ui';

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      drawer: const FitPulseSidebar(), 
      backgroundColor: const Color(0xFF0B0F14), // Premium dark background
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildTopNavBar(context, authState.value),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeHeader(authState.value?.displayName ?? 'Admin'),
                    const SizedBox(height: 32),
                    _buildTopStatsGrid(),
                    const SizedBox(height: 32),
                    _buildAnalyticsSection(),
                    const SizedBox(height: 32),
                    _buildQuickActions(context),
                    const SizedBox(height: 32),
                    _buildRecentActivity(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: FitPulseFooter()),
          ],
        ),
      ),
      bottomNavigationBar: const FitPulseAdminFooter(currentRoute: '/admin'),
    );
  }

  Widget _buildTopNavBar(BuildContext context, dynamic user) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: const Color(0xFF0B0F14).withOpacity(0.95),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(LucideIcons.menu, color: Colors.white),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            const Icon(LucideIcons.search, color: Colors.white54, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Search nodes, protocols, telemetry...',
                  hintStyle: TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          offset: const Offset(0, 50),
          color: const Color(0xFF1E2630),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.white.withOpacity(0.1)),
          ),
          icon: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                const Badge(
                  backgroundColor: Color(0xFF00FF88),
                  smallSize: 8,
                  child: Icon(LucideIcons.bell, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 12,
                  backgroundImage: NetworkImage(
                    user?.photoURL ?? 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop',
                  ),
                ),
                const Icon(LucideIcons.chevronDown, color: Colors.white54, size: 14),
              ],
            ),
          ),
          onSelected: (value) {
            if (value == 'notifications') context.go('/admin/notifications');
            if (value == 'settings') context.go('/admin/settings');
            if (value == 'messages') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Comms Interface Initializing...'), backgroundColor: Color(0xFF3B82F6)),
              );
            }
          },
          itemBuilder: (context) => [
            _buildPopupItem('notifications', LucideIcons.bell, 'Alert Center', '4 New'),
            _buildPopupItem('messages', LucideIcons.messageSquare, 'Direct Comms', 'Online'),
            _buildPopupItem('settings', LucideIcons.settings, 'System Node', 'Admin'),
          ],
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupItem(String value, IconData icon, String title, String subtitle) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00FF88), size: 18),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader(String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dashboard',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            color: Colors.white,
          ),
        ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1),
        const SizedBox(height: 6),
        Text(
          'Welcome back, $name. Here is what is happening today.',
          style: const TextStyle(color: Colors.white60, fontSize: 14),
        ).animate().fadeIn(delay: 200.ms),
      ],
    );
  }

  Widget _buildTopStatsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 800 ? 4 : (constraints.maxWidth > 500 ? 2 : 1);
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: constraints.maxWidth > 500 ? 1.5 : 2.0,
          children: [
            _buildStatCard('Total Members', '2,842', '+12.5%', LucideIcons.users, const Color(0xFF00FF88), true),
            _buildStatCard('Monthly Revenue', '\$48,290', '+8.2%', LucideIcons.banknote, const Color(0xFF3B82F6), true),
            _buildStatCard('Active Trainers', '24', '-2.1%', LucideIcons.userCheck, Colors.orangeAccent, false),
            _buildStatCard('Daily Attendance', '428', '+15.4%', LucideIcons.calendarCheck, Colors.purpleAccent, true),
          ],
        );
      }
    );
  }

  Widget _buildStatCard(String label, String value, String trend, IconData icon, Color color, bool isPositive) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (isPositive ? const Color(0xFF00FF88) : Colors.redAccent).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      isPositive ? LucideIcons.trendingUp : LucideIcons.trendingDown,
                      size: 12,
                      color: isPositive ? const Color(0xFF00FF88) : Colors.redAccent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      trend,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isPositive ? const Color(0xFF00FF88) : Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white54),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildAnalyticsSection() {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Revenue Analytics',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'This Year',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: Colors.white.withOpacity(0.05), strokeWidth: 1);
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const style = TextStyle(color: Colors.white54, fontSize: 12);
                        Widget text;
                        switch (value.toInt()) {
                          case 0: text = const Text('Jan', style: style); break;
                          case 2: text = const Text('Mar', style: style); break;
                          case 4: text = const Text('May', style: style); break;
                          case 6: text = const Text('Jul', style: style); break;
                          case 8: text = const Text('Sep', style: style); break;
                          case 10: text = const Text('Nov', style: style); break;
                          default: text = const Text('', style: style); break;
                        }
                        return SideTitleWidget(meta: meta, child: text);
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text('\$${value.toInt()}k', style: const TextStyle(color: Colors.white54, fontSize: 12));
                      },
                      reservedSize: 42,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: 50,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 15),
                      FlSpot(1, 22),
                      FlSpot(2, 18),
                      FlSpot(3, 28),
                      FlSpot(4, 35),
                      FlSpot(5, 32),
                      FlSpot(6, 42),
                      FlSpot(7, 38),
                      FlSpot(8, 48),
                      FlSpot(9, 45),
                      FlSpot(10, 50),
                    ],
                    isCurved: true,
                    color: const Color(0xFF00FF88),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF00FF88).withOpacity(0.15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildActionChip(context, 'Add Member', LucideIcons.userPlus, const Color(0xFF00FF88), () => context.push('/admin/members')),
              const SizedBox(width: 12),
              _buildActionChip(context, 'New Workout', LucideIcons.dumbbell, const Color(0xFF3B82F6), () => context.push('/admin/workouts')),
              const SizedBox(width: 12),
              _buildActionChip(context, 'Record Payment', LucideIcons.banknote, Colors.orangeAccent, () {}),
              const SizedBox(width: 12),
              _buildActionChip(context, 'Scan QR', LucideIcons.scanLine, Colors.purpleAccent, () {}),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionChip(BuildContext context, String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('View All', style: TextStyle(color: Color(0xFF3B82F6))),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildActivityItem('New membership sold: Premium Plan', 'By Trainer Alex', '10 mins ago', LucideIcons.creditCard, Colors.orangeAccent),
        _buildActivityItem('Member checked in', 'Sarah Jenkins', '25 mins ago', LucideIcons.checkCircle, const Color(0xFF00FF88)),
        _buildActivityItem('New workout assigned', 'To John Doe', '1 hour ago', LucideIcons.dumbbell, const Color(0xFF3B82F6)),
      ],
    );
  }

  Widget _buildActivityItem(String title, String subtitle, String time, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          Text(time, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white38)),
        ],
      ),
    );
  }
}


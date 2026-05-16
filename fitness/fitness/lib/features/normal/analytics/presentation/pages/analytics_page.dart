import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitpulse_gym/shared/widgets/glass_card.dart';
import 'package:fitpulse_gym/config/theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopStats(context),
                      const SizedBox(height: 35),
                      _buildWeightChart(context),
                      const SizedBox(height: 40),
                      Text(
                        'ACTIVITY METRICS',
                        style: TextStyle(
                          fontSize: 12, 
                          fontWeight: FontWeight.w900, 
                          letterSpacing: 2,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ).animate().fadeIn(),
                      const SizedBox(height: 20),
                      _buildActivityGrid(context),
                      const SizedBox(height: 40),
                      Text(
                        'MILESTONES & BADGES',
                        style: TextStyle(
                          fontSize: 12, 
                          fontWeight: FontWeight.w900, 
                          letterSpacing: 2,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ).animate().fadeIn(),
                      const SizedBox(height: 20),
                      _buildAchievementSection(context),
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
      title: const Text('PERFORMANCE ANALYTICS', style: TextStyle(letterSpacing: 3, fontSize: 18, fontWeight: FontWeight.w900, fontFamily: 'Outfit')),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: IconButton(
            icon: const Icon(LucideIcons.fileText, size: 20, color: AppTheme.secondary),
            onPressed: () {},
            tooltip: 'Export Report',
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
            icon: const Icon(LucideIcons.share2, size: 20),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildTopStats(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('PRIMARY METRICS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2, color: AppTheme.primary)),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(LucideIcons.edit2, size: 12),
              label: const Text('EDIT GOALS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildSummaryCard(context, 'BMI INDEX', '22.4', 'Optimal', AppTheme.primary),
            const SizedBox(width: 20),
            _buildSummaryCard(context, 'WEIGHT', '74.5', '-1.2kg', Colors.orangeAccent),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(BuildContext context, String label, String value, String sub, Color color) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4), letterSpacing: 1.5)),
            const SizedBox(height: 16),
            Text(value, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: -1)),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(LucideIcons.trendingDown, size: 14, color: color),
                const SizedBox(width: 6),
                Text(sub, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightChart(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Weight Transformation', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(LucideIcons.plus, size: 14),
              label: const Text('LOG WEIGHT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.secondary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                minimumSize: Size.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        GlassCard(
          height: 250,
          padding: const EdgeInsets.fromLTRB(10, 30, 20, 10),
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    const FlSpot(0, 80), const FlSpot(1, 78.5), const FlSpot(2, 79),
                    const FlSpot(3, 76.2), const FlSpot(4, 75.8), const FlSpot(5, 74.5),
                  ],
                  isCurved: true,
                  color: AppTheme.secondary,
                  barWidth: 6,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppTheme.secondary.withOpacity(0.3), AppTheme.secondary.withOpacity(0)],
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

  Widget _buildActivityGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      childAspectRatio: 1.4,
      children: [
        _buildMiniStat(context, 'Total Sessions', '48', LucideIcons.dumbbell, Colors.blueAccent),
        _buildMiniStat(context, 'Neural Sync', '2,840m', LucideIcons.zap, Colors.orangeAccent),
        _buildMiniStat(context, 'Peak Output', '12.4k', LucideIcons.flame, Colors.redAccent),
        _buildMiniStat(context, 'Hub Visits', '24', LucideIcons.mapPin, Colors.greenAccent),
      ],
    );
  }

  Widget _buildMiniStat(BuildContext context, String label, String value, IconData icon, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 20, color: color),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -1)),
              Text(label, style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4), fontWeight: FontWeight.w900, letterSpacing: 0.5)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementSection(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildBadge(context, 'STREAK KING', LucideIcons.zap, Colors.orangeAccent),
          _buildBadge(context, 'ALPHA ELITE', LucideIcons.award, Colors.purpleAccent),
          _buildBadge(context, 'EARLY DAWN', LucideIcons.sun, Colors.yellowAccent),
          _buildBadge(context, 'VITALITY+', LucideIcons.heartPulse, Colors.redAccent),
        ],
      ),
    );
  }

  Widget _buildBadge(BuildContext context, String label, IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(right: 24),
      child: Column(
        children: [
          Container(
            width: 85,
            height: 85,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
              ),
              border: Border.all(color: color.withOpacity(0.3), width: 2),
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.15), blurRadius: 20, spreadRadius: -5)
              ],
            ),
            child: Icon(icon, color: color, size: 36),
          ),
          const SizedBox(height: 14),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5), letterSpacing: 1)),
        ],
      ),
    );
  }
}

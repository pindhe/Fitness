import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fitpulse_gym/shared/widgets/glass_card.dart';
import 'package:fitpulse_gym/shared/widgets/sidebar.dart';
import 'package:fitpulse_gym/shared/widgets/admin_footer.dart';
import 'dart:ui';

class ReportsAnalyticsPage extends StatefulWidget {
  const ReportsAnalyticsPage({super.key});

  @override
  State<ReportsAnalyticsPage> createState() => _ReportsAnalyticsPageState();
}

class _ReportsAnalyticsPageState extends State<ReportsAnalyticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const FitPulseSidebar(),
      backgroundColor: const Color(0xFF050816),
      bottomNavigationBar: const FitPulseAdminFooter(currentRoute: '/admin/reports'),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050816),
        elevation: 0,
        title: const Text('ANALYTICS ENGINE', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2)),
        leading: Builder(builder: (context) => IconButton(icon: const Icon(LucideIcons.menu, color: Colors.white), onPressed: () => Scaffold.of(context).openDrawer())),
        actions: [
          IconButton(icon: const Icon(LucideIcons.download, color: Color(0xFF06B6D4)), onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRevenueMatrix(),
            const SizedBox(height: 32),
            _buildSectionHeader('GROWTH TELEMETRY', LucideIcons.trendingUp),
            const SizedBox(height: 16),
            _buildGrowthChart(),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(child: _buildMetricWidget('MEMBERSHIP', '1,242', '+12%', const Color(0xFF00FF9D))),
                const SizedBox(width: 16),
                Expanded(child: _buildMetricWidget('RETENTION', '94.2%', '+2%', const Color(0xFF06B6D4))),
              ],
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('SQUAD PERFORMANCE', LucideIcons.users),
            const SizedBox(height: 16),
            _buildTrainerPerformanceList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF06B6D4), size: 16),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(color: Color(0xFF06B6D4), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
      ],
    );
  }

  Widget _buildRevenueMatrix() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('GROSS REVENUE', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFF00FF9D).withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Text('LIVE', style: TextStyle(color: Color(0xFF00FF9D), fontSize: 8, fontWeight: FontWeight.bold))),
              ],
            ),
            const SizedBox(height: 8),
            const Text('\$142,850', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
            const SizedBox(height: 24),
            Row(
              children: [
                _buildSmallStat('Monthly', '+\$12,400'),
                const SizedBox(width: 24),
                _buildSmallStat('Annual Exp.', '+\$420K'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallStat(String l, String v) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l, style: const TextStyle(color: Colors.white24, fontSize: 10)),
        Text(v, style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildGrowthChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: const [FlSpot(0, 3), FlSpot(1, 1), FlSpot(2, 4), FlSpot(3, 2), FlSpot(4, 5), FlSpot(5, 3), FlSpot(6, 4)],
              isCurved: true,
              color: const Color(0xFF06B6D4),
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: true, color: const Color(0xFF06B6D4).withOpacity(0.1)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricWidget(String label, String value, String trend, Color color) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1)),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(trend, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainerPerformanceList() {
    return Column(
      children: List.generate(3, (index) => _buildPerformanceTile(index)),
    );
  }

  Widget _buildPerformanceTile(int index) {
    final names = ['Marcus Steel', 'Alex Mercer', 'Sarah Apex'];
    final rating = ['9.8', '9.4', '9.1'];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: Colors.white12, radius: 16, child: Text(names[index][0], style: const TextStyle(color: Colors.white, fontSize: 10))),
              const SizedBox(width: 12),
              Text(names[index], style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              const Icon(LucideIcons.star, color: Colors.amber, size: 12),
              const SizedBox(width: 4),
              Text(rating[index], style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

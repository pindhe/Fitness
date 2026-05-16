import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitpulse_gym/shared/widgets/sidebar.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:fitpulse_gym/shared/widgets/admin_footer.dart';

class AdminAnalyticsPage extends ConsumerWidget {
  const AdminAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: const FitPulseSidebar(),
      backgroundColor: const Color(0xFF0B0F14),
      bottomNavigationBar: const FitPulseAdminFooter(currentRoute: '/admin/analytics'),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F14).withOpacity(0.95),
        elevation: 0,
        title: const Text('Advanced Analytics', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(LucideIcons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.share2, color: Colors.white70, size: 20),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAnalyticsHeader(),
            const SizedBox(height: 32),
            _buildMetricsGrid(),
            const SizedBox(height: 32),
            _buildMainChartSection(),
            const SizedBox(height: 32),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 900) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _buildRevenueSection()),
                      const SizedBox(width: 24),
                      Expanded(flex: 2, child: _buildDemographicSection()),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildRevenueSection(),
                      const SizedBox(height: 24),
                      _buildDemographicSection(),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 32),
            _buildActivityHeatmap(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Strategic Insights', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -1)),
            const SizedBox(height: 4),
            Text('Aggregated performance data for Q2 Fiscal Year', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14)),
          ],
        ),
        _buildDateFilter(),
      ],
    ).animate().fadeIn().slideX(begin: -0.05);
  }

  Widget _buildDateFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: const Row(
        children: [
          Icon(LucideIcons.calendar, color: Color(0xFF00FF88), size: 16),
          SizedBox(width: 12),
          Text('MAY 01 - MAY 30', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1)),
          SizedBox(width: 12),
          Icon(LucideIcons.chevronDown, color: Colors.white38, size: 16),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return Row(
      children: [
        Expanded(child: _buildMetricCard('ACTIVE NODES', '1,284', '+12.5%', const Color(0xFF00FF88))),
        const SizedBox(width: 16),
        Expanded(child: _buildMetricCard('NET REVENUE', '\$84.2K', '+18.2%', const Color(0xFF3B82F6))),
        const SizedBox(width: 16),
        Expanded(child: _buildMetricCard('RETENTION', '94.2%', '+2.1%', Colors.purpleAccent)),
        const SizedBox(width: 16),
        Expanded(child: _buildMetricCard('CHURN RATE', '1.8%', '-0.5%', Colors.redAccent)),
      ],
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _buildMetricCard(String title, String value, String trend, Color color) {
    final isPositive = trend.startsWith('+');
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(isPositive ? LucideIcons.trendingUp : LucideIcons.trendingDown, color: isPositive ? const Color(0xFF00FF88) : Colors.redAccent, size: 14),
              const SizedBox(width: 4),
              Text(trend, style: TextStyle(color: isPositive ? const Color(0xFF00FF88) : Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainChartSection() {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.01)],
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Member Engagement Flux', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('Daily active users vs New signups', style: TextStyle(color: Colors.white38, fontSize: 12)),
                ],
              ),
              _buildChartLegend(),
            ],
          ),
          const SizedBox(height: 40),
          Expanded(
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (spot) => const Color(0xFF1E2630),
                    tooltipBorder: BorderSide(color: Colors.white.withOpacity(0.1)),
                    getTooltipItems: (spots) => spots.map((s) => LineTooltipItem('${s.y.toInt()} Users', const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))).toList(),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(color: Colors.white.withOpacity(0.05), strokeWidth: 1),
                ),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [const FlSpot(0, 40), const FlSpot(2, 65), const FlSpot(4, 55), const FlSpot(6, 85), const FlSpot(8, 75), const FlSpot(10, 95), const FlSpot(12, 110)],
                    isCurved: true,
                    color: const Color(0xFF00FF88),
                    barWidth: 4,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: true, gradient: LinearGradient(colors: [const Color(0xFF00FF88).withOpacity(0.2), Colors.transparent], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                  ),
                  LineChartBarData(
                    spots: [const FlSpot(0, 20), const FlSpot(2, 35), const FlSpot(4, 30), const FlSpot(6, 45), const FlSpot(8, 40), const FlSpot(10, 55), const FlSpot(12, 60)],
                    isCurved: true,
                    color: const Color(0xFF3B82F6),
                    barWidth: 4,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: true, gradient: LinearGradient(colors: [const Color(0xFF3B82F6).withOpacity(0.2), Colors.transparent], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildChartLegend() {
    return Row(
      children: [
        _buildLegendItem('Active', const Color(0xFF00FF88)),
        const SizedBox(width: 16),
        _buildLegendItem('Signups', const Color(0xFF3B82F6)),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 12, height: 4, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildRevenueSection() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Subscription Revenue Node', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 28),
          _buildRevenueRow('Basic Tier', '\$12,480', 0.25, Colors.white70),
          _buildRevenueRow('Pro Tier', '\$34,290', 0.45, const Color(0xFF3B82F6)),
          _buildRevenueRow('Elite Tier', '\$48,120', 0.65, const Color(0xFF00FF88)),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: const Color(0xFF00FF88).withOpacity(0.05), borderRadius: BorderRadius.circular(20)),
            child: const Row(
              children: [
                Icon(LucideIcons.zap, color: Color(0xFF00FF88), size: 28),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('High Conversion Detected', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('Pro Tier conversions are up 24% following the May campaign.', style: TextStyle(color: Colors.white38, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildRevenueRow(String label, String value, double progress, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: Colors.white60, fontSize: 14)),
              Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: progress, backgroundColor: Colors.white.withOpacity(0.05), valueColor: AlwaysStoppedAnimation<Color>(color), minHeight: 6),
          ),
        ],
      ),
    );
  }

  Widget _buildDemographicSection() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Member Density', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          Center(
            child: SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 8,
                  centerSpaceRadius: 50,
                  sections: [
                    PieChartSectionData(value: 65, color: const Color(0xFF00FF88), title: '65%', radius: 25, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    PieChartSectionData(value: 25, color: const Color(0xFF3B82F6), title: '25%', radius: 20, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    PieChartSectionData(value: 10, color: Colors.purpleAccent, title: '10%', radius: 15, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          _buildDemographicLabel('18-24 Year Olds', '65%', const Color(0xFF00FF88)),
          _buildDemographicLabel('25-34 Year Olds', '25%', const Color(0xFF3B82F6)),
          _buildDemographicLabel('35+ Year Olds', '10%', Colors.purpleAccent),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _buildDemographicLabel(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 13)),
          const Spacer(),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildActivityHeatmap() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Peak Engagement Hours', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(24, (index) {
              final opacity = (index > 6 && index < 10) || (index > 16 && index < 21) ? 0.8 : 0.1;
              return Expanded(
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(color: const Color(0xFF00FF88).withOpacity(opacity), borderRadius: BorderRadius.circular(4)),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('00:00', style: TextStyle(color: Colors.white24, fontSize: 10)),
              Text('06:00', style: TextStyle(color: Colors.white24, fontSize: 10)),
              Text('12:00', style: TextStyle(color: Colors.white24, fontSize: 10)),
              Text('18:00', style: TextStyle(color: Colors.white24, fontSize: 10)),
              Text('23:59', style: TextStyle(color: Colors.white24, fontSize: 10)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms);
  }
}


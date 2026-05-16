import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fitpulse_gym/shared/widgets/glass_card.dart';
import 'package:fitpulse_gym/shared/widgets/sidebar.dart';
import 'package:fitpulse_gym/shared/widgets/admin_footer.dart';
import 'package:fitpulse_gym/shared/widgets/neon_button.dart';
import 'dart:ui';

class AdminReportsPage extends ConsumerWidget {
  const AdminReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: const FitPulseSidebar(),
      backgroundColor: const Color(0xFF050816),
      bottomNavigationBar: const FitPulseAdminFooter(currentRoute: '/admin/reports'),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050816),
        elevation: 0,
        title: const Text('ANALYTICS & REPORTS', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2)),
        leading: Builder(builder: (context) => IconButton(icon: const Icon(LucideIcons.menu, color: Colors.white), onPressed: () => Scaffold.of(context).openDrawer())),
        actions: [
          IconButton(icon: const Icon(LucideIcons.download, color: Color(0xFF06B6D4)), onPressed: () => _handleAutoDownloadAll(context)),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReportSummaryGrid(),
            const SizedBox(height: 32),
            _buildSectionHeader('GROWTH TELEMETRY', LucideIcons.trendingUp),
            const SizedBox(height: 16),
            _buildGrowthChart(),
            const SizedBox(height: 32),
            _buildSectionHeader('DOWNLOADABLE INTEL', LucideIcons.fileText),
            const SizedBox(height: 16),
            _buildDownloadableReportsSection(),
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

  Widget _buildReportSummaryGrid() {
    return Row(
      children: [
        Expanded(child: _buildSummaryCard('RETENTION', '88%', '+2.4%', const Color(0xFF00FF88))),
        const SizedBox(width: 16),
        Expanded(child: _buildSummaryCard('SIGNUPS', '124', '+18%', const Color(0xFF3B82F6))),
      ],
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _buildSummaryCard(String title, String value, String trend, Color color) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text(title, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1))),
                const SizedBox(width: 8),
                Text(trend, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }

  Widget _buildGrowthChart() {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(24),
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

  Widget _buildDownloadableReportsSection() {
    return Column(
      children: [
        _buildReportFileItem('Monthly Financial Summary - April 2024', 'PDF • 2.4 MB', LucideIcons.fileText, const Color(0xFF00FF88)),
        _buildReportFileItem('Member Attendance Analysis - Q1 2024', 'XLSX • 1.1 MB', LucideIcons.fileSpreadsheet, const Color(0xFF3B82F6)),
        _buildReportFileItem('Trainer Performance Review', 'PDF • 0.8 MB', LucideIcons.userCheck, Colors.orangeAccent),
      ],
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildReportFileItem(String name, String meta, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 20)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                Text(meta, style: const TextStyle(color: Colors.white38, fontSize: 11)),
              ],
            ),
          ),
          IconButton(icon: const Icon(LucideIcons.download, color: Colors.white38, size: 18), onPressed: () {}),
        ],
      ),
    );
  }

  void _handleAutoDownloadAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: const Color(0xFF050816),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: BorderSide(color: const Color(0xFF06B6D4).withOpacity(0.3))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.downloadCloud, color: Color(0xFF06B6D4), size: 48).animate(onPlay: (c) => c.repeat()).scale(duration: 1000.ms).fadeOut(),
              const SizedBox(height: 24),
              const Text('GLOBAL EXTRACTION', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              const Text('Compressing and exporting all telemetry nodes to a unified report package...', textAlign: TextAlign.center, style: TextStyle(color: Colors.white38, fontSize: 13)),
              const SizedBox(height: 32),
              NeonButton(label: 'INITIALIZE DOWNLOAD', onPressed: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }
}

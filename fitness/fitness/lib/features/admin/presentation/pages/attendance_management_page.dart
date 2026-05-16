import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitpulse_gym/shared/widgets/glass_card.dart';
import 'package:fitpulse_gym/shared/widgets/sidebar.dart';
import 'package:fitpulse_gym/shared/widgets/admin_footer.dart';
import 'dart:ui';

class AttendanceManagementPage extends StatefulWidget {
  const AttendanceManagementPage({super.key});

  @override
  State<AttendanceManagementPage> createState() => _AttendanceManagementPageState();
}

class _AttendanceManagementPageState extends State<AttendanceManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const FitPulseSidebar(),
      backgroundColor: const Color(0xFF050816),
      bottomNavigationBar: const FitPulseAdminFooter(currentRoute: '/admin/attendance'),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050816),
        elevation: 0,
        title: const Text('ATTENDANCE HUB', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2)),
        leading: Builder(builder: (context) => IconButton(icon: const Icon(LucideIcons.menu, color: Colors.white), onPressed: () => Scaffold.of(context).openDrawer())),
        actions: [
          IconButton(icon: const Icon(LucideIcons.qrCode, color: Color(0xFF00FF9D)), onPressed: () => _showScannerModal()),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLiveStatusRow(),
            const SizedBox(height: 32),
            _buildSectionHeader('LIVE TELEMETRY', LucideIcons.activity),
            const SizedBox(height: 16),
            _buildAttendanceStatsGrid(),
            const SizedBox(height: 32),
            _buildSectionHeader('RECENT CHECK-INS', LucideIcons.clock),
            const SizedBox(height: 16),
            _buildRecentAttendanceList(),
            const SizedBox(height: 40),
            _buildAttendanceHeatmap(),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveStatusRow() {
    return Row(
      children: [
        _buildLiveIndicator(),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SYSTEM ACTIVE', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
            Text('Monitoring 12 active nodes', style: TextStyle(color: Colors.white38, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildLiveIndicator() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: const Color(0xFF00FF9D).withOpacity(0.1), shape: BoxShape.circle),
      child: Center(
        child: Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(color: Color(0xFF00FF9D), shape: BoxShape.circle),
        ).animate(onPlay: (c) => c.repeat()).scale(begin: const Offset(1, 1), end: const Offset(1.5, 1.5), duration: 1000.ms, curve: Curves.easeInOut).fadeOut(),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF00FF9D), size: 16),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(color: Color(0xFF00FF9D), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
      ],
    );
  }

  Widget _buildAttendanceStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard('IN GYM', '42', LucideIcons.users, const Color(0xFF00FF9D)),
        _buildStatCard('AVG DURATION', '54m', LucideIcons.timer, const Color(0xFF06B6D4)),
        _buildStatCard('PEAK LOAD', '88%', LucideIcons.trendingUp, const Color(0xFF7C3AED)),
        _buildStatCard('MISSED', '03', LucideIcons.userX, Colors.redAccent),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 18),
                Container(width: 4, height: 4, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                Text(label, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAttendanceList() {
    return Column(
      children: List.generate(3, (index) => _buildAttendanceTile(index)),
    );
  }

  Widget _buildAttendanceTile(int index) {
    final names = ['Alex Mercer', 'Sarah Apex', 'Marcus Steel'];
    final tiers = ['ELITE', 'STANDARD', 'PREMIUM'];
    final times = ['08:42 AM', '08:35 AM', '08:12 AM'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(backgroundColor: Colors.white12, child: Text(names[index][0], style: const TextStyle(color: Colors.white))),
        title: Text(names[index], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Row(
          children: [
            Text(tiers[index], style: const TextStyle(color: Color(0xFF00FF9D), fontSize: 10, fontWeight: FontWeight.w900)),
            const SizedBox(width: 8),
            Text('• ${times[index]}', style: const TextStyle(color: Colors.white38, fontSize: 10)),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: const Color(0xFF00FF9D).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: const Text('ACTIVE', style: TextStyle(color: Color(0xFF00FF9D), fontSize: 9, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildAttendanceHeatmap() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('WEEKLY LOAD HEATMAP', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (i) => _buildHeatmapColumn(i)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeatmapColumn(int i) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final loads = [0.4, 0.8, 0.6, 0.9, 0.5, 0.3, 0.2];
    return Column(
      children: [
        Container(
          height: 100,
          width: 30,
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 100 * loads[i],
            width: 30,
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [const Color(0xFF00FF9D).withOpacity(0.8), const Color(0xFF00FF9D).withOpacity(0.2)]),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(days[i], style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _showScannerModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF050816),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 40),
            const Text('QR PROTOCOL SCANNER', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            const Text('Position member QR within the targeting frame', textAlign: TextAlign.center, style: TextStyle(color: Colors.white38, fontSize: 14)),
            const Spacer(),
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(32), border: Border.all(color: const Color(0xFF00FF9D), width: 2)),
              child: Stack(
                children: [
                  Center(child: Container(width: 200, height: 2, color: const Color(0xFF00FF9D).withOpacity(0.5)).animate(onPlay: (c) => c.repeat()).slideY(begin: -50, end: 50, duration: 1500.ms, curve: Curves.easeInOut)),
                ],
              ),
            ),
            const Spacer(),
            NeonButton(label: 'INITIALIZE SENSOR', onPressed: () => Navigator.pop(context)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

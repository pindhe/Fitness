import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitpulse_gym/shared/widgets/glass_card.dart';
import 'package:fitpulse_gym/shared/widgets/neon_button.dart';
import 'package:fitpulse_gym/shared/widgets/sidebar.dart';
import 'package:fitpulse_gym/shared/widgets/admin_footer.dart';
import 'dart:ui';

class AdminAttendancePage extends StatefulWidget {
  const AdminAttendancePage({super.key});

  @override
  State<AdminAttendancePage> createState() => _AdminAttendancePageState();
}

class _AdminAttendancePageState extends State<AdminAttendancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const FitPulseSidebar(),
      backgroundColor: const Color(0xFF050816),
      bottomNavigationBar: const FitPulseAdminFooter(currentRoute: '/admin/attendance'),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050816),
        elevation: 0,
        title: const Text('ATTENDANCE CONTROL', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2)),
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
            _buildAttendanceStatsGrid(),
            const SizedBox(height: 32),
            const Text('RECENT CHECK-INS', style: TextStyle(color: Color(0xFF00FF9D), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
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
            Text('SENSOR ARRAY ACTIVE', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
            Text('Monitoring 42 active member nodes', style: TextStyle(color: Colors.white38, fontSize: 12)),
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
            Icon(icon, color: color, size: 18),
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
    final times = ['08:42 AM', '08:35 AM', '08:12 AM'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: Colors.white12, child: Text(names[index][0], style: const TextStyle(color: Colors.white))),
        title: Text(names[index], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text('Check-in: ${times[index]}', style: const TextStyle(color: Colors.white38, fontSize: 12)),
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
            const Text('WEEKLY ATTENDANCE LOAD', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1)),
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
          height: 80,
          width: 25,
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(6)),
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 80 * loads[i],
            width: 25,
            decoration: BoxDecoration(color: const Color(0xFF00FF9D).withOpacity(0.5), borderRadius: BorderRadius.circular(6)),
          ),
        ),
        const SizedBox(height: 8),
        Text(days[i], style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _showScannerModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Color(0xFF050816),
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: Stack(
          children: [
            // Realistic Scanner View
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.white10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Stack(
                    children: [
                      // Camera Simulation
                      const Center(child: Icon(LucideIcons.camera, color: Colors.white10, size: 100)),
                      
                      // Targeting Frame
                      Center(
                        child: Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF00FF9D).withOpacity(0.5), width: 2),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Stack(
                            children: [
                              // Scanning Line
                              Container(
                                height: 2,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.transparent, const Color(0xFF00FF9D), Colors.transparent],
                                  ),
                                ),
                              ).animate(onPlay: (c) => c.repeat()).slideY(begin: 0, end: 125, duration: 1500.ms, curve: Curves.easeInOut),
                              
                              // Corners
                              _buildCorner(0), _buildCorner(1), _buildCorner(2), _buildCorner(3),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // UI Overlay
            Positioned(
              top: 20,
              left: 0, right: 0,
              child: Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
            ),
            
            Positioned(
              bottom: 60,
              left: 32, right: 32,
              child: Column(
                children: [
                  const Text('QR AUTHENTICATION', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  const Text('Scanning for member identification node...', style: TextStyle(color: Colors.white38, fontSize: 13)),
                  const SizedBox(height: 40),
                  NeonButton(label: 'MANUAL ENTRY', onPressed: () => Navigator.pop(context)),
                  const SizedBox(height: 12),
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL PROTOCOL', style: TextStyle(color: Colors.white24, fontSize: 11, fontWeight: FontWeight.bold))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorner(int i) {
    return Positioned(
      top: i < 2 ? 0 : null,
      bottom: i >= 2 ? 0 : null,
      left: i % 2 == 0 ? 0 : null,
      right: i % 2 != 0 ? 0 : null,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          border: Border(
            top: i < 2 ? const BorderSide(color: Color(0xFF00FF9D), width: 4) : BorderSide.none,
            bottom: i >= 2 ? const BorderSide(color: Color(0xFF00FF9D), width: 4) : BorderSide.none,
            left: i % 2 == 0 ? const BorderSide(color: Color(0xFF00FF9D), width: 4) : BorderSide.none,
            right: i % 2 != 0 ? const BorderSide(color: Color(0xFF00FF9D), width: 4) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}

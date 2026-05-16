import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitpulse_gym/shared/widgets/glass_card.dart';
import 'package:fitpulse_gym/config/theme/app_theme.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: const Text('SCAN PROTOCOL', style: TextStyle(letterSpacing: 3, fontSize: 18, fontWeight: FontWeight.w900, fontFamily: 'Outfit')),
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark 
              ? [const Color(0xFF0B0F14), const Color(0xFF1E2630), const Color(0xFF0B0F14)]
              : [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0), const Color(0xFFF8FAFC)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildScannerPreview(context),
              const SizedBox(height: 35),
              _buildAttendanceStats(context),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'VISIT ARCHIVE',
                    style: TextStyle(
                      fontSize: 10, 
                      fontWeight: FontWeight.w900, 
                      letterSpacing: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text('EXPAND ALL', style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
                ],
              ).animate().fadeIn(),
              const SizedBox(height: 20),
              _buildVisitHistory(context),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScannerPreview(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.primary.withOpacity(0.5), width: 1.5),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(LucideIcons.qrCode, size: 120, color: Theme.of(context).colorScheme.primary.withOpacity(0.1)),
                // Scanning animation line with glow
                Container(
                  width: 180,
                  height: 3,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    boxShadow: [
                      BoxShadow(color: AppTheme.primary.withOpacity(0.6), blurRadius: 15, spreadRadius: 2)
                    ],
                  ),
                ).animate(onPlay: (c) => c.repeat())
                 .moveY(begin: -90, end: 90, duration: 1.5.seconds, curve: Curves.easeInOut),
                
                // Corner accents
                ..._buildScannerCorners(),
              ],
            ),
          ),
          const SizedBox(height: 35),
          const Text('VALIDATE ACCESS', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, letterSpacing: -0.5)),
          const SizedBox(height: 10),
          Text(
            'Point your biometric scanner at the hub terminal entrance.', 
            style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4), fontSize: 13, fontWeight: FontWeight.bold), 
            textAlign: TextAlign.center
          ),
          const SizedBox(height: 35),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(LucideIcons.camera, size: 20),
              label: const Text('INITIATE SCAN', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildScannerCorners() {
    return [
      Positioned(top: 20, left: 20, child: _scannerCorner(0)),
      Positioned(top: 20, right: 20, child: _scannerCorner(1)),
      Positioned(bottom: 20, left: 20, child: _scannerCorner(2)),
      Positioned(bottom: 20, right: 20, child: _scannerCorner(3)),
    ];
  }

  Widget _scannerCorner(int type) {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        border: Border(
          top: type < 2 ? const BorderSide(color: AppTheme.primary, width: 4) : BorderSide.none,
          bottom: type >= 2 ? const BorderSide(color: AppTheme.primary, width: 4) : BorderSide.none,
          left: type % 2 == 0 ? const BorderSide(color: AppTheme.primary, width: 4) : BorderSide.none,
          right: type % 2 != 0 ? const BorderSide(color: AppTheme.primary, width: 4) : BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildAttendanceStats(BuildContext context) {
    return Row(
      children: [
        _buildStatCard(context, 'CUMULATIVE', '156', LucideIcons.calendarDays, AppTheme.primary),
        const SizedBox(width: 20),
        _buildStatCard(context, 'CURRENT MO.', '22', LucideIcons.checkCircle2, Colors.blueAccent),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, IconData icon, Color color) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(height: 16),
            Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1)),
            Text(label, style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4), fontWeight: FontWeight.w900, letterSpacing: 1)),
          ],
        ),
      ),
    );
  }

  Widget _buildVisitHistory(BuildContext context) {
    return GlassCard(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        separatorBuilder: (_, __) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider(color: Theme.of(context).dividerColor.withOpacity(0.05), height: 1),
        ),
        itemBuilder: (context, index) => ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(14)),
            child: const Icon(LucideIcons.mapPin, size: 18, color: AppTheme.primary),
          ),
          title: const Text('Protocol Hub Alpha', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          subtitle: Text('${15 - index} May 2024 • 06:30 AM', style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4), fontWeight: FontWeight.bold)),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Theme.of(context).dividerColor.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
            child: const Text('2h 15m', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppTheme.primary)),
          ),
        ),
      ),
    );
  }
}

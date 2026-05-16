import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitpulse_gym/shared/widgets/glass_card.dart';
import 'package:fitpulse_gym/shared/widgets/neon_button.dart';
import 'package:fitpulse_gym/shared/widgets/sidebar.dart';
import 'package:fitpulse_gym/shared/widgets/admin_footer.dart';
import 'dart:ui';

class SystemSettingsPage extends StatefulWidget {
  const SystemSettingsPage({super.key});

  @override
  State<SystemSettingsPage> createState() => _SystemSettingsPageState();
}

class _SystemSettingsPageState extends State<SystemSettingsPage> {
  bool _notificationsEnabled = true;
  bool _biometricAuth = true;
  bool _darkMode = true;
  bool _autoSync = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const FitPulseSidebar(),
      backgroundColor: const Color(0xFF050816),
      bottomNavigationBar: const FitPulseAdminFooter(currentRoute: '/admin/settings'),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050816),
        elevation: 0,
        title: const Text('CORE SYSTEM CONFIG', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2)),
        leading: Builder(builder: (context) => IconButton(icon: const Icon(LucideIcons.menu, color: Colors.white), onPressed: () => Scaffold.of(context).openDrawer())),
        actions: [
          IconButton(icon: const Icon(LucideIcons.refreshCw, color: Color(0xFF00FF9D), size: 18), onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAdminNodeProfile(),
            const SizedBox(height: 32),
            _buildSectionHeader('SUBSYSTEM CONTROL', LucideIcons.cpu),
            const SizedBox(height: 16),
            _buildSettingsGrid(),
            const SizedBox(height: 32),
            _buildSectionHeader('SECURITY & ACCESS', LucideIcons.shieldCheck),
            const SizedBox(height: 16),
            _buildSecurityPanel(),
            const SizedBox(height: 40),
            _buildBrandingDossier(),
            const SizedBox(height: 100),
          ],
        ),
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

  Widget _buildAdminNodeProfile() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [const Color(0xFF00FF9D).withOpacity(0.1), Colors.transparent]),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF00FF9D).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              const CircleAvatar(radius: 35, backgroundColor: Colors.white12, child: Icon(LucideIcons.user, color: Colors.white, size: 30)),
              Positioned(right: 0, bottom: 0, child: Container(width: 14, height: 14, decoration: BoxDecoration(color: const Color(0xFF00FF9D), shape: BoxShape.circle, border: Border.all(color: const Color(0xFF050816), width: 2)))),
            ],
          ),
          const SizedBox(width: 20),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ROOT ADMINISTRATOR', style: TextStyle(color: Color(0xFF00FF9D), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
              Text('System Node #001', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
              Text('Auth Level: Level 5 (Omni)', style: TextStyle(color: Colors.white38, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsGrid() {
    return Column(
      children: [
        _buildSettingsTile('Neural Notifications', 'Global push and email sync', _notificationsEnabled, (v) => setState(() => _notificationsEnabled = v), LucideIcons.bell),
        _buildSettingsTile('Dark Matter Interface', 'Optimized for low-light command', _darkMode, (v) => setState(() => _darkMode = v), LucideIcons.moon),
        _buildSettingsTile('Real-time Data Sync', 'Auto-refresh cloud telemetry', _autoSync, (v) => setState(() => _autoSync = v), LucideIcons.refreshCcw),
      ],
    );
  }

  Widget _buildSecurityPanel() {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Column(
        children: [
          _buildSettingsTile('Biometric Protocol', 'FaceID & Fingerprint Access', _biometricAuth, (v) => setState(() => _biometricAuth = v), LucideIcons.fingerprint, showDivider: true),
          _buildActionTile('Access Key Management', 'Rotate and manage API keys', LucideIcons.key),
          _buildActionTile('Security Audit Log', 'Review system access history', LucideIcons.clipboardList),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(String title, String sub, bool val, Function(bool) onChanged, IconData icon, {bool showDivider = false}) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: Icon(icon, color: Colors.white60, size: 20),
          title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          subtitle: Text(sub, style: const TextStyle(color: Colors.white38, fontSize: 11)),
          trailing: Switch(
            value: val,
            onChanged: onChanged,
            activeColor: const Color(0xFF00FF9D),
            activeTrackColor: const Color(0xFF00FF9D).withOpacity(0.2),
          ),
        ),
        if (showDivider) Divider(color: Colors.white.withOpacity(0.05), height: 1),
      ],
    );
  }

  Widget _buildActionTile(String title, String sub, IconData icon) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Icon(icon, color: Colors.white60, size: 20),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      subtitle: Text(sub, style: const TextStyle(color: Colors.white38, fontSize: 11)),
      trailing: const Icon(LucideIcons.chevronRight, color: Colors.white24, size: 16),
      onTap: () {},
    );
  }

  Widget _buildBrandingDossier() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('BRAND IDENTITY', LucideIcons.palette),
        const SizedBox(height: 16),
        GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white10)), child: const Icon(LucideIcons.image, color: Colors.white24)),
                    const SizedBox(width: 16),
                    const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('PRIMARY_LOGO.SVG', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)), Text('Optimized for dark interfaces', style: TextStyle(color: Colors.white38, fontSize: 10))])),
                    TextButton(onPressed: () {}, child: const Text('UPLOAD', style: TextStyle(color: Color(0xFF00FF9D), fontSize: 10, fontWeight: FontWeight.bold))),
                  ],
                ),
                const SizedBox(height: 32),
                NeonButton(label: 'SAVE GLOBAL CONFIG', onPressed: () {}),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

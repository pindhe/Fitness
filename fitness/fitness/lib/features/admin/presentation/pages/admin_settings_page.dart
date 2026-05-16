import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitpulse_gym/shared/widgets/sidebar.dart';

import 'package:fitpulse_gym/shared/widgets/admin_footer.dart';

class AdminSettingsPage extends ConsumerWidget {
  const AdminSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: const FitPulseSidebar(),
      backgroundColor: const Color(0xFF0B0F14),
      bottomNavigationBar: const FitPulseAdminFooter(currentRoute: '/admin/settings'),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F14).withOpacity(0.95),
        elevation: 0,
        title: const Text('System Settings', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(LucideIcons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSettingsHeader(),
            const SizedBox(height: 32),
            _buildSettingsSection('General Configuration', [
              _buildSettingTile('Gym Identity', 'Manage name, logo, and branding', LucideIcons.building2),
              _buildSettingTile('Operating Hours', 'Set opening and closing times', LucideIcons.clock),
              _buildSettingTile('Contact Info', 'Support email and phone numbers', LucideIcons.phone),
            ]),
            const SizedBox(height: 32),
            _buildSettingsSection('Security & Access', [
              _buildSettingTile('Staff Roles', 'Manage admin and trainer permissions', LucideIcons.shieldCheck),
              _buildSettingTile('API Keys', 'Integrate with external services', LucideIcons.key),
              _buildSettingTile('Security Logs', 'View recent administrative actions', LucideIcons.history),
            ]),
            const SizedBox(height: 32),
            _buildSettingsSection('Notifications', [
              _buildSettingTile('Email SMTP', 'Configure automated member emails', LucideIcons.mail),
              _buildSettingTile('Push Protocols', 'Manage mobile notification triggers', LucideIcons.bell),
            ]),
            const SizedBox(height: 48),
            _buildDangerZone(),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('System Control', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('Configure your gym management platform parameters.', style: TextStyle(color: Colors.white.withOpacity(0.5))),
      ],
    ).animate().fadeIn().slideX(begin: -0.1);
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(title, style: const TextStyle(color: Color(0xFF3B82F6), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile(String title, String subtitle, IconData icon) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: Colors.white70, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight, color: Colors.white24, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDangerZone() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.redAccent.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.alertTriangle, color: Colors.redAccent, size: 24),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Danger Zone', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text('Irreversible actions including data wipes.', style: TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          TextButton(onPressed: () {}, child: const Text('Access', style: TextStyle(color: Colors.redAccent))),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FitPulseFooter extends StatelessWidget {
  const FitPulseFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0F14),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon(LucideIcons.instagram),
              const SizedBox(width: 24),
              _buildSocialIcon(LucideIcons.twitter),
              const SizedBox(width: 24),
              _buildSocialIcon(LucideIcons.facebook),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'FITPULSE GLOBAL SYSTEMS',
            style: TextStyle(
              color: Colors.white24,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '© 2026 Biindhe. All rights reserved.',
            style: TextStyle(color: Colors.white10, fontSize: 10),
          ),
          const SizedBox(height: 24),
          Container(
            height: 2,
            width: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00FF88), Color(0xFF3B82F6)],
              ),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Icon(
      icon,
      color: Colors.white24,
      size: 20,
    );
  }
}

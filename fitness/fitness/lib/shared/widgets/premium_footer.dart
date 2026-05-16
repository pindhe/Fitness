import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PremiumFuturisticFooter extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const PremiumFuturisticFooter({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<PremiumFuturisticFooter> createState() => _PremiumFuturisticFooterState();
}

class _PremiumFuturisticFooterState extends State<PremiumFuturisticFooter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      decoration: BoxDecoration(
        color: const Color(0xFF050816).withOpacity(0.8),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00FF9D).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTab(0, LucideIcons.home, 'Home'),
                _buildTab(1, LucideIcons.users, 'Members'),
                _buildTab(2, LucideIcons.creditCard, 'Payments'),
                _buildTab(3, LucideIcons.barChart2, 'Analytics'),
              ],
            ),
          ),
        ),
      ),
    ).animate().slideY(begin: 1, duration: 800.ms, curve: Curves.easeOutQuart);
  }

  Widget _buildTab(int index, IconData icon, String label) {
    final isSelected = widget.currentIndex == index;
    final color = isSelected ? const Color(0xFF00FF9D) : const Color(0xFF6B7280);

    return Expanded(
      child: InkWell(
        onTap: () => widget.onTap(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (isSelected)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00FF9D).withOpacity(0.2),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
                Icon(
                  icon,
                  color: color,
                  size: isSelected ? 24 : 22,
                ).animate(target: isSelected ? 1 : 0).scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 300.ms),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: 2,
                width: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFF00FF9D),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00FF9D).withOpacity(0.5),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ).animate().shimmer(duration: 2.seconds, color: Colors.white24),
          ],
        ),
      ),
    );
  }
}

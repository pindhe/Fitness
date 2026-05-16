import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';

class FitPulseAdminFooter extends StatelessWidget {
  final String currentRoute;

  const FitPulseAdminFooter({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF0B0F14).withOpacity(0.8),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFooterItem(context, LucideIcons.home, 'Home', '/admin'),
                _buildFooterItem(context, LucideIcons.users, 'Members', '/admin/members'),
                _buildFooterItem(context, LucideIcons.creditCard, 'Payments', '/admin/payments'),
                _buildFooterItem(context, LucideIcons.barChart2, 'Analytics', '/admin/analytics'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterItem(BuildContext context, IconData icon, String label, String route) {
    final bool isSelected = currentRoute == route;
    final color = isSelected ? const Color(0xFF00FF88) : Colors.white38;
    
    return InkWell(
      onTap: () {
        if (!isSelected) {
          context.go(route);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color, 
              fontSize: 10, 
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 12,
              decoration: BoxDecoration(
                color: const Color(0xFF00FF88),
                borderRadius: BorderRadius.circular(1),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF00FF88).withOpacity(0.5), blurRadius: 4),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

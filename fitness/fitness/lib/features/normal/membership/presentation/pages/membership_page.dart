import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitpulse_gym/shared/widgets/glass_card.dart';
import 'package:fitpulse_gym/config/theme/app_theme.dart';

class MembershipPage extends StatelessWidget {
  const MembershipPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: const Text('MEMBERSHIP PLANS', style: TextStyle(letterSpacing: 3, fontSize: 18, fontWeight: FontWeight.w900, fontFamily: 'Outfit')),
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: IconButton(
              icon: const Icon(LucideIcons.helpCircle, size: 20),
              onPressed: () {},
              tooltip: 'Membership Support',
            ),
          ),
        ],
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
              _buildPlanCard(context, 'BASIC', '29', ['Full Gym Access', 'Digital Locker', 'Community App'], Colors.blueGrey, false),
              const SizedBox(height: 24),
              _buildPlanCard(context, 'PREMIUM', '59', ['All Basic Perks', 'Elite Classes', 'Pro Trainer (1/mo)', 'Smart Nutrition'], AppTheme.primary, true),
              const SizedBox(height: 24),
              const SizedBox(height: 24),
              _buildPlanCard(context, 'VIP ALPHA', '99', ['Unlimited 1-on-1', 'Spa & Neural Recovery', 'Global Hub Access', 'Guest Protocols'], Colors.amberAccent, false),
              const SizedBox(height: 30),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(LucideIcons.ticket, size: 16, color: AppTheme.primary),
                label: const Text('REDEEM PROMO CODE', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 11)),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: AppTheme.primary.withOpacity(0.05),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'PAYMENT LOGS',
                style: TextStyle(
                  fontSize: 10, 
                  fontWeight: FontWeight.w900, 
                  letterSpacing: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ).animate().fadeIn(),
              const SizedBox(height: 20),
              _buildPaymentHistory(context),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, String title, String price, List<String> features, Color color, bool isPopular) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: color.withOpacity(isPopular ? 0.6 : 0.1), width: isPopular ? 2.5 : 1),
            boxShadow: [
              if (isPopular) BoxShadow(color: color.withOpacity(0.1), blurRadius: 30, spreadRadius: -5)
            ],
          ),
          child: GlassCard(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 3, color: color)),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('\$$price', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, letterSpacing: -2)),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0, left: 6),
                      child: Text('/mo', style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.3), fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ...features.map((f) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                        child: Icon(LucideIcons.check, size: 12, color: color),
                      ),
                      const SizedBox(width: 16),
                      Text(f, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.8), fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                )),
                const SizedBox(height: 35),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPopular ? color : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
                      foregroundColor: isPopular ? Colors.black : (isDark ? Colors.white : Colors.black),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    child: Text(isPopular ? 'ACTIVE PROTOCOL' : 'UPGRADE SYSTEM', style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isPopular)
          Positioned(
            top: 0,
            right: 40,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 10)],
              ),
              child: const Text('PEAK VALUE', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
            ),
          ),
      ],
    ).animate().fadeIn().scale(begin: const Offset(0.98, 0.98), curve: Curves.easeOut);
  }

  Widget _buildPaymentHistory(BuildContext context) {
    return GlassCard(
      child: Column(
        children: List.generate(3, (index) => _buildPaymentTile(context, index)),
      ),
    );
  }

  Widget _buildPaymentTile(BuildContext context, int index) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Theme.of(context).dividerColor.withOpacity(0.05), borderRadius: BorderRadius.circular(14)),
            child: Icon(LucideIcons.fileText, size: 20, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4)),
          ),
          title: const Text('Protocol Renewal', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          subtitle: Text('15 May 2024 • Invoice #FP-${20240 + index}', style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4), fontWeight: FontWeight.bold)),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('\$59.00', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              Text('SUCCESS', style: TextStyle(color: AppTheme.primary, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1)),
            ],
          ),
        ),
        if (index < 2) Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider(color: Theme.of(context).dividerColor.withOpacity(0.05), height: 1),
        ),
      ],
    );
  }
}

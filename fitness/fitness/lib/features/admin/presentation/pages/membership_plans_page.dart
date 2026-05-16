import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitpulse_gym/shared/widgets/glass_card.dart';
import 'package:fitpulse_gym/shared/widgets/neon_button.dart';
import 'package:fitpulse_gym/shared/widgets/sidebar.dart';
import 'dart:ui';

class MembershipPlansPage extends StatefulWidget {
  const MembershipPlansPage({super.key});

  @override
  State<MembershipPlansPage> createState() => _MembershipPlansPageState();
}

class _MembershipPlansPageState extends State<MembershipPlansPage> {
  bool _isYearly = false;

  final List<Map<String, dynamic>> _plans = [
    {
      'name': 'BASIC',
      'monthly': 29.99,
      'yearly': 299.99,
      'description': 'Essential access for casual fitness enthusiasts.',
      'features': ['Gym access', 'Locker access', 'Basic workouts', 'Mobile App Access'],
      'popular': false,
      'color': const Color(0xFF94A3B8),
      'icon': LucideIcons.dumbbell,
    },
    {
      'name': 'STANDARD',
      'monthly': 49.99,
      'yearly': 499.99,
      'description': 'Balanced protocol for consistent performance.',
      'features': ['Everything in Basic', 'Group training', 'Nutrition tips', 'Progress tracking', 'Standard Support'],
      'popular': true,
      'color': const Color(0xFF00FF9D),
      'icon': LucideIcons.zap,
    },
    {
      'name': 'PREMIUM',
      'monthly': 89.99,
      'yearly': 899.99,
      'description': 'Elite optimization for serious transformation.',
      'features': ['Everything in Standard', 'Personal trainer', 'Advanced analytics', 'Custom meal plans', 'Video workout library'],
      'popular': false,
      'color': const Color(0xFF7C3AED),
      'icon': LucideIcons.crown,
    },
    {
      'name': 'ELITE ATHLETE',
      'monthly': 149.99,
      'yearly': 1499.99,
      'description': 'Full VIP immersion for pro-level results.',
      'features': ['Full VIP access', 'Private coaching', 'Recovery sessions', 'Advanced tracking', 'Exclusive programs'],
      'popular': false,
      'color': const Color(0xFF06B6D4),
      'icon': LucideIcons.award,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const FitPulseSidebar(),
      backgroundColor: const Color(0xFF050816),
      body: Stack(
        children: [
          // Background Glows
          Positioned(top: -100, right: -100, child: _buildCircularGlow(const Color(0xFF7C3AED).withOpacity(0.1), 400)),
          Positioned(bottom: -100, left: -100, child: _buildCircularGlow(const Color(0xFF00FF9D).withOpacity(0.05), 400)),
          
          CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      _buildHeader(),
                      const SizedBox(height: 40),
                      _buildPricingToggle(),
                      const SizedBox(height: 48),
                      ..._plans.map((plan) => _buildPlanCard(plan)).toList(),
                      const SizedBox(height: 60),
                      _buildComparisonTable(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircularGlow(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 50)],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Builder(builder: (context) => IconButton(icon: const Icon(LucideIcons.menu, color: Colors.white), onPressed: () => Scaffold.of(context).openDrawer())),
      title: const Text('ELITE MEMBERSHIP', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2)),
      centerTitle: true,
      actions: [IconButton(icon: const Icon(LucideIcons.helpCircle, color: Colors.white38), onPressed: () {})],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(colors: [Colors.white, Color(0xFF00FF9D)]).createShader(bounds),
          child: const Text('CHOOSE YOUR\nPROTOCOL', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1)),
        ).animate().fadeIn().slideY(begin: 0.2),
        const SizedBox(height: 16),
        const Text('Unlock full potential with our advanced\nmembership tiers and professional guidance.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 14, height: 1.5)).animate().fadeIn(delay: 200.ms),
      ],
    );
  }

  Widget _buildPricingToggle() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.1))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton('MONTHLY', !_isYearly),
          _buildToggleButton('YEARLY', _isYearly, badge: 'SAVE 20%'),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isActive, {String? badge}) {
    return GestureDetector(
      onTap: () => setState(() => _isYearly = (label == 'YEARLY')),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF00FF9D) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isActive ? [BoxShadow(color: const Color(0xFF00FF9D).withOpacity(0.3), blurRadius: 15, spreadRadius: -5)] : null,
        ),
        child: Row(
          children: [
            Text(label, style: TextStyle(color: isActive ? Colors.black : Colors.white60, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1)),
            if (badge != null) ...[
              const SizedBox(width: 8),
              Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(6)), child: Text(badge, style: const TextStyle(color: Colors.black, fontSize: 8, fontWeight: FontWeight.bold))),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan) {
    final bool isPopular = plan['popular'];
    final Color planColor = plan['color'];
    final double price = _isYearly ? plan['yearly'] : plan['monthly'];

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: isPopular ? planColor.withOpacity(0.4) : Colors.white.withOpacity(0.05), width: isPopular ? 2 : 1),
        boxShadow: isPopular ? [BoxShadow(color: planColor.withOpacity(0.1), blurRadius: 30, spreadRadius: -10)] : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isPopular) 
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: planColor, borderRadius: BorderRadius.circular(8)),
                    child: const Text('MOST POPULAR', style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1)),
                  ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2.seconds),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(plan['name'], style: TextStyle(color: planColor, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2)),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('\$$price', style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: -1)),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8, left: 4),
                              child: Text(_isYearly ? '/yr' : '/mo', style: const TextStyle(color: Colors.white38, fontSize: 14, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: planColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                      child: Icon(plan['icon'], color: planColor, size: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(plan['description'], style: const TextStyle(color: Colors.white54, fontSize: 14, height: 1.5)),
                const SizedBox(height: 32),
                const Divider(color: Colors.white10),
                const SizedBox(height: 32),
                ...List.generate(plan['features'].length, (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Icon(LucideIcons.checkCircle2, color: planColor, size: 18),
                      const SizedBox(width: 12),
                      Text(plan['features'][i], style: const TextStyle(color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                )),
                const SizedBox(height: 32),
                NeonButton(
                  label: 'SELECT PROTOCOL', 
                  onPressed: () {},
                  // color: planColor, // Assuming NeonButton supports color or uses primary
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _buildComparisonTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('COMPARE PROTOCOLS', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.02), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white.withOpacity(0.05))),
          child: Column(
            children: [
              _buildComparisonRow('Gym Equipment', ['Basic', 'Full', 'Elite', 'VIP'], isHeader: true),
              _buildComparisonRow('Digital Coaching', ['X', 'Basic', 'Full', 'Private']),
              _buildComparisonRow('Locker Access', ['X', 'Standard', 'Premium', 'Private']),
              _buildComparisonRow('Guest Passes', ['0', '1/mo', 'Unlimited', 'Unlimited']),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonRow(String feature, List<String> values, {bool isHeader = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05)))),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(feature, style: TextStyle(color: isHeader ? const Color(0xFF00FF9D) : Colors.white70, fontSize: 12, fontWeight: FontWeight.bold))),
          ...values.map((v) => Expanded(child: Center(child: Text(v, style: TextStyle(color: v == 'X' ? Colors.white24 : Colors.white54, fontSize: 10, fontWeight: FontWeight.w900))))).toList(),
        ],
      ),
    );
  }
}

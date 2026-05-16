import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitpulse_gym/shared/widgets/glass_card.dart';
import 'package:fitpulse_gym/config/theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';

class NutritionPage extends StatelessWidget {
  const NutritionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark 
                    ? [const Color(0xFF0B0F14), const Color(0xFF1E2630), const Color(0xFF0B0F14)]
                    : [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0), const Color(0xFFF8FAFC)],
                ),
              ),
            ),
          ),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDailySummary(context),
                      const SizedBox(height: 35),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('MACRO ANALYSIS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2, color: AppTheme.primary)),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(LucideIcons.settings2, size: 12),
                            label: const Text('EDIT PLAN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildMacroSection(context),
                      const SizedBox(height: 35),
                      _buildWaterTracker(context),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'NUTRITIONAL SCHEDULE',
                            style: TextStyle(
                              fontSize: 12, 
                              fontWeight: FontWeight.w900, 
                              letterSpacing: 2,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(LucideIcons.plus, size: 14),
                            label: const Text('ADD MEAL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              minimumSize: Size.zero,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(),
                      const SizedBox(height: 20),
                      _buildMealCard(context, 'Breakfast', 'Avocado Toast & Poached Eggs', '08:30 AM', '420 kcal', 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=200'),
                      _buildMealCard(context, 'Lunch', 'Grilled Chicken Quinoa Bowl', '13:00 PM', '580 kcal', 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200'),
                      _buildMealCard(context, 'Dinner', 'Baked Salmon with Asparagus', '19:30 PM', '450 kcal', 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=200'),
                      const SizedBox(height: 120),
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

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 0,
      toolbarHeight: 90,
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      title: const Text('NUTRITIONAL NODE', style: TextStyle(letterSpacing: 3, fontSize: 18, fontWeight: FontWeight.w900, fontFamily: 'Outfit')),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: IconButton(
            icon: const Icon(LucideIcons.calendar, size: 20),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildDailySummary(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('CALORIE METRICS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4), letterSpacing: 1.5)),
              const Icon(LucideIcons.flame, size: 18, color: Colors.orangeAccent),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  const Text('1,450', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, letterSpacing: -1.5)),
                  Text('CONSUMED', style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5), fontWeight: FontWeight.w900, letterSpacing: 1)),
                ],
              ),
              const Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                child: Text('/', style: TextStyle(fontSize: 32, color: Colors.white10, fontWeight: FontWeight.w100)),
              ),
              Column(
                children: [
                  const Text('2,200', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white24)),
                  Text('GOAL', style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.2), fontWeight: FontWeight.w900, letterSpacing: 1)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          Stack(
            children: [
              Container(
                height: 14,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                height: 14,
                width: 220, // Dynamic
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.orangeAccent, Colors.redAccent]),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.orangeAccent.withOpacity(0.3), blurRadius: 12)],
                ),
              ).animate().shimmer(duration: 2.seconds),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroSection(BuildContext context) {
    return Row(
      children: [
        _buildMacroBar(context, 'PROTEIN', '120g', 0.8, Colors.blueAccent),
        const SizedBox(width: 14),
        _buildMacroBar(context, 'CARBS', '180g', 0.6, Colors.greenAccent),
        const SizedBox(width: 14),
        _buildMacroBar(context, 'FATS', '45g', 0.4, Colors.purpleAccent),
      ],
    );
  }

  Widget _buildMacroBar(BuildContext context, String label, String value, double progress, Color color) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4), letterSpacing: 1)),
            const SizedBox(height: 10),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            const SizedBox(height: 16),
            SizedBox(
              height: 65,
              width: 65,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: 1,
                    backgroundColor: Colors.transparent,
                    color: Theme.of(context).dividerColor.withOpacity(0.05),
                    strokeWidth: 7,
                  ),
                  CircularProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.transparent,
                    color: color,
                    strokeWidth: 7,
                    strokeCap: StrokeCap.round,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterTracker(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
            child: const Icon(LucideIcons.droplets, color: Colors.blueAccent, size: 28),
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hydration Intake', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                Text('Target: 3.5 Liters Daily', style: TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('1.2L', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.blueAccent)),
              Text('35%', style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.3), fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(width: 16),
          Container(
            decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(12)),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(LucideIcons.plus, color: Colors.black, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard(BuildContext context, String title, String subtitle, String time, String calories, String imageUrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.primary, letterSpacing: 1.5)),
                      Text(time, style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4), fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(subtitle, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: -0.3)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(LucideIcons.flame, size: 14, color: Colors.orangeAccent),
                      const SizedBox(width: 6),
                      Text(calories, style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6), fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(LucideIcons.checkCircle, color: Colors.white10, size: 28),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }
}

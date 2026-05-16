import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitpulse_gym/shared/widgets/glass_card.dart';
import 'package:fitpulse_gym/config/theme/app_theme.dart';

class TrainerBookingPage extends StatelessWidget {
  const TrainerBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: const Text('ELITE TRAINERS', style: TextStyle(letterSpacing: 3, fontSize: 18, fontWeight: FontWeight.w900, fontFamily: 'Outfit')),
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
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: 5,
          itemBuilder: (context, index) => _buildTrainerCard(context, index),
        ),
      ),
    );
  }

  Widget _buildTrainerCard(BuildContext context, int index) {
    final trainers = [
      {'name': 'Marcus Aurelius', 'specialty': 'Neural Strength', 'exp': '12y', 'rating': '4.9', 'img': 'https://images.unsplash.com/photo-1594381898411-846e7d193883?w=200'},
      {'name': 'Sarah Jenkins', 'specialty': 'Yoga Mastery', 'exp': '8y', 'rating': '5.0', 'img': 'https://images.unsplash.com/photo-1518310352947-78ff9c3d0998?w=200'},
      {'name': 'David Chen', 'specialty': 'HIIT Protocol', 'exp': '5y', 'rating': '4.8', 'img': 'https://images.unsplash.com/photo-149175235542e-99a31959bb77?w=200'},
    ];
    
    final trainer = trainers[index % trainers.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: GlassCard(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    image: DecorationImage(image: NetworkImage(trainer['img']!), fit: BoxFit.cover),
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
                          Text(trainer['name']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                const Icon(LucideIcons.star, size: 12, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(trainer['rating']!, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: Colors.amber)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(trainer['specialty']!.toUpperCase(), style: const TextStyle(color: AppTheme.primary, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(LucideIcons.clock, size: 14, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.3)),
                          const SizedBox(width: 6),
                          Text('${trainer['exp']} Master Exp', style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4), fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.1)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('MESSAGE', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 11)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('BOOK SESSION', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1, fontSize: 11)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.1);
  }
}

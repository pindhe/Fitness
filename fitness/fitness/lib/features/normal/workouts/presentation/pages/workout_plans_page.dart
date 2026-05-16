import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitpulse_gym/shared/widgets/glass_card.dart';
import 'package:fitpulse_gym/config/theme/app_theme.dart';

class WorkoutPlansPage extends StatefulWidget {
  const WorkoutPlansPage({super.key});

  @override
  State<WorkoutPlansPage> createState() => _WorkoutPlansPageState();
}

class _WorkoutPlansPageState extends State<WorkoutPlansPage> {
  String selectedFilter = 'All';
  String selectedCategory = 'All';

  final List<String> filters = ['All', 'Beginner', 'Intermediate', 'Advanced'];
  final List<String> categories = ['All', 'Weight Loss', 'Muscle Gain', 'Cardio', 'Yoga', 'Strength', 'Home Workout'];

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
                      _buildFilterSection(context),
                      const SizedBox(height: 30),
                      _buildCategorySection(context),
                      const SizedBox(height: 35),
                      Text(
                        'RECOMMENDED PROTOCOLS',
                        style: TextStyle(
                          fontSize: 12, 
                          fontWeight: FontWeight.w900, 
                          letterSpacing: 2,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ).animate().fadeIn(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildWorkoutListItem(context, index),
                    childCount: 10,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
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
      title: const Text('TRAINING HUB', style: TextStyle(letterSpacing: 3, fontSize: 18, fontWeight: FontWeight.w900, fontFamily: 'Outfit')),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: IconButton(
            icon: const Icon(LucideIcons.search, size: 20),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 45,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;
          return InkWell(
            onTap: () => setState(() => selectedFilter = filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                gradient: isSelected 
                    ? const LinearGradient(colors: [AppTheme.primary, AppTheme.secondary]) 
                    : null,
                color: isSelected ? null : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03)),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isSelected ? Colors.transparent : (isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05))),
                boxShadow: [
                  if (isSelected) BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))
                ],
              ),
              child: Center(
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.black : (isDark ? Colors.white60 : Colors.black54),
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('BROWSE BY CATEGORY', style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 20),
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory == category;
              return Column(
                children: [
                  InkWell(
                    onTap: () => setState(() => selectedCategory = category),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primary.withOpacity(0.2) : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.02)),
                        shape: BoxShape.circle,
                        border: Border.all(color: isSelected ? AppTheme.primary : (isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)), width: 1.5),
                        boxShadow: [
                          if (isSelected) BoxShadow(color: AppTheme.primary.withOpacity(0.1), blurRadius: 10)
                        ],
                      ),
                      child: Icon(
                        _getCategoryIcon(category),
                        color: isSelected ? AppTheme.primary : (isDark ? Colors.white24 : Colors.black26),
                        size: 26,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(category, style: TextStyle(fontSize: 10, fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold, color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5))),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Weight Loss': return LucideIcons.trendingDown;
      case 'Muscle Gain': return LucideIcons.dumbbell;
      case 'Cardio': return LucideIcons.wind;
      case 'Yoga': return LucideIcons.flower2;
      case 'Strength': return LucideIcons.zap;
      case 'Home Workout': return LucideIcons.home;
      default: return LucideIcons.layers;
    }
  }

  Widget _buildWorkoutListItem(BuildContext context, int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'workout_$index',
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=200&sig=$index'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), shape: BoxShape.circle),
                    child: const Icon(LucideIcons.play, size: 10, color: AppTheme.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('INTERMEDIATE', style: TextStyle(fontSize: 8, color: AppTheme.primary, fontWeight: FontWeight.w900, letterSpacing: 1)),
                      ),
                      const Text('450 kcal', style: TextStyle(fontSize: 10, color: Colors.orangeAccent, fontWeight: FontWeight.w900)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Full Body Shred Alpha',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.5),
                  ),
                  Text(
                    'Coach Alex Rivera • 45 mins',
                    style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5), fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildMiniInfo(context, LucideIcons.star, '4.9'),
                      const SizedBox(width: 12),
                      _buildMiniInfo(context, LucideIcons.users, '1.2k'),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          minimumSize: const Size(80, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('START', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.05);
  }

  Widget _buildMiniInfo(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.3)),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4), fontWeight: FontWeight.bold)),
      ],
    );
  }
}

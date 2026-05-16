import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitpulse_gym/shared/widgets/glass_card.dart';
import 'package:fitpulse_gym/shared/widgets/neon_button.dart';
import 'package:fitpulse_gym/shared/widgets/sidebar.dart';
import 'package:fitpulse_gym/shared/widgets/admin_footer.dart';
import 'dart:ui';

class NutritionManagementPage extends StatefulWidget {
  const NutritionManagementPage({super.key});

  @override
  State<NutritionManagementPage> createState() => _NutritionManagementPageState();
}

class _NutritionManagementPageState extends State<NutritionManagementPage> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Weight Loss', 'Muscle Gain', 'Keto', 'Vegan', 'High Protein'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const FitPulseSidebar(),
      backgroundColor: const Color(0xFF050816),
      bottomNavigationBar: const FitPulseAdminFooter(currentRoute: '/admin/nutrition'),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050816),
        elevation: 0,
        title: const Text('NUTRITION COMMAND', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2)),
        leading: Builder(builder: (context) => IconButton(icon: const Icon(LucideIcons.menu, color: Colors.white), onPressed: () => Scaffold.of(context).openDrawer())),
        actions: [
          IconButton(icon: const Icon(LucideIcons.plusCircle, color: Color(0xFF7C3AED)), onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMacroOverview(),
            const SizedBox(height: 32),
            _buildSectionHeader('DIETARY PROTOCOLS', LucideIcons.utensils),
            const SizedBox(height: 16),
            _buildCategoryFilter(),
            const SizedBox(height: 24),
            _buildMealGrid(),
            const SizedBox(height: 40),
            _buildPersonalPlansSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroOverview() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('GLOBAL CALORIC BURN', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMacroRing('PRO', 0.8, const Color(0xFF7C3AED)),
                _buildMacroRing('CARB', 0.6, const Color(0xFF00FF9D)),
                _buildMacroRing('FAT', 0.4, const Color(0xFF06B6D4)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroRing(String label, double value, Color color) {
    return Column(
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: Stack(
            children: [
              CircularProgressIndicator(value: value, backgroundColor: Colors.white.withOpacity(0.05), color: color, strokeWidth: 8),
              Center(child: Text('${(value * 100).toInt()}%', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 9, fontWeight: FontWeight.w900)),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF7C3AED), size: 16),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(color: Color(0xFF7C3AED), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories.map((cat) => Padding(
          padding: const EdgeInsets.only(right: 12),
          child: ChoiceChip(
            label: Text(cat, style: TextStyle(color: _selectedCategory == cat ? Colors.white : Colors.white38, fontSize: 11)),
            selected: _selectedCategory == cat,
            onSelected: (val) => setState(() => _selectedCategory = cat),
            backgroundColor: Colors.white.withOpacity(0.03),
            selectedColor: const Color(0xFF7C3AED).withOpacity(0.3),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: _selectedCategory == cat ? const Color(0xFF7C3AED) : Colors.white10)),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildMealGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, mainAxisExtent: 200),
      itemCount: 4,
      itemBuilder: (context, index) => _buildMealCard(index),
    );
  }

  Widget _buildMealCard(int index) {
    final meals = ['Salmon Protocol', 'Keto Fuel', 'Power Vegan', 'Muscle Omelette'];
    final cals = ['450', '620', '380', '510'];

    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
            child: const Center(child: Icon(LucideIcons.image, color: Colors.white10, size: 32)),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meals[index], style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('${cals[index]} kcal', style: const TextStyle(color: Color(0xFF7C3AED), fontSize: 10, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildMiniMacro('P', '24g'),
                    const SizedBox(width: 8),
                    _buildMiniMacro('F', '12g'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildMiniMacro(String l, String v) {
    return Row(
      children: [
        Text(l, style: const TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold)),
        const SizedBox(width: 2),
        Text(v, style: const TextStyle(color: Colors.white70, fontSize: 8)),
      ],
    );
  }

  Widget _buildPersonalPlansSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [const Color(0xFF7C3AED).withOpacity(0.1), Colors.transparent]), borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFF7C3AED).withOpacity(0.2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('CUSTOM DIET GENERATOR', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
          const SizedBox(height: 8),
          const Text('Analyze member performance and generate AI-driven nutrition protocols.', style: TextStyle(color: Colors.white38, fontSize: 12)),
          const SizedBox(height: 24),
          NeonButton(label: 'INITIALIZE GENERATOR', onPressed: () {}),
        ],
      ),
    );
  }
}

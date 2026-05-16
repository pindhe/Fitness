import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitpulse_gym/shared/widgets/glass_card.dart';
import 'package:fitpulse_gym/shared/widgets/neon_button.dart';
import 'package:fitpulse_gym/shared/widgets/sidebar.dart';
import 'package:fitpulse_gym/shared/widgets/admin_footer.dart';
import 'dart:ui';

class AdminNutritionPage extends StatefulWidget {
  const AdminNutritionPage({super.key});

  @override
  State<AdminNutritionPage> createState() => _AdminNutritionPageState();
}

class _AdminNutritionPageState extends State<AdminNutritionPage> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Weight Loss', 'Muscle Gain', 'Keto', 'Vegan', 'High Protein', 'Athlete'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const FitPulseSidebar(),
      backgroundColor: const Color(0xFF050816),
      bottomNavigationBar: const FitPulseAdminFooter(currentRoute: '/admin/nutrition'),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050816),
        elevation: 0,
        title: const Text('NUTRITION INTELLIGENCE', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2)),
        leading: Builder(builder: (context) => IconButton(icon: const Icon(LucideIcons.menu, color: Colors.white), onPressed: () => Scaffold.of(context).openDrawer())),
        actions: [
          IconButton(icon: const Icon(LucideIcons.plusCircle, color: Color(0xFF7C3AED)), onPressed: () => _showCreateNutritionForm()),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGlobalNutritionalLoad(),
            const SizedBox(height: 32),
            const Text('DIETARY PROTOCOLS', style: TextStyle(color: Color(0xFF7C3AED), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
            const SizedBox(height: 16),
            _buildCategoryFilter(),
            const SizedBox(height: 24),
            _buildDietaryGrid(),
            const SizedBox(height: 40),
            _buildAIGeneratorPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildGlobalNutritionalLoad() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('GLOBAL MACRONUTRIENT RATIO', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMacroProgress('PROTEIN', 0.85, const Color(0xFF7C3AED)),
                _buildMacroProgress('CARBS', 0.45, const Color(0xFF00FF9D)),
                _buildMacroProgress('LIPIDS', 0.30, const Color(0xFF06B6D4)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroProgress(String label, double val, Color color) {
    return Column(
      children: [
        SizedBox(
          width: 70,
          height: 70,
          child: Stack(
            children: [
              CircularProgressIndicator(value: val, strokeWidth: 8, backgroundColor: Colors.white.withOpacity(0.05), color: color),
              Center(child: Text('${(val * 100).toInt()}%', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900))),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(label, style: TextStyle(color: color.withOpacity(0.7), fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1)),
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
            label: Text(cat, style: TextStyle(color: _selectedCategory == cat ? Colors.white : Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
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

  Widget _buildDietaryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, mainAxisExtent: 220),
      itemCount: 4,
      itemBuilder: (context, index) => _buildMealProtocolCard(index),
    );
  }

  Widget _buildMealProtocolCard(int index) {
    final protocols = ['Hyper-Protein Salmon', 'Ketogenic Fuel Node', 'Vegan Recovery', 'Macro Balance 01'];
    final calories = ['480 kcal', '620 kcal', '350 kcal', '510 kcal'];
    
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 110,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
            child: const Center(child: Icon(LucideIcons.soup, color: Colors.white10, size: 32)),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(protocols[index], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(calories[index], style: const TextStyle(color: Color(0xFF7C3AED), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMiniMetric('P', '32g'),
                    _buildMiniMetric('C', '12g'),
                    _buildMiniMetric('L', '18g'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildMiniMetric(String l, String v) {
    return Column(
      children: [
        Text(l, style: const TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold)),
        Text(v, style: const TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildAIGeneratorPanel() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [const Color(0xFF7C3AED).withOpacity(0.15), Colors.transparent]),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFF7C3AED).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.sparkles, color: Color(0xFF7C3AED), size: 20),
              const SizedBox(width: 12),
              const Text('AI NUTRITION ARCHITECT', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Automatically synthesize personalized meal protocols based on member metabolic data and performance metrics.', style: TextStyle(color: Colors.white38, fontSize: 12, height: 1.5)),
          const SizedBox(height: 28),
          NeonButton(label: 'INITIALIZE ARCHITECT', onPressed: () {}),
        ],
      ),
    );
  }

  void _showCreateNutritionForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF050816),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 32, right: 32, top: 32),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('FORGE NUTRITION PROTOCOL', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 32),
              _buildPremiumInput('Protocol Name', LucideIcons.tag),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildPremiumInput('Calories', LucideIcons.flame)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildPremiumInput('Tier', LucideIcons.award)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildPremiumInput('Protein (g)', LucideIcons.zap)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildPremiumInput('Carbs (g)', LucideIcons.leaf)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildPremiumInput('Fats (g)', LucideIcons.droplets)),
                ],
              ),
              const SizedBox(height: 16),
              _buildPremiumInput('Instructions / Notes', LucideIcons.alignLeft, maxLines: 4),
              const SizedBox(height: 40),
              NeonButton(label: 'DEPlOY PROTOCOL', onPressed: () => Navigator.pop(context)),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumInput(String hint, IconData icon, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
        prefixIcon: Icon(icon, color: Colors.white38, size: 18),
        filled: true,
        fillColor: Colors.white.withOpacity(0.03),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 1)),
      ),
    );
  }
}

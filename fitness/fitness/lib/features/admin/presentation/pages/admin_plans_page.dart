import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitpulse_gym/features/admin/domain/models/membership_plan.dart';
import 'package:fitpulse_gym/features/admin/repositories/membership_plan_repository.dart';
import 'package:fitpulse_gym/shared/widgets/glass_card.dart';
import 'package:fitpulse_gym/shared/widgets/neon_button.dart';
import 'package:fitpulse_gym/shared/widgets/sidebar.dart';
import 'package:fitpulse_gym/shared/widgets/admin_footer.dart';
import 'dart:ui';

class AdminPlansPage extends ConsumerStatefulWidget {
  const AdminPlansPage({super.key});

  @override
  ConsumerState<AdminPlansPage> createState() => _AdminPlansPageState();
}

class _AdminPlansPageState extends ConsumerState<AdminPlansPage> {
  @override
  Widget build(BuildContext context) {
    final plansAsync = ref.watch(membershipPlansStreamProvider);

    return Scaffold(
      drawer: const FitPulseSidebar(),
      backgroundColor: const Color(0xFF050816),
      bottomNavigationBar: const FitPulseAdminFooter(currentRoute: '/admin/plans'),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050816),
        elevation: 0,
        title: const Text('SUBSCRIPTION ARCHITECTURE', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2)),
        leading: Builder(builder: (context) => IconButton(icon: const Icon(LucideIcons.menu, color: Colors.white), onPressed: () => Scaffold.of(context).openDrawer())),
        actions: [
          _buildHeaderAction(LucideIcons.plus, 'ADD TIER', () => _showPlanForm()),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetricsOverview(plansAsync),
            const SizedBox(height: 40),
            const Text('SUBSCRIPTION NODES', style: TextStyle(color: Color(0xFF00FF9D), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
            const SizedBox(height: 16),
            plansAsync.when(
              data: (plans) => GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisExtent: 220,
                  mainAxisSpacing: 16,
                ),
                itemCount: plans.length,
                itemBuilder: (context, index) => _buildPlanManagementCard(plans[index]),
              ),
              loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF00FF9D))),
              error: (e, _) => Center(child: Text('Data Corrupted: $e', style: const TextStyle(color: Colors.redAccent))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderAction(IconData icon, String label, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFF00FF9D).withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF00FF9D).withOpacity(0.3))),
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: const Color(0xFF00FF9D), size: 16),
        label: Text(label, style: const TextStyle(color: Color(0xFF00FF9D), fontWeight: FontWeight.bold, fontSize: 11)),
      ),
    );
  }

  Widget _buildMetricsOverview(AsyncValue<List<MembershipPlan>> plansAsync) {
    return plansAsync.when(
      data: (plans) {
        final active = plans.length;
        final popular = plans.where((p) => p.isPopular).length;
        return Row(
          children: [
            Expanded(child: _buildMetricCard('ACTIVE TIERS', active.toString(), LucideIcons.layers, const Color(0xFF00FF9D))),
            const SizedBox(width: 16),
            Expanded(child: _buildMetricCard('FEATURED', popular.toString(), LucideIcons.star, const Color(0xFF7C3AED))),
          ],
        );
      },
      loading: () => const SizedBox(height: 100),
      error: (_, __) => const SizedBox(),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
            Text(label, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanManagementCard(MembershipPlan plan) {
    final color = Color(plan.accentColor);
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(24), border: Border.all(color: color.withOpacity(0.2))),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
              child: Icon(_getIconData(plan.iconName), color: color, size: 30),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(plan.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                      if (plan.isPopular) ...[
                        const SizedBox(width: 8),
                        _buildBadge('FEATURED', const Color(0xFF7C3AED)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('\$${plan.monthlyPrice} / Month • \$${plan.yearlyPrice} / Year', style: const TextStyle(color: Colors.white38, fontSize: 12)),
                  const SizedBox(height: 8),
                  Text('${plan.features.length} Enabled Protocols', style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: const Icon(LucideIcons.edit3, color: Colors.white38, size: 20), onPressed: () => _showPlanForm(plan: plan)),
                IconButton(icon: Icon(LucideIcons.trash2, color: Colors.redAccent.withOpacity(0.5), size: 20), onPressed: () => _deletePlan(plan)),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4), border: Border.all(color: color.withOpacity(0.3))),
      child: Text(text, style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold)),
    );
  }

  void _showPlanForm({MembershipPlan? plan}) {
    final nameController = TextEditingController(text: plan?.name);
    final descController = TextEditingController(text: plan?.description);
    final monthlyController = TextEditingController(text: plan?.monthlyPrice.toString());
    final yearlyController = TextEditingController(text: plan?.yearlyPrice.toString());
    final featuresController = TextEditingController(text: plan?.features.join('\n') ?? '');
    
    bool isPopular = plan?.isPopular ?? false;
    int selectedColor = plan?.accentColor ?? 0xFF00FF9D;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF050816),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 32),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plan == null ? 'FORGE NEW TIER' : 'RECONFIG TIER', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                const SizedBox(height: 32),
                _buildFormTextField(nameController, 'Tier Designation', LucideIcons.tag),
                const SizedBox(height: 16),
                _buildFormTextField(descController, 'Short Description', LucideIcons.alignLeft, maxLines: 2),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildFormTextField(monthlyController, 'Monthly Price', LucideIcons.dollarSign)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildFormTextField(yearlyController, 'Yearly Price', LucideIcons.calendar)),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('ENABLED PROTOCOLS', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
                const SizedBox(height: 12),
                _buildFormTextField(featuresController, 'Features (One per line)', LucideIcons.checkCircle, maxLines: 5),
                const SizedBox(height: 24),
                SwitchListTile(
                  title: const Text('Feature as "Most Popular"', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  value: isPopular,
                  onChanged: (val) => setModalState(() => isPopular = val),
                  activeColor: const Color(0xFF00FF9D),
                ),
                const SizedBox(height: 24),
                const Text('ACCENT NEON', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [0xFF00FF9D, 0xFF7C3AED, 0xFF06B6D4, 0xFFFF0066].map((color) => GestureDetector(
                    onTap: () => setModalState(() => selectedColor = color),
                    child: Container(width: 40, height: 40, decoration: BoxDecoration(color: Color(color), shape: BoxShape.circle, border: Border.all(color: selectedColor == color ? Colors.white : Colors.transparent, width: 3))),
                  )).toList(),
                ),
                const SizedBox(height: 40),
                NeonButton(
                  label: plan == null ? 'COMMENCE DEPLOYMENT' : 'COMMIT RECONFIG',
                  onPressed: () async {
                    final repo = ref.read(membershipPlanRepositoryProvider);
                    final newPlan = MembershipPlan(
                      id: plan?.id ?? '',
                      name: nameController.text,
                      monthlyPrice: double.tryParse(monthlyController.text) ?? 0,
                      yearlyPrice: double.tryParse(yearlyController.text) ?? 0,
                      description: descController.text,
                      features: featuresController.text.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
                      isPopular: isPopular,
                      iconName: 'zap',
                      accentColor: selectedColor,
                    );

                    if (plan == null) {
                      await repo.addPlan(newPlan);
                    } else {
                      await repo.updatePlan(newPlan);
                    }
                    if (mounted) Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormTextField(TextEditingController controller, String hint, IconData icon, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
        prefixIcon: Icon(icon, color: Colors.white38, size: 18),
        filled: true,
        fillColor: Colors.white.withOpacity(0.03),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF00FF9D), width: 1)),
      ),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'zap': return LucideIcons.zap;
      case 'crown': return LucideIcons.crown;
      case 'award': return LucideIcons.award;
      default: return LucideIcons.dumbbell;
    }
  }

  void _deletePlan(MembershipPlan plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF050816),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: const BorderSide(color: Colors.white10)),
        title: const Text('PURGE TIER', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
        content: Text('Are you certain you wish to permanently decommission the "${plan.name}" protocol?', style: const TextStyle(color: Colors.white60, fontSize: 14)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL', style: TextStyle(color: Colors.white38))),
          TextButton(
            onPressed: () {
              ref.read(membershipPlanRepositoryProvider).deletePlan(plan.id);
              Navigator.pop(context);
            },
            child: const Text('PURGE', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fitpulse_gym/features/admin/domain/models/workout.dart';
import 'package:fitpulse_gym/features/admin/repositories/workout_repository.dart';
import 'package:fitpulse_gym/shared/widgets/glass_card.dart';
import 'package:fitpulse_gym/shared/widgets/neon_button.dart';
import 'package:fitpulse_gym/shared/widgets/sidebar.dart';
import 'package:fitpulse_gym/shared/widgets/admin_footer.dart';
import 'dart:ui';

class WorkoutManagementPage extends ConsumerStatefulWidget {
  const WorkoutManagementPage({super.key});

  @override
  ConsumerState<WorkoutManagementPage> createState() => _WorkoutManagementPageState();
}

class _WorkoutManagementPageState extends ConsumerState<WorkoutManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedLevel = 'All';

  final List<String> _categories = ['All', 'Strength', 'Cardio', 'Fat Loss', 'Muscle Gain', 'Yoga', 'CrossFit', 'HIIT', 'Mobility'];
  final List<String> _levels = ['All', 'Beginner', 'Intermediate', 'Advanced', 'Pro Athlete'];

  @override
  Widget build(BuildContext context) {
    final workoutsAsync = ref.watch(workoutsStreamProvider);

    return Scaffold(
      drawer: const FitPulseSidebar(),
      backgroundColor: const Color(0xFF0B1020),
      bottomNavigationBar: const FitPulseAdminFooter(currentRoute: '/admin/training'),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1020),
        elevation: 0,
        title: const Text('TRAINING COMMAND', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        leading: Builder(builder: (context) => IconButton(icon: const Icon(LucideIcons.menu, color: Colors.white), onPressed: () => Scaffold.of(context).openDrawer())),
        actions: [
          _buildHeaderAction(LucideIcons.plus, 'NEW TRAINING', () => _showWorkoutForm()),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetricGrid(workoutsAsync),
            const SizedBox(height: 40),
            _buildSearchAndFilters(),
            const SizedBox(height: 32),
            workoutsAsync.when(
              data: (workouts) {
                final filtered = workouts.where((w) {
                  final matchesSearch = w.title.toLowerCase().contains(_searchQuery.toLowerCase());
                  final matchesCategory = _selectedCategory == 'All' || w.category == _selectedCategory;
                  final matchesLevel = _selectedLevel == 'All' || w.level == _selectedLevel;
                  return matchesSearch && matchesCategory && matchesLevel;
                }).toList();

                if (filtered.isEmpty) return _buildEmptyState();

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisExtent: 420,
                    mainAxisSpacing: 24,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) => _buildPremiumWorkoutCard(filtered[index]),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF00FF9D))),
              error: (e, _) => Center(child: Text('Command Error: $e', style: const TextStyle(color: Colors.redAccent))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderAction(IconData icon, String label, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF00FF9D), Color(0xFF06B6D4)]),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: const Color(0xFF00FF9D).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.black, size: 16),
        label: Text(label, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 12)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildMetricGrid(AsyncValue<List<Workout>> workoutsAsync) {
    return workoutsAsync.when(
      data: (workouts) {
        final total = workouts.length;
        final advanced = workouts.where((w) => w.level == 'Advanced' || w.level == 'Pro Athlete').length;
        final active = workouts.where((w) => w.isPublished).length;
        final calories = workouts.fold(0, (sum, w) => sum + w.calories);

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildMetricCard('TOTAL PROGRAMS', total.toString(), LucideIcons.layers, const Color(0xFF7C3AED)),
            _buildMetricCard('ACTIVE PROTOCOLS', active.toString(), LucideIcons.zap, const Color(0xFF00FF9D)),
            _buildMetricCard('ELITE NODES', advanced.toString(), LucideIcons.shieldAlert, const Color(0xFF06B6D4)),
            _buildMetricCard('CALORIC LOAD', '${(calories / 1000).toStringAsFixed(1)}K', LucideIcons.flame, Colors.orangeAccent),
          ],
        );
      },
      loading: () => const SizedBox(height: 200),
      error: (_, __) => const SizedBox(),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: color, size: 20),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                    Text(label, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.2);
  }

  Widget _buildSearchAndFilters() {
    return Column(
      children: [
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(LucideIcons.search, color: Color(0xFF00FF9D), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(hintText: 'Search Training Protocols...', hintStyle: TextStyle(color: Colors.white24, fontSize: 14), border: InputBorder.none),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _categories.map((cat) => _buildFilterChip(cat, _selectedCategory == cat, (val) => setState(() => _selectedCategory = cat))).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, Function(bool) onSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: FilterChip(
        label: Text(label, style: TextStyle(color: isSelected ? Colors.black : Colors.white60, fontSize: 12, fontWeight: FontWeight.bold)),
        selected: isSelected,
        onSelected: onSelected,
        backgroundColor: Colors.white.withOpacity(0.05),
        selectedColor: const Color(0xFF00FF9D),
        checkmarkColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: isSelected ? const Color(0xFF00FF9D) : Colors.white10)),
      ),
    );
  }

  Widget _buildPremiumWorkoutCard(Workout workout) {
    final levelColor = _getLevelColor(workout.level);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail Area
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              image: workout.thumbnailUrl != null ? DecorationImage(image: NetworkImage(workout.thumbnailUrl!), fit: BoxFit.cover) : null,
              color: Colors.white.withOpacity(0.05),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, const Color(0xFF0B1020).withOpacity(0.8)],
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBadge(workout.category.toUpperCase(), const Color(0xFF7C3AED)),
                      _buildBadge(workout.level.toUpperCase(), levelColor),
                    ],
                  ),
                  if (workout.videoUrl != null)
                    const Icon(LucideIcons.playCircle, color: Color(0xFF00FF9D), size: 48).animate(onPlay: (c) => c.repeat()).scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 1000.ms, curve: Curves.easeInOut),
                ],
              ),
            ),
          ),
          // Content Area
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(workout.title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.5))),
                    IconButton(icon: const Icon(LucideIcons.moreVertical, color: Colors.white38), onPressed: () => _showActionSheet(workout)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(workout.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13, height: 1.4)),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildIconStat(LucideIcons.clock, workout.duration),
                    _buildIconStat(LucideIcons.flame, '${workout.calories} kcal'),
                    _buildIconStat(LucideIcons.user, workout.trainerName),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: NeonButton(label: 'REFINE PROTOCOL', onPressed: () => _showWorkoutForm(workout: workout))),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                      child: IconButton(icon: const Icon(LucideIcons.trash2, color: Colors.redAccent, size: 20), onPressed: () => _deleteWorkout(workout)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1)),
    );
  }

  Widget _buildIconStat(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF06B6D4), size: 14),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Color _getLevelColor(String level) {
    switch (level) {
      case 'Beginner': return const Color(0xFF00FF9D);
      case 'Intermediate': return const Color(0xFF06B6D4);
      case 'Advanced': return const Color(0xFF7C3AED);
      case 'Pro Athlete': return Colors.redAccent;
      default: return Colors.white;
    }
  }

  void _showWorkoutForm({Workout? workout}) {
    final titleController = TextEditingController(text: workout?.title);
    final descController = TextEditingController(text: workout?.description);
    final durationController = TextEditingController(text: workout?.duration);
    final caloriesController = TextEditingController(text: workout?.calories.toString());
    final thumbController = TextEditingController(text: workout?.thumbnailUrl);
    final videoController = TextEditingController(text: workout?.videoUrl);
    final trainerController = TextEditingController(text: workout?.trainerName ?? '');
    final equipmentController = TextEditingController(text: workout?.equipment.join(', ') ?? '');
    final instructionController = TextEditingController(text: workout?.instructions.join('\n') ?? '');
    
    String level = workout?.level ?? 'Beginner';
    String category = workout?.category ?? 'Strength';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0B1020),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 32),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(workout == null ? 'FORGE NEW PROTOCOL' : 'REFINE PROTOCOL', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                  IconButton(icon: const Icon(LucideIcons.x, color: Colors.white38), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 32),
              _buildFormLabel('IDENTITY'),
              _buildPremiumTextField(titleController, 'Protocol Designation', LucideIcons.activity),
              const SizedBox(height: 16),
              _buildPremiumTextField(descController, 'Mission Objective', LucideIcons.alignLeft, maxLines: 3),
              const SizedBox(height: 24),
              _buildFormLabel('CLASSIFICATION'),
              Row(
                children: [
                  Expanded(
                    child: _buildPremiumDropdown('Category', category, _categories.where((c) => c != 'All').toList(), (val) => category = val!),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildPremiumDropdown('Difficulty', level, _levels.where((l) => l != 'All').toList(), (val) => level = val!),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildFormLabel('ASSETS'),
              _buildPremiumTextField(thumbController, 'Thumbnail Cyber-Link', LucideIcons.image),
              const SizedBox(height: 16),
              _buildPremiumTextField(videoController, 'Video Feed Link', LucideIcons.video),
              const SizedBox(height: 24),
              _buildFormLabel('METRICS & STAFF'),
              Row(
                children: [
                  Expanded(child: _buildPremiumTextField(durationController, 'Duration', LucideIcons.clock)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildPremiumTextField(caloriesController, 'Calories', LucideIcons.flame)),
                ],
              ),
              const SizedBox(height: 16),
              _buildPremiumTextField(trainerController, 'Lead Trainer', LucideIcons.user),
              const SizedBox(height: 24),
              _buildFormLabel('REQUIREMENTS & INTEL'),
              _buildPremiumTextField(equipmentController, 'Equipment (comma separated)', LucideIcons.hammer),
              const SizedBox(height: 16),
              _buildPremiumTextField(instructionController, 'Step-by-Step Instructions', LucideIcons.list, maxLines: 4),
              const SizedBox(height: 40),
              NeonButton(
                label: workout == null ? 'INITIATE UPLOAD' : 'COMMIT REFINEMENTS',
                onPressed: () async {
                  final repo = ref.read(workoutRepositoryProvider);
                  final newWorkout = Workout(
                    id: workout?.id ?? '',
                    title: titleController.text,
                    description: descController.text,
                    category: category,
                    level: level,
                    thumbnailUrl: thumbController.text,
                    videoUrl: videoController.text,
                    duration: durationController.text,
                    calories: int.tryParse(caloriesController.text) ?? 0,
                    equipment: equipmentController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
                    instructions: instructionController.text.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
                    tags: [], // Could add tags field too
                    trainerName: trainerController.text,
                    createdAt: workout?.createdAt ?? DateTime.now(),
                  );

                  if (workout == null) {
                    await repo.addWorkout(newWorkout);
                  } else {
                    await repo.updateWorkout(newWorkout);
                  }
                  if (mounted) Navigator.pop(context);
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(text, style: const TextStyle(color: Color(0xFF00FF9D), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
    );
  }

  Widget _buildPremiumTextField(TextEditingController controller, String hint, IconData icon, {int maxLines = 1}) {
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
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF00FF9D), width: 1)),
        contentPadding: const EdgeInsets.all(18),
      ),
    );
  }

  Widget _buildPremiumDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: const Color(0xFF0B1020),
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white38, fontSize: 12),
        filled: true,
        fillColor: Colors.white.withOpacity(0.03),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
      items: items.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
      onChanged: onChanged,
    );
  }

  void _showActionSheet(Workout workout) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0B1020),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 24),
          _buildActionTile(LucideIcons.eye, 'PREVIEW PROTOCOL', () {}),
          _buildActionTile(LucideIcons.archive, 'ARCHIVE PROTOCOL', () {}),
          _buildActionTile(LucideIcons.share2, 'SHARE ACCESS', () {}),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildActionTile(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white60, size: 20),
      title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      onTap: onTap,
    );
  }

  void _deleteWorkout(Workout workout) {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: const Color(0xFF0B1020),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: const BorderSide(color: Colors.white10)),
          title: const Text('TERMINATE PROTOCOL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
          content: Text('Are you certain you wish to purge "${workout.title}"? This action is irreversible.', style: const TextStyle(color: Colors.white60, fontSize: 14)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL', style: TextStyle(color: Colors.white38))),
            TextButton(
              onPressed: () {
                ref.read(workoutRepositoryProvider).deleteWorkout(workout.id);
                Navigator.pop(context);
              },
              child: const Text('TERMINATE', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 80),
          Icon(LucideIcons.searchX, color: Colors.white10, size: 80),
          const SizedBox(height: 24),
          const Text('NO PROTOCOLS IDENTIFIED', style: TextStyle(color: Colors.white38, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 8),
          const Text('Forge a new training program to begin.', style: TextStyle(color: Colors.white24, fontSize: 12)),
        ],
      ),
    );
  }
}

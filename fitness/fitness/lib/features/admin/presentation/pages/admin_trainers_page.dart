import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitpulse_gym/shared/widgets/sidebar.dart';
import 'package:fitpulse_gym/shared/widgets/admin_footer.dart';
import 'package:fitpulse_gym/features/admin/domain/models/trainer.dart';
import 'package:fitpulse_gym/features/admin/repositories/trainer_repository.dart';
import 'package:fitpulse_gym/shared/widgets/neon_button.dart';
import 'dart:ui';

class AdminTrainersPage extends ConsumerStatefulWidget {
  const AdminTrainersPage({super.key});

  @override
  ConsumerState<AdminTrainersPage> createState() => _AdminTrainersPageState();
}

class _AdminTrainersPageState extends ConsumerState<AdminTrainersPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  void _showTrainerForm({Trainer? trainer}) {
    final nameController = TextEditingController(text: trainer?.name);
    final bioController = TextEditingController(text: trainer?.bio);
    final specialtyController = TextEditingController(text: trainer?.specialty);
    final expController = TextEditingController(text: trainer?.yearsOfExperience.toString());
    final videoController = TextEditingController(text: trainer?.videoUrl);
    String level = trainer?.level ?? 'Junior';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E2630),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(trainer == null ? 'Recruit New Elite' : 'Revise Personnel', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5)),
              const SizedBox(height: 24),
              _buildTextField(nameController, 'Identity Name', LucideIcons.user),
              const SizedBox(height: 16),
              _buildTextField(specialtyController, 'Domain Specialty', LucideIcons.award),
              const SizedBox(height: 16),
              _buildTextField(bioController, 'Professional Dossier', LucideIcons.fileText, maxLines: 3),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField(expController, 'Experience (Yrs)', LucideIcons.calendar)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: level,
                      dropdownColor: const Color(0xFF1E2630),
                      decoration: _inputDecoration('Rank Level', LucideIcons.shield),
                      style: const TextStyle(color: Colors.white),
                      items: ['Junior', 'Senior', 'Master'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (val) => level = val!,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildVideoField(videoController),
              const SizedBox(height: 32),
              NeonButton(
                label: trainer == null ? 'COMMENCE RECRUITMENT' : 'COMMIT REVISIONS',
                onPressed: () async {
                  final repo = ref.read(trainerRepositoryProvider);
                  final newTrainer = Trainer(
                    id: trainer?.id ?? '',
                    name: nameController.text,
                    level: level,
                    specialty: specialtyController.text,
                    bio: bioController.text,
                    yearsOfExperience: int.tryParse(expController.text) ?? 0,
                    videoUrl: videoController.text,
                  );

                  if (trainer == null) {
                    await repo.addTrainer(newTrainer);
                  } else {
                    await repo.updateTrainer(newTrainer);
                  }
                  if (mounted) Navigator.pop(context);
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoField(TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(LucideIcons.video, color: Color(0xFF00FF88), size: 16),
              SizedBox(width: 8),
              Text('Video Portfolio Link', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
            decoration: const InputDecoration(hintText: 'https://vimeo.com/...', hintStyle: TextStyle(color: Colors.white24), border: InputBorder.none),
          ),
        ],
      ),
    );
  }

  void _showTrainerDetails(Trainer trainer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0B0F14),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(color: const Color(0xFF1E2630), borderRadius: const BorderRadius.vertical(top: Radius.circular(32)), border: Border.all(color: Colors.white.withOpacity(0.05))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('TRAINER PROFILE', style: TextStyle(color: Color(0xFF00FF88), fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 2)),
                IconButton(icon: const Icon(LucideIcons.x, color: Colors.white38), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                CircleAvatar(radius: 40, backgroundColor: const Color(0xFF00FF88).withOpacity(0.1), child: Text(trainer.name[0].toUpperCase(), style: const TextStyle(color: Color(0xFF00FF88), fontSize: 32, fontWeight: FontWeight.bold))),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(trainer.name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFF00FF88).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                        child: Text(trainer.level.toUpperCase(), style: const TextStyle(color: Color(0xFF00FF88), fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildInfoRow(LucideIcons.award, 'Specialty', trainer.specialty),
            _buildInfoRow(LucideIcons.calendar, 'Experience', '${trainer.yearsOfExperience} Years'),
            const SizedBox(height: 16),
            Text('BIOGRAPHY', style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(trainer.bio, style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5)),
            const SizedBox(height: 40),
            NeonButton(label: 'EDIT DOSSIER', onPressed: () { Navigator.pop(context); _showTrainerForm(trainer: trainer); }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.white24, size: 20),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11)),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF00FF88), size: 18),
      labelStyle: const TextStyle(color: Colors.white38, fontSize: 12),
      filled: true,
      fillColor: Colors.white.withOpacity(0.03),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF00FF88), width: 1)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: _inputDecoration(label, icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trainersAsync = ref.watch(trainersStreamProvider);

    return Scaffold(
      drawer: const FitPulseSidebar(),
      backgroundColor: const Color(0xFF0B0F14),
      bottomNavigationBar: const FitPulseAdminFooter(currentRoute: '/admin/trainers'),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F14),
        elevation: 0,
        title: const Text('Personnel Command', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        leading: Builder(builder: (context) => IconButton(icon: const Icon(LucideIcons.menu, color: Colors.white), onPressed: () => Scaffold.of(context).openDrawer())),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plusCircle, color: Color(0xFF00FF88)),
            onPressed: () => _showTrainerForm(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: _buildSearchAndFilter(),
          ),
          Expanded(
            child: trainersAsync.when(
              data: (trainers) {
                final filtered = trainers.where((t) => t.name.toLowerCase().contains(_searchQuery.toLowerCase()) || t.specialty.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisExtent: 180,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) => _buildProfessionalTrainerCard(filtered[index]),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF00FF88))),
              error: (e, _) => Center(child: Text('Personnel Sync Error: $e', style: const TextStyle(color: Colors.redAccent))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(LucideIcons.search, color: Color(0xFF00FF88), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(hintText: 'Search the Squad...', hintStyle: TextStyle(color: Colors.white24, fontSize: 14), border: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalTrainerCard(Trainer trainer) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: const Color(0xFF3B82F6).withOpacity(0.1),
                  child: Text(trainer.name[0].toUpperCase(), style: const TextStyle(color: Color(0xFF3B82F6), fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(trainer.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(trainer.specialty, style: const TextStyle(color: Color(0xFF00FF88), fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildCardStat(LucideIcons.shield, trainer.level),
                          const SizedBox(width: 12),
                          _buildCardStat(LucideIcons.clock, '${trainer.yearsOfExperience}y Exp'),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(icon: const Icon(LucideIcons.info, color: Colors.white38, size: 18), onPressed: () => _showTrainerDetails(trainer)),
                    IconButton(icon: const Icon(LucideIcons.trash2, color: Colors.redAccent, size: 18), onPressed: () => ref.read(trainerRepositoryProvider).deleteTrainer(trainer.id)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.1);
  }

  Widget _buildCardStat(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white24, size: 12),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.white54, fontSize: 10)),
      ],
    );
  }
}


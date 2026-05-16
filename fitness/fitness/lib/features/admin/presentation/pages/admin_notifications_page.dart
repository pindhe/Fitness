import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitpulse_gym/shared/widgets/glass_card.dart';
import 'package:fitpulse_gym/shared/widgets/neon_button.dart';
import 'package:fitpulse_gym/shared/widgets/sidebar.dart';
import 'package:fitpulse_gym/shared/widgets/admin_footer.dart';
import 'dart:ui';

class AdminNotificationsPage extends StatefulWidget {
  const AdminNotificationsPage({super.key});

  @override
  State<AdminNotificationsPage> createState() => _AdminNotificationsPageState();
}

class _AdminNotificationsPageState extends State<AdminNotificationsPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String _selectedAudience = 'All Members';
  String _selectedPriority = 'Normal';

  final List<String> _audiences = ['All Members', 'Trainers', 'Elite Tier', 'Inactive Users'];
  final List<String> _priorities = ['Low', 'Normal', 'High', 'Urgent'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const FitPulseSidebar(),
      backgroundColor: const Color(0xFF050816),
      bottomNavigationBar: const FitPulseAdminFooter(currentRoute: '/admin/notifications'),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050816),
        elevation: 0,
        title: const Text('NOTIFICATION BROADCAST', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2)),
        leading: Builder(builder: (context) => IconButton(icon: const Icon(LucideIcons.menu, color: Colors.white), onPressed: () => Scaffold.of(context).openDrawer())),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBroadcastConsole(),
            const SizedBox(height: 32),
            _buildSectionHeader('TRANSMISSION LOGS', LucideIcons.history),
            const SizedBox(height: 16),
            _buildNotificationHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF00FF9D), size: 16),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(color: Color(0xFF00FF9D), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
      ],
    );
  }

  Widget _buildBroadcastConsole() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('NEW BROADCAST PROTOCOL', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
            const SizedBox(height: 24),
            _buildAudienceSelector(),
            const SizedBox(height: 24),
            _buildPremiumTextField(_titleController, 'Message Title', LucideIcons.type),
            const SizedBox(height: 16),
            _buildPremiumTextField(_messageController, 'Compose Transmission...', LucideIcons.messageSquare, maxLines: 4),
            const SizedBox(height: 24),
            _buildPrioritySelector(),
            const SizedBox(height: 32),
            NeonButton(label: 'INITIATE BROADCAST', onPressed: () => _simulateBroadcast()),
          ],
        ),
      ),
    );
  }

  Widget _buildAudienceSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('TARGET AUDIENCE', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _audiences.map((aud) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ChoiceChip(
                label: Text(aud, style: TextStyle(color: _selectedAudience == aud ? Colors.black : Colors.white60, fontSize: 11, fontWeight: FontWeight.bold)),
                selected: _selectedAudience == aud,
                onSelected: (val) => setState(() => _selectedAudience = aud),
                selectedColor: const Color(0xFF00FF9D),
                backgroundColor: Colors.white.withOpacity(0.03),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: _selectedAudience == aud ? const Color(0xFF00FF9D) : Colors.white10)),
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPrioritySelector() {
    return Row(
      children: [
        const Text('PRIORITY:', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
        const SizedBox(width: 16),
        ..._priorities.map((p) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => setState(() => _selectedPriority = p),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _selectedPriority == p ? _getPriorityColor(p).withOpacity(0.2) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _selectedPriority == p ? _getPriorityColor(p) : Colors.white10),
              ),
              child: Text(p, style: TextStyle(color: _selectedPriority == p ? _getPriorityColor(p) : Colors.white38, fontSize: 9, fontWeight: FontWeight.bold)),
            ),
          ),
        )).toList(),
      ],
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
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF00FF9D), width: 1)),
      ),
    );
  }

  Widget _buildNotificationHistory() {
    return Column(
      children: List.generate(3, (index) => _buildHistoryTile(index)),
    );
  }

  Widget _buildHistoryTile(int index) {
    final titles = ['Maintenance Alert', 'New HIIT Protocol', 'Elite Tier Perks'];
    final counts = ['1,242 nodes', '850 nodes', '124 nodes'];
    final times = ['2h ago', '5h ago', 'Yesterday'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: ListTile(
        leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle), child: const Icon(LucideIcons.send, color: Color(0xFF00FF9D), size: 18)),
        title: Text(titles[index], style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        subtitle: Text('Broadcast to ${counts[index]} • ${times[index]}', style: const TextStyle(color: Colors.white38, fontSize: 11)),
        trailing: const Icon(LucideIcons.chevronRight, color: Colors.white24, size: 16),
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Color _getPriorityColor(String p) {
    switch (p) {
      case 'Urgent': return Colors.redAccent;
      case 'High': return Colors.orangeAccent;
      case 'Normal': return const Color(0xFF00FF9D);
      default: return Colors.white38;
    }
  }

  void _simulateBroadcast() {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: const Color(0xFF050816),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: BorderSide(color: const Color(0xFF00FF9D).withOpacity(0.3))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.checkCircle2, color: Color(0xFF00FF9D), size: 48).animate().scale(),
              const SizedBox(height: 24),
              const Text('BROADCAST INITIATED', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text('Transmission sent to $_selectedAudience.', style: const TextStyle(color: Colors.white38, fontSize: 13)),
              const SizedBox(height: 32),
              NeonButton(label: 'CONFIRM', onPressed: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }
}

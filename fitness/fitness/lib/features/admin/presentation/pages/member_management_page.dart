import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:fitpulse_gym/shared/widgets/glass_card.dart';
import 'package:fitpulse_gym/shared/widgets/neon_button.dart';
import 'package:fitpulse_gym/shared/widgets/header.dart';
import 'package:fitpulse_gym/shared/widgets/footer.dart';
import 'package:fitpulse_gym/shared/widgets/sidebar.dart';
import 'package:fitpulse_gym/shared/widgets/admin_footer.dart';
import 'package:fitpulse_gym/features/admin/domain/models/member.dart';
import 'package:fitpulse_gym/features/admin/repositories/member_repository.dart';

class MemberManagementPage extends ConsumerStatefulWidget {
  const MemberManagementPage({super.key});

  @override
  ConsumerState<MemberManagementPage> createState() => _MemberManagementPageState();
}

class _MemberManagementPageState extends ConsumerState<MemberManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showMemberDetails(Member member) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0B0F14),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2630),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('MEMBER PROFILE', style: TextStyle(color: Color(0xFF00FF88), fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 2)),
                IconButton(icon: const Icon(LucideIcons.x, color: Colors.white38), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color(0xFF00FF88).withOpacity(0.1),
                  child: Text(member.name[0].toUpperCase(), style: const TextStyle(color: Color(0xFF00FF88), fontSize: 32, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(member.name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      Text(member.memberId, style: const TextStyle(color: Color(0xFF00FF88), fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(color: (member.status == 'Active' ? const Color(0xFF00FF88) : Colors.redAccent).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                        child: Text(member.status.toUpperCase(), style: TextStyle(color: member.status == 'Active' ? const Color(0xFF00FF88) : Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            _buildDetailField('Communication Node', member.email, LucideIcons.mail),
            _buildDetailField('Contact Frequency', member.phoneNumber, LucideIcons.phone),
            _buildDetailField('Subscription Tier', member.membershipPlan, LucideIcons.award),
            _buildDetailField('Total Activity', '${member.totalWorkouts} Workouts', LucideIcons.activity),
            _buildDetailField('Last Check-in', member.lastCheckIn?.toString().substring(0, 16) ?? 'No record', LucideIcons.clock),
            const SizedBox(height: 40),
            NeonButton(label: 'EDIT PERMISSIONS', onPressed: () {
              Navigator.pop(context);
              _showMemberForm(member: member);
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailField(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Icon(icon, color: Colors.white24, size: 20),
          const SizedBox(width: 20),
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

  void _showMemberForm({Member? member}) {
    final nameController = TextEditingController(text: member?.name);
    final usernameController = TextEditingController(text: member?.username);
    final emailController = TextEditingController(text: member?.email);
    final passwordController = TextEditingController(text: member?.password);
    final phoneController = TextEditingController(text: member?.phoneNumber);
    String status = member?.status ?? 'Active';
    String plan = member?.membershipPlan ?? 'Basic';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E2630),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                member == null ? 'Onboard New Member' : 'Revise Member Node',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5),
              ),
              const SizedBox(height: 24),
              _buildTextField(nameController, 'Full Identity Name', LucideIcons.user),
              const SizedBox(height: 16),
              _buildTextField(phoneController, 'Contact Phone Number', LucideIcons.phone),
              const SizedBox(height: 16),
              _buildTextField(usernameController, 'System Username', LucideIcons.atSign),
              const SizedBox(height: 16),
              _buildTextField(emailController, 'Communication Email', LucideIcons.mail),
              const SizedBox(height: 16),
              _buildTextField(passwordController, 'Security Password', LucideIcons.lock, isPassword: true),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: plan,
                      dropdownColor: const Color(0xFF1E2630),
                      decoration: _inputDecoration('Tier Plan', LucideIcons.award),
                      style: const TextStyle(color: Colors.white),
                      items: ['Basic', 'Pro', 'Elite'].map((s) {
                        return DropdownMenuItem(value: s, child: Text(s));
                      }).toList(),
                      onChanged: (val) => plan = val!,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: status,
                      dropdownColor: const Color(0xFF1E2630),
                      decoration: _inputDecoration('Access Status', LucideIcons.shieldCheck),
                      style: const TextStyle(color: Colors.white),
                      items: ['Active', 'Inactive', 'Suspended'].map((s) {
                        return DropdownMenuItem(value: s, child: Text(s));
                      }).toList(),
                      onChanged: (val) => status = val!,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              NeonButton(
                label: member == null ? 'INITIALIZE MEMBER' : 'COMMIT UPDATES',
                onPressed: () async {
                  final repo = ref.read(memberRepositoryProvider);
                  
                  String memberId = member?.memberId ?? await repo.generateMemberId();

                  final newMember = Member(
                    id: member?.id ?? '',
                    memberId: memberId,
                    name: nameController.text,
                    username: usernameController.text,
                    email: emailController.text,
                    password: passwordController.text,
                    phoneNumber: phoneController.text,
                    membershipPlan: plan,
                    status: status,
                    createdAt: member?.createdAt ?? DateTime.now(),
                    avatarUrl: member?.avatarUrl,
                    lastCheckIn: member?.lastCheckIn,
                    totalWorkouts: member?.totalWorkouts ?? 0,
                  );

                  if (member == null) {
                    await repo.addMember(newMember);
                  } else {
                    await repo.updateMember(newMember);
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

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: _inputDecoration(label, icon),
    );
  }


  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(membersStreamProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
      drawer: const FitPulseSidebar(),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(),
                  const SizedBox(height: 24),
                  membersAsync.when(
                    data: (members) {
                      final filteredMembers = members.where((m) {
                        return m.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                               m.memberId.toLowerCase().contains(_searchQuery.toLowerCase());
                      }).toList();
                      
                      return Column(
                        children: filteredMembers.map((member) => _buildMemberCard(member)).toList(),
                      );
                    },
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: CircularProgressIndicator(color: Color(0xFF00FF88)),
                      ),
                    ),
                    error: (e, _) => Center(
                      child: Text('Data Sync Error: $e', style: const TextStyle(color: Colors.redAccent)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: FitPulseFooter()),
        ],
      ),
      bottomNavigationBar: const FitPulseAdminFooter(currentRoute: '/admin/members'),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 180.0,
      floating: true,
      pinned: true,
      backgroundColor: const Color(0xFF0B0F14),
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(LucideIcons.menu, color: Colors.white),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: const TextStyle(color: Colors.white, fontSize: 12),
              decoration: const InputDecoration(
                hintText: 'Search identifiers...',
                hintStyle: TextStyle(color: Colors.white24),
                prefixIcon: Icon(LucideIcons.search, color: Colors.white24, size: 14),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF00FF88).withOpacity(0.05),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: IconButton(
            icon: const Icon(LucideIcons.plusCircle, color: Color(0xFF00FF88)),
            onPressed: () => _showMemberForm(),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Active Registrations',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Manage and verify gym access protocols',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF00FF88).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF00FF88).withOpacity(0.2)),
          ),
          child: const Row(
            children: [
              Icon(LucideIcons.users, color: Color(0xFF00FF88), size: 14),
              SizedBox(width: 6),
              Text(
                'LIVE SYNC',
                style: TextStyle(color: Color(0xFF00FF88), fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMemberCard(Member member) {
    final isActive = member.status == 'Active';
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.white.withOpacity(0.02),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _showMemberDetails(member),
                  child: Container(
                    height: 54,
                    width: 54,
                    decoration: BoxDecoration(
                      color: (isActive ? const Color(0xFF00FF88) : Colors.redAccent).withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: (isActive ? const Color(0xFF00FF88) : Colors.redAccent).withOpacity(0.2),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
                        style: TextStyle(
                          color: isActive ? const Color(0xFF00FF88) : Colors.redAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showMemberDetails(member),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.name,
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                member.memberId,
                                style: const TextStyle(color: Color(0xFF00FF88), fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              member.email,
                              style: const TextStyle(color: Colors.white38, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(LucideIcons.info, size: 18, color: Color(0xFF3B82F6)),
                      onPressed: () => _showMemberDetails(member),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.edit3, size: 18, color: Colors.white38),
                      onPressed: () => _showMemberForm(member: member),
                    ),
                    IconButton(
                      icon: Icon(LucideIcons.trash2, size: 18, color: Colors.redAccent.withOpacity(0.5)),
                      onPressed: () => _confirmDelete(member),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(Member member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2630),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Member?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to terminate the node for ${member.name}? This action cannot be reversed.', style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL', style: TextStyle(color: Colors.white38))),
          TextButton(
            onPressed: () {
              ref.read(memberRepositoryProvider).deleteMember(member.id);
              Navigator.pop(context);
            },
            child: const Text('DELETE', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}



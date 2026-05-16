import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitpulse_gym/features/auth/repositories/auth_repository.dart';
import 'package:fitpulse_gym/shared/widgets/glass_card.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitpulse_gym/config/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification Error: Passwords do not match'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.registerWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
      );
      ref.read(userRoleProvider.notifier).setRole('usernormal');
      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Enrollment Failed: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient Orbs
          Positioned(
            top: -100,
            right: -100,
            child: _buildGlowOrb(AppTheme.primary.withOpacity(0.12)),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: _buildGlowOrb(AppTheme.secondary.withOpacity(0.12)),
          ),
          
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  children: [
                    _buildLogo(context),
                    const SizedBox(height: 30),
                    _buildRegisterCard(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlowOrb(Color color) {
    return Container(
      width: 400,
      height: 400,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    ).animate(onPlay: (c) => c.repeat(reverse: true))
     .scale(begin: const Offset(1, 1), end: const Offset(1.3, 1.3), duration: 6.seconds)
     .blur(begin: const Offset(80, 80), end: const Offset(120, 120));
  }

  Widget _buildLogo(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.secondary.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.secondary.withOpacity(0.2)),
          ),
          child: const Icon(LucideIcons.userPlus, size: 36, color: AppTheme.secondary),
        ).animate().scale(curve: Curves.easeOutBack),
        const SizedBox(height: 16),
        const Text(
          'HUB ENROLLMENT',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
            fontFamily: 'Outfit',
          ),
        ).animate().fadeIn(delay: 200.ms),
      ],
    );
  }

  Widget _buildRegisterCard(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          const Text(
            'PROTOCOL INITIALIZATION',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2),
          ),
          const SizedBox(height: 24),
          _buildTextField(context, _nameController, 'FULL IDENTIFIER', LucideIcons.user),
          const SizedBox(height: 16),
          _buildTextField(context, _emailController, 'NEURAL EMAIL', LucideIcons.mail),
          const SizedBox(height: 16),
          _buildTextField(context, _passwordController, 'ACCESS KEY', LucideIcons.lock, isPassword: true),
          const SizedBox(height: 16),
          _buildTextField(context, _confirmPasswordController, 'CONFIRM KEY', LucideIcons.shieldCheck, isPassword: true),
          const SizedBox(height: 32),
          if (_isLoading)
            const CircularProgressIndicator(color: AppTheme.primary)
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('INITIALIZE PROFILE', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5)),
              ),
            ),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: () {
              ref.read(userRoleProvider.notifier).setRole('usernormal');
              context.go('/');
            },
            icon: const Icon(LucideIcons.shieldCheck, size: 14, color: AppTheme.primary),
            label: const Text('QUICK BYPASS (MEMBER)', style: TextStyle(color: AppTheme.primary, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1)),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("EXISTING OPERATIVE?", style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5), fontSize: 11, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('INITIATE ACCESS', style: TextStyle(color: AppTheme.secondary, fontSize: 11, fontWeight: FontWeight.w900)),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildTextField(BuildContext context, TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4), letterSpacing: 1),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: isPassword,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppTheme.secondary.withOpacity(0.5), size: 16),
            filled: true,
            fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.secondary, width: 1)),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ],
    );
  }
}

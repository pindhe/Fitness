import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitpulse_gym/features/auth/repositories/auth_repository.dart';
import 'package:fitpulse_gym/shared/widgets/glass_card.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitpulse_gym/config/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    final authRepo = ref.read(authRepositoryProvider);
    final identifier = _identifierController.text;
    final password = _passwordController.text;

    try {
      if (authRepo.isAdmin(identifier, password)) {
        ref.read(userRoleProvider.notifier).setRole('admin');
        if (mounted) context.go('/admin');
        return;
      }

      await authRepo.signInWithEmailAndPassword(identifier, password);
      ref.read(userRoleProvider.notifier).setRole('usernormal');
      if (mounted) context.go('/');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification Failed: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient Orbs
          Positioned(
            top: -100,
            left: -100,
            child: _buildGlowOrb(AppTheme.primary.withOpacity(0.15)),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: _buildGlowOrb(AppTheme.secondary.withOpacity(0.15)),
          ),
          
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  children: [
                    _buildLogo(context),
                    const SizedBox(height: 40),
                    _buildLoginCard(context),
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
     .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 5.seconds)
     .blur(begin: const Offset(80, 80), end: const Offset(100, 100));
  }

  Widget _buildLogo(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
          ),
          child: const Icon(LucideIcons.dumbbell, size: 48, color: AppTheme.primary),
        ).animate().scale(curve: Curves.easeOutBack),
        const SizedBox(height: 20),
        const Text(
          'FITPULSE ALPHA',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: 4,
            fontFamily: 'Outfit',
          ),
        ).animate().fadeIn(delay: 200.ms),
        Text(
          'NEURAL FITNESS PROTOCOL',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4),
          ),
        ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }

  Widget _buildLoginCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Text(
            'INITIATE ACCESS',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2),
          ),
          const SizedBox(height: 32),
          _buildTextField(context, _identifierController, 'USER IDENTIFIER', LucideIcons.user),
          const SizedBox(height: 20),
          _buildTextField(context, _passwordController, 'ACCESS KEY', LucideIcons.shieldCheck, isPassword: true),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text(
                'FORGOT KEY?',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.primary.withOpacity(0.7)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (_isLoading)
            const CircularProgressIndicator(color: AppTheme.primary)
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('AUTHENTICATE', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2)),
              ),
            ).animate().shimmer(delay: 1.seconds, duration: 2.seconds),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("NEW OPERATIVE?", style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5), fontSize: 11, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => context.go('/register'),
                child: const Text('ENROLL NOW', style: TextStyle(color: AppTheme.primary, fontSize: 11, fontWeight: FontWeight.w900)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () {
              ref.read(userRoleProvider.notifier).setRole('admin');
              context.go('/admin');
            },
            icon: const Icon(LucideIcons.terminal, size: 14, color: Colors.orangeAccent),
            label: const Text('DEVELOPER BYPASS', style: TextStyle(color: Colors.orangeAccent, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1)),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1);
  }

  Widget _buildTextField(BuildContext context, TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4), letterSpacing: 1),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppTheme.primary.withOpacity(0.5), size: 18),
            filled: true,
            fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppTheme.primary, width: 1)),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }
}

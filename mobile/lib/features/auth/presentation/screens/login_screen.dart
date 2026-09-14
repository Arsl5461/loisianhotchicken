import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/admin_widgets.dart';
import '../../../../core/widgets/brand_logo.dart';
import '../providers/auth_notifier.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref.read(authNotifierProvider.notifier).login(
          email: _email.text,
          password: _password.text,
        );
    if (!ok && mounted) {
      final error = ref.read(authNotifierProvider).error ?? 'Unable to sign in';
      showAdminSnackBar(context, error, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authNotifierProvider);
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BrandLogo(size: 64, radius: 18),
                    const SizedBox(height: 24),
                    const Text(
                      'WELCOME BACK',
                      style: TextStyle(
                        color: AppColors.brandRed,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.6,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Sign in to Admin', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    const Text(
                      'Use your organization credentials to manage stores, sales, and P&L.',
                      style: TextStyle(color: AppColors.muted, height: 1.4),
                    ),
                    const SizedBox(height: 28),
                    AdminCard(
                      child: Column(
                        children: [
                          AdminTextField(
                            label: 'Email',
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            hint: 'Enter your email',
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) return 'Email is required';
                              if (!value.contains('@')) return 'Enter a valid email';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          AdminTextField(
                            label: 'Password',
                            controller: _password,
                            obscureText: _obscure,
                            textInputAction: TextInputAction.done,
                            hint: 'Enter your password',
                            validator: (value) {
                              if (value == null || value.length < 6) return 'Password must be at least 6 characters';
                              return null;
                            },
                            suffix: IconButton(
                              onPressed: () => setState(() => _obscure = !_obscure),
                              icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                            ),
                          ),
                          const SizedBox(height: 20),
                          AdminButton(label: 'Continue', loading: auth.busy, onPressed: _submit),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

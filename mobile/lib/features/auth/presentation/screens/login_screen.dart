import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  final _otp = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _otp.dispose();
    super.dispose();
  }

  void _useDifferentAccount() {
    _otp.clear();
    ref.read(authNotifierProvider.notifier).clearOtpChallenge();
  }

  Future<void> _submitCredentials() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref.read(authNotifierProvider.notifier).login(
          email: _email.text,
          password: _password.text,
        );
    if (!mounted) return;
    final auth = ref.read(authNotifierProvider);
    if (!ok && auth.otpChallenge == null) {
      showAdminSnackBar(context, auth.error ?? 'Unable to sign in', isError: true);
    }
  }

  Future<void> _submitOtp() async {
    final code = _otp.text.trim();
    if (code.length != 6) {
      showAdminSnackBar(context, 'Enter the 6-digit code', isError: true);
      return;
    }
    final ok = await ref.read(authNotifierProvider.notifier).verifyOtp(code: code);
    if (!ok && mounted) {
      final error = ref.read(authNotifierProvider).error ?? 'Invalid or expired code';
      showAdminSnackBar(context, error, isError: true);
    }
  }

  Future<void> _resendOtp() async {
    final ok = await ref.read(authNotifierProvider.notifier).resendOtp();
    if (!mounted) return;
    if (ok) {
      showAdminSnackBar(context, 'A new code was sent to your email');
    } else {
      showAdminSnackBar(context, ref.read(authNotifierProvider).error ?? 'Unable to resend code', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authNotifierProvider);
    final challenge = auth.otpChallenge;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF1EE),
              AppColors.canvas,
              Color(0xFFF1F5F9),
            ],
            stops: [0, 0.35, 1],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 36),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.brandRed.withValues(alpha: 0.18),
                              blurRadius: 28,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: BrandLogo(
                          size: 88,
                          radius: 24,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Louisiana Hot Chicken',
                          maxLines: 1,
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                            height: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        challenge == null ? 'WELCOME BACK' : 'VERIFY ACCESS',
                        style: const TextStyle(
                          color: AppColors.brandRed,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.8,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        challenge == null ? 'Sign in' : 'Enter verification code',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800, height: 1.1),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        challenge == null
                            ? 'Use your organization credentials to manage stores, sales, and P&L.'
                            : 'We sent a 6-digit code to ${challenge.email}.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.muted, height: 1.45, fontSize: 15),
                      ),
                      const SizedBox(height: 28),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: challenge == null
                            ? Column(
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
                                      if (value == null || value.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }
                                      return null;
                                    },
                                    suffix: IconButton(
                                      onPressed: () => setState(() => _obscure = !_obscure),
                                      icon: Icon(
                                        _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () => context.push('/forgot-password'),
                                      child: const Text(
                                        'Forgot password?',
                                        style: TextStyle(fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  AdminButton(
                                    label: 'Continue',
                                    loading: auth.busy,
                                    onPressed: _submitCredentials,
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  AdminTextField(
                                    label: '6-digit code',
                                    controller: _otp,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    hint: '000000',
                                  ),
                                  const SizedBox(height: 18),
                                  AdminButton(
                                    label: 'Verify and continue',
                                    loading: auth.busy,
                                    onPressed: _submitOtp,
                                  ),
                                  const SizedBox(height: 10),
                                  TextButton(
                                    onPressed: auth.busy ? null : _resendOtp,
                                    child: const Text('Resend code'),
                                  ),
                                  TextButton(
                                    onPressed: auth.busy ? null : _useDifferentAccount,
                                    child: const Text('Use a different account'),
                                  ),
                                ],
                              ),
                      ),
                      const SizedBox(height: 24),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            color: AppColors.muted.withValues(alpha: 0.95),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                          children: [
                            const TextSpan(text: 'Authorized team access only. '),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: GestureDetector(
                                onTap: () => context.push('/privacy-policy'),
                                child: const Text(
                                  'Privacy Policy',
                                  style: TextStyle(
                                    color: AppColors.brandRed,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

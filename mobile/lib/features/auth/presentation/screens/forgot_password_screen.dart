import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/admin_widgets.dart';
import '../../../../core/widgets/brand_logo.dart';
import '../providers/auth_providers.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _email = TextEditingController();
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _codeSent = false;
  bool _busy = false;
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _handleBack() {
    if (_codeSent) {
      setState(() => _codeSent = false);
      return;
    }
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/login');
    }
  }

  Future<void> _sendCode() async {
    final email = _email.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      showAdminSnackBar(context, 'Enter a valid email', isError: true);
      return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(forgotPasswordUseCaseProvider)(email: email);
      if (!mounted) return;
      setState(() => _codeSent = true);
      showAdminSnackBar(context, 'If that email exists, a reset code was sent.');
    } on Failure catch (error) {
      if (mounted) showAdminSnackBar(context, error.message, isError: true);
    } catch (_) {
      if (mounted) showAdminSnackBar(context, 'Unable to send reset code', isError: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _reset() async {
    final email = _email.text.trim();
    final code = _code.text.trim();
    final password = _password.text;
    if (code.length != 6) {
      showAdminSnackBar(context, 'Enter the 6-digit code', isError: true);
      return;
    }
    if (password.length < 8) {
      showAdminSnackBar(context, 'Password must be at least 8 characters', isError: true);
      return;
    }
    if (password != _confirm.text) {
      showAdminSnackBar(context, 'Passwords do not match', isError: true);
      return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(resetPasswordUseCaseProvider)(email: email, code: code, newPassword: password);
      if (!mounted) return;
      showAdminSnackBar(context, 'Password reset. You can sign in now.');
      context.go('/login');
    } on Failure catch (error) {
      if (mounted) showAdminSnackBar(context, error.message, isError: true);
    } catch (_) {
      if (mounted) showAdminSnackBar(context, 'Unable to reset password', isError: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF1EE),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: _handleBack,
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Reset password'),
        centerTitle: true,
      ),
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
            stops: [0, 0.28, 1],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
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
                      size: 80,
                      radius: 22,
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
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                        height: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _codeSent
                        ? 'Enter the code we emailed you and choose a new password.'
                        : 'Enter your account email and we will send a reset code.',
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
                    child: Column(
                      children: [
                        AdminTextField(
                          label: 'Email',
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          hint: 'Enter your email',
                        ),
                        if (_codeSent) ...[
                          const SizedBox(height: 16),
                          AdminTextField(
                            label: 'Reset code',
                            controller: _code,
                            keyboardType: TextInputType.number,
                            hint: '6-digit code',
                          ),
                          const SizedBox(height: 16),
                          AdminTextField(
                            label: 'New password',
                            controller: _password,
                            obscureText: _obscure,
                            hint: 'At least 8 characters',
                            suffix: IconButton(
                              onPressed: () => setState(() => _obscure = !_obscure),
                              icon: Icon(
                                _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          AdminTextField(
                            label: 'Confirm password',
                            controller: _confirm,
                            obscureText: _obscure,
                          ),
                        ],
                        const SizedBox(height: 20),
                        AdminButton(
                          label: _codeSent ? 'Reset password' : 'Send reset code',
                          loading: _busy,
                          onPressed: _codeSent ? _reset : _sendCode,
                        ),
                        if (_codeSent)
                          TextButton(
                            onPressed: _busy ? null : _sendCode,
                            child: const Text('Resend code'),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

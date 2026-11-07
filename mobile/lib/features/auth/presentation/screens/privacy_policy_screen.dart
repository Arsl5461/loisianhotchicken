import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/admin_widgets.dart';
import '../../../../core/widgets/brand_logo.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        children: [
          const Center(child: BrandLogo(size: 64, radius: 18)),
          const SizedBox(height: 14),
          const Text(
            'Louisiana Hot Chicken',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          const Text(
            'Last updated: November 7, 2026',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, fontSize: 13),
          ),
          const SizedBox(height: 20),
          AdminCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _section(
                  'Introduction',
                  'This Privacy Policy explains how LHC (Louisiana Hot Chicken) collects, uses, stores, and shares information when you use our website, web dashboard, and mobile apps. LHC is an internal business operations tool for authorized team members and is not directed to children.',
                ),
                _section(
                  'Information we collect',
                  'Account details such as name, email, hashed password, role, and assigned stores; authentication data such as login codes and session tokens; business data you enter including stores, sales, expenses, receipts, borrowings, and reports; device/technical data such as IP address, device type, app version, and diagnostics; and media you choose to upload as receipts or attachments.',
                ),
                _section(
                  'How we use information',
                  'We use this information to authenticate users, provide multi-store operations features, enforce permissions, send sign-in/reset codes, protect security, support the service, and meet legal obligations. We do not use your data for advertising.',
                ),
                _section(
                  'How we share information',
                  'We do not sell personal information. We may share data with service providers that host or operate the service, authorized organization administrators, and legal authorities when required by law.',
                ),
                _section(
                  'Storage, security, and retention',
                  'Data is stored on our servers with protections such as HTTPS, hashed passwords, and role-based access. We retain records as needed for operations, accounting, and legal requirements. You may request access, correction, or deletion by contacting us.',
                ),
                _section(
                  'Contact',
                  'Email: ${AppConfig.privacyContactEmail}\nWebsite: ${AppConfig.privacyPolicyUrl}\nOrganization: Louisiana Hot Chicken / LHC Holdings',
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(const ClipboardData(text: AppConfig.privacyPolicyUrl));
                    if (context.mounted) {
                      showAdminSnackBar(context, 'Privacy policy link copied');
                    }
                  },
                  icon: const Icon(Icons.link_rounded),
                  label: const Text('Copy web privacy policy link'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _section(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 6),
          Text(body, style: const TextStyle(color: AppColors.ink, height: 1.45)),
        ],
      ),
    );
  }
}

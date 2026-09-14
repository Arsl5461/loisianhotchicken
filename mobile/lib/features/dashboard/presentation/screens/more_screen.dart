import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/permissions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/admin_widgets.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final can = ref.watch(permissionCheckerProvider);
    final user = ref.watch(currentUserProvider);
    final items = [
      if (can(Permissions.storesRead)) _Item('Stores', 'Locations and store performance', Icons.storefront_outlined, '/stores'),
      if (can(Permissions.expensesRead)) _Item('Expense categories', 'Manage expense labels', Icons.sell_outlined, '/expense-categories'),
      if (can(Permissions.expensesRead)) _Item('Payment methods', 'Tenders used on sales and expenses', Icons.credit_card, '/payment-methods'),
      if (can(Permissions.reportsRead)) _Item('Profit & Loss', 'Net profit by period', Icons.pie_chart_outline, '/profit-loss'),
      if (can(Permissions.reportsRead)) _Item('Reports', 'Income and expense statement', Icons.bar_chart_rounded, '/reports'),
      if (can(Permissions.reportsRead)) _Item('Tender types', 'Collections by payment method', Icons.payments_outlined, '/tender-types'),
      if (user?.canManageUsers == true) _Item('Users', 'Create and assign admin users', Icons.people_outline, '/users'),
      if (user?.canManageRoles == true) _Item('Roles & permissions', 'Permission matrix', Icons.shield_outlined, '/roles'),
      if (can(Permissions.settingsRead)) _Item('Settings', 'Organization profile', Icons.settings_outlined, '/settings'),
    ];

    return AdminScaffold(
      title: 'More',
      subtitle: user?.role.name,
      actions: [
        IconButton(
          onPressed: () => ref.read(authNotifierProvider.notifier).logout(),
          icon: const Icon(Icons.logout_rounded),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AdminCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: AppColors.brandRed.withValues(alpha: 0.12),
                child: Text(
                  (user?.name.isNotEmpty == true ? user!.name[0] : 'A').toUpperCase(),
                  style: const TextStyle(color: AppColors.brandRed, fontWeight: FontWeight.w800),
                ),
              ),
              title: Text(user?.name ?? 'Administrator', style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(user?.email ?? ''),
            ),
          ),
          const SizedBox(height: 16),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AdminListTile(
                leading: Icon(item.icon, color: AppColors.brandRed),
                title: item.title,
                subtitle: item.subtitle,
                onTap: () => context.push(item.route),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Item {
  const _Item(this.title, this.subtitle, this.icon, this.route);
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
}

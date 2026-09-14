import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/permissions.dart';
import '../theme/app_colors.dart';
import 'brand_logo.dart';
import '../../features/auth/presentation/providers/auth_notifier.dart';

class _NavItem {
  const _NavItem({
    required this.label,
    required this.route,
    required this.icon,
    required this.permission,
  });

  final String label;
  final String route;
  final IconData icon;
  final String permission;
}

class _NavGroup {
  const _NavGroup({required this.label, required this.items, this.superAdminOnly = false});

  final String label;
  final List<_NavItem> items;
  final bool superAdminOnly;
}

const _nav = [
  _NavGroup(
    label: 'Dashboard',
    items: [
      _NavItem(label: 'Dashboard', route: '/dashboard', icon: Icons.dashboard_outlined, permission: Permissions.dashboardRead),
    ],
  ),
  _NavGroup(
    label: 'Management',
    items: [
      _NavItem(label: 'Stores', route: '/stores', icon: Icons.storefront_outlined, permission: Permissions.storesRead),
      _NavItem(label: 'Sales Income', route: '/sales', icon: Icons.receipt_long_outlined, permission: Permissions.salesRead),
      _NavItem(label: 'Expenses', route: '/expenses', icon: Icons.account_balance_wallet_outlined, permission: Permissions.expensesRead),
      _NavItem(label: 'Expense Category', route: '/expense-categories', icon: Icons.sell_outlined, permission: Permissions.expensesRead),
      _NavItem(label: 'Payment Method', route: '/payment-methods', icon: Icons.credit_card_outlined, permission: Permissions.expensesRead),
    ],
  ),
  _NavGroup(
    label: 'Finance',
    items: [
      _NavItem(label: 'Profit & Loss', route: '/profit-loss', icon: Icons.pie_chart_outline, permission: Permissions.reportsRead),
      _NavItem(label: 'Reports', route: '/reports', icon: Icons.bar_chart_rounded, permission: Permissions.reportsRead),
      _NavItem(label: 'Tender Types', route: '/tender-types', icon: Icons.payments_outlined, permission: Permissions.reportsRead),
    ],
  ),
  _NavGroup(
    label: 'Administration',
    superAdminOnly: true,
    items: [
      _NavItem(label: 'Users', route: '/users', icon: Icons.people_outline, permission: Permissions.usersRead),
      _NavItem(label: 'Roles & Permissions', route: '/roles', icon: Icons.shield_outlined, permission: Permissions.rolesRead),
    ],
  ),
  _NavGroup(
    label: 'System',
    items: [
      _NavItem(label: 'Settings', route: '/settings', icon: Icons.settings_outlined, permission: Permissions.settingsRead),
    ],
  ),
];

class AdminDrawer extends ConsumerWidget {
  const AdminDrawer({super.key});

  bool _isActive(String location, String route) {
    if (location == route) return true;
    return location.startsWith('$route/');
  }

  Future<void> _open(BuildContext context, String route) async {
    final router = GoRouter.of(context);
    Navigator.of(context).pop();
    router.go(route);
  }

  List<Widget> _groups(
    bool isSuperAdmin,
    bool Function(String permission) can,
    String location,
    BuildContext context,
  ) {
    final widgets = <Widget>[];
    for (final group in _nav) {
      if (group.superAdminOnly && !isSuperAdmin) continue;
      final items = group.items.where((item) => can(item.permission)).toList();
      if (items.isEmpty) continue;
      widgets.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
          child: Text(
            group.label.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.35),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
            ),
          ),
        ),
      );
      for (final item in items) {
        final active = _isActive(location, item.route);
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Material(
              color: active ? AppColors.brandRed : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => _open(context, item.route),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                  child: Row(
                    children: [
                      Icon(item.icon, size: 18, color: active ? Colors.white : Colors.white70),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.label,
                          style: TextStyle(
                            color: active ? Colors.white : Colors.white70,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
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
    return widgets;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final can = ref.watch(permissionCheckerProvider);
    final location = GoRouterState.of(context).uri.path;

    return Drawer(
      backgroundColor: AppColors.ink,
      width: 280,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Row(
                children: [
                  BrandLogo(
                    size: 48,
                    radius: 16,
                    border: Border.all(color: Colors.white24, width: 2),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "LOUISIANA'S",
                        style: TextStyle(
                          color: AppColors.brandYellow,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.6,
                        ),
                      ),
                      Text(
                        'Hot Chicken',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                children: _groups(user?.isSuperAdmin == true, can, location, context),
              ),
            ),
            Container(
              decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08)))),
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.brandRed,
                    child: Text(
                      (user?.name.isNotEmpty == true ? user!.name[0] : 'A').toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Administrator',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                        Text(
                          user?.role.name ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppColors.brandYellow, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Sign out',
                    onPressed: () {
                      Navigator.of(context).pop();
                      ref.read(authNotifierProvider.notifier).logout();
                    },
                    icon: const Icon(Icons.logout_rounded, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

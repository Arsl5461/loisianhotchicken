import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../stores/domain/entities/store.dart';
import '../../../stores/presentation/providers/store_context_provider.dart';

class StoreFilterButton extends ConsumerWidget {
  const StoreFilterButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedStoreIdProvider);
    final stores = ref.watch(storesListProvider);
    return IconButton(
      tooltip: 'Filter by store',
      onPressed: () => _open(context, ref, stores.valueOrNull, selectedId),
      icon: const Icon(Icons.storefront_outlined),
    );
  }

  Future<void> _open(BuildContext context, WidgetRef ref, StoreListResult? data, String? selectedId) async {
    final items = data?.items ?? [];
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              const ListTile(title: Text('Filter by store', style: TextStyle(fontWeight: FontWeight.w700))),
              ListTile(
                title: const Text('All stores'),
                leading: Icon(selectedId == null ? Icons.radio_button_checked : Icons.radio_button_off, color: AppColors.brandRed),
                onTap: () {
                  selectStore(ref, null);
                  Navigator.pop(context);
                },
              ),
              ...items.map(
                (store) => ListTile(
                  title: Text(store.name),
                  subtitle: Text(store.storeCode),
                  leading: Icon(selectedId == store.id ? Icons.radio_button_checked : Icons.radio_button_off, color: AppColors.brandRed),
                  onTap: () {
                    selectStore(ref, store.id);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AdminShell extends StatelessWidget {
  const AdminShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long_rounded), label: 'Sales'),
          NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), selectedIcon: Icon(Icons.account_balance_wallet_rounded), label: 'Expenses'),
          NavigationDestination(icon: Icon(Icons.more_horiz_rounded), selectedIcon: Icon(Icons.more_horiz_rounded), label: 'More'),
        ],
      ),
    );
  }
}

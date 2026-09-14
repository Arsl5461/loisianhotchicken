import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/admin_widgets.dart';
import '../../domain/entities/finance_records.dart';
import '../providers/finance_providers.dart';

class ExpenseCategoriesScreen extends ConsumerWidget {
  const ExpenseCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(expenseCategoriesProvider);
    return AdminScaffold(
      title: 'Expense categories',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(context, ref, null),
        backgroundColor: AppColors.brandRed,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: async.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(message: error.toString(), onRetry: () => ref.invalidate(expenseCategoriesProvider)),
        data: (page) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: page.items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final item = page.items[index];
            return AdminListTile(
              title: item.name,
              subtitle: item.isActive ? 'Active' : 'Inactive',
              trailing: IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => _edit(context, ref, item)),
            );
          },
        ),
      ),
    );
  }

  Future<void> _edit(BuildContext context, WidgetRef ref, NamedRecord? item) async {
    final controller = TextEditingController(text: item?.name ?? '');
    var active = item?.isActive ?? true;
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(item == null ? 'Add category' : 'Edit category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: controller, decoration: const InputDecoration(labelText: 'Name')),
              SwitchListTile(value: active, onChanged: (value) => setState(() => active = value), title: const Text('Active')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save')),
          ],
        ),
      ),
    );
    if (saved != true) return;
    try {
      if (item == null) {
        await ref.read(catalogRepositoryProvider).createCategory(controller.text.trim(), isActive: active);
      } else {
        await ref.read(catalogRepositoryProvider).updateCategory(item.id, name: controller.text.trim(), isActive: active);
      }
      ref.invalidate(expenseCategoriesProvider);
    } catch (error) {
      if (context.mounted) showAdminSnackBar(context, error.toString(), isError: true);
    }
  }
}

class PaymentMethodsScreen extends ConsumerWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(allPaymentMethodsProvider);
    return AdminScaffold(
      title: 'Payment methods',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(context, ref, null),
        backgroundColor: AppColors.brandRed,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: async.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(message: error.toString(), onRetry: () => ref.invalidate(allPaymentMethodsProvider)),
        data: (page) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: page.items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final item = page.items[index];
            return AdminListTile(
              title: item.name,
              subtitle: item.isActive ? 'Active' : 'Inactive',
              trailing: IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => _edit(context, ref, item)),
            );
          },
        ),
      ),
    );
  }

  Future<void> _edit(BuildContext context, WidgetRef ref, NamedRecord? item) async {
    final controller = TextEditingController(text: item?.name ?? '');
    var active = item?.isActive ?? true;
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(item == null ? 'Add payment method' : 'Edit payment method'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: controller, decoration: const InputDecoration(labelText: 'Name')),
              SwitchListTile(value: active, onChanged: (value) => setState(() => active = value), title: const Text('Active')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save')),
          ],
        ),
      ),
    );
    if (saved != true) return;
    try {
      if (item == null) {
        await ref.read(catalogRepositoryProvider).createPaymentMethod(controller.text.trim(), isActive: active);
      } else {
        await ref.read(catalogRepositoryProvider).updatePaymentMethod(item.id, name: controller.text.trim(), isActive: active);
      }
      ref.invalidate(allPaymentMethodsProvider);
      ref.invalidate(paymentMethodsProvider);
    } catch (error) {
      if (context.mounted) showAdminSnackBar(context, error.toString(), isError: true);
    }
  }
}

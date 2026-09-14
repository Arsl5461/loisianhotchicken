import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/permissions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/admin_widgets.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../../dashboard/presentation/widgets/admin_shell.dart';
import '../../../stores/presentation/providers/store_context_provider.dart';
import '../../domain/entities/finance_records.dart';
import '../providers/finance_providers.dart';

class SalesScreen extends ConsumerWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canCreate = ref.watch(permissionCheckerProvider)(Permissions.salesCreate);
    final canDelete = ref.watch(permissionCheckerProvider)(Permissions.salesDelete);
    final async = ref.watch(salesListProvider);
    return AdminScaffold(
      title: 'Sales Income',
      subtitle: 'Record and review store-level sales.',
      actions: const [StoreFilterButton()],
      floatingActionButton: canCreate
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/sales/new'),
              backgroundColor: AppColors.brandRed,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Add sale'),
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search customer or reference'),
              onChanged: (value) => ref.read(salesQueryProvider.notifier).state = ListQuery(search: value),
            ),
          ),
          Expanded(
            child: async.when(
              loading: () => const LoadingView(),
              error: (error, _) => ErrorView(message: error.toString(), onRetry: () => ref.invalidate(salesListProvider)),
              data: (page) {
                if (page.items.isEmpty) {
                  return EmptyStateView(
                    title: 'No sales yet',
                    message: 'Record a sale to see it here.',
                    actionLabel: canCreate ? 'Add sale' : null,
                    onAction: canCreate ? () => context.push('/sales/new') : null,
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(salesListProvider),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: page.items.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final sale = page.items[index];
                      return AdminListTile(
                        title: money(sale.totalAmount),
                        subtitle: '${sale.customerName} · ${sale.storeName} · ${sale.paymentMethod}\n${formatDate(sale.saleDate)}',
                        trailing: canDelete
                            ? IconButton(
                                icon: const Icon(Icons.delete_outline, color: AppColors.danger),
                                onPressed: () => _delete(context, ref, sale),
                              )
                            : null,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, Sale sale) async {
    final ok = await showConfirmDialog(context, title: 'Delete sale', message: 'Remove this ${money(sale.totalAmount)} sale?');
    if (!ok) return;
    try {
      await ref.read(salesRepositoryProvider).delete(sale.id);
      ref.invalidate(salesListProvider);
      if (context.mounted) showAdminSnackBar(context, 'Sale deleted');
    } catch (error) {
      if (context.mounted) showAdminSnackBar(context, error.toString(), isError: true);
    }
  }
}

class CreateSaleScreen extends ConsumerStatefulWidget {
  const CreateSaleScreen({super.key});

  @override
  ConsumerState<CreateSaleScreen> createState() => _CreateSaleScreenState();
}

class _CreateSaleScreenState extends ConsumerState<CreateSaleScreen> {
  final _amount = TextEditingController();
  final _customer = TextEditingController(text: 'Walk-in Guest');
  String? _storeId;
  String? _method;
  bool _saving = false;

  @override
  void dispose() {
    _amount.dispose();
    _customer.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final stores = ref.read(storesListProvider).valueOrNull?.items ?? [];
    final storeId = _storeId ?? ref.read(selectedStoreIdProvider) ?? (stores.isNotEmpty ? stores.first.id : null);
    final amount = double.tryParse(_amount.text);
    if (storeId == null || amount == null || amount <= 0 || _method == null) {
      showAdminSnackBar(context, 'Fill in store, amount, and payment method', isError: true);
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(salesRepositoryProvider).create(
            CreateSaleInput(
              storeId: storeId,
              totalAmount: amount,
              paymentMethod: _method!,
              customerName: _customer.text.trim(),
            ),
          );
      ref.invalidate(salesListProvider);
      if (mounted) {
        showAdminSnackBar(context, 'Sale recorded');
        context.pop();
      }
    } catch (error) {
      if (mounted) showAdminSnackBar(context, error.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final stores = ref.watch(storesListProvider).valueOrNull?.items ?? [];
    final methods = ref.watch(paymentMethodsProvider).valueOrNull?.items ?? [];
    return AdminScaffold(
      title: 'Add sale',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            initialValue: _storeId ?? ref.watch(selectedStoreIdProvider) ?? (stores.isNotEmpty ? stores.first.id : null),
            items: stores.map((store) => DropdownMenuItem(value: store.id, child: Text(store.name))).toList(),
            onChanged: (value) => setState(() => _storeId = value),
            decoration: const InputDecoration(labelText: 'Store'),
          ),
          const SizedBox(height: 16),
          AdminTextField(label: 'Customer', controller: _customer),
          const SizedBox(height: 16),
          AdminTextField(label: 'Amount', controller: _amount, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _method,
            items: methods.map((method) => DropdownMenuItem(value: method.name, child: Text(method.name))).toList(),
            onChanged: (value) => setState(() => _method = value),
            decoration: const InputDecoration(labelText: 'Payment method'),
          ),
          const SizedBox(height: 24),
          AdminButton(label: 'Save sale', loading: _saving, onPressed: _save),
        ],
      ),
    );
  }
}

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/permissions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/admin_widgets.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../../dashboard/presentation/widgets/admin_shell.dart';
import '../../../stores/presentation/providers/store_context_provider.dart';
import '../../domain/entities/finance_records.dart';
import '../providers/finance_providers.dart';

class ExpensesScreen extends ConsumerWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canCreate = ref.watch(permissionCheckerProvider)(Permissions.expensesCreate);
    final canDelete = ref.watch(permissionCheckerProvider)(Permissions.expensesDelete);
    final async = ref.watch(expensesListProvider);
    return AdminScaffold(
      title: 'Expenses',
      subtitle: 'Track store operating costs.',
      actions: const [StoreFilterButton()],
      floatingActionButton: canCreate
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/expenses/new'),
              backgroundColor: AppColors.brandRed,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Add expense'),
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search expenses'),
              onChanged: (value) => ref.read(expensesQueryProvider.notifier).state = ListQuery(search: value),
            ),
          ),
          Expanded(
            child: async.when(
              loading: () => const LoadingView(),
              error: (error, _) => ErrorView(message: error.toString(), onRetry: () => ref.invalidate(expensesListProvider)),
              data: (page) {
                if (page.items.isEmpty) {
                  return const EmptyStateView(title: 'No expenses', message: 'Record an expense to see it here.');
                }
                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(expensesListProvider),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: page.items.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final expense = page.items[index];
                      return AdminListTile(
                        title: expense.title,
                        subtitle: '${expense.category} · ${expense.storeName}\n${formatDate(expense.expenseDate)}',
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(money(expense.amount), style: const TextStyle(fontWeight: FontWeight.w700)),
                            if (canDelete)
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: AppColors.danger),
                                onPressed: () => _delete(context, ref, expense),
                              ),
                          ],
                        ),
                        onTap: expense.receiptUrl == null
                            ? null
                            : () => showDialog<void>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Receipt'),
                                    content: Text(AppConfig.resolveUrl(expense.receiptUrl)),
                                    actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
                                  ),
                                ),
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

  Future<void> _delete(BuildContext context, WidgetRef ref, Expense expense) async {
    final ok = await showConfirmDialog(context, title: 'Delete expense', message: 'Remove ${expense.title}?');
    if (!ok) return;
    try {
      await ref.read(expensesRepositoryProvider).delete(expense.id);
      ref.invalidate(expensesListProvider);
      if (context.mounted) showAdminSnackBar(context, 'Expense deleted');
    } catch (error) {
      if (context.mounted) showAdminSnackBar(context, error.toString(), isError: true);
    }
  }
}

class CreateExpenseScreen extends ConsumerStatefulWidget {
  const CreateExpenseScreen({super.key});

  @override
  ConsumerState<CreateExpenseScreen> createState() => _CreateExpenseScreenState();
}

class _CreateExpenseScreenState extends ConsumerState<CreateExpenseScreen> {
  final _title = TextEditingController();
  final _amount = TextEditingController();
  String? _storeId;
  String? _category;
  String? _method;
  DateTime _date = DateTime.now();
  String? _receiptPath;
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _pickReceipt() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: const ['jpg', 'jpeg', 'png', 'webp', 'pdf']);
    if (result?.files.single.path != null) {
      setState(() => _receiptPath = result!.files.single.path);
    }
  }

  Future<void> _save() async {
    final stores = ref.read(storesListProvider).valueOrNull?.items ?? [];
    final storeId = _storeId ?? ref.read(selectedStoreIdProvider) ?? (stores.isNotEmpty ? stores.first.id : null);
    final amount = double.tryParse(_amount.text);
    if (storeId == null || _title.text.trim().length < 2 || amount == null || _category == null || _method == null) {
      showAdminSnackBar(context, 'Please complete the required fields', isError: true);
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(expensesRepositoryProvider).create(
            CreateExpenseInput(
              storeId: storeId,
              title: _title.text.trim(),
              category: _category!,
              amount: amount,
              paymentMethod: _method!,
              expenseDate: toIsoDate(_date),
              receiptPath: _receiptPath,
            ),
          );
      ref.invalidate(expensesListProvider);
      if (mounted) {
        showAdminSnackBar(context, 'Expense recorded');
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
    final categories = ref.watch(expenseCategoriesProvider).valueOrNull?.items ?? [];
    final methods = ref.watch(paymentMethodsProvider).valueOrNull?.items ?? [];
    return AdminScaffold(
      title: 'Add expense',
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
          AdminTextField(label: 'Title', controller: _title),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _category,
            items: categories.map((item) => DropdownMenuItem(value: item.name, child: Text(item.name))).toList(),
            onChanged: (value) => setState(() => _category = value),
            decoration: const InputDecoration(labelText: 'Category'),
          ),
          const SizedBox(height: 16),
          AdminTextField(label: 'Amount', controller: _amount, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _method,
            items: methods.map((item) => DropdownMenuItem(value: item.name, child: Text(item.name))).toList(),
            onChanged: (value) => setState(() => _method = value),
            decoration: const InputDecoration(labelText: 'Payment method'),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Expense date'),
            subtitle: Text(toIsoDate(_date)),
            trailing: const Icon(Icons.calendar_today_outlined),
            onTap: () async {
              final next = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2020), lastDate: DateTime.now().add(const Duration(days: 1)));
              if (next != null) setState(() => _date = next);
            },
          ),
          OutlinedButton.icon(
            onPressed: _pickReceipt,
            icon: const Icon(Icons.attach_file),
            label: Text(_receiptPath == null ? 'Attach receipt' : 'Receipt selected'),
          ),
          const SizedBox(height: 24),
          AdminButton(label: 'Save expense', loading: _saving, onPressed: _save),
        ],
      ),
    );
  }
}

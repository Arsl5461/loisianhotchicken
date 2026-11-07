import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/permissions.dart';
import '../../../../core/constants/timezone.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/admin_widgets.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../../dashboard/presentation/widgets/admin_shell.dart';
import '../../../sales/presentation/providers/finance_providers.dart';
import '../../../stores/presentation/providers/store_context_provider.dart';
import '../../data/borrowings_repository.dart';
import '../providers/borrowings_providers.dart';

class BorrowingsScreen extends ConsumerWidget {
  const BorrowingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canCreate = ref.watch(permissionCheckerProvider)(Permissions.expensesCreate);
    final canUpdate = ref.watch(permissionCheckerProvider)(Permissions.expensesUpdate);
    final canDelete = ref.watch(permissionCheckerProvider)(Permissions.expensesDelete);
    final async = ref.watch(borrowingsListProvider);

    return AdminScaffold(
      title: 'Money borrowed',
      subtitle: 'Track borrowed money until every balance is paid off.',
      actions: const [StoreFilterButton()],
      floatingActionButton: canCreate
          ? FloatingActionButton.extended(
              onPressed: () => _create(context, ref),
              backgroundColor: AppColors.brandRed,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Add borrowed'),
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search lender or note'),
              onChanged: (value) => ref.read(borrowingsQueryProvider.notifier).state = ListQuery(search: value),
            ),
          ),
          Expanded(
            child: async.when(
              loading: () => const LoadingView(),
              error: (error, _) => ErrorView(message: error.toString(), onRetry: () => ref.invalidate(borrowingsListProvider)),
              data: (page) {
                final stillOwed = page.items.fold<double>(0, (sum, item) => sum + item.amountOwed);
                if (page.items.isEmpty) {
                  return const EmptyStateView(
                    title: 'No borrowed money',
                    message: 'Record a loan to track what is still owed.',
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(borrowingsListProvider),
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (stillOwed > 0)
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7ED),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFFDBA74)),
                          ),
                          child: Text(
                            '${money(stillOwed)} is still owed. The final report stays open until this is paid off.',
                            style: const TextStyle(color: Color(0xFF9A3412), height: 1.35),
                          ),
                        ),
                      ...page.items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: AdminListTile(
                            title: item.lender,
                            subtitle:
                                '${item.storeName} · ${item.isOpen ? 'Open' : 'Paid off'}\nBorrowed ${money(item.amount)} · Paid ${money(item.amountPaid)} · Owed ${money(item.amountOwed)}\n${formatDate(item.borrowedDate)}',
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (canUpdate && item.isOpen)
                                  IconButton(
                                    tooltip: 'Repay',
                                    icon: const Icon(Icons.payments_outlined),
                                    onPressed: () => _repay(context, ref, item),
                                  ),
                                if (canDelete)
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: AppColors.danger),
                                    onPressed: () => _delete(context, ref, item),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final stores = ref.read(storesListProvider).valueOrNull?.items ?? [];
    final lender = TextEditingController();
    final amount = TextEditingController();
    final note = TextEditingController();
    var storeId = ref.read(selectedStoreIdProvider) ?? (stores.isNotEmpty ? stores.first.id : null);
    var borrowedDate = AppTimezone.todayYmd();

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
          child: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Add borrowed money', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: storeId,
                      items: stores.map((store) => DropdownMenuItem(value: store.id, child: Text(store.name))).toList(),
                      onChanged: (value) => setState(() => storeId = value),
                      decoration: const InputDecoration(labelText: 'Store'),
                    ),
                    const SizedBox(height: 12),
                    TextField(controller: lender, decoration: const InputDecoration(labelText: 'Borrowed from')),
                    const SizedBox(height: 12),
                    TextField(
                      controller: amount,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Amount'),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Borrowed date'),
                      subtitle: Text(borrowedDate),
                      trailing: const Icon(Icons.calendar_today_outlined),
                      onTap: () async {
                        final now = AppTimezone.now();
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(now.year, now.month, now.day),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now().add(const Duration(days: 1)),
                        );
                        if (picked != null) setState(() => borrowedDate = AppTimezone.toYmd(picked));
                      },
                    ),
                    TextField(controller: note, decoration: const InputDecoration(labelText: 'Note (optional)')),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    if (saved != true) return;
    final parsed = double.tryParse(amount.text);
    if (storeId == null || lender.text.trim().length < 2 || parsed == null || parsed <= 0) {
      if (context.mounted) showAdminSnackBar(context, 'Store, lender, and amount are required', isError: true);
      return;
    }
    try {
      await ref.read(borrowingsRepositoryProvider).create(
            CreateBorrowingInput(
              storeId: storeId!,
              lender: lender.text.trim(),
              amount: parsed,
              borrowedDate: borrowedDate,
              note: note.text.trim().isEmpty ? null : note.text.trim(),
            ),
          );
      ref.invalidate(borrowingsListProvider);
      if (context.mounted) showAdminSnackBar(context, 'Borrowed money recorded');
    } catch (error) {
      if (context.mounted) showAdminSnackBar(context, error.toString(), isError: true);
    }
  }

  Future<void> _repay(BuildContext context, WidgetRef ref, Borrowing item) async {
    final amount = TextEditingController(text: item.amountOwed.toStringAsFixed(2));
    final note = TextEditingController();
    var paidDate = AppTimezone.todayYmd();
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
          child: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Repay ${item.lender}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Text('Still owed ${money(item.amountOwed)}', style: const TextStyle(color: AppColors.muted)),
                    const SizedBox(height: 16),
                    TextField(
                      controller: amount,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Repayment amount'),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Paid date'),
                      subtitle: Text(paidDate),
                      trailing: const Icon(Icons.calendar_today_outlined),
                      onTap: () async {
                        final now = AppTimezone.now();
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(now.year, now.month, now.day),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now().add(const Duration(days: 1)),
                        );
                        if (picked != null) setState(() => paidDate = AppTimezone.toYmd(picked));
                      },
                    ),
                    TextField(controller: note, decoration: const InputDecoration(labelText: 'Note (optional)')),
                    const SizedBox(height: 16),
                    FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save repayment')),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
    if (saved != true) return;
    final parsed = double.tryParse(amount.text);
    if (parsed == null || parsed <= 0) {
      if (context.mounted) showAdminSnackBar(context, 'Enter a valid repayment amount', isError: true);
      return;
    }
    try {
      await ref.read(borrowingsRepositoryProvider).repay(
            item.id,
            RepayBorrowingInput(
              amount: parsed,
              paidDate: paidDate,
              note: note.text.trim().isEmpty ? null : note.text.trim(),
            ),
          );
      ref.invalidate(borrowingsListProvider);
      if (context.mounted) showAdminSnackBar(context, 'Repayment recorded');
    } catch (error) {
      if (context.mounted) showAdminSnackBar(context, error.toString(), isError: true);
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, Borrowing item) async {
    final ok = await showConfirmDialog(context, title: 'Delete borrowing', message: 'Remove ${item.lender}?');
    if (!ok) return;
    try {
      await ref.read(borrowingsRepositoryProvider).delete(item.id);
      ref.invalidate(borrowingsListProvider);
      if (context.mounted) showAdminSnackBar(context, 'Borrowing deleted');
    } catch (error) {
      if (context.mounted) showAdminSnackBar(context, error.toString(), isError: true);
    }
  }
}

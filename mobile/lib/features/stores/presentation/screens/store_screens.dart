import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/permissions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/admin_widgets.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../providers/store_context_provider.dart';

class StoresScreen extends ConsumerWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canCreate = ref.watch(permissionCheckerProvider)(Permissions.storesCreate);
    final async = ref.watch(storesListProvider);
    return AdminScaffold(
      title: 'Stores',
      subtitle: 'All locations in this organization.',
      floatingActionButton: canCreate
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/stores/new'),
              backgroundColor: AppColors.brandRed,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Add store'),
            )
          : null,
      body: async.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(message: error.toString(), onRetry: () => ref.invalidate(storesListProvider)),
        data: (result) {
          if (result.items.isEmpty) {
            return const EmptyStateView(title: 'No stores', message: 'Create a store to get started.');
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(storesListProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: result.items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final store = result.items[index];
                return AdminListTile(
                  title: store.name,
                  subtitle: '${store.storeCode} · ${store.city ?? ''} ${store.state ?? ''}\n${store.status}',
                  onTap: () => context.push('/stores/${store.id}'),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class StoreDetailsScreen extends ConsumerWidget {
  const StoreDetailsScreen({super.key, required this.storeId});
  final String storeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canUpdate = ref.watch(permissionCheckerProvider)(Permissions.storesUpdate);
    final canReadUsers = ref.watch(currentUserProvider)?.isSuperAdmin == true ||
        ref.watch(permissionCheckerProvider)(Permissions.usersRead);
    return FutureBuilder(
      future: ref.read(storesRepositoryProvider).getById(storeId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return AdminScaffold(title: 'Store', body: ErrorView(message: snapshot.error.toString()));
        }
        if (!snapshot.hasData) {
          return const AdminScaffold(title: 'Store', body: LoadingView());
        }
        final store = snapshot.data!;
        return AdminScaffold(
          title: store.name,
          subtitle: store.storeCode,
          actions: [
            if (canUpdate)
              IconButton(onPressed: () => context.push('/stores/$storeId/edit'), icon: const Icon(Icons.edit_outlined)),
          ],
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AdminCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(store.status, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.success)),
                    const SizedBox(height: 8),
                    Text([store.address, store.city, store.state, store.country].where((item) => item != null && item.isNotEmpty).join(', ')),
                    const SizedBox(height: 8),
                    Text(store.email ?? 'No email'),
                    Text(store.phone ?? 'No phone'),
                    Text('Manager: ${store.managerName ?? 'Unassigned'}'),
                  ],
                ),
              ),
              if (canReadUsers)
                FutureBuilder(
                  future: ref.read(storesRepositoryProvider).usersForStore(storeId),
                  builder: (context, usersSnap) {
                    final users = usersSnap.data ?? [];
                    return Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: AdminCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Assigned users', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                            const SizedBox(height: 8),
                            if (users.isEmpty) const Text('No users assigned.', style: TextStyle(color: AppColors.muted)),
                            ...users.map((user) => ListTile(contentPadding: EdgeInsets.zero, title: Text(user.name), subtitle: Text(user.email))),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class StoreFormScreen extends ConsumerStatefulWidget {
  const StoreFormScreen({super.key, this.storeId});
  final String? storeId;

  @override
  ConsumerState<StoreFormScreen> createState() => _StoreFormScreenState();
}

class _StoreFormScreenState extends ConsumerState<StoreFormScreen> {
  final _name = TextEditingController();
  final _code = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  String _status = 'ACTIVE';
  bool _loading = false;
  bool _saving = false;

  bool get _editing => widget.storeId != null;

  @override
  void initState() {
    super.initState();
    if (_editing) _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final store = await ref.read(storesRepositoryProvider).getById(widget.storeId!);
      _name.text = store.name;
      _code.text = store.storeCode;
      _email.text = store.email ?? '';
      _phone.text = store.phone ?? '';
      _address.text = store.address ?? '';
      _city.text = store.city ?? '';
      _state.text = store.state ?? '';
      _status = store.status;
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _code.dispose();
    _email.dispose();
    _phone.dispose();
    _address.dispose();
    _city.dispose();
    _state.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().length < 2 || _code.text.trim().length < 2) {
      showAdminSnackBar(context, 'Name and store code are required', isError: true);
      return;
    }
    final body = {
      'name': _name.text.trim(),
      'storeCode': _code.text.trim(),
      'email': _email.text.trim(),
      'phone': _phone.text.trim(),
      'address': _address.text.trim(),
      'city': _city.text.trim(),
      'state': _state.text.trim(),
      'status': _status,
    };
    setState(() => _saving = true);
    try {
      if (_editing) {
        await ref.read(storesRepositoryProvider).update(widget.storeId!, body);
      } else {
        await ref.read(storesRepositoryProvider).create(body);
      }
      ref.invalidate(storesListProvider);
      if (mounted) {
        showAdminSnackBar(context, _editing ? 'Store updated' : 'Store created');
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
    return AdminScaffold(
      title: _editing ? 'Edit store' : 'Add store',
      body: _loading
          ? const LoadingView()
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                AdminTextField(label: 'Name', controller: _name),
                const SizedBox(height: 16),
                AdminTextField(label: 'Store code', controller: _code),
                const SizedBox(height: 16),
                AdminTextField(label: 'Email', controller: _email, keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 16),
                AdminTextField(label: 'Phone', controller: _phone),
                const SizedBox(height: 16),
                AdminTextField(label: 'Address', controller: _address),
                const SizedBox(height: 16),
                AdminTextField(label: 'City', controller: _city),
                const SizedBox(height: 16),
                AdminTextField(label: 'State', controller: _state),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _status,
                  items: const [
                    DropdownMenuItem(value: 'ACTIVE', child: Text('Active')),
                    DropdownMenuItem(value: 'INACTIVE', child: Text('Inactive')),
                    DropdownMenuItem(value: 'TEMPORARILY_CLOSED', child: Text('Temporarily closed')),
                  ],
                  onChanged: (value) => setState(() => _status = value ?? 'ACTIVE'),
                  decoration: const InputDecoration(labelText: 'Status'),
                ),
                const SizedBox(height: 24),
                AdminButton(label: 'Save store', loading: _saving, onPressed: _save),
              ],
            ),
    );
  }
}

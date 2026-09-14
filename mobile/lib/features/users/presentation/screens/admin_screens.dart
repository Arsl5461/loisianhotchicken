import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/admin_widgets.dart';
import '../../../../core/widgets/brand_logo.dart';
import '../../../stores/presentation/providers/store_context_provider.dart';
import '../../data/admin_directory_repository.dart';
import '../providers/admin_directory_providers.dart';

class UsersScreen extends ConsumerWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(usersListProvider);
    final status = ref.watch(usersStatusProvider);
    return AdminScaffold(
      title: 'Users',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(context, ref, null),
        backgroundColor: AppColors.brandRed,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add user'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Wrap(
              spacing: 8,
              children: ['ALL', 'ACTIVE', 'INACTIVE'].map((item) {
                return ChoiceChip(
                  label: Text(item),
                  selected: status == item,
                  onSelected: (_) => ref.read(usersStatusProvider.notifier).state = item,
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: async.when(
              loading: () => const LoadingView(),
              error: (error, _) => ErrorView(message: error.toString(), onRetry: () => ref.invalidate(usersListProvider)),
              data: (page) => ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: page.items.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final user = page.items[index];
                  return AdminListTile(
                    title: user.name,
                    subtitle: '${user.email}\n${user.roleName ?? 'No role'} · ${user.storeNames.join(', ')}',
                    trailing: IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => _edit(context, ref, user)),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _edit(BuildContext context, WidgetRef ref, AdminUser? user) async {
    final name = TextEditingController(text: user?.name ?? '');
    final email = TextEditingController(text: user?.email ?? '');
    final password = TextEditingController();
    var roleId = user?.roleId;
    var storeIds = [...?user?.storeIds];
    var active = user?.isActive ?? true;
    final roles = await ref.read(adminDirectoryRepositoryProvider).roles();
    final stores = ref.read(storesListProvider).valueOrNull?.items ?? [];
    if (!context.mounted) return;
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
                    Text(user == null ? 'Add user' : 'Edit user', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 16),
                    TextField(controller: name, decoration: const InputDecoration(labelText: 'Name')),
                    const SizedBox(height: 12),
                    TextField(controller: email, decoration: const InputDecoration(labelText: 'Email')),
                    if (user == null) ...[
                      const SizedBox(height: 12),
                      TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
                    ],
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: roleId,
                      items: roles.map((role) => DropdownMenuItem(value: role.id, child: Text(role.name))).toList(),
                      onChanged: (value) => setState(() => roleId = value),
                      decoration: const InputDecoration(labelText: 'Role'),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: stores.map((store) {
                        final selected = storeIds.contains(store.id);
                        return FilterChip(
                          label: Text(store.name),
                          selected: selected,
                          onSelected: (value) => setState(() {
                            if (value) {
                              storeIds.add(store.id);
                            } else {
                              storeIds.remove(store.id);
                            }
                          }),
                        );
                      }).toList(),
                    ),
                    SwitchListTile(value: active, onChanged: (value) => setState(() => active = value), title: const Text('Active')),
                    FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save')),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
    if (saved != true) return;
    try {
      if (user == null) {
        await ref.read(adminDirectoryRepositoryProvider).createUser({
          'name': name.text.trim(),
          'email': email.text.trim(),
          'password': password.text,
          'roleId': roleId,
          'stores': storeIds,
          'isActive': active,
        });
      } else {
        await ref.read(adminDirectoryRepositoryProvider).updateUser(user.id, {
          'name': name.text.trim(),
          'email': email.text.trim(),
          'roleId': roleId,
          'stores': storeIds,
          'isActive': active,
        });
      }
      ref.invalidate(usersListProvider);
      if (context.mounted) showAdminSnackBar(context, 'User saved');
    } catch (error) {
      if (context.mounted) showAdminSnackBar(context, error.toString(), isError: true);
    }
  }
}

class RolesScreen extends ConsumerWidget {
  const RolesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roles = ref.watch(rolesListProvider);
    final groups = ref.watch(permissionGroupsProvider);
    return AdminScaffold(
      title: 'Roles & permissions',
      body: roles.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(message: error.toString(), onRetry: () => ref.invalidate(rolesListProvider)),
        data: (roleRows) {
          final catalog = groups.valueOrNull ?? [];
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: roleRows.length,
            itemBuilder: (context, index) {
              final role = roleRows[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AdminCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(role.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                      if (role.description != null) Text(role.description!, style: const TextStyle(color: AppColors.muted)),
                      const SizedBox(height: 8),
                      ...catalog.map((group) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 4),
                              child: Text(group.label.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.muted)),
                            ),
                            ...group.permissions.map((permission) {
                              final checked = role.permissions.contains(permission);
                              return CheckboxListTile(
                                value: checked,
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                title: Text(permission),
                                onChanged: role.slug == 'SUPER_ADMIN'
                                    ? null
                                    : (value) async {
                                        final next = [...role.permissions];
                                        if (value == true) {
                                          next.add(permission);
                                        } else {
                                          next.remove(permission);
                                        }
                                        await ref.read(adminDirectoryRepositoryProvider).updateRolePermissions(role.id, next);
                                        ref.invalidate(rolesListProvider);
                                      },
                              );
                            }),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  bool _hydrated = false;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(organizationProvider);
    return AdminScaffold(
      title: 'Settings',
      body: async.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(message: error.toString(), onRetry: () => ref.invalidate(organizationProvider)),
        data: (org) {
          if (!_hydrated) {
            _name.text = org.name;
            _email.text = org.email ?? '';
            _phone.text = org.phone ?? '';
            _address.text = org.address ?? '';
            _hydrated = true;
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AdminCard(
                child: Row(
                  children: [
                    BrandLogo(size: 64, radius: 16, border: Border.all(color: const Color(0xFFE2E8F0))),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(org.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                          Text(org.email ?? 'No email on file', style: const TextStyle(color: AppColors.muted)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AdminTextField(label: 'Organization name', controller: _name),
              const SizedBox(height: 16),
              AdminTextField(label: 'Email', controller: _email),
              const SizedBox(height: 16),
              AdminTextField(label: 'Phone', controller: _phone),
              const SizedBox(height: 16),
              AdminTextField(label: 'Address', controller: _address, maxLines: 3),
              const SizedBox(height: 24),
              AdminButton(
                label: 'Save settings',
                loading: _saving,
                onPressed: () async {
                  setState(() => _saving = true);
                  try {
                    await ref.read(adminDirectoryRepositoryProvider).updateOrganization({
                      'name': _name.text.trim(),
                      'email': _email.text.trim(),
                      'phone': _phone.text.trim(),
                      'address': _address.text.trim(),
                    });
                    ref.invalidate(organizationProvider);
                    if (context.mounted) showAdminSnackBar(context, 'Settings saved');
                  } catch (error) {
                    if (context.mounted) showAdminSnackBar(context, error.toString(), isError: true);
                  } finally {
                    if (mounted) setState(() => _saving = false);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'features/auth/presentation/providers/auth_providers.dart';
import 'features/stores/presentation/providers/store_selection_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        selectedStoreIdProvider.overrideWith((ref) => prefs.getString('lhc_store_id')),
      ],
      child: const LhcAdminApp(),
    ),
  );
}

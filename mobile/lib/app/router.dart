import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../core/widgets/brand_logo.dart';
import '../features/auth/presentation/providers/auth_notifier.dart';
import '../features/auth/presentation/providers/auth_state.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../features/dashboard/presentation/screens/more_screen.dart';
import '../features/dashboard/presentation/widgets/admin_shell.dart';
import '../features/reports/presentation/screens/report_screens.dart';
import '../features/sales/presentation/screens/catalog_screens.dart';
import '../features/sales/presentation/screens/expense_screens.dart';
import '../features/sales/presentation/screens/sales_screens.dart';
import '../features/stores/presentation/screens/store_screens.dart';
import '../features/users/presentation/screens/admin_screens.dart';

class _RouterRefresh extends ChangeNotifier {
  void ping() => notifyListeners();
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefresh();
  ref.listen(authNotifierProvider, (previous, next) => refresh.ping());
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/dashboard',
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authNotifierProvider);
      final location = state.matchedLocation;
      final loggingIn = location == '/login';
      final splashing = location == '/splash';

      if (auth.status == AuthStatus.unknown) {
        return splashing ? null : '/splash';
      }
      if (auth.status == AuthStatus.unauthenticated) {
        return loggingIn ? null : '/login';
      }
      if (loggingIn || splashing) return '/dashboard';

      final user = auth.user;
      if ((location.startsWith('/users') || location.startsWith('/roles')) && user?.isSuperAdmin != true) {
        return '/more';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const _SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => AdminShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: '/dashboard', builder: (context, state) => const DashboardScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/sales', builder: (context, state) => const SalesScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/expenses', builder: (context, state) => const ExpensesScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/more', builder: (context, state) => const MoreScreen())]),
        ],
      ),
      GoRoute(path: '/sales/new', builder: (context, state) => const CreateSaleScreen()),
      GoRoute(path: '/expenses/new', builder: (context, state) => const CreateExpenseScreen()),
      GoRoute(path: '/stores', builder: (context, state) => const StoresScreen()),
      GoRoute(path: '/stores/new', builder: (context, state) => const StoreFormScreen()),
      GoRoute(
        path: '/stores/:id',
        builder: (context, state) => StoreDetailsScreen(storeId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/stores/:id/edit',
        builder: (context, state) => StoreFormScreen(storeId: state.pathParameters['id']),
      ),
      GoRoute(path: '/expense-categories', builder: (context, state) => const ExpenseCategoriesScreen()),
      GoRoute(path: '/payment-methods', builder: (context, state) => const PaymentMethodsScreen()),
      GoRoute(path: '/profit-loss', builder: (context, state) => const ProfitLossScreen()),
      GoRoute(path: '/reports', builder: (context, state) => const ReportsScreen()),
      GoRoute(path: '/tender-types', builder: (context, state) => const TenderTypesScreen()),
      GoRoute(path: '/users', builder: (context, state) => const UsersScreen()),
      GoRoute(path: '/roles', builder: (context, state) => const RolesScreen()),
      GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
    ],
  );
});

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandRed,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BrandLogo(size: 88, radius: 24, border: Border.all(color: Colors.white24, width: 2)),
            const SizedBox(height: 16),
            const Text(
              'Louisiana Hot Chicken',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}

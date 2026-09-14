class ApiPaths {
  const ApiPaths._();

  static const login = '/auth/login';
  static const logout = '/auth/logout';
  static const me = '/auth/me';
  static const refresh = '/auth/refresh-token';

  static const dashboardOverview = '/dashboard/overview';
  static const profitLoss = '/reports/profit-loss';
  static const storeComparison = '/reports/store-comparison';
  static const tenderTypes = '/reports/tender-types';
  static const incomeExpenseStatement = '/reports/income-expense-statement';

  static const stores = '/stores';
  static const sales = '/sales';
  static const expenses = '/expenses';
  static const expenseCategories = '/expense-categories';
  static const paymentMethods = '/payment-methods';
  static const users = '/users';
  static const roles = '/roles';
  static const permissions = '/permissions';
  static const organization = '/organizations/current';
}

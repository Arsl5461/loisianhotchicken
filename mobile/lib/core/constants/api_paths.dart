class ApiPaths {
  const ApiPaths._();

  static const login = '/auth/login';
  static const verifyOtp = '/auth/verify-otp';
  static const resendOtp = '/auth/resend-otp';
  static const forgotPassword = '/auth/forgot-password';
  static const resetPassword = '/auth/reset-password';
  static const changePassword = '/auth/change-password';
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
  static const saleCategories = '/sale-categories';
  static const expenses = '/expenses';
  static const borrowings = '/borrowings';
  static const expenseCategories = '/expense-categories';
  static const paymentMethods = '/payment-methods';
  static const users = '/users';
  static const roles = '/roles';
  static const permissions = '/permissions';
  static const organization = '/organizations/current';
}

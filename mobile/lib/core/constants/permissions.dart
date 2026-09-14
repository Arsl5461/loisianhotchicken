class Permissions {
  const Permissions._();

  static const dashboardRead = 'dashboard.read';

  static const storesCreate = 'stores.create';
  static const storesRead = 'stores.read';
  static const storesUpdate = 'stores.update';
  static const storesDelete = 'stores.delete';
  static const storesAnalytics = 'stores.analytics';

  static const usersCreate = 'users.create';
  static const usersRead = 'users.read';
  static const usersUpdate = 'users.update';
  static const usersDelete = 'users.delete';

  static const rolesCreate = 'roles.create';
  static const rolesRead = 'roles.read';
  static const rolesUpdate = 'roles.update';
  static const rolesDelete = 'roles.delete';

  static const expensesCreate = 'expenses.create';
  static const expensesRead = 'expenses.read';
  static const expensesUpdate = 'expenses.update';
  static const expensesDelete = 'expenses.delete';

  static const salesCreate = 'sales.create';
  static const salesRead = 'sales.read';
  static const salesUpdate = 'sales.update';
  static const salesDelete = 'sales.delete';

  static const reportsRead = 'reports.read';
  static const reportsExport = 'reports.export';

  static const settingsRead = 'settings.read';
  static const settingsUpdate = 'settings.update';
}

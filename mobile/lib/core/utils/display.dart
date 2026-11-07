String displayRoleName(String? name) {
  final value = name?.trim() ?? '';
  if (value.isEmpty) return '';
  final lower = value.toLowerCase();
  if (lower == 'super admin') return 'Super';
  if (lower == 'admin') return 'User';
  return value.replaceAll(RegExp(r'\badmin\b', caseSensitive: false), '').replaceAll(RegExp(r'\s+'), ' ').trim();
}

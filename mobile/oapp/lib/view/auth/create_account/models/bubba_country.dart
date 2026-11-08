class BubbaCountry {
  const BubbaCountry({
    required this.code,
    required this.name,
    required this.dialCode,
  });

  final String code;
  final String name;
  final String dialCode;

  String get flagAsset => 'assets/flags/${code.toLowerCase()}.png';

  String get shortLabel => '$code $dialCode';

  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return name.toLowerCase().contains(q) ||
        code.toLowerCase().contains(q) ||
        dialCode.contains(q);
  }
}

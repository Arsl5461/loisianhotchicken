import 'package:flutter/material.dart';

import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_settings_tokens.dart';

class SettingsPickerOption {
  const SettingsPickerOption({required this.value, required this.label});

  final String value;
  final String label;
}

Future<String?> showSettingsPickerSheet(
  BuildContext context, {
  required String title,
  required List<SettingsPickerOption> options,
  String? selected,
  String searchHint = 'Search',
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: BubbaSettingsColors.pageBg,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(d(16))),
    ),
    builder: (sheetContext) => _SettingsPickerSheet(
      title: title,
      options: options,
      selected: selected,
      searchHint: searchHint,
    ),
  );
}

class _SettingsPickerSheet extends StatefulWidget {
  const _SettingsPickerSheet({
    required this.title,
    required this.options,
    required this.selected,
    required this.searchHint,
  });

  final String title;
  final List<SettingsPickerOption> options;
  final String? selected;
  final String searchHint;

  @override
  State<_SettingsPickerSheet> createState() => _SettingsPickerSheetState();
}

class _SettingsPickerSheetState extends State<_SettingsPickerSheet> {
  final TextEditingController _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  List<SettingsPickerOption> get _visible {
    final q = _query.text.trim().toLowerCase();
    if (q.isEmpty) return widget.options;
    return widget.options
        .where((o) => o.label.toLowerCase().contains(q) ||
            o.value.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final rows = _visible;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.72,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: d(12)),
              Center(
                child: Container(
                  width: hd(38),
                  height: d(4),
                  decoration: BoxDecoration(
                    color: BubbaSettingsColors.cardBorder,
                    borderRadius: BorderRadius.circular(d(2)),
                  ),
                ),
              ),
              SizedBox(height: d(14)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hd(20)),
                child: Text(widget.title,
                    style: BubbaSettingsText.uiMedium
                        .copyWith(color: BubbaSettingsColors.rowLabel)),
              ),
              SizedBox(height: d(12)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hd(20)),
                child: Container(
                  height: d(38),
                  padding: EdgeInsets.symmetric(horizontal: hd(12)),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6F8),
                    borderRadius: BorderRadius.circular(d(9)),
                  ),
                  child: Center(
                    child: TextField(
                      controller: _query,
                      onChanged: (_) => setState(() {}),
                      style: BubbaSettingsText.formValue,
                      cursorColor: BubbaSettingsColors.rowLabel,
                      decoration: InputDecoration.collapsed(
                        hintText: widget.searchHint,
                        hintStyle: BubbaSettingsText.formPlaceholder,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: d(8)),
              Expanded(
                child: rows.isEmpty
                    ? Center(
                        child: Text('No matches',
                            style: BubbaSettingsText.formPlaceholder),
                      )
                    : ListView.separated(
                        itemCount: rows.length,
                        separatorBuilder: (_, __) => Divider(
                          height: d(0.5),
                          thickness: d(0.5),
                          color: BubbaSettingsColors.divider,
                          indent: hd(20),
                          endIndent: hd(20),
                        ),
                        itemBuilder: (_, i) {
                          final option = rows[i];
                          final isSelected = option.value == widget.selected;
                          return InkWell(
                            onTap: () => Navigator.of(context).pop(option.value),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: hd(20),
                                vertical: d(14),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      option.label,
                                      style: BubbaSettingsText.formValue,
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check,
                                      size: d(16),
                                      color: BubbaSettingsColors.rowLabel,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

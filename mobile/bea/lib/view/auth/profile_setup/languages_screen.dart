import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_icons.dart';
import '../../../core/design/bubba_text_styles.dart';
import '../../../core/design/bubba_tokens.dart';
import '../../../core/design/widgets/bubba_field.dart';
import 'widgets/choice_chip_grid.dart';
import 'widgets/display_toggle_row.dart';
import 'widgets/step_scaffold.dart';

const double _searchY = 234.0;
const double _popularBaseline = 334.39;
const double _gridTop = 348.40;
const double _selectedLabelBaseline = 317.29;
const double _selectedChipsY = 329.0;
const double _gridTopWithSelection = 411.73;
const double _popularBaselineWithSelection = 397.0;
const double _selectedChipHeight = 30.0;
const double _chipHeight = 47.85;
const double _chipRowGap = 12.99;

/// p026 puts the toggle 30.17 under the grid. p028 pushes the grid down by the
/// "Your languages" row, so the toggle has to follow it rather than stay on
/// p026's y - otherwise it lands on top of the Mandarin/Hindi row, which is
/// what it used to do. p028 itself simply stops drawing the toggle; the flow
/// cannot, so past that point the canvas scrolls.
const double _gridToToggle = 30.17;
const double _gridHeight = 5 * _chipHeight + 4 * _chipRowGap;

/// p027 - the search state. The mock keyboard the artboard draws is the
/// system's, so only the toolbar above it is ours; it rides on
/// `MediaQuery.viewInsets`.
const double _searchSelectedBaseline = 316.02;
const double _searchPillsY = 328.14;
const double _resultsLabelBaseline = 393.80;
const double _resultsTop = 406.09;
const double _resultRowHeight = 43.93;
const double _resultRowPitch = 53.75;
const double _resultRowX = 28.80;
const double _resultRowRightInset = 390 - (28.80 + 324.08);
const double _resultRowRadius = 4.97;
const double _resultLabelX = 36.64 - 28.80;
const double _resultLabelBaseline = 431.83 - 406.09;
const double _resultGlyphInset = 13.36;
const double _resultGlyphTop = 13.5;
const double _toolbarHeight = 565.1 - 513.59;
const double _toolbarCancelX = 38.22;
const double _toolbarBaseline = 547.50 - 513.59;
const double _doneWidth = 107.83;
const double _doneHeight = 37.67;
const double _doneRadius = 4.42;
const double _doneRightInset = 390 - (247.76 + 107.83);
const double _doneTop = 524.31 - 513.59;

/// Step 7 of 12 - artboards p026 (popular options), p027 (search + keyboard) and
/// p028 (with a chosen language shown above the grid).
class ProfileLanguagesScreen extends StatefulWidget {
  const ProfileLanguagesScreen({
    super.key,
    this.initialSelection = const <String>{},
    this.showSelectedSummary = false,
    this.searchOpen = false,
    this.initialQuery = '',
    this.onBack,
    this.onSkip,
    this.onContinue,
  });

  /// p027 - the search state. Focusing the field opens it; this only forces it
  /// open for a golden, where there is no real focus or keyboard.
  final bool searchOpen;

  /// Seeds the search box. p027 is drawn mid-query ("It").
  final String initialQuery;

  final Set<String> initialSelection;

  /// p028 lists the chosen languages above the grid under a "Your languages (n)"
  /// header and switches the body copy to "Select up to 3."; p026 shows the same
  /// grid with a selection but no summary. They are two states of one screen,
  /// so which one is drawn is a caller decision.
  final bool showSelectedSummary;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;
  final void Function(Set<String> languages, bool display)? onContinue;

  static const int maxSelection = 3;

  static const List<ChipItem> popular = [
    ChipItem('English'), ChipItem('Spanish'),
    ChipItem('French'), ChipItem('Portuguese'),
    ChipItem('Italian'), ChipItem('Arabic'),
    ChipItem('Farsi'), ChipItem('Hebrew'),
    ChipItem('Mandarin'), ChipItem('Hindi'),
  ];

  /// What the search looks through. The design only shows "Italian" and
  /// "Lithuanian" for the query "It", so the list is ours; it is the popular
  /// ten plus enough of the long tail to make the search worth having.
  static const List<String> all = [
    'Arabic', 'Bengali', 'Bulgarian', 'Cantonese', 'Croatian', 'Czech',
    'Danish', 'Dutch', 'English', 'Estonian', 'Farsi', 'Finnish', 'French',
    'German', 'Greek', 'Hebrew', 'Hindi', 'Hungarian', 'Indonesian', 'Italian',
    'Japanese', 'Korean', 'Latvian', 'Lithuanian', 'Malay', 'Mandarin',
    'Norwegian', 'Polish', 'Portuguese', 'Punjabi', 'Romanian', 'Russian',
    'Serbian', 'Slovak', 'Spanish', 'Swahili', 'Swedish', 'Tagalog', 'Tamil',
    'Thai', 'Turkish', 'Ukrainian', 'Urdu', 'Vietnamese',
  ];

  @override
  State<ProfileLanguagesScreen> createState() => _ProfileLanguagesScreenState();
}

class _ProfileLanguagesScreenState extends State<ProfileLanguagesScreen> {
  late final Set<String> _selected = {...widget.initialSelection};
  late final _search = TextEditingController(text: widget.initialQuery);
  final _searchFocus = FocusNode();
  bool _display = true;
  late bool _searching = widget.searchOpen;

  @override
  void initState() {
    super.initState();
    _searchFocus.addListener(_onFocus);
    _search.addListener(_onQuery);
  }

  @override
  void dispose() {
    _searchFocus.removeListener(_onFocus);
    _search.removeListener(_onQuery);
    _search.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onFocus() {
    if (_searchFocus.hasFocus && !_searching) setState(() => _searching = true);
  }

  /// Only rebuild when the rendered result set actually changes - the
  /// controller also fires on selection changes.
  late String _lastQuery = widget.initialQuery;
  void _onQuery() {
    if (_search.text == _lastQuery) return;
    _lastQuery = _search.text;
    setState(() {});
  }

  /// p027 matches "It" against both "Italian" and "Lithuanian", so the search
  /// is a substring one. Prefix matches lead, which is what puts Italian first.
  List<String> get _results {
    final query = _search.text.trim().toLowerCase();
    if (query.isEmpty) return const [];
    final prefix = <String>[];
    final rest = <String>[];
    for (final language in ProfileLanguagesScreen.all) {
      final lower = language.toLowerCase();
      if (lower.startsWith(query)) {
        prefix.add(language);
      } else if (lower.contains(query)) {
        rest.add(language);
      }
    }
    return [...prefix, ...rest];
  }

  void _closeSearch() {
    _searchFocus.unfocus();
    _search.clear();
    setState(() => _searching = false);
  }

  void _toggle(String value) {
    setState(() {
      if (_selected.contains(value)) {
        _selected.remove(value);
      } else if (_selected.length < ProfileLanguagesScreen.maxSelection) {
        _selected.add(value);
      }
    });
  }

  void _searchResults(BubbaFlow flow) {
    final results = _results;
    if (_selected.isNotEmpty) {
      flow.copy(
        'Selected',
        baseline: _searchSelectedBaseline,
        style: BubbaText.searchSectionLabel,
      );
      flow.block(
        Wrap(
          spacing: d(9),
          runSpacing: d(8),
          children: [
            for (final value in _selected)
              _SelectedPill(label: value, onRemove: () => _toggle(value)),
          ],
        ),
        top: _searchPillsY,
        height: _selectedChipHeight,
      );
    }
    if (results.isNotEmpty) {
      flow.copy(
        'Search results',
        baseline: _resultsLabelBaseline,
        style: BubbaText.searchSectionLabel,
      );
      for (var i = 0; i < results.length; i++) {
        flow.block(
          SizedBox(
            height: d(_resultRowHeight),
            child: _ResultRow(
              label: results[i],
              selected: _selected.contains(results[i]),
              onTap: () => _toggle(results[i]),
            ),
          ),
          top: _resultsTop + i * _resultRowPitch,
          height: _resultRowHeight,
          left: _resultRowX,
          right: _resultRowRightInset,
        );
      }
    }
  }

  Widget _searchToolbar() {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: BubbaColors.screenBg,
        border: Border(top: BorderSide(color: BubbaColors.divider)),
      ),
      child: SizedBox(
        height: d(_toolbarHeight),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: dx(_toolbarCancelX)),
            Baseline(
              baseline: d(_toolbarBaseline),
              baselineType: TextBaseline.alphabetic,
              child: BubbaTapTarget(
                onTap: _closeSearch,
                label: 'Cancel',
                child: Text('Cancel', style: BubbaText.goBack),
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(top: d(_doneTop)),
              child: SizedBox(
                width: hd(_doneWidth),
                height: d(_doneHeight),
                child: OverflowBox(
                  minHeight: BubbaMetrics.minTapTarget,
                  maxHeight: BubbaMetrics.minTapTarget,
                  child: BubbaTapTarget(
                    onTap: _closeSearch,
                    label: 'Done',
                    child: SizedBox(
                      height: BubbaMetrics.minTapTarget,
                      child: Center(
                        child: Container(
                          width: hd(_doneWidth),
                          height: d(_doneHeight),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: BubbaColors.actionPrimary,
                            borderRadius:
                                BorderRadius.circular(d(_doneRadius)),
                          ),
                          child: Text('Done', style: BubbaText.ctaEnabled),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: BubbaScale.availableWidth - dxRight(_doneRightInset),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final summary = widget.showSelectedSummary && _selected.isNotEmpty;
    final gridTop = summary ? _gridTopWithSelection : _gridTop;
    final toggleY = gridTop + _gridHeight + _gridToToggle;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: BubbaColors.screenBg,
        resizeToAvoidBottomInset: false,
        body: BubbaStepScaffold(
          step: 7,
          heading: 'What languages do you\nspeak?',
          body: summary
              ? 'Select up to ${ProfileLanguagesScreen.maxSelection}.'
              : 'Select all that apply.',
          continueEnabled: _selected.isNotEmpty,
          onBack: widget.onBack,
          onSkip: widget.onSkip,
          onContinue: () => widget.onContinue?.call(_selected, _display),
          showFooter: !_searching,
          footer: _searching ? (context) => _searchToolbar() : null,
          content: (context, flow) {
            flow.block(
              BubbaField(
                controller: _search,
                focusNode: _searchFocus,
                hintText: 'Search languages',
                hintStyle: BubbaText.stepFieldPlaceholder,
                textInset: 15,
                focused: _searching,
                leading: const BubbaSearchIcon(),
              ),
              top: _searchY,
              height: BubbaMetrics.fieldHeight,
            );
            if (_searching) {
              _searchResults(flow);
              return;
            }
            if (summary) {
              flow.copy(
                'Your languages (${_selected.length})',
                baseline: _selectedLabelBaseline,
                style: BubbaText.inspirationLabel,
              );
              flow.block(
                Wrap(
                  spacing: d(9),
                  runSpacing: d(8),
                  children: [
                    for (final value in _selected)
                      _SelectedPill(
                        label: value,
                        onRemove: () => _toggle(value),
                      ),
                  ],
                ),
                top: _selectedChipsY,
                height: _selectedChipHeight,
              );
            }
            flow.copy(
              'Popular options',
              baseline:
                  summary ? _popularBaselineWithSelection : _popularBaseline,
              style: BubbaText.sectionLabel,
            );
            final grid = BubbaChipGrid(
              items: ProfileLanguagesScreen.popular,
              columns: 2,
              chipHeight: 47.85,
              columnGap: 16.35,
              rowGap: 12.99,
              isSelected: _selected.contains,
              onToggle: _toggle,
            );
            flow.block(
              grid,
              top: gridTop,
              height: grid.measure() / BubbaScale.factor,
            );
            flow.block(
              BubbaDisplayToggleRow(
                subtitle: 'Let others see your language',
                value: _display,
                onChanged: (v) => setState(() => _display = v),
              ),
              top: toggleY,
              height: BubbaMetrics.rowHeightPart2,
            );
          },
        ),
      ),
    );
  }
}

/// One row of p027's search results: a grey bar with a tick when the language
/// is already chosen and a plus when it is not.
class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        selected: selected,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFFF2F3F2),
              borderRadius: BorderRadius.circular(d(_resultRowRadius)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: hd(_resultLabelX)),
                Expanded(
                  child: BubbaCopy(
                    label,
                    gapAbove: _resultLabelBaseline,
                    style: BubbaText.resultRow,
                    maxLines: 1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: d(_resultGlyphTop)),
                  child: selected
                      ? const BubbaResultTick()
                      : const BubbaResultPlus(),
                ),
                SizedBox(width: hd(_resultGlyphInset)),
              ],
            ),
          ),
        ),
      );
}

class _SelectedPill extends StatelessWidget {
  const _SelectedPill({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Remove $label',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onRemove,
        child: Container(
          height: d(_selectedChipHeight),
          padding: EdgeInsets.symmetric(horizontal: d(12)),
          decoration: BoxDecoration(
            color: const Color(0xFFE0E7E1),
            borderRadius: BorderRadius.circular(d(6)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: BubbaText.selectedPill),
              SizedBox(width: hd(8)),
              BubbaCross(size: d(7), strokeWidth: d(1.1), color: const Color(0xFF164E38)),
            ],
          ),
        ),
      ),
    );
  }
}

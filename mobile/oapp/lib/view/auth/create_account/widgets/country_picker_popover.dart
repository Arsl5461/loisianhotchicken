import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/design/bubba_layout.dart';
import '../../../../core/design/bubba_icons.dart';
import '../../../../core/design/bubba_text_styles.dart';
import '../../../../core/design/bubba_tokens.dart';
import '../data/bubba_countries.dart';
import '../models/bubba_country.dart';

class CountryPickerPopover extends StatefulWidget {
  const CountryPickerPopover({
    super.key,
    required this.selected,
    required this.onSelected,
    required this.onDismiss,
    this.shiftY = 0,
    this.searching = false,
    this.onSheetChanged,
  });

  final BubbaCountry selected;
  final ValueChanged<BubbaCountry> onSelected;
  final VoidCallback onDismiss;
  final double shiftY;

  final bool searching;
  final ValueChanged<bool>? onSheetChanged;

  static const double cardX = 26.2;
  static const double cardY = 415.7;
  static const double cardWidth = 238.2;
  static const double cardHeight = 218.9;
  static const double cardRadius = 10.1;
  static const double cardBottom = cardY + cardHeight;

  static const double cardPadding = 10.2;
  static const double searchTop = 11.9;
  static const double searchHeight = 33.2;
  static const double searchRadius = 8.7;
  static const double searchIconInset = 10.7;
  static const double searchIconSize = 11.2;
  static const double searchTextInset = 29.6;
  static const Color searchFill = Color(0xFFF5F6F8);

  static const double listTop = 50.7;
  static const double rowPitch = 36.6;
  static const double separatorInset = 10.2;

  static const double flagInset = 11.8;
  static const double flagWidth = 26.1;
  static const double flagHeight = 17.6;
  static const double nameInset = 50.3;
  static const double dialGap = 17.1;
  static const double tickWidth = 11.9;
  static const double tickHeight = 8.5;
  static const double tickInset = 10.4;

  static const double shadowBlur = 8.7;

  static const double pointerX = 55.94;
  static const double pointerY = 405.76;
  static const double pointerWidth = 15.78;
  static const double pointerHeight = 9.94;

  static const double sheetCardX = 24.2;
  static const double sheetCardRightInset = 21.1;
  static const double sheetCardHeight = 218.9;
  static const double sheetKeyboardGap = 50.4;
  static const double sheetRadius = 10.1;
  static const double sheetSideInset = 16.9;
  static const double sheetTopPad = 15.2;
  static const double sheetSearchGap = 2.3;
  static const double sheetSearchIconSize = 13.0;
  static const double sheetSearchIconInset = 9.0;
  static const double sheetListBottomPad = 4;
  static const double sheetMinHeight = 150;
  static const Duration sheetDuration = Duration(milliseconds: 260);

  @override
  State<CountryPickerPopover> createState() => _CountryPickerPopoverState();
}

class _CountryPickerPopoverState extends State<CountryPickerPopover>
    with SingleTickerProviderStateMixin {
  final TextEditingController _search = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  List<BubbaCountry> _results = bubbaCountries;

  late final AnimationController _sheetController = AnimationController(
    vsync: this,
    duration: CountryPickerPopover.sheetDuration,
  );
  late final Animation<double> _sheet = CurvedAnimation(
    parent: _sheetController,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );

  @override
  void initState() {
    super.initState();
    _searchFocus.addListener(_onSearchFocusChanged);
    _sheetController.addStatusListener(_onSheetStatusChanged);
    if (widget.searching) _sheetController.value = 1;
  }

  @override
  void dispose() {
    _sheetController.dispose();
    _search.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onSearchFocusChanged() {
    if (_searchFocus.hasFocus) {
      widget.onSheetChanged?.call(true);
      _sheetController.forward();
    } else {
      _sheetController.reverse();
    }
    setState(() {});
  }

  void _onSheetStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      widget.onSheetChanged?.call(false);
    }
  }

  void _onQueryChanged(String value) {
    setState(() {
      _results = bubbaCountries.where((c) => c.matches(value)).toList();
    });
  }

  Rect _popoverRect() => Rect.fromLTWH(
        dx(CountryPickerPopover.cardX),
        d(CountryPickerPopover.cardY + widget.shiftY) + bubbaTopShift(context),
        d(CountryPickerPopover.cardWidth),
        d(CountryPickerPopover.cardHeight),
      );

  Rect _sheetRect(BoxConstraints constraints) {
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final available = math.max(constraints.maxHeight - keyboard, 0.0);
    final bottom = math.max(
      available - d(CountryPickerPopover.sheetKeyboardGap),
      d(CountryPickerPopover.sheetMinHeight),
    );
    final height = math.min(d(CountryPickerPopover.sheetCardHeight), bottom);
    return Rect.fromLTWH(
      dx(CountryPickerPopover.sheetCardX),
      bottom - height,
      dxSpan(CountryPickerPopover.sheetCardX,
          CountryPickerPopover.sheetCardRightInset),
      height,
    );
  }

  @override
  Widget build(BuildContext context) => BubbaTextDefaults(
    child: Builder(builder: _build),
  );

  Widget _build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => AnimatedBuilder(
        animation: _sheet,
        builder: (context, _) => _layers(constraints),
      ),
    );
  }

  Widget _layers(BoxConstraints constraints) {
    final t = _sheet.value;
    final asSheet = t > 0;
    final rect = asSheet ? _sheetRect(constraints) : _popoverRect();
    final slide =
        asSheet ? (1 - t) * (constraints.maxHeight - rect.top) : 0.0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox.expand(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onDismiss,
            child: ColoredBox(
              color: BubbaColors.scrimLight.withValues(
                alpha: BubbaColors.scrimLight.a * t,
              ),
            ),
          ),
        ),
        BubbaCanvasBox(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: rect.left, top: rect.top),
                  child: SizedBox(
                    width: rect.width,
                    height: rect.height,
                    child: Transform.translate(
                      offset: Offset(0, slide),
                      child: _card(asSheet),
                    ),
                  ),
                ),
              ),
              BubbaOverlay(
                x: CountryPickerPopover.pointerX,
                y: CountryPickerPopover.pointerY + widget.shiftY,
                topShift: true,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: asSheet ? 0 : 1,
                    child: BubbaPopoverPointer(
                      width: hd(CountryPickerPopover.pointerWidth),
                      height: d(CountryPickerPopover.pointerHeight),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _card(bool asSheet) {
    final sideInset =
        d(asSheet ? CountryPickerPopover.sheetSideInset : CountryPickerPopover.cardPadding);
    final searchTop =
        d(asSheet ? CountryPickerPopover.sheetTopPad : CountryPickerPopover.searchTop);
    final listTop = asSheet
        ? d(CountryPickerPopover.sheetTopPad +
            CountryPickerPopover.searchHeight +
            CountryPickerPopover.sheetSearchGap)
        : d(CountryPickerPopover.listTop);

    return Container(
      decoration: BoxDecoration(
        color: BubbaColors.surface,
        borderRadius: BorderRadius.circular(d(asSheet
            ? CountryPickerPopover.sheetRadius
            : CountryPickerPopover.cardRadius)),
        border: Border.all(
          color: BubbaColors.border,
          width: BubbaMetrics.borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: BubbaColors.popoverShadow,
            blurRadius: d(CountryPickerPopover.shadowBlur),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: searchTop),
          Padding(
            padding: EdgeInsets.only(
              left: sideInset,
              right: asSheet ? sideInset : 0,
            ),
            child: SizedBox(
              width: asSheet
                  ? null
                  : d(CountryPickerPopover.cardWidth -
                      CountryPickerPopover.cardPadding * 2),
              height: d(CountryPickerPopover.searchHeight),
              child: _searchField(asSheet),
            ),
          ),
          SizedBox(
            height: listTop - searchTop - d(CountryPickerPopover.searchHeight),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(d(asSheet
                    ? CountryPickerPopover.sheetRadius
                    : CountryPickerPopover.cardRadius)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: asSheet
                      ? d(CountryPickerPopover.sheetSideInset -
                          CountryPickerPopover.separatorInset)
                      : 0,
                ),
                child: _results.isEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: d(CountryPickerPopover.nameInset),
                          vertical: d(12),
                        ),
                        child: Text(
                          'No countries match “${_search.text}”.',
                          style: BubbaText.countryName,
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.only(
                          bottom:
                              asSheet ? d(CountryPickerPopover.sheetListBottomPad) : 0,
                        ),
                        itemCount: _results.length,
                        itemExtent: d(CountryPickerPopover.rowPitch),
                        itemBuilder: (context, index) => _CountryRow(
                          country: _results[index],
                          isSelected: _results[index].code == widget.selected.code,
                          onTap: () => widget.onSelected(_results[index]),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchField(bool asSheet) {
    final focused = widget.searching || _searchFocus.hasFocus;
    final iconSize = asSheet
        ? CountryPickerPopover.sheetSearchIconSize
        : CountryPickerPopover.searchIconSize;
    final iconInset = asSheet
        ? CountryPickerPopover.sheetSearchIconInset
        : CountryPickerPopover.searchIconInset;
    return Container(
      decoration: BoxDecoration(
        color: focused ? BubbaColors.surface : CountryPickerPopover.searchFill,
        borderRadius:
            BorderRadius.circular(d(CountryPickerPopover.searchRadius)),
        border: focused
            ? Border.all(
                color: BubbaColors.actionDark,
                width: BubbaMetrics.borderWidth,
              )
            : null,
      ),
      child: Row(
        children: [
          SizedBox(width: hd(iconInset)),
          SvgPicture.asset(
            'assets/svg/bubba_search.svg',
            width: d(iconSize),
            height: d(iconSize),
          ),
          SizedBox(
            width: hd(CountryPickerPopover.searchTextInset - iconInset - iconSize),
          ),
          Expanded(
            child: TextField(
              controller: _search,
              focusNode: _searchFocus,
              onChanged: _onQueryChanged,
              textInputAction: TextInputAction.search,
              style: BubbaText.searchHint.copyWith(
                color: BubbaColors.actionDark,
              ),
              cursorColor: BubbaColors.actionDark,
              decoration: InputDecoration(
                isDense: true,
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: 'Search',
                hintStyle: BubbaText.searchHint,
              ),
            ),
          ),
          if (_search.text.isNotEmpty)
            Semantics(
              button: true,
              label: 'Clear search',
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _search.clear();
                  _onQueryChanged('');
                },
                child: SizedBox(
                  width: hd(BubbaMetrics.minTouchTarget),
                  height: d(CountryPickerPopover.searchHeight),
                  child: Center(
                    child: BubbaCross(
                      size: d(9),
                      color: BubbaColors.textPlaceholder,
                    ),
                  ),
                ),
              ),
            )
          else
            SizedBox(width: hd(iconInset)),
        ],
      ),
    );
  }
}

class _CountryRow extends StatelessWidget {
  const _CountryRow({
    required this.country,
    required this.isSelected,
    required this.onTap,
  });

  final BubbaCountry country;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: '${country.name} ${country.dialCode}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Stack(
          children: [
            SizedBox.expand(
              child: Row(
                children: [
                  SizedBox(width: hd(CountryPickerPopover.flagInset)),
                  Image.asset(
                    country.flagAsset,
                    width: hd(CountryPickerPopover.flagWidth),
                    height: d(CountryPickerPopover.flagHeight),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        SizedBox(width: hd(CountryPickerPopover.flagWidth)),
                  ),
                  SizedBox(
                    width: hd(CountryPickerPopover.nameInset -
                        CountryPickerPopover.flagInset -
                        CountryPickerPopover.flagWidth),
                  ),
                  Expanded(
                    child: Text(
                      country.name,
                      style: BubbaText.countryName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(country.dialCode, style: BubbaText.countryName),
                  SizedBox(width: hd(CountryPickerPopover.dialGap)),
                  SizedBox(
                    width: hd(CountryPickerPopover.tickWidth),
                    child: isSelected
                        ? SvgPicture.asset(
                            'assets/svg/bubba_tick.svg',
                            width: hd(CountryPickerPopover.tickWidth),
                            height: d(CountryPickerPopover.tickHeight),
                          )
                        : null,
                  ),
                  SizedBox(width: hd(CountryPickerPopover.tickInset)),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: d(CountryPickerPopover.separatorInset),
                ),
                child: Container(
                  height: BubbaMetrics.borderWidth,
                  color: BubbaColors.border,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

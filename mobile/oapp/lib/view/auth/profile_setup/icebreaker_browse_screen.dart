import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_glyphs.dart';
import '../../../core/design/bubba_icons.dart';
import '../../../core/design/bubba_text_styles.dart';
import '../../../core/design/bubba_tokens.dart';
import 'icebreaker_format_screen.dart';
import 'widgets/bubba_nav_bar.dart';

const double _cardLeft = 22.34;
const double _cardRightInset = 390 - 367.65;

const double _tabsLeft = 28.04;
const double _tabsY = 99.34;
const double _tabsHeight = 39.26;
const double _tabsRadius = 10.06;
const double _tabPillWidth = 103.89;
const double _tabPillHeight = 38.68;
const double _tabPillRadius = 9.43;
const double _tabPillInset = 0.32;
const double _tabDividerTop = 106.32 - _tabsY;
const double _tabDividerHeight = 26.50;
const Color _tabsBorder = Color(0xFFE6E6E7);
const Color _tabPillBg = Color(0xFFFAFAFA);
const Color _tabPillBorder = Color(0xFFE2E5E3);
const double _hairline = 0.5;

const double _featuredY = 172.0;
const double _featuredHeight = 108.0;
const double _featuredRadius = 10.0;
const double _badgeInset = 19.05;
const double _badgeTop = 24.69;
const double _badgeSize = 61.17;
const double _featuredCopyInset = 106.68;
const double _featuredTitleBaseline = 36.04;
const double _featuredBodyBaseline = 61.97;
const double _listY = 298.11;
const double _listHeight = 597.0;
const double _listRadius = 10.03;
const double _rowPitch = 52.5;
const double _listTopPad = 8.89;
const double _rowTextInset = 13.1;
const double _rowChevronInset = 16.5;


/// Artboards p006 (Prompts), p040 (Games) and p041 (Snaps) - the same browse
/// screen with a different tab selected.
class IcebreakerBrowseScreen extends StatefulWidget {
  const IcebreakerBrowseScreen({
    super.key,
    this.initialFormat = IcebreakerFormat.prompts,
    this.items,
    this.onBack,
    this.onPick,
  });

  final IcebreakerFormat initialFormat;

  /// The prompt catalogue. The artboards show nine fixed lines, but the API
  /// keys an answer by the prompt's id, so the live flow passes the fetched
  /// list; leaving it null falls back to the design's copy.
  final List<({String? id, String text})>? items;
  final VoidCallback? onBack;

  /// The tab is switchable inside this screen, so a pick has to report which
  /// format it was made under as well as which item was chosen.
  final void Function(IcebreakerFormat format, String item, String? promptId)?
      onPick;

  static const List<String> prompts = [
    'My happy place is',
    'Kill, f*ck, marry',
    'My favorite dinner spot is',
    'I go crazy for',
    'The way to win me over',
    'Dating me is like',
    'Unpopular opinion',
    'Something I cant live without',
    'I get excited about',
  ];

  @override
  State<IcebreakerBrowseScreen> createState() => _IcebreakerBrowseScreenState();
}

class _IcebreakerBrowseScreenState extends State<IcebreakerBrowseScreen> {
  late IcebreakerFormat _format = widget.initialFormat;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: BubbaColors.screenBg,
        resizeToAvoidBottomInset: false,
        body: BubbaPage(
          contentStartY: navHairlineY,
          header: (context) => BubbaNavBar(
            title: 'Choose an icebreaker',
            onBack: widget.onBack,
          ),
          content: (context, flow) {
            flow.block(
              _TabBar(
                selected: _format,
                onTap: (format) => setState(() => _format = format),
              ),
              top: _tabsY,
              height: _tabsHeight,
              left: _tabsLeft,
              right: _cardRightInset,
            );
            flow.block(
              _FeaturedCard(format: _format),
              top: _featuredY,
              height: _featuredHeight,
              left: _cardLeft,
              right: _cardRightInset,
            );
            flow.block(
              _List(
                items: [
                  for (final p in widget.items ??
                      [
                        for (final t in IcebreakerBrowseScreen.prompts)
                          (id: null, text: t),
                      ])
                    p.text,
                ],
                onPick: (item) {
                  final source = widget.items;
                  final match = source
                      ?.where((p) => p.text == item)
                      .cast<({String? id, String text})?>()
                      .firstWhere((p) => true, orElse: () => null);
                  widget.onPick?.call(_format, item, match?.id);
                },
              ),
              top: _listY,
              height: 0,
              left: _cardLeft,
              right: _cardRightInset,
            );
          },
        ),
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({required this.selected, this.onTap});

  final IcebreakerFormat selected;
  final ValueChanged<IcebreakerFormat>? onTap;

  @override
  Widget build(BuildContext context) {
    const formats = IcebreakerFormat.values;
    final children = <Widget>[];
    for (var i = 0; i < formats.length; i++) {
      if (i > 0) {
        final adjacent = formats[i - 1] == selected || formats[i] == selected;
        children.add(
          Expanded(
            child: adjacent
                ? const SizedBox.shrink()
                : Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: d(_tabDividerTop)),
                      child: BubbaHairline(
                        color: _tabsBorder,
                        height: d(_tabDividerHeight),
                      ),
                    ),
                  ),
          ),
        );
      }
      children.add(
        _Tab(
          format: formats[i],
          selected: formats[i] == selected,
          onTap: onTap == null ? null : () => onTap!(formats[i]),
        ),
      );
    }
    return Container(
      height: d(_tabsHeight),
      decoration: BoxDecoration(
        color: BubbaColors.surface,
        borderRadius: BorderRadius.circular(d(_tabsRadius)),
        border: Border.all(color: _tabsBorder, width: _hairline),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: d(_tabPillInset)),
        child: Row(children: children),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.format, required this.selected, this.onTap});

  final IcebreakerFormat format;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        selected: selected,
        label: format.title,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            width: hd(_tabPillWidth),
            height: d(_tabPillHeight),
            decoration: selected
                ? BoxDecoration(
                    color: _tabPillBg,
                    borderRadius: BorderRadius.circular(d(_tabPillRadius)),
                    border: Border.all(color: _tabPillBorder, width: 1),
                  )
                : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TabGlyph(format: format),
                SizedBox(width: hd(5)),
                Text(
                  format.title,
                  style: selected
                      ? BubbaText.tabSelected
                      : BubbaText.tabUnselected,
                ),
              ],
            ),
          ),
        ),
      );
}

class _TabGlyph extends StatelessWidget {
  const _TabGlyph({required this.format});

  final IcebreakerFormat format;

  @override
  Widget build(BuildContext context) => switch (format) {
        IcebreakerFormat.prompts => BubbaGlyphIcon(
            BubbaGlyphs.quoteMark,
            color: format.accent,
            width: 18.73,
          ),
        IcebreakerFormat.snaps =>
          BubbaCameraGlyph(size: 14.31, color: format.accent),
        IcebreakerFormat.games =>
          BubbaSparkle(size: 15.60, color: format.browseAccent),
      };
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.format});

  final IcebreakerFormat format;

  @override
  Widget build(BuildContext context) => Container(
        height: d(_featuredHeight),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [format.bannerFrom, format.bannerTo],
          ),
          borderRadius: BorderRadius.circular(d(_featuredRadius)),
        ),
        child: Builder(
          builder: (context) {
            final titleMetrics =
                bubbaDesignTextMetrics(context, BubbaText.formatTitle);
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: hd(_badgeInset)),
                Padding(
                  padding: EdgeInsets.only(top: d(_badgeTop)),
                  child: Container(
                    width: d(_badgeSize),
                    height: d(_badgeSize),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: format.browseTint,
                      shape: BoxShape.circle,
                    ),
                    child: _BadgeGlyph(format: format),
                  ),
                ),
                SizedBox(
                  width: hd(_featuredCopyInset - _badgeInset - _badgeSize),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BubbaCopy(
                        format.title,
                        gapAbove: _featuredTitleBaseline,
                        style: BubbaText.formatTitle,
                      ),
                      BubbaCopy(
                        'Pick a style to add\nicebreakers to your profile',
                        gapAbove: _featuredBodyBaseline -
                            _featuredTitleBaseline -
                            titleMetrics.descent,
                        style: BubbaText.formatBody.copyWith(height: 21 / 14),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
}

class _BadgeGlyph extends StatelessWidget {
  const _BadgeGlyph({required this.format});

  final IcebreakerFormat format;

  @override
  Widget build(BuildContext context) => switch (format) {
        IcebreakerFormat.prompts => BubbaGlyphIcon(
            BubbaGlyphs.quoteMark,
            color: format.accent,
            width: 26.42,
          ),
        IcebreakerFormat.snaps =>
          BubbaCameraGlyph(size: 20.19, color: format.accent),
        IcebreakerFormat.games =>
          BubbaSparkle(size: 22.0, color: format.browseAccent),
      };
}

class _List extends StatelessWidget {
  const _List({required this.items, this.onPick});

  final List<String> items;
  final ValueChanged<String>? onPick;

  @override
  Widget build(BuildContext context) => Container(
        height: d(_listHeight),
        decoration: BoxDecoration(
          color: BubbaColors.surface,
          borderRadius: BorderRadius.circular(d(_listRadius)),
          border: Border.all(color: BubbaColors.border, width: 0.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const BubbaGap(_listTopPad),
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0)
                BubbaHairline(color: BubbaColors.border, width: double.infinity),
              Semantics(
                button: true,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onPick == null ? null : () => onPick!(items[i]),
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: d(_rowPitch) -
                          (i > 0 ? 1 / MediaQuery.devicePixelRatioOf(context) : 0),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: hd(_rowTextInset)),
                        Expanded(
                          child: Text(items[i], style: BubbaText.listRow),
                        ),
                        const BubbaChevronRight(),
                        SizedBox(width: hd(_rowChevronInset)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
}

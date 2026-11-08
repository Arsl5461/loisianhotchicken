import 'package:flutter/material.dart';

import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_settings_glyphs.dart';
import '../../../core/design/bubba_settings_tokens.dart';
import 'settings_chrome.dart';

class SettingsCardRow {
  const SettingsCardRow({
    required this.title,
    required this.titleX,
    required this.titleBaseline,
    required this.chevronX,
    required this.chevronY,
    required this.bandTop,
    required this.bandBottom,
    this.subtitle,
    this.subtitleX,
    this.subtitleBaseline,
    this.subtitleLarge = false,
    this.dividerX,
    this.dividerY,
    this.dividerWidth,
    this.onTap,
  });

  final String title;
  final double titleX;
  final double titleBaseline;
  final double chevronX;
  final double chevronY;
  final double bandTop;
  final double bandBottom;
  final String? subtitle;
  final double? subtitleX;
  final double? subtitleBaseline;
  final bool subtitleLarge;
  final double? dividerX;
  final double? dividerY;
  final double? dividerWidth;
  final VoidCallback? onTap;

  SettingsCardRow copyWith({String? title, VoidCallback? onTap}) =>
      SettingsCardRow(
        title: title ?? this.title,
        titleX: titleX,
        titleBaseline: titleBaseline,
        chevronX: chevronX,
        chevronY: chevronY,
        bandTop: bandTop,
        bandBottom: bandBottom,
        subtitle: subtitle,
        subtitleX: subtitleX,
        subtitleBaseline: subtitleBaseline,
        subtitleLarge: subtitleLarge,
        dividerX: dividerX,
        dividerY: dividerY,
        dividerWidth: dividerWidth,
        onTap: onTap ?? this.onTap,
      );

  SettingsCardRow withTap(VoidCallback? tap) => SettingsCardRow(
        title: title,
        titleX: titleX,
        titleBaseline: titleBaseline,
        chevronX: chevronX,
        chevronY: chevronY,
        bandTop: bandTop,
        bandBottom: bandBottom,
        subtitle: subtitle,
        subtitleX: subtitleX,
        subtitleBaseline: subtitleBaseline,
        subtitleLarge: subtitleLarge,
        dividerX: dividerX,
        dividerY: dividerY,
        dividerWidth: dividerWidth,
        onTap: tap,
      );
}

class SettingsCardList extends StatelessWidget {
  const SettingsCardList({
    super.key,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.rows,
    this.fill = BubbaSettingsColors.cardBg,
  });

  final double x;
  final double y;
  final double width;
  final double height;
  final List<SettingsCardRow> rows;
  final Color fill;

  @override
  Widget build(BuildContext context) {
    final titleMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.cardRowTitle);
    final subMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.cardRowSubtitle);
    final subLargeMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.cardRowSubtitleLarge);

    Widget at(double left, double top, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: hd(left - x), top: d(top - y)),
            child: child,
          ),
        );

    final layers = <Widget>[];
    for (final row in rows) {
      layers.add(
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(top: d(row.bandTop - y)),
            child: Semantics(
              button: true,
              label: row.title,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: row.onTap,
                child: SizedBox(
                  width: hd(width),
                  height: d(row.bandBottom - row.bandTop),
                ),
              ),
            ),
          ),
        ),
      );
      layers.add(at(
        row.titleX,
        row.titleBaseline - titleMetrics.baseline,
        Text(row.title, style: BubbaSettingsText.cardRowTitle),
      ));
      if (row.subtitle != null) {
        final style = row.subtitleLarge
            ? BubbaSettingsText.cardRowSubtitleLarge
            : BubbaSettingsText.cardRowSubtitle;
        final metrics = row.subtitleLarge ? subLargeMetrics : subMetrics;
        layers.add(at(
          row.subtitleX ?? row.titleX,
          row.subtitleBaseline! - metrics.baseline,
          Text(row.subtitle!, style: style),
        ));
      }
      layers.add(at(row.chevronX, row.chevronY, const SettingsChevron()));
      if (row.dividerY != null) {
        layers.add(at(
          row.dividerX!,
          row.dividerY! - BubbaSettingsMetrics.dividerWeight / 2,
          SizedBox(
            width: hd(row.dividerWidth!),
            height: d(BubbaSettingsMetrics.dividerWeight),
            child: const BubbaHairline(color: BubbaSettingsColors.divider),
          ),
        ));
      }
    }

    return Row(
      children: [
        SizedBox(width: hd(x)),
        Container(
          width: hd(width),
          height: d(height),
          decoration: BoxDecoration(
            color: fill,
            border: Border.all(
              color: BubbaSettingsColors.cardBorder,
              width: d(BubbaSettingsMetrics.dividerWeight),
            ),
            borderRadius:
                BorderRadius.circular(d(BubbaSettingsMetrics.cardRadius)),
          ),
          child: Stack(children: layers),
        ),
      ],
    );
  }
}

void settingsLead(
  BuildContext context,
  BubbaFlow flow,
  String text,
  double x,
  double baseline, {
  bool bold = false,
}) {
  final style =
      bold ? BubbaSettingsText.sectionLead : BubbaSettingsText.lead;
  final metrics = bubbaDesignTextMetrics(context, style);
  flow.block(
    Row(
      children: [
        SizedBox(width: hd(x)),
        Text(text, style: style),
      ],
    ),
    top: baseline - metrics.baseline,
    height: metrics.lineHeight,
  );
}

class SettingsAccordionRow {
  const SettingsAccordionRow({
    required this.title,
    required this.titleX,
    required this.titleBaseline,
    required this.chevronY,
    required this.bandTop,
    required this.bandBottom,
    this.dividerY,
    this.body,
  });

  final String title;
  final double titleX;
  final double titleBaseline;
  final double chevronY;
  final double bandTop;
  final double bandBottom;
  final double? dividerY;
  final String? body;
}

class SettingsAccordionCard extends StatelessWidget {
  const SettingsAccordionCard({
    super.key,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.rows,
    required this.expanded,
    this.onToggle,
  });

  static const double bodyX = 45.73;
  static const double bodyFirstBaseline = 240.97;
  static const double bodyLineHeight = 18;
  static const double expandedChevronX = 336.90;
  static const double expandedChevronWidth = 10.60;
  static const double expandedChevronHeight = 6.00;
  static const double collapsedChevronX = 339.20;
  static const double dividerX = 30.55;
  static const double dividerWidth = 318;

  final double x;
  final double y;
  final double width;
  final double height;
  final List<SettingsAccordionRow> rows;
  final int expanded;
  final ValueChanged<int>? onToggle;

  @override
  Widget build(BuildContext context) {
    final titleMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.rowLabel);
    final bodyMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.accordionBody);

    Widget at(double left, double top, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: hd(left - x), top: d(top - y)),
            child: child,
          ),
        );

    final layers = <Widget>[];
    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      final open = i == expanded;
      layers.add(
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(top: d(row.bandTop - y)),
            child: Semantics(
              button: true,
              label: row.title,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onToggle == null ? null : () => onToggle!(i),
                child: SizedBox(
                  width: hd(width),
                  height: d(row.bandBottom - row.bandTop),
                ),
              ),
            ),
          ),
        ),
      );
      layers.add(at(
        row.titleX,
        row.titleBaseline - titleMetrics.baseline,
        Text(row.title, style: BubbaSettingsText.rowLabel),
      ));
      layers.add(
        open
            ? at(
                expandedChevronX,
                row.chevronY,
                const SettingsChevron(
                  glyph: BubbaSettingsGlyphs.rowChevronUp,
                  width: expandedChevronWidth,
                  height: expandedChevronHeight,
                ),
              )
            : at(collapsedChevronX, row.chevronY, const SettingsChevron()),
      );
      if (open && row.body != null) {
        layers.add(at(
          bodyX,
          bodyFirstBaseline - bodyMetrics.baseline,
          Text(row.body!, style: BubbaSettingsText.accordionBody),
        ));
      }
      if (row.dividerY != null) {
        layers.add(at(
          dividerX,
          row.dividerY! - BubbaSettingsMetrics.dividerWeight / 2,
          SizedBox(
            width: hd(dividerWidth),
            height: d(BubbaSettingsMetrics.dividerWeight),
            child: const BubbaHairline(color: BubbaSettingsColors.divider),
          ),
        ));
      }
    }

    return Row(
      children: [
        SizedBox(width: hd(x)),
        Container(
          width: hd(width),
          height: d(height),
          decoration: BoxDecoration(
            color: BubbaSettingsColors.pageBg,
            border: Border.all(
              color: BubbaSettingsColors.cardBorder,
              width: d(BubbaSettingsMetrics.dividerWeight),
            ),
            borderRadius:
                BorderRadius.circular(d(BubbaSettingsMetrics.cardRadius)),
          ),
          child: Stack(children: layers),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/design/bubba_glyphs.dart';
import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_prefs_glyphs.dart';
import '../../core/design/bubba_prefs_tokens.dart';
import '../../core/routing/app_routes.dart';
import '../../models/travel_destination_model.dart';
import 'bubba_prefs_controller.dart';
import 'prefs_feedback.dart';
import 'prefs_filter_routes.dart';
import 'widgets/prefs_chrome.dart';

class PrefsSummary {
  const PrefsSummary(this.label, this.value, this.glyph, this.glyphSize);
  final String label;
  final String value;
  final BubbaGlyph glyph;
  final Size glyphSize;
}

const List<PrefsSummary> prefsSummaryRows = [
  PrefsSummary('LOOKING FOR', 'Women', BubbaPrefsGlyphs.person,
      Size(11.37, 12.94)),
  PrefsSummary('AGE RANGE', '22 - 36', BubbaPrefsGlyphs.age, Size(13.49, 13.49)),
  PrefsSummary('DISTANCE', '8 miles', BubbaPrefsGlyphs.pin, Size(14.22, 18.29)),
  PrefsSummary('HEIGHT', '5’6” - 5’11”', BubbaPrefsGlyphs.height,
      Size(14.84, 14.84)),
];

const double _titleBaseline = 106.59;
const double _subtitleBaseline = 149.72;
const double _modeEyebrow = 197.44;
const double _pillY = 209;
const double _pillW = 106;
const double _pillH = 41;
const double _localFirstEyebrow = 284.38;
const double _travelFirstEyebrow = 491.38;

double _tripFirstEyebrow(PrefsTripCard card) => switch (card) {
      PrefsTripCard.cards || PrefsTripCard.form => 491.38,
      PrefsTripCard.upcoming => 489.38,
      PrefsTripCard.upcomingCta => 534.38,
      PrefsTripCard.summary => 380.38,
    };
const double _summaryPitch = 93.13;
const double _iconOffset = 12.75;
const double _valueOffset = 37.77;
const double _chevronOffset = 26.46;
const double _ruleOffset = 65.12;
const double _poolCardY = 664;
const double _poolCardH = 141;

/// p033 - p047. The second Dating preferences hub: a Canela heading, a
/// Local / Travel pill pair, four summary rows and either the match-pool meter
/// (Local) or the destination and arrival rows (Travel).
class PrefsSummaryHubView extends StatelessWidget {
  const PrefsSummaryHubView({
    super.key,
    this.travel = false,
    this.tripCard = PrefsTripCard.cards,
    this.rows = prefsSummaryRows,
    this.destination,
    this.arrival,
    this.tripMeta = 'Arrives Jun 15',
    this.poolCount = '12,400',
    this.poolVerdict = 'Excellent',
    this.poolNote = 'Plenty of great people in your area.',
    this.poolFilled = 25,
    this.poolMid = 12,
    this.onBack,
    this.onMode,
    this.onRow,
    this.onDestination,
    this.onArrival,
    this.onDone,
    this.onDismiss,
  });

  final bool travel;
  final PrefsTripCard tripCard;
  final List<PrefsSummary> rows;
  final String tripMeta;
  final String? destination;
  final String? arrival;
  final String poolCount;
  final String poolVerdict;
  final String poolNote;
  final int poolFilled;
  final int poolMid;
  final VoidCallback? onBack;
  final ValueChanged<bool>? onMode;
  final ValueChanged<int>? onRow;
  final VoidCallback? onDestination;
  final VoidCallback? onArrival;
  final VoidCallback? onDone;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: BubbaPrefsColors.v2Bg,
        body: BubbaPage(
          padContent: false,
          background: BubbaPrefsColors.v2Bg,
          footerBand: 21,
          content: _content,
        ),
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.reserveBlocks = true;
    flow.block(
      PrefsNavBar(onBack: onBack),
      top: 0,
      height: PrefsNavBar.height,
    );

    final titleMetrics = bubbaDesignTextMetrics(context, BubbaPrefsText.v2Title);
    flow.block(
      Row(
        children: [
          SizedBox(width: hd(19)),
          Text('Dating preferences', style: BubbaPrefsText.v2Title),
        ],
      ),
      top: _titleBaseline - titleMetrics.baseline,
      height: titleMetrics.lineHeight,
    );

    final subMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.introCopy);
    flow.block(
      Row(
        children: [
          SizedBox(width: hd(20.75)),
          Text('Refine your match pool.', style: BubbaPrefsText.introCopy),
        ],
      ),
      top: _subtitleBaseline - subMetrics.baseline,
      height: subMetrics.lineHeight,
    );

    final eyebrowMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.eyebrow);
    flow.block(
      PrefsEyebrow(label: 'MODE', x: 22.40, style: BubbaPrefsText.eyebrow),
      top: _modeEyebrow - eyebrowMetrics.baseline,
      height: eyebrowMetrics.lineHeight,
    );

    flow.block(
      _ModePills(travel: travel, onMode: onMode),
      top: _pillY,
      height: _pillH + 1,
    );

    if (travel) {
      switch (tripCard) {
        case PrefsTripCard.cards:
          flow.block(
            _TravelRow(
              eyebrow: 'DESTINATION',
              label: destination ?? 'Choose destination',
              cardY: 277.44,
              eyebrowBaseline: 301.11,
              labelBaseline: 322.48,
              glyph: BubbaPrefsGlyphs.pinSmall,
              glyphSize: const Size(10.03, 12.90),
              onTap: onDestination,
            ),
            top: 277.44,
            height: 64,
          );

          flow.block(
            _TravelRow(
              eyebrow: 'ARRIVAL',
              label: arrival ?? 'Add arrival date',
              cardY: 346.44,
              eyebrowBaseline: 370.11,
              labelBaseline: 391.48,
              glyph: BubbaPrefsGlyphs.age,
              glyphSize: const Size(13.49, 13.49),
              onTap: onArrival,
            ),
            top: 346.44,
            height: 64,
          );
        case PrefsTripCard.form:
          flow.block(
            _TripFormCard(
              destination: destination,
              arrival: arrival,
              x: 14.29,
              width: 359,
              top: 277.44,
              onDestination: onDestination,
              onArrival: onArrival,
            ),
            top: 277.44,
            height: _TripFormCard.height,
          );
        case PrefsTripCard.upcoming:
        case PrefsTripCard.upcomingCta:
          flow.block(
            _TripWrapper(
              destination: destination,
              arrival: arrival,
              height: tripCard == PrefsTripCard.upcoming ? 181 : 237,
              showDoneLink: tripCard == PrefsTripCard.upcoming,
              showCta: tripCard == PrefsTripCard.upcomingCta,
              onDone: onDone,
              onDismiss: onDismiss,
              onDestination: onDestination,
              onArrival: onArrival,
            ),
            top: _TripWrapper.y,
            height: tripCard == PrefsTripCard.upcoming ? 181 : 237,
          );
        case PrefsTripCard.summary:
          flow.block(
            _TripSummaryCard(
              destination: destination ?? 'Choose destination',
              meta: tripMeta,
              onEdit: onDestination,
              onDismiss: onDismiss,
            ),
            top: _TripSummaryCard.y,
            height: _TripSummaryCard.height,
          );
      }

      if (tripCard == PrefsTripCard.cards ||
          tripCard == PrefsTripCard.form) {
        final noteMetrics =
            bubbaDesignTextMetrics(context, BubbaPrefsText.travelNote);
        flow.block(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: hd(18.75)),
              Padding(
                padding: EdgeInsets.only(top: d(424.79 - 419.55)),
                child: const BubbaGlyphIcon(
                  BubbaPrefsGlyphs.info,
                  color: BubbaPrefsColors.title,
                  width: 14.22,
                  height: 14.22,
                ),
              ),
              SizedBox(width: hd(40.76 - 32.97)),
              Text(
                'Complete your trip details to activate travel mode and\n'
                'estimate your match pool.',
                style: BubbaPrefsText.travelNote,
              ),
            ],
          ),
          top: 419.55,
          height: noteMetrics.lineHeight * 2,
        );
      }
    }

    final firstEyebrow = travel ? _tripFirstEyebrow(tripCard) : _localFirstEyebrow;
    for (var i = 0; i < rows.length; i++) {
      final eyebrowBaseline = firstEyebrow + _summaryPitch * i;
      final top = eyebrowBaseline - eyebrowMetrics.baseline;
      flow.block(
        _SummaryRow(
          row: rows[i],
          top: top,
          eyebrowBaseline: eyebrowBaseline,
          muted: travel,
          rule: i < rows.length - 1,
          onTap: onRow == null ? null : () => onRow!(i),
        ),
        top: top,
        height: _summaryPitch,
      );
    }

    if (!travel) {
      flow.block(
        _MatchPoolCard(
          count: poolCount,
          verdict: poolVerdict,
          note: poolNote,
          filled: poolFilled,
          mid: poolMid,
        ),
        top: _poolCardY,
        height: _poolCardH,
      );
    }
  }
}

class _ModePills extends StatelessWidget {
  const _ModePills({required this.travel, this.onMode});

  final bool travel;
  final ValueChanged<bool>? onMode;

  Widget _pill(
    BuildContext context, {
    required String label,
    required bool selected,
    required double labelX,
    required double labelBaseline,
    required double top,
    VoidCallback? onTap,
  }) {
    final metrics = bubbaDesignTextMetrics(context, BubbaPrefsText.v2Pill);
    return BubbaTapTarget(
      onTap: onTap,
      label: label,
      child: Container(
        width: hd(_pillW),
        height: d(_pillH),
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          color: selected
              ? BubbaPrefsColors.v2PillOn
              : (travel ? BubbaPrefsColors.v2PillOn : BubbaPrefsColors.v2PillOff),
          borderRadius: BorderRadius.circular(d(20.50)),
          border: selected
              ? Border.all(color: BubbaPrefsColors.title, width: d(1))
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: hd(labelX),
            top: dGap(labelBaseline - top - metrics.baseline),
          ),
          child: Text(
            label,
            style: selected
                ? BubbaPrefsText.v2Pill
                : BubbaPrefsText.v2Pill
                    .copyWith(color: BubbaPrefsColors.v2PillLabelOff),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: hd(15.97)),
              child: _pill(
                context,
                label: 'Local',
                selected: !travel,
                labelX: 52.18 - 15.97,
                labelBaseline: 234.01,
                top: _pillY,
                onTap: onMode == null ? null : () => onMode!(false),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: hd(139.97), top: d(1)),
              child: _pill(
                context,
                label: 'Travel',
                selected: travel,
                labelX: 175.18 - 139.97,
                labelBaseline: 237.01,
                top: _pillY + 1,
                onTap: onMode == null ? null : () => onMode!(true),
              ),
            ),
          ),
        ],
      );
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.row,
    required this.top,
    required this.eyebrowBaseline,
    required this.muted,
    required this.rule,
    this.onTap,
  });

  final PrefsSummary row;
  final double top;
  final double eyebrowBaseline;
  final bool muted;
  final bool rule;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final eyebrowMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.eyebrow);
    final valueMetrics = bubbaDesignTextMetrics(context, BubbaPrefsText.v2Value);

    Widget at(double left, double y, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: hd(left), top: dGap(y - top)),
            child: child,
          ),
        );

    return Semantics(
      button: true,
      label: '${row.label}, ${row.value}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Stack(
          children: [
            at(
              24.92,
              eyebrowBaseline + _iconOffset,
              Container(
                width: d(41),
                height: d(41),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: muted
                      ? BubbaPrefsColors.v2IconBgMuted
                      : BubbaPrefsColors.v2IconBg,
                  shape: BoxShape.circle,
                ),
                child: BubbaGlyphIcon(
                  row.glyph,
                  color: BubbaPrefsColors.title,
                  width: row.glyphSize.width,
                  height: row.glyphSize.height,
                ),
              ),
            ),
            at(
              24.28,
              eyebrowBaseline - eyebrowMetrics.baseline,
              Text(row.label, style: BubbaPrefsText.eyebrow),
            ),
            at(
              82.02,
              eyebrowBaseline + _valueOffset - valueMetrics.baseline,
              Text(row.value, style: BubbaPrefsText.v2Value),
            ),
            at(
              369.25,
              eyebrowBaseline + _chevronOffset,
              const BubbaGlyphIcon(
                BubbaPrefsGlyphs.cardChevron,
                color: BubbaPrefsColors.chevron,
                width: 6.00,
                height: 14.25,
              ),
            ),
            if (rule)
              at(
                22.88,
                eyebrowBaseline + _ruleOffset - 0.5,
                SizedBox(
                  width: hd(374.46),
                  height: d(1),
                  child: const BubbaHairline(color: BubbaPrefsColors.v2Rule),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


enum PrefsTripCard { cards, form, upcoming, upcomingCta, summary }

class _TripFormCard extends StatelessWidget {
  const _TripFormCard({
    required this.destination,
    required this.arrival,
    required this.x,
    required this.width,
    required this.top,
    this.circleDx = 12.00,
    this.glyphDx1 = 23.10,
    this.glyphDx2 = 21.54,
    this.textDx = 52.36,
    this.chevronDx1 = 342.72,
    this.chevronDx2 = 340.27,
    this.ruleDx = -0.17,
    this.ruleInset = 0.51,
    this.onDestination,
    this.onArrival,
  });

  final String? destination;
  final String? arrival;
  final double x;
  final double width;
  final double top;
  final double circleDx;
  final double glyphDx1;
  final double glyphDx2;
  final double textDx;
  final double chevronDx1;
  final double chevronDx2;
  final double ruleDx;
  final double ruleInset;
  final VoidCallback? onDestination;
  final VoidCallback? onArrival;

  static const double height = 123.06;

  @override
  Widget build(BuildContext context) {
    final titleMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.tripRowTitle);
    final valueMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.tripRowValue);
    final hintMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.tripRowHint);

    Widget at(double left, double y, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: hdGap(left - x),
              top: dGap(y - top),
            ),
            child: child,
          ),
        );

    Widget row({
      required String title,
      required String? value,
      required String hint,
      required double circleY,
      required double glyphX,
      required double glyphY,
      required BubbaGlyph glyph,
      required Size glyphSize,
      required double titleBaseline,
      required double valueBaseline,
      required double chevronX,
      required double chevronY,
      VoidCallback? onTap,
    }) =>
        Semantics(
          button: true,
          label: '$title, ${value ?? hint}',
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Stack(
              children: [
                at(
                  x + circleDx,
                  circleY,
                  Container(
                    width: d(32),
                    height: d(32),
                    decoration: const BoxDecoration(
                      color: BubbaPrefsColors.travelIconBg,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                at(
                  glyphX,
                  glyphY,
                  BubbaGlyphIcon(
                    glyph,
                    color: BubbaPrefsColors.title,
                    width: glyphSize.width,
                    height: glyphSize.height,
                  ),
                ),
                at(
                  x + textDx,
                  titleBaseline - titleMetrics.baseline,
                  Text(title, style: BubbaPrefsText.tripRowTitle),
                ),
                at(
                  x + textDx,
                  value == null
                      ? valueBaseline - hintMetrics.baseline
                      : valueBaseline - valueMetrics.baseline,
                  value == null
                      ? Text(hint, style: BubbaPrefsText.tripRowHint)
                      : Text(value, style: BubbaPrefsText.tripRowValue),
                ),
                at(
                  chevronX,
                  chevronY,
                  const BubbaGlyphIcon(
                    BubbaPrefsGlyphs.rowChevron,
                    color: BubbaPrefsColors.chevron,
                    width: 6.00,
                    height: 10.58,
                  ),
                ),
              ],
            ),
          ),
        );

    return Row(
      children: [
        SizedBox(width: hd(x)),
        Container(
          width: hd(width),
          height: d(height),
          decoration: BoxDecoration(
            color: BubbaPrefsColors.sliderCardFill,
            borderRadius: BorderRadius.circular(d(7.42)),
            border: Border.all(
              color: BubbaPrefsColors.sliderCardBorder,
              width: d(1),
            ),
          ),
          child: Stack(
            children: [
              row(
                title: 'Destination',
                value: destination,
                hint: 'Choose destination',
                circleY: top + 16,
                glyphX: x + glyphDx1,
                glyphY: top + 25.92,
                glyph: BubbaPrefsGlyphs.pinSmall,
                glyphSize: const Size(10.03, 12.90),
                titleBaseline: destination == null ? top + 28.67 : top + 25.17,
                valueBaseline: top + 44.04,
                chevronX: x + chevronDx1,
                chevronY: top + 27.46,
                onTap: onDestination,
              ),
              row(
                title: 'Arrival',
                value: arrival,
                hint: 'Add arrival date',
                circleY: top + 72,
                glyphX: x + glyphDx2,
                glyphY: top + 81.04,
                glyph: BubbaPrefsGlyphs.age,
                glyphSize: const Size(13.49, 13.49),
                titleBaseline: top + 84.67,
                valueBaseline: top + 102.04,
                chevronX: x + chevronDx2,
                chevronY: top + 83.38,
                onTap: onArrival,
              ),
              at(
                x + ruleDx,
                top + 61.57,
                SizedBox(
                  width: hd(width - ruleInset),
                  height: d(1),
                  child: const ColoredBox(color: BubbaPrefsColors.v2Rule),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TripWrapper extends StatelessWidget {
  const _TripWrapper({
    required this.destination,
    required this.arrival,
    required this.height,
    required this.showDoneLink,
    required this.showCta,
    this.onDone,
    this.onDismiss,
    this.onDestination,
    this.onArrival,
  });

  final String? destination;
  final String? arrival;
  final double height;
  final bool showDoneLink;
  final bool showCta;
  final VoidCallback? onDone;
  final VoidCallback? onDismiss;
  final VoidCallback? onDestination;
  final VoidCallback? onArrival;

  static const double x = 18.11;
  static const double y = 272;
  static const double width = 359;

  @override
  Widget build(BuildContext context) {
    final eyebrowMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.eyebrow);
    final actionMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.tripAction);
    final ctaMetrics = bubbaDesignTextMetrics(context, BubbaPrefsText.tripCta);

    Widget at(double left, double top, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: hdGap(left - x),
              top: dGap(top - y),
            ),
            child: child,
          ),
        );

    return Row(
      children: [
        SizedBox(width: hd(x)),
        Container(
          width: hd(width),
          height: d(height),
          decoration: BoxDecoration(
            color: BubbaPrefsColors.travelCardBg,
            borderRadius: BorderRadius.circular(d(7.42)),
          ),
          child: Stack(
            children: [
              at(
                28.11,
                282,
                Container(
                  width: d(32),
                  height: d(32),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: BubbaPrefsColors.travelIconBg,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              at(
                37.03,
                292.26,
                const BubbaGlyphIcon(
                  BubbaPrefsGlyphs.planeMark,
                  color: BubbaPrefsColors.title,
                  width: 12.24,
                  height: 12.25,
                ),
              ),
              at(
                70.47,
                301.67 - eyebrowMetrics.baseline,
                Text('UPCOMING TRIP', style: BubbaPrefsText.eyebrow),
              ),
              if (showDoneLink)
                at(
                  308.96,
                  297.63 - actionMetrics.baseline,
                  BubbaTapTarget(
                    onTap: onDone,
                    label: 'Done',
                    child: Text('Done', style: BubbaPrefsText.tripAction),
                  ),
                ),
              at(
                353.06,
                290.35,
                BubbaTapTarget(
                  onTap: onDismiss,
                  label: 'Dismiss trip',
                  child: const BubbaGlyphIcon(
                    BubbaPrefsGlyphs.closeCross,
                    color: BubbaPrefsColors.title,
                    width: 7.57,
                    height: 7.42,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: d(319.10 - y)),
                  child: _TripFormCard(
                    destination: destination,
                    arrival: arrival,
                    x: 30.61 - x,
                    width: 335,
                    top: 0,
                    circleDx: 14.94,
                    glyphDx1: 26.04,
                    glyphDx2: 24.48,
                    textDx: 55.80,
                    chevronDx1: 303.66,
                    chevronDx2: 301.21,
                    ruleDx: 0,
                    ruleInset: 0,
                    onDestination: onDestination,
                    onArrival: onArrival,
                  ),
                ),
              ),
              if (showCta)
                at(
                  30.74,
                  457,
                  BubbaTapTarget(
                    onTap: onDone,
                    label: 'Done',
                    child: Container(
                      width: hd(334.37),
                      height: d(37),
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        color: BubbaPrefsColors.ctaDark,
                        borderRadius: BorderRadius.circular(d(11.39)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: dGap(481.20 - 457 - ctaMetrics.baseline),
                        ),
                        child: Text('Done', style: BubbaPrefsText.tripCta),
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
}

class _TripSummaryCard extends StatelessWidget {
  const _TripSummaryCard({
    required this.destination,
    required this.meta,
    this.onEdit,
    this.onDismiss,
  });

  final String destination;
  final String meta;
  final VoidCallback? onEdit;
  final VoidCallback? onDismiss;

  static const double y = 272;
  static const double height = 75;

  @override
  Widget build(BuildContext context) {
    final eyebrowMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.eyebrow);
    final nameMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.tripSummaryName);
    final metaMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.tripSummaryMeta);
    final editMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.tripActionSmall);

    Widget at(double left, double top, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: hdGap(left - _TripWrapper.x),
              top: dGap(top - y),
            ),
            child: child,
          ),
        );

    return Row(
      children: [
        SizedBox(width: hd(_TripWrapper.x)),
        Container(
          width: hd(_TripWrapper.width),
          height: d(height),
          decoration: BoxDecoration(
            color: BubbaPrefsColors.travelCardBg,
            borderRadius: BorderRadius.circular(d(7.42)),
          ),
          child: Stack(
            children: [
              at(
                28.11,
                295,
                Container(
                  width: d(32),
                  height: d(32),
                  decoration: const BoxDecoration(
                    color: BubbaPrefsColors.travelIconBg,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              at(
                37.03,
                305.26,
                const BubbaGlyphIcon(
                  BubbaPrefsGlyphs.planeMark,
                  color: BubbaPrefsColors.title,
                  width: 12.24,
                  height: 12.25,
                ),
              ),
              at(
                70.47,
                295.67 - eyebrowMetrics.baseline,
                Text('UPCOMING TRIP', style: BubbaPrefsText.eyebrow),
              ),
              at(
                70.47,
                317.04 - nameMetrics.baseline,
                Text(destination, style: BubbaPrefsText.tripSummaryName),
              ),
              at(
                70.47,
                336.13 - metaMetrics.baseline,
                Text(meta, style: BubbaPrefsText.tripSummaryMeta),
              ),
              at(
                321.74,
                314.36 - editMetrics.baseline,
                BubbaTapTarget(
                  onTap: onEdit,
                  label: 'Edit trip',
                  child: Text('Edit', style: BubbaPrefsText.tripActionSmall),
                ),
              ),
              at(
                355.06,
                307.35,
                BubbaTapTarget(
                  onTap: onDismiss,
                  label: 'Dismiss trip',
                  child: const BubbaGlyphIcon(
                    BubbaPrefsGlyphs.closeCross,
                    color: BubbaPrefsColors.title,
                    width: 7.57,
                    height: 7.42,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TravelRow extends StatelessWidget {
  const _TravelRow({
    required this.eyebrow,
    required this.label,
    required this.cardY,
    required this.eyebrowBaseline,
    required this.labelBaseline,
    required this.glyph,
    required this.glyphSize,
    this.onTap,
  });

  final String eyebrow;
  final String label;
  final double cardY;
  final double eyebrowBaseline;
  final double labelBaseline;
  final BubbaGlyph glyph;
  final Size glyphSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final eyebrowMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.eyebrow);
    final labelMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.travelRow);

    Widget at(double left, double y, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: hd(left), top: dGap(y - cardY)),
            child: child,
          ),
        );

    return Row(
      children: [
        SizedBox(width: hd(14.29)),
        Semantics(
          button: true,
          label: '$eyebrow, $label',
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              width: hd(359),
              height: d(64),
              decoration: BoxDecoration(
                color: BubbaPrefsColors.travelCardBg,
                borderRadius: BorderRadius.circular(d(7.42)),
              ),
              child: Stack(
                children: [
                  at(
                    26.29 - 14.29,
                    cardY + 16,
                    Container(
                      width: d(32),
                      height: d(32),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: BubbaPrefsColors.travelIconBg,
                        shape: BoxShape.circle,
                      ),
                      child: BubbaGlyphIcon(
                        glyph,
                        color: BubbaPrefsColors.title,
                        width: glyphSize.width,
                        height: glyphSize.height,
                      ),
                    ),
                  ),
                  at(
                    66.65 - 14.29,
                    eyebrowBaseline - eyebrowMetrics.baseline,
                    Text(eyebrow, style: BubbaPrefsText.eyebrow),
                  ),
                  at(
                    66.82 - 14.29,
                    labelBaseline - labelMetrics.baseline,
                    Text(label, style: BubbaPrefsText.travelRow),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: hd(14.29),
                        top: d(24),
                      ),
                      child: const BubbaGlyphIcon(
                        BubbaPrefsGlyphs.cardChevron,
                        color: BubbaPrefsColors.chevron,
                        width: 6.00,
                        height: 14.25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MatchPoolCard extends StatelessWidget {
  const _MatchPoolCard({
    required this.count,
    required this.verdict,
    required this.note,
    required this.filled,
    required this.mid,
  });

  final String count;
  final String verdict;
  final String note;
  final int filled;
  final int mid;

  static const int segments = 48;
  static const double segmentPitch = 6.918;
  static const double firstSegmentX = 32.58;

  @override
  Widget build(BuildContext context) {
    final eyebrowMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.eyebrow);
    final numberMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.impactNumber);
    final verdictMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.meterVerdict);
    final noteMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.impactNote);

    Widget at(double left, double y, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: hdGap(left - 18.97),
              top: dGap(y - _poolCardY),
            ),
            child: child,
          ),
        );

    return Row(
      children: [
        SizedBox(width: hd(18.97)),
        Container(
          width: hd(359),
          height: d(_poolCardH),
          decoration: BoxDecoration(
            color: BubbaPrefsColors.impactBg,
            borderRadius: BorderRadius.circular(d(15.20)),
          ),
          child: Stack(
            children: [
              at(
                32.85,
                690.18 - eyebrowMetrics.baseline,
                Text('YOUR MATCH POOL', style: BubbaPrefsText.eyebrow),
              ),
              at(
                30.38,
                728.16 - numberMetrics.baseline,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(count, style: BubbaPrefsText.impactNumber),
                    SizedBox(width: hd(BubbaPrefsMetrics.impactUnitGap)),
                    Text('people nearby', style: BubbaPrefsText.impactUnit),
                  ],
                ),
              ),
              at(
                302.50,
                729.93 - verdictMetrics.baseline,
                Text(verdict, style: BubbaPrefsText.meterVerdict),
              ),
              for (var i = 0; i < segments; i++)
                at(
                  firstSegmentX - 2.5 + segmentPitch * i,
                  747.27,
                  Container(
                    width: hd(5),
                    height: d(6),
                    color: i < filled
                        ? BubbaPrefsColors.meterFilled
                        : (i < filled + mid
                            ? BubbaPrefsColors.meterMid
                            : BubbaPrefsColors.meterEmpty),
                  ),
                ),
              at(
                30.96,
                779.87 - noteMetrics.baseline,
                Text(note, style: BubbaPrefsText.impactNote),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// p033 to p047 wired. The four summary rows render the live model and open
/// their own screens; the trip card walks its five states off what the trip
/// actually holds.
class BubbaPrefsSummaryHubScreen extends StatefulWidget {
  const BubbaPrefsSummaryHubScreen({super.key});

  @override
  State<BubbaPrefsSummaryHubScreen> createState() =>
      _BubbaPrefsSummaryHubScreenState();
}

class _BubbaPrefsSummaryHubScreenState
    extends State<BubbaPrefsSummaryHubScreen> {
  BubbaPrefsController get _controller => BubbaPrefsController.to;

  /// p046/p047 collapse to p043's summary once the trip is confirmed, and the
  /// form re-opens when Edit is tapped. That is the only state the screen owns
  /// rather than reading off the trip.
  bool _editing = false;

  static const List<PrefsFilterKind> _rowKinds = [
    PrefsFilterKind.sexuality,
    PrefsFilterKind.ageRange,
    PrefsFilterKind.maxDistance,
    PrefsFilterKind.height,
  ];

  PrefsTripCard _cardFor(TravelTrip trip) {
    if (_editing) return PrefsTripCard.form;
    if (trip.destination == null) return PrefsTripCard.cards;
    if (trip.arrivalDate == null) return PrefsTripCard.form;
    if (trip.isTraveling) return PrefsTripCard.summary;
    return PrefsTripCard.upcomingCta;
  }

  Future<void> _pickArrival(TravelTrip trip) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: trip.arrivalDate ?? now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      helpText: 'Arrival date',
    );

    if (picked == null) return;
    final ok = await _controller.setArrivalDate(picked);
    if (!ok) showPrefsError(_controller.travelError.value);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final trip = _controller.trip.value;
      final model = _controller.model;
      final arrival = trip.arrivalDate;

      return PrefsSummaryHubView(
        travel: trip.isTraveling,
        tripCard: _cardFor(trip),
        rows: [
          PrefsSummary(
            'LOOKING FOR',
            _controller.valueFor(PrefsFilterKind.sexuality),
            BubbaPrefsGlyphs.person,
            const Size(11.37, 12.94),
          ),
          PrefsSummary(
            'AGE RANGE',
            '${model.ageRange.start.round()} - ${model.ageRange.end.round()}',
            BubbaPrefsGlyphs.age,
            const Size(13.49, 13.49),
          ),
          PrefsSummary(
            'DISTANCE',
            '${model.maxDistance.round()} miles',
            BubbaPrefsGlyphs.pin,
            const Size(14.22, 18.29),
          ),
          PrefsSummary(
            'HEIGHT',
            _controller.valueFor(PrefsFilterKind.height),
            BubbaPrefsGlyphs.height,
            const Size(14.84, 14.84),
          ),
        ],
        destination: trip.destination?.label,
        arrival: arrival == null ? null : prefsArrivalLabel(arrival),
        tripMeta: arrival == null
            ? 'Arrival not set'
            : 'Arrives ${prefsShortArrival(arrival)}',
        onBack: Get.back,
        onMode: (value) async {
          if (value && trip.destination == null) {
            await Get.toNamed(Routes.BUBBA_PREFS_DESTINATION_SHEET);
            return;
          }
          final ok = await _controller.setTravelMode(value);
          if (!ok) showPrefsError(_controller.travelError.value);
        },
        onRow: (index) {
          if (index < _rowKinds.length) {
            prefsRouteFor(_rowKinds[index]).open();
          }
        },
        onDestination: () async {
          setState(() => _editing = true);
          await Get.toNamed(Routes.BUBBA_PREFS_CHOOSE_DESTINATION);
        },
        onArrival: () => _pickArrival(trip),
        onDone: () async {
          if (trip.destination == null || trip.arrivalDate == null) {
            showPrefsError('Set a destination and an arrival date first.');
            return;
          }
          setState(() => _editing = false);
          final ok = await _controller.setTravelMode(true);
          if (!ok) showPrefsError(_controller.travelError.value);
        },
        onDismiss: () async {
          setState(() => _editing = false);
          final ok = await _controller.clearTrip();
          if (!ok) showPrefsError(_controller.travelError.value);
        },
      );
    });
  }
}

const List<String> _weekdays = [
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
];

const List<String> _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// p042 draws `Sun, June 15`, p043 `Arrives Jun 15`. Two formats, one date.
String prefsArrivalLabel(DateTime date) =>
    '${_weekdays[date.weekday - 1]}, ${_months[date.month - 1]} ${date.day}';

String prefsShortArrival(DateTime date) =>
    '${_months[date.month - 1]} ${date.day}';

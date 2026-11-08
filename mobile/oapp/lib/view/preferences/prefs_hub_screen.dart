import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/design/bubba_glyphs.dart';
import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_prefs_glyphs.dart';
import '../../core/design/bubba_prefs_tokens.dart';
import '../../core/routing/app_routes.dart';
import 'bubba_prefs_controller.dart';
import 'prefs_feedback.dart';
import 'prefs_filter_routes.dart';
import 'widgets/prefs_chrome.dart';

class PrefsFilter {
  const PrefsFilter(this.label, this.value);
  final String label;
  final String value;
}

const List<PrefsFilter> prefsDefaultFilters = [
  PrefsFilter('Sexuality', 'Straight'),
  PrefsFilter('Location', 'Manhattan'),
  PrefsFilter('Age Range', '22 to 36'),
  PrefsFilter('Maximum Distance', '8 mi'),
  PrefsFilter('Height', 'Open to all'),
  PrefsFilter('Politics', 'Open to all'),
  PrefsFilter('Education', 'Open to all'),
  PrefsFilter('Languages', 'Open to all'),
  PrefsFilter('Ethnicity', 'Open to all'),
  PrefsFilter('Religion', 'Open to all'),
];

const double _headingBaseline = 104.59;
const double _modeEyebrow = 141.44;
const double _localLabel = 167.01;
const double _localValue = 184.76;
const double _modeRuleY = 200.02;
const double _travelLabel = 219.86;
const double _travelValue = 237.61;
const double _travelLink = 256.60;
const double _filtersEyebrow = 291.47;
const double _firstFilterLabel = 314.75;

/// p002 / p005 / p008 - the Dating Preferences hub. p008 is byte-identical to
/// p002; p005 is the Travel-on state, which swaps the two switches and adds the
/// `Change destination` link under the destination.
class PrefsHubView extends StatelessWidget {
  const PrefsHubView({
    super.key,
    this.travel = false,
    this.destination = 'New York City',
    this.filters = prefsDefaultFilters,
    this.onBack,
    this.onMode,
    this.onDestination,
    this.onFilter,
  });

  final bool travel;
  final String destination;
  final List<PrefsFilter> filters;
  final VoidCallback? onBack;
  final ValueChanged<bool>? onMode;
  final VoidCallback? onDestination;
  final ValueChanged<int>? onFilter;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: BubbaPrefsColors.pageBg,
        body: BubbaPage(
          padContent: false,
          background: BubbaPrefsColors.pageBg,
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

    final headingMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.heading);
    flow.block(
      Row(
        children: [
          SizedBox(width: hd(BubbaPrefsMetrics.headingX)),
          Text('Dating Preferences', style: BubbaPrefsText.heading),
        ],
      ),
      top: _headingBaseline - headingMetrics.baseline,
      height: headingMetrics.lineHeight,
    );

    final eyebrowMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.sectionHeader);
    flow.block(
      const PrefsEyebrow(label: 'MODE', x: 14.40),
      top: _modeEyebrow - eyebrowMetrics.baseline,
      height: eyebrowMetrics.lineHeight,
    );

    flow.block(
      _ModeRow(
        label: 'Local',
        value: 'Default',
        labelX: 14.18,
        valueX: 14.71,
        labelBaseline: _localLabel,
        valueBaseline: _localValue,
        blockTop: _localLabel,
        on: !travel,
        toggleY: travel ? 159.25 : 158.39,
        toggleX: travel ? 317.36 : 320.64,
        onChanged: onMode == null ? null : (v) => onMode!(!v),
      ),
      top: _localLabel - 14,
      height: _modeRuleY - (_localLabel - 14),
    );

    flow.block(
      const PrefsRule(x: 16.70, width: 374.46),
      top: _modeRuleY - 0.5,
      height: 1,
    );

    flow.block(
      _ModeRow(
        label: 'Travel',
        value: travel ? destination : 'Choose location',
        link: travel ? 'Change destination' : null,
        chevron: !travel,
        labelX: 15.41,
        valueX: 15.93,
        labelBaseline: _travelLabel,
        valueBaseline: _travelValue,
        linkBaseline: _travelLink,
        blockTop: _travelLabel,
        on: travel,
        toggleY: travel ? 214.39 : 214.25,
        toggleX: travel ? 320.64 : 317.36,
        onChanged: onMode,
        onLink: onDestination,
      ),
      top: _travelLabel - 14,
      height: _filtersEyebrow - eyebrowMetrics.baseline - (_travelLabel - 14),
    );

    flow.block(
      const PrefsEyebrow(label: 'FILTERS', x: 13.40),
      top: _filtersEyebrow - eyebrowMetrics.baseline,
      height: eyebrowMetrics.lineHeight,
    );

    final labelMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.rowLabel);
    for (var i = 0; i < filters.length; i++) {
      final baseline = _firstFilterLabel + BubbaPrefsMetrics.rowPitch * i;
      final top = baseline - labelMetrics.baseline;
      flow.block(
        _FilterRow(
          filter: filters[i],
          top: top,
          baseline: baseline,
          onTap: onFilter == null ? null : () => onFilter!(i),
        ),
        top: top,
        height: baseline + BubbaPrefsMetrics.rowRuleGap + 0.5 - top,
      );
    }
  }
}

class _ModeRow extends StatelessWidget {
  const _ModeRow({
    required this.label,
    required this.value,
    required this.labelX,
    required this.valueX,
    required this.labelBaseline,
    required this.valueBaseline,
    required this.blockTop,
    required this.on,
    required this.toggleY,
    required this.toggleX,
    this.link,
    this.linkBaseline,
    this.chevron = false,
    this.onChanged,
    this.onLink,
  });

  final String label;
  final String value;
  final String? link;
  final double labelX;
  final double valueX;
  final double labelBaseline;
  final double valueBaseline;
  final double? linkBaseline;
  final double blockTop;
  final bool on;
  final double toggleY;
  final double toggleX;
  final bool chevron;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onLink;

  @override
  Widget build(BuildContext context) {
    final origin = blockTop - 14;
    final labelMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.rowLabel);
    final valueMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.rowValue);

    Widget at(double left, double top, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: hd(left), top: dGap(top - origin)),
            child: child,
          ),
        );

    return Stack(
      children: [
        at(
          labelX,
          labelBaseline - labelMetrics.baseline,
          Text(label, style: BubbaPrefsText.rowLabel),
        ),
        at(
          valueX,
          valueBaseline - valueMetrics.baseline,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value, style: BubbaPrefsText.rowValue),
              if (chevron) ...[
                SizedBox(width: hd(5)),
                Padding(
                  padding: EdgeInsets.only(top: dGap(valueMetrics.baseline - 5.5)),
                  child: const BubbaGlyphIcon(
                    BubbaPrefsGlyphs.smallChevron,
                    color: BubbaPrefsColors.rowValue,
                    width: 3.36,
                    height: 5.94,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (link != null && linkBaseline != null)
          at(
            16.13,
            linkBaseline! - valueMetrics.baseline,
            BubbaTapTarget(
              onTap: onLink,
              label: link!,
              child: Text(
                link!,
                style: BubbaPrefsText.rowValue
                    .copyWith(color: const Color(0xFF226F96)),
              ),
            ),
          ),
        at(
          toggleX,
          toggleY,
          PrefsToggle(
            value: on,
            label: label,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.filter,
    required this.top,
    required this.baseline,
    this.onTap,
  });

  final PrefsFilter filter;
  final double top;
  final double baseline;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final labelMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.rowLabel);
    final valueMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.rowValue);

    Widget at(double left, double y, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: hd(left), top: dGap(y - top)),
            child: child,
          ),
        );

    return Semantics(
      button: true,
      label: '${filter.label}, ${filter.value}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Stack(
          children: [
            at(
              BubbaPrefsMetrics.contentX,
              baseline - labelMetrics.baseline,
              Text(filter.label, style: BubbaPrefsText.rowLabel),
            ),
            at(
              BubbaPrefsMetrics.contentX,
              baseline +
                  BubbaPrefsMetrics.rowValueGap -
                  valueMetrics.baseline,
              Text(filter.value, style: BubbaPrefsText.rowValue),
            ),
            at(
              BubbaPrefsMetrics.rowChevronX,
              baseline + BubbaPrefsMetrics.rowChevronGap,
              const BubbaGlyphIcon(
                BubbaPrefsGlyphs.rowChevron,
                color: BubbaPrefsColors.chevron,
                width: 6.00,
                height: 10.60,
              ),
            ),
            at(
              BubbaPrefsMetrics.ruleX,
              baseline + BubbaPrefsMetrics.rowRuleGap - 0.5,
              SizedBox(
                width: hd(BubbaPrefsMetrics.ruleWidth),
                height: d(1),
                child: const BubbaHairline(color: BubbaPrefsColors.divider),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const List<PrefsFilterKind> prefsHubFilterOrder = [
  PrefsFilterKind.sexuality,
  PrefsFilterKind.location,
  PrefsFilterKind.ageRange,
  PrefsFilterKind.maxDistance,
  PrefsFilterKind.height,
  PrefsFilterKind.politics,
  PrefsFilterKind.education,
  PrefsFilterKind.languages,
  PrefsFilterKind.ethnicity,
  PrefsFilterKind.religion,
];

class BubbaPrefsHubScreen extends StatelessWidget {
  const BubbaPrefsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = BubbaPrefsController.to;

    return Obx(() {
      final trip = controller.trip.value;
      controller.prefs.value;

      return PrefsHubView(
        travel: trip.isTraveling,
        destination: trip.destination?.label ?? 'Choose location',
        filters: [
          for (final kind in prefsHubFilterOrder)
            PrefsFilter(kind.label, controller.valueFor(kind)),
        ],
        onBack: Get.back,
        onMode: (value) async {
          if (value && trip.destination == null) {
            await Get.toNamed(Routes.BUBBA_PREFS_DESTINATION_SHEET);
            return;
          }
          final ok = await controller.setTravelMode(value);
          if (!ok) showPrefsError(controller.travelError.value);
        },
        onDestination: () => Get.toNamed(Routes.BUBBA_PREFS_DESTINATION_SHEET),
        onFilter: (index) => prefsRouteFor(prefsHubFilterOrder[index]).open(),
      );
    });
  }
}


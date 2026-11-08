import 'package:flutter/material.dart';

import '../../../core/design/bubba_glyphs.dart';
import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_prefs_glyphs.dart';
import '../../../core/design/bubba_prefs_tokens.dart';

/// The back chevron, centred title and optional Reset link every part 4 screen
/// carries. The 0.5pt rule under it is drawn only where the artboard has one.
class PrefsNavBar extends StatelessWidget {
  const PrefsNavBar({
    super.key,
    this.title,
    this.titleStyle,
    this.titleBaseline = BubbaPrefsMetrics.navTitleBaseline,
    this.backY = BubbaPrefsMetrics.navBackY,
    this.showBack = true,
    this.resetLabel,
    this.divider = false,
    this.onBack,
    this.onReset,
  });

  final String? title;
  final TextStyle? titleStyle;
  final double titleBaseline;
  final double backY;
  final bool showBack;
  final String? resetLabel;
  final bool divider;
  final VoidCallback? onBack;
  final VoidCallback? onReset;

  static const double height = 84;

  @override
  Widget build(BuildContext context) {
    final style = titleStyle ?? BubbaPrefsText.navTitle;
    final titleMetrics = bubbaDesignTextMetrics(context, style);
    final resetMetrics = bubbaDesignTextMetrics(context, BubbaPrefsText.reset);

    Widget at(double left, double top, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: hd(left), top: d(top)),
            child: child,
          ),
        );

    return SizedBox(
      height: d(height),
      child: Stack(
        children: [
          if (showBack)
            at(
              BubbaPrefsMetrics.navBackX,
              backY,
              BubbaTapTarget(
                onTap: onBack,
                label: 'Back',
                child: const BubbaGlyphIcon(
                  BubbaPrefsGlyphs.navBack,
                  color: BubbaPrefsColors.navIcon,
                  width: BubbaPrefsMetrics.navBackWidth,
                  height: BubbaPrefsMetrics.navBackHeight,
                ),
              ),
            ),
          if (title != null)
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding:
                    EdgeInsets.only(top: dGap(titleBaseline - titleMetrics.baseline)),
                child: Text(title!, style: style),
              ),
            ),
          if (resetLabel != null)
            at(
              337.05,
              titleBaseline + 0.16 - resetMetrics.baseline,
              BubbaTapTarget(
                onTap: onReset,
                label: resetLabel!,
                child: Text(resetLabel!, style: BubbaPrefsText.reset),
              ),
            ),
          if (divider)
            at(
              5.74,
              BubbaPrefsMetrics.navDividerY - 0.25,
              SizedBox(
                width: hd(384),
                height: d(0.5),
                child: const BubbaHairline(color: BubbaPrefsColors.navDivider),
              ),
            ),
        ],
      ),
    );
  }
}

/// `MODE`, `FILTERS`, `QUICK OPTIONS`, `NON-NEGOTIABLE` - the same eyebrow at
/// two sizes. The artboard sets the section headers at 12 and the eyebrows at
/// 10, so the caller picks the style.
class PrefsEyebrow extends StatelessWidget {
  const PrefsEyebrow({
    super.key,
    required this.label,
    required this.x,
    this.style,
  });

  final String label;
  final double x;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          SizedBox(width: hd(x)),
          Text(label, style: style ?? BubbaPrefsText.sectionHeader),
        ],
      );
}

/// The part 4 switch. Same 54.19 x 23.87 stadium as part 3, with a wider knob
/// and a per-screen on colour.
class PrefsToggle extends StatelessWidget {
  const PrefsToggle({
    super.key,
    required this.value,
    this.onColour = BubbaPrefsColors.toggleOn,
    this.onChanged,
    this.label,
  });

  final bool value;
  final Color onColour;
  final ValueChanged<bool>? onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final track = SizedBox(
      width: hd(BubbaPrefsMetrics.toggleWidth),
      height: d(BubbaPrefsMetrics.toggleHeight),
      child: Stack(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: value ? onColour : BubbaPrefsColors.toggleOff,
              borderRadius:
                  BorderRadius.circular(d(BubbaPrefsMetrics.toggleRadius)),
            ),
            child: const SizedBox.expand(),
          ),
          Align(
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: value ? 0 : hd(BubbaPrefsMetrics.knobInsetLeft),
                right: value ? hd(BubbaPrefsMetrics.knobInsetRight) : 0,
              ),
              child: Container(
                width: hd(BubbaPrefsMetrics.knobWidth),
                height: d(BubbaPrefsMetrics.knobHeight),
                decoration: BoxDecoration(
                  color: BubbaPrefsColors.onDark,
                  borderRadius:
                      BorderRadius.circular(d(BubbaPrefsMetrics.knobRadius)),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Semantics(
      toggled: value,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onChanged == null ? null : () => onChanged!(!value),
        child: track,
      ),
    );
  }
}

/// A hairline that keeps its own width under a stretched column (P3-3).
class PrefsRule extends StatelessWidget {
  const PrefsRule({
    super.key,
    required this.x,
    required this.width,
    this.colour = BubbaPrefsColors.divider,
    this.weight = 1,
  });

  final double x;
  final double width;
  final Color colour;
  final double weight;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          SizedBox(width: hd(x)),
          Flexible(
            child: SizedBox(
              width: hd(width),
              height: d(weight),
              child: BubbaHairline(color: colour),
            ),
          ),
        ],
      );
}

/// An unselected ring or a filled dot - p001's radio.
class PrefsRadio extends StatelessWidget {
  const PrefsRadio({super.key, required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: d(BubbaPrefsMetrics.radioSize),
        height: d(BubbaPrefsMetrics.radioSize),
        child: selected
            ? Container(
                decoration: const BoxDecoration(
                  color: BubbaPrefsColors.radioOn,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Container(
                  width: d(BubbaPrefsMetrics.radioDot),
                  height: d(BubbaPrefsMetrics.radioDot),
                  decoration: const BoxDecoration(
                    color: BubbaPrefsColors.onDark,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            : DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: BubbaPrefsColors.controlBorder,
                    width: d(1),
                  ),
                ),
                child: const SizedBox.expand(),
              ),
      );
}

/// p017's rounded checkbox.
class PrefsCheckbox extends StatelessWidget {
  const PrefsCheckbox({super.key, required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: d(BubbaPrefsMetrics.checkboxSize),
        height: d(BubbaPrefsMetrics.checkboxSize),
        child: selected
            ? Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: BubbaPrefsColors.checkOn,
                  borderRadius: BorderRadius.circular(
                    d(BubbaPrefsMetrics.checkboxRadius),
                  ),
                ),
                child: const BubbaGlyphIcon(
                  BubbaPrefsGlyphs.checkTick,
                  color: BubbaPrefsColors.onDark,
                  width: 11.86,
                  height: 8.49,
                ),
              )
            : DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    d(BubbaPrefsMetrics.checkboxRadius),
                  ),
                  border: Border.all(
                    color: BubbaPrefsColors.controlBorder,
                    width: d(1),
                  ),
                ),
                child: const SizedBox.expand(),
              ),
      );
}

/// The `IMPACT OF THIS FILTER` card, on five artboards.
class PrefsImpactCard extends StatelessWidget {
  const PrefsImpactCard({
    super.key,
    this.count = '-2,900',
    this.unit = 'matches',
    this.note = 'Approximately 23% of your filtered match pool',
  });

  final String count;
  final String unit;
  final String note;

  static const double cardY = 705.96;

  @override
  Widget build(BuildContext context) {
    final titleMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.impactTitle);
    final numberMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.impactNumber);
    final noteMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.impactNote);

    Widget at(double left, double top, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: hd(left), top: d(top)),
            child: child,
          ),
        );

    return Row(
      children: [
        SizedBox(width: hd(BubbaPrefsMetrics.impactX)),
        Container(
          width: hd(BubbaPrefsMetrics.impactWidth),
          height: d(BubbaPrefsMetrics.impactHeight),
          decoration: BoxDecoration(
            color: BubbaPrefsColors.impactBg,
            borderRadius:
                BorderRadius.circular(d(BubbaPrefsMetrics.impactRadius)),
          ),
          child: Stack(
            children: [
              at(
                19.95,
                25.05,
                const BubbaGlyphIcon(
                  BubbaPrefsGlyphs.impactChart,
                  color: BubbaPrefsColors.title,
                  width: 21.76,
                  height: 21.69,
                ),
              ),
              at(
                52.88,
                33.17 - titleMetrics.baseline,
                Text('IMPACT OF THIS FILTER',
                    style: BubbaPrefsText.impactTitle),
              ),
              at(
                50.40,
                75.15 - numberMetrics.baseline,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(count, style: BubbaPrefsText.impactNumber),
                    SizedBox(width: hd(BubbaPrefsMetrics.impactUnitGap)),
                    Text(unit, style: BubbaPrefsText.impactUnit),
                  ],
                ),
              ),
              at(
                50.98,
                104.86 - noteMetrics.baseline,
                Text(note, style: BubbaPrefsText.impactNote),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The full-width dark CTA parts 4 and 5 use at the foot of a sheet.
class PrefsCtaButton extends StatelessWidget {
  const PrefsCtaButton({
    super.key,
    required this.label,
    required this.x,
    required this.width,
    this.height = 47,
    this.radius = 8,
    this.fill = BubbaPrefsColors.ctaDark,
    this.labelDrop,
    this.onTap,
  });

  final String label;
  final double x;
  final double width;
  final double height;
  final double radius;
  final Color fill;
  final double? labelDrop;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final metrics = bubbaDesignTextMetrics(context, BubbaPrefsText.ctaLabel);
    final drop =
        labelDrop ?? (height - metrics.lineHeight) / 2;
    return Row(
      children: [
        SizedBox(width: hd(x)),
        BubbaTapTarget(
          onTap: onTap,
          label: label,
          child: Container(
            width: hd(width),
            height: d(height),
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(d(radius)),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: d(drop)),
              child: Text(label, style: BubbaPrefsText.ctaLabel),
            ),
          ),
        ),
      ],
    );
  }
}

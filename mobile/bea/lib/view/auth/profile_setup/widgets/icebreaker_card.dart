import 'package:flutter/material.dart';

import '../../../../core/design/bubba_layout.dart';
import '../../../../core/design/bubba_icons.dart';
import '../../../../core/design/bubba_text_styles.dart';
import '../../../../core/design/bubba_tokens.dart';
import '../models/icebreaker_entry.dart';

const double _cardRadius = 12.41;
const double _pad = 20.3;
const double _headerHeight = 50.0;
const double _kindBaseline = 24.72;
const double _titleBaseline = 46.79;
const double _pencilRight = 10.69;
const double _pencilTop = 19.4;
const double _pencilSize = 18.94;

const double _dividerLeft = 22.5;
const double _dividerRight = 40.5;
const Color _dividerColor = Color(0xFFEFF0F0);
const Color _wellColor = Color(0xFFF4F4F3);

/// A filled icebreaker on "Your icebreakers" (p042, p048, p049, p050, p053).
///
/// Card chrome is shared; the block under the title comes from [entry]'s type.
/// Heights here are content driven rather than pinned to the mock: the design's
/// two-line rows are ~9pt tighter than its own 18pt leading allows, so real
/// answers would clip if the frames were copied literally. Single-line rows,
/// which is what every other measurement keys off, match the mock exactly.
class IcebreakerCard extends StatelessWidget {
  const IcebreakerCard({super.key, required this.entry, this.onEdit});

  final IcebreakerEntry entry;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final pencil = _PencilButton(label: entry.title, onTap: onEdit);
    return Container(
      width: BubbaScale.contentWidth,
      decoration: BoxDecoration(
        color: BubbaColors.surface,
        borderRadius: BorderRadius.circular(d(_cardRadius)),
        border: Border.all(color: BubbaColors.border, width: 1),
      ),
      child: switch (entry) {
        SnapIcebreaker e => _SnapLayout(entry: e, pencil: pencil),
        _ => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _Header(
              kind: entry.kindLabel,
              title: entry.title,
              pencil: pencil,
            ),
            ..._blocks(entry),
          ],
        ),
      },
    );
  }
}

const double _pencilHit = 6;
const double _pencilGap = 10.3;

class _PencilButton extends StatelessWidget {
  const _PencilButton({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(
      top: d(_pencilTop - _pencilHit),
      right: hd(_pencilRight - _pencilHit),
    ),
    child: Semantics(
      button: true,
      label: 'Edit $label',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(d(_pencilHit)),
          child: const BubbaPencil(size: _pencilSize),
        ),
      ),
    ),
  );
}

/// The blocks under the header, in flow order, per entry type.
List<Widget> _blocks(IcebreakerEntry entry) => switch (entry) {
  PromptIcebreaker e => [
    _Body(e.answer, topGap: 6.55),
    SizedBox(height: d(14.1)),
  ],
  SnapIcebreaker _ => const [],
  MultipleChoiceIcebreaker e => [
    _Body(e.statement, topGap: 8.07),
    SizedBox(height: d(17.55)),
    ..._optionBoxes(e.options, left: 23.30, right: 27.72, gap: 7.2),
    SizedBox(height: d(31.2)),
  ],
  TwoTruthsIcebreaker e => [
    SizedBox(height: d(9.29)),
    ..._markerRows(e.statements),
    SizedBox(height: d(4.56)),
  ],
  RankOrderIcebreaker e => [
    _Body(e.caption, topGap: 3.37),
    SizedBox(height: d(12.3)),
    ..._rankRows(e.statements),
    SizedBox(height: d(11.12)),
  ],
  WouldYouRatherIcebreaker e => [
    SizedBox(height: d(14.22)),
    _OptionBox(marker: 'A', text: e.optionA, left: 17.51, right: 29.39),
    SizedBox(height: d(4.03)),
    const _OrDivider(),
    SizedBox(height: d(4.03)),
    _OptionBox(marker: 'B', text: e.optionB, left: 17.51, right: 29.39),
    SizedBox(height: d(14.01)),
  ],
  RateThisIcebreaker e => [
    _Body(e.caption, topGap: 3.49),
    SizedBox(height: d(8.37)),
    _RatePhoto(image: e.image),
    _RateSlider(entry: e),
    SizedBox(height: d(16.05)),
  ],
  ThisOrThatIcebreaker e => [
    SizedBox(height: d(8.31)),
    ..._pairRows(e.pairs),
    SizedBox(height: d(6.5)),
  ],
  GreenRedFlagIcebreaker e => [
    _Body(e.statement, topGap: 6.3),
    SizedBox(height: d(15.19)),
    _FlagTiles(entry: e),
    SizedBox(height: d(13.54)),
  ],
  FinishSentenceIcebreaker e => [
    _FinishBlank(stem: e.stem),
    SizedBox(height: d(24.24)),
  ],
};

class _Header extends StatelessWidget {
  const _Header({required this.kind, required this.title, required this.pencil});

  final String kind;
  final String title;
  final Widget pencil;

  @override
  Widget build(BuildContext context) {
    final kindMetrics = bubbaDesignTextMetrics(context, BubbaText.cardKind);
    final titleMetrics = bubbaDesignTextMetrics(context, BubbaText.cardTitle);
    final tail = _headerHeight - _titleBaseline - titleMetrics.descent;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: hd(_pad)),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BubbaCopy(kind, gapAbove: _kindBaseline, style: BubbaText.cardKind),
              Baseline(
                baseline:
                    d(_titleBaseline - _kindBaseline - kindMetrics.descent),
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: BubbaText.cardTitle,
                ),
              ),
              if (tail > 0) BubbaGap(tail),
            ],
          ),
        ),
        SizedBox(width: hd(_pencilGap)),
        pencil,
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body(this.text, {required this.topGap});

  final String text;
  final double topGap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(left: hd(_pad), right: hd(_pad), top: d(topGap)),
    child: BubbaMeasure(child: Text(text, style: BubbaText.cardBody)),
  );
}

// ---------------------------------------------------------------------------
// Multiple choice / would you rather
// ---------------------------------------------------------------------------

List<Widget> _optionBoxes(
  List<String> options, {
  required double left,
  required double right,
  required double gap,
}) {
  const markers = ['A', 'B', 'C', 'D', 'E'];
  final out = <Widget>[];
  for (var i = 0; i < options.length; i++) {
    if (i > 0) out.add(SizedBox(height: d(gap)));
    out.add(
      _OptionBox(
        marker: i < markers.length ? markers[i] : '${i + 1}',
        text: options[i],
        left: left,
        right: right,
      ),
    );
  }
  return out;
}

const double _optionMinHeight = 40.39;
const double _optionVerticalPad = 6.68;
const double _optionCircle = 25.03;
const double _optionCircleInset = 9.66;
const double _optionTextInset = 43.61;

class _OptionBox extends StatelessWidget {
  const _OptionBox({
    required this.marker,
    required this.text,
    required this.left,
    required this.right,
  });

  final String marker;
  final String text;
  final double left;
  final double right;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(left: hd(left), right: hd(right)),
    child: Container(
      constraints: BoxConstraints(minHeight: d(_optionMinHeight)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(d(5.07)),
        border: Border.all(color: _wellColor, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: d(_optionVerticalPad)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: hd(_optionCircleInset)),
            _MarkerCircle(label: marker, size: _optionCircle),
            SizedBox(
              width: hd(_optionTextInset - _optionCircleInset - _optionCircle),
            ),
            Expanded(
              child: BubbaMeasure(
                child: Text(text, style: BubbaText.cardOption),
              ),
            ),
            SizedBox(width: hd(10)),
          ],
        ),
      ),
    ),
  );
}

class _MarkerCircle extends StatelessWidget {
  const _MarkerCircle({
    required this.label,
    required this.size,
    this.style,
  });

  final String label;
  final double size;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) => Container(
    width: d(size),
    height: d(size),
    alignment: Alignment.center,
    decoration: const BoxDecoration(color: _wellColor, shape: BoxShape.circle),
    child: Text(label, style: style ?? BubbaText.cardOptionMarker),
  );
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(left: hd(19.08), right: hd(29.59)),
    child: Row(
      children: [
        Expanded(child: Container(height: 1, color: _dividerColor)),
        SizedBox(width: hd(19)),
        Container(
          width: d(_optionCircle),
          height: d(_optionCircle),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFFF0ECE9),
            shape: BoxShape.circle,
          ),
          child: Text('OR', style: BubbaText.cardOrBadge),
        ),
        SizedBox(width: hd(19)),
        Expanded(child: Container(height: 1, color: _dividerColor)),
      ],
    ),
  );
}

// ---------------------------------------------------------------------------
// Two truths & a lie
// ---------------------------------------------------------------------------

const double _markerRowPad = 12.67;
const double _markerCircleInset = 21.64;
const double _markerTextInset = 55.59;

List<Widget> _markerRows(List<String> statements) {
  final out = <Widget>[];
  for (var i = 0; i < statements.length; i++) {
    if (i > 0) {
      out.add(
        Padding(
          padding: EdgeInsets.only(left: hd(_dividerLeft), right: hd(_dividerRight)),
          child: Container(height: 1, color: _dividerColor),
        ),
      );
    }
    out.add(
      Padding(
        padding: EdgeInsets.only(
          top: d(_markerRowPad),
          bottom: d(_markerRowPad),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: hd(_markerCircleInset)),
            _MarkerCircle(label: '${i + 1}', size: _optionCircle),
            SizedBox(
              width: hd(_markerTextInset - _markerCircleInset - _optionCircle),
            ),
            Expanded(
              child: BubbaMeasure(
                child: Text(statements[i], style: BubbaText.cardOption),
              ),
            ),
            SizedBox(width: hd(_dividerRight)),
          ],
        ),
      ),
    );
  }
  return out;
}

// ---------------------------------------------------------------------------
// Rank order
// ---------------------------------------------------------------------------

const double _rankRowLeft = 13.43;
const double _rankRowRight = 20.35;
const double _rankRowHeight = 45.73;
const double _rankGap = 7.47;
const double _rankHandleInset = 11.91;
const double _rankCircleInset = 37.45;
const double _rankCircle = 27.17;
const double _rankTextInset = 79.5;

List<Widget> _rankRows(List<String> statements) {
  final out = <Widget>[];
  for (var i = 0; i < statements.length; i++) {
    if (i > 0) out.add(SizedBox(height: d(_rankGap)));
    out.add(
      Padding(
        padding: EdgeInsets.only(left: hd(_rankRowLeft), right: hd(_rankRowRight)),
        child: Container(
          constraints: BoxConstraints(minHeight: d(_rankRowHeight)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(d(11.40)),
            border: Border.all(color: _wellColor, width: 1),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: d(8.28)),
            child: Row(
              children: [
                SizedBox(width: hd(_rankHandleInset)),
                const _DragHandle(),
                SizedBox(
                  width: hd(_rankCircleInset - _rankHandleInset - 12.33),
                ),
                _MarkerCircle(
                  label: '${i + 1}',
                  size: _rankCircle,
                  style: BubbaText.cardRankMarker,
                ),
                SizedBox(
                  width: hd(_rankTextInset - _rankCircleInset - _rankCircle),
                ),
                Expanded(
                  child: BubbaMeasure(
                    child: Text(statements[i], style: BubbaText.cardRankValue),
                  ),
                ),
                SizedBox(width: hd(10)),
              ],
            ),
          ),
        ),
      ),
    );
  }
  return out;
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size(d(12.33), d(19.73)),
    painter: const _DragHandlePainter(),
  );
}

class _DragHandlePainter extends CustomPainter {
  const _DragHandlePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = const Color(0xFFD6D6D6);
    final r = size.width * 0.145;
    for (var row = 0; row < 3; row++) {
      for (var col = 0; col < 2; col++) {
        canvas.drawCircle(
          Offset(
            r + col * (size.width - 2 * r),
            r + row * (size.height - 2 * r) / 2,
          ),
          r,
          p,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_DragHandlePainter old) => false;
}

// ---------------------------------------------------------------------------
// This or that
// ---------------------------------------------------------------------------

const double _pairPad = 13.64;

List<Widget> _pairRows(List<(String, String)> pairs) {
  final out = <Widget>[];
  for (var i = 0; i < pairs.length; i++) {
    if (i > 0) {
      out.add(
        Padding(
          padding: EdgeInsets.only(
            left: hd(_dividerLeft),
            right: hd(_dividerRight),
          ),
          child: Container(height: 1, color: _dividerColor),
        ),
      );
    }
    out.add(
      Padding(
        padding: EdgeInsets.only(
          top: d(_pairPad),
          bottom: d(_pairPad),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: hd(22.48)),
            _MarkerCircle(label: '${i + 1}', size: _optionCircle),
            SizedBox(width: hd(70.11 - 22.48 - _optionCircle)),
            Expanded(
              flex: 108,
              child: Text(pairs[i].$1, style: BubbaText.cardOption),
            ),
            SizedBox(
              width: hd(30),
              child: Text(
                'or',
                textAlign: TextAlign.center,
                style: BubbaText.cardOrInline,
              ),
            ),
            const Expanded(flex: 51, child: SizedBox.shrink()),
            SizedBox(
              width: hd(66),
              child: Text(pairs[i].$2, style: BubbaText.cardOption),
            ),
          ],
        ),
      ),
    );
  }
  return out;
}

// ---------------------------------------------------------------------------
// Rate this
// ---------------------------------------------------------------------------

class _RatePhoto extends StatelessWidget {
  const _RatePhoto({this.image});

  final ImageProvider? image;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(left: hd(22.7), right: hd(22.7)),
    child: AspectRatio(
      aspectRatio: 306.3 / 160.7,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF0EFEE),
          borderRadius: BorderRadius.circular(d(4)),
          image: image == null
              ? null
              : DecorationImage(image: image!, fit: BoxFit.cover),
        ),
      ),
    ),
  );
}

const double _sliderLeft = 27.07;
const double _sliderRight = 15.19;
const double _sliderKnob = 21.56;
const double _sliderValueHeight = 23.2;

class _RateSlider extends StatelessWidget {
  const _RateSlider({required this.entry});

  final RateThisIcebreaker entry;

  @override
  Widget build(BuildContext context) {
    final t = (entry.value / entry.steps).clamp(0.0, 1.0);
    final align = Alignment(t * 2 - 1, 0);
    return Padding(
      padding: EdgeInsets.only(left: hd(_sliderLeft), right: hd(_sliderRight)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: d(_sliderValueHeight),
            child: Align(
              alignment: align,
              child: SizedBox(
                width: hd(40),
                child: Text(
                  entry.value.toStringAsFixed(1),
                  textAlign: TextAlign.center,
                  style: BubbaText.cardRateValue,
                ),
              ),
            ),
          ),
          SizedBox(
            height: d(_sliderKnob),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(height: 2, color: const Color(0xFFEFEFEF)),
                Row(
                  children: [
                    for (var i = 0; i < entry.steps; i++) ...[
                      if (i > 0)
                        Container(
                          width: 1,
                          height: d(7.81),
                          color: const Color(0xFFEFEFEF),
                        ),
                      const Expanded(child: SizedBox.shrink()),
                    ],
                  ],
                ),
                FractionallySizedBox(
                  widthFactor: t,
                  child: Container(height: 2, color: const Color(0xFF3D6BAF)),
                ),
                Align(
                  alignment: align,
                  child: Container(
                    width: d(_sliderKnob),
                    height: d(_sliderKnob),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: BubbaColors.surface,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD8D8D8),
                        width: 1,
                      ),
                    ),
                    child: Container(
                      width: d(6.42),
                      height: d(6.42),
                      decoration: const BoxDecoration(
                        color: Color(0xFF3D6BAF),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: d(4.5)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(entry.lowLabel, style: BubbaText.cardRateEdge),
              Text(entry.highLabel, style: BubbaText.cardRateEdge),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Green or red flag
// ---------------------------------------------------------------------------

class _FlagTiles extends StatelessWidget {
  const _FlagTiles({required this.entry});

  final GreenRedFlagIcebreaker entry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(left: hd(62.69), right: hd(50.5)),
    child: Row(
      children: [
        Expanded(
          child: _FlagTile(
            label: entry.greenLabel,
            asset: greenFlagAsset,
            width: 66.4,
            height: 80.0,
            top: 10.37,
          ),
        ),
        SizedBox(width: hd(12.44)),
        Expanded(
          child: _FlagTile(
            label: entry.redLabel,
            asset: redFlagAsset,
            width: 59.8,
            height: 79.4,
            top: 10.77,
          ),
        ),
      ],
    ),
  );
}

const double _flagLabelBaseline = 102.11;

/// p050 draws both flags as placed rasters, recovered from the .ai file.
const String greenFlagAsset = 'assets/images/bubba_flag_green.png';
const String redFlagAsset = 'assets/images/bubba_flag_red.png';

class _FlagTile extends StatelessWidget {
  const _FlagTile({
    required this.label,
    required this.asset,
    required this.width,
    required this.height,
    required this.top,
  });

  final String label;
  final String asset;
  final double width;
  final double height;
  final double top;

  @override
  Widget build(BuildContext context) => Container(
    constraints: BoxConstraints(minHeight: d(126.42)),
    decoration: BoxDecoration(
      color: const Color(0xFFF8F6F6),
      borderRadius: BorderRadius.circular(d(11.25)),
      border: Border.all(color: _dividerColor, width: 1),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BubbaGap(top),
        Center(
          child: Image.asset(
            asset,
            width: hd(width),
            height: d(height),
            fit: BoxFit.fill,
          ),
        ),
        BubbaCopy(
          label,
          gapAbove: _flagLabelBaseline - top - height,
          style: BubbaText.cardFlagLabel,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

// ---------------------------------------------------------------------------
// Finish the sentence
// ---------------------------------------------------------------------------

class _FinishBlank extends StatelessWidget {
  const _FinishBlank({required this.stem});

  final String stem;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(left: hd(_pad), right: hd(_pad), top: d(11.76)),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(child: Text(stem, style: BubbaText.cardBody)),
        SizedBox(width: hd(12)),
        SizedBox(
          width: hd(83.75),
          child: SizedBox(
            height: d(16.8),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: d(2.5)),
                child: Container(height: 1, color: const Color(0xFF050505)),
              ),
            ),
          ),
        ),
        SizedBox(width: hd(27)),
      ],
    ),
  );
}

// ---------------------------------------------------------------------------
// Snap
// ---------------------------------------------------------------------------

const double _snapHeight = 121.7;
const double _snapThumbLeft = 9.3;
const double _snapThumbTop = 11.5;
const double _snapThumbWidth = 80.5;
const double _snapThumbHeight = 99;
const double _snapTextLeft = 111.56;
const double _snapKindBaseline = 44.85;
const double _snapTitleBaseline = 67.56;
const double _snapCaptionBaseline = 90.94;

class _SnapLayout extends StatelessWidget {
  const _SnapLayout({required this.entry, required this.pencil});

  final SnapIcebreaker entry;
  final Widget pencil;

  @override
  Widget build(BuildContext context) {
    final kindMetrics = bubbaDesignTextMetrics(context, BubbaText.cardKind);
    final titleMetrics = bubbaDesignTextMetrics(context, BubbaText.cardTitle);
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: d(_snapHeight)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // An empty grey rectangle reads as a photo that failed to load, so a
          // snap with no picture drops the slot instead of drawing one.
          if (entry.image != null) ...[
            SizedBox(width: hd(_snapThumbLeft)),
            Padding(
              padding: EdgeInsets.only(top: d(_snapThumbTop)),
              child: Container(
                width: hd(_snapThumbWidth),
                height: d(_snapThumbHeight),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EFEE),
                  borderRadius: BorderRadius.circular(d(4)),
                  image: DecorationImage(
                    image: entry.image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: hd(_snapTextLeft - _snapThumbLeft - _snapThumbWidth),
            ),
          ] else
            SizedBox(width: hd(_snapThumbLeft)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                BubbaCopy(
                  entry.kindLabel,
                  gapAbove: _snapKindBaseline,
                  style: BubbaText.cardKind,
                ),
                BubbaCopy(
                  entry.title,
                  gapAbove: _snapTitleBaseline -
                      _snapKindBaseline -
                      kindMetrics.descent,
                  style: BubbaText.cardTitle,
                  maxLines: 1,
                ),
                BubbaCopy(
                  entry.caption,
                  gapAbove: _snapCaptionBaseline -
                      _snapTitleBaseline -
                      titleMetrics.descent,
                  style: BubbaText.cardBody,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          SizedBox(width: hd(_pencilGap)),
          pencil,
        ],
      ),
    );
  }
}

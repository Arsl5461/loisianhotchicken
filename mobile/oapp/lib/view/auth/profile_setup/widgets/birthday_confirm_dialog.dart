import 'package:flutter/material.dart';

import '../../../../core/design/bubba_layout.dart';
import '../../../../core/design/bubba_text_styles.dart';
import '../../../../core/design/bubba_tokens.dart';

const double _cardWidth = 310.20;
const double _cardHeight = 407.10;
const double _cardRadius = 25.29;

/// Offsets inside the card, so the card can be centred without re-deriving
/// every baseline. p022 draws the card 4.75pt left of the canvas centre and
/// then centres its own contents on the card; only "Edit my birthday" is
/// centred on the canvas, which reads as the slip. Normalised to centred.
const double _badgeCentreY = 44.98;
const double _badgeOuter = 39.44;
const double _badgeInner = 17.49;
const double _titleBaseline = 97.49;
const double _dateBaseline = 134.27;
const double _ageBaseline = 167.94;
const double _dividerY = 187.22;
const double _dividerInset = 29.74;
const double _copyFirstBaseline = 227.78;
const double _copySecondBaseline = 248.78;
const double _ctaInset = 21.94;
const double _ctaY = 282.57;
const double _ctaHeight = 58.0;
const double _ctaRadius = 11.39;
const double _ctaBaseline = 35.21;
const double _editBaseline = 370.81;
const double _cardBottom = 843 - (233.78 + 407.10);

/// p022 - the "Confirm your birthday" card over the birthday step.
class BubbaBirthdayConfirmDialog extends StatelessWidget {
  const BubbaBirthdayConfirmDialog({
    super.key,
    required this.dateLabel,
    required this.age,
    this.onConfirm,
    this.onEdit,
  });

  final String dateLabel;
  final int age;
  final VoidCallback? onConfirm;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) => BubbaTextDefaults(
    child: BubbaSheetCanvas(builder: _build),
  );

  Widget _build(BuildContext context) {
    final titleMetrics = bubbaDesignTextMetrics(context, BubbaText.confirmTitle);
    final dateMetrics = bubbaDesignTextMetrics(context, BubbaText.confirmDate);
    final ageMetrics = bubbaDesignTextMetrics(context, BubbaText.confirmAge);
    final bodyMetrics = bubbaDesignTextMetrics(context, BubbaText.body);
    final editMetrics = bubbaDesignTextMetrics(context, BubbaText.confirmEdit);
    return Stack(
      children: [
        SizedBox.expand(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onEdit,
            child: const ColoredBox(color: Color(0x2B000000)),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(child: SizedBox.shrink()),
            Center(
          child: Container(
            width: hd(_cardWidth),
            decoration: BoxDecoration(
              color: BubbaColors.surface,
              borderRadius: BorderRadius.circular(d(_cardRadius)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const BubbaGap(_badgeCentreY - _badgeOuter / 2),
                Center(
                  child: Container(
                    width: d(_badgeOuter),
                    height: d(_badgeOuter),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F2F2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CustomPaint(
                        size: Size(d(_badgeInner), d(_badgeInner)),
                        painter: const _CheckPainter(),
                      ),
                    ),
                  ),
                ),
                BubbaCopy(
                  'Confirm your birthday',
                  gapAbove:
                      _titleBaseline - _badgeCentreY - _badgeOuter / 2,
                  style: BubbaText.confirmTitle,
                  textAlign: TextAlign.center,
                ),
                BubbaCopy(
                  dateLabel,
                  gapAbove:
                      _dateBaseline - _titleBaseline - titleMetrics.descent,
                  style: BubbaText.confirmDate,
                  textAlign: TextAlign.center,
                ),
                BubbaCopy(
                  'You\u2019re $age years old',
                  gapAbove: _ageBaseline - _dateBaseline - dateMetrics.descent,
                  style: BubbaText.confirmAge,
                  textAlign: TextAlign.center,
                ),
                BubbaGap(_dividerY - _ageBaseline - ageMetrics.descent),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: d(_dividerInset)),
                  child: Container(height: 1, color: BubbaColors.divider),
                ),
                BubbaCopy(
                  'Make sure this is correct. Only your age',
                  gapAbove: _copyFirstBaseline - _dividerY - 1,
                  style: BubbaText.body,
                  textAlign: TextAlign.center,
                ),
                BubbaCopy(
                  'will appear on profile.',
                  gapAbove: _copySecondBaseline -
                      _copyFirstBaseline -
                      bodyMetrics.descent,
                  style: BubbaText.body,
                  textAlign: TextAlign.center,
                ),
                BubbaGap(_ctaY - _copySecondBaseline - bodyMetrics.descent),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: d(_ctaInset)),
                  child: Semantics(
                    button: true,
                    label: 'Confirm birthday',
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onConfirm,
                      child: Container(
                        height: d(_ctaHeight),
                        decoration: BoxDecoration(
                          color: BubbaColors.actionDark,
                          borderRadius: BorderRadius.circular(d(_ctaRadius)),
                        ),
                        child: Baseline(
                          baseline: d(_ctaBaseline),
                          baselineType: TextBaseline.alphabetic,
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Confirm birthday',
                              textAlign: TextAlign.center,
                              style: BubbaText.enterBubba,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Baseline(
                  baseline: d(_editBaseline - _ctaY - _ctaHeight),
                  baselineType: TextBaseline.alphabetic,
                  child: Align(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onEdit,
                      child: Semantics(
                        button: true,
                        child: Text(
                          'Edit my birthday',
                          style: BubbaText.confirmEdit,
                        ),
                      ),
                    ),
                  ),
                ),
                BubbaGap(
                  _cardHeight - _editBaseline - editMetrics.descent,
                ),
              ],
            ),
          ),
        ),
            const BubbaGap(_cardBottom),
          ],
        ),
      ],
    );
  }
}

class _CheckPainter extends CustomPainter {
  const _CheckPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.085;
    final paint = Paint()
      ..color = BubbaColors.actionPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final c = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(c, size.width / 2 - stroke / 2, paint);
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.30, size.height * 0.52)
        ..lineTo(size.width * 0.44, size.height * 0.66)
        ..lineTo(size.width * 0.71, size.height * 0.37),
      paint,
    );
  }

  @override
  bool shouldRepaint(_CheckPainter oldDelegate) => false;
}

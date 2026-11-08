import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_text_styles.dart';
import '../../../core/design/bubba_tokens.dart';
import 'models/icebreaker_entry.dart';
import 'widgets/icebreaker_card.dart';
import 'widgets/profile_step_scaffold.dart';

const double _addAtLeastBaseline = 228.44;
const double _yourIcebreakersBaseline = 213.61;
const double _firstCardY = 243.24;
const double _cardGap = 9.47;
const double _firstSlotY = 243.13;
const double _slotPitch = 91.29;
const double _slotHeight = 76.61;
const double _slotRadius = 12.41;
const double _slotTextX = 19.4;
const double _slotTitleBaseline = 32.23;
const double _slotSubtitleBaseline = 55.62;
const double _addButtonInset = 15.7;
const double _addButtonSize = 24.59;

/// Artboard p001 (three empty slots) and p042 / p048 / p049 / p050 / p053 (the
/// same screen once icebreakers have been added).
///
/// The empty state lists "Add at least one" over three tappable slots; as soon
/// as [entries] is non-empty the slots give way to [IcebreakerCard]s under a
/// "Your icebreakers" label.
class IcebreakersScreen extends StatelessWidget {
  const IcebreakersScreen({
    super.key,
    this.answers = const <String?>[null, null, null],
    this.entries = const <IcebreakerEntry>[],
    this.onAdd,
    this.onEdit,
    this.onBack,
    this.onContinue,
  });

  /// One entry per slot; null means the slot is still empty.
  final List<String?> answers;

  /// Filled icebreakers. When non-empty these replace the empty slots.
  final List<IcebreakerEntry> entries;
  final void Function(int slot)? onAdd;
  final void Function(int index)? onEdit;
  final VoidCallback? onBack;
  final VoidCallback? onContinue;

  static const List<String> slotTitles = [
    'First icebreaker',
    'Second icebreaker',
    'Third icebreaker',
  ];

  bool get _hasAny =>
      entries.isNotEmpty || answers.any((a) => a != null && a.isNotEmpty);

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
        body: BubbaProfileStepScaffold(
          footerRule: true,
          heading: 'Icebreakers',
          // p001 asks for icebreakers; once some exist the filled artboards
          // (p042, p048-p050, p053) switch to the "share a little more" line.
          body: entries.isEmpty
              ? 'Choose up to three icebreakers to\nhelp start conversation.'
              : 'Share a little more about you to help\nbreak the ice',
          onBack: onBack,
          ctaEnabled: _hasAny,
          onCta: onContinue,
          content: (context, flow) =>
              entries.isEmpty ? _emptySlots(flow) : _filledCards(flow),
        ),
      ),
    );
  }
}

extension on IcebreakersScreen {
  void _emptySlots(BubbaFlow flow) {
    flow.copy(
      'Add at least one',
      baseline: _addAtLeastBaseline,
      style: BubbaText.sectionLabel,
    );
    for (var i = 0; i < IcebreakersScreen.slotTitles.length; i++) {
      flow.block(
        _Slot(
          title: IcebreakersScreen.slotTitles[i],
          answer: i < answers.length ? answers[i] : null,
          onTap: onAdd == null ? null : () => onAdd!(i),
        ),
        top: _firstSlotY + _slotPitch * i,
        height: _slotHeight,
      );
    }
  }

  void _filledCards(BubbaFlow flow) {
    flow.copy(
      'Your icebreakers',
      baseline: _yourIcebreakersBaseline,
      style: BubbaText.sectionLabel,
    );
    // The filled artboards (p042, p048-p050, p053) draw cards and nothing else,
    // so the remaining slots only appear where something can act on them - the
    // live flow passes [onAdd], the artboard fixtures do not. Without them
    // "choose up to three" stopped at one, with no way back to the browser.
    final free = onAdd == null
        ? 0
        : IcebreakersScreen.slotTitles.length - entries.length;
    flow.block(
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < entries.length; i++) ...[
            if (i > 0) SizedBox(height: d(_cardGap)),
            IcebreakerCard(
              entry: entries[i],
              onEdit: onEdit == null ? null : () => onEdit!(i),
            ),
          ],
          for (var i = 0; i < free; i++) ...[
            SizedBox(height: d(_cardGap)),
            _Slot(
              title: IcebreakersScreen.slotTitles[entries.length + i],
              onTap: onAdd == null ? null : () => onAdd!(entries.length + i),
            ),
          ],
        ],
      ),
      top: _firstCardY,
      height: 0,
    );
  }
}

class _Slot extends StatelessWidget {
  const _Slot({required this.title, this.answer, this.onTap});

  final String title;
  final String? answer;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final filled = answer != null && answer!.isNotEmpty;
    return Semantics(
      button: true,
      label: filled ? '$title, $answer' : '$title, add your answer',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          height: d(_slotHeight),
          decoration: BoxDecoration(
            color: BubbaColors.surface,
            borderRadius: BorderRadius.circular(d(_slotRadius)),
            border: Border.all(color: BubbaColors.border, width: 0.5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: hd(_slotTextX)),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BubbaCopy(
                      title,
                      gapAbove: _slotTitleBaseline,
                      style: BubbaText.slotTitle,
                    ),
                    BubbaCopy(
                      filled ? answer! : 'Add your answer',
                      gapAbove: _slotSubtitleBaseline -
                          _slotTitleBaseline -
                          bubbaDesignTextMetrics(context, BubbaText.slotTitle)
                              .descent,
                      style: BubbaText.slotSubtitle,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              SizedBox(width: hd(8)),
              Padding(
                padding: EdgeInsets.only(top: d(26.01)),
                child: const _AddCircle(),
              ),
              SizedBox(width: hd(_addButtonInset)),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddCircle extends StatelessWidget {
  const _AddCircle();

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size(d(_addButtonSize), d(_addButtonSize)),
        painter: _AddPainter(strokeWidth: d(1.1)),
      );
}

class _AddPainter extends CustomPainter {
  const _AddPainter({required this.strokeWidth});

  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = BubbaColors.actionPrimary;
    final c = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(c, size.width / 2 - strokeWidth / 2, p);
    final arm = size.width * 0.215;
    canvas.drawLine(Offset(c.dx - arm, c.dy), Offset(c.dx + arm, c.dy), p);
    canvas.drawLine(Offset(c.dx, c.dy - arm), Offset(c.dx, c.dy + arm), p);
  }

  @override
  bool shouldRepaint(_AddPainter old) => old.strokeWidth != strokeWidth;
}

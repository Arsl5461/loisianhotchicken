import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_icons.dart';
import '../../../core/design/bubba_text_styles.dart';
import '../../../core/design/bubba_tokens.dart';
import 'models/icebreaker_entry.dart';

// p054 is drawn on a 390x818.42 artboard where the other pages are 390x843, so
// every y below is the traced value scaled by 843/818.42. The x values need no
// scaling - the artboard is already 390 wide.
const double _chevronX = BubbaMetrics.backChevronX;
const double _chevronY = 53.71;
const double _titleBaseline = 67.44;
const double _gearY = 50.53;
const double _gear = 20.36;
const double _chevronWidth = 8.20;
const double _chevronHeight = 14.48;
const double _chevronPad = 12.0;
const double _headerBottom = 90.0;

const double _sectionX = 15.31;
const double _icebreakersBaseline = 112.6;
const double _addedBaseline = 112.79;
const double _addedRightInset = 12.83;
const double _hintBaseline = 132.98;

const double _cardX = 15.35;
const double _cardRightInset = 390 - (15.35 + 356.96);
const double _cardRadius = 12.41;
const double _cardGap = 12.01;
const double _firstCardY = 160.71;

/// Insets inside an icebreaker card. The pencil's x jitters between 339.70 and
/// 334.77 across the three cards; 334.77 is the pair.
const double _cardTextX = 20.5;
const double _cardEyebrowBaseline = 29.0;
const double _cardTitleBaseline = 50.41;
const double _cardBodyBaseline = 76.04;
const double _cardBodyLine = 17.3;
const double _pencilRightInset = 372.31 - (334.77 + 18.94);
const double _pencil = 18.94;
const double _pencilGap = 8.0;
const double _cardBorder = 1.0;

const double _snapThumbX = 9.15;
const double _snapThumbY = 12.44;
const double _snapThumbWidth = 71.0;
const double _snapThumbHeight = 102.49;
const double _snapThumbRadius = 4.0;

const double _snapTextX = 111.56;
const double _snapEyebrowBaseline = 46.2;
const double _snapTitleBaseline = 68.33;
const double _snapBodyBaseline = 93.67;

const double _basicsX = 13.77;
const double _basicsBaseline = 578.46;
const double _basicsHintBaseline = 598.82;
const double _basicsCardX = 13.38;
const double _basicsCardRightInset = 390 - (13.38 + 363.23);
const double _basicsCardY = 618.85;
const double _basicsCardRadius = 6.35;
const double _rowHeight = 61.39;
const double _rowLabelX = 31.11 - 13.38;
const double _rowLabelBaseline = 22.59;
const double _rowValueX = 32.32 - 13.38;
const double _rowValueY = 38.87;
const double _rowValueWidth = 15.34;
const double _rowVisibilityGap = 362.48 - 341.0;
const double _rowVisibilityBaseline = 37.35;
const double _rowChevronRightInset = 376.61 - (362.48 + 5.32);
const double _rowChevronY = 27.8;
const double _rowChevronWidth = 5.32;
const double _rowChevronHeight = 9.68;

/// One row of the "Basics" card.
class ProfileBasic {
  const ProfileBasic({
    required this.label,
    this.value = '',
    this.visibility,
  });

  final String label;
  final String value;

  /// "Public" / "Private". Null draws nothing, which is what the design does on
  /// the rows it leaves unlabelled.
  final String? visibility;
}

/// Artboard p054 - the assembled profile, and the entry point for later edits.
///
/// The artboard also carries the app's black tab bar and a couple of pasted
/// screenshots of other screens; those belong to the shell, not here.
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({
    super.key,
    this.entries = const <IcebreakerEntry>[],
    this.basics = defaultBasics,
    this.maxIcebreakers = 3,
    this.onBack,
    this.onSettings,
    this.onEditIcebreaker,
    this.onEditBasic,
  });

  final List<IcebreakerEntry> entries;
  final List<ProfileBasic> basics;
  final int maxIcebreakers;
  final VoidCallback? onBack;
  final VoidCallback? onSettings;
  final ValueChanged<int>? onEditIcebreaker;
  final ValueChanged<int>? onEditBasic;

  static const List<ProfileBasic> defaultBasics = [
    ProfileBasic(label: 'NAME', visibility: 'Public'),
    ProfileBasic(label: 'HOMETOWN'),
    ProfileBasic(label: 'EDUCATION'),
    ProfileBasic(label: 'WORK'),
    ProfileBasic(label: 'BIRTHDAY', visibility: 'Private'),
    ProfileBasic(label: 'LANGUAGE', visibility: 'Public'),
  ];

  static double _cardHeight(IcebreakerEntry entry) => switch (entry) {
        SnapIcebreaker() => 125.36,
        PromptIcebreaker() => 107.85,
        GameIcebreaker() => 113.08,
      };

  double get _basicsCardHeight => basics.length * _rowHeight;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: BubbaColors.surface,
        resizeToAvoidBottomInset: false,
        body: BubbaPage(
          background: BubbaColors.surface,
          padContent: false,
          contentStartY: _headerBottom,
          header: (context) => _EditProfileHeader(
            onBack: onBack,
            onSettings: onSettings,
          ),
          content: (context, flow) {
            final sectionMetrics =
                bubbaDesignTextMetrics(context, BubbaText.editSection);
            flow.block(
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Icebreakers', style: BubbaText.editSection),
                  const Spacer(),
                  Baseline(
                    baseline: d(_addedBaseline - _icebreakersBaseline) +
                        d(sectionMetrics.baseline),
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      '${entries.length}/$maxIcebreakers added',
                      style: BubbaText.editAdded,
                    ),
                  ),
                ],
              ),
              top: _icebreakersBaseline - sectionMetrics.baseline,
              height: sectionMetrics.lineHeight,
              left: _sectionX,
              right: _addedRightInset,
            );
            flow.copy(
              'Tap to edit  \u00b7  Hold to reorder',
              baseline: _hintBaseline,
              style: BubbaText.editSectionHint,
              left: _sectionX,
            );
            flow.skipTo(_firstCardY);
            for (var i = 0; i < entries.length; i++) {
              if (i > 0) flow.gap(_cardGap);
              flow.raw(
                _EntryCard(
                  entry: entries[i],
                  onEdit: () => onEditIcebreaker?.call(i),
                ),
                advance: _cardHeight(entries[i]),
                left: _cardX,
                right: _cardRightInset,
              );
            }
            flow.copy(
              'Basics',
              baseline: _basicsBaseline,
              style: BubbaText.editSection,
              left: _basicsX,
            );
            flow.copy(
              'Tap to edit',
              baseline: _basicsHintBaseline,
              style: BubbaText.editSectionHint,
              left: _basicsX,
            );
            flow.skipTo(_basicsCardY);
            flow.raw(
              _BasicsCard(basics: basics, onTap: onEditBasic),
              advance: _basicsCardHeight,
              left: _basicsCardX,
              right: _basicsCardRightInset,
            );
            flow.gap(24);
          },
        ),
      ),
    );
  }
}

class _EditProfileHeader extends StatelessWidget {
  const _EditProfileHeader({this.onBack, this.onSettings});

  final VoidCallback? onBack;
  final VoidCallback? onSettings;

  @override
  Widget build(BuildContext context) {
    final metrics = bubbaDesignTextMetrics(context, BubbaText.navTitle);
    final titleTop = _titleBaseline - metrics.baseline;
    final chevronTop = _chevronY - _chevronPad;
    final gearTop = _gearY - _chevronPad;
    final rowTop = math.min(titleTop, math.min(chevronTop, gearTop));
    final rowBottom = math.max(
      titleTop + metrics.lineHeight,
      math.max(
        chevronTop + _chevronHeight + _chevronPad * 2,
        gearTop + _gear + _chevronPad * 2,
      ),
    );
    final leftCell = dx(_chevronX) + d(_chevronWidth + _chevronPad);
    final rightCell =
        dx(_chevronX) + d(_gear + _chevronPad);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: d(rowTop) + bubbaTopShift(context)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: dx(_chevronX) - d(_chevronPad)),
            Padding(
              padding: EdgeInsets.only(top: d(chevronTop - rowTop)),
              child: BubbaTapTarget(
                onTap: onBack,
                label: 'Back',
                child: Padding(
                  padding: EdgeInsets.all(d(_chevronPad)),
                  child: const BubbaChevronLeft(
                    width: _chevronWidth,
                    height: _chevronHeight,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  top: d(titleTop - rowTop),
                  left: math.max(0, rightCell - leftCell),
                  right: math.max(0, leftCell - rightCell),
                ),
                child: Text(
                  'Edit Profile',
                  textAlign: TextAlign.center,
                  style: BubbaText.navTitle,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: d(gearTop - rowTop)),
              child: BubbaTapTarget(
                onTap: onSettings,
                label: 'Settings',
                child: Padding(
                  padding: EdgeInsets.all(d(_chevronPad)),
                  child: const BubbaGear(size: _gear),
                ),
              ),
            ),
            SizedBox(width: dx(_chevronX) - d(_chevronPad)),
          ],
        ),
        SizedBox(height: math.max(0, d(_headerBottom - rowBottom))),
      ],
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.entry, required this.onEdit});

  final IcebreakerEntry entry;
  final VoidCallback onEdit;

  String get _body => switch (entry) {
        PromptIcebreaker(:final answer) => answer,
        SnapIcebreaker(:final caption) => caption,
        TwoTruthsIcebreaker(:final statements) => statements.join(', '),
        GameIcebreaker() => '',
      };

  bool get _isSnap => entry is SnapIcebreaker;

  @override
  Widget build(BuildContext context) {
    final textX = _isSnap ? _snapTextX : _cardTextX;
    final eyebrow = _isSnap ? _snapEyebrowBaseline : _cardEyebrowBaseline;
    final title = _isSnap ? _snapTitleBaseline : _cardTitleBaseline;
    final body = _isSnap ? _snapBodyBaseline : _cardBodyBaseline;
    final eyebrowMetrics =
        bubbaDesignTextMetrics(context, BubbaText.editCardEyebrow);
    final titleMetrics =
        bubbaDesignTextMetrics(context, BubbaText.editCardTitle);
    final bodyStyle =
        BubbaText.editCardBody.copyWith(height: _cardBodyLine / 14);
    final bodyMetrics = bubbaDesignTextMetrics(context, bodyStyle);
    final tail = EditProfileScreen._cardHeight(entry) - _cardBorder * 2;
    final bodyBottom =
        body + bodyMetrics.descent + (_isSnap ? 0 : _cardBodyLine);
    return Container(
      decoration: BoxDecoration(
        color: BubbaColors.surface,
        borderRadius: BorderRadius.circular(d(_cardRadius)),
        border: Border.all(color: const Color(0xFFDAE0E8), width: _cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_isSnap && (entry as SnapIcebreaker).image != null) ...[
            SizedBox(width: hd(_snapThumbX)),
            Padding(
              padding: EdgeInsets.only(
                top: d(_snapThumbY),
                bottom: d(tail - _snapThumbY - _snapThumbHeight),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(d(_snapThumbRadius)),
                child: SizedBox(
                  width: hd(_snapThumbWidth),
                  height: d(_snapThumbHeight),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F2F2),
                      image: (entry as SnapIcebreaker).image == null
                          ? null
                          : DecorationImage(
                              image: (entry as SnapIcebreaker).image!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: hd(textX - _snapThumbX - _snapThumbWidth)),
          ] else
            SizedBox(width: hd(textX)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                BubbaCopy(
                  entry.kindLabel,
                  gapAbove: eyebrow,
                  style: BubbaText.editCardEyebrow,
                ),
                BubbaCopy(
                  entry.title.toUpperCase(),
                  gapAbove: title - eyebrow - eyebrowMetrics.descent,
                  style: BubbaText.editCardTitle,
                ),
                BubbaCopy(
                  _body,
                  gapAbove: body - title - titleMetrics.descent,
                  style: bodyStyle,
                  maxLines: 2,
                  measure: BubbaMetrics.copyMeasure,
                ),
                BubbaGap(tail - bodyBottom),
              ],
            ),
          ),
          SizedBox(width: hd(_pencilGap)),
          _CardPencil(label: entry.title, onTap: onEdit),
          SizedBox(width: hd(_pencilRightInset)),
        ],
      ),
    );
  }
}

class _CardPencil extends StatelessWidget {
  const _CardPencil({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: 'Edit $label',
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: SizedBox(
            width: BubbaMetrics.minTapTarget,
            height: BubbaMetrics.minTapTarget,
            child: const Center(child: BubbaPencil(size: _pencil)),
          ),
        ),
      );
}

class _BasicsCard extends StatelessWidget {
  const _BasicsCard({required this.basics, required this.onTap});

  final List<ProfileBasic> basics;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: BubbaColors.surface,
          borderRadius: BorderRadius.circular(d(_basicsCardRadius)),
          border: Border.all(color: const Color(0xFFE7E6E7), width: 0.75),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < basics.length; i++)
              _BasicRow(
                basic: basics[i],
                divider: i < basics.length - 1,
                onTap: () => onTap?.call(i),
              ),
          ],
        ),
      );
}

class _BasicRow extends StatelessWidget {
  const _BasicRow({
    required this.basic,
    required this.divider,
    required this.onTap,
  });

  final ProfileBasic basic;
  final bool divider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final labelMetrics = bubbaDesignTextMetrics(context, BubbaText.editRowLabel);
    return Semantics(
      button: true,
      label: basic.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          constraints: BoxConstraints(minHeight: d(_rowHeight)),
          decoration: BoxDecoration(
            border: divider
                ? const Border(
                    bottom: BorderSide(color: Color(0xFFEBEBEB), width: 0.75),
                  )
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: hd(_rowLabelX)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BubbaCopy(
                      basic.label,
                      gapAbove: _rowLabelBaseline,
                      style: BubbaText.editRowLabel,
                    ),
                    if (basic.value.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(
                          left: hd(_rowValueX - _rowLabelX),
                          top: d(_rowValueY -
                              _rowLabelBaseline -
                              labelMetrics.descent),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: hd(_rowValueWidth),
                            height: 2,
                            color: const Color(0xFF6D6D6D),
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: EdgeInsets.only(
                          left: hd(_rowValueX - _rowLabelX),
                        ),
                        child: BubbaCopy(
                          basic.value,
                          gapAbove: _rowValueY +
                              4 -
                              _rowLabelBaseline -
                              labelMetrics.descent,
                          style: BubbaText.editRowValue,
                        ),
                      ),
                  ],
                ),
              ),
              if (basic.visibility != null)
                Baseline(
                  baseline: d(_rowVisibilityBaseline),
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    basic.visibility!,
                    style: BubbaText.editRowVisibility,
                  ),
                ),
              SizedBox(width: hd(_rowVisibilityGap)),
              Padding(
                padding: EdgeInsets.only(top: d(_rowChevronY)),
                child: const BubbaChevronRight(
                  width: _rowChevronWidth,
                  height: _rowChevronHeight,
                  color: Color(0xFFB7B7B7),
                ),
              ),
              SizedBox(width: hd(_rowChevronRightInset)),
            ],
          ),
        ),
      ),
    );
  }
}

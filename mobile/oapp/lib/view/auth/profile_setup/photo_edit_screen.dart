import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_icons.dart';
import '../../../core/design/bubba_text_styles.dart';
import '../../../core/design/bubba_tokens.dart';

// p014 and p045 are drawn on a 382.57x818.55 artboard where the other pages are
// 390x843, so every number below is the traced value scaled by 390/382.57
// horizontally and 843/818.55 vertically.
const double _chevronX = BubbaMetrics.backChevronX;
const double _chevronY = 70.14;
const double _chevronWidth = 6.12;
const double _chevronHeight = 10.92;
const double _chevronPad = 12.0;
const double _titleBaseline = 81.27;
const double _doneX = 334.26;
const double _doneBaseline = 80.48;

const double _heroX = 9.16;
const double _heroY = 108.08;
const double _heroRightInset = 10.19;
const double _heroHeight = 459.59;
const double _heroRadius = 9.28;

const double _mainBadgeX = 8.85;
const double _mainBadgeY = 11.61;
const double _mainBadgeWidth = 47.59;
const double _mainBadgeHeight = 24.09;
const double _heroBadgeRadius = 6.52;
const double _mainLabelX = 10.35;
const double _mainLabelBaseline = 16.16;

const double _captionX = 21.39;
const double _captionBaseline = 540.35;
const double _cropX = 293.89;
const double _cropY = 515.28;
const double _cropWidth = 67.06;
const double _cropHeight = 37.45;
const double _cropRadius = 18.72;
const double _cropGlyphX = 306.50;
const double _cropGlyphY = 527.40;
const double _cropGlyph = 12.15;
const double _cropLabelX = 323.14;
const double _cropLabelBaseline = 537.53;

const double _handX = 123.93;
const double _handY = 582.91;
const double _handWidth = 13.30;
const double _handHeight = 14.45;
const double _hintX = 146.55;
const double _hintBaseline = 595.26;

const double _trayY = 625.82;
const double _trayHeight = 150.79;
const double _trayWidth = 120.67;
const List<double> _trayX = [8.14, 133.90, 260.17];
const double _trayRadius = 6.47;
const double _trayBadgeRadius = 4.41;
const double _trayBadgeInset = 4.52;
const double _orderBadge = 21.32;
const double _orderBadgeInset = 2.69;
const double _emptyCircle = 35.97;
const double _emptyPlus = 14.72;

/// Artboards p014 (three photos in the tray) and p045 (one photo, two empty
/// slots) - the shot on its own with a crop affordance and a caption.
///
/// p014 centres "Edit Photo" and p045 left-aligns it beside the chevron; the
/// artboards are otherwise identical, so the centred one is used.
class PhotoEditScreen extends StatelessWidget {
  const PhotoEditScreen({
    super.key,
    required this.photos,
    this.selected = 0,
    this.slots = 3,
    this.caption,
    this.onBack,
    this.onDone,
    this.onCrop,
    this.onCaption,
    this.onSelect,
    this.onAdd,
  });

  /// The tray, in order. The first is the main photo.
  final List<ImageProvider> photos;

  /// Which tray photo the hero is showing.
  final int selected;

  /// How many tray slots to draw; the ones past [photos] are empty.
  final int slots;
  final String? caption;
  final VoidCallback? onBack;
  final VoidCallback? onDone;
  final VoidCallback? onCrop;
  final VoidCallback? onCaption;
  final ValueChanged<int>? onSelect;
  final ValueChanged<int>? onAdd;

  ImageProvider? get _hero =>
      selected >= 0 && selected < photos.length ? photos[selected] : null;

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
          contentStartY: _heroY,
          header: (context) => _EditHeader(onBack: onBack, onDone: onDone),
          content: (context, flow) {
            flow.block(
              SizedBox(
                height: d(_heroHeight),
                child: _Hero(
                  photo: _hero,
                  caption: caption,
                  onCrop: onCrop,
                  onCaption: onCaption,
                ),
              ),
              top: _heroY,
              height: _heroHeight,
              left: _heroX,
              right: _heroRightInset,
            );
            flow.block(
              Row(
                children: [
                  const BubbaTapHand(
                    width: _handWidth,
                    height: _handHeight,
                  ),
                  SizedBox(width: hd(_hintX - _handX - _handWidth)),
                  Baseline(
                    baseline: d(_hintBaseline - _handY),
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      'Tap to see profile view',
                      style: BubbaText.editHint,
                    ),
                  ),
                ],
              ),
              top: _handY,
              height: _handHeight,
              left: _handX,
            );
            flow.block(
              SizedBox(
                height: d(_trayHeight),
                child: Row(
                  children: [
                    for (var i = 0; i < slots && i < _trayX.length; i++) ...[
                      if (i > 0) SizedBox(width: hd(_trayX[i] - _trayX[i - 1] - _trayWidth)),
                      SizedBox(
                        width: hd(_trayWidth),
                        child: i < photos.length
                            ? _TrayTile(
                                photo: photos[i],
                                order: i + 1,
                                isMain: i == 0,
                                onTap: () => onSelect?.call(i),
                              )
                            : _EmptyTile(onTap: () => onAdd?.call(i)),
                      ),
                    ],
                  ],
                ),
              ),
              top: _trayY,
              height: _trayHeight,
              left: _trayX.first,
            );
          },
        ),
      ),
    );
  }
}

class _EditHeader extends StatelessWidget {
  const _EditHeader({this.onBack, this.onDone});

  final VoidCallback? onBack;
  final VoidCallback? onDone;

  @override
  Widget build(BuildContext context) {
    final metrics = bubbaDesignTextMetrics(context, BubbaText.navTitle);
    final doneMetrics = bubbaDesignTextMetrics(context, BubbaText.editDone);
    final titleTop = _titleBaseline - metrics.baseline;
    final doneTop = _doneBaseline - doneMetrics.baseline;
    final chevronTop = _chevronY - _chevronPad;
    final rowTop = math.min(titleTop, math.min(doneTop, chevronTop));
    final rowBottom = math.max(
      titleTop + metrics.lineHeight,
      math.max(
        doneTop + doneMetrics.lineHeight,
        chevronTop + _chevronHeight + _chevronPad * 2,
      ),
    );
    final doneBox = BubbaScale.tapBox(d(doneMetrics.lineHeight));
    final leftCell = dx(_chevronX) + d(_chevronWidth + _chevronPad);
    final rightCell = BubbaScale.availableWidth - dx(_doneX);
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
                  'Edit Photo',
                  textAlign: TextAlign.center,
                  style: BubbaText.navTitle,
                ),
              ),
            ),
            SizedBox(
              width: rightCell,
              child: Padding(
                padding: EdgeInsets.only(top: d(doneTop - rowTop)),
                child: Align(
                  alignment: Alignment.topLeft,
                  heightFactor: 1,
                  child: SizedBox(
                    height: d(doneMetrics.lineHeight),
                    child: OverflowBox(
                      minHeight: doneBox,
                      maxHeight: doneBox,
                      child: BubbaTapTarget(
                        onTap: onDone,
                        label: 'Done',
                        child: SizedBox(
                          height: doneBox,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Done', style: BubbaText.editDone),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: math.max(0, d(_heroY - rowBottom))),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({
    required this.photo,
    required this.caption,
    required this.onCrop,
    required this.onCaption,
  });

  final ImageProvider? photo;
  final String? caption;
  final VoidCallback? onCrop;
  final VoidCallback? onCaption;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(d(_heroRadius)),
      child: Stack(
        children: [
          SizedBox.expand(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F2F2),
                image: photo == null
                    ? null
                    : DecorationImage(image: photo!, fit: BoxFit.cover),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: hd(_mainBadgeX),
                top: d(_mainBadgeY),
              ),
              child: _MainBadge(radius: _heroBadgeRadius),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: hd(_captionX - _heroX)),
              child: Baseline(
                baseline: d(_captionBaseline - _heroY),
                baselineType: TextBaseline.alphabetic,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onCaption,
                  child: Semantics(
                    button: true,
                    child: SizedBox(
                      height: BubbaMetrics.minTapTarget,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        widthFactor: 1,
                        child: Text(
                          caption?.isNotEmpty == true
                              ? caption!
                              : 'Add a caption',
                          style: BubbaText.editCaption,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: hd(_cropX - _heroX),
                top: d(_cropY - _heroY),
              ),
              child: Semantics(
                button: true,
                label: 'Crop',
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onCrop,
                  child: Container(
                    width: hd(_cropWidth),
                    height: d(_cropHeight),
                    decoration: BoxDecoration(
                      color: BubbaColors.surface,
                      borderRadius: BorderRadius.circular(d(_cropRadius)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: hd(_cropGlyphX - _cropX)),
                        Padding(
                          padding:
                              EdgeInsets.only(top: d(_cropGlyphY - _cropY)),
                          child: const BubbaCropGlyph(size: _cropGlyph),
                        ),
                        SizedBox(
                          width: hd(_cropLabelX - _cropGlyphX - _cropGlyph),
                        ),
                        Baseline(
                          baseline: d(_cropLabelBaseline - _cropY),
                          baselineType: TextBaseline.alphabetic,
                          child: Text('Crop', style: BubbaText.editCrop),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MainBadge extends StatelessWidget {
  const _MainBadge({required this.radius});

  final double radius;

  @override
  Widget build(BuildContext context) => Container(
        width: hd(_mainBadgeWidth),
        height: d(_mainBadgeHeight),
        decoration: BoxDecoration(
          color: BubbaColors.surface,
          borderRadius: BorderRadius.circular(d(radius)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: hd(_mainLabelX)),
            Baseline(
              baseline: d(_mainLabelBaseline),
              baselineType: TextBaseline.alphabetic,
              child: Text('MAIN', style: BubbaText.editMainBadge),
            ),
          ],
        ),
      );
}

class _TrayTile extends StatelessWidget {
  const _TrayTile({
    required this.photo,
    required this.order,
    required this.isMain,
    required this.onTap,
  });

  final ImageProvider photo;
  final int order;
  final bool isMain;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: 'Photo $order',
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(d(_trayRadius)),
            child: Stack(
              children: [
                SizedBox.expand(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      image: DecorationImage(image: photo, fit: BoxFit.cover),
                    ),
                  ),
                ),
                if (isMain)
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.all(d(_trayBadgeInset)),
                      child: _MainBadge(radius: _trayBadgeRadius),
                    ),
                  ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: hd(_orderBadgeInset),
                      top: d(_trayBadgeInset),
                    ),
                    child: Container(
                    width: d(_orderBadge),
                    height: d(_orderBadge),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: BubbaColors.surface,
                      shape: BoxShape.circle,
                    ),
                      child: Text('$order', style: BubbaText.editOrderBadge),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class _EmptyTile extends StatelessWidget {
  const _EmptyTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: 'Add a photo',
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: BubbaDashedTile(
            radius: _trayRadius,
            fill: const Color(0xFFF7F5F4),
            border: const Color(0xFFE7E4E0),
            child: Center(
              child: Container(
              width: d(_emptyCircle),
              height: d(_emptyCircle),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFFEEECE9),
                shape: BoxShape.circle,
              ),
                child: BubbaPlusGlyph(
                  size: _emptyPlus,
                  color: const Color(0xFF807E7D),
                ),
              ),
            ),
          ),
        ),
      );
}

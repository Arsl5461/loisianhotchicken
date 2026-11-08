import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_icons.dart';
import '../../../core/design/bubba_text_styles.dart';
import '../../../core/design/bubba_tokens.dart';
import '../../../core/design/widgets/bubba_loading.dart';

// p008 and p012 are drawn on a 385x846 artboard where the other 52 pages are
// 390x843, so every number below is the traced value scaled by 390/385
// horizontally and 843/846 vertically.
const double _headerBaseline = 73.84;
const double _cancelX = 18.89;
const double _gridTop = 102.07;
const double _gridLeft = 8.56;
const double _gridRightInset = 8.56;
const double _columnGap = 4.18;
const double _rowGap = 5.23;
const double _tileHeight = 159.51;
const double _tileRadius = 6.15;
const double _checkSize = 16.26;
const double _checkInset = 4.60;
const double _barTop = 734.78;
const double _pillX = 14.10;
const double _pillRightInset = 14.71;
const double _pillY = 758.18;
const double _pillHeight = 63.34;
const double _pillRadius = 31.79;

/// The bar is anchored to the bottom of the viewport, not to its design y: on a
/// 568-tall phone "Next" would otherwise sit 17pt below the screen.
const double _barHeight = BubbaMetrics.designHeight - _barTop;

/// Artboards p008 (nothing picked, "Next" disabled) and p012 (one picked).
///
/// A restyled system picker: full-bleed 3-up grid, a "Cancel / Recents" header
/// and a pill that turns green once something is selected. The count badge is
/// the pick order, not a tick, so the user can see which photo lands first.
class PhotoLibraryScreen extends StatefulWidget {
  const PhotoLibraryScreen({
    super.key,
    required this.photos,
    this.albumName = 'Recents',
    this.initialSelection = const <int>[],
    this.maxSelection = 6,
    this.loading = false,
    this.busy = false,
    this.onCancel,
    this.onChooseAlbum,
    this.onNext,
  });

  final List<ImageProvider> photos;
  final String albumName;

  /// Indexes into [photos], in pick order.
  final List<int> initialSelection;
  final int maxSelection;

  /// The album is still being read - the grid draws a spinner, not "no photos".
  final bool loading;

  /// The picked assets are being copied out - "Next" draws a spinner.
  final bool busy;
  final VoidCallback? onCancel;
  final VoidCallback? onChooseAlbum;
  final ValueChanged<List<int>>? onNext;

  @override
  State<PhotoLibraryScreen> createState() => _PhotoLibraryScreenState();
}

class _PhotoLibraryScreenState extends State<PhotoLibraryScreen> {
  late final List<int> _picked = [...widget.initialSelection];

  void _toggle(int index) {
    setState(() {
      if (!_picked.remove(index) && _picked.length < widget.maxSelection) {
        _picked.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final enabled = _picked.isNotEmpty;
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
          scrollable: false,
          contentStartY: _gridTop,
          header: (context) => _Header(
            albumName: widget.albumName,
            onCancel: widget.onCancel,
            onChooseAlbum: widget.onChooseAlbum,
          ),
          fillContent: true,
          content: (context, flow) => flow.raw(
            Expanded(
              child: Padding(
              padding: EdgeInsets.only(
                left: dx(_gridLeft),
                right: BubbaScale.availableWidth - dxRight(_gridRightInset),
              ),
                child: widget.loading
                    ? const Center(child: BubbaSpinner(size: 28))
                    : widget.photos.isEmpty
                        ? Center(
                            child: Text(
                              'No photos here yet',
                              style: BubbaText.pickerAlbum,
                            ),
                          )
                        : _Grid(
                            photos: widget.photos,
                            picked: _picked,
                            onToggle: _toggle,
                          ),
              ),
            ),
          ),
          footer: (context) => _NextBar(
            enabled: enabled,
            busy: widget.busy,
            onNext: enabled
                ? () => widget.onNext?.call(List<int>.of(_picked))
                : null,
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.albumName,
    this.onCancel,
    this.onChooseAlbum,
  });

  final String albumName;
  final VoidCallback? onCancel;
  final VoidCallback? onChooseAlbum;

  @override
  Widget build(BuildContext context) {
    final metrics = bubbaDesignTextMetrics(context, BubbaText.pickerAlbum);
    final rowTop = _headerBaseline - metrics.baseline;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: d(rowTop) + bubbaTopShift(context)),
        Row(
          children: [
            SizedBox(width: dx(_cancelX)),
            BubbaTapTarget(
              onTap: onCancel,
              label: 'Cancel',
              child: Text('Cancel', style: BubbaText.pickerCancel),
            ),
            Expanded(
              child: Center(
                child: BubbaTapTarget(
                  onTap: onChooseAlbum,
                  label: albumName,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(albumName, style: BubbaText.pickerAlbum),
                      SizedBox(width: hd(7)),
                      const BubbaChevronDown(width: 9.5, height: 5.2),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: dx(_cancelX)),
          ],
        ),
        SizedBox(height: d(_gridTop - _headerBaseline - metrics.descent)),
      ],
    );
  }
}

class _NextBar extends StatelessWidget {
  const _NextBar({required this.enabled, required this.busy, this.onNext});

  final bool enabled;
  final bool busy;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: BubbaColors.surface,
        border: Border(
          top: BorderSide(color: BubbaColors.divider, width: 1),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: dx(_pillX),
          right: BubbaScale.availableWidth - dxRight(_pillRightInset),
          top: d(_pillY - (BubbaMetrics.designHeight - _barHeight)),
          bottom: d(BubbaMetrics.designHeight - _pillY - _pillHeight),
        ),
        child: BubbaTapTarget(
          onTap: onNext,
          enabled: enabled,
          label: 'Next',
          designHeight: _pillHeight,
          child: Container(
            height: d(_pillHeight),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: enabled
                  ? BubbaColors.actionPrimary
                  : BubbaColors.actionPrimaryDisabledBg,
              borderRadius: BorderRadius.circular(d(_pillRadius)),
              border: enabled
                  ? null
                  : Border.all(
                      color: BubbaColors.actionPrimaryDisabledBorder,
                      width: 1,
                    ),
            ),
            child: busy
                ? const BubbaSpinner(size: 24, color: Colors.white)
                : Text(
                    'Next',
                    style: enabled
                        ? BubbaText.pickerNextEnabled
                        : BubbaText.pickerNextDisabled,
                  ),
          ),
        ),
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({
    required this.photos,
    required this.picked,
    required this.onToggle,
  });

  final List<ImageProvider> photos;
  final List<int> picked;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) => GridView.builder(
    padding: EdgeInsets.zero,
    physics: const ClampingScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: d(_columnGap),
      mainAxisSpacing: d(_rowGap),
      mainAxisExtent: d(_tileHeight),
    ),
    itemCount: photos.length,
    itemBuilder: (context, i) => _Tile(
      image: photos[i],
      order: picked.indexOf(i),
      onTap: () => onToggle(i),
    ),
  );
}

class _Tile extends StatelessWidget {
  const _Tile({required this.image, required this.order, this.onTap});

  final ImageProvider image;

  /// Zero-based pick order, or -1 when this photo is not selected.
  final int order;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final selected = order >= 0;
    return Semantics(
      button: true,
      selected: selected,
      label: selected ? 'Photo, selected ${order + 1}' : 'Photo',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Stack(
          children: [
            SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(d(_tileRadius)),
                  image: DecorationImage(image: image, fit: BoxFit.cover),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(d(_checkInset)),
                child: Container(
                width: d(_checkSize),
                height: d(_checkSize),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? BubbaColors.actionPrimary
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: BubbaColors.surface, width: 1),
                ),
                  child: selected
                      ? Text('${order + 1}', style: BubbaText.pickerBadge)
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

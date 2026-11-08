import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_icons.dart';
import '../../../core/design/bubba_text_styles.dart';
import '../../../core/design/bubba_tokens.dart';
import 'widgets/photo_grid.dart';
import 'widgets/photo_source_sheet.dart';
import 'widgets/profile_step_scaffold.dart';
import 'widgets/upload_toast.dart';

const double _bodyBaseline = 183.50;
const double _gridTop = 236.03;
const double _reorderHintGap = 30.26;
const double _reorderHintX = 21.40;
const double _errorGap = 20.15;
const double _tipsY = 548.27;
const double _tipsX = 25.56;
const double _tipsRightInset = 390 - (25.56 + 340.79);
const double _tipsHeight = 84.50;
const double _tipsRadius = 10.13;
const double _tipsBulbX = 19.44;
const double _tipsBulbY = 26.44;
const double _tipsTitleX = 61.27;
const double _bulbWidth = 15.0;
const double _tipsTitleBaseline = 26.07;
const double _tipsBodyBaseline = 44.32;
const double _goBackWithTips = 705.14;
const double _headingStar = 14.99;
const double _headingStarGap = 8.0;

/// Artboards p002 (empty), p004 (filled and reorderable), p005 (not enough
/// photos) and p003 (uploading).
///
/// p003 and p005 are stale: they still use the part 1 type ramp (PublicSans
/// headings, PlayfairDisplay "Choose Photos") and a different tile size. Their
/// *states* are built here on p002/p004's geometry, which is the language the
/// rest of part 2 uses. See `PROGRESS.md`.
class PhotosScreen extends StatelessWidget {
  const PhotosScreen({
    super.key,
    this.photos = const <ImageProvider?>[null, null, null, null, null, null],
    this.minimumPhotos = 3,
    this.errorText,
    this.uploaded,
    this.uploadTotal,
    this.sourceSheet = false,
    this.pressedSource,
    this.onPickSource,
    this.onDismissSheet,
    this.onAdd,
    this.onRemove,
    this.onReorder,
    this.onEdit,
    this.onBack,
    this.onContinue,
  });

  /// Six slots; null is an empty tile.
  final List<ImageProvider?> photos;

  /// The number the body copy names. p002, p004 and p005 all draw "Add at
  /// least 3 photos to get started" while p005's error says four, so the count
  /// the copy quotes and the count the flow enforces are different numbers and
  /// this is not [ProfileSetupController.minimumPhotos].
  final int minimumPhotos;

  /// p005 - shown under the grid in red when the user continues too early.
  final String? errorText;

  /// p003 - when both are set the upload toast covers the top of the screen.
  final int? uploaded;
  final int? uploadTotal;

  /// p043 / p044 - the "Add photos" sheet over the grid. [pressedSource] only
  /// exists so p043's pressed row can be rendered in a golden.
  final bool sourceSheet;
  final BubbaPhotoSource? pressedSource;
  final ValueChanged<BubbaPhotoSource>? onPickSource;
  final VoidCallback? onDismissSheet;

  final void Function(int slot)? onAdd;
  final void Function(int slot)? onRemove;
  final void Function(int oldIndex, int newIndex)? onReorder;

  /// Tapping a filled tile opens the edit-photo screen (p014/p045).
  final void Function(int slot)? onEdit;
  final VoidCallback? onBack;
  final VoidCallback? onContinue;

  int get _filled => photos.where((p) => p != null).length;
  bool get _uploading => uploaded != null && uploadTotal != null;
  bool get _showTips => _filled == 0;

  @override
  Widget build(BuildContext context) {
    final gridBottom = _gridTop + BubbaPhotoGrid.height;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: BubbaColors.screenBg,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            BubbaProfileStepScaffold(
              heading: 'Add your best photos',
              headingSpan: TextSpan(
                children: [
                  const TextSpan(text: 'Add your best\n'),
                  const TextSpan(
                    text: 'photos',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: SizedBox(
                      width: 0,
                      height: d(_headingStar),
                      child: OverflowBox(
                        alignment: Alignment.centerLeft,
                        maxWidth: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.only(left: hd(_headingStarGap)),
                          child: const BubbaStar4(size: _headingStar),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              body:
                  'Great photos get better matches.\n'
                  'Add at least $minimumPhotos photos to get started',
              bodyBaseline: _bodyBaseline,
              onBack: onBack,
              ctaLabel: 'Continue',
              // p005 is the proof that Continue stays live: it shows the black
              // CTA with three photos and the "add at least 4" error, so the
              // count is validated on tap rather than by disabling the button.
              ctaEnabled: !_uploading,
              onCta: onContinue,
              stackedFooter: true,
              goBackBaseline: _showTips ? _goBackWithTips : null,
              content: (context, flow) {
                flow.block(
                  BubbaPhotoGrid(
                    photos: photos,
                    onAdd: onAdd,
                    onRemove: onRemove,
                    onReorder: onReorder,
                    onEdit: onEdit,
                  ),
                  top: _gridTop,
                  height: gridBottom - _gridTop,
                  left: BubbaPhotoGrid.left,
                  right: BubbaPhotoGrid.rightInset,
                );
                if (_filled > 0 && errorText == null) {
                  flow.copy(
                    'Hold and drag to reorder',
                    baseline: gridBottom + _reorderHintGap,
                    style: BubbaText.reorderHint,
                    left: _reorderHintX,
                  );
                }
                if (errorText != null) {
                  flow.block(
                    Row(
                      children: [
                        Container(
                          width: d(12.67),
                          height: d(12.67),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEA1C35),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            width: hd(1.58),
                            height: d(5.28),
                            color: BubbaColors.surface,
                          ),
                        ),
                        SizedBox(width: hd(3.45)),
                        Text(errorText!, style: BubbaText.photoError),
                      ],
                    ),
                    top: gridBottom + _errorGap - 10.03,
                    height: 12.67,
                    left: 29.11,
                  );
                }
                if (_showTips) {
                  flow.block(
                    const _TipsCard(),
                    top: _tipsY,
                    height: _tipsHeight,
                    left: _tipsX,
                    right: _tipsRightInset,
                  );
                }
              },
            ),
            if (sourceSheet)
              BubbaPhotoSourceSheet(
                pressed: pressedSource,
                onPick: onPickSource,
                onDismiss: onDismissSheet,
              ),
            if (_uploading)
              BubbaUploadToast(uploaded: uploaded!, total: uploadTotal!),
          ],
        ),
      ),
    );
  }
}

class _TipsCard extends StatelessWidget {
  const _TipsCard();

  @override
  Widget build(BuildContext context) => Container(
    height: d(_tipsHeight),
    decoration: BoxDecoration(
      color: BubbaColors.tipsBg,
      borderRadius: BorderRadius.circular(d(_tipsRadius)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: hd(_tipsBulbX)),
        Padding(
          padding: EdgeInsets.only(top: d(_tipsBulbY)),
          child: const BubbaBulb(),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: hd(_tipsTitleX - _tipsBulbX - _bulbWidth), right: hd(12)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BubbaCopy(
                  'Tips for great photos',
                  gapAbove: _tipsTitleBaseline,
                  style: BubbaText.tipsTitle,
                ),
                BubbaCopy(
                  'Use clear, well-lit photos. Show your face,\n'
                  'and try to add a little variaty.',
                  gapAbove: _tipsBodyBaseline -
                      _tipsTitleBaseline -
                      bubbaDesignTextMetrics(context, BubbaText.tipsTitle)
                          .descent,
                  style: BubbaText.tipsBody,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

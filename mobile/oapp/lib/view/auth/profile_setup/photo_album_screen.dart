import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_icons.dart';
import '../../../core/design/bubba_text_styles.dart';
import '../../../core/design/bubba_tokens.dart';
import '../../../core/design/widgets/bubba_loading.dart';

// p009 is a 385x846 artboard; these are the traced values scaled by 390/385
// horizontally and 843/846 vertically, the same as the library picker.
const double _chevronX = BubbaMetrics.backChevronX;
const double _chevronY = 62.99;
const double _chevronWidth = 7.68;
const double _chevronHeight = 15.35;
const double _chevronPad = 10.0;
const double _titleBaseline = 73.55;
const double _firstRowTop = 93.97;
const double _rowPitch = 93.57;
const double _thumbX = 23.30;
const double _thumbSize = 63.80;
const double _thumbRadius = 10.0;
const double _textX = 107.40;
const double _rowTitleBaseline = 43.77;
const double _rowSubtitleBaseline = 64.11;
const double _rowChevronInset = 22.99;
const double _dividerLeft = 21.74;

/// One row of the album list.
class PhotoAlbum {
  const PhotoAlbum({
    required this.name,
    required this.count,
    this.cover,
  });

  final String name;
  final int count;
  final ImageProvider? cover;
}

/// Artboard p009 - "Choose album", reached from the library picker's header.
class PhotoAlbumScreen extends StatelessWidget {
  const PhotoAlbumScreen({
    super.key,
    required this.albums,
    this.loading = false,
    this.onBack,
    this.onPick,
  });

  final List<PhotoAlbum> albums;
  final bool loading;
  final VoidCallback? onBack;
  final ValueChanged<PhotoAlbum>? onPick;

  /// "1,230 photos" - the design groups thousands with a comma.
  static String formatCount(int count) {
    final digits = count.toString();
    final out = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) out.write(',');
      out.write(digits[i]);
    }
    return '$out photo${count == 1 ? '' : 's'}';
  }

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
          contentStartY: _firstRowTop,
          header: (context) => _AlbumHeader(onBack: onBack),
          content: (context, flow) {
            if (loading) {
              flow.block(
                const BubbaSpinner(size: 28),
                top: _firstRowTop + 40,
                height: 28,
                align: Alignment.center,
              );
              return;
            }
            for (var i = 0; i < albums.length; i++) {
              flow.block(
                SizedBox(
                  height: d(_rowPitch),
                  child: _AlbumRow(
                    album: albums[i],
                    onTap: onPick == null ? null : () => onPick!(albums[i]),
                  ),
                ),
                top: _firstRowTop + _rowPitch * i,
                height: _rowPitch,
              );
              if (i < albums.length - 1) {
                flow.raw(
                  Padding(
                    padding: EdgeInsets.only(left: dx(_dividerLeft)),
                    child: Container(height: 1, color: const Color(0xFFE9E6E3)),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}

class _AlbumHeader extends StatelessWidget {
  const _AlbumHeader({this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final metrics = bubbaDesignTextMetrics(context, BubbaText.pickerAlbum);
    final titleTop = _titleBaseline - metrics.baseline;
    final chevronTop = _chevronY - _chevronPad;
    final rowTop = math.min(titleTop, chevronTop);
    final rowBottom = math.max(
      titleTop + metrics.lineHeight,
      chevronTop + _chevronHeight + _chevronPad * 2,
    );
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
                    strokeWidth: 1.737,
                    color: Color(0xFF000000),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: d(titleTop - rowTop)),
                child: Text(
                  'Choose album',
                  textAlign: TextAlign.center,
                  style: BubbaText.pickerAlbum,
                ),
              ),
            ),
            SizedBox(width: dx(_chevronX) + d(_chevronWidth + _chevronPad)),
          ],
        ),
        SizedBox(
          height: math.max(0, d(_firstRowTop - rowBottom)),
        ),
      ],
    );
  }
}

class _AlbumRow extends StatelessWidget {
  const _AlbumRow({required this.album, this.onTap});

  final PhotoAlbum album;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: '${album.name}, ${PhotoAlbumScreen.formatCount(album.count)}',
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Builder(
        builder: (context) {
          final titleMetrics =
              bubbaDesignTextMetrics(context, BubbaText.albumName);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(width: dx(_thumbX)),
              Center(
                child: Container(
                  width: d(_thumbSize),
                  height: d(_thumbSize),
                  decoration: BoxDecoration(
                    color: BubbaColors.photoTile,
                    borderRadius: BorderRadius.circular(d(_thumbRadius)),
                    image: album.cover == null
                        ? null
                        : DecorationImage(
                            image: album.cover!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              SizedBox(width: dx(_textX) - dx(_thumbX) - d(_thumbSize)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BubbaCopy(
                      album.name,
                      gapAbove: _rowTitleBaseline,
                      style: BubbaText.albumName,
                      maxLines: 1,
                    ),
                    BubbaCopy(
                      PhotoAlbumScreen.formatCount(album.count),
                      gapAbove: _rowSubtitleBaseline -
                          _rowTitleBaseline -
                          titleMetrics.descent,
                      style: BubbaText.albumCount,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              SizedBox(width: hd(20)),
              const Center(
                child: BubbaChevronRight(
                  width: 5.46,
                  height: 10.92,
                  strokeWidth: 2,
                  color: Color(0xFF8A847F),
                ),
              ),
              SizedBox(
                width: BubbaScale.availableWidth - dxRight(_rowChevronInset),
              ),
            ],
          );
        },
      ),
    ),
  );
}

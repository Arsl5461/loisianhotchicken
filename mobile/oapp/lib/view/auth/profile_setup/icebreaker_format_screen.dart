import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_glyphs.dart';
import '../../../core/design/bubba_icons.dart';
import '../../../core/design/bubba_text_styles.dart';
import '../../../core/design/bubba_tokens.dart';
import 'widgets/profile_step_scaffold.dart';

const double _firstCardY = 228.36;
const double _cardPitch = 139.16;
const double _cardHeight = 129.60;
const double _cardRadius = 12.41;
const double _stripeWidth = 6.0;
const double _circleInset = 13.72;
const double _circleSize = 61.17;
const double _copyInset = 86.43;
const double _titleBaseline = 49.71;
const double _bodyBaseline = 75.63;
const double _bodyLineHeight = 21.0;
const double _chevronInset = 15.12;

/// The three icebreaker formats, with the tint the design gives each one.
enum IcebreakerFormat {
  prompts(
    'Prompts',
    'Thoughtful answers that start\nmeaningful conversations',
    Color(0xFFCCDDD1),
    Color(0xFFCCDDD1),
    Color(0xFF094725),
    Color(0xFF094725),
    Color(0xFFECF2F1),
    Color(0xFFCDECDC),
  ),
  snaps(
    'Snaps',
    'Quick visual moments that\nshow your vibe',
    Color(0xFFD8E5EF),
    Color(0xFFD8E5EF),
    Color(0xFF3E66B0),
    Color(0xFF3E66B0),
    Color(0xFFEEF3FC),
    Color(0xFFD9E9FA),
  ),
  games(
    'Games',
    'Playful interactions that lead\nto conversations fast',
    Color(0xFFF2E6D7),
    Color(0xFFDBC8CA),
    Color(0xFFA4753B),
    Color(0xFF5B252F),
    Color(0xFFF1E7E6),
    Color(0xFFF1E7E6),
  );

  const IcebreakerFormat(
    this.title,
    this.body,
    this.tint,
    this.browseTint,
    this.accent,
    this.browseAccent,
    this.bannerFrom,
    this.bannerTo,
  );

  final String title;
  final String body;
  final Color tint;

  /// p040 tints the Games hero circle maroon where p039's format card tints it
  /// amber; Prompts and Snaps use one tint on both.
  final Color browseTint;
  final Color accent;

  /// p006/p040/p041 draw the Games mark in a deep maroon where p039's format
  /// card draws it in amber; every other mark is the same colour on both.
  final Color browseAccent;

  /// The browse screen's banner is a placed raster in the artboards; these are
  /// its left and right edge colours sampled off p006 / p040 / p041. Games is
  /// flat, so both stops are the same.
  final Color bannerFrom;
  final Color bannerTo;
}

/// Artboard p039 - "Pick a format for your first icebreaker".
class IcebreakerFormatScreen extends StatelessWidget {
  const IcebreakerFormatScreen({
    super.key,
    this.onBack,
    this.onPick,
  });

  final VoidCallback? onBack;
  final ValueChanged<IcebreakerFormat>? onPick;

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
          heading: 'Icebreakers',
          body: 'Pick a format for your first icebreaker',
          onBack: onBack,
          showFooter: false,
          backChevron: true,
          content: (context, flow) {
            for (var i = 0; i < IcebreakerFormat.values.length; i++) {
              flow.block(
                _FormatCard(
                  format: IcebreakerFormat.values[i],
                  onTap: onPick == null
                      ? null
                      : () => onPick!(IcebreakerFormat.values[i]),
                ),
                top: _firstCardY + _cardPitch * i,
                height: _cardHeight,
              );
            }
          },
        ),
      ),
    );
  }
}

class _FormatCard extends StatelessWidget {
  const _FormatCard({required this.format, this.onTap});

  final IcebreakerFormat format;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${format.title}. ${format.body.replaceAll('\n', ' ')}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          height: d(_cardHeight),
          decoration: BoxDecoration(
            color: BubbaColors.surface,
            borderRadius: BorderRadius.circular(d(_cardRadius)),
            border: Border.all(
              color: BubbaColors.border,
              width: BubbaMetrics.borderWidth,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: hd(_stripeWidth), color: format.accent),
              SizedBox(width: hd(_circleInset - _stripeWidth)),
              Center(child: _FormatBadge(format: format)),
              SizedBox(width: hd(_copyInset - _circleInset - _circleSize)),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BubbaCopy(
                      format.title,
                      gapAbove: _titleBaseline,
                      style: BubbaText.formatTitle,
                    ),
                    BubbaCopy(
                      format.body,
                      gapAbove: _bodyBaseline -
                          _titleBaseline -
                          bubbaDesignTextMetrics(context, BubbaText.formatTitle)
                              .descent,
                      style: BubbaText.formatBody
                          .copyWith(height: _bodyLineHeight / 14),
                    ),
                  ],
                ),
              ),
              const Align(child: BubbaChevronRight()),
              SizedBox(width: hd(_chevronInset)),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormatBadge extends StatelessWidget {
  const _FormatBadge({required this.format});

  final IcebreakerFormat format;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: d(_circleSize),
      height: d(_circleSize),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: format.tint, shape: BoxShape.circle),
      child: switch (format) {
        IcebreakerFormat.prompts =>
          BubbaGlyphIcon(BubbaGlyphs.quoteMark, color: format.accent, width: 26.42),
        IcebreakerFormat.snaps =>
          BubbaCameraGlyph(size: 20.19, color: format.accent),
        IcebreakerFormat.games =>
          BubbaSparkle(size: 22.0, color: format.accent),
      },
    );
  }
}

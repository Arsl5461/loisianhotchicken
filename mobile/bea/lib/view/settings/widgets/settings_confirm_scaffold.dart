import 'package:flutter/material.dart';

import '../../../core/design/bubba_glyphs.dart';
import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_settings_tokens.dart';
import '../../../core/design/widgets/bubba_loading.dart';
import 'settings_chrome.dart';

class SettingsCircleMark extends StatelessWidget {
  const SettingsCircleMark({
    super.key,
    required this.x,
    required this.color,
    this.glyph,
    this.glyphColor,
    this.glyphX,
    this.glyphY,
    this.glyphWidth,
    this.glyphHeight,
    this.photoUrl,
    this.semanticsLabel,
    required this.top,
  });

  final double x;
  final Color color;
  final BubbaGlyph? glyph;
  final Color? glyphColor;
  final double? glyphX;
  final double? glyphY;
  final double? glyphWidth;
  final double? glyphHeight;
  final String? photoUrl;
  final String? semanticsLabel;
  final double top;

  @override
  Widget build(BuildContext context) {
    const size = BubbaSettingsMetrics.markCircleSize;
    final fill = Container(
      width: d(size),
      height: d(size),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
    final url = photoUrl;
    final circle = url == null || url.isEmpty
        ? fill
        : ClipOval(
            child: Image.network(
              url,
              width: d(size),
              height: d(size),
              fit: BoxFit.cover,
              semanticLabel: semanticsLabel,
              errorBuilder: (context, error, stack) => fill,
              frameBuilder: (context, child, frame, wasSynchronous) =>
                  frame == null && !wasSynchronous ? fill : child,
            ),
          );
    return Row(
      children: [
        SizedBox(width: hd(x)),
        SizedBox(
          width: d(size),
          height: d(size),
          child: glyph == null
              ? circle
              : Stack(
                  children: [
                    circle,
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: hd(glyphX! - x),
                          top: d(glyphY! - top),
                        ),
                        child: BubbaGlyphIcon(
                          glyph!,
                          color: glyphColor ?? BubbaSettingsColors.rowIcon,
                          width: glyphWidth,
                          height: glyphHeight,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class SettingsCtaButton extends StatelessWidget {
  const SettingsCtaButton({
    super.key,
    required this.label,
    required this.fill,
    this.labelColor,
    this.onTap,
    this.busy = false,
  });

  final String label;
  final Color fill;
  final Color? labelColor;
  final VoidCallback? onTap;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final metrics = bubbaDesignTextMetrics(context, BubbaSettingsText.ctaLabel);
    final labelTop = BubbaSettingsMetrics.ctaLabelBaseline -
        BubbaSettingsMetrics.ctaY -
        metrics.baseline;
    return Row(
      children: [
        SizedBox(width: hd(BubbaSettingsMetrics.ctaX)),
        Semantics(
          button: true,
          enabled: onTap != null,
          label: label,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: busy ? null : onTap,
            child: Container(
              width: hd(BubbaSettingsMetrics.ctaWidth),
              height: d(BubbaSettingsMetrics.ctaHeight),
              decoration: BoxDecoration(
                color: fill,
                borderRadius:
                    BorderRadius.circular(d(BubbaSettingsMetrics.ctaRadius)),
              ),
              alignment: busy ? Alignment.center : null,
              child: busy
                  ? const BubbaSpinner(size: 22, color: Colors.white)
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: d(labelTop)),
                  Text(
                    label,
                    style: labelColor == null
                        ? BubbaSettingsText.ctaLabel
                        : BubbaSettingsText.ctaLabel
                            .copyWith(color: labelColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SettingsCancelLink extends StatelessWidget {
  const SettingsCancelLink({
    super.key,
    this.label = 'Cancel',
    this.style,
    this.onTap,
  });

  final String label;
  final TextStyle? style;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: label,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: SizedBox(
            height: BubbaScale.tapBox(d(20)),
            child: Center(
              child: Text(label, style: style ?? BubbaSettingsText.cancelLabel),
            ),
          ),
        ),
      );
}

class SettingsCardItem {
  const SettingsCardItem({
    required this.glyph,
    required this.iconX,
    required this.iconY,
    required this.iconWidth,
    required this.iconHeight,
    required this.label,
    required this.labelX,
    required this.labelBaseline,
    this.iconColor = BubbaSettingsColors.rowIcon,
  });

  final BubbaGlyph glyph;
  final double iconX;
  final double iconY;
  final double iconWidth;
  final double iconHeight;
  final String label;
  final double labelX;
  final double labelBaseline;
  final Color iconColor;
}

class SettingsInfoCard extends StatelessWidget {
  const SettingsInfoCard({
    super.key,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.fill,
    required this.title,
    required this.titleX,
    required this.titleBaseline,
    required this.items,
  });

  final double x;
  final double y;
  final double width;
  final double height;
  final Color fill;
  final String title;
  final double titleX;
  final double titleBaseline;
  final List<SettingsCardItem> items;

  @override
  Widget build(BuildContext context) {
    final titleMetrics = bubbaDesignTextMetrics(context, BubbaSettingsText.cardTitle);
    final itemMetrics = bubbaDesignTextMetrics(context, BubbaSettingsText.cardItem);
    return Row(
      children: [
        SizedBox(width: hd(x)),
        Container(
          width: hd(width),
          height: d(height),
          decoration: BoxDecoration(
            color: fill,
            borderRadius:
                BorderRadius.circular(d(BubbaSettingsMetrics.cardRadius)),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: hd(titleX - x),
                    top: d(titleBaseline - y - titleMetrics.baseline),
                  ),
                  child: Text(title, style: BubbaSettingsText.cardTitle),
                ),
              ),
              for (final item in items) ...[
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: hd(item.iconX - x),
                      top: d(item.iconY - y),
                    ),
                    child: BubbaGlyphIcon(
                      item.glyph,
                      color: item.iconColor,
                      width: item.iconWidth,
                      height: item.iconHeight,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: hd(item.labelX - x),
                      top: d(item.labelBaseline - y - itemMetrics.baseline),
                    ),
                    child: Text(item.label, style: BubbaSettingsText.cardItem),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class SettingsAnchoredBlock {
  const SettingsAnchoredBlock({
    required this.child,
    required this.top,
    required this.height,
  });

  final Widget child;
  final double top;
  final double height;
}

class SettingsConfirmView extends StatelessWidget {
  const SettingsConfirmView({
    super.key,
    required this.navTitle,
    required this.circle,
    required this.heading,
    required this.headingBaseline,
    required this.body,
    required this.bodyBaseline,
    this.bodyLines = 2,
    this.card,
    this.middle,
    required this.ctaLabel,
    required this.ctaFill,
    this.ctaLabelColor,
    this.onCta,
    this.onCancel,
    this.onBack,
  });

  final String navTitle;
  final SettingsCircleMark circle;
  final String heading;
  final double headingBaseline;
  final String body;
  final double bodyBaseline;
  final int bodyLines;
  final SettingsInfoCard? card;
  final SettingsAnchoredBlock? middle;
  final String ctaLabel;
  final Color ctaFill;
  final Color? ctaLabelColor;
  final VoidCallback? onCta;
  final VoidCallback? onCancel;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: BubbaSettingsColors.pageBg,
        body: BubbaPage(
          padContent: false,
          background: BubbaSettingsColors.pageBg,
          content: _content,
        ),
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.block(
      SettingsNavBar(title: navTitle, onBack: onBack),
      top: 0,
      height: BubbaSettingsMetrics.navHeight,
    );

    flow.block(
      circle,
      top: circle.top,
      height: BubbaSettingsMetrics.markCircleSize,
    );

    final headingMetrics = bubbaDesignTextMetrics(context, BubbaSettingsText.heading);
    flow.block(
      Text(
        heading,
        textAlign: TextAlign.center,
        style: BubbaSettingsText.heading,
      ),
      top: headingBaseline - headingMetrics.baseline,
      height: headingMetrics.lineHeight,
    );

    final bodyMetrics = bubbaDesignTextMetrics(context, BubbaSettingsText.bodyCentred);
    flow.block(
      Text(
        body,
        textAlign: TextAlign.center,
        style: BubbaSettingsText.bodyCentred,
      ),
      top: bodyBaseline - bodyMetrics.baseline,
      height: bodyMetrics.lineHeight * bodyLines,
    );

    if (card != null) {
      flow.block(card!, top: card!.y, height: card!.height);
    }
    if (middle != null) {
      flow.block(middle!.child, top: middle!.top, height: middle!.height);
    }

    flow.block(
      SettingsCtaButton(
        label: ctaLabel,
        fill: ctaFill,
        labelColor: ctaLabelColor,
        onTap: onCta,
      ),
      top: BubbaSettingsMetrics.ctaY,
      height: BubbaSettingsMetrics.ctaHeight,
    );

    final cancelMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.cancelLabel);
    final cancelBox =
        BubbaScale.tapBox(d(cancelMetrics.lineHeight)) / BubbaScale.factor;
    flow.block(
      SettingsCancelLink(onTap: onCancel),
      top: BubbaSettingsMetrics.cancelBaseline -
          cancelMetrics.baseline -
          (cancelBox - cancelMetrics.lineHeight) / 2,
      height: cancelBox,
    );
  }
}

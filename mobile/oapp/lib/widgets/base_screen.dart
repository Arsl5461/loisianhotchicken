import 'package:flutter/material.dart';
import '../utils/media_query.dart';

/// Base screen widget that provides responsive design capabilities
/// All screens should extend this widget for consistent responsive behavior
abstract class BaseScreen extends StatelessWidget {
  const BaseScreen({super.key});

  /// Build the screen content
  Widget buildScreen(BuildContext context);

  /// Optional: Override to provide custom app bar
  PreferredSizeWidget? appBar(BuildContext context) => null;

  /// Optional: Override to provide custom bottom navigation
  Widget? bottomNavigationBar(BuildContext context) => null;

  /// Optional: Override to provide custom floating action button
  Widget? floatingActionButton(BuildContext context) => null;

  /// Optional: Override to provide custom drawer
  Widget? drawer(BuildContext context) => null;

  /// Optional: Override to provide custom end drawer
  Widget? endDrawer(BuildContext context) => null;

  /// Optional: Override to provide custom background color
  Color? backgroundColor(BuildContext context) => null;

  /// Optional: Override to provide custom body padding
  EdgeInsets? bodyPadding(BuildContext context) => null;

  /// Optional: Override to provide custom resize behavior
  bool? resizeToAvoidBottomInset(BuildContext context) => true;

  @override
  Widget build(BuildContext context) {
    // Initialize MediaQueryUtil for consistent responsive behavior
    MediaQueryUtil.init(context);

    return Scaffold(
      appBar: appBar(context),
      backgroundColor:
          backgroundColor(context) ?? Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding:
              bodyPadding(context) ??
              EdgeInsets.symmetric(
                horizontal: MediaQueryUtil.spacing(24),
                vertical: MediaQueryUtil.spacing(12),
              ),
          child: buildScreen(context),
        ),
      ),
      bottomNavigationBar: bottomNavigationBar(context),
      floatingActionButton: floatingActionButton(context),
      drawer: drawer(context),
      endDrawer: endDrawer(context),
      resizeToAvoidBottomInset: resizeToAvoidBottomInset(context),
    );
  }
}

/// Responsive text widget that automatically adjusts based on screen size
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;

  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontSize,
    this.fontWeight,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    final responsiveStyle =
        style?.copyWith(
          fontSize: fontSize != null
              ? MediaQueryUtil.fontSize(fontSize!)
              : style?.fontSize,
          fontWeight: fontWeight ?? style?.fontWeight,
          color: color ?? style?.color,
        ) ??
        TextStyle(
          fontSize: fontSize != null
              ? MediaQueryUtil.fontSize(fontSize!)
              : MediaQueryUtil.fontSize(14),
          fontWeight: fontWeight,
          color: color,
        );

    return Text(
      text,
      style: responsiveStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Responsive container widget that automatically adjusts padding and margins
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final Color? color;
  final Decoration? decoration;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.color,
    this.decoration,
    this.borderRadius,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration:
          decoration ??
          BoxDecoration(
            color: color,
            borderRadius: borderRadius != null
                ? BorderRadius.circular(MediaQueryUtil.spacing(borderRadius!))
                : null,
            boxShadow: boxShadow,
          ),
      child: child,
    );
  }
}

/// Responsive spacing widget
class ResponsiveSpacing extends StatelessWidget {
  final double height;
  final double? width;

  const ResponsiveSpacing({super.key, required this.height, this.width});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return SizedBox(
      height: MediaQueryUtil.spacing(height),
      width: width != null ? MediaQueryUtil.spacing(width!) : null,
    );
  }
}

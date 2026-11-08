import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../utils/svg_paint_util.dart';

class CustomSvgIcons {
  // SVG asset paths for bottom navigation icons
  static const String _iconHome = 'assets/icons/home.svg';
  static const String _iconHeart = 'assets/icons/heart.svg';
  static const String _iconMessage = 'assets/icons/message.svg';
  static const String _iconUser = 'assets/icons/user.svg';
  static const String _iconPlus = 'assets/icons/plus.svg';
  static const String _iconFilter = 'assets/icons/filter.svg';
  static const String _iconBack = 'assets/icons/back.svg';
  static const String _iconBirthday = 'assets/icons/birthday.svg';
  static const String _iconHeight = 'assets/icons/height.svg';
  static const String _iconLanguage = 'assets/icons/language.svg';
  static const String _iconAgnostic = 'assets/icons/agnostic.svg';
  static const String _iconLiberal = 'assets/icons/liberal.svg';
  static const String _iconRaisedIn = 'assets/icons/raised_in.svg';
  static const String _iconWorks = 'assets/icons/works.svg';
  static const String _iconStudied = 'assets/icons/studied.svg';
  static const String _iconThumbsDown = 'assets/icons/thumbs_down.svg';
  static const String _iconThumbsUp = 'assets/icons/thumbs_up.svg';
  static const String _iconDatingPreferences =
      'assets/icons/dating_preferences.svg';
  static const String _iconInviteFriend = 'assets/icons/invite_friend.svg';
  static const String _iconSettings = 'assets/icons/settings.svg';
  static const String _iconSupport = 'assets/icons/support.svg';
  static const String _iconEditProfile = 'assets/icons/edit_profile.svg';

  /// One place to handle SVG crashes + log which asset caused it.
  static Widget _safePaintSvg({
    required String assetPath,
    required Color color,
    required double size,
    required IconData fallbackIcon,
    required String semanticsLabel,
  }) {
    Widget fallback(BuildContext context) =>
        Icon(fallbackIcon, color: color, size: size);

    // Extra safety: if any FlutterError is thrown during build/paint,
    // show fallback instead of crashing and log details.
    return _ErrorBoundary(
      label: semanticsLabel,
      assetPath: assetPath,
      fallbackBuilder: fallback,
      child: SvgPaintUtil.paintSvg(
        assetPath: assetPath,
        color: color,
        size: size,
        semanticsLabel: semanticsLabel,
        placeholderBuilder: fallback,
      ),
    );
  }

  // Message Circle Icon
  static Widget messageCircle({required Color color, required double size}) {
    return _safePaintSvg(
      assetPath: _iconMessage,
      color: color,
      size: size,
      fallbackIcon: LucideIcons.messageCircle,
      semanticsLabel: 'Message',
    );
  }

  // Heart Icon
  static Widget heart({required Color color, required double size}) {
    return _safePaintSvg(
      assetPath: _iconHeart,
      color: color,
      size: size,
      fallbackIcon: LucideIcons.heart,
      semanticsLabel: 'Heart',
    );
  }

  // Circle Plus Icon
  static Widget circlePlus({required Color color, required double size}) {
    return _safePaintSvg(
      assetPath: _iconPlus,
      color: color,
      size: size,
      fallbackIcon: LucideIcons.plusCircle,
      semanticsLabel: 'Add',
    );
  }

  // House Icon
  static Widget houseHeart({required Color color, required double size}) {
    return _safePaintSvg(
      assetPath: _iconHome,
      color: color,
      size: size,
      fallbackIcon: LucideIcons.home,
      semanticsLabel: 'Home',
    );
  }

  // Circle User Icon
  static Widget circleUser({required Color color, required double size}) {
    return _safePaintSvg(
      assetPath: _iconUser,
      color: color,
      size: size,
      fallbackIcon: LucideIcons.userCircle,
      semanticsLabel: 'Profile',
    );
  }

  // Filter Icon
  static Widget filter({required Color color, required double size}) {
    return _safePaintSvg(
      assetPath: _iconFilter,
      color: color,
      size: size,
      fallbackIcon: LucideIcons.slidersHorizontal,
      semanticsLabel: 'Filter',
    );
  }

  // Back Arrow Icon
  static Widget backArrow({required Color color, required double size}) {
    return _safePaintSvg(
      assetPath: _iconBack,
      color: color,
      size: size,
      fallbackIcon: LucideIcons.arrowLeft,
      semanticsLabel: 'Back',
    );
  }

  // Birthday Icon
  static Widget birthday({required Color color, required double size}) {
    return _safePaintSvg(
      assetPath: _iconBirthday,
      color: color,
      size: size,
      fallbackIcon: LucideIcons.cake,
      semanticsLabel: 'Birthday',
    );
  }

  // Height Icon
  static Widget height({required Color color, required double size}) {
    return _safePaintSvg(
      assetPath: _iconHeight,
      color: color,
      size: size,
      fallbackIcon: LucideIcons.ruler,
      semanticsLabel: 'Height',
    );
  }

  // Language Icon
  static Widget language({required Color color, required double size}) {
    return _safePaintSvg(
      assetPath: _iconLanguage,
      color: color,
      size: size,
      fallbackIcon: LucideIcons.languages,
      semanticsLabel: 'Language',
    );
  }

  // Agnostic/Religion Icon
  static Widget agnostic({required Color color, required double size}) {
    return _safePaintSvg(
      assetPath: _iconAgnostic,
      color: color,
      size: size,
      fallbackIcon: LucideIcons.bookOpen,
      semanticsLabel: 'Religion',
    );
  }

  // Liberal/Political Icon
  static Widget liberal({required Color color, required double size}) {
    return _safePaintSvg(
      assetPath: _iconLiberal,
      color: color,
      size: size,
      fallbackIcon: LucideIcons.scale,
      semanticsLabel: 'Political',
    );
  }

  // Raised In Icon
  static Widget raisedIn({required Color color, required double size}) {
    return _safePaintSvg(
      assetPath: _iconRaisedIn,
      color: color,
      size: size,
      fallbackIcon: LucideIcons.home,
      semanticsLabel: 'Raised In',
    );
  }

  // Works Icon
  static Widget works({required Color color, required double size}) {
    return _safePaintSvg(
      assetPath: _iconWorks,
      color: color,
      size: size,
      fallbackIcon: LucideIcons.briefcase,
      semanticsLabel: 'Works',
    );
  }

  // Studied Icon
  static Widget studied({required Color color, required double size}) {
    return _safePaintSvg(
      assetPath: _iconStudied,
      color: color,
      size: size,
      fallbackIcon: LucideIcons.graduationCap,
      semanticsLabel: 'Study',
    );
  }

  // Thumbs Down Icon
  static Widget thumbsDown({required Color color, required double size}) {
    return _safePaintSvg(
      assetPath: _iconThumbsDown,
      color: color,
      size: size,
      fallbackIcon: LucideIcons.thumbsDown,
      semanticsLabel: 'Thumbs Down',
    );
  }

  // Thumbs Up Icon
  static Widget thumbsUp({required Color color, required double size}) {
    return _safePaintSvg(
      assetPath: _iconThumbsUp,
      color: color,
      size: size,
      fallbackIcon: LucideIcons.thumbsUp,
      semanticsLabel: 'Thumbs Up',
    );
  }

  // Dating Preferences Icon
  static Widget datingPreferences({
    required Color color,
    required double size,
  }) {
    return _safePaintSvg(
      assetPath: _iconDatingPreferences,
      color: color,
      size: size,
      fallbackIcon: LucideIcons.slidersHorizontal,
      semanticsLabel: 'Dating Preferences',
    );
  }

  // Invite Friend Icon
  static Widget inviteFriend({required Color color, required double size}) {
    return _safePaintSvg(
      assetPath: _iconInviteFriend,
      color: color,
      size: size,
      fallbackIcon: LucideIcons.link,
      semanticsLabel: 'Invite Friend',
    );
  }

  // Settings Icon
  static Widget settings({required Color color, required double size}) {
    return _safePaintSvg(
      assetPath: _iconSettings,
      color: color,
      size: size,
      fallbackIcon: LucideIcons.settings,
      semanticsLabel: 'Settings',
    );
  }

  // Support Icon
  static Widget support({required Color color, required double size}) {
    return _safePaintSvg(
      assetPath: _iconSupport,
      color: color,
      size: size,
      fallbackIcon: LucideIcons.alertCircle,
      semanticsLabel: 'Support',
    );
  }

  // Edit Profile Icon
  static Widget editProfile({required Color color, required double size}) {
    return _safePaintSvg(
      assetPath: _iconEditProfile,
      color: color,
      size: size,
      fallbackIcon: LucideIcons.userSquare,
      semanticsLabel: 'Edit Profile',
    );
  }

  // Generic method to paint any SVG icon from assets
  static Widget paintSvgIcon({
    required String assetPath,
    required Color color,
    required double size,
    IconData fallbackIcon = LucideIcons.imageOff,
    String semanticsLabel = 'Icon',
  }) {
    return _safePaintSvg(
      assetPath: assetPath,
      color: color,
      size: size,
      fallbackIcon: fallbackIcon,
      semanticsLabel: semanticsLabel,
    );
  }
}

/// A small error boundary that prevents SVG parsing errors from crashing the app.
/// It replaces the widget with a fallback icon and logs the failing asset path.
///
/// This helps for cases where SVG parsing throws during build/paint and isn't handled
/// by placeholderBuilder alone.
class _ErrorBoundary extends StatefulWidget {
  final Widget child;
  final String assetPath;
  final String label;
  final WidgetBuilder fallbackBuilder;

  const _ErrorBoundary({
    required this.child,
    required this.assetPath,
    required this.label,
    required this.fallbackBuilder,
  });

  @override
  State<_ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<_ErrorBoundary> {
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    // If something throws asynchronously during SVG decoding/painting,
    // catch it and switch to fallback.
    FlutterError.onError = (FlutterErrorDetails details) {
      // Keep default behavior too
      FlutterError.presentError(details);

      final exceptionText = details.exceptionAsString();
      // Your specific crash often contains: "First character of a number must be one of"
      final looksLikeSvgParse =
          exceptionText.contains('path_parsing') ||
          exceptionText.contains('parseSvgPathData') ||
          exceptionText.contains('First character of a number') ||
          exceptionText.contains('vector_graphics_compiler');

      if (looksLikeSvgParse && mounted) {
        setState(() => _hasError = true);
        debugPrint(
          'SVG ERROR (${widget.label}): ${widget.assetPath}\n$exceptionText\n${details.stack}',
        );
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) return widget.fallbackBuilder(context);

    // Also catch sync build errors.
    try {
      return widget.child;
    } catch (e, st) {
      debugPrint(
        'SVG BUILD ERROR (${widget.label}): ${widget.assetPath}\n$e\n$st',
      );
      return widget.fallbackBuilder(context);
    }
  }
}

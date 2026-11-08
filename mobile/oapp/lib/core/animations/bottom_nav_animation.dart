// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../../utils/scroll_notifier.dart';

/// Simple animation controller.dart for bottom navigation bar visibility
class BottomNavAnimationController {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isVisible = true;

  BottomNavAnimationController({
    required TickerProvider vsync,
    Duration duration = const Duration(milliseconds: 100),
  }) {
    _controller = AnimationController(duration: duration, vsync: vsync);
    _animation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  Animation<double> get animation => _animation;
  bool get isVisible => _isVisible;

  void hide() {
    if (_isVisible) {
      _isVisible = false;
      _controller.forward();
    }
  }

  void show() {
    if (!_isVisible) {
      _isVisible = true;
      _controller.reverse();
    }
  }

  void dispose() {
    _controller.dispose();
  }
}

/// Widget that animates the bottom navigation bar based on scroll direction
class AnimatedBottomNavBar extends StatefulWidget {
  final Widget child;

  const AnimatedBottomNavBar({super.key, required this.child});

  @override
  _AnimatedBottomNavBarState createState() => _AnimatedBottomNavBarState();
}

class _AnimatedBottomNavBarState extends State<AnimatedBottomNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0, // Start visible (nav bar shown)
      end: 1.0, // End hidden (nav bar hidden)
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Listen to scroll notifier changes
    globalScrollNotifier.addListener(_onScrollStateChanged);
  }

  @override
  void dispose() {
    globalScrollNotifier.removeListener(_onScrollStateChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onScrollStateChanged() {
    if (globalScrollNotifier.isBottomNavVisible) {
      _controller.reverse(); // Show nav bar (animation value 0.0 = visible)
    } else {
      _controller.forward(); // Hide nav bar (animation value 1.0 = hidden)
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // If nav bar is completely hidden, don't render it at all
        if (_animation.value >= 0.95) {
          return SizedBox.shrink(); // No space occupied
        }

        return Transform.translate(
          offset: Offset(0, _animation.value * 80), // Slide down when hiding
          child: Opacity(
            opacity:
                1.0 -
                _animation
                    .value, // Complete fade out (1.0 when visible, 0.0 when hidden)
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Scroll detector widget that triggers bottom nav animations
class ScrollDetector extends StatefulWidget {
  final Widget child;
  final ScrollNotifier scrollNotifier;
  final double threshold;

  const ScrollDetector({
    super.key,
    required this.child,
    required this.scrollNotifier,
    this.threshold = 20.0, // Reduced threshold for more responsive detection
  });

  @override
  _ScrollDetectorState createState() => _ScrollDetectorState();
}

class _ScrollDetectorState extends State<ScrollDetector> {
  double _lastScrollPosition = 0.0;
  bool _isInitialized = false;

  bool _onScroll(ScrollNotification notification) {
    final currentPosition = notification.metrics.pixels;
    final maxScrollExtent = notification.metrics.maxScrollExtent;

    // Initialize on first scroll
    if (!_isInitialized) {
      _lastScrollPosition = currentPosition;
      _isInitialized = true;
      // Show nav bar at initial position (at top)
      widget.scrollNotifier.showBottomNav();
      return false;
    }

    final delta = currentPosition - _lastScrollPosition;

    // Check if we're at the bottom
    final isAtBottom = currentPosition >= maxScrollExtent - 10;

    // Check if we're at the top
    final isAtTop = currentPosition <= 10;

    if (isAtTop) {
      // At top - show nav bar
      widget.scrollNotifier.showBottomNav();
    } else if (isAtBottom) {
      // At bottom - hide nav bar
      widget.scrollNotifier.hideBottomNav();
    } else if (delta > widget.threshold) {
      // Scrolling down - hide bottom nav with fade
      widget.scrollNotifier.hideBottomNav();
    } else if (delta < -widget.threshold) {
      // Scrolling up - show bottom nav with fade
      widget.scrollNotifier.showBottomNav();
    }

    _lastScrollPosition = currentPosition;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _onScroll,
      child: widget.child,
    );
  }
}

import 'package:flutter/material.dart';

/// Simple notifier to communicate scroll state between screens and the bottom navigation bar
class ScrollNotifier extends ChangeNotifier {
  bool _isBottomNavVisible = true; // Start with nav bar visible

  bool get isBottomNavVisible => _isBottomNavVisible;

  void hideBottomNav() {
    if (_isBottomNavVisible) {
      _isBottomNavVisible = false;
      notifyListeners();
    }
  }

  void showBottomNav() {
    if (!_isBottomNavVisible) {
      _isBottomNavVisible = true;
      notifyListeners();
    }
  }

  void resetToVisible() {
    _isBottomNavVisible = true;
    notifyListeners();
  }
}

/// Global scroll notifier instance
final ScrollNotifier globalScrollNotifier = ScrollNotifier();

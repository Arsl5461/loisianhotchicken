import 'dart:async';

import 'package:OApp/utils/media_query.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/core/typography/app_text_styles.dart';
import 'package:get/get.dart';

class DialogMessage {
  final String? title;
  final String? subheading;
  final String? okText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const DialogMessage({
    this.title,
    this.subheading,
    this.okText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
  });
}

class DialogService {
  DialogService._internal();
  static final DialogService instance = DialogService._internal();

  factory DialogService() => instance;
  OverlayEntry? _currentOverlay;
  Future<void> showIntroBubble({
    required String text,
    required Offset position,
    bool isReversed = false,
  }) {
    final completer = Completer<void>();

    final overlayContext = Get.overlayContext;

    if (overlayContext == null) {
      debugPrint("❌ No overlay context found");
      completer.complete();
      return completer.future;
    }

    final overlayState = Navigator.of(overlayContext).overlay;

    if (overlayState == null) {
      debugPrint("❌ No overlay state found");
      completer.complete();
      return completer.future;
    }

    void remove() {
      _removeCurrent();
      if (!completer.isCompleted) {
        completer.complete(); // 👈 notify awaiter
      }
    }

    _removeCurrent();

    _currentOverlay = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: remove,
                child: Container(color: Colors.transparent),
              ),
            ),
            Positioned(
              left: position.dx,
              top: position.dy,
              child: IntroBubble(
                text: text,
                onClose: remove,
                isReversed: isReversed,
              ),
            ),
          ],
        );
      },
    );

    overlayState.insert(_currentOverlay!);

    return completer.future;
  }

  void _removeCurrent() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }

  /// Returns:
  /// - true  => OK / primary action tapped
  /// - false => Cancel tapped
  /// - null  => dismissed outside / back gesture
  Future<bool?> selectionDialog({DialogMessage? message}) async {
    final context = Get.context!;

    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  message?.title ?? 'Are you sure you want to unmatch?',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.medium(
                    fontFamily: AppFontFamily.publicSans,
                    fontWeight: AppFontWeight.semiBold,
                  ),
                ),

                const SizedBox(height: 12),

                // Subtitle
                Text(
                  message?.subheading ??
                      'Unmatching will permanently remove this member from your matches and any ability to communicate',
                  textAlign: TextAlign.center,

                  style: AppTextStyles.small(
                    color: AppColors.grey[600],
                    fontWeight: AppFontWeight.semi,
                    fontFamily: AppFontFamily.publicSans,
                  ),
                ),

                const SizedBox(height: 24),

                // Buttons Row
                Row(
                  children: [
                    // Unmatch Button (Primary)
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context, true);
                          message?.onConfirm?.call();
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFF006A68), // green
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            message?.okText ?? 'Unmatch',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Cancel Button
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context, false),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.grey[400] ?? AppColors.darkGrey,
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            message?.cancelText ?? 'Cancel',
                            style: TextStyle(
                              color: AppColors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<T?> showAppDialog<T>({
    DialogMessage? message,
    bool showSecondary = false,
    bool barrierDismissible = true,
    Color primaryColor = const Color(0xFF006A68),
    Color? secondaryBorderColor,
    Color? secondaryTextColor,
    T? primaryResult,
    T? secondaryResult,
  }) async {
    final context = Get.context!;

    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                if (message?.title != null) ...[
                  Text(
                    message!.title!,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.medium(
                      fontFamily: AppFontFamily.publicSans,
                      fontWeight: AppFontWeight.semiBold,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Subtitle
                if (message?.subheading != null) ...[
                  Text(
                    message!.subheading!,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.small(
                      color: AppColors.grey[600],
                      fontWeight: AppFontWeight.semiBold,
                      fontFamily: AppFontFamily.publicSans,
                    ),
                  ),
                  const SizedBox(height: 44),
                ],

                // Buttons
                Row(
                  children: [
                    // Primary Button
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context, primaryResult),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            message?.okText ?? 'OK',
                            style: AppTextStyles.regular(
                              color: Colors.white,
                              fontWeight: AppFontWeight.bold,
                              fontFamily: AppFontFamily.publicSans,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Secondary Button (optional)
                    if (showSecondary) ...[
                      const SizedBox(width: 12),

                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context, secondaryResult),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    secondaryBorderColor ??
                                    AppColors.grey[400] ??
                                    AppColors.darkGrey,
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              message?.cancelText ?? 'Cancel',
                              style: AppTextStyles.small(
                                color:
                                    secondaryTextColor ?? AppColors.grey[600],
                                fontWeight: AppFontWeight.semi,
                                fontFamily: AppFontFamily.publicSans,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showCustomActionSheet({
    required BuildContext context,
    bool showCancel = false,
    required List<ActionSheetItem> actions,
  }) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: actions.map((item) {
          return Container(
            color: Colors.white,
            child: CupertinoActionSheetAction(
              isDestructiveAction: item.isDestructive,
              onPressed: () {
                Navigator.of(context).pop();
                item.onTap();
              },
              child: Text(
                item.title,
                style: AppTextStyles.small(
                  fontFamily: AppFontFamily.publicSans,
                  fontWeight: AppFontWeight.semiBold,
                  color: item.isDestructive ? Colors.red : Colors.black,
                ),
              ),
            ),
          );
        }).toList(),

        cancelButton: showCancel
            ? Container(
                color: Colors.white,
                child: CupertinoActionSheetAction(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: AppTextStyles.small(
                      fontFamily: AppFontFamily.publicSans,
                      fontWeight: AppFontWeight.semiBold,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Future<void> showMatchActionSheet({
    required BuildContext context,
    required VoidCallback onUnmatch,
    required VoidCallback onHide,
    required VoidCallback onReport,
  }) async {
    showCustomActionSheet(
      context: context,
      actions: [
        ActionSheetItem(
          title: 'Unmatch',

          onTap: onUnmatch,
          textStyle: AppTextStyles.small(
            fontFamily: AppFontFamily.publicSans,
            fontWeight: AppFontWeight.semiBold,
            color: AppColors.red,
          ),
          isDestructive: true,
        ),
        ActionSheetItem(title: 'Hide', onTap: onHide),
        ActionSheetItem(title: 'Report', onTap: onReport),
        ActionSheetItem(
          title: 'Cancel',
          onTap: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Future<void> showConfirmationBottomSheet({
    required DialogMessage message,
  }) async {
    final context = Get.context!;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Close Icon
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, size: 30),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 5,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),

                      /// Title
                      Text(
                        message.title ?? "",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.medium(
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// Description
                      Text(
                        message.subheading ?? "",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.verySmall(color: Colors.black),
                      ),

                      const SizedBox(height: 20),

                      /// Confirm Button
                      SizedBox(
                        width: MediaQueryUtil.width * 0.4,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            message.onConfirm?.call();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            message.okText ?? "Confirm",
                            style: AppTextStyles.regular(
                              fontWeight: AppFontWeight.semiBold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// Cancel Button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          message.cancelText ?? "Cancel",
                          style: AppTextStyles.regular(
                            fontWeight: AppFontWeight.semiBold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ActionSheetItem {
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;
  final TextStyle? textStyle;

  ActionSheetItem({
    this.textStyle,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });
}

class IntroBubble extends StatelessWidget {
  final String text;
  final VoidCallback onClose;
  final bool isReversed;

  const IntroBubble({
    super.key,
    required this.text,
    required this.onClose,
    this.isReversed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          /// Main Box — tap anywhere on the bubble to dismiss
          GestureDetector(
            onTap: onClose,
            child: Container(
              width: 230,
              padding: EdgeInsets.symmetric(
                horizontal: MediaQueryUtil.spacing(16),
                vertical: MediaQueryUtil.spacing(25),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.5),
                    offset: Offset(2, 2), // Shadow to bottom and left
                    blurRadius: 1,
                    spreadRadius: -1,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  text,
                  style: AppTextStyles.small(fontWeight: AppFontWeight.semi),
                ),
              ),
            ),
          ),

          /// Close Button (flips left/right)
          Positioned(
            top: -10,
            right: isReversed ? null : -10,
            left: isReversed ? -10 : null,
            child: GestureDetector(
              onTap: onClose,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200]!.withValues(alpha: 0.8),
                ),
                padding: const EdgeInsets.all(6),
                child: Icon(Icons.close, size: 16, color: AppColors.grey[600]),
              ),
            ),
          ),

          /// Triangle (flips left/right)
          Positioned(
            top: -10,
            left: isReversed ? null : 20,
            right: isReversed ? 20 : null,
            child: CustomPaint(
              size: const Size(20, 10),
              painter: _TrianglePainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

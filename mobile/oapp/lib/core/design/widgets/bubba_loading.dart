import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../bubba_tokens.dart';

class BubbaSpinner extends StatelessWidget {
  const BubbaSpinner({
    super.key,
    this.size = 20,
    this.color,
    this.strokeWidth = 2,
  });

  final double size;
  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? BubbaColors.actionPrimary,
          ),
        ),
      );
}

/// Every Bubba controller flag that means "a request is in flight" registers
/// here, and [BubbaBusyOverlay] - mounted once over the whole app - is what
/// draws it. Flags are held rather than counted so a controller that is
/// disposed mid-request cannot leave the overlay stuck on.
class BubbaBusy {
  BubbaBusy._();

  static final List<RxBool> _flags = [];

  /// Bumped when the registry grows so the overlay rebuilds and picks up a
  /// subscription to the new flag. Iterating a plain list registers nothing.
  static final RxInt _version = 0.obs;

  /// Deferred: a controller registers from `onInit`, which can run while a
  /// route is building, and rebuilding the overlay there would mark it dirty
  /// mid-build.
  static void watch(List<RxBool> flags) {
    scheduleMicrotask(() {
      final added = flags.where((f) => !_flags.contains(f)).toList();
      if (added.isEmpty) return;
      _flags.addAll(added);
      _version.value++;
    });
  }

  static bool get busy {
    _version.value;
    return _flags.any((flag) => flag.value);
  }

  static final RxBool _adhoc = false.obs;
  static int _depth = 0;

  /// For an awaited tap that no controller flag covers.
  static Future<T> run<T>(Future<T> action) async {
    watch([_adhoc]);
    _depth++;
    _adhoc.value = true;
    try {
      return await action;
    } finally {
      if (--_depth == 0) _adhoc.value = false;
    }
  }
}

class BubbaBusyOverlay extends StatelessWidget {
  const BubbaBusyOverlay({super.key});

  @override
  Widget build(BuildContext context) => Obx(
        () => BubbaBusy.busy
            ? const AbsorbPointer(
                child: ColoredBox(
                  color: Color(0x33000000),
                  child: Center(child: _BusyCard()),
                ),
              )
            : const SizedBox.shrink(),
      );
}

class _BusyCard extends StatelessWidget {
  const _BusyCard();

  @override
  Widget build(BuildContext context) => Container(
        width: 68,
        height: 68,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: BubbaColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const BubbaSpinner(size: 26, strokeWidth: 2.5),
      );
}

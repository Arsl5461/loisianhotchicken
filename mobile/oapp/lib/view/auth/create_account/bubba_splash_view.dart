import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/design/bubba_tokens.dart';
import '../../SplashScreen/controllers/splash_screen_controller.dart';
import 'signing_in_screen.dart';

class BubbaSplashView extends GetView<OappSplashController> {
  const BubbaSplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: BubbaColors.surface,
      child: AnimatedBuilder(
        animation: controller.exitController,
        builder: (context, child) => Opacity(
          opacity: controller.exitOpacity.value,
          child: child,
        ),
        child: Obx(
          () => SigningInScreen(
            title: controller.isSigningIn.value
                ? 'Signing you in..'
                : 'Getting things ready..',
          ),
        ),
      ),
    );
  }
}

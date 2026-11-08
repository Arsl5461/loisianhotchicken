import 'package:flutter/material.dart';

import 'bubba_info_screen.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({
    super.key,
    this.onUseCurrentLocation,
    this.onEnterManually,
  });

  final VoidCallback? onUseCurrentLocation;
  final VoidCallback? onEnterManually;

  @override
  Widget build(BuildContext context) {
    return BubbaInfoScreen(
      heading: 'See who’s\nnearby',
      headingLines: 2,
      body: 'Use your location to find people\n'
          'nearby and make plans. This is\n'
          'required to continue.',
      bodyLines: 3,
      ctaLabel: 'Use my current location',
      secondaryLabel: 'Enter location manually?',
      onCta: onUseCurrentLocation,
      onSecondary: onEnterManually,
      secondaryBaseline: 729.6,
      ctaY: 747.3,
      illustration: const BubbaIllustration(
        asset: 'assets/images/bubba_illus_location.png',
        x: 55.22,
        y: 290.91,
        width: 271.6,
        height: 301.5,
      ),
    );
  }
}

class NotificationPermissionScreen extends StatelessWidget {
  const NotificationPermissionScreen({
    super.key,
    this.onAllow,
    this.onNotNow,
  });

  final VoidCallback? onAllow;
  final VoidCallback? onNotNow;

  @override
  Widget build(BuildContext context) {
    return BubbaInfoScreen(
      heading: 'Don’t miss a\nmatch',
      headingLines: 2,
      body: 'Get notified about new matches,\n'
          'messages, and reactions.\n'
          'You can change these anytime.',
      bodyLines: 3,
      ctaLabel: 'Allow notifications',
      secondaryLabel: 'Not now',
      onCta: onAllow,
      onSecondary: onNotNow,
      secondaryBaseline: 721.4,
      ctaY: 739.5,
      illustration: const BubbaIllustration(
        asset: 'assets/images/bubba_illus_notifications.png',
        x: 39.19,
        y: 352.85,
        width: 311.6,
        height: 194.6,
      ),
    );
  }
}

class AccountReadyScreen extends StatelessWidget {
  const AccountReadyScreen({super.key, this.onBeginProfileSetup});

  final VoidCallback? onBeginProfileSetup;

  @override
  Widget build(BuildContext context) {
    return BubbaInfoScreen(
      heading: 'You’re in',
      body: 'Your account is ready. Now let’s\n'
          'create a profile that feels like you.',
      bodyLines: 2,
      ctaLabel: 'Begin profile setup',
      onCta: onBeginProfileSetup,
      showBack: false,
      centred: true,
      headingBaseline: 164.5,
      bodyBaseline: 204.3,
      ctaY: 739.5,
      illustration: const BubbaIllustration(
        asset: 'assets/images/bubba_illus_profile_cards.png',
        x: 79.09,
        y: 285.68,
        width: 231.8,
        height: 340.7,
      ),
    );
  }
}

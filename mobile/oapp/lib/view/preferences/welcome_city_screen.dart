import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/design/bubba_glyphs.dart';
import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_prefs_glyphs.dart';
import '../../core/design/bubba_prefs_tokens.dart';
import '../../core/routing/app_routes.dart';
import '../../models/travel_destination_model.dart';
import 'bubba_prefs_controller.dart';
import 'prefs_feedback.dart';
import 'prefs_v2_hub_screen.dart';

const double _chipX = 68.36;
const double _chipTitleBaseline = 140.65;
const double _chipDateBaseline = 161.50;
const double _headingOne = 422.41;
const double _headingTwo = 481.35;
const double _copyOne = 562.79;
const double _copyTwo = 586.79;
const double _ctaX = 57;
const double _ctaW = 276;
const double _ctaY = 637.22;
const double _ctaH = 55;
const double _ctaBaseline = 671.01;
const double _cardX = 11.16;
const double _cardY = 102.34;
const double _cardW = 366.01;
const double _cardH = 643.32;
const double _cardRadius = 20.65;
const Color _cardFill = Color(0xFFF5ECE3);
const Color _blobFill = Color(0xFFF0E1CE);
const double _blobX = -87.54;
const double _blobY = -19.14;
const double _blobSize = 330.38;

/// p030 / p048 - the arrival card. It is shown over the swipe deck once travel
/// mode switches the user to a new city.
class PrefsWelcomeCityView extends StatelessWidget {
  const PrefsWelcomeCityView({
    super.key,
    this.city = 'Miami',
    this.arrival = 'Jun 15',
    this.onExplore,
  });

  final String city;
  final String arrival;
  final VoidCallback? onExplore;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFF5F6F6),
        body: BubbaPage(
          padContent: false,
          scrollable: false,
          background: const Color(0xFFF5F6F6),
          footerBand: 21,
          content: _content,
        ),
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.reserveBlocks = true;
    flow.block(
      _ArrivalCard(city: city, arrival: arrival, onExplore: onExplore),
      top: _cardY,
      height: _cardH,
    );
  }
}

class _ArrivalCard extends StatelessWidget {
  const _ArrivalCard({
    required this.city,
    required this.arrival,
    this.onExplore,
  });

  final String city;
  final String arrival;
  final VoidCallback? onExplore;

  @override
  Widget build(BuildContext context) {
    final chipMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.welcomeChipTitle);
    final dateMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.welcomeChipDate);
    final headingMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.welcomeHeading);
    final copyMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.welcomeCopy);
    final ctaMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.welcomeCta);

    Widget at(double left, double top, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: hdGap(left - _cardX),
              top: dGap(top - _cardY),
            ),
            child: child,
          ),
        );

    return Row(
      children: [
        SizedBox(width: hd(_cardX)),
        SizedBox(
          width: hd(_cardW),
          height: d(_cardH),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(d(_cardRadius)),
            child: ColoredBox(
              color: _cardFill,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Transform.translate(
                      offset: Offset(
                        hd(_blobX - _cardX),
                        d(_blobY - _cardY),
                      ),
                      child: Opacity(
                        opacity: 0.98,
                        child: Container(
                          width: hd(_blobSize),
                          height: d(_blobSize),
                          decoration: const BoxDecoration(
                            color: _blobFill,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  at(
                    26.11,
                    126.22,
                    Container(
                      width: d(32),
                      height: d(32),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE5D3CB),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  at(
                    36.10,
                    135.98,
                    const BubbaGlyphIcon(
                      BubbaPrefsGlyphs.planeMark,
                      color: Color(0xFF8D5C69),
                      width: 12.24,
                      height: 12.25,
                    ),
                  ),
                  at(
                    _chipX,
                    _chipTitleBaseline - chipMetrics.baseline,
                    Opacity(
                      opacity: 0.95,
                      child: Text(city, style: BubbaPrefsText.welcomeChipTitle),
                    ),
                  ),
                  at(
                    68.11,
                    _chipDateBaseline - dateMetrics.baseline,
                    Opacity(
                      opacity: 0.75,
                      child: Text(
                        arrival,
                        style: BubbaPrefsText.welcomeChipDate,
                      ),
                    ),
                  ),
                  at(
                    177.95,
                    252.26,
                    const BubbaGlyphIcon(
                      BubbaPrefsGlyphs.flightArc,
                      color: Color(0xFF9A7C81),
                      width: 123.72,
                      height: 67.25,
                      strokeWidth: 3,
                      dash: 7.854,
                    ),
                  ),
                  at(
                    292.72,
                    266.72,
                    const BubbaGlyphIcon(
                      BubbaPrefsGlyphs.planeLarge,
                      color: Color(0xFF000000),
                      width: 45.23,
                      height: 45.17,
                    ),
                  ),
                  at(
                    65.40,
                    _headingOne - headingMetrics.baseline,
                    Text('Welcome to', style: BubbaPrefsText.welcomeHeading),
                  ),
                  at(
                    123.86,
                    _headingTwo - headingMetrics.baseline,
                    Text(
                      city,
                      style: BubbaPrefsText.welcomeHeading
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  at(
                    178.18,
                    519.22 - 2,
                    SizedBox(
                      width: hd(30.50),
                      height: d(4),
                      child: const ColoredBox(color: Color(0xFFAB8991)),
                    ),
                  ),
                  at(
                    136.68,
                    _copyOne - copyMetrics.baseline,
                    Text(
                      'Your dating mode has',
                      style: BubbaPrefsText.welcomeCopy,
                    ),
                  ),
                  at(
                    150.37,
                    _copyTwo - copyMetrics.baseline,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('switched to ',
                            style: BubbaPrefsText.welcomeCopy),
                        Text(
                          'local',
                          style: BubbaPrefsText.welcomeCopy
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  at(
                    _ctaX,
                    _ctaY,
                    BubbaTapTarget(
                      onTap: onExplore,
                      label: 'Explore $city',
                      child: Container(
                        width: hd(_ctaW),
                        height: d(_ctaH),
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                          color: BubbaPrefsColors.ctaDark,
                          borderRadius: BorderRadius.circular(d(_ctaH / 2)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: dGap(
                              _ctaBaseline - _ctaY - ctaMetrics.baseline,
                            ),
                          ),
                          child: Text(
                            'Explore $city',
                            style: BubbaPrefsText.welcomeCta,
                          ),
                        ),
                      ),
                    ),
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

/// p030 / p048. The end of the destination flow: it names the city the trip
/// was just set to, and Explore returns to the hub with Travel mode on.
class BubbaPrefsWelcomeCityScreen extends StatelessWidget {
  const BubbaPrefsWelcomeCityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = BubbaPrefsController.to;
    final argument = Get.arguments is Map<String, dynamic>
        ? (Get.arguments as Map<String, dynamic>)['destination']
        : null;

    return Obx(() {
      final trip = controller.trip.value;
      final destination =
          argument is TravelDestination ? argument : trip.destination;
      final arrival = trip.arrivalDate;

      return PrefsWelcomeCityView(
        city: destination?.name ?? 'Miami',
        arrival: arrival == null ? 'Jun 15' : prefsShortArrival(arrival),
        onExplore: () async {
          if (!trip.isTraveling && destination != null) {
            final ok = await controller.setTravelMode(true);
            if (!ok) showPrefsError(controller.travelError.value);
          }
          Get.until((route) => Get.currentRoute == Routes.BUBBA_PREFS_HUB ||
              route.isFirst);
        },
      );
    });
  }
}

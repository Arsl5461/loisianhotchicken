import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/design/bubba_icons.dart';
import '../../core/design/bubba_glyphs.dart';
import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_prefs_glyphs.dart';
import '../../core/design/bubba_prefs_tokens.dart';
import '../../core/design/widgets/bubba_loading.dart';
import '../../core/routing/app_routes.dart';
import '../../models/travel_destination_model.dart';
import 'bubba_prefs_controller.dart';
import 'prefs_feedback.dart';
import 'prefs_location.dart';
import 'widgets/prefs_chrome.dart';

class PrefsRecentPlace {
  const PrefsRecentPlace(this.name, this.distance);
  final String name;
  final String distance;
}

class PrefsPopularCity {
  const PrefsPopularCity(this.name, this.country, this.asset);
  final String name;
  final String country;
  final String asset;
}

const List<PrefsRecentPlace> prefsRecentPlaces = [
  PrefsRecentPlace('Storrs, CT', '5.4km'),
  PrefsRecentPlace('Storrs, CT', '5.4km'),
  PrefsRecentPlace('Storrs, CT', '5.4km'),
  PrefsRecentPlace('Storrs, CT', '5.4km'),
];

const List<PrefsPopularCity> prefsPopularCities = [
  PrefsPopularCity(
    'Prague',
    'Czech Republic',
    'assets/bubba/prefs/city_prague.png',
  ),
  PrefsPopularCity('London', 'England', 'assets/bubba/prefs/city_london.png'),
  PrefsPopularCity('Paris', 'France', 'assets/bubba/prefs/city_paris.png'),
];

const List<String> prefsCityAssets = [
  'assets/bubba/prefs/city_prague.png',
  'assets/bubba/prefs/city_london.png',
  'assets/bubba/prefs/city_paris.png',
];

const double _searchY = 117.20;
const double _searchH = 38.29;
const double _recentEyebrow = 184.29;
const double _firstRecent = 210.65;
const double _recentPitch = 48.08;
const double _popularEyebrow = 408.21;
const double _firstCard = 423.35;
const double _cardPitch = 83.75;
const double _cardH = 68;
const double _browseEyebrow = 687.74;
const double _ctaY = 775.85;

/// p003 / p004 / p006 - the Set your destination sheet. p004 is the searching
/// state (recents only), p006 left-aligns the title and offers the device's
/// own location, which pushes everything below it down by 37.
class PrefsDestinationSheetView extends StatelessWidget {
  const PrefsDestinationSheetView({
    super.key,
    this.recents = prefsRecentPlaces,
    this.loading = false,
    this.cities = prefsPopularCities,
    this.showPopular = true,
    this.searchFocused = false,
    this.titleLeft = false,
    this.useCurrentLocation = false,
    this.searchController,
    this.searchFocusNode,
    this.onSearchChanged,
    this.recentEyebrow,
    this.emptyMessage,
    this.onClose,
    this.onClear,
    this.onRecent,
    this.onCity,
    this.onCurrentLocation,
    this.onSet,
  });

  final List<PrefsRecentPlace> recents;

  /// A search is in flight - a spinner sits where the results will land.
  final bool loading;
  final List<PrefsPopularCity> cities;
  final bool showPopular;
  final bool searchFocused;
  final bool titleLeft;
  final bool useCurrentLocation;
  final TextEditingController? searchController;
  final FocusNode? searchFocusNode;
  final ValueChanged<String>? onSearchChanged;
  final String? recentEyebrow;
  final String? emptyMessage;
  final VoidCallback? onClose;
  final VoidCallback? onClear;
  final ValueChanged<int>? onRecent;
  final ValueChanged<int>? onCity;
  final VoidCallback? onCurrentLocation;
  final VoidCallback? onSet;

  double get _shift => useCurrentLocation ? 37 : 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: BubbaPrefsColors.pageBg,
    body: BubbaPage(
      padContent: false,
      background: BubbaPrefsColors.pageBg,
      footerBand: 11,
      content: _content,
      overlay: (context) => [
        BubbaOverlay(
          x: 359.65,
          y: 68.09,
          topShift: true,
          hitPadding: 10,
          label: 'Close',
          onTap: onClose,
          child: const BubbaCloseMark(
            color: BubbaPrefsColors.title,
            strokeWidth: 2,
            width: 11.23,
            height: 11.23,
          ),
        ),
      ],
    ),
  );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.reserveBlocks = true;
    final titleStyle = titleLeft
        ? BubbaPrefsText.heading
        : BubbaPrefsText.sheetTitle;
    final titleMetrics = bubbaDesignTextMetrics(context, titleStyle);
    flow.block(
      titleLeft
          ? Row(
              children: [
                SizedBox(width: hd(20.09)),
                Text('Set your destination', style: titleStyle),
              ],
            )
          : Text(
              'Set your destination',
              textAlign: TextAlign.center,
              style: titleStyle,
            ),
      top: 80.39 - titleMetrics.baseline,
      height: titleMetrics.lineHeight,
    );

    final subMetrics = bubbaDesignTextMetrics(
      context,
      BubbaPrefsText.sheetSubtitle,
    );
    flow.block(
      titleLeft
          ? Row(
              children: [
                SizedBox(width: hd(20.09)),
                Text(
                  'See people who are traveling to your destination',
                  style: BubbaPrefsText.sheetSubtitle,
                ),
              ],
            )
          : Text(
              'See people who are traveling to your destination',
              textAlign: TextAlign.center,
              style: BubbaPrefsText.sheetSubtitle,
            ),
      top: 100.04 - subMetrics.baseline,
      height: subMetrics.lineHeight,
    );

    flow.block(
      _SearchField(
        focused: searchFocused,
        controller: searchController,
        focusNode: searchFocusNode,
        onChanged: onSearchChanged,
      ),
      top: _searchY,
      height: _searchH,
    );

    if (useCurrentLocation) {
      final linkMetrics = bubbaDesignTextMetrics(
        context,
        BubbaPrefsText.locationLink,
      );
      final linkTop = math.min(171.94, 182.38 - linkMetrics.baseline);
      flow.block(
        Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  left: hd(14.40),
                  top: dGap(171.94 - linkTop),
                ),
                child: const BubbaGlyphIcon(
                  BubbaPrefsGlyphs.locationCrosshair,
                  color: Color(0xFF3B6E93),
                  width: 12.21,
                  height: 12.21,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  left: hd(30.78),
                  top: dGap(182.38 - linkMetrics.baseline - linkTop),
                ),
                child: BubbaTapTarget(
                  onTap: onCurrentLocation,
                  label: 'Use current location',
                  child: Text(
                    'Use current location',
                    style: BubbaPrefsText.locationLink,
                  ),
                ),
              ),
            ),
          ],
        ),
        top: linkTop,
        height: 182.38 + linkMetrics.descent - linkTop,
      );
    }

    final eyebrowMetrics = bubbaDesignTextMetrics(
      context,
      BubbaPrefsText.sectionHeader,
    );
    flow.block(
      _EyebrowRow(
        label: recentEyebrow ?? 'RECENT',
        x: 17.83,
        action: useCurrentLocation ? null : 'Clear',
        onAction: onClear,
        baseline: _recentEyebrow + _shift,
      ),
      top: _recentEyebrow + _shift - eyebrowMetrics.baseline,
      height: eyebrowMetrics.lineHeight,
    );

    final nameMetrics = bubbaDesignTextMetrics(
      context,
      BubbaPrefsText.placeName,
    );
    if (loading && recents.isEmpty) {
      flow.block(
        const BubbaSpinner(size: 24),
        top: _firstRecent + _shift - nameMetrics.baseline,
        height: nameMetrics.lineHeight,
        align: Alignment.center,
      );
    }
    for (var i = 0; i < recents.length; i++) {
      final baseline = _firstRecent + _shift + _recentPitch * i;
      final top = baseline - nameMetrics.baseline;
      flow.block(
        _RecentRow(
          place: recents[i],
          top: top,
          baseline: baseline,
          onTap: onRecent == null ? null : () => onRecent!(i),
        ),
        top: top,
        height: _recentPitch,
      );
    }

    flow.block(
      _EyebrowRow(
        label: 'POPULAR',
        x: 19.03,
        baseline: _popularEyebrow + _shift,
      ),
      top: _popularEyebrow + _shift - eyebrowMetrics.baseline,
      height: eyebrowMetrics.lineHeight,
    );

    if (showPopular) {
      for (var i = 0; i < cities.length; i++) {
        final top = _firstCard + _shift + _cardPitch * i;
        flow.block(
          _CityCard(
            city: cities[i],
            top: top,
            onTap: onCity == null ? null : () => onCity!(i),
          ),
          top: top,
          height: _cardH,
        );
      }

      flow.block(
        _EyebrowRow(
          label: 'BROWSE',
          x: 15.41,
          baseline: _browseEyebrow + _shift,
        ),
        top: _browseEyebrow + _shift - eyebrowMetrics.baseline,
        height: eyebrowMetrics.lineHeight,
      );
    }

    flow.block(
      PrefsCtaButton(
        label: 'Set Destination',
        x: 18.89,
        width: 356.56,
        height: 51.23,
        radius: 11.01,
        fill: BubbaPrefsColors.toggleOn,
        labelDrop: 805.74 - _ctaY - 14,
        onTap: onSet,
      ),
      top: _ctaY,
      height: 51.23,
    );
  }
}

class _EyebrowRow extends StatelessWidget {
  const _EyebrowRow({
    required this.label,
    required this.x,
    required this.baseline,
    this.action,
    this.onAction,
  });

  final String label;
  final double x;
  final double baseline;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final eyebrowMetrics = bubbaDesignTextMetrics(
      context,
      BubbaPrefsText.sectionHeader,
    );
    final actionMetrics = bubbaDesignTextMetrics(
      context,
      BubbaPrefsText.clearLink,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: hd(x)),
        Text(label, style: BubbaPrefsText.sectionHeader),
        const Spacer(),
        if (action != null)
          Padding(
            padding: EdgeInsets.only(
              top: d(1.91 + eyebrowMetrics.baseline - actionMetrics.baseline),
            ),
            child: BubbaTapTarget(
              onTap: onAction,
              label: action!,
              child: Text(action!, style: BubbaPrefsText.clearLink),
            ),
          ),
        SizedBox(width: hd(19.04)),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    this.focused = false,
    this.controller,
    this.focusNode,
    this.onChanged,
  });

  final bool focused;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final metrics = bubbaDesignTextMetrics(
      context,
      BubbaPrefsText.searchPlaceholder,
    );
    return Row(
      children: [
        SizedBox(width: hd(15.06)),
        Container(
          width: hd(337.29),
          height: d(_searchH),
          decoration: BoxDecoration(
            color: focused
                ? BubbaPrefsColors.pageBg
                : const Color(0xFFEAEAEA),
            borderRadius: BorderRadius.circular(d(19.15)),
            border: Border.all(color: const Color(0xFFE5E5E5), width: d(1)),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: hd(25.58 - 15.06),
                    top: d(132.11 - _searchY),
                  ),
                  child: const BubbaSearchIcon(
                    size: 11.7,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: hd(41.50 - 15.06),
                    top: d(141.56 - _searchY - metrics.baseline),
                  ),
                  child: SizedBox(
                    width: hd(337.29 - (41.50 - 15.06) - 12),
                    child: Stack(
                      children: [
                        if (controller == null ||
                            controller!.text.isEmpty)
                          Text(
                            'Search city',
                            style: BubbaPrefsText.searchPlaceholder,
                          ),
                        if (controller != null)
                          EditableText(
                            controller: controller!,
                            focusNode: focusNode ?? FocusNode(),
                            style: BubbaPrefsText.searchPlaceholder.copyWith(
                              color: BubbaPrefsColors.rowLabel,
                            ),
                            cursorColor: BubbaPrefsColors.rowLabel,
                            backgroundCursorColor: BubbaPrefsColors.divider,
                            onChanged: onChanged,
                            textInputAction: TextInputAction.search,
                          ),
                      ],
                    ),
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

class _RecentRow extends StatelessWidget {
  const _RecentRow({
    required this.place,
    required this.top,
    required this.baseline,
    this.onTap,
  });

  final PrefsRecentPlace place;
  final double top;
  final double baseline;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final nameMetrics = bubbaDesignTextMetrics(
      context,
      BubbaPrefsText.placeName,
    );
    final distMetrics = bubbaDesignTextMetrics(
      context,
      BubbaPrefsText.placeDistance,
    );

    Widget at(double left, double y, Widget child) => Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(left: hd(left), top: dGap(y - top)),
        child: child,
      ),
    );

    return Semantics(
      button: true,
      label: '${place.name}, ${place.distance}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Stack(
          children: [
            at(
              18.22,
              baseline - nameMetrics.baseline,
              Text(place.name, style: BubbaPrefsText.placeName),
            ),
            at(
              18.89,
              baseline + 12.85 - distMetrics.baseline,
              Text(place.distance, style: BubbaPrefsText.placeDistance),
            ),
          ],
        ),
      ),
    );
  }
}

class _CityCard extends StatelessWidget {
  const _CityCard({required this.city, required this.top, this.onTap});

  final PrefsPopularCity city;
  final double top;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final nameMetrics = bubbaDesignTextMetrics(
      context,
      BubbaPrefsText.rowLabel,
    );
    final countryMetrics = bubbaDesignTextMetrics(
      context,
      BubbaPrefsText.rowValue,
    );
    return Row(
      children: [
        SizedBox(width: hd(20.18)),
        Semantics(
          button: true,
          label: '${city.name}, ${city.country}',
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              width: hd(345),
              height: d(_cardH),
              decoration: BoxDecoration(
                color: BubbaPrefsColors.pageBg,
                borderRadius: BorderRadius.circular(d(34)),
                border: Border.all(
                  color: BubbaPrefsColors.sliderCardBorder,
                  width: d(1),
                ),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: hd(6.80), top: d(8.97)),
                      child: ClipOval(
                        child: Image.asset(
                          city.asset,
                          width: d(49.52),
                          height: d(49.52),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: hd(76.74),
                        top: d(31.93 - nameMetrics.baseline),
                      ),
                      child: Text(city.name, style: BubbaPrefsText.rowLabel),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: hd(76.74),
                        top: d(49.68 - countryMetrics.baseline),
                      ),
                      child: Text(city.country, style: BubbaPrefsText.rowValue),
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

/// p003 / p004 / p006 wired. Typing searches the destination directory; the
/// RECENT list is the cities nearest the device. The three popular cards keep
/// their placed art and resolve to a real city by name when tapped.
class BubbaPrefsDestinationSheetScreen extends StatefulWidget {
  const BubbaPrefsDestinationSheetScreen({super.key});

  @override
  State<BubbaPrefsDestinationSheetScreen> createState() =>
      _BubbaPrefsDestinationSheetScreenState();
}

class _BubbaPrefsDestinationSheetScreenState
    extends State<BubbaPrefsDestinationSheetScreen> {
  final TextEditingController _search = TextEditingController();
  final FocusNode _focus = FocusNode();
  BubbaPrefsController get _controller => BubbaPrefsController.to;

  TravelDestination? _picked;

  @override
  void initState() {
    super.initState();
    _search.addListener(() => setState(() {}));
    _focus.addListener(() => setState(() {}));
    _loadNearby();
  }

  @override
  void dispose() {
    _search.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _loadNearby() async {
    final point = await PrefsLocation.current();
    if (!mounted) return;
    await _controller.loadNearby(
      latitude: point.latitude,
      longitude: point.longitude,
    );
  }

  Future<void> _choose(TravelDestination destination) async {
    setState(() => _picked = destination);
    FocusScope.of(context).unfocus();
  }

  Future<void> _commit() async {
    final destination = _picked;
    if (destination == null) {
      showPrefsError('Pick a destination first.');
      return;
    }
    if (_controller.travelSaving.value) return;

    final ok = await _controller.setDestination(destination);
    if (!ok) {
      showPrefsError(_controller.travelError.value);
      return;
    }

    Get.back();
    Get.toNamed(
      Routes.BUBBA_PREFS_CONFIRM_DESTINATION,
      arguments: {'destination': destination},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final searching = _search.text.trim().isNotEmpty;
      final results = searching
          ? _controller.searchResults
          : _controller.nearbyResults;

      return PrefsDestinationSheetView(
        searchController: _search,
        searchFocusNode: _focus,
        searchFocused: _focus.hasFocus || searching,
        showPopular: !searching,
        recentEyebrow: searching ? 'RESULTS' : 'RECENT',
        loading: _controller.searching.value,
        recents: [
          for (final city in results.take(4))
            PrefsRecentPlace(city.label, city.distanceLabel),
        ],
        onSearchChanged: _controller.search,
        onClear: () {
          _search.clear();
          _controller.search('');
        },
        onRecent: (index) {
          if (index < results.length) _choose(results[index]);
        },
        onCity: (index) async {
          final name = prefsPopularCities[index].name;
          final found = await BubbaBusy.run(_controller.searchOne(name));
          if (found == null) {
            showPrefsError('$name is not in the destination list yet.');
            return;
          }
          _choose(found);
        },
        onCurrentLocation: () async {
          final point = await PrefsLocation.current(force: true);
          if (!point.isReal) {
            showPrefsError('Turn on location to use where you are.');
            return;
          }
          await _controller.loadNearby(
            latitude: point.latitude,
            longitude: point.longitude,
          );
          final nearest = _controller.nearbyResults.firstOrNull;
          if (nearest != null) _choose(nearest);
        },
        onClose: Get.back,
        onSet: _commit,
      );
    });
  }
}

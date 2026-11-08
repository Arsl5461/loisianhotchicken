import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/design/bubba_glyphs.dart';
import '../../core/design/bubba_icons.dart';
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

class PrefsDestination {
  const PrefsDestination(this.name, this.country);
  final String name;
  final String country;
}

const List<PrefsDestination> prefsPopularDestinations = [
  PrefsDestination('Miami, FL', 'United States'),
  PrefsDestination('Los Angeles, CA', 'United States'),
  PrefsDestination('Chicago, IL', 'United States'),
  PrefsDestination('Austin, TX', 'United States'),
  PrefsDestination('San Diego, CA', 'United States'),
];

const double _searchY = 107;
const double _searchH = 42;
const double _eyebrowBaseline = 189.61;
const double _firstName = 234.55;
const double _namePitch = 64;
const double _countryGap = 24.76;
const double _mapCardY = 564;
const double _highlightRise = 23.55;
const double _highlightHeight = 63;
const double _highlightX = 14.94;
const double _highlightWidth = 363;
const double _highlightRadius = 10.15;

/// p022 / p025 / p029 - Choose Destination. One list with three states: the
/// popular set, the recents an active query narrows to, and its results.
class PrefsChooseDestinationView extends StatelessWidget {
  const PrefsChooseDestinationView({
    super.key,
    this.sectionLabel = 'POPULAR DESTINATIONS',
    this.query,
    this.places = prefsPopularDestinations,
    this.loading = false,
    this.showMapCard = false,
    this.clearLabel,
    this.namePitch = _namePitch,
    this.highlightIndex,
    this.secondLabel,
    this.secondClearLabel,
    this.secondEyebrow = 0,
    this.secondFirstName = 0,
    this.secondPlaces = const [],
    this.searchController,
    this.searchFocusNode,
    this.onSearchChanged,
    this.onBack,
    this.onClear,
    this.onPlace,
    this.onMap,
  });

  final String sectionLabel;
  final String? query;
  final List<PrefsDestination> places;

  /// A search is in flight - a spinner sits where the results will land.
  final bool loading;
  final bool showMapCard;
  final String? clearLabel;
  final double namePitch;
  final int? highlightIndex;
  final String? secondLabel;
  final String? secondClearLabel;
  final double secondEyebrow;
  final double secondFirstName;
  final List<PrefsDestination> secondPlaces;
  final TextEditingController? searchController;
  final FocusNode? searchFocusNode;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onBack;
  final VoidCallback? onClear;
  final ValueChanged<int>? onPlace;
  final VoidCallback? onMap;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: BubbaPrefsColors.listBg,
        body: BubbaPage(
          padContent: false,
          background: BubbaPrefsColors.listBg,
          footerBand: 17,
          content: _content,
        ),
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.reserveBlocks = true;
    flow.block(
      PrefsNavBar(
        title: 'Choose Destination',
        titleStyle: BubbaPrefsText.navTitle
            .copyWith(color: BubbaPrefsColors.v2Value),
        titleBaseline: 77.73,
        backY: 62.83,
        onBack: onBack,
      ),
      top: 0,
      height: PrefsNavBar.height + 14,
    );

    flow.block(
      _SearchField(
        query: query,
        controller: searchController,
        focusNode: searchFocusNode,
        onChanged: onSearchChanged,
      ),
      top: _searchY,
      height: _searchH,
    );

    final eyebrowMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.destinationEyebrow);
    flow.block(
      _SectionRow(
        label: sectionLabel,
        clearLabel: clearLabel,
        onClear: onClear,
      ),
      top: _eyebrowBaseline - eyebrowMetrics.baseline,
      height: eyebrowMetrics.lineHeight,
    );

    final nameMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.destinationName);
    if (loading && places.isEmpty) {
      flow.block(
        const BubbaSpinner(size: 24),
        top: _firstName - nameMetrics.baseline,
        height: nameMetrics.lineHeight,
        align: Alignment.center,
      );
    }
    for (var i = 0; i < places.length; i++) {
      final baseline = _firstName + namePitch * i;
      final rowTop = baseline - nameMetrics.baseline;
      final highlight = i == highlightIndex;
      final top = highlight
          ? math.min(rowTop, baseline - _highlightRise)
          : rowTop;
      flow.block(
        _PlaceRow(
          place: places[i],
          top: top,
          baseline: baseline,
          highlight: highlight,
          onTap: onPlace == null ? null : () => onPlace!(i),
        ),
        top: top,
        height: baseline + namePitch - _highlightRise - top,
      );
    }

    if (secondLabel != null) {
      flow.block(
        _SectionRow(
          label: secondLabel!,
          clearLabel: secondClearLabel,
          onClear: onClear,
        ),
        top: secondEyebrow - eyebrowMetrics.baseline,
        height: eyebrowMetrics.lineHeight,
      );

      for (var i = 0; i < secondPlaces.length; i++) {
        final baseline = secondFirstName + namePitch * i;
        final top = baseline - nameMetrics.baseline;
        flow.block(
          _PlaceRow(
            place: secondPlaces[i],
            top: top,
            baseline: baseline,
            onTap: onPlace == null
                ? null
                : () => onPlace!(places.length + i),
          ),
          top: top,
          height: namePitch,
        );
      }
    }

    if (showMapCard) {
      flow.block(_MapCard(onTap: onMap), top: _mapCardY, height: 74);
    }
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    this.query,
    this.controller,
    this.focusNode,
    this.onChanged,
  });

  final String? query;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final style = query == null
        ? BubbaPrefsText.destinationSearch
        : BubbaPrefsText.destinationQuery;
    final metrics = bubbaDesignTextMetrics(context, style);
    final active = query != null;
    return Row(
      children: [
        SizedBox(width: hd(20.20)),
        Container(
          width: hd(341),
          height: d(_searchH),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(d(14.66)),
            border: Border.all(
              color: active
                  ? BubbaPrefsColors.searchActiveBorder
                  : BubbaPrefsColors.searchIdleBorder,
              width: d(2),
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: hd(34.05 - 20.20),
                    top: d(120.38 - _searchY),
                  ),
                  child: BubbaSearchIcon(
                    size: 18,
                    color: active
                        ? const Color(0xFF0A0A0A)
                        : BubbaPrefsColors.searchIdleIcon,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: hd(63.38 - 20.20),
                    top: d(133.63 - _searchY - metrics.baseline),
                  ),
                  child: SizedBox(
                    width: hd(341 - (63.38 - 20.20) - 14),
                    child: Stack(
                      children: [
                        if (controller == null || controller!.text.isEmpty)
                          Text(
                            query ?? 'Search for a city or place',
                            style: style,
                          ),
                        if (controller != null)
                          EditableText(
                            controller: controller!,
                            focusNode: focusNode ?? FocusNode(),
                            style: BubbaPrefsText.destinationQuery,
                            cursorColor: BubbaPrefsColors.v2Value,
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

class _SectionRow extends StatelessWidget {
  const _SectionRow({required this.label, this.clearLabel, this.onClear});

  final String label;
  final String? clearLabel;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final eyebrowMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.destinationEyebrow);
    final clearMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.destinationEyebrow);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: hd(25.96)),
        Text(label, style: BubbaPrefsText.destinationEyebrow),
        const Spacer(),
        if (clearLabel != null)
          Padding(
            padding: EdgeInsets.only(
              top: dGap(eyebrowMetrics.baseline - clearMetrics.baseline - 2.81),
            ),
            child: BubbaTapTarget(
              onTap: onClear,
              label: clearLabel!,
              child: Text(
                clearLabel!,
                style: BubbaPrefsText.destinationEyebrow,
              ),
            ),
          ),
        SizedBox(width: hd(20.36)),
      ],
    );
  }
}

class _PlaceRow extends StatelessWidget {
  const _PlaceRow({
    required this.place,
    required this.top,
    required this.baseline,
    this.highlight = false,
    this.onTap,
  });

  final PrefsDestination place;
  final double top;
  final double baseline;
  final bool highlight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final nameMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.destinationName);
    final countryMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.destinationCountry);

    Widget at(double left, double y, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: hd(left), top: dGap(y - top)),
            child: child,
          ),
        );

    return Semantics(
      button: true,
      label: '${place.name}, ${place.country}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Stack(
          children: [
            if (highlight)
              at(
                _highlightX,
                baseline - _highlightRise,
                Container(
                  width: hd(_highlightWidth),
                  height: d(_highlightHeight),
                  decoration: BoxDecoration(
                    color: BubbaPrefsColors.impactBg,
                    borderRadius:
                        BorderRadius.circular(d(_highlightRadius)),
                  ),
                ),
              ),
            at(
              26.25,
              baseline - nameMetrics.baseline,
              Text(place.name, style: BubbaPrefsText.destinationName),
            ),
            at(
              24.92,
              baseline + _countryGap - countryMetrics.baseline,
              Text(place.country, style: BubbaPrefsText.destinationCountry),
            ),
            at(
              358.34,
              baseline + 4.40,
              const BubbaGlyphIcon(
                BubbaPrefsGlyphs.rowChevron,
                color: BubbaPrefsColors.chevron,
                width: 6.00,
                height: 10.58,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapCard extends StatelessWidget {
  const _MapCard({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final titleMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.travelRow);
    final subMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.destinationCountry);

    Widget at(double left, double y, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: hdGap(left - 16.20),
              top: dGap(y - _mapCardY),
            ),
            child: child,
          ),
        );

    return Row(
      children: [
        SizedBox(width: hd(16.20)),
        Semantics(
          button: true,
          label: 'Choose on map',
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              width: hd(359),
              height: d(74),
              decoration: BoxDecoration(
                color: BubbaPrefsColors.impactBg,
                borderRadius: BorderRadius.circular(d(15.20)),
              ),
              child: Stack(
                children: [
                  at(
                    27.20,
                    583,
                    Container(
                      width: d(41),
                      height: d(41),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: BubbaPrefsColors.v2IconBg,
                        shape: BoxShape.circle,
                      ),
                      child: const BubbaGlyphIcon(
                        BubbaPrefsGlyphs.mapMark,
                        color: BubbaPrefsColors.title,
                        width: 15.54,
                        height: 15.57,
                      ),
                    ),
                  ),
                  at(
                    84.25,
                    597.84 - titleMetrics.baseline,
                    Text('Choose on map', style: BubbaPrefsText.travelRow),
                  ),
                  at(
                    85.64,
                    621.28 - subMetrics.baseline,
                    Text(
                      'Search anywhere in the world',
                      style: BubbaPrefsText.destinationCountry,
                    ),
                  ),
                  at(
                    354.69,
                    597.09,
                    const BubbaGlyphIcon(
                      BubbaPrefsGlyphs.rowChevron,
                      color: BubbaPrefsColors.chevron,
                      width: 6.00,
                      height: 10.58,
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

/// p022 / p025 / p029 wired. Empty query draws the popular set, a query draws
/// live results with the first one highlighted, and `Choose on map` hands over
/// to the map screen, which comes back with a city.
class BubbaPrefsChooseDestinationScreen extends StatefulWidget {
  const BubbaPrefsChooseDestinationScreen({super.key});

  @override
  State<BubbaPrefsChooseDestinationScreen> createState() =>
      _BubbaPrefsChooseDestinationScreenState();
}

class _BubbaPrefsChooseDestinationScreenState
    extends State<BubbaPrefsChooseDestinationScreen> {
  final TextEditingController _search = TextEditingController();
  final FocusNode _focus = FocusNode();
  BubbaPrefsController get _controller => BubbaPrefsController.to;

  List<TravelDestination> _popular = const [];

  @override
  void initState() {
    super.initState();
    _search.addListener(() => setState(() {}));
    _loadPopular();
  }

  @override
  void dispose() {
    _search.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _loadPopular() async {
    final point = await PrefsLocation.current();
    if (!mounted) return;
    await _controller.loadNearby(
      latitude: point.latitude,
      longitude: point.longitude,
    );
    if (!mounted) return;
    setState(() => _popular = _controller.nearbyResults.toList());
  }

  Future<void> _pick(TravelDestination destination) async {
    if (_controller.travelSaving.value) return;

    final ok = await _controller.setDestination(destination);
    if (!ok) {
      showPrefsError(_controller.travelError.value);
      return;
    }

    Get.back(result: destination);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final query = _search.text.trim();
      final searching = query.isNotEmpty;
      final places = searching
          ? _controller.searchResults.toList()
          : (_popular.isEmpty
              ? const <TravelDestination>[]
              : _popular);

      return PrefsChooseDestinationView(
        sectionLabel: searching ? 'RESULTS' : 'POPULAR DESTINATIONS',
        loading: _controller.searching.value,
        query: searching ? query : null,
        searchController: _search,
        searchFocusNode: _focus,
        showMapCard: true,
        highlightIndex: searching && places.isNotEmpty ? 0 : null,
        clearLabel: searching ? 'CLEAR' : null,
        places: places.isEmpty
            ? (searching ? const [] : prefsPopularDestinations)
            : [
                for (final city in places.take(5))
                  PrefsDestination(city.name, city.country),
              ],
        onSearchChanged: _controller.search,
        onClear: () {
          _search.clear();
          _controller.search('');
        },
        onPlace: (index) {
          if (index < places.length) {
            _pick(places[index]);
            return;
          }
          showPrefsError('That place is not in the destination list yet.');
        },
        onMap: () async {
          final result = await Get.toNamed(
            Routes.BUBBA_PREFS_CHOOSE_LOCATION,
            arguments: {'radius': false, 'pickDestination': true},
          );
          if (result is TravelDestination) _pick(result);
        },
        onBack: Get.back,
      );
    });
  }
}

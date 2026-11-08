import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/design/bubba_glyphs.dart';
import '../../core/design/bubba_icons.dart';
import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_prefs_glyphs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/design/bubba_prefs_tokens.dart';
import '../../core/routing/app_routes.dart';
import '../../models/travel_destination_model.dart';
import 'bubba_prefs_controller.dart';
import 'prefs_feedback.dart';
import 'prefs_location.dart';
import 'prefs_map_surface.dart';
import 'widgets/prefs_chrome.dart';

const List<String> prefsMapAssets = [
  'assets/bubba/prefs/map_confirm.png',
  'assets/bubba/prefs/map_explore_plate.png',
  'assets/bubba/prefs/map_radius_plate.png',
  'assets/bubba/prefs/map_distance.png',
  'assets/bubba/prefs/map_locate_button.png',
  'assets/bubba/prefs/map_zoom_pill.png',
  'assets/bubba/prefs/map_explore_mark.png',
];

/// The map box. Under `PrefsMapMode.live` it is a real `GoogleMap`; otherwise
/// it is the measured raster the artboards place, which is what keeps the
/// goldens deterministic. The geometry is identical either way.
class PrefsMapPlate extends StatelessWidget {
  const PrefsMapPlate({
    super.key,
    required this.asset,
    required this.x,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.latitude,
    this.longitude,
    this.radiusMiles,
    this.zoom = 12,
    this.interactive = true,
    this.onCentreChanged,
    this.onMapReady,
  });

  final String asset;
  final double x;
  final double width;
  final double height;
  final BoxFit fit;
  final double? latitude;
  final double? longitude;
  final double? radiusMiles;
  final double zoom;
  final bool interactive;
  final void Function(double latitude, double longitude)? onCentreChanged;
  final void Function(GoogleMapController controller)? onMapReady;

  @override
  Widget build(BuildContext context) => PrefsMapSurface(
        asset: asset,
        x: x,
        width: width,
        height: height,
        fit: fit,
        latitude: latitude,
        longitude: longitude,
        radiusMiles: radiusMiles,
        zoom: zoom,
        interactive: interactive,
        onCentreChanged: onCentreChanged,
        onMapReady: onMapReady,
      );
}

/// p026 - Confirm Destination.
class PrefsConfirmDestinationView extends StatelessWidget {
  const PrefsConfirmDestinationView({
    super.key,
    this.place = 'Miami, FL',
    this.country = 'United States',
    this.latitude,
    this.longitude,
    this.saving = false,
    this.onBack,
    this.onSave,
  });

  final String place;
  final String country;
  final double? latitude;
  final double? longitude;
  final bool saving;
  final VoidCallback? onBack;
  final VoidCallback? onSave;

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
    flow.block(
      PrefsNavBar(
        title: 'Confirm Destination',
        titleStyle:
            BubbaPrefsText.navTitle.copyWith(color: BubbaPrefsColors.v2Value),
        titleBaseline: 77.73,
        backY: 62.83,
        onBack: onBack,
      ),
      top: 0,
      height: PrefsNavBar.height + 14,
    );

    flow.block(
      PrefsMapPlate(
        asset: 'assets/bubba/prefs/map_confirm.png',
        x: 0,
        width: 390.9,
        height: 353.6,
        latitude: latitude,
        longitude: longitude,
        interactive: false,
        zoom: 11,
      ),
      top: 141,
      height: 353.6,
    );

    final eyebrowMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.destinationEyebrow);
    flow.block(
      PrefsEyebrow(
        label: 'YOU SELECTED',
        x: 20.60,
        style: BubbaPrefsText.destinationEyebrow,
      ),
      top: 536.90 - eyebrowMetrics.baseline,
      height: eyebrowMetrics.lineHeight,
    );

    final nameMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.destinationName);
    flow.block(
      Row(
        children: [
          SizedBox(width: hd(21.37)),
          Text(place, style: BubbaPrefsText.destinationName),
        ],
      ),
      top: 566.20 - nameMetrics.baseline,
      height: nameMetrics.lineHeight,
    );

    final countryMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.destinationCountry);
    flow.block(
      Row(
        children: [
          SizedBox(width: hd(20.04)),
          Text(country, style: BubbaPrefsText.destinationCountry),
        ],
      ),
      top: 590.95 - countryMetrics.baseline,
      height: countryMetrics.lineHeight,
    );

    flow.block(
      PrefsCtaButton(
        label: 'Save preference',
        x: 22.30,
        width: 339.70,
        height: 58,
        radius: 11.39,
        fill: const Color(0xFF1B483F),
        labelDrop: 781.20 - 746 - 14,
        onTap: onSave,
      ),
      top: 746,
      height: 58,
    );
  }
}

/// p027 / p028 - Choose location. The artboards bake the zoom controls, the
/// `Explore the map` card, the radius slider and `Confirm location` into the
/// placed map raster; only the nav bar and the search field are vectors. Those
/// controls are rebuilt here as real widgets over the plate, measured off the
/// 144dpi render, because there is no trace to read them from - the plate is a
/// stand-in for the live map, which will not draw them at all. The two glyphs
/// with no equivalent anywhere in the `.ai` - the locate crosshair and the
/// +/- pill - ship as cropped assets, the same treatment p050's flags got.
class PrefsChooseLocationView extends StatefulWidget {
  const PrefsChooseLocationView({
    super.key,
    this.radius = false,
    this.place = 'New York, NY',
    this.origin = 'Near your pin',
    this.radiusMiles = 25,
    this.latitude,
    this.longitude,
    this.onCentreChanged,
    this.onBack,
    this.onSearch,
    this.onLocate,
    this.onEditPlace,
    this.onChangeOrigin,
    this.onRadiusChanged,
    this.onConfirm,
  });

  final bool radius;
  final String place;
  final String origin;
  final double radiusMiles;
  final double? latitude;
  final double? longitude;
  final void Function(double latitude, double longitude)? onCentreChanged;
  final VoidCallback? onBack;
  final VoidCallback? onSearch;
  final VoidCallback? onLocate;
  final VoidCallback? onEditPlace;
  final VoidCallback? onChangeOrigin;
  final ValueChanged<double>? onRadiusChanged;
  final VoidCallback? onConfirm;

  static const double minRadius = 5;
  static const double maxRadius = 100;

  @override
  State<PrefsChooseLocationView> createState() =>
      _PrefsChooseLocationViewState();
}

class _PrefsChooseLocationViewState extends State<PrefsChooseLocationView> {
  late double _radius = widget.radiusMiles;
  GoogleMapController? _map;

  Future<void> _zoom(double by) async {
    final map = _map;
    if (map == null) return;
    await map.animateCamera(
      by > 0 ? CameraUpdate.zoomIn() : CameraUpdate.zoomOut(),
    );
  }

  void _setRadius(double miles) {
    final clamped = miles.clamp(
      PrefsChooseLocationView.minRadius,
      PrefsChooseLocationView.maxRadius,
    );
    if (clamped == _radius) return;
    setState(() => _radius = clamped);
    widget.onRadiusChanged?.call(clamped);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: BubbaPrefsColors.listBg,
        body: BubbaPage(
          padContent: false,
          scrollable: false,
          background: BubbaPrefsColors.listBg,
          footerBand: 17,
          content: _content,
        ),
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.block(
      PrefsNavBar(
        title: 'Choose location',
        titleStyle:
            BubbaPrefsText.navTitle.copyWith(color: BubbaPrefsColors.v2Value),
        titleBaseline: 77.73,
        backY: 62.83,
        onBack: widget.onBack,
      ),
      top: 0,
      height: PrefsNavBar.height + 14,
    );

    flow.block(
      _LocationSearch(onTap: widget.onSearch),
      top: 101.12,
      height: 42,
    );

    final mapTop = widget.radius ? 158.4 : 167.0;
    const mapBottom = 838.0;

    flow.block(
      SizedBox(
        height: d(mapBottom - mapTop),
        child: Stack(
          children: [
            PrefsMapPlate(
              asset: widget.radius
                  ? 'assets/bubba/prefs/map_radius_plate.png'
                  : 'assets/bubba/prefs/map_explore_plate.png',
              x: 0,
              width: 390,
              height: mapBottom - mapTop,
              fit: BoxFit.fill,
              latitude: widget.latitude,
              longitude: widget.longitude,
              radiusMiles: widget.radius ? _radius : null,
              onCentreChanged: widget.onCentreChanged,
              onMapReady: (controller) => _map = controller,
            ),
            _floating(
              mapTop,
              widget.radius ? 349.5 : 371.5,
              _MapLocateButton(onTap: widget.onLocate),
            ),
            _floating(
              mapTop,
              widget.radius ? 407.5 : 429.0,
              _MapZoomPill(
                onZoomIn: () => _zoom(1),
                onZoomOut: () => _zoom(-1),
              ),
            ),
            if (!widget.radius)
              _floating(mapTop, _ExploreCard.top, const _ExploreCard()),
            if (widget.radius)
              _floating(
                mapTop,
                _LocationSheet.top,
                _LocationSheet(
                  place: widget.place,
                  origin: widget.origin,
                  radiusMiles: _radius,
                  onEditPlace: widget.onEditPlace,
                  onChangeOrigin: widget.onChangeOrigin,
                  onRadiusChanged: _setRadius,
                  onConfirm: widget.onConfirm,
                ),
              ),
          ],
        ),
      ),
      top: mapTop,
      height: mapBottom - mapTop,
    );
  }

  Widget _floating(double origin, double y, Widget child) => Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.only(top: dGap(y - origin)),
          child: child,
        ),
      );
}

/// The map's own locate control. `x` is normalised across the two states, which
/// draw it 2pt apart.
class _MapLocateButton extends StatelessWidget {
  const _MapLocateButton({this.onTap});

  final VoidCallback? onTap;

  static const double x = 335.0;
  static const double size = 41;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          SizedBox(width: hd(x)),
          Semantics(
            button: true,
            label: 'Centre on my location',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: ClipOval(
                child: Image.asset(
                  'assets/bubba/prefs/map_locate_button.png',
                  width: d(size),
                  height: d(size),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      );
}

class _MapZoomPill extends StatelessWidget {
  const _MapZoomPill({this.onZoomIn, this.onZoomOut});

  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;

  static const double x = 335.0;
  static const double width = 41;
  static const double height = 89;
  static const double radius = 12;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          SizedBox(width: hd(x)),
          SizedBox(
            width: hd(width),
            height: d(height),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(d(radius)),
                  child: Image.asset(
                    'assets/bubba/prefs/map_zoom_pill.png',
                    width: hd(width),
                    height: d(height),
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  children: [
                    Expanded(
                      child: Semantics(
                        button: true,
                        label: 'Zoom in',
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: onZoomIn,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Semantics(
                        button: true,
                        label: 'Zoom out',
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: onZoomOut,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
}

class _ExploreCard extends StatelessWidget {
  const _ExploreCard();

  static const double x = 19.50;
  static const double top = 698.50;
  static const double width = 347;
  static const double height = 117;
  static const double radius = 14;
  static const double markX = 47;
  static const double markY = 730;
  static const double markSize = 45;
  static const double textX = 115.75;
  static const double titleBaseline = 745;
  static const double bodyBaseline = 770;

  @override
  Widget build(BuildContext context) {
    final titleMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.exploreTitle);
    final bodyMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.exploreBody);
    final titleTop = titleBaseline - titleMetrics.baseline;
    final bodyTop = bodyBaseline - bodyMetrics.baseline;

    return Row(
      children: [
        SizedBox(width: hd(x)),
        Container(
          width: hd(width),
          height: d(height),
          decoration: BoxDecoration(
            color: BubbaPrefsColors.listBg,
            borderRadius: BorderRadius.circular(d(radius)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: hd(markX - x)),
              Column(
                children: [
                  SizedBox(height: d(markY - top)),
                  ClipOval(
                    child: Image.asset(
                      'assets/bubba/prefs/map_explore_mark.png',
                      width: d(markSize),
                      height: d(markSize),
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              SizedBox(width: hd(textX - markX - markSize)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: dGap(titleTop - top)),
                    Text('Explore the map',
                        style: BubbaPrefsText.exploreTitle),
                    SizedBox(
                      height: dGap(
                        bodyTop - (titleTop + titleMetrics.lineHeight),
                      ),
                    ),
                    Text(
                      'Pan and zoom to find any\ncity or place',
                      style: BubbaPrefsText.exploreBody,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// p028's bottom sheet, rebuilt from the render. The radius slider is real: it
/// drags, it reports, and `Confirm location` advances the flow.
class _LocationSheet extends StatelessWidget {
  const _LocationSheet({
    required this.place,
    required this.origin,
    required this.radiusMiles,
    this.onEditPlace,
    this.onChangeOrigin,
    this.onRadiusChanged,
    this.onConfirm,
  });

  final String place;
  final String origin;
  final double radiusMiles;
  final VoidCallback? onEditPlace;
  final VoidCallback? onChangeOrigin;
  final ValueChanged<double>? onRadiusChanged;
  final VoidCallback? onConfirm;

  static const double top = 540.50;
  static const double radius = 20;
  static const double handleX = 178.50;
  static const double handleY = 552;
  static const double handleWidth = 31;
  static const double handleHeight = 4;
  static const double textX = 21;
  static const double titleBaseline = 592;
  static const double pencilGap = 8;
  static const double originBaseline = 630;
  static const double originIconX = 25.50;
  static const double originTextX = 52.00;
  static const double chevronX = 351.50;
  static const double radiusLabelBaseline = 671;
  static const double radiusValueBaseline = 699;
  static const double confirmY = 777;
  static const double confirmX = 20.50;
  static const double confirmWidth = 344.50;
  static const double confirmHeight = 43;
  static const double confirmBaseline = 803;

  @override
  Widget build(BuildContext context) {
    final titleMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.locationTitle);
    final originMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.locationMeta);
    final labelMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.locationRadiusLabel);
    final valueMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.locationRadiusValue);
    final ctaMetrics = bubbaDesignTextMetrics(context, BubbaPrefsText.ctaLabel);

    final children = <Widget>[];
    var cursor = top;
    void put(double y, double advance, Widget child) {
      children
        ..add(SizedBox(height: dGap(y - cursor)))
        ..add(child);
      cursor = y + advance;
    }

    put(
      handleY,
      handleHeight,
      Row(
        children: [
          SizedBox(width: hd(handleX)),
          Container(
            width: hd(handleWidth),
            height: d(handleHeight),
            decoration: BoxDecoration(
              color: BubbaPrefsColors.sliderTrack,
              borderRadius: BorderRadius.circular(d(handleHeight / 2)),
            ),
          ),
        ],
      ),
    );

    put(
      titleBaseline - titleMetrics.baseline,
      titleMetrics.lineHeight,
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: hd(textX)),
          Text(place, style: BubbaPrefsText.locationTitle),
          SizedBox(width: hd(pencilGap)),
          Semantics(
            button: true,
            label: 'Edit location',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onEditPlace,
              child: const BubbaGlyphIcon(
                BubbaGlyphs.pencil,
                color: BubbaPrefsColors.v2Value,
                width: 14,
              ),
            ),
          ),
        ],
      ),
    );

    put(
      originBaseline - originMetrics.baseline,
      originMetrics.lineHeight,
      Semantics(
        button: true,
        label: origin,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onChangeOrigin,
          child: Row(
            children: [
              SizedBox(width: hd(originIconX)),
              const BubbaGlyphIcon(
                BubbaPrefsGlyphs.pinSmall,
                color: BubbaPrefsColors.v2Value,
                width: 11,
              ),
              SizedBox(width: hd(originTextX - originIconX - 11)),
              Text(origin, style: BubbaPrefsText.locationMeta),
              const Spacer(),
              const BubbaChevronDown(
                width: 10,
                height: 6,
                color: BubbaPrefsColors.v2Value,
              ),
              SizedBox(width: hd(390 - chevronX - 10)),
            ],
          ),
        ),
      ),
    );

    put(
      radiusLabelBaseline - labelMetrics.baseline,
      labelMetrics.lineHeight,
      Row(
        children: [
          SizedBox(width: hd(textX)),
          Text('Radius', style: BubbaPrefsText.locationRadiusLabel),
        ],
      ),
    );

    put(
      radiusValueBaseline - valueMetrics.baseline,
      valueMetrics.lineHeight,
      Row(
        children: [
          SizedBox(width: hd(textX)),
          Text(
            '${radiusMiles.round()} miles',
            style: BubbaPrefsText.locationRadiusValue,
          ),
        ],
      ),
    );

    put(
      PrefsRadiusSlider.top,
      PrefsRadiusSlider.bottom - PrefsRadiusSlider.top,
      PrefsRadiusSlider(miles: radiusMiles, onChanged: onRadiusChanged),
    );

    put(
      confirmY,
      confirmHeight,
      Row(
        children: [
          SizedBox(width: hd(confirmX)),
          Semantics(
            button: true,
            label: 'Confirm location',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onConfirm,
              child: Container(
                width: hd(confirmWidth),
                height: d(confirmHeight),
                decoration: BoxDecoration(
                  color: BubbaPrefsColors.ctaTeal,
                  borderRadius: BorderRadius.circular(d(8)),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: dGap(
                        confirmBaseline - confirmY - ctaMetrics.baseline,
                      ),
                    ),
                    Text('Confirm location', style: BubbaPrefsText.ctaLabel),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: BubbaPrefsColors.listBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(d(radius))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

/// The radius slider on p028. Drag the knob or tap the track.
class PrefsRadiusSlider extends StatelessWidget {
  const PrefsRadiusSlider({super.key, required this.miles, this.onChanged});

  final double miles;
  final ValueChanged<double>? onChanged;

  static const double trackX = 19.50;
  static const double trackWidth = 345.50;
  static const double trackWeight = 4;
  static const double knobSize = 22;
  static const double top = 712.50;
  static const double height = 24;
  static const double bottom = top + height + 14;
  static const double tickBaseline = 750;
  static const List<(String, double)> ticks = [
    ('5 mi', 21.50),
    ('25 mi', 135.50),
    ('100 mi', 328.00),
  ];

  static double _scale(double m) => math.sqrt(m);

  double get _fraction => ((_scale(miles) -
              _scale(PrefsChooseLocationView.minRadius)) /
          (_scale(PrefsChooseLocationView.maxRadius) -
              _scale(PrefsChooseLocationView.minRadius)))
      .clamp(0.0, 1.0);

  void _report(BuildContext context, Offset local) {
    if (onChanged == null) return;
    final span = hd(trackWidth);
    if (span <= 0) return;
    final t = ((local.dx - hd(trackX)) / span).clamp(0.0, 1.0);
    final lo = _scale(PrefsChooseLocationView.minRadius);
    final hi = _scale(PrefsChooseLocationView.maxRadius);
    final v = lo + t * (hi - lo);
    onChanged!(v * v);
  }

  @override
  Widget build(BuildContext context) {
    final tickMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.sliderScale);
    final active = hd(trackWidth) * _fraction;

    return Semantics(
      slider: true,
      label: 'Radius',
      value: '${miles.round()} miles',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (details) => _report(context, details.localPosition),
        onHorizontalDragUpdate: (details) =>
            _report(context, details.localPosition),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: d(height),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Row(
                    children: [
                      SizedBox(width: hd(trackX)),
                      Container(
                        width: hd(trackWidth),
                        height: d(trackWeight),
                        decoration: BoxDecoration(
                          color: BubbaPrefsColors.sliderTrack,
                          borderRadius:
                              BorderRadius.circular(d(trackWeight / 2)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: hd(trackX)),
                      Container(
                        width: active,
                        height: d(trackWeight),
                        decoration: BoxDecoration(
                          color: BubbaPrefsColors.ctaTeal,
                          borderRadius:
                              BorderRadius.circular(d(trackWeight / 2)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: hdGap(trackX) + active - d(knobSize) / 2,
                      ),
                      Container(
                        width: d(knobSize),
                        height: d(knobSize),
                        decoration: const BoxDecoration(
                          color: BubbaPrefsColors.ctaTeal,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: dGap(tickBaseline - tickMetrics.baseline - top - height),
            ),
            Stack(
              children: [
                for (final (label, x) in ticks)
                  Row(
                    children: [
                      SizedBox(width: hd(x)),
                      Text(label, style: BubbaPrefsText.sliderScale),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationSearch extends StatelessWidget {
  const _LocationSearch({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final metrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.destinationSearch);
    return Row(
      children: [
        SizedBox(width: hd(21.98)),
        BubbaTapTarget(
          onTap: onTap,
          label: 'Search for a city or place',
          child: Container(
            width: hd(341),
            height: d(42),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(d(14.66)),
              border: Border.all(
                color: BubbaPrefsColors.searchIdleBorder,
                width: d(2),
              ),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: hd(35.83 - 21.98),
                      top: d(114.50 - 101.12),
                    ),
                    child: const BubbaSearchIcon(
                      size: 18,
                      color: BubbaPrefsColors.searchIdleIcon,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: hd(65.16 - 21.98),
                      top: d(127.75 - 101.12 - metrics.baseline),
                    ),
                    child: Text(
                      'Search for a city or place',
                      style: BubbaPrefsText.destinationSearch,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// p013 - Adjust Distance. The map plate, then the radius readout, the slider
/// and the origin row.
class PrefsAdjustDistanceView extends StatelessWidget {
  const PrefsAdjustDistanceView({
    super.key,
    this.distance = '25 miles',
    this.origin = 'My current location',
    this.miles,
    this.latitude,
    this.longitude,
    this.saving = false,
    this.onBack,
    this.onReset,
    this.onChangeOrigin,
    this.onMilesChanged,
    this.onSave,
  });

  final String distance;
  final String origin;
  final double? miles;
  final double? latitude;
  final double? longitude;
  final bool saving;
  final VoidCallback? onBack;
  final VoidCallback? onReset;
  final VoidCallback? onChangeOrigin;
  final ValueChanged<double>? onMilesChanged;
  final VoidCallback? onSave;

  static const List<(String, double)> _scale = [
    ('1 mi', 27.30),
    ('50 mi', 183.30),
    ('+100 mi', 334.30),
  ];
  static const List<double> _ticks = [37.47, 197.47, 352.47];

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: BubbaPrefsColors.listBg,
        body: BubbaPage(
          padContent: false,
          background: BubbaPrefsColors.listBg,
          footerBand: 30,
          content: _content,
        ),
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.block(
      PrefsNavBar(
        title: 'Adjust Distance',
        titleBaseline: 68.14,
        backY: 56.48,
        resetLabel: 'Reset',
        onBack: onBack,
        onReset: onReset,
      ),
      top: 0,
      height: PrefsNavBar.height + 4,
    );

    final introMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.introCopy);
    flow.block(
      Row(
        children: [
          SizedBox(width: hd(19.28)),
          Text(
            'Move the map or adjust the slider to set\nyour preferred distance.',
            style: BubbaPrefsText.introCopy,
          ),
        ],
      ),
      top: 114.16 - introMetrics.baseline,
      height: introMetrics.lineHeight * 2,
    );

    flow.block(
      PrefsMapPlate(
        asset: 'assets/bubba/prefs/map_distance.png',
        x: 4,
        width: 386,
        height: 353.5,
        latitude: latitude,
        longitude: longitude,
        radiusMiles: miles,
        interactive: false,
        zoom: 9,
      ),
      top: 151,
      height: 353.5,
    );

    final eyebrowMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.eyebrow);
    flow.block(
      PrefsEyebrow(
        label: 'Maximum distance',
        x: 19.35,
        style: BubbaPrefsText.eyebrow,
      ),
      top: 530.63 - eyebrowMetrics.baseline,
      height: eyebrowMetrics.lineHeight,
    );

    final valueMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.sliderValue);
    flow.block(
      Row(
        children: [
          SizedBox(width: hd(19.85)),
          Text(distance, style: BubbaPrefsText.sliderValue),
        ],
      ),
      top: 557.93 - valueMetrics.baseline,
      height: valueMetrics.lineHeight,
    );

    flow.block(
      _DistanceSlider(miles: miles, onChanged: onMilesChanged),
      top: 567.62,
      height: 18.50,
    );

    final scaleMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.sliderScale);
    flow.block(
      Stack(
        children: [
          for (final x in _ticks)
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: hd(x)),
                child: SizedBox(
                  width: hd(1),
                  height: d(6),
                  child: const ColoredBox(color: Color(0xFFB9B7B8)),
                ),
              ),
            ),
          for (final (label, x) in _scale)
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  left: hd(x),
                  top: d(612.81 - 592.50 - scaleMetrics.baseline),
                ),
                child: Text(label, style: BubbaPrefsText.sliderScale),
              ),
            ),
        ],
      ),
      top: 592.50,
      height: 28,
    );

    final noteMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.originNote);
    flow.block(
      Row(
        children: [
          SizedBox(width: hd(24.06)),
          Text(
            'Show me people within this distance from',
            style: BubbaPrefsText.originNote,
          ),
        ],
      ),
      top: 650.34 - noteMetrics.baseline,
      height: noteMetrics.lineHeight,
    );

    flow.block(
      _OriginRow(origin: origin, onChange: onChangeOrigin),
      top: 668.50,
      height: 44,
    );

    flow.block(
      PrefsCtaButton(
        label: 'Save distance',
        x: 18.97,
        width: 352,
        height: 43,
        radius: 12.06,
        fill: const Color(0xFF1B483F),
        labelDrop: 768.07 - 742.46 - 14,
        onTap: onSave,
      ),
      top: 742.46,
      height: 43,
    );
  }
}

/// p013's distance slider. With no [miles] it draws the artboard's own state,
/// which is what the goldens assert. Given a value it reads the position off
/// the track's own tick scale: the first tick is 1 mile, the last is 100, and
/// they are evenly spaced between.
class _DistanceSlider extends StatelessWidget {
  const _DistanceSlider({this.miles, this.onChanged});

  final double? miles;
  final ValueChanged<double>? onChanged;

  static const double _firstTick = 37.47;
  static const double _lastTick = 352.47;
  static const double _minMiles = 1;
  static const double _maxMiles = 100;
  static const double _handle = 18.50;
  static const double _defaultActiveStart = 24.97;
  static const double _defaultActiveWidth = 85;
  static const double _defaultHandleLeft = 98.07;

  static double xForMiles(double value) =>
      _firstTick +
      (value.clamp(_minMiles, _maxMiles) - _minMiles) *
          ((_lastTick - _firstTick) / (_maxMiles - _minMiles));

  static double milesForX(double designX) {
    final raw = _minMiles +
        (designX - _firstTick) *
            ((_maxMiles - _minMiles) / (_lastTick - _firstTick));
    return raw.clamp(_minMiles, _maxMiles);
  }

  @override
  Widget build(BuildContext context) {
    final value = miles;
    final handleLeft =
        value == null ? _defaultHandleLeft : xForMiles(value) - _handle / 2;
    final activeStart =
        value == null ? _defaultActiveStart : _firstTick - _handle / 2;
    final activeWidth = value == null
        ? _defaultActiveWidth
        : math.max(0.0, xForMiles(value) - _firstTick + _handle / 2);

    final slider = Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: hd(25.42), top: d(7.14)),
            child: Container(
              width: hd(334.55),
              height: d(4),
              decoration: BoxDecoration(
                color: BubbaPrefsColors.sliderTrack,
                borderRadius: BorderRadius.circular(d(2)),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: hdGap(activeStart), top: d(7.14)),
            child: Container(
              width: hd(activeWidth),
              height: d(4),
              decoration: BoxDecoration(
                color: BubbaPrefsColors.sliderActive,
                borderRadius: BorderRadius.circular(d(2)),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: hdGap(handleLeft)),
            child: Container(
              width: d(_handle),
              height: d(_handle),
              decoration: const BoxDecoration(
                color: Color(0xFF18433A),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );

    if (onChanged == null) return slider;

    void report(Offset local, double pixelWidth) {
      if (pixelWidth <= 0) return;
      final designX = (local.dx / pixelWidth) * 390;
      onChanged!(milesForX(designX));
    }

    return LayoutBuilder(
      builder: (context, constraints) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (details) =>
            report(details.localPosition, constraints.maxWidth),
        onHorizontalDragUpdate: (details) =>
            report(details.localPosition, constraints.maxWidth),
        child: slider,
      ),
    );
  }
}

class _OriginRow extends StatelessWidget {
  const _OriginRow({required this.origin, this.onChange});

  final String origin;
  final VoidCallback? onChange;

  @override
  Widget build(BuildContext context) {
    final labelMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.originLabel);
    final changeMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.originChange);

    Widget at(double left, double y, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: hdGap(left - 18.47), top: dGap(y - 668.50)),
            child: child,
          ),
        );

    return Row(
      children: [
        SizedBox(width: hd(18.47)),
        Container(
          width: hd(359),
          height: d(44),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(d(9.10)),
            border: Border.all(
              color: BubbaPrefsColors.cardBorder,
              width: d(1),
            ),
          ),
          child: Stack(
            children: [
              at(
                32.77,
                682.51,
                const BubbaGlyphIcon(
                  BubbaPrefsGlyphs.pinSmall,
                  color: BubbaPrefsColors.title,
                  width: 10.92,
                  height: 14.04,
                ),
              ),
              at(
                52.13,
                693.79 - labelMetrics.baseline,
                Text(origin, style: BubbaPrefsText.originLabel),
              ),
              at(
                318.75,
                696.74 - changeMetrics.baseline,
                BubbaTapTarget(
                  onTap: onChange,
                  label: 'Change',
                  child: Text('Change', style: BubbaPrefsText.originChange),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// p026. Confirms the destination the previous screen picked and hands the
/// flow on to the welcome-city screen.
class BubbaPrefsConfirmDestinationScreen extends StatelessWidget {
  const BubbaPrefsConfirmDestinationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = BubbaPrefsController.to;
    final argument = Get.arguments is Map<String, dynamic>
        ? (Get.arguments as Map<String, dynamic>)['destination']
        : null;

    return Obx(() {
      final destination = argument is TravelDestination
          ? argument
          : controller.trip.value.destination;

      return PrefsConfirmDestinationView(
        place: destination?.name ?? 'Miami, FL',
        country: destination?.country ?? 'United States',
        latitude: destination?.latitude,
        longitude: destination?.longitude,
        saving: controller.travelSaving.value,
        onBack: Get.back,
        onSave: () async {
          if (destination == null) {
            showPrefsError('Pick a destination first.');
            return;
          }
          if (controller.travelSaving.value) return;

          final ok = await controller.setDestination(destination);
          if (!ok) {
            showPrefsError(controller.travelError.value);
            return;
          }

          Get.offNamed(
            Routes.BUBBA_PREFS_WELCOME_CITY,
            arguments: {'destination': destination},
          );
        },
      );
    });
  }
}

/// p027 / p028. p027 explores the map to pick a place; p028 adds the radius
/// sheet. With `pickDestination` it returns the picked city to whoever pushed
/// it, which is how `Choose on map` gets its answer back.
class BubbaPrefsChooseLocationScreen extends StatefulWidget {
  const BubbaPrefsChooseLocationScreen({
    super.key,
    this.radius = false,
    this.pickDestination = false,
  });

  final bool radius;
  final bool pickDestination;

  @override
  State<BubbaPrefsChooseLocationScreen> createState() =>
      _BubbaPrefsChooseLocationScreenState();
}

class _BubbaPrefsChooseLocationScreenState
    extends State<BubbaPrefsChooseLocationScreen> {
  BubbaPrefsController get _controller => BubbaPrefsController.to;

  double? _latitude;
  double? _longitude;
  TravelDestination? _nearest;

  @override
  void initState() {
    super.initState();
    _centreOnSomething();
  }

  Future<void> _centreOnSomething() async {
    final stored = _controller.trip.value.destination;
    if (stored != null && stored.hasCoordinates) {
      setState(() {
        _latitude = stored.latitude;
        _longitude = stored.longitude;
        _nearest = stored;
      });
      return;
    }
    await _locate();
  }

  Future<void> _locate() async {
    final point = await PrefsLocation.current();
    if (!mounted) return;
    setState(() {
      _latitude = point.latitude;
      _longitude = point.longitude;
    });
    await _resolveNearest(point.latitude, point.longitude);
  }

  Future<void> _resolveNearest(double latitude, double longitude) async {
    await _controller.loadNearby(latitude: latitude, longitude: longitude);
    if (!mounted) return;
    setState(() => _nearest = _controller.nearbyResults.firstOrNull);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final miles = _controller.model.maxDistance;

      return PrefsChooseLocationView(
        radius: widget.radius,
        radiusMiles: miles.clamp(
          PrefsChooseLocationView.minRadius,
          PrefsChooseLocationView.maxRadius,
        ),
        place: _nearest?.label ?? 'New York, NY',
        latitude: _latitude,
        longitude: _longitude,
        onCentreChanged: (latitude, longitude) {
          _latitude = latitude;
          _longitude = longitude;
          _resolveNearest(latitude, longitude);
        },
        onLocate: _locate,
        onSearch: () => Get.toNamed(Routes.BUBBA_PREFS_CHOOSE_DESTINATION),
        onEditPlace: () => Get.toNamed(Routes.BUBBA_PREFS_CHOOSE_DESTINATION),
        onChangeOrigin: () =>
            Get.toNamed(Routes.BUBBA_PREFS_CHOOSE_DESTINATION),
        onRadiusChanged: (value) async {
          final outcome = await _controller.apply(
            (current) => current.copyWith(maxDistance: value),
          );
          if (!outcome.succeeded) showPrefsError(outcome.message);
        },
        onConfirm: () async {
          final picked = _nearest;
          if (picked == null) {
            showPrefsError('Move the pin over a city first.');
            return;
          }

          if (widget.pickDestination) {
            Get.back(result: picked);
            return;
          }

          if (_controller.travelSaving.value) return;
          final ok = await _controller.setDestination(picked);
          if (!ok) {
            showPrefsError(_controller.travelError.value);
            return;
          }
          Get.back();
        },
        onBack: Get.back,
      );
    });
  }
}

/// p013. The radius readout and slider over the map, saving `max_distance`.
class BubbaPrefsAdjustDistanceScreen extends StatefulWidget {
  const BubbaPrefsAdjustDistanceScreen({super.key});

  @override
  State<BubbaPrefsAdjustDistanceScreen> createState() =>
      _BubbaPrefsAdjustDistanceScreenState();
}

class _BubbaPrefsAdjustDistanceScreenState
    extends State<BubbaPrefsAdjustDistanceScreen> {
  BubbaPrefsController get _controller => BubbaPrefsController.to;

  double? _pending;
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    _locate();
  }

  Future<void> _locate() async {
    final trip = _controller.trip.value;
    if (trip.isTraveling && trip.destination?.hasCoordinates == true) {
      setState(() {
        _latitude = trip.destination!.latitude;
        _longitude = trip.destination!.longitude;
      });
      return;
    }

    final point = await PrefsLocation.current();
    if (!mounted) return;
    setState(() {
      _latitude = point.latitude;
      _longitude = point.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final trip = _controller.trip.value;
      final miles = _pending ?? _controller.model.maxDistance;

      return PrefsAdjustDistanceView(
        distance: '${miles.round()} miles',
        miles: miles,
        origin: trip.isTraveling
            ? (trip.destination?.name ?? 'Your destination')
            : 'My current location',
        latitude: _latitude,
        longitude: _longitude,
        saving: _controller.saving.value,
        onMilesChanged: (value) => setState(() => _pending = value),
        onReset: () => setState(() => _pending = 25),
        onChangeOrigin: () =>
            Get.toNamed(Routes.BUBBA_PREFS_CHOOSE_LOCATION, arguments: {
          'radius': true,
        }),
        onSave: () async {
          if (_controller.saving.value) return;

          final outcome = await _controller.apply(
            (current) => current.copyWith(maxDistance: miles.roundToDouble()),
          );
          if (outcome.succeeded) {
            Get.back();
          } else {
            showPrefsError(outcome.message);
          }
        },
        onBack: Get.back,
      );
    });
  }
}

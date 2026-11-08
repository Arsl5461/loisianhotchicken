import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/design/bubba_layout.dart';

/// Whether the part 4 map boxes draw a live `GoogleMap` or the measured plate.
///
/// It defaults to the plate so the goldens stay deterministic without any test
/// having to know about it. `AppConfigurations.initialize()` turns it on for
/// the running app, which is the only place a real map can render anyway.
class PrefsMapMode {
  static bool live = false;
}

/// The box the artboards place a map raster into. Same geometry either way, so
/// switching between the plate and the live map moves nothing.
class PrefsMapSurface extends StatefulWidget {
  const PrefsMapSurface({
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
  State<PrefsMapSurface> createState() => _PrefsMapSurfaceState();
}

class _PrefsMapSurfaceState extends State<PrefsMapSurface> {
  GoogleMapController? _controller;
  final Completer<void> _ready = Completer<void>();

  static const double _metresPerMile = 1609.34;

  LatLng get _target =>
      LatLng(widget.latitude ?? 40.7128, widget.longitude ?? -74.006);

  @override
  void didUpdateWidget(covariant PrefsMapSurface old) {
    super.didUpdateWidget(old);

    if (old.latitude != widget.latitude || old.longitude != widget.longitude) {
      _controller?.animateCamera(CameraUpdate.newLatLng(_target));
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget _plate() => Image.asset(widget.asset, fit: widget.fit);

  Widget _map() => GoogleMap(
        initialCameraPosition:
            CameraPosition(target: _target, zoom: widget.zoom),
        onMapCreated: (controller) {
          _controller = controller;
          if (!_ready.isCompleted) _ready.complete();
          widget.onMapReady?.call(controller);
        },
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        compassEnabled: false,
        scrollGesturesEnabled: widget.interactive,
        zoomGesturesEnabled: widget.interactive,
        rotateGesturesEnabled: false,
        tiltGesturesEnabled: false,
        onCameraIdle: widget.onCentreChanged == null
            ? null
            : () async {
                final controller = _controller;
                if (controller == null) return;
                final region = await controller.getVisibleRegion();
                widget.onCentreChanged!(
                  (region.northeast.latitude + region.southwest.latitude) / 2,
                  (region.northeast.longitude + region.southwest.longitude) / 2,
                );
              },
        markers: {
          Marker(markerId: const MarkerId('bubba-pin'), position: _target),
        },
        circles: widget.radiusMiles == null
            ? const {}
            : {
                Circle(
                  circleId: const CircleId('bubba-radius'),
                  center: _target,
                  radius: widget.radiusMiles! * _metresPerMile,
                  fillColor: const Color(0x1F1F4941),
                  strokeColor: const Color(0xFF1F4941),
                  strokeWidth: 2,
                ),
              },
      );

  @override
  Widget build(BuildContext context) => Row(
        children: [
          if (widget.x > 0) SizedBox(width: hd(widget.x)),
          Flexible(
            child: SizedBox(
              width: hd(widget.width),
              height: d(widget.height),
              child: PrefsMapMode.live ? _map() : _plate(),
            ),
          ),
        ],
      );
}

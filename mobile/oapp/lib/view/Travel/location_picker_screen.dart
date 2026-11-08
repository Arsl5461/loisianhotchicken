// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:OApp/core/constants/app_colors.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;
  LatLng? _currentLatLng;
  bool _loadingLocation = false;

  final List<String> _countries = const [
    'United States',
    'United Kingdom',
    'Pakistan',
    'Turkey',
    'France',
    'Germany',
    'United Arab Emirates',
    'Australia',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _loadingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          setState(() => _loadingLocation = false);
          return;
        }
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        setState(() => _loadingLocation = false);
        return;
      }

      final Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final LatLng latLng = LatLng(pos.latitude, pos.longitude);
      setState(() => _currentLatLng = latLng);

      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: latLng, zoom: 14),
        ),
      );
    } finally {
      if (mounted) setState(() => _loadingLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.cFFF1DFD5,
            AppColors.cFFEADFDB,
            AppColors.cFFDDE4EC,
            AppColors.cFFDDE4EC,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: Icon(Icons.location_on, color: AppColors.black87),
          title: Text(
            'Locations',
            style: TextStyle(
              color: AppColors.black87,
              fontWeight: FontWeight.w700,
              fontSize: MediaQueryUtil.fontSize(18),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: MediaQueryUtil.spacing(12)),
              child: Center(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.cFF3fbcb7,
                    fontWeight: FontWeight.w600,
                    fontSize: MediaQueryUtil.fontSize(14),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Choose a location to explore',
                  style: TextStyle(
                    color: AppColors.black87,
                    fontSize: MediaQueryUtil.fontSize(12),
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Content posted will appear within the location you have selected',
                  style: TextStyle(
                    color: AppColors.black54,
                    fontSize: MediaQueryUtil.fontSize(10),
                  ),
                ),
              ),

              // Search
              Padding(
                padding: EdgeInsets.all(MediaQueryUtil.spacing(12)),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQueryUtil.spacing(12),
                    vertical: MediaQueryUtil.spacing(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: AppColors.black38),
                      SizedBox(width: MediaQueryUtil.spacing(8)),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Use current location
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQueryUtil.spacing(12),
                ),
                child: InkWell(
                  onTap: _loadingLocation ? null : _useCurrentLocation,
                  child: Row(
                    children: [
                      Icon(Icons.my_location, color: AppColors.teal),
                      SizedBox(width: MediaQueryUtil.spacing(8)),
                      Text(
                        _loadingLocation
                            ? 'Getting current location…'
                            : 'Use current location',
                        style: TextStyle(
                          color: AppColors.teal,
                          fontWeight: FontWeight.w600,
                          fontSize: MediaQueryUtil.fontSize(14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Map preview
              Padding(
                padding: EdgeInsets.all(MediaQueryUtil.spacing(12)),
                child: Container(
                  height: MediaQueryUtil.dynamicSize(
                    small: 160,
                    medium: 180,
                    large: 200,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: GoogleMap(
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    onMapCreated: (c) => _mapController = c,
                    initialCameraPosition: CameraPosition(
                      target: _currentLatLng ?? const LatLng(41.8084, -72.2495),
                      zoom: 12,
                    ),
                    markers: _currentLatLng == null
                        ? {}
                        : {
                            Marker(
                              markerId: const MarkerId('current'),
                              position: _currentLatLng!,
                            ),
                          },
                  ),
                ),
              ),

              // Country list (simple mock to match visuals)
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQueryUtil.spacing(12),
                    vertical: MediaQueryUtil.spacing(8),
                  ),
                  itemCount: _countries.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQueryUtil.spacing(10),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.grey.withValues(alpha: 0.15),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: MediaQueryUtil.spacing(14),
                            vertical: MediaQueryUtil.spacing(8),
                          ),
                          title: Text(
                            _countries[index],
                            style: const TextStyle(
                              color: AppColors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: const Text(
                            '5.4km',
                            style: TextStyle(color: AppColors.black45),
                          ),
                          onTap: () {},
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Set location button
              Padding(
                padding: EdgeInsets.fromLTRB(
                  MediaQueryUtil.spacing(16),
                  0,
                  MediaQueryUtil.spacing(16),
                  MediaQueryUtil.spacing(16),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cFF2FB9B6,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQueryUtil.spacing(14),
                      ),
                      elevation: 2,
                      shadowColor: AppColors.black.withValues(alpha: 0.08),
                    ),
                    child: const Text('Set location'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

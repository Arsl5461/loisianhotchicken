import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/routing/app_routes.dart';
import '../../../widgets/ElevatedButton/gradientButton.dart';
import '../../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class AddressPickerPage extends StatefulWidget {
  const AddressPickerPage({super.key});

  @override
  State<AddressPickerPage> createState() => _AddressPickerPageState();
}

class _AddressPickerPageState extends State<AddressPickerPage> {
  bool isLocationPermissionGranted = false;
  String? currentLocation;
  final Set<Marker> _markers = {};
  final LatLng _currentPosition = LatLng(
    40.7128,
    -74.0060,
  ); // New York City coordinates
  bool _isMapReady = false;
  GoogleMapController? _mapController;
  LatLng? _userLocation;

  @override
  void initState() {
    super.initState();
    _addMarkers();
    debugPrint('AddressPickerPage initialized');

    // Fallback to show map after 3 seconds if not loaded
    Future.delayed(Duration(seconds: 3), () {
      if (mounted && !_isMapReady) {
        setState(() {
          _isMapReady = true;
        });
        debugPrint('Map fallback activated');
      }
    });
  }

  void _addMarkers() {
    _markers.add(
      Marker(
        markerId: MarkerId('camera'),
        position: LatLng(40.7589, -73.9851), // Central Park area
        infoWindow: InfoWindow(title: 'Camera'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
    _markers.add(
      Marker(
        markerId: MarkerId('museum'),
        position: LatLng(40.7614, -73.9776), // Museum area
        infoWindow: InfoWindow(title: 'Museum'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _isMapReady = true;
      _mapController = controller;
    });
    debugPrint('Google Map created successfully');
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Show loading indicator
      setState(() {
        isLocationPermissionGranted = false;
      });

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationError(
          'Location services are disabled. Please enable location services in your device settings.',
        );
        return;
      }

      // Check and request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showLocationError(
            'Location permissions are denied. Please allow location access to continue.',
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showLocationError(
          'Location permissions are permanently denied. Please enable location access in app settings.',
        );
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );

      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        isLocationPermissionGranted = true;
        currentLocation =
            '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
      });

      // Add user location marker
      _addUserLocationMarker();

      // Move camera to user location
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(_userLocation!, 15.0),
        );
      }

      debugPrint(
        'Current location: ${position.latitude}, ${position.longitude}',
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Location found!'),
          backgroundColor: AppColors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
      _showLocationError('Error getting your location. Please try again.');
    }
  }

  void _addUserLocationMarker() {
    if (_userLocation != null) {
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId('user_location'),
            position: _userLocation!,
            infoWindow: InfoWindow(
              title: 'Your Location',
              snippet: 'Current position',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
        );
      });
    }
  }

  void _showLocationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initialize MediaQuery for responsive design
    MediaQueryUtil.init(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.cFFF1DFD5, // light peach
                AppColors.cFFEADFDB, // pale pinkish-beige
                AppColors.cFFDDE4EC, // light bluish-gray
                AppColors.cFFDDE4EC, // repeated to extend the bottom color
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Progress indicator
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQueryUtil.spacing(20),
                      vertical: MediaQueryUtil.spacing(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: MediaQueryUtil.spacing(4),
                            decoration: BoxDecoration(
                              color: AppColors.cFF1E88E5,
                              borderRadius: BorderRadius.circular(
                                MediaQueryUtil.spacing(2),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: MediaQueryUtil.spacing(4)),
                        Expanded(
                          flex: 7,
                          child: Container(
                            height: MediaQueryUtil.spacing(4),
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(
                                MediaQueryUtil.spacing(2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Main content area
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQueryUtil.spacing(28),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: MediaQueryUtil.spacing(40)),

                          // Title
                          Text(
                            "Can we track your location?",
                            style: TextStyle(
                              fontSize: MediaQueryUtil.fontSize(28),
                              fontWeight: FontWeight.w600,
                              color: AppColors.black87,
                              height: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: MediaQueryUtil.spacing(16)),

                          // Subtitle
                          Text(
                            "This helps us show you people nearby",
                            style: TextStyle(
                              fontSize: MediaQueryUtil.fontSize(16),
                              fontWeight: FontWeight.w400,
                              color: AppColors.grey[600],
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: MediaQueryUtil.spacing(30)),

                          // Google Maps container
                          Container(
                            height: MediaQueryUtil.dynamicSize(
                              small: 300,
                              medium: 350,
                              large: 400,
                              extraSmall: 280,
                              extraLarge: 450,
                            ),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                MediaQueryUtil.spacing(12),
                              ),
                              border: Border.all(
                                color: AppColors.grey[300]!,
                                width: MediaQueryUtil.spacing(1),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                MediaQueryUtil.spacing(12),
                              ),
                              child: Stack(
                                children: [
                                  GoogleMap(
                                    onMapCreated: _onMapCreated,
                                    initialCameraPosition: CameraPosition(
                                      target: _currentPosition,
                                      zoom: 12.0,
                                    ),
                                    markers: _markers,
                                    mapType: MapType.normal,
                                    myLocationEnabled: false,
                                    myLocationButtonEnabled: false,
                                    zoomControlsEnabled: true,
                                    mapToolbarEnabled: false,
                                  ),
                                  // Fallback loading indicator
                                  if (!_isMapReady)
                                    Container(
                                      color: AppColors.grey[200],
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircularProgressIndicator(
                                              color: AppColors.cFF1E88E5,
                                            ),
                                            SizedBox(
                                              height: MediaQueryUtil.spacing(
                                                16,
                                              ),
                                            ),
                                            Text(
                                              'Loading Map...',
                                              style: TextStyle(
                                                fontSize:
                                                    MediaQueryUtil.fontSize(16),
                                                color: AppColors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: MediaQueryUtil.spacing(20)),

                          // Go back link
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.AGE_PICKER);
                            },
                            child: Text(
                              "Go back",
                              style: TextStyle(
                                fontSize: MediaQueryUtil.fontSize(14),
                                fontWeight: FontWeight.w400,
                                color: AppColors.black87,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.black87,
                                decorationThickness: 1.0,
                              ),
                            ),
                          ),

                          // This will push the button to the bottom
                          SizedBox(height: MediaQueryUtil.spacing(100)),
                        ],
                      ),
                    ),
                  ),

                  // Bottom section with buttons
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQueryUtil.spacing(28),
                    ),
                    child: Column(
                      children: [
                        // Go to current location button
                        GradientButton(
                          text: 'Get your location',
                          onPressed: () {
                            debugPrint('Get your location pressed');
                            _getCurrentLocation();
                          },
                          backgroundColor: AppColors.white, // White color
                          textColor: AppColors.cFF1E88E5, // Blue text
                          borderRadius: MediaQueryUtil.spacing(12),
                          textSize: MediaQueryUtil.fontSize(16),
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(16)),

                        // Continue button
                        GradientButton(
                          text: 'Continue',
                          onPressed: isLocationPermissionGranted
                              ? () {
                                  debugPrint(
                                    'Continue pressed with location: $currentLocation',
                                  );
                                  Get.toNamed(Routes.HEIGHT_PICKER);
                                }
                              : null,
                          backgroundColor: isLocationPermissionGranted
                              ? AppColors.cFF1E88E5
                              : AppColors.cFF9CA2AE,
                          textColor: AppColors.white,
                          borderRadius: MediaQueryUtil.spacing(12),
                          textSize: MediaQueryUtil.fontSize(16),
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(30)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

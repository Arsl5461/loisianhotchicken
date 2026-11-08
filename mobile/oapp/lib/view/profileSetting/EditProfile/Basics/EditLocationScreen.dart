import 'package:flutter/material.dart';
import '../../../../utils/media_query.dart';
import '../../../../widgets/Layout/EditProfileHeader.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/core/typography/app_text_styles.dart';

class EditLocationScreen extends StatefulWidget {
  const EditLocationScreen({super.key});

  @override
  State<EditLocationScreen> createState() => _EditLocationScreenState();
}

class _EditLocationScreenState extends State<EditLocationScreen> {
  String _currentLocation = 'Loading...';
  LatLng? _currentPosition;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Request permission
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _currentLocation = 'Location services disabled';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _currentLocation = 'Location permission denied';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _currentLocation = 'Location permission permanently denied';
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      // Get address from coordinates using Google Geocoding API
      try {
        String apiKey =
            'YOUR_GOOGLE_API_KEY'; // You'll need to add your API key
        final response = await http.get(
          Uri.parse(
            'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey',
          ),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['status'] == 'OK' && data['results'].isNotEmpty) {
            String address = data['results'][0]['formatted_address'];
            setState(() {
              _currentLocation = address;
            });
          } else {
            setState(() {
              _currentLocation = 'Unable to get address';
            });
          }
        } else {
          setState(() {
            _currentLocation = 'Error getting address';
          });
        }
      } catch (e) {
        setState(() {
          _currentLocation = 'Could not get address';
        });
      }

      // Update map to show current location
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(_currentPosition!),
        );
      }
    } catch (e) {
      setState(() {
        _currentLocation = 'Error getting location: $e';
      });
    }
  }

  void _saveAndGoBack() {
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return GetBuilder(
      builder: (ctrl) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: Column(
              children: [
                // Header with chevron, title, and X icon
                EditProfileHeader(
                  title: 'Location',
                  onBack: _saveAndGoBack,
                  onClose: _saveAndGoBack,
                ),

                // Main content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Location information
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQueryUtil.spacing(20),
                            vertical: MediaQueryUtil.spacing(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Instruction text
                              Text(
                                'Your current location is:',
                                style: AppTextStyles.regular(
                                  fontWeight: AppFontWeight.semiBold,
                                  color: AppColors.black,
                                ),
                              ),

                              SizedBox(height: MediaQueryUtil.spacing(4)),

                              // Current location
                              Text(
                                _currentLocation,
                                style: AppTextStyles.regular(
                                  fontWeight: AppFontWeight.regular,
                                  color: AppColors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Map display
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target:
                                  _currentPosition ??
                                  LatLng(
                                    40.7128,
                                    -74.0060,
                                  ), // Default to NYC if no position
                              zoom: 12.0,
                            ),
                            mapType: MapType.normal,
                            myLocationButtonEnabled: true,
                            zoomControlsEnabled: true,
                            scrollGesturesEnabled: true,
                            tiltGesturesEnabled: true,
                            myLocationEnabled: true,
                            onMapCreated: (GoogleMapController controller) {
                              _mapController = controller;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

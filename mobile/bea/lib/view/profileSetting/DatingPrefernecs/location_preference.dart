import 'package:OApp/core/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class LocationPreferencePage extends StatefulWidget {
  const LocationPreferencePage({super.key});

  @override
  State<LocationPreferencePage> createState() => _LocationPreferencePageState();
}

class _LocationPreferencePageState extends State<LocationPreferencePage> {
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  List<String> selectedLocations = [];

  @override
  void dispose() {
    _countryController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
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
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(MediaQueryUtil.spacing(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Subtitle
                      _buildTitleSection(),

                      SizedBox(height: MediaQueryUtil.spacing(24)),

                      // Country Input
                      _buildCountryInput(),

                      SizedBox(height: MediaQueryUtil.spacing(20)),

                      // Area Input
                      _buildAreaInput(),

                      SizedBox(height: MediaQueryUtil.spacing(20)),

                      // Add Location Button
                      _buildAddLocationButton(),

                      SizedBox(height: MediaQueryUtil.spacing(20)),

                      // Selected Locations
                      if (selectedLocations.isNotEmpty)
                        _buildSelectedLocations(),

                      SizedBox(height: MediaQueryUtil.spacing(32)),

                      // Save Button
                      _buildSaveButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQueryUtil.spacing(20),
        vertical: MediaQueryUtil.spacing(16),
      ),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: EdgeInsets.all(MediaQueryUtil.spacing(8)),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(8)),
              ),
              child: Icon(
                Icons.arrow_back,
                color: AppColors.black87,
                size: MediaQueryUtil.iconSize(20),
              ),
            ),
          ),

          SizedBox(width: MediaQueryUtil.spacing(16)),

          // Title
          Expanded(
            child: Text(
              'Location Preference',
              style: TextStyle(
                fontSize: MediaQueryUtil.fontSize(24),
                fontWeight: FontWeight.bold,
                color: AppColors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Container(
      padding: EdgeInsets.all(MediaQueryUtil.spacing(20)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: MediaQueryUtil.spacing(10),
            spreadRadius: MediaQueryUtil.spacing(2),
            offset: Offset(0, MediaQueryUtil.spacing(2)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Where would you like to find matches?',
            style: TextStyle(
              fontSize: MediaQueryUtil.fontSize(20),
              fontWeight: FontWeight.w600,
              color: AppColors.black87,
            ),
          ),
          SizedBox(height: MediaQueryUtil.spacing(8)),
          Text(
            'Select countries and areas where you\'d like to meet people.',
            style: TextStyle(
              fontSize: MediaQueryUtil.fontSize(14),
              fontWeight: FontWeight.w400,
              color: AppColors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryInput() {
    return Container(
      padding: EdgeInsets.all(MediaQueryUtil.spacing(20)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: MediaQueryUtil.spacing(10),
            spreadRadius: MediaQueryUtil.spacing(2),
            offset: Offset(0, MediaQueryUtil.spacing(2)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Country',
            style: TextStyle(
              fontSize: MediaQueryUtil.fontSize(16),
              fontWeight: FontWeight.w600,
              color: AppColors.black87,
            ),
          ),
          SizedBox(height: MediaQueryUtil.spacing(16)),

          TextField(
            controller: _countryController,
            decoration: InputDecoration(
              hintText: 'Enter country name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
                borderSide: BorderSide(color: AppColors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
                borderSide: BorderSide(color: AppColors.cFF1E88E5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
                borderSide: BorderSide(color: AppColors.grey[300]!),
              ),
              contentPadding: EdgeInsets.all(MediaQueryUtil.spacing(16)),
            ),
            style: TextStyle(
              fontSize: MediaQueryUtil.fontSize(14),
              color: AppColors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAreaInput() {
    return Container(
      padding: EdgeInsets.all(MediaQueryUtil.spacing(20)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: MediaQueryUtil.spacing(10),
            spreadRadius: MediaQueryUtil.spacing(2),
            offset: Offset(0, MediaQueryUtil.spacing(2)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Area/City',
            style: TextStyle(
              fontSize: MediaQueryUtil.fontSize(16),
              fontWeight: FontWeight.w600,
              color: AppColors.black87,
            ),
          ),
          SizedBox(height: MediaQueryUtil.spacing(16)),

          TextField(
            controller: _areaController,
            decoration: InputDecoration(
              hintText: 'Enter area or city name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
                borderSide: BorderSide(color: AppColors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
                borderSide: BorderSide(color: AppColors.cFF1E88E5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
                borderSide: BorderSide(color: AppColors.grey[300]!),
              ),
              contentPadding: EdgeInsets.all(MediaQueryUtil.spacing(16)),
            ),
            style: TextStyle(
              fontSize: MediaQueryUtil.fontSize(14),
              color: AppColors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddLocationButton() {
    return SizedBox(
      width: double.infinity,
      height: MediaQueryUtil.dynamicSize(small: 48, medium: 56, large: 64),
      child: ElevatedButton(
        onPressed: _addLocation,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cFF1E88E5,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
          ),
          elevation: 0,
        ),
        child: Text(
          'Add Location',
          style: TextStyle(
            fontSize: MediaQueryUtil.fontSize(16),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _addLocation() {
    final country = _countryController.text.trim();
    final area = _areaController.text.trim();

    if (country.isNotEmpty && area.isNotEmpty) {
      final location = '$area, $country';
      if (!selectedLocations.contains(location)) {
        setState(() {
          selectedLocations.add(location);
          _countryController.clear();
          _areaController.clear();
        });
      }
    }
  }

  Widget _buildSelectedLocations() {
    return Container(
      padding: EdgeInsets.all(MediaQueryUtil.spacing(20)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: MediaQueryUtil.spacing(10),
            spreadRadius: MediaQueryUtil.spacing(2),
            offset: Offset(0, MediaQueryUtil.spacing(2)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Locations (${selectedLocations.length})',
            style: TextStyle(
              fontSize: MediaQueryUtil.fontSize(16),
              fontWeight: FontWeight.w600,
              color: AppColors.black87,
            ),
          ),
          SizedBox(height: MediaQueryUtil.spacing(12)),

          Wrap(
            spacing: MediaQueryUtil.spacing(8),
            runSpacing: MediaQueryUtil.spacing(8),
            children: selectedLocations.map((location) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQueryUtil.spacing(12),
                  vertical: MediaQueryUtil.spacing(8),
                ),
                decoration: BoxDecoration(
                  color: AppColors.cFF1E88E5.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    MediaQueryUtil.spacing(16),
                  ),
                  border: Border.all(
                    color: AppColors.cFF1E88E5,
                    width: MediaQueryUtil.spacing(1),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      location,
                      style: TextStyle(
                        fontSize: MediaQueryUtil.fontSize(12),
                        fontWeight: FontWeight.w500,
                        color: AppColors.cFF1E88E5,
                      ),
                    ),
                    SizedBox(width: MediaQueryUtil.spacing(4)),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedLocations.remove(location);
                        });
                      },
                      child: Icon(
                        Icons.close,
                        size: MediaQueryUtil.iconSize(16),
                        color: AppColors.cFF1E88E5,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: MediaQueryUtil.dynamicSize(small: 48, medium: 56, large: 64),
      child: ElevatedButton(
        onPressed: selectedLocations.isNotEmpty ? _savePreferences : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cFF1E88E5,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
          ),
          elevation: 0,
        ),
        child: Text(
          'Save Preferences',
          style: TextStyle(
            fontSize: MediaQueryUtil.fontSize(16),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _savePreferences() {
    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(16)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(MediaQueryUtil.spacing(16)),
              decoration: BoxDecoration(
                color: AppColors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: AppColors.green,
                size: MediaQueryUtil.iconSize(32),
              ),
            ),
            SizedBox(height: MediaQueryUtil.spacing(16)),
            Text(
              'Preferences Saved!',
              style: TextStyle(
                fontSize: MediaQueryUtil.fontSize(18),
                fontWeight: FontWeight.w600,
                color: AppColors.black87,
              ),
            ),
            SizedBox(height: MediaQueryUtil.spacing(8)),
            Text(
              'Your location preferences have been updated successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQueryUtil.fontSize(14),
                fontWeight: FontWeight.w400,
                color: AppColors.grey[600],
                height: 1.4,
              ),
            ),
            SizedBox(height: MediaQueryUtil.spacing(24)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Get.toNamed(Routes.PREFERENCE_MAIN);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cFF1E88E5,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      MediaQueryUtil.spacing(8),
                    ),
                  ),
                ),
                child: Text(
                  'Done',
                  style: TextStyle(
                    fontSize: MediaQueryUtil.fontSize(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

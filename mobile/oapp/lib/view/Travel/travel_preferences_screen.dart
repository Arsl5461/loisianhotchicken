import 'package:flutter/material.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:get/get.dart';

import 'package:OApp/core/constants/app_colors.dart';

/// Travel Preferences screen - matches the image exactly
/// - Clean white background
/// - Header with "Travel Preferences" title and close button
/// - "Are you traveling?" section with toggle
/// - List of preference items with dividers
class TravelPreferencesScreen extends StatefulWidget {
  const TravelPreferencesScreen({super.key});

  @override
  State<TravelPreferencesScreen> createState() =>
      _TravelPreferencesScreenState();
}

class _TravelPreferencesScreenState extends State<TravelPreferencesScreen> {
  bool _isTraveling = true; // Default to true (toggle is on)

  static const List<_PreferenceItem> _preferences = [
    _PreferenceItem('Travel Preference', 'Travelers'),
    _PreferenceItem('Sexuality', 'Straight'),
    _PreferenceItem('Age Range', '22 to 36'),
    _PreferenceItem('Maximum Distance', '8 mi'),
    _PreferenceItem('Height', 'Open'),
    _PreferenceItem('Politics', 'Open'),
    _PreferenceItem('Education', 'Open'),
    _PreferenceItem('Languages', 'Open'),
    _PreferenceItem('Ethnicity', 'Open'),
    _PreferenceItem('Religion', 'Open'),
  ];

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            SizedBox(height: MediaQueryUtil.spacing(8)),
            _buildDivider(),
            SizedBox(height: MediaQueryUtil.spacing(16)),
            _buildTravelingSection(),
            SizedBox(height: MediaQueryUtil.spacing(50)),
            Expanded(child: _buildPreferencesList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQueryUtil.spacing(16),
        vertical: MediaQueryUtil.spacing(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Empty space for centering
          SizedBox(width: MediaQueryUtil.spacing(24)),
          // Title
          Text(
            'Travel Preferences',
            style: TextStyle(
              fontSize: MediaQueryUtil.fontSize(16),
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          // Close button
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.close,
              color: AppColors.black,
              size: MediaQueryUtil.iconSize(24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTravelingSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQueryUtil.spacing(16)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Are you traveling?',
                  style: TextStyle(
                    fontSize: MediaQueryUtil.fontSize(14),
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: MediaQueryUtil.spacing(2)),
                Text(
                  'Indicating your status will help you connect with other travelers.',
                  style: TextStyle(
                    fontSize: MediaQueryUtil.fontSize(11),
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: MediaQueryUtil.spacing(16)),
          GestureDetector(
            onTap: () {
              setState(() {
                _isTraveling = !_isTraveling;
              });
            },
            child: _buildToggleSwitch(),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleSwitch() {
    return Container(
      width: MediaQueryUtil.spacing(40),
      height: MediaQueryUtil.spacing(24),
      decoration: BoxDecoration(
        color: _isTraveling ? AppColors.cFF2FACAE : AppColors.grey[300],
        borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
      ),
      child: Stack(
        children: [
          // Toggle handle
          Positioned(
            right: _isTraveling
                ? MediaQueryUtil.spacing(2)
                : MediaQueryUtil.spacing(18),
            top: MediaQueryUtil.spacing(2),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: MediaQueryUtil.spacing(20),
              height: MediaQueryUtil.spacing(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 1, color: AppColors.grey[300]);
  }

  Widget _buildPreferencesList() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: MediaQueryUtil.spacing(16)),
      itemCount: _preferences.length,
      separatorBuilder: (context, index) => _buildDivider(),
      itemBuilder: (context, index) {
        final preference = _preferences[index];
        return _buildPreferenceItem(preference);
      },
    );
  }

  Widget _buildPreferenceItem(_PreferenceItem preference) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: MediaQueryUtil.spacing(8)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  preference.title,
                  style: TextStyle(
                    fontSize: MediaQueryUtil.fontSize(12),
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: MediaQueryUtil.spacing(2)),
                Text(
                  preference.value,
                  style: TextStyle(
                    fontSize: MediaQueryUtil.fontSize(12),
                    color: AppColors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            LucideIcons.chevronRight,
            color: AppColors.grey[400],
            size: MediaQueryUtil.iconSize(24),
          ),
        ],
      ),
    );
  }
}

class _PreferenceItem {
  final String title;
  final String value;

  const _PreferenceItem(this.title, this.value);
}

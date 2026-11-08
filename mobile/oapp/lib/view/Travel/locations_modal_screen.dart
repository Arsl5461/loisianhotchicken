import 'package:OApp/view/Travel/models/travel_city_model.dart';
import 'package:flutter/material.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:get/get.dart';
import '../../core/typography/app_text_styles.dart';
import '../../widgets/Images/base64OrNetworkImage.dart';
import 'choose_location_controller.dart';

import 'package:OApp/core/constants/app_colors.dart';

class LocationsModalScreen extends GetView<ChooseLocationController> {
  final TextEditingController _searchController = TextEditingController();

  static const List<LocationItem> _nearbyLocations = [
    LocationItem('New York, NY', '12.3km', 40.7128, -74.0060),
    LocationItem('Boston, MA', '8.7km', 42.3601, -71.0589),
    LocationItem('Hartford, CT', '15.2km', 41.7658, -72.6734),
    LocationItem('Providence, RI', '6.9km', 41.8240, -71.4128),
    LocationItem('New Haven, CT', '9.1km', 41.3083, -72.9279),
    LocationItem('Worcester, MA', '11.4km', 42.2626, -71.8023),
  ];

  LocationsModalScreen({super.key});

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
            _buildSearchBar(),
            SizedBox(height: MediaQueryUtil.spacing(12)),
            _buildCurrentLocationOption(),
            SizedBox(height: MediaQueryUtil.spacing(16)),
            // Show "Cities around you" heading only when not searching
            if (controller.searchQuery.value.isEmpty) _buildCitiesHeading(),
            Expanded(
              child: controller.searchQuery.value.isEmpty
                  ? Obx(() => _buildCitiesGrid())
                  : _buildLocationsList(),
            ),
            // Show "Set location" button only when searching
            if (controller.searchQuery.value.isNotEmpty)
              _buildSetLocationButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        // Top row with location icon, title, and cancel button
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQueryUtil.spacing(5),
            vertical: MediaQueryUtil.spacing(3),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Location icon
              Icon(
                Icons.location_on,
                color: AppColors.black,
                size: MediaQueryUtil.iconSize(20),
              ),
              SizedBox(width: MediaQueryUtil.spacing(4)),
              // Title
              Text(
                'Locations',
                style: AppTextStyles.medium(fontWeight: AppFontWeight.semiBold),
              ),
              // Cancel button
              TextButton(
                onPressed: () => controller.refresh(goBack: true),

                child: Text(
                  'Cancel',
                  style: AppTextStyles.regular(
                    fontWeight: AppFontWeight.semiBold,
                    color: AppColors.cFF3fbcb7,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Divider
        Container(height: 1, color: AppColors.grey),
        SizedBox(height: MediaQueryUtil.spacing(4)),
        // Centered text
        Text(
          'Choose a location to explore',
          textAlign: TextAlign.center,
          style: AppTextStyles.verySmall(
            fontWeight: AppFontWeight.semi,
            color: AppColors.darkGrey,
          ),
        ),
        SizedBox(height: MediaQueryUtil.spacing(4)),
        Text(
          'Content posted will appear within the location you have selected',
          textAlign: TextAlign.center,
          style: AppTextStyles.text(
            customSize: MediaQueryUtil.fontSize(9),
            fontWeight: AppFontWeight.semi,
            color: AppColors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQueryUtil.spacing(8)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cFFE5E7E6,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: TextField(
            controller: _searchController,

            decoration: InputDecoration(
              hintText: 'Search',

              hintStyle: AppTextStyles.regular(
                // fontSize: MediaQueryUtil.fontSize(14),
                color: AppColors.grey[700],
                fontWeight: AppFontWeight.semi,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: MediaQueryUtil.spacing(12),
                vertical: MediaQueryUtil.spacing(8),
              ),
              alignLabelWithHint: false,
            ),
            style: TextStyle(
              fontSize: MediaQueryUtil.fontSize(14),
              color: AppColors.black,
            ),
            textAlign: TextAlign.left,
            onChanged: (value) {
              controller.getCitiesSearch(value.toLowerCase());
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentLocationOption() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQueryUtil.spacing(8)),
      child: Obx(
        () => GestureDetector(
          onTap: () {
            controller.searchPostedCities();
          },
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: [
              Icon(
                Icons.my_location,
                color: AppColors.cFF619295,
                size: MediaQueryUtil.iconSize(12),
              ),
              SizedBox(width: MediaQueryUtil.spacing(4)),
              Text(
                !controller.isNearbyFilter.value
                    ? 'Use current location'
                    : controller.country.value.isNotEmpty
                    ? "Current location: ${controller.country.value}"
                    : "Latitude: ${controller.latitude.value.toStringAsFixed(2)}, Longitude: ${controller.longitude.value.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: MediaQueryUtil.fontSize(14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.cFF2A8281,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCitiesHeading() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQueryUtil.spacing(16),
        vertical: MediaQueryUtil.spacing(8),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Cities around you',
          style: TextStyle(
            fontSize: MediaQueryUtil.fontSize(18),
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildCitiesGrid() {
    final spacing = MediaQueryUtil.spacing(22);
    final cities = controller.travelCities;
    if (controller.isPostLoading.value) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.cFF35BCB8),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQueryUtil.spacing(22)),
      child: GridView.builder(
        itemCount: cities.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: 1.05,
        ),
        itemBuilder: (context, index) {
          final city = cities[index];
          return GestureDetector(
            onTap: () {
              // Navigate directly to travel screen with selected city
              // controller.updateLocation(city);
            },
            child: _CityCard(city: city),
          );
        },
      ),
    );
  }

  Widget _buildLocationsList() {
    // Filter locations based on search query
    final filteredLocations = controller.searchQuery.value.isEmpty
        ? _nearbyLocations
        : _nearbyLocations
              .where(
                (location) => location.name.toLowerCase().contains(
                  controller.searchQuery.value.toLowerCase(),
                ),
              )
              .toList();

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: MediaQueryUtil.spacing(16)),
      itemCount: filteredLocations.length,
      separatorBuilder: (context, index) =>
          SizedBox(height: MediaQueryUtil.spacing(4)),
      itemBuilder: (context, index) {
        final location = filteredLocations[index];
        return _buildLocationItem(location);
      },
    );
  }

  Widget _buildLocationItem(LocationItem location) {
    final isSelected =
        controller.selectedTravelCity.value.name == location.name;

    return GestureDetector(
      onTap: () {
        controller.selectedTravelCity.value = location.toTravelCity();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQueryUtil.spacing(16),
          vertical: MediaQueryUtil.spacing(8),
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cFFE5F7F6 : AppColors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location.name,
              style: TextStyle(
                fontSize: MediaQueryUtil.fontSize(12),
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.cFF2A8281 : AppColors.black,
              ),
            ),
            SizedBox(height: MediaQueryUtil.spacing(1)),
            Text(
              location.distance,
              style: TextStyle(
                fontSize: MediaQueryUtil.fontSize(10),
                color: isSelected ? AppColors.cFF2A8281 : AppColors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetLocationButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQueryUtil.spacing(16)),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to travel screen with selected city
            controller.updateLocation(controller.selectedTravelCity.value!);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.cFF35BCB8,
            foregroundColor: AppColors.white,
            padding: EdgeInsets.symmetric(vertical: MediaQueryUtil.spacing(14)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(14)),
            ),
          ),
          child: Text(
            'Set location',
            style: TextStyle(
              fontSize: MediaQueryUtil.fontSize(16),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _CityCard extends StatelessWidget {
  final TravelCity city;

  const _CityCard({required this.city});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          // Main image
          Positioned.fill(
            child: Base64OrNetworkImage(
              imageData: city.image ?? '',
              fit: BoxFit.cover,
            ),
          ),
          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.transparent,
                    AppColors.black.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
          ),
          // City name overlay
          Positioned(
            left: MediaQueryUtil.spacing(12),
            bottom: MediaQueryUtil.spacing(12),
            child: Text(
              city.name ?? "",
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
                fontSize: MediaQueryUtil.fontSize(12),
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    color: AppColors.black.withValues(alpha: 0.5),
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:OApp/widgets/custom_svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:get/get.dart';
import '../../controller/home_controller.dart';
import 'helpers/dating_filters.dart';
import 'package:OApp/core/constants/app_colors.dart';

class DatingPreferenceScreen extends GetView<HomeController> {
  final VoidCallback? onBackTap;
  final VoidCallback? onFilterTap;

  const DatingPreferenceScreen({super.key, this.onBackTap, this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.cFFF8F8F8,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Obx(
          () => SingleChildScrollView(
            padding: EdgeInsets.all(MediaQueryUtil.spacing(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Dating Preferences'),
                SizedBox(height: MediaQueryUtil.spacing(24)),

                _buildAgeRangeSelector(),
                SizedBox(height: MediaQueryUtil.spacing(24)),

                _buildDistanceSelector(),
                SizedBox(height: MediaQueryUtil.spacing(24)),

                _buildLookingForSelector(),
                SizedBox(height: MediaQueryUtil.spacing(24)),

                _buildInterestsSelector(),
                SizedBox(height: MediaQueryUtil.spacing(24)),

                _buildEthnicitySelector(),
                SizedBox(height: MediaQueryUtil.spacing(24)),

                _buildEducationSelector(),
                SizedBox(height: MediaQueryUtil.spacing(24)),

                _buildReligiousViewsSelector(),
                SizedBox(height: MediaQueryUtil.spacing(24)),

                _buildLifestyleSelector(),
                SizedBox(height: MediaQueryUtil.spacing(32)),

                Row(
                  children: [
                    Expanded(child: _buildClearFiltersButton()),
                    SizedBox(width: MediaQueryUtil.spacing(16)),
                    Expanded(child: _buildSaveButton()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.cFFF8F8F8,
      elevation: 0,
      leadingWidth: 60,
      leading: GestureDetector(
        onTap: onBackTap ?? () => Get.back(),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.all(MediaQueryUtil.spacing(20)),
          child: CustomSvgIcons.backArrow(
            color: AppColors.black,
            size: MediaQueryUtil.iconSize(14),
          ),
        ),
      ),
      title: Text(
        'Oapp',
        style: TextStyle(
          fontSize: MediaQueryUtil.fontSize(30),
          fontWeight: FontWeight.w500,
          color: AppColors.black,
          letterSpacing: -1.0,
          fontFamily: 'Poppins',
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: MediaQueryUtil.fontSize(28),
        fontWeight: FontWeight.bold,
        color: AppColors.black87,
      ),
    );
  }

  // ---------------------------
  // Helpers
  // ---------------------------

  bool _isAgeRangeSelected(String option) {
    final range = controller.datingPreferences.value.ageRange;
    final parsed = _parseAgeRange(option);
    if (parsed == null) return false;

    return range.start.round() == parsed.start.round() &&
        range.end.round() == parsed.end.round();
  }

  RangeValues? _parseAgeRange(String value) {
    final cleaned = value.trim();

    if (cleaned.contains('-')) {
      final parts = cleaned.split('-');
      if (parts.length == 2) {
        final start = double.tryParse(parts[0].trim());
        final end = double.tryParse(parts[1].trim());
        if (start != null && end != null) {
          return RangeValues(start, end);
        }
      }
    }

    if (cleaned.endsWith('+')) {
      final start = double.tryParse(cleaned.replaceAll('+', '').trim());
      if (start != null) {
        return RangeValues(start, 65);
      }
    }

    return null;
  }

  void _toggleAgeRange(String option) {
    final isSelected = _isAgeRangeSelected(option);

    controller.datingPreferences.value = controller.datingPreferences.value
        .copyWith(
          ageRange: isSelected
              ? const RangeValues(18, 65)
              : (_parseAgeRange(option) ?? const RangeValues(18, 65)),
        );
  }

  bool _isDistanceSelected(String option) {
    final current = controller.datingPreferences.value.maxDistance.round();
    final parsed = _parseDistance(option);
    return parsed != null && current == parsed;
  }

  int? _parseDistance(String value) {
    final match = RegExp(r'\d+').firstMatch(value);
    if (match == null) return null;
    return int.tryParse(match.group(0)!);
  }

  void _toggleDistance(String option) {
    final parsed = _parseDistance(option);
    if (parsed == null) return;

    final isSelected = _isDistanceSelected(option);

    controller.datingPreferences.value = controller.datingPreferences.value
        .copyWith(maxDistance: isSelected ? 50.0 : parsed.toDouble());
  }

  // ---------------------------
  // Selectors
  // ---------------------------

  Widget _buildAgeRangeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Age Range',
          style: TextStyle(
            fontSize: MediaQueryUtil.fontSize(18),
            fontWeight: FontWeight.w700,
            color: AppColors.black87,
          ),
        ),
        SizedBox(height: MediaQueryUtil.spacing(12)),
        SizedBox(
          height: MediaQueryUtil.spacing(40),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: DatingFilters.ageRanges.length,
            itemBuilder: (_, index) {
              final option = DatingFilters.ageRanges[index];
              final isSelected = _isAgeRangeSelected(option);

              return GestureDetector(
                onTap: () => _toggleAgeRange(option),
                child: Container(
                  margin: EdgeInsets.only(right: MediaQueryUtil.spacing(8)),
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQueryUtil.spacing(16),
                    vertical: MediaQueryUtil.spacing(8),
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.cFF006C6A : AppColors.white,
                    borderRadius: BorderRadius.circular(
                      MediaQueryUtil.spacing(20),
                    ),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: MediaQueryUtil.fontSize(14),
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected ? AppColors.white : AppColors.grey[600],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDistanceSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Maximum Distance',
          style: TextStyle(
            fontSize: MediaQueryUtil.fontSize(18),
            fontWeight: FontWeight.w700,
            color: AppColors.black87,
          ),
        ),
        SizedBox(height: MediaQueryUtil.spacing(12)),
        SizedBox(
          height: MediaQueryUtil.spacing(40),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: DatingFilters.maxDistances.length,
            itemBuilder: (_, index) {
              final option = DatingFilters.maxDistances[index];
              final isSelected = _isDistanceSelected(option);

              return GestureDetector(
                onTap: () => _toggleDistance(option),
                child: Container(
                  margin: EdgeInsets.only(right: MediaQueryUtil.spacing(8)),
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQueryUtil.spacing(16),
                    vertical: MediaQueryUtil.spacing(8),
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.cFF006C6A : AppColors.white,
                    borderRadius: BorderRadius.circular(
                      MediaQueryUtil.spacing(20),
                    ),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: MediaQueryUtil.fontSize(14),
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected ? AppColors.white : AppColors.grey[600],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLookingForSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Looking For',
          style: TextStyle(
            fontSize: MediaQueryUtil.fontSize(18),
            fontWeight: FontWeight.w700,
            color: AppColors.black87,
          ),
        ),
        SizedBox(height: MediaQueryUtil.spacing(12)),
        Column(
          children: DatingFilters.lookingForOptions.map((option) {
            final selected = controller.datingPreferences.value.lookingFor;
            final isSelected = selected == option;

            return GestureDetector(
              onTap: () {
                controller.datingPreferences.value = controller
                    .datingPreferences
                    .value
                    .copyWith(lookingFor: isSelected ? null : option);
              },
              child: Container(
                margin: EdgeInsets.only(bottom: MediaQueryUtil.spacing(8)),
                padding: EdgeInsets.all(MediaQueryUtil.spacing(16)),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.cFF006C6A : AppColors.white,
                  borderRadius: BorderRadius.circular(
                    MediaQueryUtil.spacing(12),
                  ),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.cFF006C6A
                        : AppColors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: MediaQueryUtil.spacing(20),
                      height: MediaQueryUtil.spacing(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.white
                              : AppColors.grey[400]!,
                        ),
                        color: AppColors.white,
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check,
                              size: MediaQueryUtil.spacing(14),
                              color: AppColors.cFF006C6A,
                            )
                          : null,
                    ),
                    SizedBox(width: MediaQueryUtil.spacing(12)),
                    Text(
                      option,
                      style: TextStyle(
                        fontSize: MediaQueryUtil.fontSize(16),
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? AppColors.white
                            : AppColors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildInterestsSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Interests',
          style: TextStyle(
            fontSize: MediaQueryUtil.fontSize(18),
            fontWeight: FontWeight.w700,
            color: AppColors.black87,
          ),
        ),
        SizedBox(height: MediaQueryUtil.spacing(12)),
        Wrap(
          spacing: MediaQueryUtil.spacing(8),
          runSpacing: MediaQueryUtil.spacing(8),
          children: DatingFilters.interests.map((interest) {
            final selectedInterests =
                controller.datingPreferences.value.interests;
            final isSelected = selectedInterests.contains(interest);

            return GestureDetector(
              onTap: () {
                final updated = List<String>.from(selectedInterests);

                if (isSelected) {
                  updated.remove(interest);
                } else {
                  updated.add(interest);
                }

                controller.datingPreferences.value = controller
                    .datingPreferences
                    .value
                    .copyWith(interests: updated);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQueryUtil.spacing(12),
                  vertical: MediaQueryUtil.spacing(8),
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.cFF006C6A : AppColors.white,
                  borderRadius: BorderRadius.circular(
                    MediaQueryUtil.spacing(16),
                  ),
                ),
                child: Text(
                  interest,
                  style: TextStyle(
                    fontSize: MediaQueryUtil.fontSize(14),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? AppColors.white : AppColors.grey[600],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEthnicitySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ethnicity',
          style: TextStyle(
            fontSize: MediaQueryUtil.fontSize(18),
            fontWeight: FontWeight.w700,
            color: AppColors.black87,
          ),
        ),
        SizedBox(height: MediaQueryUtil.spacing(12)),
        Wrap(
          spacing: MediaQueryUtil.spacing(8),
          runSpacing: MediaQueryUtil.spacing(8),
          children: DatingFilters.ethnicities.map((ethnicity) {
            final selected = controller.datingPreferences.value.ethnicity;
            final isSelected = selected.contains(ethnicity);

            return GestureDetector(
              onTap: () {
                controller.datingPreferences.value = controller
                    .datingPreferences
                    .value
                    .copyWith(ethnicity: isSelected ? const [] : [ethnicity]);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQueryUtil.spacing(12),
                  vertical: MediaQueryUtil.spacing(8),
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.cFF006C6A : AppColors.white,
                  borderRadius: BorderRadius.circular(
                    MediaQueryUtil.spacing(16),
                  ),
                  border: Border.all(color: AppColors.grey.shade300),
                ),
                child: Text(
                  ethnicity,
                  style: TextStyle(
                    fontSize: MediaQueryUtil.fontSize(14),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? AppColors.white : AppColors.grey[600],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEducationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Education',
          style: TextStyle(
            fontSize: MediaQueryUtil.fontSize(18),
            fontWeight: FontWeight.w700,
            color: AppColors.black87,
          ),
        ),
        SizedBox(height: MediaQueryUtil.spacing(12)),
        Wrap(
          spacing: MediaQueryUtil.spacing(8),
          runSpacing: MediaQueryUtil.spacing(8),
          children: DatingFilters.educationOptions.map((education) {
            final selected = controller.datingPreferences.value.education;
            final isSelected = selected == education;

            return GestureDetector(
              onTap: () {
                controller.datingPreferences.value = controller
                    .datingPreferences
                    .value
                    .copyWith(education: isSelected ? null : education);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQueryUtil.spacing(12),
                  vertical: MediaQueryUtil.spacing(8),
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.cFF006C6A : AppColors.white,
                  borderRadius: BorderRadius.circular(
                    MediaQueryUtil.spacing(16),
                  ),
                  border: Border.all(color: AppColors.grey.shade300),
                ),
                child: Text(
                  education,
                  style: TextStyle(
                    fontSize: MediaQueryUtil.fontSize(14),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? AppColors.white : AppColors.grey[600],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildReligiousViewsSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Religious Views',
          style: TextStyle(
            fontSize: MediaQueryUtil.fontSize(18),
            fontWeight: FontWeight.w700,
            color: AppColors.black87,
          ),
        ),
        SizedBox(height: MediaQueryUtil.spacing(12)),
        Wrap(
          spacing: MediaQueryUtil.spacing(8),
          runSpacing: MediaQueryUtil.spacing(8),
          children: DatingFilters.religiousViews.map((religion) {
            final selected = controller.datingPreferences.value.religion;
            final isSelected = selected.contains(religion);

            return GestureDetector(
              onTap: () {
                controller.datingPreferences.value = controller
                    .datingPreferences
                    .value
                    .copyWith(religion: isSelected ? const [] : [religion]);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQueryUtil.spacing(12),
                  vertical: MediaQueryUtil.spacing(8),
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.cFF006C6A : AppColors.white,
                  borderRadius: BorderRadius.circular(
                    MediaQueryUtil.spacing(16),
                  ),
                  border: Border.all(color: AppColors.grey.shade300),
                ),
                child: Text(
                  religion,
                  style: TextStyle(
                    fontSize: MediaQueryUtil.fontSize(14),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? AppColors.white : AppColors.grey[600],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLifestyleSelector() {
    final drinkingSelected =
        controller.datingPreferences.value.drinking == true;
    final smokingSelected = controller.datingPreferences.value.smoking == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lifestyle',
          style: TextStyle(
            fontSize: MediaQueryUtil.fontSize(18),
            fontWeight: FontWeight.w700,
            color: AppColors.black87,
          ),
        ),
        SizedBox(height: MediaQueryUtil.spacing(12)),
        Row(
          children: [
            Expanded(
              child: _buildLifestyleOption('Drinking', drinkingSelected, () {
                final current = controller.datingPreferences.value.drinking;
                controller.datingPreferences.value = controller
                    .datingPreferences
                    .value
                    .copyWith(drinking: current == true ? null : true);
              }),
            ),
            SizedBox(width: MediaQueryUtil.spacing(16)),
            Expanded(
              child: _buildLifestyleOption('Smoking', smokingSelected, () {
                final current = controller.datingPreferences.value.smoking;
                controller.datingPreferences.value = controller
                    .datingPreferences
                    .value
                    .copyWith(smoking: current == true ? null : true);
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLifestyleOption(String title, bool value, VoidCallback onTap) {
    return Container(
      padding: EdgeInsets.all(MediaQueryUtil.spacing(12)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
        border: Border.all(color: AppColors.grey.shade300),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: MediaQueryUtil.fontSize(14),
              fontWeight: FontWeight.w500,
              color: AppColors.black87,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: MediaQueryUtil.spacing(24),
              height: MediaQueryUtil.spacing(24),
              decoration: BoxDecoration(
                color: value ? AppColors.cFF006C6A : AppColors.grey.shade300,
                borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
              ),
              child: Center(
                child: value
                    ? Icon(
                        Icons.check,
                        color: AppColors.white,
                        size: MediaQueryUtil.spacing(16),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------
  // Buttons
  // ---------------------------

  Widget _buildClearFiltersButton() {
    return SizedBox(
      width: double.infinity,
      height: MediaQueryUtil.spacing(52),
      child: ElevatedButton(
        onPressed: () async {
          await controller.clearAllPreferenceSelections();
          Get.back();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.cFF006C6A,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(26)),
          ),
          side: const BorderSide(color: AppColors.cFF006C6A, width: 1),
          shadowColor: AppColors.transparent,
        ),
        child: Text(
          'Clear Filters',
          style: TextStyle(
            fontSize: MediaQueryUtil.fontSize(16),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: MediaQueryUtil.spacing(52),
      child: ElevatedButton(
        onPressed: () async {
          await controller.savePreferenceSelectionsToStorage();
          await controller.loadPosts();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cFF006C6A,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(26)),
          ),
          shadowColor: AppColors.transparent,
        ),
        child: Text(
          'Save',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: MediaQueryUtil.fontSize(16),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

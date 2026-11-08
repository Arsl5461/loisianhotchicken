import 'package:flutter/material.dart';
import '../../utils/media_query.dart';
import 'CustomContainerSelection.dart';

import 'package:OApp/core/constants/app_colors.dart';

class SelectionGrid extends StatelessWidget {
  final List<String> options;
  final String? selectedOption;
  final Function(String) onOptionSelected;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;
  final Color? selectedBackgroundColor;
  final Color? unselectedBackgroundColor;
  final Color? selectedBorderColor;
  final Color? unselectedBorderColor;
  final double borderRadius;
  final double borderWidth;
  final double? textSize;
  final FontWeight? fontWeight;

  const SelectionGrid({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onOptionSelected,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 12.0,
    this.mainAxisSpacing = 12.0,
    this.childAspectRatio = 2.5,
    this.selectedBackgroundColor,
    this.unselectedBackgroundColor,
    this.selectedBorderColor,
    this.unselectedBorderColor,
    this.borderRadius = 12.0,
    this.borderWidth = 1.0,
    this.textSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize MediaQueryUtil for responsive design
    MediaQueryUtil.init(context);

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: MediaQueryUtil.spacing(crossAxisSpacing),
        mainAxisSpacing: MediaQueryUtil.spacing(mainAxisSpacing),
        childAspectRatio: childAspectRatio,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        final isSelected = selectedOption == option;

        return CustomContainerSelection(
          text: option,
          isSelected: isSelected,
          onTap: () => onOptionSelected(option),
          selectedBackgroundColor: selectedBackgroundColor ?? AppColors.white,
          unselectedBackgroundColor:
              unselectedBackgroundColor ??
              AppColors.white.withValues(alpha: 0.3),
          selectedBorderColor: selectedBorderColor ?? AppColors.cFF1E88E5,
          unselectedBorderColor: unselectedBorderColor ?? AppColors.grey[300]!,
          borderRadius: borderRadius,
          borderWidth: borderWidth,
          textSize: textSize ?? 14.0,
          fontWeight: fontWeight ?? FontWeight.w500,
        );
      },
    );
  }
}

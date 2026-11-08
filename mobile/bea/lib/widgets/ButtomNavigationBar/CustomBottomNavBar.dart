import 'package:flutter/material.dart';
import '../../core/typography/app_text_styles.dart';
import '../../utils/media_query.dart';
import '../custom_svg_icons.dart';

import 'package:OApp/core/constants/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    final height = MediaQueryUtil.dynamicSize(
      small: 70,
      medium: 80,
      large: 90,
      extraSmall: 65,
      extraLarge: 100,
    );

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(MediaQueryUtil.spacing(24)),
          topRight: Radius.circular(MediaQueryUtil.spacing(24)),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Row(
          children: [
            _buildNavItem(context, 'Home', 0),
            _buildNavItem(context, 'Matches', 1),
            _buildCenterPlus(context, 2),
            _buildNavItem(context, 'Messages', 3),
            _buildNavItem(context, 'Profile', 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String label, int index) {
    final isActive = selectedIndex == index;
    final iconSize = MediaQueryUtil.iconSize(24);

    final activeColor = AppColors.black;
    final inactiveColor = Color(0xFF828383);

    Widget iconWidget;

    switch (index) {
      case 0:
        iconWidget = CustomSvgIcons.houseHeart(
          color: isActive ? activeColor : inactiveColor,
          size: iconSize,
        );
        break;
      case 1:
        iconWidget = CustomSvgIcons.heart(
          color: isActive ? activeColor : inactiveColor,
          size: iconSize,
        );
        break;
      case 3:
        iconWidget = CustomSvgIcons.messageCircle(
          color: isActive ? activeColor : inactiveColor,
          size: iconSize,
        );
        break;
      case 4:
        iconWidget = CustomSvgIcons.circleUser(
          color: isActive ? activeColor : inactiveColor,
          size: iconSize,
        );
        break;
      default:
        iconWidget = Icon(
          Icons.home,
          color: isActive ? activeColor : inactiveColor,
          size: iconSize,
        );
    }

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        splashColor: AppColors.transparent,
        highlightColor: AppColors.transparent,
        child: Column(
          children: [
            const Spacer(),

            iconWidget,

            const SizedBox(height: 4),

            Text(
              label,
              style: AppTextStyles.verySmall(
                color: isActive ? activeColor : inactiveColor,
                //  fontSize: MediaQueryUtil.fontSize(10),
                fontWeight: isActive
                    ? AppFontWeight.semiBold
                    : AppFontWeight.semiBold,
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterPlus(BuildContext context, int index) {
    final isActive = selectedIndex == index;
    final iconSize = MediaQueryUtil.iconSize(26);

    final activeColor = AppColors.black;
    final inactiveColor = Color(0xFF828383);

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        splashColor: AppColors.transparent,
        highlightColor: AppColors.transparent,
        child: Column(
          children: [
            const Spacer(),

            CustomSvgIcons.circlePlus(
              color: isActive ? activeColor : inactiveColor,
              size: iconSize,
            ),

            const SizedBox(height: 4),

            Text(
              'Travel',
              style: AppTextStyles.verySmall(
                color: isActive ? activeColor : inactiveColor,
                //  fontSize: MediaQueryUtil.fontSize(10),
                fontWeight: isActive
                    ? AppFontWeight.semiBold
                    : AppFontWeight.semiBold,
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}

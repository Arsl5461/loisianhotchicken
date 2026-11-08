import 'package:flutter/material.dart';

import 'package:OApp/core/constants/app_colors.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onLike;
  final VoidCallback onDislike;
  final VoidCallback? onSuperLike;

  const ActionButtons({
    super.key,
    required this.onLike,
    required this.onDislike,
    this.onSuperLike,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Dislike Button
        _ActionButton(
          icon: Icons.close,
          color: AppColors.red[400]!,
          onPressed: onDislike,
          size: 65,
          shadowColor: AppColors.red.withValues(alpha: 0.3),
        ),

        // Like Button
        _ActionButton(
          icon: Icons.favorite,
          color: AppColors.green[400]!,
          onPressed: onLike,
          size: 65,
          shadowColor: AppColors.green.withValues(alpha: 0.3),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final double size;
  final Color shadowColor;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    required this.size,
    required this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 15,
              offset: const Offset(0, 4),
              spreadRadius: 2,
            ),
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
        ),
        child: Icon(icon, color: color, size: size * 0.4),
      ),
    );
  }
}

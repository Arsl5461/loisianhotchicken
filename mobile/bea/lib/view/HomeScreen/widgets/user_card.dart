import 'package:flutter/material.dart';

import '../../../controller/home_controller.dart';
import '../../../models/user_model.dart';

import 'package:OApp/core/constants/app_colors.dart';

import '../../../widgets/Images/base64OrNetworkImage.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  final HomeController controller;

  const UserCard({super.key, required this.user, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background Image or Placeholder
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.grey[300]!, AppColors.grey[400]!],
                ),
              ),
              child: user.photos?.isNotEmpty == true
                  ? Base64OrNetworkImage(
                      imageData: user.photos!.first,
                      fit: BoxFit.cover,
                    )
                  : _buildPlaceholderImage(),
            ),

            // Gradient Overlay for better text visibility
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.transparent,
                    AppColors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),

            // User Information
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Age
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          user.fullName ?? 'Unknown',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (user.age != null)
                        Text(
                          '${user.age}',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Job and Education
                  if (user.jobTitle != null || user.education != null) ...[
                    Text(
                      '${user.jobTitle ?? ''}${user.jobTitle != null && user.education != null ? ' • ' : ''}${user.education ?? ''}',
                      style: TextStyle(
                        color: AppColors.white.withValues(alpha: 0.9),
                        fontSize: 16,
                      ),
                    ),
                  ],

                  const SizedBox(height: 8),

                  // Location
                  if (user.hometown != null) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: AppColors.white.withValues(alpha: 0.9),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          user.hometown!,
                          style: TextStyle(
                            color: AppColors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.yellow[200]!, AppColors.yellow[400]!],
        ),
      ),
      child: Icon(
        Icons.person,
        size: 80,
        color: AppColors.white.withValues(alpha: 0.7),
      ),
    );
  }
}

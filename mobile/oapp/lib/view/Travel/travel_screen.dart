// import 'package:flutter/material.dart';
// import 'package:OApp/core/utils/media_query.dart';
// import 'package:OApp/core/utils/navigation_helpers.dart';
// import 'package:get/get.dart';
// import '../../../../core/routing/app_routes.dart';

// class TravelScreen extends StatefulWidget {
//   const TravelScreen({super.key});

//   @override
//   State<TravelScreen> createState() => _TravelScreenState();
// }

// class _TravelScreenState extends State<TravelScreen> {
//   String _selectedCity = 'New York'; // Default city

//   @override
//   void initState() {
//     super.initState();
//     // Get selected city from route extra if available
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final extra = Get.arguments;
//       if (extra is String) {
//         setState(() {
//           _selectedCity = extra;
//         });
//       }
//     });
//   }

//   static const imageUrls = [
//     'https://plus.unsplash.com/premium_photo-1688676796006-bbd1599bbfb6?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
//     'https://plus.unsplash.com/premium_photo-1687186954188-76f7f4a3d829?q=80&w=686&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
//     'https://images.unsplash.com/photo-1601288496920-b6154fe3626a?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
//     // 4th box uses second URL
//     'https://plus.unsplash.com/premium_photo-1687186954188-76f7f4a3d829?q=80&w=686&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     MediaQueryUtil.init(context);

//     return Scaffold(
//       backgroundColor: AppColors.white,
//       body: Container(
//         color: AppColors.white,
//         child: SafeArea(
//           child: Column(
//             children: [
//               // Header Section
//               Padding(
//                 padding: EdgeInsets.only(
//                   left: MediaQueryUtil.spacing(16),
//                   right: MediaQueryUtil.spacing(16),
//                   top: MediaQueryUtil.spacing(12),
//                   bottom: MediaQueryUtil.spacing(8),
//                 ),
//                 child: Row(
//                   children: [
//                     // Profile picture with story ring - tappable to open travel post
//                     GestureDetector(
//                       onTap: () {
//                         // Navigate to travel post screen
//                         Get.toNamed(Routes.TRAVEL_POST);
//                       },
//                       child: Stack(
//                         children: [
//                           // Status ring (outer ring) - story ring
//                           Container(
//                             width: 40,
//                             height: 40,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               gradient: LinearGradient(
//                                 colors: [
//                                   AppColors.cFF006A68, // Dark teal
//                                   AppColors.cFFDFF3F1, // Light teal
//                                 ],
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                               ),
//                             ),
//                             child: Center(
//                               child: Container(
//                                 width: 36,
//                                 height: 36,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: AppColors.white,
//                                 ),
//                                 child: Center(
//                                   child: CircleAvatar(
//                                     radius: 16,
//                                     backgroundImage: NetworkImage(
//                                       'https://images.unsplash.com/photo-1526129318478-62ed807ebdf9?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           // Plus icon - tappable to create post
//                           Positioned(
//                             right: -2,
//                             bottom: -2,
//                             child: GestureDetector(
//                               onTap: () {
//                                 // Navigate to create post screen
//                                 Get.toNamed(Routes.CREATE_POST);
//                               },
//                               child: Container(
//                                 width: 16,
//                                 height: 16,
//                                 decoration: BoxDecoration(
//                                   color: AppColors.white,
//                                   shape: BoxShape.circle,
//                                   border: Border.all(
//                                     color: AppColors.grey[300]!,
//                                     width: 1,
//                                   ),
//                                 ),
//                                 child: Icon(
//                                   Icons.add,
//                                   size: 10,
//                                   color: AppColors.grey[600],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: MediaQueryUtil.spacing(8)),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text(
//                             'Explore Cities',
//                             style: TextStyle(
//                               fontSize: MediaQueryUtil.fontSize(14),
//                               fontWeight: FontWeight.w700,
//                               color: AppColors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     // Settings/Filter icon - opens preferences
//                     GestureDetector(
//                       onTap: () => Get.toNamed(Routes.TRAVEL_PREFERENCES),
//                       child: Icon(
//                         Icons.tune,
//                         size: MediaQueryUtil.iconSize(20),
//                         color: AppColors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Divider between header and content
//               SizedBox(height: MediaQueryUtil.spacing(8)),
//               Container(height: 1, color: AppColors.black),
//               SizedBox(height: MediaQueryUtil.spacing(8)),
//               // City info row
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: MediaQueryUtil.spacing(16),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // City name on left
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.location_on,
//                           color: AppColors.cFF2A8281, // Teal color
//                           size: MediaQueryUtil.iconSize(12),
//                         ),
//                         SizedBox(width: MediaQueryUtil.spacing(4)),
//                         Text(
//                           '$_selectedCity, NY',
//                           style: TextStyle(
//                             fontSize: MediaQueryUtil.fontSize(12),
//                             color: AppColors.cFF2A8281, // Teal color
//                           ),
//                         ),
//                       ],
//                     ),
//                     // Change city on right
//                     GestureDetector(
//                       onTap: () {
//                         // Navigate to locations modal screen using GetX
//                         Get.toNamed(Routes.LOCATIONS_MODAL);
//                       },
//                       child: Text(
//                         'Change city',
//                         style: TextStyle(
//                           fontSize: MediaQueryUtil.fontSize(12),
//                           color: AppColors.cFF2A8281,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: MediaQueryUtil.spacing(14)),
//               Expanded(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: MediaQueryUtil.spacing(16),
//                   ),
//                   child: LayoutBuilder(
//                     builder: (context, constraints) {
//                       final spacing = MediaQueryUtil.spacing(12);
//                       // 2x2 grid with taller cards to match image
//                       final aspect = 0.65;
//                       return GridView.builder(
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           crossAxisSpacing: spacing,
//                           mainAxisSpacing: spacing,
//                           childAspectRatio: aspect,
//                         ),
//                         itemCount: imageUrls.length,
//                         itemBuilder: (context, index) {
//                           return GestureDetector(
//                             onTap: () {
//                               ConversationNavigator.goToConversation(
//                                 context: context,
//                                 name: 'Kendall Jenner',
//                                 imageUrl: imageUrls[index],
//                                 targetUserId: 'mock_user_$index',
//                                 timeLeft: 'Active now',
//                               );
//                             },
//                             child: _TravelCard(
//                               imageUrl: imageUrls[index],
//                               title: 'Kendall Jenner',
//                               subtitle: '${[24, 27, 27, 21][index % 4]}',
//                               avatarUrl: imageUrls[index],
//                               showTravelTag: index == 1,
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _TravelCard extends StatelessWidget {
//   final String imageUrl;
//   final String title;
//   final String subtitle;
//   final bool showTravelTag;
//   final String avatarUrl;

//   const _TravelCard({
//     required this.imageUrl,
//     required this.title,
//     required this.subtitle,
//     required this.avatarUrl,
//     this.showTravelTag = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         child: Stack(
//           children: [
//             // Main image
//             Positioned.fill(child: Image.network(imageUrl, fit: BoxFit.cover)),

//             // Top-left avatar
//             Positioned(
//               top: 8,
//               left: 8,
//               child: CircleAvatar(
//                 radius: 14,
//                 backgroundImage: NetworkImage(avatarUrl),
//               ),
//             ),

//             // Travel tag (top-right)
//             if (showTravelTag)
//               Positioned(
//                 top: 8,
//                 right: 8,
//                 child: Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: MediaQueryUtil.spacing(8),
//                     vertical: MediaQueryUtil.spacing(4),
//                   ),
//                   decoration: BoxDecoration(
//                     color: AppColors.grey[200],
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     'Travel',
//                     style: TextStyle(
//                       fontSize: MediaQueryUtil.fontSize(10),
//                       fontWeight: FontWeight.w500,
//                       color: AppColors.grey[700],
//                     ),
//                   ),
//                 ),
//               ),

//             // Bottom text overlay
//             Positioned(
//               left: 8,
//               right: 8,
//               bottom: 8,
//               child: Text(
//                 '$title, $subtitle',
//                 style: TextStyle(
//                   color: AppColors.white,
//                   fontWeight: FontWeight.w600,
//                   fontSize: MediaQueryUtil.fontSize(12),
//                   shadows: [
//                     Shadow(blurRadius: 2, color: AppColors.black.withValues(alpha: 0.7)),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

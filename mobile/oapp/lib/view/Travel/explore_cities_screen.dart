// import 'package:flutter/material.dart';
// import 'package:OApp/core/utils/media_query.dart';
// import 'package:get/get.dart';

// /// Locations screen - matches the image exactly
// /// - Clean white background
// /// - Header with location icon, "Locations" title, and "Cancel" button
// /// - Search bar
// /// - "Use current location" option
// /// - "Cities around you" section
// /// - 2x3 grid of city cards
// class ExploreCitiesScreen extends StatelessWidget {
//   const ExploreCitiesScreen({super.key});

//   static const List<_City> _cities = [
//     _City(
//       'London',
//       'https://images.unsplash.com/photo-1526129318478-62ed807ebdf9?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
//     ),
//     _City(
//       'Madrid',
//       'https://images.unsplash.com/photo-1539037116277-4db20889f2d4?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
//     ),
//     _City(
//       'Prague',
//       'https://images.unsplash.com/photo-1541849546-216549ae216d?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
//     ),
//     _City(
//       'Tel Aviv',
//       'https://images.unsplash.com/photo-1544551763-46a013bb70d5?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
//     ),
//     _City(
//       'New York',
//       'https://images.unsplash.com/photo-1500916434205-0c77489c6cf7?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
//     ),
//     _City(
//       'Berlin',
//       'https://images.unsplash.com/photo-1516900557549-41557d405adf?q=80&w=764&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     MediaQueryUtil.init(context);

//     return Scaffold(
//       backgroundColor: AppColors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildHeader(context),
//             SizedBox(height: MediaQueryUtil.spacing(8)),
//             _buildSearchBar(),
//             SizedBox(height: MediaQueryUtil.spacing(12)),
//             _buildCurrentLocationOption(),
//             SizedBox(height: MediaQueryUtil.spacing(5)),
//             _buildSectionTitle(),
//             SizedBox(height: MediaQueryUtil.spacing(16)),
//             Expanded(child: _buildGrid()),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context) {
//     return Column(
//       children: [
//         // Top row with location icon, title, and cancel button
//         Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: MediaQueryUtil.spacing(25),
//             vertical: MediaQueryUtil.spacing(3),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Location icon
//               Icon(
//                 Icons.location_on,
//                 color: AppColors.black,
//                 size: MediaQueryUtil.iconSize(20),
//               ),
//               SizedBox(width: MediaQueryUtil.spacing(4)),
//               // Title
//               Text(
//                 'Locations',
//                 style: TextStyle(
//                   fontSize: MediaQueryUtil.fontSize(16),
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.black,
//                 ),
//               ),
//               // Cancel button
//               TextButton(
//                 onPressed: () => Get.back(),
//                 child: Text(
//                   'Cancel',
//                   style: TextStyle(
//                     fontSize: MediaQueryUtil.fontSize(16),
//                     fontWeight: FontWeight.w500,
//                     color: AppColors.cFF74C7C5,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         // SizedBox(height: MediaQueryUtil.spacing(2)),
//         // Divider
//         Container(height: 1, color: AppColors.grey),
//         SizedBox(height: MediaQueryUtil.spacing(4)),
//         // Centered text
//         Text(
//           'Choose a location to explore',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: MediaQueryUtil.fontSize(11),
//             color: AppColors.black,
//           ),
//         ),
//         SizedBox(height: MediaQueryUtil.spacing(4)),
//         Text(
//           'Content posted will appear within the location you have selected',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: MediaQueryUtil.fontSize(9),
//             color: AppColors.grey[500],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSearchBar() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: MediaQueryUtil.spacing(8)),
//       child: Container(
//         height: MediaQueryUtil.dynamicSize(small: 36, medium: 40, large: 44),
//         decoration: BoxDecoration(
//           color: AppColors.cFFE5E7E6,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: MediaQueryUtil.spacing(12)),
//           child: Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               'Search',
//               style: TextStyle(
//                 fontSize: MediaQueryUtil.fontSize(16),
//                 color: AppColors.grey[500],
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCurrentLocationOption() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: MediaQueryUtil.spacing(8)),
//       child: Row(
//         children: [
//           Icon(
//             Icons.my_location,
//             color: AppColors.cFF619295,
//             size: MediaQueryUtil.iconSize(12),
//           ),
//           SizedBox(width: MediaQueryUtil.spacing(4)),
//           Text(
//             'Use current location',
//             style: TextStyle(
//               fontSize: MediaQueryUtil.fontSize(14),
//               fontWeight: FontWeight.w600,
//               color: AppColors.cFF619295,
//               letterSpacing: -0.5,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionTitle() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: MediaQueryUtil.spacing(12)),
//       child: Align(
//         alignment: Alignment.bottomLeft,
//         child: Text(
//           '  Cities around you',
//           textAlign: TextAlign.start,
//           style: TextStyle(
//             fontSize: MediaQueryUtil.fontSize(18),
//             fontWeight: FontWeight.bold,
//             color: AppColors.black,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildGrid() {
//     final spacing = MediaQueryUtil.spacing(22);

//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: MediaQueryUtil.spacing(22)),
//       child: GridView.builder(
//         itemCount: _cities.length,
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: spacing,
//           mainAxisSpacing: spacing,
//           childAspectRatio: 1.05,
//         ),
//         itemBuilder: (context, index) {
//           final city = _cities[index];
//           return _CityCard(city: city);
//         },
//       ),
//     );
//   }
// }

// class _CityCard extends StatelessWidget {
//   final _City city;

//   const _CityCard({required this.city});

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(20),
//       child: Container(
//         child: Stack(
//           children: [
//             // Main image
//             Positioned.fill(
//               child: Image.network(
//                 city.imageUrl,
//                 fit: BoxFit.cover,
//                 loadingBuilder: (context, child, loadingProgress) {
//                   if (loadingProgress == null) return child;
//                   return Container(
//                     color: AppColors.grey[200],
//                     child: Center(
//                       child: CircularProgressIndicator(
//                         value: loadingProgress.expectedTotalBytes != null
//                             ? loadingProgress.cumulativeBytesLoaded /
//                                   loadingProgress.expectedTotalBytes!
//                             : null,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             // Gradient overlay
//             Positioned.fill(
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [AppColors.transparent, AppColors.black.withValues(alpha: 0.3)],
//                   ),
//                 ),
//               ),
//             ),
//             // City name overlay
//             Positioned(
//               left: MediaQueryUtil.spacing(12),
//               bottom: MediaQueryUtil.spacing(12),
//               child: Text(
//                 city.name,
//                 style: TextStyle(
//                   color: AppColors.white,
//                   fontWeight: FontWeight.w700,
//                   fontSize: MediaQueryUtil.fontSize(12),
//                   shadows: [
//                     Shadow(
//                       blurRadius: 4,
//                       color: AppColors.black.withValues(alpha: 0.5),
//                       offset: Offset(0, 1),
//                     ),
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

// class _City {
//   final String name;
//   final String imageUrl;

//   const _City(this.name, this.imageUrl);
// }

import 'package:flutter/material.dart';

class BrandAssets {
  const BrandAssets._();

  static const logo = 'assets/logo.jpg';
}

class BrandLogo extends StatelessWidget {
  const BrandLogo({
    super.key,
    this.size = 48,
    this.radius = 16,
    this.border,
  });

  final double size;
  final double radius;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: border,
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        BrandAssets.logo,
        fit: BoxFit.cover,
        semanticLabel: 'Louisiana Hot Chicken',
      ),
    );
  }
}

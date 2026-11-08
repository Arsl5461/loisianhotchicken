import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:OApp/config/app_config.dart';
import 'package:OApp/core/constants/app_colors.dart';
import 'package:flutter_svg/svg.dart';

enum AppImageMimeType { png, jpg, jpeg, webp, gif, bmp, svg, unknown }

enum AppImageSourceType { network, asset, base64, unknown }

class Base64OrNetworkImage extends StatelessWidget {
  final String imageData;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final double iconSize;

  /// only used for svg
  final Color? svgColor;
  final Duration fadeInDuration;
  final FilterQuality filterQuality;

  const Base64OrNetworkImage({
    super.key,
    required this.imageData,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.iconSize = 40,
    this.svgColor,
    this.fadeInDuration = const Duration(milliseconds: 220),
    this.filterQuality = FilterQuality.medium,
  });

  @override
  Widget build(BuildContext context) {
    final value = normalizeImageData(imageData);

    if (value.isEmpty) {
      return _buildPlaceholder();
    }

    try {
      /// 1) NETWORK IMAGE / SVG
      if (_isNetworkImage(value)) {
        if (_isSvgPath(value) || _isSvgDataUri(value)) {
          return SvgPicture.network(
            value,
            width: width,
            height: height,
            fit: fit,
            colorFilter: svgColor != null
                ? ColorFilter.mode(svgColor!, BlendMode.srcIn)
                : null,
            placeholderBuilder: (_) =>
                BlurShimmerPlaceholder(width: width, height: height),
          );
        }

        return _buildCachedNetworkImage(context, value);
      }

      /// 2) ASSET IMAGE / SVG
      if (_isAssetImage(value)) {
        if (_isSvgPath(value)) {
          return SvgPicture.asset(
            value,
            width: width,
            height: height,
            fit: fit,
            colorFilter: svgColor != null
                ? ColorFilter.mode(svgColor!, BlendMode.srcIn)
                : null,
            placeholderBuilder: (_) =>
                BlurShimmerPlaceholder(width: width, height: height),
          );
        }

        return Image.asset(
          value,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return errorWidget ?? _buildPlaceholder();
          },
        );
      }

      /// 3) BASE64 IMAGE / SVG
      if (_isSvgBase64(value)) {
        final String? svgString = _tryDecodeBase64ToString(value);
        if (svgString == null) {
          return errorWidget ?? _buildPlaceholder();
        }

        return SvgPicture.string(
          svgString,
          width: width,
          height: height,
          fit: fit,
          colorFilter: svgColor != null
              ? ColorFilter.mode(svgColor!, BlendMode.srcIn)
              : null,
        );
      }

      final Uint8List? bytes = _tryDecodeBase64(value);
      if (bytes == null) {
        return errorWidget ?? _buildPlaceholder();
      }

      final cacheWidth = _memCachePixels(context, width);
      final cacheHeight = _memCachePixels(context, height);

      return Image.memory(
        bytes,
        width: width,
        height: height,
        fit: fit,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        gaplessPlayback: true,
        filterQuality: filterQuality,
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? _buildPlaceholder();
        },
      );
    } catch (_) {
      return errorWidget ?? _buildPlaceholder();
    }
  }

  static String normalizeImageData(String? imageData) {
    if (imageData == null) return '';

    final value = imageData.trim();
    if (value.isEmpty) return '';

    if (value.startsWith('http://') ||
        value.startsWith('https://') ||
        value.startsWith('data:') ||
        value.startsWith('assets/')) {
      return value;
    }

    if (value.startsWith('//')) {
      return 'https:$value';
    }

    if (value.startsWith('/')) {
      final base = AppConfig.baseUrl.replaceAll(RegExp(r'/$'), '');
      return '$base$value';
    }

    final lower = value.toLowerCase();
    if (lower.contains('firebasestorage.googleapis.com') ||
        lower.contains('storage.googleapis.com')) {
      return 'https://$value';
    }

    return value;
  }

  static bool isNetworkUrl(String? imageData) {
    final value = normalizeImageData(imageData);
    return value.startsWith('http://') || value.startsWith('https://');
  }

  Widget _buildCachedNetworkImage(BuildContext context, String value) {
    Widget buildImage({int? cacheWidth, int? cacheHeight}) {
      return CachedNetworkImage(
        imageUrl: value,
        width: width,
        height: height,
        fit: fit,
        memCacheWidth: cacheWidth,
        memCacheHeight: cacheHeight,
        filterQuality: filterQuality,
        fadeInDuration: fadeInDuration,
        fadeOutDuration: const Duration(milliseconds: 120),
        useOldImageOnUrlChange: true,
        placeholder: (context, url) =>
            placeholder ?? BlurShimmerPlaceholder(width: width, height: height),
        errorWidget: (context, url, error) =>
            errorWidget ?? _buildPlaceholder(),
      );
    }

    final hasFiniteWidth = width != null && width!.isFinite && width! > 0;
    final hasFiniteHeight = height != null && height!.isFinite && height! > 0;

    if (hasFiniteWidth && hasFiniteHeight) {
      return buildImage(
        cacheWidth: _memCachePixels(context, width),
        cacheHeight: _memCachePixels(context, height),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final layoutWidth =
            constraints.maxWidth.isFinite && constraints.maxWidth > 0
            ? constraints.maxWidth
            : null;
        final layoutHeight =
            constraints.maxHeight.isFinite && constraints.maxHeight > 0
            ? constraints.maxHeight
            : null;

        return buildImage(
          cacheWidth: layoutWidth != null
              ? _memCachePixels(context, layoutWidth)
              : null,
          cacheHeight: layoutHeight != null
              ? _memCachePixels(context, layoutHeight)
              : null,
        );
      },
    );
  }

  /// Downloads a remote image to disk cache so the first paint is faster.
  static Future<void> warmNetworkCache(String imageData) async {
    final url = normalizeImageData(imageData);
    if (!isNetworkUrl(url)) return;

    try {
      await DefaultCacheManager().downloadFile(url);
    } catch (_) {}
  }

  /// Decodes a remote image into the in-memory image cache.
  static Future<void> warmMemoryCache(
    BuildContext context,
    String imageData, {
    double? width,
    double? height,
  }) async {
    if (!context.mounted) return;

    final url = normalizeImageData(imageData);
    if (!isNetworkUrl(url)) return;

    final cacheWidth = width != null && width.isFinite && width > 0
        ? _memCachePixels(context, width)
        : _memCachePixels(context, MediaQuery.sizeOf(context).width);
    final cacheHeight = height != null && height.isFinite && height > 0
        ? _memCachePixels(context, height)
        : _memCachePixels(context, MediaQuery.sizeOf(context).height);

    final provider = CachedNetworkImageProvider(
      url,
      maxWidth: cacheWidth,
      maxHeight: cacheHeight,
    );

    try {
      await precacheImage(provider, context);
    } catch (_) {}
  }

  static void prefetchUrls(
    BuildContext? context,
    Iterable<String> urls, {
    double? width,
    double? height,
  }) {
    for (final url in urls) {
      final normalized = normalizeImageData(url);
      if (!isNetworkUrl(normalized)) continue;

      unawaited(warmNetworkCache(normalized));
      if (context != null && context.mounted) {
        unawaited(
          warmMemoryCache(context, normalized, width: width, height: height),
        );
      }
    }
  }

  static int? _memCachePixels(BuildContext context, double? logicalSize) {
    if (logicalSize == null || !logicalSize.isFinite || logicalSize <= 0) {
      return null;
    }

    final pixels = (logicalSize * MediaQuery.devicePixelRatioOf(context))
        .round();
    return pixels > 0 ? pixels : null;
  }

  bool _isNetworkImage(String value) {
    return value.startsWith('http://') || value.startsWith('https://');
  }

  bool _isAssetImage(String value) {
    return value.startsWith('assets/');
  }

  bool _isSvgPath(String value) {
    return value.toLowerCase().endsWith('.svg');
  }

  bool _isSvgDataUri(String value) {
    return value.startsWith('data:image/svg+xml');
  }

  bool _isSvgBase64(String value) {
    final normalized = value.trim().toLowerCase();
    return normalized.startsWith('data:image/svg+xml;base64,');
  }

  Uint8List? _tryDecodeBase64(String value) {
    try {
      String base64String = value;

      if (base64String.contains(',')) {
        base64String = base64String.split(',').last;
      }

      base64String = base64String.replaceAll(RegExp(r'\s+'), '');

      if (base64String.isEmpty) return null;

      return base64Decode(base64String);
    } catch (_) {
      return null;
    }
  }

  String? _tryDecodeBase64ToString(String value) {
    try {
      final bytes = _tryDecodeBase64(value);
      if (bytes == null) return null;
      return utf8.decode(bytes);
    } catch (_) {
      return null;
    }
  }

  Widget _buildPlaceholder() {
    if (placeholder != null) return placeholder!;

    return Container(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      color: AppColors.grey[300],
      child: Icon(Icons.person, color: AppColors.grey[600], size: iconSize),
    );
  }

  /// For CircleAvatar / DecorationImage
  /// Note: Svg cannot be returned as ImageProvider.
  static ImageProvider? getImageProvider(
    String? imageData, {
    int? maxWidth,
    int? maxHeight,
  }) {
    if (imageData == null || imageData.trim().isEmpty) return null;

    final value = normalizeImageData(imageData);

    if (_isSvgAny(value)) return null;

    if (value.startsWith('http://') || value.startsWith('https://')) {
      return CachedNetworkImageProvider(
        value,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );
    }

    if (value.startsWith('assets/')) {
      return AssetImage(value);
    }

    try {
      String base64String = value;

      if (base64String.contains(',')) {
        base64String = base64String.split(',').last;
      }

      base64String = base64String.replaceAll(RegExp(r'\s+'), '');

      return MemoryImage(base64Decode(base64String));
    } catch (e) {
      return null;
    }
  }

  static bool _isSvgAny(String value) {
    final v = value.trim().toLowerCase();
    return v.endsWith('.svg') || v.startsWith('data:image/svg+xml');
  }

  /// Detect source type
  static AppImageSourceType getSourceType(String? imageData) {
    if (imageData == null || imageData.trim().isEmpty) {
      return AppImageSourceType.unknown;
    }

    final value = imageData.trim();

    if (value.startsWith('http://') || value.startsWith('https://')) {
      return AppImageSourceType.network;
    }

    if (value.startsWith('assets/')) {
      return AppImageSourceType.asset;
    }

    return AppImageSourceType.base64;
  }

  /// Detect mime type from asset path / url / base64 header
  static AppImageMimeType getMimeType(String? imageData) {
    if (imageData == null || imageData.trim().isEmpty) {
      return AppImageMimeType.unknown;
    }

    final value = imageData.trim().toLowerCase();

    if (value.startsWith('data:image/svg+xml')) return AppImageMimeType.svg;
    if (value.startsWith('data:image/png')) return AppImageMimeType.png;
    if (value.startsWith('data:image/jpeg')) return AppImageMimeType.jpeg;
    if (value.startsWith('data:image/jpg')) return AppImageMimeType.jpg;
    if (value.startsWith('data:image/webp')) return AppImageMimeType.webp;
    if (value.startsWith('data:image/gif')) return AppImageMimeType.gif;
    if (value.startsWith('data:image/bmp')) return AppImageMimeType.bmp;

    if (value.endsWith('.svg')) return AppImageMimeType.svg;
    if (value.endsWith('.png')) return AppImageMimeType.png;
    if (value.endsWith('.jpg')) return AppImageMimeType.jpg;
    if (value.endsWith('.jpeg')) return AppImageMimeType.jpeg;
    if (value.endsWith('.webp')) return AppImageMimeType.webp;
    if (value.endsWith('.gif')) return AppImageMimeType.gif;
    if (value.endsWith('.bmp')) return AppImageMimeType.bmp;

    return AppImageMimeType.unknown;
  }

  /// specifically for assets
  static AppImageMimeType getAssetMimeType(String? assetPath) {
    if (assetPath == null || assetPath.trim().isEmpty) {
      return AppImageMimeType.unknown;
    }

    final value = assetPath.trim().toLowerCase();

    if (!value.startsWith('assets/')) {
      return AppImageMimeType.unknown;
    }

    if (value.endsWith('.svg')) return AppImageMimeType.svg;
    if (value.endsWith('.png')) return AppImageMimeType.png;
    if (value.endsWith('.jpg')) return AppImageMimeType.jpg;
    if (value.endsWith('.jpeg')) return AppImageMimeType.jpeg;
    if (value.endsWith('.webp')) return AppImageMimeType.webp;
    if (value.endsWith('.gif')) return AppImageMimeType.gif;
    if (value.endsWith('.bmp')) return AppImageMimeType.bmp;

    return AppImageMimeType.unknown;
  }
}

class BlurShimmerPlaceholder extends StatefulWidget {
  final double? width;
  final double? height;
  final double borderRadius;

  const BlurShimmerPlaceholder({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 12,
  });

  @override
  State<BlurShimmerPlaceholder> createState() => _BlurShimmerPlaceholderState();
}

class _BlurShimmerPlaceholderState extends State<BlurShimmerPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = AppColors.grey[200] ?? const Color(0xFFE8E8E8);
    final highlight = AppColors.grey[100] ?? const Color(0xFFF3F3F3);

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-1 + _controller.value * 2, 0),
                end: Alignment(1 + _controller.value * 2, 0),
                colors: [base, highlight, base],
              ),
            ),
          );
        },
      ),
    );
  }
}

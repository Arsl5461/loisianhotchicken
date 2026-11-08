import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:OApp/utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class ActionSheets {
  static void showActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (ctx) {
        MediaQueryUtil.init(ctx);
        return Container(
          padding: EdgeInsets.fromLTRB(
            MediaQueryUtil.spacing(16),
            MediaQueryUtil.spacing(8),
            MediaQueryUtil.spacing(16),
            MediaQueryUtil.spacing(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Main actions card
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _actionButton(
                      ctx,
                      'Hide User',
                      isFirst: true,
                      onTap: () {
                        Get.back();
                        showHideUserSheet(context);
                      },
                    ),
                    Divider(
                      height: 1,
                      thickness: 0.5,
                      color: AppColors.grey[300],
                    ),
                    _actionButton(
                      ctx,
                      'Report',
                      isLast: true,
                      onTap: () {
                        Get.back();
                        showReportSheet(context);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQueryUtil.spacing(12)),

              // Cancel button card (separate)
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: _actionButton(
                  ctx,
                  'Cancel',
                  textColor: AppColors.red,
                  isFirst: true,
                  isLast: true,
                  onTap: () => Get.back(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void showHideUserSheet(BuildContext context) {
    final reasons = [
      'Not interested',
      'Inappropriate content',
      'Looks underage',
      'Advertising or not relevant',
    ];
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: AppColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        MediaQueryUtil.init(ctx);
        return Padding(
          padding: EdgeInsets.fromLTRB(
            MediaQueryUtil.spacing(16),
            MediaQueryUtil.spacing(12),
            MediaQueryUtil.spacing(16),
            MediaQueryUtil.spacing(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _sheetHeader(ctx, 'Hide User', onClose: () => Get.back()),
              Text(
                'Your reason matters',
                style: TextStyle(
                  color: AppColors.grey[700],
                  fontSize: MediaQueryUtil.fontSize(12),
                ),
              ),
              SizedBox(height: MediaQueryUtil.spacing(14)),
              for (final r in reasons) ...[
                _sheetChoice(ctx, r, onTap: () => Get.back()),
                SizedBox(height: MediaQueryUtil.spacing(10)),
              ],
            ],
          ),
        );
      },
    );
  }

  static void showReportSheet(BuildContext context) {
    final categories = [
      'Violence and abuse',
      'Hate and harassment',
      'Self-harm',
      'Nudity and sexual content',
      'Fraud and scam',
      'False identity',
      'Graphic content',
    ];
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: AppColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        MediaQueryUtil.init(ctx);
        return Padding(
          padding: EdgeInsets.fromLTRB(
            MediaQueryUtil.spacing(16),
            MediaQueryUtil.spacing(12),
            MediaQueryUtil.spacing(16),
            MediaQueryUtil.spacing(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _sheetHeader(ctx, 'Report User', onClose: () => Get.back()),
              Text(
                'What should we know',
                style: TextStyle(
                  color: AppColors.grey[700],
                  fontSize: MediaQueryUtil.fontSize(12),
                ),
              ),
              SizedBox(height: MediaQueryUtil.spacing(14)),
              for (final c in categories) ...[
                _sheetChoice(
                  ctx,
                  c,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Get.back();
                    showReportReasonSheet(context, c);
                  },
                ),
                SizedBox(height: MediaQueryUtil.spacing(10)),
              ],
            ],
          ),
        );
      },
    );
  }

  static void showReportReasonSheet(BuildContext context, String category) {
    final reasons = ['Violence', 'Abuse'];
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        MediaQueryUtil.init(ctx);
        return Padding(
          padding: EdgeInsets.fromLTRB(
            MediaQueryUtil.spacing(16),
            MediaQueryUtil.spacing(12),
            MediaQueryUtil.spacing(16),
            MediaQueryUtil.spacing(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _sheetHeader(ctx, 'Choose Reason', onClose: () => Get.back()),
              Text(
                'What should we know',
                style: TextStyle(
                  color: AppColors.grey[700],
                  fontSize: MediaQueryUtil.fontSize(12),
                ),
              ),
              SizedBox(height: MediaQueryUtil.spacing(14)),
              for (final r in reasons) ...[
                _sheetChoice(
                  ctx,
                  r,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Get.back();
                    showReportDetailSheet(context, r);
                  },
                ),
                SizedBox(height: MediaQueryUtil.spacing(10)),
              ],
            ],
          ),
        );
      },
    );
  }

  static void showReportDetailSheet(BuildContext context, String reason) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: AppColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        MediaQueryUtil.init(ctx);
        return Padding(
          padding: EdgeInsets.fromLTRB(
            MediaQueryUtil.spacing(16),
            MediaQueryUtil.spacing(12),
            MediaQueryUtil.spacing(16),
            MediaQueryUtil.spacing(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _sheetHeader(ctx, 'Report', onClose: () => Get.back()),
              SizedBox(height: MediaQueryUtil.spacing(16)),

              // Section title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Violence and abuse',
                  style: TextStyle(
                    fontSize: MediaQueryUtil.fontSize(18),
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey[600],
                  ),
                ),
              ),
              SizedBox(height: MediaQueryUtil.spacing(12)),

              // Report description text
              Text(
                'Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril',
                style: TextStyle(
                  fontSize: MediaQueryUtil.fontSize(14),
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                  height: 1.4,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: MediaQueryUtil.spacing(24)),

              // Report button
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: MediaQueryUtil.spacing(12),
                ),
                decoration: BoxDecoration(
                  color: AppColors.cFFB6B6B6,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Report',
                  style: TextStyle(
                    fontSize: MediaQueryUtil.fontSize(16),
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper methods
  static Widget _actionButton(
    BuildContext ctx,
    String label, {
    VoidCallback? onTap,
    Color? textColor,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          top: isFirst ? Radius.circular(14) : Radius.zero,
          bottom: isLast ? Radius.circular(14) : Radius.zero,
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: MediaQueryUtil.spacing(16),
            vertical: MediaQueryUtil.spacing(16),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: MediaQueryUtil.fontSize(14),
              color: textColor ?? AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  static Widget _sheetHeader(
    BuildContext ctx,
    String title, {
    VoidCallback? onClose,
  }) {
    return Row(
      children: [
        const SizedBox(width: 24),
        Expanded(
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.black87,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: onClose,
          icon: const Icon(Icons.close, color: AppColors.black54),
        ),
      ],
    );
  }

  static Widget _sheetChoice(
    BuildContext ctx,
    String label, {
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: MediaQueryUtil.spacing(16),
            vertical: MediaQueryUtil.spacing(14),
          ),
          decoration: BoxDecoration(
            color: AppColors.cFFB6B6B6,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:OApp/hardcoded_data.dart';
import 'package:OApp/widgets/custom_svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:OApp/utils/media_query.dart';

import '../../../core/typography/app_text_styles.dart';
import '../../../models/user_model.dart';

import 'package:OApp/core/constants/app_colors.dart';

class AboutCard extends StatelessWidget {
  final int age;
  final String location;
  final UserModel user;

  const AboutCard({
    super.key,
    required this.age,
    required this.location,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    final summaryItems = _buildSummaryItems();
    final detailItems = _buildDetailItems();

    if (summaryItems.isEmpty && detailItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQueryUtil.spacing(6),
        vertical: MediaQueryUtil.spacing(8),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(18)),
        border: Border.all(color: AppColors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            offset: const Offset(0, 4),
            blurRadius: 14,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              MediaQueryUtil.spacing(18),
              MediaQueryUtil.spacing(18),
              MediaQueryUtil.spacing(18),
              MediaQueryUtil.spacing(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: MediaQueryUtil.spacing(22),
                  decoration: BoxDecoration(
                    color: AppColors.cFF006C6A,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(width: MediaQueryUtil.spacing(10)),
                Text(
                  'About',
                  style: AppTextStyles.text(
                    fontFamily: AppFontFamily.playfair,
                    customSize: MediaQueryUtil.fontSize(26),
                    fontWeight: AppFontWeight.semi,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
          if (summaryItems.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQueryUtil.spacing(16),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var i = 0; i < summaryItems.length; i++) ...[
                      if (i > 0) SizedBox(width: MediaQueryUtil.spacing(8)),
                      summaryItems[i],
                    ],
                    SizedBox(width: MediaQueryUtil.spacing(4)),
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQueryUtil.spacing(16)),
          ],
          if (summaryItems.isNotEmpty && detailItems.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQueryUtil.spacing(18),
              ),
              child: Divider(
                height: 1,
                thickness: 1,
                color: AppColors.grey[200],
              ),
            ),
          if (detailItems.isNotEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQueryUtil.spacing(18),
                MediaQueryUtil.spacing(16),
                MediaQueryUtil.spacing(18),
                MediaQueryUtil.spacing(18),
              ),
              child: Column(
                children: [
                  for (var i = 0; i < detailItems.length; i++) ...[
                    if (i > 0) SizedBox(height: MediaQueryUtil.spacing(14)),
                    detailItems[i],
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildSummaryItems() {
    final items = <Widget>[];

    if (age > 0) {
      items.add(
        _SummaryChip(
          icon: CustomSvgIcons.birthday(
            color: AppColors.cFF006C6A,
            size: MediaQueryUtil.iconSize(14),
          ),
          label: '$age',
        ),
      );
    }

    if (user.height != null && user.showHeight == true) {
      items.add(
        _SummaryChip(
          icon: CustomSvgIcons.height(
            color: AppColors.cFF006C6A,
            size: MediaQueryUtil.iconSize(13),
          ),
          label: HardCodedDataFormatter.formatHeight(user.height),
        ),
      );
    }

    if (user.languages != null &&
        user.languages!.isNotEmpty &&
        user.showLanguages == true) {
      items.add(
        _SummaryChip(
          icon: CustomSvgIcons.language(
            color: AppColors.cFF006C6A,
            size: MediaQueryUtil.iconSize(13),
          ),
          label: user.languages!.first,
        ),
      );
    }

    if (user.religiousViews != null && user.showReligion == true) {
      items.add(
        _SummaryChip(
          icon: CustomSvgIcons.agnostic(
            color: AppColors.cFF006C6A,
            size: MediaQueryUtil.iconSize(13),
          ),
          label: user.religiousViews!,
        ),
      );
    }

    if (user.politicalAffiliation != null &&
        user.showPoliticalAffiliation == true) {
      items.add(
        _SummaryChip(
          icon: CustomSvgIcons.liberal(
            color: AppColors.cFF006C6A,
            size: MediaQueryUtil.iconSize(13),
          ),
          label: user.politicalAffiliation!,
        ),
      );
    }

    return items;
  }

  List<Widget> _buildDetailItems() {
    final items = <Widget>[];

    if (user.companyName != null &&
        user.showCompanyName == true &&
        user.showJobTitle == true) {
      final value = '${user.jobTitle ?? ''} at ${user.companyName ?? ''}'
          .trim();
      if (value.isNotEmpty && value != 'at') {
        items.add(
          _DetailRow(
            icon: CustomSvgIcons.works(
              color: AppColors.cFF006C6A,
              size: MediaQueryUtil.iconSize(16),
            ),
            label: 'Works',
            value: value,
          ),
        );
      }
    }

    if (user.education != null && user.showSchoolName == true) {
      final value = '${user.education ?? ''} at ${user.schoolName ?? ''}'
          .trim();
      if (value.isNotEmpty && value != 'at') {
        items.add(
          _DetailRow(
            icon: CustomSvgIcons.studied(
              color: AppColors.cFF006C6A,
              size: MediaQueryUtil.iconSize(16),
            ),
            label: 'Studied',
            value: value,
          ),
        );
      }
    }

    if (location.isNotEmpty && user.showHometown == true) {
      items.add(
        _DetailRow(
          icon: CustomSvgIcons.raisedIn(
            color: AppColors.cFF006C6A,
            size: MediaQueryUtil.iconSize(16),
          ),
          label: 'Raised in',
          value: location,
        ),
      );
    }

    return items;
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.icon, required this.label});

  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQueryUtil.spacing(12),
        vertical: MediaQueryUtil.spacing(8),
      ),
      decoration: BoxDecoration(
        color: AppColors.cFFDFF3F1,
        borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(20)),
        border: Border.all(color: AppColors.cFF006C6A.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(width: MediaQueryUtil.spacing(6)),
          Text(
            label,
            style: AppTextStyles.small(
              fontFamily: AppFontFamily.publicSans,
              fontWeight: AppFontWeight.semi,
              color: AppColors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final Widget icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQueryUtil.spacing(36),
          height: MediaQueryUtil.spacing(36),
          decoration: BoxDecoration(
            color: AppColors.cFFDFF3F1,
            borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(10)),
          ),
          child: Center(child: icon),
        ),
        SizedBox(width: MediaQueryUtil.spacing(12)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: AppTextStyles.text(
                  fontFamily: AppFontFamily.publicSans,
                  customSize: MediaQueryUtil.fontSize(10),
                  color: AppColors.c48b1ab,
                  fontWeight: AppFontWeight.semiBold,
                ),
              ),
              SizedBox(height: MediaQueryUtil.spacing(3)),
              Text(
                value,
                style: AppTextStyles.small(
                  fontFamily: AppFontFamily.publicSans,
                  fontWeight: AppFontWeight.semi,
                  color: AppColors.black87,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

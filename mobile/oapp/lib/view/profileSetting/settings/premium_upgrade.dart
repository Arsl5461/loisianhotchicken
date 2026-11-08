import 'package:OApp/widgets/Images/Base64OrNetworkImage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/typography/app_text_styles.dart';
import '../../../utils/media_query.dart';
import '../../../widgets/Layout/EditProfileHeader.dart';
import 'controllers/premium_upgrade_controller.dart';

class PremiumUpgradeScreen extends GetView<PremiumUpgradeController> {
  const PremiumUpgradeScreen({super.key});

  static const _features = <_FeatureRowData>[
    _FeatureRowData('Unlimited likes', true, true, true),
    _FeatureRowData('See whxo likes you', true, true, true),
    _FeatureRowData('Insights report', false, true, true),
    _FeatureRowData('Incognito mode', false, true, true),
    _FeatureRowData('Unlimited timer', false, false, true),
    _FeatureRowData('Travel mode priority', false, false, true),
  ];

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.cFFF8F8F8,
      body: SafeArea(
        child: Column(
          children: [
            EditProfileHeader(
              title: 'Subscription Plans',
              onBack: Get.back,
              showCloseButton: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQueryUtil.spacing(16),
                ),
                child: Column(
                  children: [
                    SizedBox(height: MediaQueryUtil.spacing(12)),
                    _ProfileHero(controller: controller),
                    SizedBox(height: MediaQueryUtil.spacing(24)),
                    _PlanPicker(controller: controller),
                    SizedBox(height: MediaQueryUtil.spacing(28)),
                    _FeatureComparison(
                      controller: controller,
                      features: _features,
                    ),
                    SizedBox(height: MediaQueryUtil.spacing(20)),
                  ],
                ),
              ),
            ),
            _BottomActions(controller: controller),
          ],
        ),
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.controller});

  final PremiumUpgradeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final photo =
          controller.profileDisplayController.user.value?.photos?.firstOrNull ??
          '';
      final planLabel = controller.currentPlanLabel;

      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.cFF006C6A, width: 2),
            ),
            child: ClipOval(
              child: SizedBox(
                width: MediaQueryUtil.spacing(72),
                height: MediaQueryUtil.spacing(72),
                child: photo.isNotEmpty
                    ? Base64OrNetworkImage(
                        imageData: photo,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.low,
                      )
                    : ColoredBox(
                        color: AppColors.grey[200]!,
                        child: Icon(
                          Icons.person,
                          color: AppColors.grey[600],
                          size: MediaQueryUtil.iconSize(32),
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(height: MediaQueryUtil.spacing(12)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQueryUtil.spacing(14),
              vertical: MediaQueryUtil.spacing(6),
            ),
            decoration: BoxDecoration(
              color: AppColors.cFFDFF3F1,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Current plan: $planLabel',
              style: AppTextStyles.small(
                fontWeight: AppFontWeight.semiBold,
                color: AppColors.cFF006C6A,
              ),
            ),
          ),
          SizedBox(height: MediaQueryUtil.spacing(8)),
          Text(
            'Choose the plan that fits how you date',
            textAlign: TextAlign.center,
            style: AppTextStyles.verySmall(color: AppColors.grey[600]),
          ),
        ],
      );
    });
  }
}

class _PlanPicker extends StatelessWidget {
  const _PlanPicker({required this.controller});

  final PremiumUpgradeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _PlanCard(
              title: 'Basic',
              price: 'Free',
              subtitle: 'Access code required',
              index: 0,
              isSelected: controller.selectedPlan.value == 0,
              onTap: () => controller.selectPlan(0),
            ),
          ),
          SizedBox(width: MediaQueryUtil.spacing(10)),
          Expanded(
            child: _PlanCard(
              title: 'Standard',
              price: '\$7.99',
              priceSuffix: '/mo',
              subtitle: 'Recurring billing\nCancel anytime',
              index: 1,
              isSelected: controller.selectedPlan.value == 1,
              onTap: () => controller.selectPlan(1),
            ),
          ),
          SizedBox(width: MediaQueryUtil.spacing(10)),
          Expanded(
            child: _PlanCard(
              title: 'Premium',
              price: '\$9.99',
              priceSuffix: '/mo',
              subtitle: 'Recurring billing\nCancel anytime',
              index: 2,
              isSelected: controller.selectedPlan.value == 2,
              onTap: () => controller.selectPlan(2),
              badge: 'Best value',
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.title,
    required this.price,
    required this.subtitle,
    required this.index,
    required this.isSelected,
    required this.onTap,
    this.priceSuffix,
    this.badge,
  });

  final String title;
  final String price;
  final String? priceSuffix;
  final String subtitle;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: MediaQueryUtil.spacing(8),
          vertical: MediaQueryUtil.spacing(14),
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : AppColors.cFFDFF3F1,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.cFF006C6A : AppColors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.cFF006C6A.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badge != null) ...[
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQueryUtil.spacing(8),
                  vertical: MediaQueryUtil.spacing(3),
                ),
                decoration: BoxDecoration(
                  color: AppColors.cFF006C6A,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge!,
                  style: AppTextStyles.extraSmall(
                    color: AppColors.white,
                    fontWeight: AppFontWeight.semiBold,
                  ),
                ),
              ),
              SizedBox(height: MediaQueryUtil.spacing(8)),
            ] else
              SizedBox(height: MediaQueryUtil.spacing(22)),
            Text(
              title,
              style: AppTextStyles.small(
                fontFamily: AppFontFamily.urbanist,
                fontWeight: AppFontWeight.semiBold,
              ),
            ),
            SizedBox(height: MediaQueryUtil.spacing(6)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    price,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.small(
                      fontWeight: AppFontWeight.semiBold,
                      color: AppColors.black87,
                    ),
                  ),
                ),
                if (priceSuffix != null)
                  Text(
                    priceSuffix!,
                    style: AppTextStyles.extraSmall(color: AppColors.grey[600]),
                  ),
              ],
            ),
            SizedBox(height: MediaQueryUtil.spacing(6)),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.extraSmall(
                fontWeight: AppFontWeight.semi,
                color: AppColors.grey[700],
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureComparison extends StatelessWidget {
  const _FeatureComparison({required this.controller, required this.features});

  final PremiumUpgradeController controller;
  final List<_FeatureRowData> features;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedPlan.value;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(MediaQueryUtil.spacing(16)),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "What's included",
              style: AppTextStyles.regular(fontWeight: AppFontWeight.semiBold),
            ),
            SizedBox(height: MediaQueryUtil.spacing(14)),
            _FeatureHeader(selectedPlan: selected),
            SizedBox(height: MediaQueryUtil.spacing(8)),
            for (var i = 0; i < features.length; i++) ...[
              _FeatureRow(data: features[i], selectedPlan: selected),
              if (i < features.length - 1)
                Divider(height: 1, color: AppColors.grey[200]),
            ],
          ],
        ),
      );
    });
  }
}

class _FeatureHeader extends StatelessWidget {
  const _FeatureHeader({required this.selectedPlan});

  final int selectedPlan;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(flex: 3, child: SizedBox.shrink()),
        Expanded(
          flex: 2,
          child: _PlanColumnLabel(
            label: 'Free',
            highlighted: selectedPlan == 0,
          ),
        ),
        Expanded(
          flex: 2,
          child: _PlanColumnLabel(
            label: 'Standard',
            highlighted: selectedPlan == 1,
          ),
        ),
        Expanded(
          flex: 2,
          child: _PlanColumnLabel(
            label: 'Premium',
            highlighted: selectedPlan == 2,
          ),
        ),
      ],
    );
  }
}

class _PlanColumnLabel extends StatelessWidget {
  const _PlanColumnLabel({required this.label, required this.highlighted});

  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: MediaQueryUtil.spacing(6)),
      decoration: BoxDecoration(
        color: highlighted ? AppColors.cFFDFF3F1 : AppColors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: AppTextStyles.extraSmall(
          fontWeight: AppFontWeight.semiBold,
          color: highlighted ? AppColors.cFF006C6A : AppColors.black87,
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.data, required this.selectedPlan});

  final _FeatureRowData data;
  final int selectedPlan;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: MediaQueryUtil.spacing(8)),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              data.label,
              style: AppTextStyles.small(fontWeight: AppFontWeight.semi),
            ),
          ),
          Expanded(
            flex: 2,
            child: _FeatureCheck(
              included: data.basic,
              highlighted: selectedPlan == 0,
            ),
          ),
          Expanded(
            flex: 2,
            child: _FeatureCheck(
              included: data.standard,
              highlighted: selectedPlan == 1,
            ),
          ),
          Expanded(
            flex: 2,
            child: _FeatureCheck(
              included: data.premium,
              highlighted: selectedPlan == 2,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCheck extends StatelessWidget {
  const _FeatureCheck({required this.included, required this.highlighted});

  final bool included;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: MediaQueryUtil.spacing(2)),
      decoration: BoxDecoration(
        color: highlighted
            ? AppColors.cFFDFF3F1.withValues(alpha: 0.5)
            : AppColors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: included
          ? Icon(
              Icons.check_rounded,
              color: AppColors.cFF006C6A,
              size: MediaQueryUtil.iconSize(18),
            )
          : Icon(
              Icons.remove_rounded,
              color: AppColors.grey[400],
              size: MediaQueryUtil.iconSize(16),
            ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({required this.controller});

  final PremiumUpgradeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        MediaQueryUtil.spacing(16),
        MediaQueryUtil.spacing(12),
        MediaQueryUtil.spacing(16),
        MediaQueryUtil.spacing(10),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            if (!controller.profileDisplayController.isPremiumActive) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: EdgeInsets.only(bottom: MediaQueryUtil.spacing(10)),
              child: TextButton(
                onPressed: () => _showCancelPlanDialog(context),
                child: Text(
                  'Cancel plan',
                  style: AppTextStyles.regular(
                    color: AppColors.dangerRed,
                    fontWeight: AppFontWeight.semiBold,
                  ),
                ),
              ),
            );
          }),
          Obx(
            () => SizedBox(
              width: double.infinity,
              height: MediaQueryUtil.spacing(52),
              child: ElevatedButton(
                onPressed:
                    controller.selectedPlan.value == 0 ||
                        controller.isLoading.value
                    ? null
                    : controller.startCheckoutFlow,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      controller.selectedPlan.value == 0 ||
                          controller.isLoading.value
                      ? AppColors.grey[400]
                      : AppColors.cFF006C6A,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.white,
                          ),
                        ),
                      )
                    : Text(
                        controller.ctaText,
                        style: AppTextStyles.regular(
                          fontWeight: AppFontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(height: MediaQueryUtil.spacing(8)),
          Text(
            'Subscribe on www.stellapp.com to save 30%',
            textAlign: TextAlign.center,
            style: AppTextStyles.extraSmall(
              fontWeight: AppFontWeight.semiBold,
              color: AppColors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRowData {
  const _FeatureRowData(this.label, this.basic, this.standard, this.premium);

  final String label;
  final bool basic;
  final bool standard;
  final bool premium;
}

void _showCancelPlanDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(MediaQueryUtil.spacing(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sentiment_dissatisfied_outlined,
              size: MediaQueryUtil.iconSize(48),
              color: AppColors.grey[600],
            ),
            SizedBox(height: MediaQueryUtil.spacing(16)),
            Text(
              'Cancel plan?',
              style: AppTextStyles.regular(fontWeight: AppFontWeight.semiBold),
            ),
            SizedBox(height: MediaQueryUtil.spacing(8)),
            Text(
              "We're here whenever you get bored.",
              textAlign: TextAlign.center,
              style: AppTextStyles.small(color: AppColors.grey[600]),
            ),
            SizedBox(height: MediaQueryUtil.spacing(24)),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      _showConfirmCancellationDialog(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.black87,
                      side: BorderSide(color: AppColors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQueryUtil.spacing(12),
                      ),
                    ),
                    child: const Text('Continue'),
                  ),
                ),
                SizedBox(width: MediaQueryUtil.spacing(10)),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cFF006C6A,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQueryUtil.spacing(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Keep plan'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

void _showConfirmCancellationDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(MediaQueryUtil.spacing(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Confirm cancellation',
              style: AppTextStyles.regular(fontWeight: AppFontWeight.semiBold),
            ),
            SizedBox(height: MediaQueryUtil.spacing(8)),
            Text(
              'Just double checking',
              style: AppTextStyles.small(color: AppColors.grey[600]),
            ),
            SizedBox(height: MediaQueryUtil.spacing(24)),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  // Hook up subscription cancellation API when available.
                },
                child: Text(
                  'Cancel subscription',
                  style: AppTextStyles.regular(
                    color: AppColors.dangerRed,
                    fontWeight: AppFontWeight.semiBold,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  'Go back',
                  style: AppTextStyles.regular(
                    fontWeight: AppFontWeight.semiBold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

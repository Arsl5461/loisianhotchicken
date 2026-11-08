import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/design/bubba_icons.dart';
import '../../../../core/design/bubba_layout.dart';
import '../../../../core/design/bubba_text_styles.dart';
import '../../../../core/design/bubba_tokens.dart';

const double navTitleBaseline = 63.57;
const double navHairlineY = 82.82;
const double navChevronX = BubbaMetrics.backChevronX;
const double navChevronY = 48.26;
const double _chevronWidth = BubbaMetrics.backChevronWidth;
const double _chevronHeight = BubbaMetrics.backChevronHeight;
const double _chevronPad = 10.0;

class BubbaNavBar extends StatelessWidget {
  const BubbaNavBar({super.key, required this.title, this.onBack});

  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final metrics = bubbaDesignTextMetrics(context, BubbaText.navTitle);
    final titleTop = navTitleBaseline - metrics.baseline;
    final chevronBoxTop = navChevronY - _chevronPad;
    final rowTop = math.min(chevronBoxTop, titleTop);
    final side = navChevronX - _chevronPad;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: d(rowTop) + bubbaTopShift(context)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: dx(side)),
            Padding(
              padding: EdgeInsets.only(top: d(chevronBoxTop - rowTop)),
              child: BubbaTapTarget(
                onTap: onBack,
                label: 'Back',
                child: Padding(
                  padding: EdgeInsets.all(d(_chevronPad)),
                  child: const BubbaChevronLeft(
                    width: _chevronWidth,
                    height: _chevronHeight,
                    strokeWidth: 1.6,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: d(titleTop - rowTop)),
                child: Text(
                  title,
                  style: BubbaText.navTitle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(width: dx(side) + d(_chevronWidth + _chevronPad * 2)),
          ],
        ),
        SizedBox(
          height: math.max(
            0,
            d(navHairlineY - rowTop) -
                math.max(
                  d(chevronBoxTop - rowTop + _chevronHeight + _chevronPad * 2),
                  d(titleTop - rowTop + metrics.lineHeight),
                ),
          ),
        ),
        const BubbaHairline(
          color: Color(0xFFCBCBCB),
          width: double.infinity,
        ),
      ],
    );
  }
}

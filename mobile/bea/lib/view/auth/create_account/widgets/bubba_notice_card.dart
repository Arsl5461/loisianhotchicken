import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/design/bubba_layout.dart';
import '../../../../core/design/bubba_text_styles.dart';
import '../../../../core/design/bubba_tokens.dart';

class BubbaNoticeCard extends StatelessWidget {
  const BubbaNoticeCard({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  static const double height = 57.46;
  static const double designHeight = height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: d(height),
      decoration: BoxDecoration(
        color: BubbaColors.surface,
        borderRadius: BorderRadius.circular(d(BubbaMetrics.fieldRadius)),
        border: Border.all(
          color: BubbaColors.border,
          width: BubbaMetrics.borderWidth,
        ),
      ),
      child: Semantics(
        liveRegion: true,
        label: '$title $message',
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: d(15.5)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svg/bubba_clock.svg',
                width: d(17.6),
                height: d(17.6),
              ),
              SizedBox(width: hd(8.6)),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: BubbaText.noticeTitle),
                    SizedBox(height: d(2)),
                    Text(message, style: BubbaText.noticeMessage),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/typography/app_text_styles.dart';
import '../../../widgets/Buttons/customContinueButton.dart';
import '../../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class TermsAndGuidelinesPage extends StatefulWidget {
  const TermsAndGuidelinesPage({super.key});

  @override
  State<TermsAndGuidelinesPage> createState() => _TermsAndGuidelinesPageState();
}

class _TermsAndGuidelinesPageState extends State<TermsAndGuidelinesPage> {
  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background split: half white, half green
          Column(
            children: [
              Expanded(child: Container(color: Colors.white)),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFDFF7F2),
                        Color(0xFFDFF7F2),
                        Color(0xFFDFF7F2),
                        Color(0xFFDFF7F2),
                        Color.fromARGB(255, 145, 236, 228),
                        Color.fromARGB(255, 122, 246, 236),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Foreground content
          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: screenHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQueryUtil.spacing(20),
                    vertical: MediaQueryUtil.spacing(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: MediaQueryUtil.spacing(20)),

                      Text(
                        "Be kind and respectful",
                        style: AppTextStyles.large(
                          color: AppColors.darkGrey,
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(26)),

                      Text(
                        "Welcome to the club.",
                        style: AppTextStyles.small(
                          color: AppColors.darkGrey,
                          fontWeight: AppFontWeight.regular,
                        ),
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(20)),

                      Text(
                        "We started Oapp with the focused goal of making city life more fun. To do this, we believe that new people should be able to connect easily and quickly, maximizing the number of IRL experiences.",
                        style: AppTextStyles.small(
                          color: AppColors.darkGrey,
                          fontWeight: AppFontWeight.regular,
                        ),
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(26)),

                      Text(
                        "The issue with other dating apps today is that they don't sufficiently create urgency, filter for intention and relevance. There is too much room for overthinking.",
                        style: AppTextStyles.small(
                          color: AppColors.darkGrey,
                          fontWeight: AppFontWeight.regular,
                        ),
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(26)),

                      Text(
                        "By setting a 24 hour window to chat, we hope you meet more people, do more things, and that our community enjoys a more fulfilling dating experience. All we ask is that you treat everyone with kindness and respect while adhering to our safety guidelines.",
                        style: AppTextStyles.small(
                          color: AppColors.darkGrey,
                          fontWeight: AppFontWeight.regular,
                        ),
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(26)),

                      Text(
                        "Yours truly,\nThe Oapp team",
                        style: TextStyle(
                          fontSize: MediaQueryUtil.fontSize(14),
                          fontWeight: FontWeight.w400,
                          color: AppColors.black,
                        ),
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(100)),

                      Row(
                        children: [
                          Expanded(
                            child: CustomContinueButton(
                              onPressed: () {
                                debugPrint("Let's go pressed");
                                Get.toNamed(Routes.NAME_ASKING);
                              },
                              text: "Let's go",
                              backgroundColor: AppColors.white,
                              borderRadius: MediaQueryUtil.spacing(12),
                              textStyle: TextStyle(
                                fontSize: MediaQueryUtil.fontSize(16),
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          Spacer(),
                          SizedBox.shrink(),
                        ],
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(30)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

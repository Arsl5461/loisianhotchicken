import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/repositories/settings_repository.dart';
import '../../models/settings_models.dart';

import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_settings_tokens.dart';
import 'widgets/settings_card_list.dart';
import 'widgets/settings_chrome.dart';

const String _articleLorem =
    'Lorem ipsum dolor sit amet, consectetuer adipiscing\n'
    'elit, sed diam nonummy nibh euismod tincidunt ut\n'
    'laoreet dolore magna aliquam erat volutpat. Ut wisi\n'
    'enim ad minim veniam, quis nostrud exerci tation';

const String _lorem =
    'Lorem ipsum dolor sit amet, consectetuer adipiscing\n'
    'elit, sed diam nonummy nibh euismod tincidunt ut\n'
    'laoreet dolore magna aliquam erat volutpat. Ut wisi\n'
    'enim ad minim veniam, quis nos';

const Map<String, List<String>> _documentContents = {
  'Privacy Policy': [
    '1. We collect what’s needed',
    '2.  We never seell your data',
    '3.  You’re in control',
    '4.  We keep it secure',
  ],
  'Cookie Policy': [
    '1. What are cookies',
    '2.  What we use cookies for',
    '3.  Your choices',
    '4.  We respect your privacy',
  ],
  'Terms of Service': [
    '1. Eligibility',
    '2. How do time packs work',
    '3. How does travel mode ',
    '4. How to change my location',
    '5. How to delete my account',
    '6. Can i get a refund',
  ],
  'Community Guidelines': [
    '1. Be respectful',
    '2. Be authentic',
    '3. No inappropriate content',
    '4. No scams or spamming',
    '5. No advertising',
    '6. Follow the law',
  ],
};

List<String> _contentsOf(String document) =>
    _documentContents[document] ?? const <String>[];

const List<double> _contentsBaselines = [
  277.55,
  333.58,
  391.62,
  444.17,
  503.70,
  554.74,
];
const List<double> _contentsX = [48.46, 47.29, 48.79, 48.79, 48.79, 49.29];
const List<double> _contentsChevrons = [
  270.10,
  324.89,
  379.68,
  434.47,
  489.26,
  544.05,
];
const List<double> _contentsDividers = [
  302.15,
  357.65,
  413.15,
  468.65,
  524.15,
];

class SettingsDocSection {
  const SettingsDocSection({
    required this.title,
    required this.titleX,
    required this.titleBaseline,
    required this.bodyX,
    required this.bodyBaseline,
    this.body = _lorem,
  });

  final String title;
  final double titleX;
  final double titleBaseline;
  final double bodyX;
  final double bodyBaseline;
  final String body;

  SettingsDocSection withBody(String next) => SettingsDocSection(
        title: title,
        titleX: titleX,
        titleBaseline: titleBaseline,
        bodyX: bodyX,
        bodyBaseline: bodyBaseline,
        body: next,
      );

  SettingsDocSection withTitle(String next) => SettingsDocSection(
        title: next,
        titleX: titleX,
        titleBaseline: titleBaseline,
        bodyX: bodyX,
        bodyBaseline: bodyBaseline,
        body: body,
      );
}

class SettingsDocumentView extends StatelessWidget {
  const SettingsDocumentView({
    super.key,
    required this.navTitle,
    this.lastUpdated,
    this.intro,
    this.contentsTitle,
    this.contents = const [],
    this.cardHeight = 226.35,
    this.fullHeading,
    this.fullHeadingX,
    this.fullHeadingBaseline,
    this.sections = const [],
    this.onBack,
    this.onContents,
  });

  final String navTitle;
  final String? lastUpdated;
  final String? intro;
  final String? contentsTitle;
  final List<String> contents;
  final double cardHeight;
  final String? fullHeading;
  final double? fullHeadingX;
  final double? fullHeadingBaseline;
  final List<SettingsDocSection> sections;
  final VoidCallback? onBack;
  final ValueChanged<int>? onContents;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: BubbaSettingsColors.pageBg,
        body: BubbaPage(
          padContent: false,
          background: BubbaSettingsColors.pageBg,
          content: _content,
        ),
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.block(
      SettingsNavBar(title: navTitle, onBack: onBack),
      top: 0,
      height: BubbaSettingsMetrics.navHeight,
    );

    if (lastUpdated != null) {
      final labelMetrics =
          bubbaDesignTextMetrics(context, BubbaSettingsText.sectionLead);
      flow.block(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: hd(23.99)),
            Text('Last updated:', style: BubbaSettingsText.sectionLead),
            SizedBox(width: hd(121.39 - 23.99 - 84.5)),
            Text(lastUpdated!, style: BubbaSettingsText.docValue),
          ],
        ),
        top: 117.04 - labelMetrics.baseline,
        height: labelMetrics.lineHeight,
      );
    }

    if (intro != null) {
      final metrics =
          bubbaDesignTextMetrics(context, BubbaSettingsText.docIntro);
      flow.block(
        Row(
          children: [
            SizedBox(width: hd(23.99)),
            Text(intro!, style: BubbaSettingsText.docIntro),
          ],
        ),
        top: 148.91 - metrics.baseline,
        height: metrics.lineHeight * 2,
      );
    }

    if (contentsTitle != null) {
      settingsLead(context, flow, contentsTitle!, 24.91, 212.42, bold: true);
      final rows = <SettingsCardRow>[
        for (var i = 0; i < contents.length; i++)
          SettingsCardRow(
            title: contents[i],
            titleX: _contentsX[i],
            titleBaseline: _contentsBaselines[i],
            chevronX: 343.47,
            chevronY: _contentsChevrons[i],
            bandTop: i == 0 ? 240.15 : _contentsDividers[i - 1] + 1,
            bandBottom: i == contents.length - 1
                ? 240.15 + cardHeight
                : _contentsDividers[i],
            dividerX: i == contents.length - 1 ? null : 34.83,
            dividerY: i == contents.length - 1 ? null : _contentsDividers[i],
            dividerWidth: i == contents.length - 1 ? null : 318,
            onTap: onContents == null ? null : () => onContents!(i),
          ),
      ];
      flow.block(
        SettingsCardList(
          x: 18.67,
          y: 240.15,
          width: 354,
          height: cardHeight,
          fill: BubbaSettingsColors.pageBg,
          rows: rows,
        ),
        top: 240.15,
        height: cardHeight,
      );
    }

    if (fullHeading != null) {
      final metrics =
          bubbaDesignTextMetrics(context, BubbaSettingsText.docHeading);
      flow.block(
        Row(
          children: [
            SizedBox(width: hd(fullHeadingX!)),
            Text(fullHeading!, style: BubbaSettingsText.docHeading),
          ],
        ),
        top: fullHeadingBaseline! - metrics.baseline,
        height: metrics.lineHeight,
      );
    }

    final titleMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.docSectionTitle);
    final bodyMetrics = bubbaDesignTextMetrics(context, BubbaSettingsText.docBody);
    for (final section in sections) {
      flow.block(
        Row(
          children: [
            SizedBox(width: hd(section.titleX)),
            Text(section.title, style: BubbaSettingsText.docSectionTitle),
          ],
        ),
        top: section.titleBaseline - titleMetrics.baseline,
        height: titleMetrics.lineHeight,
      );
      flow.block(
        Row(
          children: [
            SizedBox(width: hd(section.bodyX)),
            Text(section.body, style: BubbaSettingsText.docBody),
          ],
        ),
        top: section.bodyBaseline - bodyMetrics.baseline,
        height: bodyMetrics.lineHeight * 4,
      );
    }
  }
}

const _twoSections = [
  SettingsDocSection(
    title: '1. Eligibility',
    titleX: 28.62,
    titleBaseline: 552.63,
    bodyX: 21.48,
    bodyBaseline: 579.85,
  ),
  SettingsDocSection(
    title: '1. Eligibility',
    titleX: 30.86,
    titleBaseline: 703.96,
    bodyX: 23.77,
    bodyBaseline: 731.18,
  ),
];

const _bodySections = [
  SettingsDocSection(
    title: '1. Eligibility',
    titleX: 31.68,
    titleBaseline: 145.36,
    bodyX: 24.54,
    bodyBaseline: 172.58,
  ),
  SettingsDocSection(
    title: '1. Eligibility',
    titleX: 33.92,
    titleBaseline: 296.69,
    bodyX: 26.84,
    bodyBaseline: 323.91,
  ),
  SettingsDocSection(
    title: '1. Eligibility',
    titleX: 38.69,
    titleBaseline: 436.19,
    bodyX: 31.74,
    bodyBaseline: 463.40,
  ),
];

class SettingsPrivacyPolicyView extends StatelessWidget {
  const SettingsPrivacyPolicyView({
    super.key,
    this.lastUpdated = 'June 10, 2026',
    this.onBack,
    this.onContents,
  });

  final String lastUpdated;
  final VoidCallback? onBack;
  final ValueChanged<int>? onContents;

  @override
  Widget build(BuildContext context) => SettingsDocumentView(
        navTitle: 'Privacy Policy',
        onBack: onBack,
        onContents: onContents,
        lastUpdated: lastUpdated,
        intro: 'These Privacy Policies govern the data we collect,\n'
            'why we collect it, and how you can control it.',
        contentsTitle: 'Privacy at a glance',
        contents: _documentContents['Privacy Policy']!,
        fullHeading: 'Full Privacy Policy',
        fullHeadingX: 23.27,
        fullHeadingBaseline: 505.29,
        sections: _twoSections,
      );
}

class SettingsCookiePolicyView extends StatelessWidget {
  const SettingsCookiePolicyView({
    super.key,
    this.lastUpdated = 'June 10, 2026',
    this.onBack,
    this.onContents,
  });

  final String lastUpdated;
  final VoidCallback? onBack;
  final ValueChanged<int>? onContents;

  @override
  Widget build(BuildContext context) => SettingsDocumentView(
        navTitle: 'Cookie Policy',
        onBack: onBack,
        onContents: onContents,
        lastUpdated: lastUpdated,
        intro: 'We use cookies and similar technologies\n'
            'to provide a better experience and improve our app.',
        contentsTitle: 'At a glance',
        contents: _documentContents['Cookie Policy']!,
        fullHeading: 'Full Cookie Policy',
        fullHeadingX: 24.44,
        fullHeadingBaseline: 505.29,
        sections: _twoSections,
      );
}

class SettingsTermsOfServiceView extends StatelessWidget {
  const SettingsTermsOfServiceView({
    super.key,
    this.lastUpdated = 'June 10, 2026',
    this.onBack,
    this.onContents,
  });

  final String lastUpdated;
  final VoidCallback? onBack;
  final ValueChanged<int>? onContents;

  @override
  Widget build(BuildContext context) => SettingsDocumentView(
        navTitle: 'Terms of Service',
        onBack: onBack,
        onContents: onContents,
        lastUpdated: lastUpdated,
        intro: 'These Terms of Service govern your\naccess to and use of Bea.',
        contentsTitle: 'Contents',
        cardHeight: 348,
        contents: _documentContents['Terms of Service']!,
        fullHeading: 'Full Terms of Service',
        fullHeadingX: 21.77,
        fullHeadingBaseline: 630.15,
        sections: const [
          SettingsDocSection(
            title: '1. Eligibility',
            titleX: 21.77,
            titleBaseline: 671.19,
            bodyX: 21.77,
            bodyBaseline: 698.40,
          ),
        ],
      );
}

class SettingsCommunityGuidelinesView extends StatelessWidget {
  const SettingsCommunityGuidelinesView({
    super.key,
    this.lastUpdated = 'June 10, 2026',
    this.onBack,
    this.onContents,
  });

  final String lastUpdated;
  final VoidCallback? onBack;
  final ValueChanged<int>? onContents;

  @override
  Widget build(BuildContext context) => SettingsDocumentView(
        navTitle: 'Community Guidelines',
        onBack: onBack,
        onContents: onContents,
        lastUpdated: lastUpdated,
        intro: 'Bubba is a place to connect authentically\n'
            'and treat others with respect.',
        contentsTitle: 'Contents',
        cardHeight: 348,
        contents: _documentContents['Community Guidelines']!,
      );
}

class SettingsPolicySectionView extends StatelessWidget {
  const SettingsPolicySectionView({
    super.key,
    required this.navTitle,
    this.sectionTitle,
    this.sectionBody,
    this.onBack,
  });

  final String navTitle;
  final String? sectionTitle;
  final String? sectionBody;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) => SettingsDocumentView(
        navTitle: navTitle,
        onBack: onBack,
        sections: sectionTitle == null
            ? _bodySections
            : [
                _bodySections.first
                    .withTitle(sectionTitle!)
                    .withBody(sectionBody ?? ''),
                ..._bodySections.skip(1).map((s) => s.withBody('')),
              ],
      );
}

class SettingsArticleView extends StatelessWidget {
  const SettingsArticleView({
    super.key,
    required this.navTitle,
    required this.heading,
    this.body = _articleLorem,
    this.onBack,
  });

  final String navTitle;
  final String heading;
  final String body;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: BubbaSettingsColors.pageBg,
        body: BubbaPage(
          padContent: false,
          background: BubbaSettingsColors.pageBg,
          content: (context, flow) {
            flow.block(
              SettingsNavBar(title: navTitle, onBack: onBack),
              top: 0,
              height: BubbaSettingsMetrics.navHeight,
            );
            settingsLead(context, flow, heading, 18.64, 110.77, bold: true);
            final metrics =
                bubbaDesignTextMetrics(context, BubbaSettingsText.docBody);
            flow.block(
              Row(
                children: [
                  SizedBox(width: hd(17.18)),
                  Text(body, style: BubbaSettingsText.docBody),
                ],
              ),
              top: 157.41 - metrics.baseline,
              height: metrics.lineHeight * 4,
            );
          },
        ),
      );
}

class SettingsLicensesView extends StatelessWidget {
  const SettingsLicensesView({super.key, this.titles, this.onBack, this.onLicense});

  final List<String>? titles;
  final VoidCallback? onBack;
  final ValueChanged<int>? onLicense;

  static const _rows = [
    SettingsCardRow(
      title: '1. Comapny 1',
      titleX: 45.62,
      titleBaseline: 238.83,
      chevronX: 340.64,
      chevronY: 231.39,
      bandTop: 201.44,
      bandBottom: 262.94,
      dividerX: 31.99,
      dividerY: 263.44,
      dividerWidth: 318,
    ),
    SettingsCardRow(
      title: '2.  Comapny 1',
      titleX: 44.45,
      titleBaseline: 294.87,
      chevronX: 340.64,
      chevronY: 286.18,
      bandTop: 264.44,
      bandBottom: 318.44,
      dividerX: 31.99,
      dividerY: 318.94,
      dividerWidth: 318,
    ),
    SettingsCardRow(
      title: '3.  Comapny 1',
      titleX: 45.95,
      titleBaseline: 352.91,
      chevronX: 340.64,
      chevronY: 340.97,
      bandTop: 319.94,
      bandBottom: 373.94,
      dividerX: 31.99,
      dividerY: 374.44,
      dividerWidth: 318,
    ),
    SettingsCardRow(
      title: '4.  Comapny 1',
      titleX: 45.95,
      titleBaseline: 405.45,
      chevronX: 340.64,
      chevronY: 395.75,
      bandTop: 375.44,
      bandBottom: 427.79,
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: BubbaSettingsColors.pageBg,
        body: BubbaPage(
          padContent: false,
          background: BubbaSettingsColors.pageBg,
          content: (context, flow) {
            flow.block(
              SettingsNavBar(title: 'Licenses', onBack: onBack),
              top: 0,
              height: BubbaSettingsMetrics.navHeight,
            );
            final metrics =
                bubbaDesignTextMetrics(context, BubbaSettingsText.lead);
            flow.block(
              Row(
                children: [
                  SizedBox(width: hd(22.58)),
                  Text(
                    'Bubba is built in-part with open source software.\n'
                    'We’re grateful to the community.',
                    style: BubbaSettingsText.lead.copyWith(height: 21 / 14),
                  ),
                ],
              ),
              top: 116.21 - metrics.baseline,
              height: 21 * 2,
            );
            settingsLead(
              context,
              flow,
              'Third-party licenses',
              20.64,
              179.77,
              bold: true,
            );
            flow.block(
              SettingsCardList(
                x: 15.83,
                y: 201.44,
                width: 354,
                height: 226.35,
                fill: BubbaSettingsColors.pageBg,
                rows: [
                  for (var i = 0; i < _rows.length; i++)
                    _rows[i].copyWith(
                      title: titles != null && i < titles!.length
                          ? titles![i]
                          : _rows[i].title,
                      onTap: onLicense == null ? null : () => onLicense!(i),
                    ),
                ],
              ),
              top: 201.44,
              height: 226.35,
            );
          },
        ),
      );
}

class BubbaLicensesScreen extends StatefulWidget {
  const BubbaLicensesScreen({super.key});

  @override
  State<BubbaLicensesScreen> createState() => _BubbaLicensesScreenState();
}

class _BubbaLicensesScreenState extends State<BubbaLicensesScreen> {
  final Map<String, StringBuffer> _licenses = {};
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await for (final entry in LicenseRegistry.licenses) {
      for (final package in entry.packages) {
        final buffer = _licenses.putIfAbsent(package, StringBuffer.new);
        for (final paragraph in entry.paragraphs) {
          buffer.writeln(paragraph.text.trim());
        }
      }
    }
    if (!mounted) return;
    setState(() => _loaded = true);
  }

  List<String> get _names {
    final names = _licenses.keys.toList()..sort();
    return names;
  }

  @override
  Widget build(BuildContext context) {
    final names = _names;
    return SettingsLicensesView(
      titles: _loaded && names.isNotEmpty
          ? [
              for (var i = 0; i < 4 && i < names.length; i++)
                '${i + 1}. ${names[i]}',
            ]
          : null,
      onBack: Get.back,
      onLicense: !_loaded || names.isEmpty
          ? null
          : (index) {
              if (index >= names.length) return;
              final package = names[index];
              Get.to(
                () => SettingsArticleView(
                  navTitle: 'Licenses',
                  heading: package,
                  body: _licenses[package]!.toString().trim(),
                  onBack: Get.back,
                ),
              );
            },
    );
  }
}

class _LegalDocument extends StatefulWidget {
  const _LegalDocument({required this.slug, required this.builder});

  final String slug;
  final Widget Function(LegalDocument? document) builder;

  @override
  State<_LegalDocument> createState() => _LegalDocumentState();
}

class _LegalDocumentState extends State<_LegalDocument> {
  LegalDocument? _document;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result =
        await Get.find<SettingsRepository>().fetchLegalDocument(widget.slug);
    if (!mounted || !result.isSuccess) return;
    setState(() => _document = result.value);
  }

  @override
  Widget build(BuildContext context) => widget.builder(_document);
}

Widget _sectionRoute(String navTitle, String sectionTitle, LegalDocument? doc) {
  final match = doc?.sections.firstWhere(
    (s) => s.title.trim().toLowerCase() == sectionTitle.trim().toLowerCase(),
    orElse: () => const HelpArticle(title: '', body: ''),
  );
  return SettingsPolicySectionView(
    navTitle: navTitle,
    sectionTitle: sectionTitle,
    sectionBody: match == null || match.body.isEmpty ? null : match.body,
    onBack: Get.back,
  );
}

class BubbaPrivacyPolicyScreen extends StatelessWidget {
  const BubbaPrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) => _LegalDocument(
        slug: 'privacy-policy',
        builder: (doc) => SettingsPrivacyPolicyView(
          lastUpdated: doc?.lastUpdated ?? '',
          onBack: Get.back,
          onContents: (index) => Get.to(
            () => _sectionRoute(
              'Privacy Policy',
              _contentsOf('Privacy Policy')[index],
              doc,
            ),
          ),
        ),
      );
}

class BubbaTermsOfServiceScreen extends StatelessWidget {
  const BubbaTermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) => _LegalDocument(
        slug: 'terms-of-service',
        builder: (doc) => SettingsTermsOfServiceView(
          lastUpdated: doc?.lastUpdated ?? '',
          onBack: Get.back,
          onContents: (index) => Get.to(
            () => _sectionRoute(
              'Terms of Service',
              _contentsOf('Terms of Service')[index],
              doc,
            ),
          ),
        ),
      );
}

class BubbaCommunityGuidelinesScreen extends StatelessWidget {
  const BubbaCommunityGuidelinesScreen({super.key});

  @override
  Widget build(BuildContext context) => _LegalDocument(
        slug: 'community-guidelines',
        builder: (doc) => SettingsCommunityGuidelinesView(
          lastUpdated: doc?.lastUpdated ?? '',
          onBack: Get.back,
          onContents: (index) => Get.to(
            () => _sectionRoute(
              'Community Guidelines',
              _contentsOf('Community Guidelines')[index],
              doc,
            ),
          ),
        ),
      );
}

class BubbaCookiePolicyScreen extends StatelessWidget {
  const BubbaCookiePolicyScreen({super.key});

  @override
  Widget build(BuildContext context) => _LegalDocument(
        slug: 'cookie-policy',
        builder: (doc) => SettingsCookiePolicyView(
          lastUpdated: doc?.lastUpdated ?? '',
          onBack: Get.back,
          onContents: (index) => Get.to(
            () => _sectionRoute(
              'Cookie Policy',
              _contentsOf('Cookie Policy')[index],
              doc,
            ),
          ),
        ),
      );
}

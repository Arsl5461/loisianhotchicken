import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_settings_tokens.dart';
import '../../data/repositories/settings_repository.dart';
import '../../models/settings_models.dart';
import 'widgets/settings_card_list.dart';
import 'widgets/settings_chrome.dart';

const String _placeholderBody =
    'Lorem ipsum dolor sit amet, consectetuer adipiscing\n'
    'elit, sed diam nonummy nibh euismod tincidunt ut\n'
    'laoreet dolore magna aliquam erat volutpat. Ut wisi\n'
    'enim ad minim veniam, quis nostrud exerci tation';

const List<double> _collapsedBaselines = [359.94, 417.98, 470.51, 530.05, 581.09];
const List<double> _collapsedChevrons = [351.24, 406.03, 460.82, 515.61, 570.40];
const List<double> _collapsedDividers = [384.00, 439.50, 495.00, 550.50];
const List<double> _collapsedX = [43.01, 44.51, 44.51, 44.51, 45.01];

List<SettingsAccordionRow> accordionRows(
  List<String> titles, {
  String body = _placeholderBody,
}) {
  final rows = <SettingsAccordionRow>[
    SettingsAccordionRow(
      title: titles.first,
      titleX: 44.18,
      titleBaseline: 210.90,
      chevronY: 205.75,
      bandTop: 173.50,
      bandBottom: 328.00,
      dividerY: 328.50,
      body: body,
    ),
  ];
  for (var i = 1; i < titles.length; i++) {
    final last = i == titles.length - 1;
    rows.add(
      SettingsAccordionRow(
        title: titles[i],
        titleX: _collapsedX[i - 1],
        titleBaseline: _collapsedBaselines[i - 1],
        chevronY: _collapsedChevrons[i - 1],
        bandTop: i == 1 ? 329.00 : _collapsedDividers[i - 2] + 1,
        bandBottom: last
            ? _collapsedBaselines[i - 1] + 23
            : _collapsedDividers[i - 1],
        dividerY: last ? null : _collapsedDividers[i - 1],
      ),
    );
  }
  return rows;
}

class SettingsAccordionView extends StatefulWidget {
  const SettingsAccordionView({
    super.key,
    required this.navTitle,
    required this.lead,
    required this.titles,
    required this.cardHeight,
    this.bodies,
    this.initialExpanded = 0,
    this.onBack,
  });

  final String navTitle;
  final String lead;
  final List<String> titles;
  final double cardHeight;

  final List<String>? bodies;
  final int initialExpanded;
  final VoidCallback? onBack;

  @override
  State<SettingsAccordionView> createState() => _SettingsAccordionViewState();
}

class _SettingsAccordionViewState extends State<SettingsAccordionView> {
  late int _expanded = widget.initialExpanded;

  @override
  void didUpdateWidget(SettingsAccordionView old) {
    super.didUpdateWidget(old);
    if (old.initialExpanded != widget.initialExpanded) {
      _expanded = widget.initialExpanded;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: BubbaSettingsColors.pageBg,
        body: BubbaPage(
          padContent: false,
          background: BubbaSettingsColors.pageBg,
          content: (context, flow) {
            flow.block(
              SettingsNavBar(title: widget.navTitle, onBack: widget.onBack),
              top: 0,
              height: BubbaSettingsMetrics.navHeight,
            );
            settingsLead(context, flow, widget.lead, 20.64, 145.77, bold: true);
            flow.block(
              SettingsAccordionCard(
                x: 14.40,
                y: 173.50,
                width: 354,
                height: widget.cardHeight,
                rows: accordionRows(
                  widget.titles,
                  body: widget.bodies == null
                      ? _placeholderBody
                      : (_expanded < widget.bodies!.length
                          ? widget.bodies![_expanded]
                          : ''),
                ),
                expanded: _expanded,
                onToggle: (i) => setState(() => _expanded = i),
              ),
              top: 173.50,
              height: widget.cardHeight,
            );
          },
        ),
      );
}

class SettingsFaqExpandedView extends StatelessWidget {
  const SettingsFaqExpandedView({
    super.key,
    this.bodies,
    this.initialExpanded = 0,
    this.onBack,
  });

  final List<String>? bodies;
  final int initialExpanded;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) => SettingsAccordionView(
        navTitle: 'FAQ',
        lead: 'Popular topics',
        cardHeight: 434,
        bodies: bodies,
        initialExpanded: initialExpanded,
        onBack: onBack,
        titles: BubbaFaqExpandedScreen.titles,
      );
}

class SettingsSafetyTipsView extends StatelessWidget {
  const SettingsSafetyTipsView({
    super.key,
    this.bodies,
    this.initialExpanded = 0,
    this.onBack,
  });

  final List<String>? bodies;
  final int initialExpanded;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) => SettingsAccordionView(
        navTitle: 'Safety Tips',
        lead: 'Simple advice',
        cardHeight: 380,
        bodies: bodies,
        initialExpanded: initialExpanded,
        onBack: onBack,
        titles: BubbaSafetyTipsScreen.titles,
      );
}

class SettingsProtectInformationView extends StatelessWidget {
  const SettingsProtectInformationView({
    super.key,
    this.bodies,
    this.initialExpanded = 0,
    this.onBack,
  });

  final List<String>? bodies;
  final int initialExpanded;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) => SettingsAccordionView(
        navTitle: 'Protect Your Information',
        lead: 'Things to look out for',
        cardHeight: 380,
        bodies: bodies,
        initialExpanded: initialExpanded,
        onBack: onBack,
        titles: BubbaProtectInformationScreen.titles,
      );
}

class _HelpArticles extends StatefulWidget {
  const _HelpArticles({
    required this.collection,
    required this.titles,
    required this.builder,
  });

  final String collection;
  final List<String> titles;
  final Widget Function(List<String>? bodies, int initialExpanded) builder;

  @override
  State<_HelpArticles> createState() => _HelpArticlesState();
}

class _HelpArticlesState extends State<_HelpArticles> {
  List<String>? _bodies;

  int get _initialExpanded {
    final args = Get.arguments;
    final asked = args is Map ? args['question'] ?? args['topic'] : null;
    if (asked is! String) return 0;
    final index = widget.titles.indexWhere(
      (t) => t.trim().toLowerCase() == asked.trim().toLowerCase(),
    );
    return index < 0 ? 0 : index;
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result =
        await Get.find<SettingsRepository>().fetchHelpArticles(widget.collection);
    if (!mounted || !result.isSuccess) return;
    final articles = result.value!;
    setState(() {
      _bodies = [
        for (final title in widget.titles)
          articles
              .firstWhere(
                (a) => a.title.trim().toLowerCase() == title.trim().toLowerCase(),
                orElse: () => const HelpArticle(title: '', body: ''),
              )
              .body,
      ];
    });
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(_bodies, _initialExpanded);
}

class BubbaFaqExpandedScreen extends StatelessWidget {
  const BubbaFaqExpandedScreen({super.key});

  static const List<String> titles = [
    'How does membership work',
    'How do time packs work',
    'How does travel mode work',
    'How to change my location',
    'How to delete my account',
    'Can i get a refund',
  ];

  @override
  Widget build(BuildContext context) => _HelpArticles(
        collection: 'faq',
        titles: titles,
        builder: (bodies, expanded) => SettingsFaqExpandedView(
          bodies: bodies,
          initialExpanded: expanded,
          onBack: Get.back,
        ),
      );
}

class BubbaSafetyTipsScreen extends StatelessWidget {
  const BubbaSafetyTipsScreen({super.key});

  static const List<String> titles = [
    'Before you meet',
    'Meeting in person',
    'Protect your privacy',
    'Trust your instincts',
    'Need immediate help?',
  ];

  @override
  Widget build(BuildContext context) => _HelpArticles(
        collection: 'safety-tips',
        titles: titles,
        builder: (bodies, expanded) => SettingsSafetyTipsView(
          bodies: bodies,
          initialExpanded: expanded,
          onBack: Get.back,
        ),
      );
}

class BubbaProtectInformationScreen extends StatelessWidget {
  const BubbaProtectInformationScreen({super.key});

  static const List<String> titles = [
    'Don’t share too soon ',
    'Keep conversations in Bubba',
    'Beware of verification scams',
    'Never send money',
    'Trust your instincts',
  ];

  @override
  Widget build(BuildContext context) => _HelpArticles(
        collection: 'protect-information',
        titles: titles,
        builder: (bodies, expanded) => SettingsProtectInformationView(
          bodies: bodies,
          initialExpanded: expanded,
          onBack: Get.back,
        ),
      );
}

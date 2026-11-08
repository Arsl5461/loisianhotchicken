import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_settings_tokens.dart';
import '../../data/repositories/settings_repository.dart';
import 'settings_feedback.dart';
import 'widgets/settings_chrome.dart';

class SettingsEmergencyResource {
  const SettingsEmergencyResource({
    required this.title,
    required this.titleX,
    required this.titleBaseline,
    required this.detail,
    required this.detailX,
    required this.detailBaseline,
    required this.bandTop,
    required this.bandBottom,
    this.dividerY,
  });

  final String title;
  final double titleX;
  final double titleBaseline;
  final String detail;
  final double detailX;
  final double detailBaseline;
  final double bandTop;
  final double bandBottom;
  final double? dividerY;

  SettingsEmergencyResource withContent(String nextTitle, String nextDetail) =>
      SettingsEmergencyResource(
        title: nextTitle.isEmpty ? title : nextTitle,
        titleX: titleX,
        titleBaseline: titleBaseline,
        detail: nextDetail.isEmpty ? detail : nextDetail,
        detailX: detailX,
        detailBaseline: detailBaseline,
        bandTop: bandTop,
        bandBottom: bandBottom,
        dividerY: dividerY,
      );
}

const _resources = [
  SettingsEmergencyResource(
    title: 'National Domestic Violence Hotline',
    titleX: 36.29,
    titleBaseline: 298.02,
    detail: '1-800-799-7233',
    detailX: 37.59,
    detailBaseline: 323.44,
    bandTop: 260.55,
    bandBottom: 340.31,
    dividerY: 340.81,
  ),
  SettingsEmergencyResource(
    title: 'Crisis Text Line',
    titleX: 34.75,
    titleBaseline: 371.71,
    detail: 'Text HOME to 741741',
    detailX: 36.05,
    detailBaseline: 397.14,
    bandTop: 341.31,
    bandBottom: 414.00,
    dividerY: 414.50,
  ),
  SettingsEmergencyResource(
    title: 'Local Emergency Services',
    titleX: 33.75,
    titleBaseline: 442.71,
    detail: 'Call 911',
    detailX: 35.05,
    detailBaseline: 468.14,
    bandTop: 415.00,
    bandBottom: 485.00,
    dividerY: 485.50,
  ),
  SettingsEmergencyResource(
    title: 'Find Local Support',
    titleX: 34.04,
    titleBaseline: 513.91,
    detail: 'Search for support in your area',
    detailX: 35.34,
    detailBaseline: 539.34,
    bandTop: 486.00,
    bandBottom: 566.55,
  ),
];

class SettingsEmergencyResourcesView extends StatelessWidget {
  const SettingsEmergencyResourcesView({
    super.key,
    this.onBack,
    this.onResource,
    this.tabIndex = 0,
    this.onTab,
    this.resources,
  });

  final VoidCallback? onBack;
  final ValueChanged<int>? onResource;
  final int tabIndex;
  final ValueChanged<int>? onTab;
  final List<SettingsEmergencyResource>? resources;

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
      SettingsNavBar(title: 'Emergency Resources', onBack: onBack),
      top: 0,
      height: BubbaSettingsMetrics.navHeight,
    );

    flow.block(const _Banner(), top: 94, height: 87);
    flow.block(_Tabs(index: tabIndex, onTab: onTab), top: 200, height: 40);

    final titleMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.cardRowTitle);
    final detailMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.cardRowSubtitleLarge);

    Widget at(double left, double top, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: hd(left - 17.56), top: d(top - 260.55)),
            child: child,
          ),
        );

    final layers = <Widget>[];
    final rows = resources ?? _resources;
    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      layers.add(
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(top: d(row.bandTop - 260.55)),
            child: Semantics(
              button: true,
              label: row.title,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onResource == null ? null : () => onResource!(i),
                child: SizedBox(
                  width: hd(354),
                  height: d(row.bandBottom - row.bandTop),
                ),
              ),
            ),
          ),
        ),
      );
      layers.add(at(
        row.titleX,
        row.titleBaseline - titleMetrics.baseline,
        Text(row.title, style: BubbaSettingsText.cardRowTitle),
      ));
      layers.add(at(
        row.detailX,
        row.detailBaseline - detailMetrics.baseline,
        Text(row.detail, style: BubbaSettingsText.cardRowSubtitleLarge),
      ));
      if (row.dividerY != null) {
        layers.add(at(
          31.20,
          row.dividerY! - BubbaSettingsMetrics.dividerWeight / 2,
          SizedBox(
            width: hd(318),
            height: d(BubbaSettingsMetrics.dividerWeight),
            child: const BubbaHairline(color: BubbaSettingsColors.divider),
          ),
        ));
      }
    }

    flow.block(
      Row(
        children: [
          SizedBox(width: hd(17.56)),
          Container(
            width: hd(354),
            height: d(306),
            decoration: BoxDecoration(
              color: BubbaSettingsColors.pageBg,
              border: Border.all(
                color: BubbaSettingsColors.cardBorder,
                width: d(BubbaSettingsMetrics.dividerWeight),
              ),
              borderRadius:
                  BorderRadius.circular(d(BubbaSettingsMetrics.cardRadius)),
            ),
            child: Stack(children: layers),
          ),
        ],
      ),
      top: 260.55,
      height: 306,
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner();

  @override
  Widget build(BuildContext context) {
    final titleMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.sectionLead);
    final bodyMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.bannerBody);
    return Row(
      children: [
        SizedBox(width: hd(17.53)),
        Container(
          width: hd(348),
          height: d(87),
          decoration: BoxDecoration(
            color: BubbaSettingsColors.bannerBg,
            borderRadius: BorderRadius.circular(d(13.23)),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: hd(85.77 - 17.53),
                    top: d(124.59 - 94 - titleMetrics.baseline),
                  ),
                  child: Text(
                    'Local and global resources',
                    style: BubbaSettingsText.sectionLead,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: hd(85.91 - 17.53),
                    top: d(148.45 - 94 - bodyMetrics.baseline),
                  ),
                  child: Text(
                    'Get help from organizations\nthat are here for you',
                    style: BubbaSettingsText.bannerBody,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.index, this.onTab});

  final int index;
  final ValueChanged<int>? onTab;

  @override
  Widget build(BuildContext context) {
    final metrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.sectionLead);
    Widget label(String text, double x, double baseline, bool active, int i) =>
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: hd(x - 21.53),
              top: d(baseline - 200 - metrics.baseline),
            ),
            child: Semantics(
              button: true,
              selected: active,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTab == null ? null : () => onTab!(i),
                child: Text(
                  text,
                  style: active
                      ? BubbaSettingsText.sectionLead
                          .copyWith(color: BubbaSettingsColors.tabActive)
                      : BubbaSettingsText.sectionLead,
                ),
              ),
            ),
          ),
        );

    return Row(
      children: [
        SizedBox(width: hd(21.53)),
        SizedBox(
          width: hd(344),
          height: d(40),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: d(237 - 200 - 0.5)),
                  child: SizedBox(
                    width: hd(344),
                    height: d(1),
                    child: const BubbaHairline(
                      color: BubbaSettingsColors.infoCardBorder,
                    ),
                  ),
                ),
              ),
              label('Local', 75.25, 225.86, index == 0, 0),
              label('Local', 229.23, 222.45, index == 1, 1),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: hd(index == 0 ? 0 : 157),
                    top: d(236 - 200 - 1),
                  ),
                  child: SizedBox(
                    width: hd(157),
                    height: d(2),
                    child: const BubbaHairline(
                      color: BubbaSettingsColors.tabUnderline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BubbaEmergencyResourcesScreen extends StatefulWidget {
  const BubbaEmergencyResourcesScreen({super.key});

  @override
  State<BubbaEmergencyResourcesScreen> createState() =>
      _BubbaEmergencyResourcesScreenState();
}

class _BubbaEmergencyResourcesScreenState
    extends State<BubbaEmergencyResourcesScreen> {
  static const List<String> _collections = [
    'emergency-resources',
    'emergency-resources-global',
  ];

  int _tab = 0;
  final Map<int, List<SettingsEmergencyResource>> _loaded = {};

  @override
  void initState() {
    super.initState();
    _load(0);
  }

  Future<void> _load(int tab) async {
    if (_loaded.containsKey(tab)) return;
    final result = await Get.find<SettingsRepository>()
        .fetchHelpArticles(_collections[tab]);
    if (!mounted || !result.isSuccess) return;
    final articles = result.value!;
    if (articles.isEmpty) return;
    setState(() {
      _loaded[tab] = [
        for (var i = 0; i < _resources.length; i++)
          i < articles.length
              ? _resources[i].withContent(articles[i].title, articles[i].body)
              : _resources[i].withContent('', ''),
      ];
    });
  }

  List<SettingsEmergencyResource> get _rows => _loaded[_tab] ?? _resources;

  Future<void> _open(int index) async {
    final resource = _rows[index];
    final detail = resource.detail;
    final digits = RegExp(r'[0-9]{3,}').allMatches(detail).map((m) => m.group(0)!);
    final Uri target;
    if (detail.toLowerCase().startsWith('text ')) {
      final shortCode = digits.isEmpty ? '' : digits.last;
      final keyword = detail.split(RegExp(r'\s+'))[1];
      target = Uri(
        scheme: 'sms',
        path: shortCode,
        queryParameters: {'body': keyword},
      );
    } else if (digits.isNotEmpty) {
      target = Uri(scheme: 'tel', path: detail.replaceAll(RegExp(r'[^0-9+]'), ''));
    } else {
      target = Uri.https('www.google.com', '/search', {
        'q': '${resource.title} near me',
      });
    }
    final ok = await launchUrl(target, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      showSettingsError('Could not open $detail on this device.');
    }
  }

  @override
  Widget build(BuildContext context) => SettingsEmergencyResourcesView(
        onBack: Get.back,
        tabIndex: _tab,
        onTab: (i) {
          setState(() => _tab = i);
          _load(i);
        },
        onResource: _open,
        resources: _loaded[_tab],
      );
}

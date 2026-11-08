import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/repositories/settings_repository.dart';
import '../../core/design/bubba_glyphs.dart';
import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_settings_glyphs.dart';
import '../../core/design/bubba_settings_tokens.dart';
import 'settings_feedback.dart';
import 'widgets/settings_card_list.dart';
import 'widgets/settings_chrome.dart';
import 'widgets/settings_confirm_scaffold.dart';

const double _fieldX = 17.51;
const double _fieldY = 198.50;
const double _fieldW = 354;
const double _fieldH = 247;
const double _placeholderX = 44.54;
const double _placeholderBaseline = 239.18;
const double _counterX = 307.08;
const double _counterBaseline = 432.52;
const double _tileSize = 105.93;
const double _tileRadius = 15.78;
const List<double> _tileX = [26.12, 144.13, 262.40];
const List<double> _tileY = [538.49, 538.06, 538.96];

class SettingsTechnicalIssueView extends StatelessWidget {
  const SettingsTechnicalIssueView({
    super.key,
    this.controller,
    this.characters = 0,
    this.onBack,
    this.onCancel,
    this.onSubmit,
    this.onAddScreenshot,
    this.screenshots = const [null, null, null],
  });

  final TextEditingController? controller;
  final int characters;
  final VoidCallback? onBack;
  final VoidCallback? onCancel;
  final VoidCallback? onSubmit;
  final ValueChanged<int>? onAddScreenshot;
  final List<ImageProvider?> screenshots;

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
      SettingsNavBar(title: 'Technical Issue', onBack: onBack),
      top: 0,
      height: BubbaSettingsMetrics.navHeight,
    );
    settingsLead(context, flow, 'Describe the issue', 18.64, 110.77, bold: true);

    final subMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.pageSubtitle);
    flow.block(
      Row(
        children: [
          SizedBox(width: hd(19.64)),
          Text(
            'Please provide as much detail as\n'
            'possible so we can help you faster.',
            style: BubbaSettingsText.pageSubtitle,
          ),
        ],
      ),
      top: 142.63 - subMetrics.baseline,
      height: subMetrics.lineHeight * 2,
    );

    flow.block(
      _IssueField(controller: controller, characters: characters),
      top: _fieldY,
      height: _fieldH,
    );

    final labelMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.sectionLead);
    flow.block(
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: hd(24.06)),
          Text('Add screenshots ', style: BubbaSettingsText.sectionLead),
          Text('(optional)', style: BubbaSettingsText.docValue),
        ],
      ),
      top: 481.59 - labelMetrics.baseline,
      height: labelMetrics.lineHeight,
    );
    settingsLead(
      context,
      flow,
      'This helps us understand the issue',
      24.06,
      513.46,
    );

    flow.block(
      _ScreenshotRow(onAdd: onAddScreenshot, shots: screenshots),
      top: _tileY[1],
      height: _tileSize + 1,
    );

    flow.block(
      SettingsCtaButton(
        label: 'Submit',
        fill: BubbaSettingsColors.rowLabel,
        onTap: onSubmit,
      ),
      top: 688,
      height: 58,
    );

    final cancelMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.cancelLabel);
    final cancelBox =
        BubbaScale.tapBox(d(cancelMetrics.lineHeight)) / BubbaScale.factor;
    flow.block(
      SettingsCancelLink(onTap: onCancel),
      top: 775.58 - cancelMetrics.baseline - (cancelBox - cancelMetrics.lineHeight) / 2,
      height: cancelBox,
    );
  }
}

class _IssueField extends StatelessWidget {
  const _IssueField({this.controller, required this.characters});

  final TextEditingController? controller;
  final int characters;

  @override
  Widget build(BuildContext context) {
    final metrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.issuePlaceholder);
    final counterMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.issuePlaceholder);
    return Row(
      children: [
        SizedBox(width: hd(_fieldX)),
        Container(
          width: hd(_fieldW),
          height: d(_fieldH),
          decoration: BoxDecoration(
            color: BubbaSettingsColors.pageBg,
            border: Border.all(
              color: BubbaSettingsColors.cardBorder,
              width: d(BubbaSettingsMetrics.dividerWeight),
            ),
            borderRadius:
                BorderRadius.circular(d(BubbaSettingsMetrics.cardRadius)),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: hd(_placeholderX - _fieldX),
                    top: d(_placeholderBaseline - _fieldY - metrics.baseline),
                  ),
                  child: SizedBox(
                    width: hd(_fieldW - (_placeholderX - _fieldX) - 20),
                    height: d(160),
                    child: controller == null
                        ? Text(
                            'What’s going on?\n'
                            'Include any error message or\n'
                            'what you were trying to do.',
                            style: BubbaSettingsText.issuePlaceholder,
                          )
                        : _IssueInput(controller: controller!),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: hd(_counterX - _fieldX),
                    top: d(_counterBaseline - _fieldY - counterMetrics.baseline),
                  ),
                  child: Text(
                    '$characters/1000',
                    style: BubbaSettingsText.issuePlaceholder,
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

class _IssueInput extends StatelessWidget {
  const _IssueInput({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, _) => Stack(
          children: [
            if (value.text.isEmpty)
              Text(
                'What’s going on?\n'
                'Include any error message or\n'
                'what you were trying to do.',
                style: BubbaSettingsText.issuePlaceholder,
              ),
            TextField(
              controller: controller,
              maxLines: null,
              maxLength: 1000,
              style: BubbaSettingsText.issuePlaceholder
                  .copyWith(color: BubbaSettingsColors.rowLabel),
              cursorColor: BubbaSettingsColors.rowLabel,
              decoration: null,
            ),
          ],
        ),
      );
}

class _ScreenshotRow extends StatelessWidget {
  const _ScreenshotRow({this.onAdd, this.shots = const [null, null, null]});

  final ValueChanged<int>? onAdd;
  final List<ImageProvider?> shots;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < 3; i++) ...[
            SizedBox(
              width: hd(i == 0 ? _tileX[0] : _tileX[i] - _tileX[i - 1] - _tileSize),
            ),
            Padding(
              padding: EdgeInsets.only(top: d(_tileY[i] - _tileY[1])),
              child: Semantics(
                button: true,
                label: 'Add screenshot ${i + 1}',
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onAdd == null ? null : () => onAdd!(i),
                  child: Container(
                    width: d(_tileSize),
                    height: d(_tileSize),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: BubbaSettingsColors.uploadBorder,
                        width: d(BubbaSettingsMetrics.dividerWeight),
                      ),
                      borderRadius: BorderRadius.circular(d(_tileRadius)),
                    ),
                    child: i < shots.length && shots[i] != null
                        ? ClipRRect(
                            borderRadius:
                                BorderRadius.circular(d(_tileRadius)),
                            child: Image(
                              image: shots[i]!,
                              width: d(_tileSize),
                              height: d(_tileSize),
                              fit: BoxFit.cover,
                            ),
                          )
                        : Center(
                            child: SizedBox(
                              width: d(17.80),
                              height: d(17.79),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: d(1.74),
                                    height: d(17.79),
                                    color: BubbaSettingsColors.uploadPlus,
                                  ),
                                  Container(
                                    width: d(17.80),
                                    height: d(1.74),
                                    color: BubbaSettingsColors.uploadPlus,
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ],
      );
}

class SettingsReportSubmittedView extends StatelessWidget {
  const SettingsReportSubmittedView({super.key, this.onBack, this.onDone});

  final VoidCallback? onBack;
  final VoidCallback? onDone;

  static const _items = [
    ('We typically respond within 14 days', 68.86, 515.28, 43.53, 505.21),
    ('You’ll get an email update', 70.26, 547.73, 44.93, 537.67),
    ('You can view your request in \nyour inbox', 70.26, 578.73, 44.93, 568.67),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: BubbaSettingsColors.pageBg,
        body: BubbaPage(
          padContent: false,
          background: BubbaSettingsColors.pageBg,
          content: (context, flow) {
            flow.block(
              SettingsNavBar(title: 'Report Submitted', onBack: onBack),
              top: 0,
              height: BubbaSettingsMetrics.navHeight,
            );

            flow.block(
              Row(
                children: [
                  SizedBox(width: hd(150.07)),
                  SizedBox(
                    width: d(76),
                    height: d(76),
                    child: Stack(
                      children: [
                        Container(
                          width: d(76),
                          height: d(76),
                          decoration: const BoxDecoration(
                            color: BubbaSettingsColors.successCircle,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: hd(172.72 - 150.07),
                              top: d(216.92 - 190),
                            ),
                            child: const BubbaGlyphIcon(
                              BubbaSettingsGlyphs.successCheck,
                              color: BubbaSettingsColors.successMark,
                              width: 30.69,
                              height: 22.17,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              top: 190,
              height: 76,
            );

            final headingMetrics =
                bubbaDesignTextMetrics(context, BubbaSettingsText.thanksHeading);
            flow.block(
              Text(
                'Thanks!',
                textAlign: TextAlign.center,
                style: BubbaSettingsText.thanksHeading,
              ),
              top: 327.89 - headingMetrics.baseline,
              height: headingMetrics.lineHeight,
            );

            final bodyMetrics =
                bubbaDesignTextMetrics(context, BubbaSettingsText.bodyCentred);
            flow.block(
              Text(
                'We’ve received your message\nand will get back to you soon.',
                textAlign: TextAlign.center,
                style: BubbaSettingsText.bodyCentred,
              ),
              top: 370.84 - bodyMetrics.baseline,
              height: bodyMetrics.lineHeight * 2,
            );

            flow.block(
              const _WhatHappensCard(items: _items),
              top: 443.50,
              height: 185,
            );

            flow.block(
              SettingsCtaButton(
                label: 'Back to Support',
                fill: BubbaSettingsColors.rowLabel,
                onTap: onDone,
              ),
              top: 687,
              height: 58,
            );
          },
        ),
      );
}

class _WhatHappensCard extends StatelessWidget {
  const _WhatHappensCard({required this.items});

  final List<(String, double, double, double, double)> items;

  @override
  Widget build(BuildContext context) {
    const x = 17.57;
    const y = 443.50;
    final titleMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.sectionLead);
    final itemMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.cardItem);

    Widget at(double left, double top, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: hd(left - x), top: d(top - y)),
            child: child,
          ),
        );

    return Row(
      children: [
        SizedBox(width: hd(x)),
        Container(
          width: hd(354),
          height: d(185),
          decoration: BoxDecoration(
            color: BubbaSettingsColors.infoCardBg,
            border: Border.all(
              color: BubbaSettingsColors.infoCardBorder,
              width: d(BubbaSettingsMetrics.dividerWeight),
            ),
            borderRadius:
                BorderRadius.circular(d(BubbaSettingsMetrics.cardRadius)),
          ),
          child: Stack(
            children: [
              at(
                40.72,
                478.85 - titleMetrics.baseline,
                Text('What happens next?', style: BubbaSettingsText.sectionLead),
              ),
              for (final item in items) ...[
                at(
                  item.$4,
                  item.$5,
                  const BubbaGlyphIcon(
                    BubbaSettingsGlyphs.listCheck,
                    color: BubbaSettingsColors.infoCheck,
                    width: 14.18,
                    height: 10.16,
                  ),
                ),
                at(
                  item.$2,
                  item.$3 - itemMetrics.baseline,
                  Text(item.$1, style: BubbaSettingsText.cardItem),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class BubbaTechnicalIssueScreen extends StatefulWidget {
  const BubbaTechnicalIssueScreen({super.key});

  @override
  State<BubbaTechnicalIssueScreen> createState() =>
      _BubbaTechnicalIssueScreenState();
}

class _BubbaTechnicalIssueScreenState extends State<BubbaTechnicalIssueScreen> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<File?> _files = [null, null, null];
  bool _sending = false;

  String get _topic {
    final args = Get.arguments;
    if (args is Map && args['topic'] is String) return args['topic'] as String;
    return 'Technical Issue';
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _addScreenshot(int slot) async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked == null || !mounted) return;
    setState(() => _files[slot] = File(picked.path));
  }

  Future<void> _submit() async {
    if (_sending || _controller.text.trim().isEmpty) return;
    setState(() => _sending = true);

    final shots = <String>[];
    for (final file in _files) {
      if (file == null) continue;
      shots.add(base64Encode(await file.readAsBytes()));
    }

    final result = await Get.find<SettingsRepository>().submitSupportTicket(
      topic: _topic,
      description: _controller.text.trim(),
      screenshots: shots,
    );

    if (!mounted) return;
    if (!result.isSuccess) {
      showSettingsError(result.errorMessage);
      setState(() => _sending = false);
      return;
    }
    Get.off(() => const BubbaReportSubmittedScreen());
  }

  @override
  Widget build(BuildContext context) => SettingsTechnicalIssueView(
        controller: _controller,
        characters: _controller.text.characters.length,
        screenshots: [
          for (final file in _files) file == null ? null : FileImage(file),
        ],
        onBack: Get.back,
        onCancel: Get.back,
        onAddScreenshot: _sending ? null : _addScreenshot,
        onSubmit: _sending ? null : _submit,
      );
}

class BubbaReportSubmittedScreen extends StatelessWidget {
  const BubbaReportSubmittedScreen({super.key});

  @override
  Widget build(BuildContext context) => SettingsReportSubmittedView(
        onBack: Get.back,
        onDone: Get.back,
      );
}

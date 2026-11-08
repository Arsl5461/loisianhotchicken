import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/design/bubba_glyphs.dart';
import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_settings_glyphs.dart';
import '../../core/design/bubba_settings_tokens.dart';
import '../auth/create_account/data/bubba_countries.dart';
import 'data/us_states.dart';
import 'widgets/settings_chrome.dart';
import 'widgets/settings_confirm_scaffold.dart';
import 'widgets/settings_picker_sheet.dart';

const double _cardX = 27.50;
const double _cardY = 138.11;
const double _cardW = 335;
const double _cardH = 545;

class SettingsBillingAddress {
  const SettingsBillingAddress({
    required this.name,
    required this.line1,
    required this.line2,
    required this.country,
    this.countryCode = '',
    this.street = '',
    this.apt = '',
    this.city = '',
    this.state = '',
    this.zip = '',
    this.phone = '',
  });

  factory SettingsBillingAddress.fromForm(
    SettingsBillingAddressForm form, {
    String name = '',
  }) {
    final streetLine =
        form.apt.isEmpty ? form.street : '${form.street}, ${form.apt}';
    final locality = <String>[
      if (form.city.isNotEmpty) form.city,
      if (form.state.isNotEmpty) form.state,
    ].join(', ');
    return SettingsBillingAddress(
      name: name,
      line1: streetLine,
      line2: form.zip.isEmpty ? locality : '$locality ${form.zip}'.trim(),
      country: form.country,
      countryCode: form.countryCode,
      street: form.street,
      apt: form.apt,
      city: form.city,
      state: form.state,
      zip: form.zip,
      phone: form.phone,
    );
  }

  final String name;
  final String line1;
  final String line2;
  final String country;
  final String countryCode;
  final String street;
  final String apt;
  final String city;
  final String state;
  final String zip;
  final String phone;

  SettingsBillingAddressForm toForm() => SettingsBillingAddressForm(
        country: country,
        countryCode: countryCode,
        street: street,
        apt: apt,
        city: city,
        state: state,
        zip: zip,
        phone: phone,
      );
}

class SettingsBillingAddressForm {
  const SettingsBillingAddressForm({
    this.country = '',
    this.countryCode = '',
    this.street = '',
    this.apt = '',
    this.city = '',
    this.state = '',
    this.zip = '',
    this.phone = '',
  });

  final String country;
  final String countryCode;
  final String street;
  final String apt;
  final String city;
  final String state;
  final String zip;
  final String phone;

  bool get isComplete =>
      country.isNotEmpty &&
      street.isNotEmpty &&
      city.isNotEmpty &&
      state.isNotEmpty &&
      zip.isNotEmpty;

  SettingsBillingAddressForm copyWith({
    String? country,
    String? countryCode,
    String? street,
    String? apt,
    String? city,
    String? state,
    String? zip,
    String? phone,
  }) =>
      SettingsBillingAddressForm(
        country: country ?? this.country,
        countryCode: countryCode ?? this.countryCode,
        street: street ?? this.street,
        apt: apt ?? this.apt,
        city: city ?? this.city,
        state: state ?? this.state,
        zip: zip ?? this.zip,
        phone: phone ?? this.phone,
      );
}

enum _FieldKind { text, country, state }

class _Field {
  const _Field({
    required this.id,
    required this.label,
    required this.labelX,
    required this.labelBaseline,
    required this.value,
    required this.valueX,
    required this.valueBaseline,
    required this.inputWidth,
    this.kind = _FieldKind.text,
    this.keyboard = TextInputType.text,
    this.capitalization = TextCapitalization.words,
    this.ruleY,
    this.ruleX = 26.72,
    this.chevronX,
    this.chevronY,
  });

  final String id;
  final String label;
  final double labelX;
  final double labelBaseline;
  final String value;
  final double valueX;
  final double valueBaseline;
  final double inputWidth;
  final _FieldKind kind;
  final TextInputType keyboard;
  final TextCapitalization capitalization;
  final double? ruleY;
  final double ruleX;
  final double? chevronX;
  final double? chevronY;
}

const _fields = [
  _Field(
    id: 'country',
    kind: _FieldKind.country,
    label: 'Country / Region',
    labelX: 43.43,
    labelBaseline: 226.84,
    value: 'Select country or region',
    valueX: 42.99,
    valueBaseline: 255.69,
    inputWidth: 280,
    ruleY: 280.11,
    chevronX: 333.98,
    chevronY: 242.75,
  ),
  _Field(
    id: 'street',
    label: 'Street address',
    labelX: 43.43,
    labelBaseline: 308.84,
    value: 'Enter street address',
    valueX: 42.99,
    valueBaseline: 337.69,
    inputWidth: 300,
    ruleY: 362.11,
    keyboard: TextInputType.streetAddress,
  ),
  _Field(
    id: 'apt',
    label: 'Apt, suite, etc. (optional)',
    labelX: 42.43,
    labelBaseline: 389.84,
    value: 'Enter apartment, suite, etc.',
    valueX: 41.99,
    valueBaseline: 418.69,
    inputWidth: 300,
    ruleY: 443.11,
    ruleX: 25.72,
  ),
  _Field(
    id: 'city',
    label: 'City',
    labelX: 43.43,
    labelBaseline: 469.84,
    value: 'Enter city',
    valueX: 42.99,
    valueBaseline: 498.69,
    inputWidth: 124,
    ruleY: 523.11,
  ),
  _Field(
    id: 'state',
    kind: _FieldKind.state,
    label: 'State',
    labelX: 185.92,
    labelBaseline: 470.02,
    value: 'Select state',
    valueX: 185.34,
    valueBaseline: 500.40,
    inputWidth: 145,
    chevronX: 336.56,
    chevronY: 480.79,
  ),
  _Field(
    id: 'zip',
    label: 'ZIP code',
    labelX: 42.43,
    labelBaseline: 546.84,
    value: 'Enter ZIP code',
    valueX: 41.99,
    valueBaseline: 575.69,
    inputWidth: 300,
    ruleY: 600.11,
    ruleX: 25.72,
    keyboard: TextInputType.numberWithOptions(),
    capitalization: TextCapitalization.characters,
  ),
  _Field(
    id: 'phone',
    label: 'Phone (optional)',
    labelX: 43.43,
    labelBaseline: 629.84,
    value: '(555) 555 - 555',
    valueX: 42.99,
    valueBaseline: 658.69,
    inputWidth: 300,
    keyboard: TextInputType.phone,
    capitalization: TextCapitalization.none,
  ),
];

class SettingsBillingAddressView extends StatefulWidget {
  const SettingsBillingAddressView({
    super.key,
    this.initial = const SettingsBillingAddressForm(),
    this.onBack,
    this.onSaveAddress,
  });

  final SettingsBillingAddressForm initial;
  final VoidCallback? onBack;
  final ValueChanged<SettingsBillingAddressForm>? onSaveAddress;

  @override
  State<SettingsBillingAddressView> createState() =>
      _SettingsBillingAddressViewState();
}

class _SettingsBillingAddressViewState
    extends State<SettingsBillingAddressView> {
  late SettingsBillingAddressForm _form = widget.initial;
  late final Map<String, TextEditingController> _controllers = {
    'street': TextEditingController(text: widget.initial.street),
    'apt': TextEditingController(text: widget.initial.apt),
    'city': TextEditingController(text: widget.initial.city),
    'zip': TextEditingController(text: widget.initial.zip),
    'phone': TextEditingController(text: widget.initial.phone),
  };
  late final Map<String, FocusNode> _nodes = {
    for (final id in _controllers.keys) id: FocusNode(),
  };

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    for (final n in _nodes.values) {
      n.dispose();
    }
    super.dispose();
  }

  void _onText(String id, String text) {
    setState(() {
      switch (id) {
        case 'street':
          _form = _form.copyWith(street: text);
        case 'apt':
          _form = _form.copyWith(apt: text);
        case 'city':
          _form = _form.copyWith(city: text);
        case 'zip':
          _form = _form.copyWith(zip: text);
        case 'phone':
          _form = _form.copyWith(phone: text);
      }
    });
  }

  Future<void> _pickCountry() async {
    final picked = await showSettingsPickerSheet(
      context,
      title: 'Country / Region',
      searchHint: 'Search countries',
      selected: _form.countryCode,
      options: [
        for (final country in bubbaCountries)
          SettingsPickerOption(value: country.code, label: country.name),
      ],
    );
    if (picked == null || !mounted) return;
    final country = bubbaCountries.firstWhere((c) => c.code == picked);
    setState(() {
      _form = _form.copyWith(country: country.name, countryCode: country.code);
    });
  }

  Future<void> _pickState() async {
    final picked = await showSettingsPickerSheet(
      context,
      title: 'State',
      searchHint: 'Search states',
      selected: _form.state,
      options: [
        for (final state in usStates)
          SettingsPickerOption(
            value: state.code,
            label: '${state.name} (${state.code})',
          ),
      ],
    );
    if (picked == null || !mounted) return;
    setState(() => _form = _form.copyWith(state: picked));
  }

  String _valueOf(String id) => switch (id) {
        'country' => _form.country,
        'street' => _form.street,
        'apt' => _form.apt,
        'city' => _form.city,
        'state' => _form.state,
        'zip' => _form.zip,
        'phone' => _form.phone,
        _ => '',
      };

  void _save() => widget.onSaveAddress?.call(_form);

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
      SettingsNavBar(title: 'Add Card', onBack: widget.onBack),
      top: 0,
      height: BubbaSettingsMetrics.navHeight,
    );

    final sectionMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.formSection);
    flow.block(
      Row(
        children: [
          SizedBox(width: hd(26.20)),
          Text('BILLING ADDRESS', style: BubbaSettingsText.formSection),
        ],
      ),
      top: 114.76 - sectionMetrics.baseline,
      height: sectionMetrics.lineHeight,
    );

    flow.block(
      _AddressCard(
        valueOf: _valueOf,
        controllers: _controllers,
        nodes: _nodes,
        onText: _onText,
        onPickCountry: _pickCountry,
        onPickState: _pickState,
      ),
      top: _cardY,
      height: _cardH,
    );

    flow.block(
      SettingsCtaButton(
        label: 'Save card',
        fill: BubbaSettingsColors.rowLabel,
        onTap: _form.isComplete ? _save : null,
      ),
      top: 742.81,
      height: 58,
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.valueOf,
    required this.controllers,
    required this.nodes,
    required this.onText,
    required this.onPickCountry,
    required this.onPickState,
  });

  final String Function(String id) valueOf;
  final Map<String, TextEditingController> controllers;
  final Map<String, FocusNode> nodes;
  final void Function(String id, String text) onText;
  final VoidCallback onPickCountry;
  final VoidCallback onPickState;

  @override
  Widget build(BuildContext context) {
    final headerMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.billingValue);
    final labelMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.formLabel);
    final valueMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.formPlaceholder);

    Widget at(double left, double top, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: hd(math.max(0, left - _cardX)),
              top: d(math.max(0, top - _cardY)),
            ),
            child: child,
          ),
        );

    final layers = <Widget>[
      at(
        37.95,
        157.71,
        const BubbaGlyphIcon(
          BubbaSettingsGlyphs.pinMark,
          color: BubbaSettingsColors.rowLabel,
          width: 16.81,
          height: 20.08,
        ),
      ),
      at(
        66.36,
        171.49 - headerMetrics.baseline,
        Text('Billing address', style: BubbaSettingsText.billingValue),
      ),
      at(
        335.09,
        165.20,
        const SettingsChevron(
          glyph: BubbaSettingsGlyphs.rowChevronUp,
          color: BubbaSettingsColors.mutedChevron,
          width: 10,
          height: 5.66,
        ),
      ),
      at(
        27.00,
        197.11 - 0.25,
        SizedBox(
          width: hd(336),
          height: d(0.5),
          child: const BubbaHairline(color: BubbaSettingsColors.cardBorder),
        ),
      ),
      at(
        171.22,
        443.61,
        SizedBox(
          width: d(0.5),
          height: d(79.50),
          child: const BubbaHairline(color: BubbaSettingsColors.cardBorder),
        ),
      ),
    ];

    for (final field in _fields) {
      layers.add(at(
        field.labelX,
        field.labelBaseline - labelMetrics.baseline,
        Text(field.label, style: BubbaSettingsText.formLabel),
      ));

      final current = valueOf(field.id);
      final Widget valueWidget;
      if (field.kind == _FieldKind.text) {
        valueWidget = SizedBox(
          width: hd(field.inputWidth),
          child: Stack(
            children: [
              if (current.isEmpty)
                Text(field.value, style: BubbaSettingsText.formPlaceholder),
              EditableText(
                controller: controllers[field.id]!,
                focusNode: nodes[field.id]!,
                style: BubbaSettingsText.formValue,
                cursorColor: BubbaSettingsColors.rowLabel,
                backgroundCursorColor: BubbaSettingsColors.cardBorder,
                keyboardType: field.keyboard,
                textCapitalization: field.capitalization,
                maxLines: 1,
                onChanged: (text) => onText(field.id, text),
              ),
            ],
          ),
        );
      } else {
        valueWidget = Semantics(
          button: true,
          label: field.label,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: field.kind == _FieldKind.country
                ? onPickCountry
                : onPickState,
            child: SizedBox(
              width: hd(field.inputWidth),
              child: Text(
                current.isEmpty ? field.value : current,
                style: current.isEmpty
                    ? BubbaSettingsText.formPlaceholder
                    : BubbaSettingsText.formValue,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      }

      layers.add(at(
        field.valueX,
        field.valueBaseline - valueMetrics.baseline,
        valueWidget,
      ));

      if (field.ruleY != null) {
        layers.add(at(
          field.ruleX,
          field.ruleY! - 0.25,
          SizedBox(
            width: hd(336),
            height: d(0.5),
            child: const BubbaHairline(color: BubbaSettingsColors.cardBorder),
          ),
        ));
      }
      if (field.chevronX != null) {
        layers.add(at(
          field.chevronX!,
          field.chevronY!,
          const SettingsChevron(
            glyph: BubbaSettingsGlyphs.rowChevronDown,
            color: BubbaSettingsColors.mutedChevron,
            width: 10,
            height: 5.66,
          ),
        ));
      }
    }

    return Row(
      children: [
        SizedBox(width: hd(_cardX)),
        Container(
          width: hd(_cardW),
          height: d(_cardH),
          decoration: BoxDecoration(
            color: BubbaSettingsColors.pageBg,
            border: Border.all(
              color: BubbaSettingsColors.cardBorder,
              width: d(BubbaSettingsMetrics.dividerWeight),
            ),
            borderRadius: BorderRadius.circular(d(9.38)),
          ),
          child: Stack(children: layers),
        ),
      ],
    );
  }
}

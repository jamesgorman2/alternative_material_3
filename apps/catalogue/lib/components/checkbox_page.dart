import 'package:alternative_material_3/material.dart';

import '../common_scaffold.dart';
import 'component_card.dart';
import 'components_overview.dart';

class CheckboxPage extends StatelessWidget {
  const CheckboxPage({super.key});

  static const String route = '${ComponentsOverview.route}/checkbox';
  static const String label = 'Checkbox';

  @override
  Widget build(BuildContext context) {
    final colorSchemeLight = Theme.of(context).colorScheme.asLight();
    final colorSchemeDark = colorSchemeLight.asDark();

    return CommonScaffold(
      title: const Text(label),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CheckboxSample(
                colorScheme: colorSchemeLight,
              ),
              const SizedBox(height: 16.0),
              CheckboxSample(
                colorScheme: colorSchemeDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CheckboxSample extends StatelessWidget {
  const CheckboxSample({
    super.key,
    required this.colorScheme,
  });

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return ComponentCard(
      colorScheme: colorScheme,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              CheckboxState(),
              SizedBox(height: 16.0),
              Text('Checkbox'),
            ],
          ),
          SizedBox(width: 48),
          Column(
            children: [
              CheckboxState(isTristate: true),
              SizedBox(height: 16.0),
              Text('Tri-state checkbox'),
            ],
          ),
          SizedBox(width: 48),
          Column(
            children: [
              Row(
                children: [
                  CheckboxState(enabled: false),
                  SizedBox(width: 8),
                  CheckboxState(enabled: false, checked: false),
                ],
              ),
              SizedBox(height: 16.0),
              Text('Disabled checkbox'),
            ],
          ),
        ],
      ),
    );
  }
}

class CheckboxState extends StatefulWidget {
  const CheckboxState({
    super.key,
    this.enabled = true,
    this.checked = true,
    this.isTristate = false,
  });

  final bool enabled;
  final bool checked;
  final bool isTristate;

  @override
  State<CheckboxState> createState() => _CheckboxStateState();
}

class _CheckboxStateState extends State<CheckboxState> {
  bool? checked;

  @override
  void initState() {
    super.initState();
    checked = widget.checked;
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: checked,
      onChanged: widget.enabled
        ? (value) {
            setState(() {
              checked = value;
            });
          }
        : null,
      tristate: widget.isTristate,
    );
  }
}

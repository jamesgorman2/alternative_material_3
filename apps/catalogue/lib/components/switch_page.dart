import 'package:alternative_material_3/material.dart';

import '../common_scaffold.dart';
import 'component_card.dart';
import 'components_overview.dart';

class SwitchPage extends StatelessWidget {
  const SwitchPage({super.key});

  static const String route = '${ComponentsOverview.route}/switch';
  static const String label = 'Switch';

  @override
  Widget build(BuildContext context) {
    final colorSchemeLight = Theme.of(context).colorScheme.asLight();
    final colorSchemeDark = colorSchemeLight.asDark();

    return CommonScaffold(
      title: const Text(label),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchSample(
            colorScheme: colorSchemeLight,
          ),
          const SizedBox(height: 16.0),
          SwitchSample(
            colorScheme: colorSchemeDark,
          ),
        ],
      ),
    );
  }
}

class SwitchSample extends StatelessWidget {
  const SwitchSample({
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
              SwitchState(),
              SizedBox(height: 16.0),
              Text('Checked switch'),
            ],
          ),
          SizedBox(width: 48),
          Column(
            children: [
              SwitchState(isPlain: true),
              SizedBox(height: 16.0),
              Text('Plain switch'),
            ],
          ),
          SizedBox(width: 48),
          Column(
            children: [
              Row(
                children: [
                  SwitchState(enabled: false),
                  SizedBox(height: 8.0),
                  SwitchState(enabled: false, value: false),
                ],
              ),
              SizedBox(height: 16.0),
              Text('Disabled checked switch'),
            ],
          ),
          SizedBox(width: 48),
          Column(
            children: [
              Row(
                children: [
                  SwitchState(enabled: false, isPlain: true),
                  SizedBox(height: 8.0),
                  SwitchState(enabled: false, value: false, isPlain: true),
                ],
              ),
              SizedBox(height: 16.0),
              Text('Disabled plain switch'),
            ],
          ),
        ],
      ),
    );
  }
}

class SwitchState extends StatefulWidget {
  const SwitchState({
    super.key,
    this.enabled = true,
    this.value = true,
    this.isPlain = false,
  });

  final bool enabled;
  final bool value;
  final bool isPlain;

  @override
  State<SwitchState> createState() => _SwitchStateState();
}

class _SwitchStateState extends State<SwitchState> {
  late bool checked;

  @override
  void initState() {
    super.initState();
    checked = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isPlain) {
      return Switch.plain(
        value: checked,
        onChanged: widget.enabled
            ? (value) {
                setState(() {
                  checked = value;
                });
              }
            : null,
      );
    }
    return Switch(
      value: checked,
      onChanged: widget.enabled
          ? (value) {
              setState(() {
                checked = value;
              });
            }
          : null,
    );
  }
}

import 'package:alternative_material_3/material.dart';

import '../common_scaffold.dart';
import 'component_card.dart';
import 'components_overview.dart';

class RadioButtonPage extends StatelessWidget {
  const RadioButtonPage({super.key});

  static const String route = '${ComponentsOverview.route}/radio';
  static const String label = 'Radio button';

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
              RadioButtonSample(
                colorScheme: colorSchemeLight,
              ),
              const SizedBox(height: 16.0),
              RadioButtonSample(
                colorScheme: colorSchemeDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RadioButtonSample extends StatelessWidget {
  const RadioButtonSample({
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
              RadioButtonsState(),
              SizedBox(height: 16.0),
              Text('Radio buttons'),
            ],
          ),
          SizedBox(width: 48),
          Column(
            children: [
              RadioButtonsState(toggleable: true),
              SizedBox(height: 16.0),
              Text('Toggleable radio buttons'),
            ],
          ),
          SizedBox(width: 48),
          Column(
            children: [
              RadioButtonsState(enabled: false),
              SizedBox(height: 16.0),
              Text('Disabled radio buttons'),
            ],
          ),
        ],
      ),
    );
  }
}

class RadioButtonsState extends StatefulWidget {
  const RadioButtonsState({
    super.key,
    this.enabled = true,
    this.checked = true,
    this.toggleable = false,
  });

  final bool enabled;
  final bool checked;
  final bool toggleable;

  @override
  State<RadioButtonsState> createState() => _RadioButtonsStateState();
}

class _RadioButtonsStateState extends State<RadioButtonsState> {
  int? selectedValue = 0;

  void handleChanged(int? value) {
    setState(() {
      selectedValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Radio<int>(
          value: 0,
          groupValue: selectedValue,
          onChanged: widget.enabled
            ? handleChanged
            : null,
          toggleable: widget.toggleable,
        ),
        Radio<int>(
          value: 1,
          groupValue: selectedValue,
          onChanged: widget.enabled
            ? handleChanged
            : null,
          toggleable: widget.toggleable,
        ),
        Radio<int>(
          value: 2,
          groupValue: selectedValue,
          onChanged: widget.enabled
            ? handleChanged
            : null,
          toggleable: widget.toggleable,
        ),
      ],
    );
  }
}

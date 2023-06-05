import 'package:alternative_material_3/material.dart';

import '../common_scaffold.dart';
import 'component_card.dart';
import 'components_overview.dart';

class SegmentedButtonsPage extends StatelessWidget {
  const SegmentedButtonsPage({super.key});

  static const String route = '${ComponentsOverview.route}/segmented_buttons';
  static const String label = 'Segmented buttons';

  @override
  Widget build(BuildContext context) {
    final colorSchemeLight = Theme.of(context).colorScheme.asLight();
    final colorSchemeDark = colorSchemeLight.asDark();

    return CommonScaffold(
      title: const Text(label),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ButtonsSample(
            colorScheme: colorSchemeLight,
          ),
          const SizedBox(height: 24.0),
          ToggleSample(
            colorScheme: colorSchemeLight,
          ),
          const SizedBox(height: 24.0),
          ButtonsSample(
            colorScheme: colorSchemeDark,
          ),
          const SizedBox(height: 24.0),
          ToggleSample(
            colorScheme: colorSchemeDark,
          ),
        ],
      ),
    );
  }
}

class ButtonsSample extends StatelessWidget {
  const ButtonsSample({
    super.key,
    required this.colorScheme,
  });

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return ComponentCard(
      colorScheme: colorScheme,
      child: Column(
        children: [
          SegmentedButton<int>(
            onSelectionChanged: (_){},
            selected: const {1},
            segments: const [
              ButtonSegment<int>(
                value: 0,
                icon: Icon(Icons.star_outline),
                label: Text('Enabled'),
              ),
              ButtonSegment<int>(
                value: 1,
                icon: Icon(Icons.palette_outlined),
                label: Text('Enabled'),
              ),
              ButtonSegment<int>(
                value: 2,
                icon: Icon(Icons.person_outline),
                label: Text('Enabled'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SegmentedButton<int>(
            onSelectionChanged: (_){},
            selected: const {1},
            segments: const [
              ButtonSegment<int>(
                value: 0,
                label: Text('Enabled'),
              ),
              ButtonSegment<int>(
                value: 1,
                label: Text('Enabled'),
              ),
              ButtonSegment<int>(
                value: 2,
                label: Text('Enabled'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SegmentedButton<int>(
            onSelectionChanged: (_){},
            selected: const {1},
            showSelectedIcon: false,
            segments: const [
              ButtonSegment<int>(
                value: 0,
                icon: Icon(Icons.star_outline),
                label: Text('Enabled'),
              ),
              ButtonSegment<int>(
                value: 1,
                icon: Icon(Icons.palette_outlined),
                label: Text('Enabled'),
              ),
              ButtonSegment<int>(
                value: 2,
                icon: Icon(Icons.person_outline),
                label: Text('Enabled'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SegmentedButton<int>(
            onSelectionChanged: (_){},
            selected: const {1},
            showSelectedIcon: false,
            segments: const [
              ButtonSegment<int>(
                value: 0,
                label: Text('Enabled'),
              ),
              ButtonSegment<int>(
                value: 1,
                label: Text('Enabled'),
              ),
              ButtonSegment<int>(
                value: 2,
                label: Text('Enabled'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SegmentedButton<int>(
            onSelectionChanged: (_){},
            selected: const {1},
            segments: const [
              ButtonSegment<int>(
                value: 0,
                icon: Icon(Icons.star_outline),
              ),
              ButtonSegment<int>(
                value: 1,
                icon: Icon(Icons.palette_outlined),
              ),
              ButtonSegment<int>(
                value: 2,
                icon: Icon(Icons.person_outline),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SegmentedButton<int>(
            onSelectionChanged: (_){},
            selected: const {1},
            showSelectedIcon: false,
            segments: const [
              ButtonSegment<int>(
                value: 0,
                icon: Icon(Icons.star_outline),
              ),
              ButtonSegment<int>(
                value: 1,
                icon: Icon(Icons.palette_outlined),
              ),
              ButtonSegment<int>(
                value: 2,
                icon: Icon(Icons.person_outline),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SegmentedButton<int>(
            onSelectionChanged: (_){},
            selected: const {0},
            emptySelectionAllowed: true,
            segments: const [
              ButtonSegment<int>(
                value: 0,
                label: Text('Enabled'),
              ),
              ButtonSegment<int>(
                value: 1,
                label: Text('Disabled'),
                enabled: false,
              ),
              ButtonSegment<int>(
                value: 2,
                label: Text('Enabled'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ToggleSample extends StatefulWidget {
  const ToggleSample({
    super.key,
    required this.colorScheme,
  });

  final ColorScheme colorScheme;

  @override
  State<ToggleSample> createState() => _ToggleSampleState();
}

class _ToggleSampleState extends State<ToggleSample> {
  Set<int> selectedA = {};
  Set<int> selectedB = {};
  Set<int> selectedC = {};

  void handleSelectedA(Set<int> s) {
    setState(() {
      selectedA = s;
    });
  }

  void handleSelectedB(Set<int> s) {
    setState(() {
      selectedB = s;
    });
  }

  void handleSelectedC(Set<int> s) {
    setState(() {
      selectedC = s;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ComponentCard(
      colorScheme: widget.colorScheme,
      child: Column(
        children: [
          SegmentedButton<int>(
            onSelectionChanged: handleSelectedA,
            emptySelectionAllowed: true,
            selected: selectedA,
            segments: const [
              ButtonSegment<int>(
                value: 0,
                icon: Icon(Icons.star_outline),
                label: Text('Enabled'),
              ),
              ButtonSegment<int>(
                value: 1,
                icon: Icon(Icons.palette_outlined),
                label: Text('Enabled'),
              ),
              ButtonSegment<int>(
                value: 2,
                icon: Icon(Icons.person_outline),
                label: Text('Enabled'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SegmentedButton<int>(
            onSelectionChanged: handleSelectedB,
            emptySelectionAllowed: true,
            multiSelectionEnabled: true,
            selected: selectedB,
            segments: const [
              ButtonSegment<int>(
                value: 0,
                icon: Icon(Icons.star_outline),
                label: Text('Star'),
              ),
              ButtonSegment<int>(
                value: 1,
                icon: Icon(Icons.palette_outlined),
                label: Text('Palette'),
              ),
              ButtonSegment<int>(
                value: 2,
                icon: Icon(Icons.person_outline),
                label: Text('Person'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SegmentedButton<int>(
            onSelectionChanged: handleSelectedC,
            emptySelectionAllowed: true,
            multiSelectionEnabled: true,
            selected: selectedC,
            segments: const [
              ButtonSegment<int>(
                value: 0,
                label: Text('Star'),
              ),
              ButtonSegment<int>(
                value: 1,
                label: Text('Palette'),
              ),
              ButtonSegment<int>(
                value: 2,
                label: Text('Person'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

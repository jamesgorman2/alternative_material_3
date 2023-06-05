import 'package:alternative_material_3/material.dart';

import '../common_scaffold.dart';
import 'component_card.dart';
import 'components_overview.dart';

class IconButtonsPage extends StatelessWidget {
  const IconButtonsPage({super.key});

  static const String route = '${ComponentsOverview.route}/icon_buttons';
  static const String label = 'Icon buttons';

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Row(
                children: [
                  FilledIconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings),
                  ),
                  const SizedBox(width: 24),
                  FilledIconButton.toggle(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined),
                  ),
                  const SizedBox(width: 24),
                  FilledIconButton.toggle(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined),
                    selectedIcon: const Icon(Icons.settings),
                    isSelected: true,
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              Row(
                children: [
                  FilledTonalIconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings),
                  ),
                  const SizedBox(width: 24),
                  FilledTonalIconButton.toggle(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined),
                  ),
                  const SizedBox(width: 24),
                  FilledTonalIconButton.toggle(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined),
                    selectedIcon: const Icon(Icons.settings),
                    isSelected: true,
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              Row(
                children: [
                  OutlinedIconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined),
                  ),
                  const SizedBox(width: 24),
                  OutlinedIconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined),
                    selectedIcon: const Icon(Icons.settings),
                  ),
                  const SizedBox(width: 24),
                  OutlinedIconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined),
                    selectedIcon: const Icon(Icons.settings),
                    isSelected: true,
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined),
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined),
                    selectedIcon: const Icon(Icons.settings),
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined),
                    selectedIcon: const Icon(Icons.settings),
                    isSelected: true,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 48),
          const Column(
            children: [
              Row(
                children: [
                  FilledIconButton(
                    onPressed: null,
                    icon: Icon(Icons.settings),
                  ),
                  SizedBox(width: 24),
                  FilledIconButton.toggle(
                    onPressed: null,
                    icon: Icon(Icons.settings_outlined),
                  ),
                  SizedBox(width: 24),
                  FilledIconButton.toggle(
                    onPressed: null,
                    icon: Icon(Icons.settings_outlined),
                    selectedIcon: Icon(Icons.settings),
                    isSelected: true,
                  ),
                ],
              ),
              SizedBox(height: 24.0),
              Row(
                children: [
                  FilledTonalIconButton(
                    onPressed: null,
                    icon: Icon(Icons.settings),
                  ),
                  SizedBox(width: 24),
                  FilledTonalIconButton.toggle(
                    onPressed: null,
                    icon: Icon(Icons.settings_outlined),
                  ),
                  SizedBox(width: 24),
                  FilledTonalIconButton.toggle(
                    onPressed: null,
                    icon: Icon(Icons.settings_outlined),
                    selectedIcon: Icon(Icons.settings),
                    isSelected: true,
                  ),
                ],
              ),
              SizedBox(height: 24.0),
              Row(
                children: [
                  OutlinedIconButton(
                    onPressed: null,
                    icon: Icon(Icons.settings_outlined),
                  ),
                  SizedBox(width: 24),
                  OutlinedIconButton(
                    onPressed: null,
                    icon: Icon(Icons.settings_outlined),
                    selectedIcon: Icon(Icons.settings),
                  ),
                  SizedBox(width: 24),
                  OutlinedIconButton(
                    onPressed: null,
                    icon: Icon(Icons.settings_outlined),
                    selectedIcon: Icon(Icons.settings),
                    isSelected: true,
                  ),
                ],
              ),
              SizedBox(height: 24.0),
              Row(
                children: [
                  IconButton(
                    onPressed: null,
                    icon: Icon(Icons.settings_outlined),
                  ),
                  SizedBox(width: 24),
                  IconButton(
                    onPressed: null,
                    icon: Icon(Icons.settings_outlined),
                    selectedIcon: Icon(Icons.settings),
                  ),
                  SizedBox(width: 24),
                  IconButton(
                    onPressed: null,
                    icon: Icon(Icons.settings_outlined),
                    selectedIcon: Icon(Icons.settings),
                    isSelected: true,
                  ),
                ],
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
  List<bool> selected = List.filled(4, false);

  void handleOnSelected(int i) {
    setState(() {
      selected[i] = !selected[i];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ComponentCard(
      colorScheme: widget.colorScheme,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FilledIconButton.toggle(
            onPressed: () => handleOnSelected(0),
            icon: const Icon(Icons.star_outline),
            selectedIcon: const Icon(Icons.star),
            isSelected: selected[0],
          ),
          const SizedBox(width: 24),
          FilledTonalIconButton.toggle(
            onPressed: () => handleOnSelected(1),
            icon: const Icon(Icons.star_outline),
            selectedIcon: const Icon(Icons.star),
            isSelected: selected[1],
          ),
          const SizedBox(width: 24),
          OutlinedIconButton(
            onPressed: () => handleOnSelected(2),
            icon: const Icon(Icons.star_outline),
            selectedIcon: const Icon(Icons.star),
            isSelected: selected[2],
          ),
          const SizedBox(width: 24),
          IconButton(
            onPressed: () => handleOnSelected(3),
            icon: const Icon(Icons.star_outline),
            selectedIcon: const Icon(Icons.star),
            isSelected: selected[3],
          ),
        ],
      ),
    );
  }
}

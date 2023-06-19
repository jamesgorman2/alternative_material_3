import 'dart:math' as math;

import 'package:alternative_material_3/material.dart';

import '../common_scaffold.dart';
import 'component_card.dart';
import 'components_overview.dart';

class FloatingActionButtonPage extends StatelessWidget {
  const FloatingActionButtonPage({super.key});

  static const String route =
      '${ComponentsOverview.route}/floating_action_button';
  static const String label = 'Floating action button';

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
          ExpandingSample(
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
          const SizedBox(height: 24.0),
          ExpandingSample(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                heroTag: math.Random().nextDouble(),
              ),
              const SizedBox(width: 24),
              FloatingActionButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.secondary,
                heroTag: math.Random().nextDouble(),
              ),
              const SizedBox(width: 24),
              FloatingActionButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.tertiary,
                heroTag: math.Random().nextDouble(),
              ),
              const SizedBox(width: 24),
              FloatingActionButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.surface,
                heroTag: math.Random().nextDouble(),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                height: FloatingActionButtonHeight.lowered,
                heroTag: math.Random().nextDouble(),
              ),
              const SizedBox(width: 24),
              FloatingActionButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.secondary,
                height: FloatingActionButtonHeight.lowered,
                heroTag: math.Random().nextDouble(),
              ),
              const SizedBox(width: 24),
              FloatingActionButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.tertiary,
                height: FloatingActionButtonHeight.lowered,
                heroTag: math.Random().nextDouble(),
              ),
              const SizedBox(width: 24),
              FloatingActionButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.surface,
                height: FloatingActionButtonHeight.lowered,
                heroTag: math.Random().nextDouble(),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                height: FloatingActionButtonHeight.flat,
                heroTag: math.Random().nextDouble(),
              ),
              const SizedBox(width: 24),
              FloatingActionButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.secondary,
                height: FloatingActionButtonHeight.flat,
                heroTag: math.Random().nextDouble(),
              ),
              const SizedBox(width: 24),
              FloatingActionButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.tertiary,
                height: FloatingActionButtonHeight.flat,
                heroTag: math.Random().nextDouble(),
              ),
              const SizedBox(width: 24),
              FloatingActionButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.surface,
                height: FloatingActionButtonHeight.flat,
                heroTag: math.Random().nextDouble(),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton.small(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                heroTag: math.Random().nextDouble(),
              ),
              const SizedBox(width: 24),
              FloatingActionButton.small(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.secondary,
                heroTag: math.Random().nextDouble(),
              ),
              const SizedBox(width: 24),
              FloatingActionButton.small(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.tertiary,
                heroTag: math.Random().nextDouble(),
              ),
              const SizedBox(width: 24),
              FloatingActionButton.small(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.surface,
                heroTag: math.Random().nextDouble(),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton.large(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                heroTag: math.Random().nextDouble(),
              ),
              const SizedBox(width: 24),
              FloatingActionButton.large(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.secondary,
                heroTag: math.Random().nextDouble(),
              ),
              const SizedBox(width: 24),
              FloatingActionButton.large(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.tertiary,
                heroTag: math.Random().nextDouble(),
              ),
              const SizedBox(width: 24),
              FloatingActionButton.large(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.surface,
                heroTag: math.Random().nextDouble(),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton.extended(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Extended'),
                heroTag: math.Random().nextDouble(),
              ),
              const SizedBox(width: 24),
              FloatingActionButton.extended(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.secondary,
                label: const Text('Extended'),
                heroTag: math.Random().nextDouble(),
              ),
              const SizedBox(width: 24),
              FloatingActionButton.extended(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.tertiary,
                label: const Text('Extended'),
                heroTag: math.Random().nextDouble(),
              ),
              const SizedBox(width: 24),
              FloatingActionButton.extended(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.surface,
                label: const Text('Extended'),
                heroTag: math.Random().nextDouble(),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton.extended(
                onPressed: () {},
                label: const Text('Extended'),
                heroTag: math.Random().nextDouble(),
              ),
              const SizedBox(width: 24),
              FloatingActionButton.extended(
                onPressed: () {},
                colorTheme: FloatingActionButtonColorTheme.secondary,
                label: const Text('Extended'),
                heroTag: math.Random().nextDouble(),
              ),
              const SizedBox(width: 24),
              FloatingActionButton.extended(
                onPressed: () {},
                colorTheme: FloatingActionButtonColorTheme.tertiary,
                label: const Text('Extended'),
                heroTag: math.Random().nextDouble(),
              ),
              const SizedBox(width: 24),
              FloatingActionButton.extended(
                onPressed: () {},
                colorTheme: FloatingActionButtonColorTheme.surface,
                label: const Text('Extended'),
                heroTag: math.Random().nextDouble(),
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

class ExpandingSample extends StatelessWidget {
  const ExpandingSample({
    super.key,
    required this.colorScheme,
  });

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return ComponentCard(
      colorScheme: colorScheme,
      child: SizedBox(
        height: 200,
        child: Align(
          alignment: Alignment.bottomRight,
          child: ExpandableFloatingActionButton(
            collapsedHeight: FloatingActionButtonHeight.lowered,
            primaryFab: ExpandableFloatingActionButtonEntry(
              icon: const Icon(Icons.navigation_outlined),
              label: const Text('Navigate'),
              onPressed: (){},
              heroTag: math.Random().nextDouble(),
            ),
            supportingFabs: [
              ExpandableFloatingActionButtonEntry(
                icon: const Icon(Icons.location_searching_outlined),
                onPressed: (){},
              ),
              ExpandableFloatingActionButtonEntry(
                icon: const Icon(Icons.search_outlined),
                onPressed: (){},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

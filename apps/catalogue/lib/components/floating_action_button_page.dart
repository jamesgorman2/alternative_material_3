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
          ExpandingSample(
            colorScheme: colorSchemeLight,
          ),
          const SizedBox(height: 24.0),
          ButtonsSample(
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
              ),
              const SizedBox(width: 24),
              FloatingActionButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.secondary,
              ),
              const SizedBox(width: 24),
              FloatingActionButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.tertiary,
              ),
              const SizedBox(width: 24),
              FloatingActionButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.surface,
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
              ),
              const SizedBox(width: 24),
              FloatingActionButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.secondary,
                height: FloatingActionButtonHeight.lowered,
              ),
              const SizedBox(width: 24),
              FloatingActionButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.tertiary,
                height: FloatingActionButtonHeight.lowered,
              ),
              const SizedBox(width: 24),
              FloatingActionButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.surface,
                height: FloatingActionButtonHeight.lowered,
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
              ),
              const SizedBox(width: 24),
              FloatingActionButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.secondary,
                height: FloatingActionButtonHeight.flat,
              ),
              const SizedBox(width: 24),
              FloatingActionButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.tertiary,
                height: FloatingActionButtonHeight.flat,
              ),
              const SizedBox(width: 24),
              FloatingActionButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.surface,
                height: FloatingActionButtonHeight.flat,
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
              ),
              const SizedBox(width: 24),
              FloatingActionButton.small(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.secondary,
              ),
              const SizedBox(width: 24),
              FloatingActionButton.small(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.tertiary,
              ),
              const SizedBox(width: 24),
              FloatingActionButton.small(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.surface,
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
              ),
              const SizedBox(width: 24),
              FloatingActionButton.large(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.secondary,
              ),
              const SizedBox(width: 24),
              FloatingActionButton.large(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.tertiary,
              ),
              const SizedBox(width: 24),
              FloatingActionButton.large(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.surface,
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
              ),
              const SizedBox(width: 24),
              FloatingActionButton.extended(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.secondary,
                label: const Text('Extended'),
              ),
              const SizedBox(width: 24),
              FloatingActionButton.extended(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.tertiary,
                label: const Text('Extended'),
              ),
              const SizedBox(width: 24),
              FloatingActionButton.extended(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                colorTheme: FloatingActionButtonColorTheme.surface,
                label: const Text('Extended'),
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
              ),
              const SizedBox(width: 24),
              FloatingActionButton.extended(
                onPressed: () {},
                colorTheme: FloatingActionButtonColorTheme.secondary,
                label: const Text('Extended'),
              ),
              const SizedBox(width: 24),
              FloatingActionButton.extended(
                onPressed: () {},
                colorTheme: FloatingActionButtonColorTheme.tertiary,
                label: const Text('Extended'),
              ),
              const SizedBox(width: 24),
              FloatingActionButton.extended(
                onPressed: () {},
                colorTheme: FloatingActionButtonColorTheme.surface,
                label: const Text('Extended'),
              ),
            ],
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

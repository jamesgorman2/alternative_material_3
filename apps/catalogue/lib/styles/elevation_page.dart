import 'package:alternative_material_3/material.dart';
import 'package:flutter/widgets.dart';

import '../common_scaffold.dart';
import 'styles_overview.dart';

class ElevationPage extends StatelessWidget {
  const ElevationPage({super.key});

  static const String route = '${StylesOverview.route}/elevation';
  static const String label = 'Elevation';

  @override
  Widget build(BuildContext context) {
    final colorSchemeLight = Theme.of(context).colorScheme.asLight();
    final colorSchemeDark = colorSchemeLight.asDark();

    return CommonScaffold(
      title: const Text(label),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Elevation using tone'),
                  const SizedBox(height: 8),
                  ElevationCards(
                    hasShadow: false,
                    colorScheme: colorSchemeLight,
                  ),
                  const SizedBox(height: 8),
                  ElevationCards(
                    hasShadow: false,
                    colorScheme: colorSchemeDark,
                  ),
                  const SizedBox(height: 32),
                  const Text('Elevation using tone and shadow'),
                  const SizedBox(height: 16),
                  ElevationCards(
                    hasShadow: true,
                    colorScheme: colorSchemeLight,
                  ),
                  const SizedBox(height: 8),
                  ElevationCards(
                    hasShadow: true,
                    colorScheme: colorSchemeDark,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ElevationCards extends StatelessWidget {
  const ElevationCards({
    super.key,
    required this.hasShadow,
    required this.colorScheme,
  });

  final bool hasShadow;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final outerTheme = Theme.of(context);
    final font = outerTheme.textTheme.labelLarge.copyWith(
          color: colorScheme.onSurface,
        );
    const shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
    );
    return SizedBox(
      height: 48 + 20 + 16 + 128,
      width: 48 + 128 * 6 + 16 * 5,
      child: Theme(
        data: outerTheme.copyWith(colorScheme: colorScheme),
        child: Material(
          shape: shape,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Surface', style: font),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevationCard(elevation: Elevation.level0, hasShadow: hasShadow),
                    const SizedBox(width: 16),
                    ElevationCard(elevation: Elevation.level1, hasShadow: hasShadow),
                    const SizedBox(width: 16),
                    ElevationCard(elevation: Elevation.level2, hasShadow: hasShadow),
                    const SizedBox(width: 16),
                    ElevationCard(elevation: Elevation.level3, hasShadow: hasShadow),
                    const SizedBox(width: 16),
                    ElevationCard(elevation: Elevation.level4, hasShadow: hasShadow),
                    const SizedBox(width: 16),
                    ElevationCard(elevation: Elevation.level5, hasShadow: hasShadow),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ElevationCard extends StatelessWidget {
  const ElevationCard({
    super.key,
    required this.elevation,
    required this.hasShadow,
  });

  final Elevation elevation;
  final bool hasShadow;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const shape = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
    );
    final font = Theme.of(context).textTheme.labelLarge.copyWith(
      color: colorScheme.onSurface,
    );
    return SizedBox(
      height: 128,
      width: 128,
      child: Material(
        type: MaterialType.card,
        // color: colorScheme.surfaceContainerHighest,
        shape: shape,
        shadowColor:
        hasShadow ? colorScheme.shadow : Colors.transparent,
        elevation: elevation,
        child: Center(child: Text(elevation.label, style: font)),
      ),
    );
  }
}

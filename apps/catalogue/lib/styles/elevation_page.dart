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
    final font = Theme.of(context).textTheme.labelMedium.copyWith(
          color: colorScheme.onSurface,
        );
    const shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
    );
    return SizedBox(
      height: 32 + 16 + 16 + 128,
      width: 32 + 128 * 5 + 16 * 4,
      child: Material(
        type: MaterialType.card,
        color: colorScheme.surface,
        shape: shape,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Level 0', style: font),
              const SizedBox(height: 16),
              Row(
                children: [
                  SizedBox(
                    height: 128,
                    width: 128,
                    child: Material(
                      type: MaterialType.card,
                      // color: colorScheme.surfaceContainerLowest,
                      shape: shape,
                      shadowColor:
                          hasShadow ? colorScheme.shadow : Colors.transparent,
                      elevation: Elevation.level1,
                      child: Center(child: Text('Level 1', style: font)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    height: 128,
                    width: 128,
                    child: Material(
                      type: MaterialType.card,
                      // color: colorScheme.surfaceContainerLow,
                      shape: shape,
                      shadowColor:
                          hasShadow ? colorScheme.shadow : Colors.transparent,
                      elevation: Elevation.level2,
                      child: Center(child: Text('Level 2', style: font)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    height: 128,
                    width: 128,
                    child: Material(
                      type: MaterialType.card,
                      // color: colorScheme.surfaceContainer,
                      shape: shape,
                      shadowColor:
                          hasShadow ? colorScheme.shadow : Colors.transparent,
                      elevation: Elevation.level3,
                      child: Center(child: Text('Level 3', style: font)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    height: 128,
                    width: 128,
                    child: Material(
                      type: MaterialType.card,
                      // color: colorScheme.surfaceContainerHigh,
                      shape: shape,
                      shadowColor:
                          hasShadow ? colorScheme.shadow : Colors.transparent,
                      elevation: Elevation.level4,
                      child: Center(child: Text('Level 4', style: font)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    height: 128,
                    width: 128,
                    child: Material(
                      type: MaterialType.card,
                      // color: colorScheme.surfaceContainerHighest,
                      shape: shape,
                      shadowColor:
                          hasShadow ? colorScheme.shadow : Colors.transparent,
                      elevation: Elevation.level5,
                      child: Center(child: Text('Level 5', style: font)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

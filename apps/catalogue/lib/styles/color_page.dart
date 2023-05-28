import 'package:alternative_material_3/material.dart';

import '../common_scaffold.dart';
import 'styles_overview.dart';

class ColorPage extends StatelessWidget {
  const ColorPage({super.key});

  static const String route = '${StylesOverview.route}/color';
  static const String label = 'Color';

  static const double narrowPadding = 4;
  static const double widePadding = 12;

  static const double tallCell = 56;
  static const double shortCell = 36;
  static const double cellWidth = 220;

  @override
  Widget build(BuildContext context) {
    return const CommonScaffold(
      title: Text(label),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TonalPalettesCard(),
                  SizedBox(height: 16.0),
                  ThemeCardLight(),
                  SizedBox(height: 16.0),
                  ThemeCardDark(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TonalPalettesCard extends StatelessWidget {
  const TonalPalettesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tonal Palettes',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16.0),
            TonalPaletteRow(
                label: 'Primary', palette: colorScheme.palette.primary),
            const SizedBox(height: 16.0),
            TonalPaletteRow(
                label: 'Secondary', palette: colorScheme.palette.secondary),
            const SizedBox(height: 16.0),
            TonalPaletteRow(
                label: 'Tertiary', palette: colorScheme.palette.tertiary),
            const SizedBox(height: 16.0),
            TonalPaletteRow(
                label: 'Neutral', palette: colorScheme.palette.neutral),
            const SizedBox(height: 16.0),
            TonalPaletteRow(
                label: 'Neutral Variant',
                palette: colorScheme.palette.neutralVariant),
            const SizedBox(height: 16.0),
            TonalPaletteRow(label: 'Error', palette: colorScheme.palette.error),
          ],
        ),
      ),
    );
  }
}

class TonalPaletteRow extends StatelessWidget {
  const TonalPaletteRow({
    super.key,
    required this.label,
    required this.palette,
  });

  final String label;
  final TonalPalette palette;

  @override
  Widget build(BuildContext context) {
    const fullWidth = ColorPage.cellWidth * 4 +
        ColorPage.narrowPadding * 2 +
        ColorPage.widePadding;

    Color textColor(int tone) {
      if (tone < 60) {
        return Colors.white70;
      } else if (tone < 80) {
        return Colors.black;
      }
      return Colors.black87;
    }

    return SizedBox(
      width: fullWidth,
      height: ColorPage.tallCell,
      child: Flex(
        direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 124,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),
          ...TonalPalette.commonTones
              .map(
                (tone) => Expanded(
                  child: Container(
                    color: Color(palette.get(tone)),
                    height: ColorPage.tallCell,
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      '$tone',
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            color: textColor(tone),
                          ),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class ThemeCardLight extends StatelessWidget {
  const ThemeCardLight({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme.asLight();
    return Card(
      color: colorScheme.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Light Theme',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: colorScheme.onSurface),
            ),
            const SizedBox(height: 16.0),
            const TopRowLight(),
            const SizedBox(height: 16.0),
            const FixedRow(),
            const SizedBox(height: 16.0),
            const BottomRowLight()
          ],
        ),
      ),
    );
  }
}

class ThemeCardDark extends StatelessWidget {
  const ThemeCardDark({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme.asDark();
    return Card(
      color: colorScheme.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dark Theme',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: colorScheme.onSurface),
            ),
            const SizedBox(height: 16.0),
            const TopRowDark(),
            const SizedBox(height: 16.0),
            const FixedRow(),
            const SizedBox(height: 16.0),
            const BottomRowDark()
          ],
        ),
      ),
    );
  }
}

class TopRowLight extends StatelessWidget {
  const TopRowLight({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        PrimaryLight(),
        SizedBox(width: ColorPage.narrowPadding),
        SecondaryLight(),
        SizedBox(width: ColorPage.narrowPadding),
        TertiaryLight(),
        SizedBox(width: ColorPage.widePadding),
        ErrorLight(),
      ],
    );
  }
}

class TopRowDark extends StatelessWidget {
  const TopRowDark({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        PrimaryDark(),
        SizedBox(width: ColorPage.narrowPadding),
        SecondaryDark(),
        SizedBox(width: ColorPage.narrowPadding),
        TertiaryDark(),
        SizedBox(width: ColorPage.widePadding),
        ErrorDark(),
      ],
    );
  }
}

class FixedRow extends StatelessWidget {
  const FixedRow({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        SwatchFixed(
          role: 'Primary',
          token: 'P-90',
          dimToken: 'P-80',
          onToken: 'P-10',
          variantToken: 'P-30',
          color: colorScheme.primaryFixed,
          dimColor: colorScheme.primaryFixedDim,
          onColor: colorScheme.onPrimaryFixed,
          variantColor: colorScheme.onPrimaryFixedVariant,
        ),
        const SizedBox(width: ColorPage.narrowPadding),
        SwatchFixed(
          role: 'Secondary',
          token: 'S-90',
          dimToken: 'S-80',
          onToken: 'S-10',
          variantToken: 'S-30',
          color: colorScheme.secondaryFixed,
          dimColor: colorScheme.secondaryFixedDim,
          onColor: colorScheme.onSecondaryFixed,
          variantColor: colorScheme.onSecondaryFixedVariant,
        ),
        const SizedBox(width: ColorPage.narrowPadding),
        SwatchFixed(
          role: 'Tertiary',
          token: 'T-90',
          dimToken: 'T-80',
          onToken: 'T-10',
          variantToken: 'T-30',
          color: colorScheme.tertiaryFixed,
          dimColor: colorScheme.tertiaryFixedDim,
          onColor: colorScheme.onTertiaryFixed,
          variantColor: colorScheme.onTertiaryFixedVariant,
        ),
      ],
    );
  }
}

class BottomRowLight extends StatelessWidget {
  const BottomRowLight({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme.asLight();
    return Row(
      children: [
        const Column(
          children: [
            SurfaceRowLight(),
            SizedBox(height: ColorPage.narrowPadding),
            SurfaceContainerRowLight(),
            SizedBox(height: ColorPage.narrowPadding),
            OnSurfaceRowLight(),
          ],
        ),
        const SizedBox(width: ColorPage.widePadding),
        Column(
          children: [
            const InverseSwatchLight(),
            const SizedBox(height: ColorPage.widePadding + 4),
            Row(
              children: [
                Swatch(
                  role: 'Scrim',
                  token: 'N-0',
                  color: colorScheme.scrim,
                  textColor: colorScheme.asLight().surface,
                  height: ColorPage.shortCell,
                  width: (ColorPage.cellWidth - ColorPage.widePadding) / 2,
                ),
                const SizedBox(width: ColorPage.widePadding),
                Swatch(
                  role: 'Shadow',
                  token: 'N-0',
                  color: colorScheme.shadow,
                  textColor: colorScheme.asLight().surface,
                  height: ColorPage.shortCell,
                  width: (ColorPage.cellWidth - ColorPage.widePadding) / 2,
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}

class BottomRowDark extends StatelessWidget {
  const BottomRowDark({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme.asDark();
    return Row(
      children: [
        const Column(
          children: [
            SurfaceRowDark(),
            SizedBox(height: ColorPage.narrowPadding),
            SurfaceContainerRowDark(),
            SizedBox(height: ColorPage.narrowPadding),
            OnSurfaceRowDark(),
          ],
        ),
        const SizedBox(width: ColorPage.widePadding),
        Column(
          children: [
            const InverseSwatchDark(),
            const SizedBox(height: ColorPage.widePadding + 4),
            Row(
              children: [
                Swatch(
                  role: 'Scrim',
                  token: 'N-0',
                  color: colorScheme.scrim,
                  textColor: colorScheme.asLight().surface,
                  height: ColorPage.shortCell,
                  width: (ColorPage.cellWidth - ColorPage.widePadding) / 2,
                ),
                const SizedBox(width: ColorPage.widePadding),
                Swatch(
                  role: 'Shadow',
                  token: 'N-0',
                  color: colorScheme.shadow,
                  textColor: colorScheme.asLight().surface,
                  height: ColorPage.shortCell,
                  width: (ColorPage.cellWidth - ColorPage.widePadding) / 2,
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}

class InverseSwatchLight extends StatelessWidget {
  const InverseSwatchLight({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme.asLight();
    return Column(
      children: [
        Swatch(
          role: 'Inverse Surface',
          token: 'N-20',
          color: colorScheme.inverseSurface,
          textColor: colorScheme.inverseOnSurface,
          height: 48,
        ),
        Swatch(
          role: 'Inverse On Surface',
          token: 'N-95',
          color: colorScheme.inverseOnSurface,
          textColor: colorScheme.inverseSurface,
          height: ColorPage.shortCell,
        ),
        const SizedBox(height: ColorPage.narrowPadding),
        Swatch(
          role: 'Inverse Primary',
          token: 'P-80',
          color: colorScheme.inversePrimary,
          textColor: colorScheme.onPrimaryContainer,
          height: ColorPage.shortCell,
        ),
      ],
    );
  }
}

class InverseSwatchDark extends StatelessWidget {
  const InverseSwatchDark({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme.asDark();
    return Column(
      children: [
        Swatch(
          role: 'Inverse Surface',
          token: 'N-90',
          color: colorScheme.inverseSurface,
          textColor: colorScheme.inverseOnSurface,
          height: 48,
        ),
        Swatch(
          role: 'Inverse On Surface',
          token: 'N-20',
          color: colorScheme.inverseOnSurface,
          textColor: colorScheme.inverseSurface,
          height: ColorPage.shortCell,
        ),
        const SizedBox(height: ColorPage.narrowPadding),
        Swatch(
          role: 'Inverse Primary',
          token: 'P-40',
          color: colorScheme.inversePrimary,
          textColor: colorScheme.onPrimaryContainer,
          height: ColorPage.shortCell,
        ),
      ],
    );
  }
}

class SurfaceRowLight extends StatelessWidget {
  const SurfaceRowLight({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme.asLight();
    const fullWidth = ColorPage.cellWidth * 3 + ColorPage.narrowPadding * 2;
    return SizedBox(
      width: fullWidth,
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Swatch(
            role: 'Surface Dim',
            token: 'N-87',
            color: colorScheme.surfaceDim,
            textColor: colorScheme.onSurface,
            height: ColorPage.tallCell,
            width: fullWidth / 3,
          ),
          Swatch(
            role: 'Surface',
            token: 'N-98',
            color: colorScheme.surface,
            textColor: colorScheme.onSurface,
            height: ColorPage.tallCell,
            width: fullWidth / 3,
          ),
          Swatch(
            role: 'Surface Bright',
            token: 'N-98',
            color: colorScheme.surfaceBright,
            textColor: colorScheme.onSurface,
            height: ColorPage.tallCell,
            width: fullWidth / 3,
          ),
        ],
      ),
    );
  }
}

class SurfaceRowDark extends StatelessWidget {
  const SurfaceRowDark({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme.asDark();
    const fullWidth = ColorPage.cellWidth * 3 + ColorPage.narrowPadding * 2;
    return SizedBox(
      width: fullWidth,
      child: Row(
        children: [
          Swatch(
            role: 'Surface Dim',
            token: 'N-6',
            color: colorScheme.surfaceDim,
            textColor: colorScheme.onSurface,
            height: ColorPage.tallCell,
            width: fullWidth / 3,
          ),
          Swatch(
            role: 'Surface',
            token: 'N-6',
            color: colorScheme.surface,
            textColor: colorScheme.onSurface,
            height: ColorPage.tallCell,
            width: fullWidth / 3,
          ),
          Swatch(
            role: 'Surface Bright',
            token: 'N-24',
            color: colorScheme.surfaceBright,
            textColor: colorScheme.onSurface,
            height: ColorPage.tallCell,
            width: fullWidth / 3,
          ),
        ],
      ),
    );
  }
}

class SurfaceContainerRowLight extends StatelessWidget {
  const SurfaceContainerRowLight({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme.asLight();
    const fullWidth = ColorPage.cellWidth * 3 + ColorPage.narrowPadding * 2;
    return SizedBox(
      width: fullWidth,
      child: Row(
        children: [
          Swatch(
            role: 'Surface Container Lowest',
            token: 'N-100',
            color: colorScheme.surfaceContainerLowest,
            textColor: colorScheme.onSurface,
            height: ColorPage.tallCell,
            width: fullWidth / 5,
          ),
          Swatch(
            role: 'Surface Container Low',
            token: 'N-96',
            color: colorScheme.surfaceContainerLow,
            textColor: colorScheme.onSurface,
            height: ColorPage.tallCell,
            width: fullWidth / 5,
          ),
          Swatch(
            role: 'Surface Container',
            token: 'N-94',
            color: colorScheme.surfaceContainer,
            textColor: colorScheme.onSurface,
            height: ColorPage.tallCell,
            width: fullWidth / 5,
          ),
          Swatch(
            role: 'Surface Container High',
            token: 'N-92',
            color: colorScheme.surfaceContainerHigh,
            textColor: colorScheme.onSurface,
            height: ColorPage.tallCell,
            width: fullWidth / 5,
          ),
          Swatch(
            role: 'Surface Container Highest',
            token: 'N-90',
            color: colorScheme.surfaceContainerHighest,
            textColor: colorScheme.onSurface,
            height: ColorPage.tallCell,
            width: fullWidth / 5,
          ),
        ],
      ),
    );
  }
}

class SurfaceContainerRowDark extends StatelessWidget {
  const SurfaceContainerRowDark({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme.asDark();
    const fullWidth = ColorPage.cellWidth * 3 + ColorPage.narrowPadding * 2;
    return SizedBox(
      width: fullWidth,
      child: Row(
        children: [
          Swatch(
            role: 'Surface Container Lowest',
            token: 'N-4',
            color: colorScheme.surfaceContainerLowest,
            textColor: colorScheme.onSurface,
            height: ColorPage.tallCell,
            width: fullWidth / 5,
          ),
          Swatch(
            role: 'Surface Container Low',
            token: 'N-10',
            color: colorScheme.surfaceContainerLow,
            textColor: colorScheme.onSurface,
            height: ColorPage.tallCell,
            width: fullWidth / 5,
          ),
          Swatch(
            role: 'Surface Container',
            token: 'N-12  ',
            color: colorScheme.surfaceContainer,
            textColor: colorScheme.onSurface,
            height: ColorPage.tallCell,
            width: fullWidth / 5,
          ),
          Swatch(
            role: 'Surface Container High',
            token: 'N-17',
            color: colorScheme.surfaceContainerHigh,
            textColor: colorScheme.onSurface,
            height: ColorPage.tallCell,
            width: fullWidth / 5,
          ),
          Swatch(
            role: 'Surface Container Highest',
            token: 'N-22',
            color: colorScheme.surfaceContainerHighest,
            textColor: colorScheme.onSurface,
            height: ColorPage.tallCell,
            width: fullWidth / 5,
          ),
        ],
      ),
    );
  }
}

class OnSurfaceRowLight extends StatelessWidget {
  const OnSurfaceRowLight({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme.asLight();
    const fullWidth = ColorPage.cellWidth * 3 + ColorPage.narrowPadding * 2;
    return SizedBox(
      width: fullWidth,
      child: Row(
        children: [
          Swatch(
            role: 'On Surface',
            token: 'N-10',
            color: colorScheme.onSurface,
            textColor: colorScheme.surface,
            height: ColorPage.tallCell,
            width: fullWidth / 4,
          ),
          Swatch(
            role: 'On Surface Variant',
            token: 'NV-30',
            color: colorScheme.onSurfaceVariant,
            textColor: colorScheme.surface,
            height: ColorPage.tallCell,
            width: fullWidth / 4,
          ),
          Swatch(
            role: 'Outline',
            token: 'N-50',
            color: colorScheme.outline,
            textColor: colorScheme.surface,
            height: ColorPage.tallCell,
            width: fullWidth / 4,
          ),
          Swatch(
            role: 'Outline Variant',
            token: 'NV-50',
            color: colorScheme.outlineVariant,
            textColor: colorScheme.inverseSurface,
            height: ColorPage.tallCell,
            width: fullWidth / 4,
          ),
        ],
      ),
    );
  }
}

class OnSurfaceRowDark extends StatelessWidget {
  const OnSurfaceRowDark({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme.asDark();
    const fullWidth = ColorPage.cellWidth * 3 + ColorPage.narrowPadding * 2;
    return SizedBox(
      width: fullWidth,
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Swatch(
            role: 'On Surface',
            token: 'N-90',
            color: colorScheme.onSurface,
            textColor: colorScheme.surface,
            height: ColorPage.tallCell,
            width: fullWidth / 4,
          ),
          Swatch(
            role: 'On Surface Variant',
            token: 'NV-80',
            color: colorScheme.onSurfaceVariant,
            textColor: colorScheme.surface,
            height: ColorPage.tallCell,
            width: fullWidth / 4,
          ),
          Swatch(
            role: 'Outline',
            token: 'N-60',
            color: colorScheme.outline,
            textColor: colorScheme.surface,
            height: ColorPage.tallCell,
            width: fullWidth / 4,
          ),
          Swatch(
            role: 'Outline Variant',
            token: 'NV-30',
            color: colorScheme.outlineVariant,
            textColor: colorScheme.inverseSurface,
            height: ColorPage.tallCell,
            width: fullWidth / 4,
          ),
        ],
      ),
    );
  }
}

class PrimaryLight extends StatelessWidget {
  const PrimaryLight({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme.asLight();
    return Column(
      children: [
        SwatchPair(
          role: 'Primary',
          token: 'P-40',
          onToken: 'P-100',
          color: colorScheme.primary,
          onColor: colorScheme.onPrimary,
        ),
        const SizedBox(height: ColorPage.narrowPadding),
        SwatchPair(
          role: 'Primary Container',
          token: 'P-90',
          onToken: 'P-10',
          color: colorScheme.primaryContainer,
          onColor: colorScheme.onPrimaryContainer,
        ),
      ],
    );
  }
}

class SecondaryLight extends StatelessWidget {
  const SecondaryLight({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme.asLight();
    return Column(
      children: [
        SwatchPair(
          role: 'Secondary',
          token: 'S-40',
          onToken: 'S-100',
          color: colorScheme.secondary,
          onColor: colorScheme.onSecondary,
        ),
        const SizedBox(height: ColorPage.narrowPadding),
        SwatchPair(
          role: 'Secondary Container',
          token: 'S-90',
          onToken: 'S-10',
          color: colorScheme.secondaryContainer,
          onColor: colorScheme.onSecondaryContainer,
        ),
      ],
    );
  }
}

class TertiaryLight extends StatelessWidget {
  const TertiaryLight({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme.asLight();
    return Column(
      children: [
        SwatchPair(
          role: 'Tertiary',
          token: 'T-40',
          onToken: 'T-100',
          color: colorScheme.tertiary,
          onColor: colorScheme.onTertiary,
        ),
        const SizedBox(height: ColorPage.narrowPadding),
        SwatchPair(
          role: 'Tertiary Container',
          token: 'T-90',
          onToken: 'T-10',
          color: colorScheme.tertiaryContainer,
          onColor: colorScheme.onTertiaryContainer,
        ),
      ],
    );
  }
}

class ErrorLight extends StatelessWidget {
  const ErrorLight({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme.asLight();
    return Column(
      children: [
        SwatchPair(
          role: 'Error',
          token: 'E-40',
          onToken: 'E-100',
          color: colorScheme.error,
          onColor: colorScheme.onError,
        ),
        const SizedBox(height: ColorPage.narrowPadding),
        SwatchPair(
          role: 'Error Container',
          token: 'E-90',
          onToken: 'E-10',
          color: colorScheme.errorContainer,
          onColor: colorScheme.onErrorContainer,
        ),
      ],
    );
  }
}

class PrimaryDark extends StatelessWidget {
  const PrimaryDark({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme.asDark();
    return Column(
      children: [
        SwatchPair(
          role: 'Primary',
          token: 'P-80',
          onToken: 'P-20',
          color: colorScheme.primary,
          onColor: colorScheme.onPrimary,
        ),
        const SizedBox(height: ColorPage.narrowPadding),
        SwatchPair(
          role: 'Primary Container',
          token: 'P-30',
          onToken: 'P-90',
          color: colorScheme.primaryContainer,
          onColor: colorScheme.onPrimaryContainer,
        ),
      ],
    );
  }
}

class SecondaryDark extends StatelessWidget {
  const SecondaryDark({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme.asDark();
    return Column(
      children: [
        SwatchPair(
          role: 'Secondary',
          token: 'S-80',
          onToken: 'S-20',
          color: colorScheme.secondary,
          onColor: colorScheme.onSecondary,
        ),
        const SizedBox(height: ColorPage.narrowPadding),
        SwatchPair(
          role: 'Secondary Container',
          token: 'S-30',
          onToken: 'S-90',
          color: colorScheme.secondaryContainer,
          onColor: colorScheme.onSecondaryContainer,
        ),
      ],
    );
  }
}

class TertiaryDark extends StatelessWidget {
  const TertiaryDark({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme.asDark();
    return Column(
      children: [
        SwatchPair(
          role: 'Tertiary',
          token: 'T-80',
          onToken: 'T-20',
          color: colorScheme.tertiary,
          onColor: colorScheme.onTertiary,
        ),
        const SizedBox(height: ColorPage.narrowPadding),
        SwatchPair(
          role: 'Tertiary Container',
          token: 'T-30',
          onToken: 'T-90',
          color: colorScheme.tertiaryContainer,
          onColor: colorScheme.onTertiaryContainer,
        ),
      ],
    );
  }
}

class ErrorDark extends StatelessWidget {
  const ErrorDark({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme.asDark();
    return Column(
      children: [
        SwatchPair(
          role: 'Error',
          token: 'E-80',
          onToken: 'E-20',
          color: colorScheme.error,
          onColor: colorScheme.onError,
        ),
        const SizedBox(height: ColorPage.narrowPadding),
        SwatchPair(
          role: 'Error Container',
          token: 'E-30',
          onToken: 'E-90',
          color: colorScheme.errorContainer,
          onColor: colorScheme.onErrorContainer,
        ),
      ],
    );
  }
}

class SwatchPair extends StatelessWidget {
  const SwatchPair({
    super.key,
    required this.role,
    required this.token,
    required this.onToken,
    required this.color,
    required this.onColor,
  });

  final String role;
  final String token;
  final String onToken;
  final Color color;
  final Color onColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Swatch(
          role: role,
          token: token,
          color: color,
          textColor: onColor,
          height: ColorPage.tallCell,
        ),
        Swatch(
          role: 'On $role',
          token: onToken,
          color: onColor,
          textColor: color,
          height: ColorPage.shortCell,
        ),
      ],
    );
  }
}

class SwatchFixed extends StatelessWidget {
  const SwatchFixed({
    super.key,
    required this.role,
    required this.token,
    required this.dimToken,
    required this.onToken,
    required this.variantToken,
    required this.color,
    required this.dimColor,
    required this.onColor,
    required this.variantColor,
  });

  final String role;
  final String token;
  final String dimToken;
  final String onToken;
  final String variantToken;
  final Color color;
  final Color dimColor;
  final Color onColor;
  final Color variantColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Swatch(
              role: '$role Fixed',
              token: token,
              color: color,
              textColor: onColor,
              height: ColorPage.tallCell,
              width: ColorPage.cellWidth / 2,
            ),
            Swatch(
              role: '$role Fixed Dim',
              token: dimToken,
              color: dimColor,
              textColor: variantColor,
              height: ColorPage.tallCell,
              width: ColorPage.cellWidth / 2,
            ),
          ],
        ),
        Swatch(
          role: 'On $role Fixed',
          token: onToken,
          color: onColor,
          textColor: color,
          height: ColorPage.shortCell,
        ),
        Swatch(
          role: 'On $role Fixed Variant',
          token: variantToken,
          color: variantColor,
          textColor: dimColor,
          height: ColorPage.shortCell,
        ),
      ],
    );
  }
}

class Swatch extends StatelessWidget {
  const Swatch({
    super.key,
    required this.role,
    required this.token,
    required this.color,
    required this.textColor,
    required this.height,
    this.width = ColorPage.cellWidth,
  });

  final String role;
  final String token;
  final Color color;
  final Color textColor;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final font = Theme.of(context).textTheme.labelSmall!;

    const double verticalPadding = 10;
    const double horizontalPadding = 12;

    return Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        color: color,
        child: Stack(
          children: [
            Positioned(
              top: 0.0,
              left: 0.0,
              child: SizedBox(
                width: width - horizontalPadding * 2,
                child: Text(
                  role,
                  style: font.copyWith(color: textColor),
                ),
              ),
            ),
            Positioned(
              bottom: 0.0,
              right: 0.0,
              child: Text(
                token,
                style: font.copyWith(color: textColor),
              ),
            ),
          ],
        ));
  }
}

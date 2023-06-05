import 'package:alternative_material_3/material.dart';

import '../common_scaffold.dart';
import 'styles_overview.dart';

class ElevationPage extends StatelessWidget {
  const ElevationPage({super.key});

  static const String route = '${StylesOverview.route}/elevation';
  static const String label = 'Elevation';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorSchemeLight = theme.colorScheme.asLight();
    final colorSchemeDark = colorSchemeLight.asDark();

    return CommonScaffold(
      title: const Text(label),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Elevation using tone', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
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
            Text('Elevation using tone and shadow',
                style: theme.textTheme.titleLarge),
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
            const SizedBox(height: 32),
            Text('Elevation animations', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            ElevationAnimation(
              colorScheme: colorSchemeLight,
            ),
            const SizedBox(height: 8),
            ElevationAnimation(
              colorScheme: colorSchemeDark,
            ),
          ],
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
                    ElevationCard(
                        elevation: Elevation.level0, hasShadow: hasShadow),
                    const SizedBox(width: 16),
                    ElevationCard(
                        elevation: Elevation.level1, hasShadow: hasShadow),
                    const SizedBox(width: 16),
                    ElevationCard(
                        elevation: Elevation.level2, hasShadow: hasShadow),
                    const SizedBox(width: 16),
                    ElevationCard(
                        elevation: Elevation.level3, hasShadow: hasShadow),
                    const SizedBox(width: 16),
                    ElevationCard(
                        elevation: Elevation.level4, hasShadow: hasShadow),
                    const SizedBox(width: 16),
                    ElevationCard(
                        elevation: Elevation.level5, hasShadow: hasShadow),
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

class ElevationAnimation extends StatefulWidget {
  const ElevationAnimation({
    super.key,
    required this.colorScheme,
  });

  final ColorScheme colorScheme;

  @override
  State<ElevationAnimation> createState() => _ElevationAnimationState();
}

class _ElevationAnimationState extends State<ElevationAnimation>
    with SingleTickerProviderStateMixin {
  Elevation _elevation = Elevation.level0;

  bool _goUp = true;

  bool _dispose = false;

  final pauseDuration = const Duration(milliseconds: 1000);
  final transitionDuration = const Duration(milliseconds: 1500);

  @override
  void initState() {
    super.initState();
    _changeElevation();
  }

  void _changeElevation() {
    if (_dispose) {
      return;
    }
    Future<void>.delayed(pauseDuration).then((_) {
      if (_dispose) {
        return Future.value();
      }
      if (_elevation == Elevation.level0) {
        _goUp = true;
      }
      if (_elevation == Elevation.level5) {
        _goUp = false;
      }
      setState(() {
        if (_goUp) {
          _elevation = _elevation.incr();
        } else {
          _elevation = _elevation.decr();
        }
      });
      return Future.delayed(transitionDuration);
    }).then((_) {
      _changeElevation();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _dispose = true;
  }

  @override
  Widget build(BuildContext context) {
    final outerTheme = Theme.of(context);
    const shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
    );
    return SizedBox(
      height: 48 + 40 + 16 + 128,
      width: 48 + 128 * 6 + 16 * 5,
      child: Theme(
        data: outerTheme.copyWith(colorScheme: widget.colorScheme),
        child: Builder(builder: (context) {
          final theme = Theme.of(context);
          final textTheme = theme.textTheme;
          final colorScheme = theme.colorScheme;
          return Material(
            shape: shape,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          ElevationCard(
                            elevation: _elevation,
                            hasShadow: false,
                            animationDuration: transitionDuration,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Elevation using tone',
                            textAlign: TextAlign.center,
                            style: textTheme.labelLarge
                                .copyWith(color: colorScheme.onSurface),
                          ),
                        ],
                      ),
                      const SizedBox(width: 48),
                      Column(
                        children: [
                          ElevationCard(
                            elevation: _elevation,
                            hasShadow: true,
                            animationDuration: transitionDuration,
                          ),
                          const SizedBox(height: 16),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 128),
                            child: Text(
                              'Elevation using tone and shadow',
                              textAlign: TextAlign.center,
                              style: textTheme.labelLarge
                                  .copyWith(color: colorScheme.onSurface),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class ElevationCard extends StatelessWidget {
  const ElevationCard({
    super.key,
    required this.elevation,
    required this.hasShadow,
    this.animationDuration = kThemeChangeDuration,
  });

  final Elevation elevation;
  final bool hasShadow;
  final Duration animationDuration;

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
        shape: shape,
        shadowColor: hasShadow ? colorScheme.shadow : Colors.transparent,
        elevation: elevation,
        animationDuration: animationDuration,
        child: Center(
          child: AnimatedSwitcher(
            duration: animationDuration,
            switchOutCurve: Curves.easeInOut,
            child:
                Text(key: Key(elevation.label), elevation.label, style: font),
          ),
        ),
      ),
    );
  }
}

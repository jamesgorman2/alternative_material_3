import 'package:alternative_material_3/material.dart';

class ComponentCard extends StatelessWidget {
  const ComponentCard({
    super.key,
    required this.colorScheme,
    required this.child,
  });

  final ColorScheme colorScheme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final outerTheme = Theme.of(context);
    return Theme(
      data: outerTheme.copyWith(
        colorScheme: colorScheme,
        textTheme: outerTheme.textTheme.merge(
          ThemeData.textThemeFor(
            colorScheme: colorScheme,
            typography: outerTheme.typography,
          ),
        ),
      ),
      child: Container(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 800,
            minHeight: 200,
          ),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:alternative_material_3/material.dart';

class LabeledComponentCard extends StatelessWidget {
  const LabeledComponentCard({
    super.key,
    required this.label,
    required this.colorScheme,
    required this.child,
  });

  final String label;
  final ColorScheme colorScheme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 800,
          ),
          child: Container(
            alignment: AlignmentDirectional.topStart,
            padding: const EdgeInsetsDirectional.only(start: 8.0),
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        ComponentCard(
          colorScheme: colorScheme,
          child: child,
        ),
      ],
    );;
  }
}

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
          child: ElevatedCard(
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

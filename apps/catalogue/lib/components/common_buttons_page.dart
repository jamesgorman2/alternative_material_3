import 'package:alternative_material_3/material.dart';

import '../common_scaffold.dart';
import 'component_card.dart';
import 'components_overview.dart';

class CommonButtonsPage extends StatelessWidget {
  const CommonButtonsPage({super.key});

  static const String route = '${ComponentsOverview.route}/common_buttons';
  static const String label = 'Common buttons';

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
          const SizedBox(height: 16.0),
          WideButtonsSample(
            colorScheme: colorSchemeLight,
          ),
          const SizedBox(height: 16.0),
          ButtonsSample(
            colorScheme: colorSchemeDark,
          ),
          const SizedBox(height: 16.0),
          WideButtonsSample(
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
              ElevatedButton(
                onPressed: () {},
                label: const Text('Elevated button'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {},
                label: const Text('Elevated button'),
                icon: const Icon(Icons.add),
              ),
              const SizedBox(height: 36.0),
              FilledButton(
                onPressed: () {},
                label: const Text('Filled button'),
              ),
              const SizedBox(height: 16.0),
              FilledButton(
                onPressed: () {},
                label: const Text('Filled button'),
                icon: const Icon(Icons.add),
              ),
              const SizedBox(height: 36.0),
              FilledTonalButton(
                onPressed: () {},
                label: const Text('Filled tonal button'),
              ),
              const SizedBox(height: 16.0),
              FilledTonalButton(
                onPressed: () {},
                label: const Text('Filled tonal button'),
                icon: const Icon(Icons.add),
              ),
              const SizedBox(height: 36.0),
              OutlinedButton(
                onPressed: () {},
                label: const Text('Outlined button'),
              ),
              const SizedBox(height: 16.0),
              OutlinedButton(
                onPressed: () {},
                label: const Text('Outlined button'),
                icon: const Icon(Icons.add),
              ),
              const SizedBox(height: 36.0),
              TextButton(
                onPressed: () {},
                label: const Text('Text button'),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () {},
                label: const Text('Text button'),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(width: 48.0),
          const Column(
            children: [
              ElevatedButton(
                onPressed: null,
                label: Text('Elevated button'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: null,
                label: Text('Elevated button'),
                icon: Icon(Icons.add),
              ),
              SizedBox(height: 36.0),
              FilledButton(
                onPressed: null,
                label: Text('Filled button'),
              ),
              SizedBox(height: 16.0),
              FilledButton(
                onPressed: null,
                label: Text('Filled button'),
                icon: Icon(Icons.add),
              ),
              SizedBox(height: 36.0),
              FilledTonalButton(
                onPressed: null,
                label: Text('Filled tonal button'),
              ),
              SizedBox(height: 16.0),
              FilledTonalButton(
                onPressed: null,
                label: Text('Filled tonal button'),
                icon: Icon(Icons.add),
              ),
              SizedBox(height: 36.0),
              OutlinedButton(
                onPressed: null,
                label: Text('Outlined button'),
              ),
              SizedBox(height: 16.0),
              OutlinedButton(
                onPressed: null,
                label: Text('Outlined button'),
                icon: Icon(Icons.add),
              ),
              SizedBox(height: 36.0),
              TextButton(
                onPressed: null,
                label: Text('Text button'),
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: null,
                label: Text('Text button'),
                icon: Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WideButtonsSample extends StatelessWidget {
  const WideButtonsSample({
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
          SizedBox(
            width: 250,
            child: ElevatedButton(
              onPressed: () {},
              label: const Text('Elevated button'),
            ),
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: 250,
            child: ElevatedButton(
              onPressed: () {},
              label: const Text('Elevated button'),
              icon: const Icon(Icons.add),
            ),
          ),
          const SizedBox(height: 36.0),
          SizedBox(
            width: 250,
            child: FilledButton(
              onPressed: () {},
              label: const Text('Filled button'),
            ),
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: 250,
            child: FilledButton(
              onPressed: () {},
              label: const Text('Filled button'),
              icon: const Icon(Icons.add),
            ),
          ),
          const SizedBox(height: 36.0),
          SizedBox(
            width: 250,
            child: FilledTonalButton(
              onPressed: () {},
              label: const Text('Filled tonal button'),
            ),
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: 250,
            child: FilledTonalButton(
              onPressed: () {},
              label: const Text('Filled tonal button'),
              icon: const Icon(Icons.add),
            ),
          ),
          const SizedBox(height: 36.0),
          SizedBox(
            width: 250,
            child: OutlinedButton(
              onPressed: () {},
              label: const Text('Outlined button'),
            ),
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: 250,
            child: OutlinedButton(
              onPressed: () {},
              label: const Text('Outlined button'),
              icon: const Icon(Icons.add),
            ),
          ),
          const SizedBox(height: 36.0),
          SizedBox(
            width: 250,
            child: TextButton(
              onPressed: () {},
              label: const Text('Text button'),
            ),
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: 250,
            child: TextButton(
              onPressed: () {},
              label: const Text('Text button'),
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}


import 'package:alternative_material_3/material.dart';

import '../common_scaffold.dart';
import 'styles_overview.dart';

class TypographyPage extends StatelessWidget {
  const TypographyPage({super.key});

  static const String route = '${StylesOverview.route}/typography';
  static const String label = 'Typography';

  @override
  Widget build(BuildContext context) {
    return const CommonScaffold(
      title: Text(label),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Display(),
            SizedBox(height: 16),
            Headline(),
            SizedBox(height: 16),
            Title(),
            SizedBox(height: 16),
            Label(),
            SizedBox(height: 16),
            Body(),
          ],
        ),
      ),
    );
  }
}

class Display extends StatelessWidget {
  const Display({super.key});

  @override
  Widget build(BuildContext context) {
    return TextCard(
      large: Text(
        'Display Large - Roboto 57/64 . -0.25',
        style: Theme.of(context).textTheme.displayLarge,
      ),
      medium: Text(
        'Display Medium - Roboto 45/52 . 0',
        style: Theme.of(context).textTheme.displayMedium,
      ),
      small: Text(
        'Display Small - Roboto 36/44 . 0',
        style: Theme.of(context).textTheme.displaySmall,
      ),
    );
  }
}

class Headline extends StatelessWidget {
  const Headline({super.key});

  @override
  Widget build(BuildContext context) {
    return TextCard(
      large: Text(
        'Headline Large - Roboto 32/40 . 0',
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      medium: Text(
        'Headline Medium - Roboto 28/36 . 0',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      small: Text(
        'Headline Small - Roboto 24/32 . 0',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}

class Title extends StatelessWidget {
  const Title({super.key});

  @override
  Widget build(BuildContext context) {
    return TextCard(
      large: Text(
        'Title Large - Roboto Regular 22/28 . 0',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      medium: Text(
        'Title Medium - Roboto Medium 16/24 . +0.15',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      small: Text(
        'Title Small - Roboto Medium 14/20 . +0.1',
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }
}

class Label extends StatelessWidget {
  const Label({super.key});

  @override
  Widget build(BuildContext context) {
    return TextCard(
      large: Text(
        'Label Large - Roboto Medium 14/20 . +0.1',
        style: Theme.of(context).textTheme.labelLarge,
      ),
      medium: Text(
        'Label Medium - Roboto Medium 12/16 . +0.5',
        style: Theme.of(context).textTheme.labelMedium,
      ),
      small: Text(
        'Label Small - Roboto Medium 11/16 . +0.5',
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return TextCard(
      large: Text(
        'Body Large - Roboto 16/24 . +0.5',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      medium: Text(
        'Body Medium - Roboto 14/20 . +0.25',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      small: Text(
        'Body Small - Roboto 12/16 . +0.4',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}

class TextCard extends StatelessWidget {
  const TextCard({
    super.key,
    required this.large,
    required this.medium,
    required this.small,
  });

  final Text large;
  final Text medium;
  final Text small;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            large,
            const SizedBox(height: 8.0),
            medium,
            const SizedBox(height: 8.0),
            small,
          ],
        ),
      ),
    );
  }
}

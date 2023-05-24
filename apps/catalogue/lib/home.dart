import 'package:alternative_material_3/material.dart';

import 'common_scaffold.dart';

/// The home page of the catalogue
class Home extends StatelessWidget {
  const Home({super.key});

  static const String route = '/';
  static const Icon icon = Icon(Icons.access_time_outlined);
  static const Icon iconSelected = Icon(Icons.access_time_filled);
  static const String label = 'Home';

  @override
  Widget build(BuildContext context) {
    return const CommonScaffold(
      title: Text(label),
      body: Text('Home'),
    );
  }
}

import 'package:alternative_material_3/material.dart';

import '../common_scaffold.dart';
import 'checkbox_page.dart';
import 'list_tile_page.dart';
import 'radio_button_page.dart';
import 'switch_page.dart';

class ComponentsOverview extends StatelessWidget {

  const ComponentsOverview({super.key});

  static const String route = '/components';
  static const Icon icon = Icon(Icons.add_circle_outline);
  static const Icon iconSelected = Icon(Icons.add_circle);
  static const String label = 'Components';

  static Map<String, WidgetBuilder> routes = {
    ComponentsOverview.route: (context) => const ComponentsOverview(),
    CheckboxPage.route: (context) => const CheckboxPage(),
    SwitchPage.route: (context) => const SwitchPage(),
    RadioButtonPage.route: (context) => const RadioButtonPage(),
    ListTilePage.route: (context) => const ListTilePage(),
  };

  @override
  Widget build(BuildContext context) {
    return const CommonScaffold(title: Text(label), body: Placeholder());
  }
}

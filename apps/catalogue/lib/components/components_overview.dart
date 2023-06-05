import 'package:alternative_material_3/material.dart';

import '../common_scaffold.dart';
import 'checkbox_page.dart';
import 'chips_page.dart';
import 'common_buttons_page.dart';
import 'floating_action_button_page.dart';
import 'icon_buttons_page.dart';
import 'list_tile_page.dart';
import 'radio_button_page.dart';
import 'segmented_buttons_page.dart';
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
    ChipsPage.route: (context) => const ChipsPage(),
    CommonButtonsPage.route: (context) => const CommonButtonsPage(),
    FloatingActionButtonPage.route: (context) => const FloatingActionButtonPage(),
    IconButtonsPage.route: (context) => const IconButtonsPage(),
    ListTilePage.route: (context) => const ListTilePage(),
    RadioButtonPage.route: (context) => const RadioButtonPage(),
    SegmentedButtonsPage.route: (context) => const SegmentedButtonsPage(),
    SwitchPage.route: (context) => const SwitchPage(),
  };

  @override
  Widget build(BuildContext context) {
    return const CommonScaffold(title: Text(label), body: Placeholder());
  }
}

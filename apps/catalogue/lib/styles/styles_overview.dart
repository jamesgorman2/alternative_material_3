import 'package:alternative_material_3/material.dart';

import '../common_scaffold.dart';
import 'color_page.dart';
import 'elevation_page.dart';
import 'typography_page.dart';

class StylesOverview extends StatelessWidget {

  const StylesOverview({super.key});
  static const String route = '/styles';
  static const Icon icon = Icon(Icons.palette_outlined);
  static const Icon iconSelected = Icon(Icons.palette);
  static const String label = 'Styles';

  static Map<String, WidgetBuilder> routes = {
    StylesOverview.route: (context) => const StylesOverview(),
    TypographyPage.route: (context) => const TypographyPage(),
    // ColorPage.route: (context) => const ColorPage(),
    // ElevationPage.route: (context) => const ElevationPage(),
  };

  @override
  Widget build(BuildContext context) {
    return const CommonScaffold(title: Text(label), body: Placeholder());
  }
}

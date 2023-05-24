import 'package:alternative_material_3/material.dart';
import 'package:provider/provider.dart';

import 'home.dart';
import 'styles/styles_overview.dart';

class WidgetCatalogue extends StatelessWidget {
  WidgetCatalogue({super.key});

  final ThemeModeNotifier themeMode = ThemeModeNotifier();

  final ColorSeedNotifier colorSeed = ColorSeedNotifier();

  final TextDirectionNotifier textDirection = TextDirectionNotifier();

  final Map<String, WidgetBuilder> _routes = {
    Home.route: (context) => const Home(),
    ...StylesOverview.routes,
  };

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<ColorSeedNotifier>.value(value: colorSeed),
        ListenableProvider<ThemeModeNotifier>.value(value: themeMode),
        ListenableProvider<TextDirectionNotifier>.value(value: textDirection),
      ],
      builder: (context, child) {
        final seedColor = context.watch<ColorSeedNotifier>();
        final themeMode = context.watch<ThemeModeNotifier>();
        final textDirection = context.watch<TextDirectionNotifier>();
        final colorScheme = seedColor.hasColor
            ? ColorScheme.fromSeed(seedColor: seedColor.color!)
            : ColorScheme.light();//m3DefaultLight;

        final ThemeData theme = ThemeData(
          useMaterial3: true,
          colorScheme: colorScheme,
          typography: Typography.material2021(),
        );
        final ThemeData darkTheme = ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.dark(),// colorScheme.asDark(),
          typography: Typography.material2021(),
        );
        return Directionality(
          textDirection: textDirection.direction,
          child: MaterialApp(
            title: 'Alternative Material 3 Widgets Catalogue',
            theme: theme,
            darkTheme: darkTheme,
            themeMode: themeMode.mode,
            routes: _routes,
          ),
        );
      },
    );
  }
}

class ColorSeedNotifier with ChangeNotifier {
  Color? _color;

  Color? get color => _color;

  bool get hasColor => color != null;

  set color(Color? value) {
    if (value != _color) {
      _color = value;
      notifyListeners();
    }
  }
}

class ThemeModeNotifier with ChangeNotifier {
  ThemeMode _mode = ThemeMode.dark;

  ThemeMode get mode => _mode;

  set mode(ThemeMode value) {
    if (value != _mode) {
      _mode = value;
      notifyListeners();
    }
  }
}

class TextDirectionNotifier with ChangeNotifier {
  TextDirection _direction = TextDirection.ltr;

  TextDirection get direction => _direction;

  set direction(TextDirection value) {
    if (value != _direction) {
      _direction = value;
      notifyListeners();
    }
  }
}

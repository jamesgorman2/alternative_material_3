import 'dart:ui' as ui;

import 'package:alternative_material_3/material.dart';
import 'package:provider/provider.dart';

import 'home.dart';
import 'styles/color_page.dart';
import 'styles/elevation_page.dart';
import 'styles/styles_overview.dart';
import 'styles/typography_page.dart';
import 'widget_catalogue.dart';

class CommonScaffold extends StatelessWidget {
  const CommonScaffold({
    super.key,
    required this.title,
    required this.body,
  });

  final Widget title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title,
      ),
      drawer: const AppDrawer(),
      body: body,
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final String? currentRoute = ModalRoute.of(context)?.settings.name;

    bool isCurrentRoute(String route, {bool isHome = false}) {
      return route == currentRoute || (isHome && currentRoute == null);
    }

    void Function() navigateTo(String route, {bool isHome = false}) {
      return () {
        if (!isCurrentRoute(route, isHome: isHome)) {
          Navigator.pushNamed(context, route);
        }
      };
    }

    Widget navTile(
      String label,
      String route, {
      bool isHome = false,
      bool isChildPage = false,
    }) {
      return ListTile(
        title: isChildPage
            ? Padding(
                padding: const EdgeInsets.only(left: 8.0), child: Text(label))
            : Text(label),
        selected: isCurrentRoute(route, isHome: isHome),
        onTap: navigateTo(route, isHome: isHome),
      );
    }

    return Drawer(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            navTile(Home.label, Home.route, isHome: true),
            const Divider(),
            navTile(StylesOverview.label, StylesOverview.route),
            navTile(TypographyPage.label, TypographyPage.route, isChildPage: true),
            // navTile(ColorPage.label, ColorPage.route, isChildPage: true),
            // navTile(ElevationPage.label, ElevationPage.route, isChildPage: true),
          ],
        ),
      ),
    );
  }
}

class ThemeModeButton extends StatelessWidget {
  const ThemeModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final Brightness platformBrightness =
        MediaQuery.platformBrightnessOf(context);
    final themeMode = context.watch<ThemeModeNotifier>();
    final bool useDarkTheme = themeMode.mode == ThemeMode.dark ||
        (themeMode.mode == ThemeMode.system &&
            platformBrightness == ui.Brightness.dark);
    return IconButton.outlined(
      onPressed: () {},
      icon: Icon(
        useDarkTheme ? Icons.sunny : Icons.mood,
      ),
    );
  }
}

class ColorSeedButton extends StatelessWidget {
  const ColorSeedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton.outlined(
      onPressed: () {},
      icon: const Icon(Icons.colorize_outlined),
    );
  }
}

class TextDirectionButton extends StatelessWidget {
  const TextDirectionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final textDirection = context.watch<TextDirectionNotifier>();
    return IconButton.outlined(
      onPressed: () {
        if (textDirection.direction == TextDirection.ltr) {
          textDirection.direction = TextDirection.rtl;
        } else {
          textDirection.direction = TextDirection.ltr;
        }
      },
      icon: Icon(textDirection.direction == TextDirection.ltr
          ? Icons.format_textdirection_l_to_r_outlined
          : Icons.format_textdirection_r_to_l_outlined),
    );
  }
}

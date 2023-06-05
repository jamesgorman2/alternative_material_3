import 'dart:ui' as ui;

import 'package:alternative_material_3/material.dart';
import 'package:provider/provider.dart';

import 'components/checkbox_page.dart';
import 'components/chips_page.dart';
import 'components/common_buttons_page.dart';
import 'components/components_overview.dart';
import 'components/floating_action_button_page.dart';
import 'components/icon_buttons_page.dart';
import 'components/list_tile_page.dart';
import 'components/radio_button_page.dart';
import 'components/segmented_buttons_page.dart';
import 'components/switch_page.dart';
import 'home.dart';
import 'styles/color_page.dart';
import 'styles/elevation_page.dart';
import 'styles/styles_overview.dart';
import 'styles/typography_page.dart';
import 'widget_catalogue.dart';

class CommonScaffold extends StatefulWidget {
  const CommonScaffold({
    super.key,
    required this.title,
    required this.body,
  });

  final Widget title;
  final Widget body;

  @override
  State<CommonScaffold> createState() => _CommonScaffoldState();
}

class _CommonScaffoldState extends State<CommonScaffold> {

  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = context.watch<TextDirectionNotifier>();

    return Directionality(
      textDirection: textDirection.direction,
      child: Scaffold(
        appBar: AppBar(
          title: widget.title,
        ),
        drawer: const AppDrawer(),
        // floatingActionButton: ExpandableFloatingActionButton(
        //   primaryFab: ExpandableFloatingActionButtonEntry(
        //     icon: const Icon(Icons.navigation_outlined),
        //     label: const Text('Navigate'),
        //     onPressed: (){},
        //   ),
        //   supportingFabs: [
        //     ExpandableFloatingActionButtonEntry(
        //       icon: const Icon(Icons.location_searching_outlined),
        //       onPressed: (){},
        //     ),
        //     ExpandableFloatingActionButtonEntry(
        //       icon: const Icon(Icons.search_outlined),
        //       onPressed: (){},
        //     ),
        //   ],
        //
        // ),
        body: SizedBox(
          width: double.infinity,
          child: Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (context) => ControlledScroll(
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16.0),
                    child: widget.body,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@immutable
class ControlledScroll extends InheritedWidget {
  const ControlledScroll({super.key, required super.child, required this.controller});

  final ScrollController controller;

  static ScrollController? of(BuildContext context) {
    final ControlledScroll? inheritedTheme =
    context.dependOnInheritedWidgetOfExactType<ControlledScroll>();
    return inheritedTheme?.controller;
  }

  @override
  bool updateShouldNotify(ControlledScroll oldWidget) =>
      oldWidget.controller != controller;
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
        headline: isChildPage
            ? Padding(
                padding: const EdgeInsets.only(left: 8.0), child: Text(label))
            : Text(label),
        selected: isCurrentRoute(route, isHome: isHome),
        onTap: navigateTo(route, isHome: isHome),
      );
    }

    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              navTile(Home.label, Home.route, isHome: true),
              const Divider(),
              navTile(StylesOverview.label, StylesOverview.route),
              navTile(TypographyPage.label, TypographyPage.route,
                  isChildPage: true),
              navTile(ColorPage.label, ColorPage.route, isChildPage: true),
              navTile(ElevationPage.label, ElevationPage.route,
                  isChildPage: true),
              const Divider(),
              navTile(ComponentsOverview.label, ComponentsOverview.route),
              navTile(CheckboxPage.label, CheckboxPage.route,
                  isChildPage: true),
              navTile(ChipsPage.label, ChipsPage.route, isChildPage: true),
              navTile(CommonButtonsPage.label, CommonButtonsPage.route,
                  isChildPage: true),
              navTile(IconButtonsPage.label, IconButtonsPage.route,
                  isChildPage: true),
              navTile(FloatingActionButtonPage.label, FloatingActionButtonPage.route,
                  isChildPage: true),
              navTile(ListTilePage.label, ListTilePage.route,
                  isChildPage: true),
              navTile(RadioButtonPage.label, RadioButtonPage.route,
                  isChildPage: true),
              navTile(SegmentedButtonsPage.label, SegmentedButtonsPage.route,
                  isChildPage: true),
              navTile(SwitchPage.label, SwitchPage.route, isChildPage: true),
            ],
          ),
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
    return OutlinedIconButton(
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
    return OutlinedIconButton(
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
    return OutlinedIconButton(
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

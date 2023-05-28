// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:alternative_material_3/material.dart';
import 'package:alternative_material_3/src/state_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Theme data control test', () {
    final ThemeData dark = ThemeData.dark();

    expect(dark, hasOneLineDescription);
    expect(dark, equals(dark.copyWith()));
    expect(dark.hashCode, equals(dark.copyWith().hashCode));

    final ThemeData light = ThemeData.light();
    final ThemeData dawn = ThemeData.lerp(dark, light, 0.25);

    expect(dawn.brightness, Brightness.dark);
    expect(dawn.colorScheme.primary, Color.lerp(dark.colorScheme.primary, light.colorScheme.primary, 0.25));
  });

  test('Defaults to the default typography for the platform', () {
    for (final TargetPlatform platform in TargetPlatform.values) {
      final ThemeData theme = ThemeData(platform: platform);
      final Typography typography = Typography.material2021(platform: platform);
      expect(
        theme.textTheme,
        typography.black.apply(decoration: TextDecoration.none),
        reason: 'Not using default typography for $platform',
      );
    }
  });

  test('Default text theme contrasts with brightness', () {
    final ThemeData lightTheme = ThemeData.light();
    final ThemeData darkTheme = ThemeData.dark();
    final Typography typography = Typography.material2021(platform: lightTheme.platform);

    expect(lightTheme.textTheme.titleLarge.color, typography.black.titleLarge.color);
    expect(darkTheme.textTheme.titleLarge.color, typography.white.titleLarge.color);
  });

  test('Default primary text theme contrasts with primary brightness', () {
    final ThemeData lightTheme = ThemeData.light();
    final ThemeData darkTheme = ThemeData.dark();
    final Typography typography = Typography.material2021(platform: lightTheme.platform);

    expect(lightTheme.textTheme.titleLarge.color, typography.black.titleLarge.color);
    expect(darkTheme.textTheme.titleLarge.color, typography.white.titleLarge.color);
  });

  test('Default icon theme contrasts with brightness', () {
    final ThemeData lightTheme = ThemeData.light();
    final ThemeData darkTheme = ThemeData.dark();
    final Typography typography = Typography.material2021(platform: lightTheme.platform);

    expect(lightTheme.textTheme.titleLarge.color, typography.black.titleLarge.color);
    expect(darkTheme.textTheme.titleLarge.color, typography.white.titleLarge.color);
  });

  test('Default primary icon theme contrasts with primary brightness', () {
    final ThemeData lightTheme = ThemeData(colorScheme: ColorScheme.m3DefaultLight.copyWith(primary: Colors.white));
    final ThemeData darkTheme = ThemeData(colorScheme: ColorScheme.m3DefaultDark.copyWith(primary: Colors.black));
    final Typography typography = Typography.material2021(platform: lightTheme.platform);

    expect(lightTheme.textTheme.titleLarge.color, typography.black.titleLarge.color);
    expect(darkTheme.textTheme.titleLarge.color, typography.white.titleLarge.color);
  });

  test('light, dark and fallback constructors support useMaterial3', () {
    final ThemeData lightTheme = ThemeData.light();
    
    expect(lightTheme.typography, Typography.material2021(colorScheme: lightTheme.colorScheme));

    final ThemeData darkTheme = ThemeData.dark();
    
    expect(darkTheme.typography, Typography.material2021(colorScheme: darkTheme.colorScheme));

    final ThemeData fallbackTheme = ThemeData.light();
    
    expect(fallbackTheme.typography, Typography.material2021(colorScheme: fallbackTheme.colorScheme));
  });

  testWidgets('Defaults to MaterialTapTargetBehavior.padded on mobile platforms and MaterialTapTargetBehavior.shrinkWrap on desktop', (WidgetTester tester) async {
    final ThemeData themeData = ThemeData(platform: defaultTargetPlatform);
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.iOS:
        expect(themeData.materialTapTargetSize, MaterialTapTargetSize.padded);
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        expect(themeData.materialTapTargetSize, MaterialTapTargetSize.shrinkWrap);
    }
  }, variant: TargetPlatformVariant.all());

  test('Can estimate brightness - directly', () {
    expect(ThemeData.estimateBrightnessForColor(Colors.white), equals(Brightness.light));
    expect(ThemeData.estimateBrightnessForColor(Colors.black), equals(Brightness.dark));
    expect(ThemeData.estimateBrightnessForColor(Colors.blue), equals(Brightness.dark));
    expect(ThemeData.estimateBrightnessForColor(Colors.yellow), equals(Brightness.light));
    expect(ThemeData.estimateBrightnessForColor(Colors.deepOrange), equals(Brightness.dark));
    expect(ThemeData.estimateBrightnessForColor(Colors.orange), equals(Brightness.light));
    expect(ThemeData.estimateBrightnessForColor(Colors.lime), equals(Brightness.light));
    expect(ThemeData.estimateBrightnessForColor(Colors.grey), equals(Brightness.light));
    expect(ThemeData.estimateBrightnessForColor(Colors.teal), equals(Brightness.dark));
    expect(ThemeData.estimateBrightnessForColor(Colors.indigo), equals(Brightness.dark));
  });

  test('cursorColor', () {
    expect(const TextSelectionThemeData(cursorColor: Colors.red).cursorColor, Colors.red);
  });

  test('ThemeData.light() can generate a default M3 light colorScheme when useMaterial3 is true', () {
    final ThemeData theme = ThemeData.light();
    expect(theme.colorScheme, ColorScheme.m3DefaultLight);
  });


  test('ThemeData.dark() can generate a default M3 dark colorScheme when useMaterial3 is true', () {
    final ThemeData theme = ThemeData.dark();
    expect(theme.colorScheme, ColorScheme.m3DefaultDark);
  });

  testWidgets('splashFactory is InkSparkle only for Android non-web when useMaterial3 is true', (WidgetTester tester) async {
    final ThemeData theme = ThemeData();

    // Basic check that this theme is in fact using material 3.
    

    switch (debugDefaultTargetPlatformOverride!) {
      case TargetPlatform.android:
        if (kIsWeb) {
          expect(theme.splashFactory, equals(InkRipple.splashFactory));
        } else {
          expect(theme.splashFactory, equals(InkSparkle.splashFactory));
        }
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        expect(theme.splashFactory, equals(InkRipple.splashFactory));
     }
  }, variant: TargetPlatformVariant.all());

  testWidgets('VisualDensity.adaptivePlatformDensity returns adaptive values', (WidgetTester tester) async {
    switch (debugDefaultTargetPlatformOverride!) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        expect(VisualDensity.adaptivePlatformDensity, equals(VisualDensity.standard));
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        expect(VisualDensity.adaptivePlatformDensity, equals(VisualDensity.compact));
    }
  }, variant: TargetPlatformVariant.all());

  testWidgets('VisualDensity.getDensityForPlatform returns adaptive values', (WidgetTester tester) async {
    switch (debugDefaultTargetPlatformOverride!) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        expect(VisualDensity.defaultDensityForPlatform(debugDefaultTargetPlatformOverride!), equals(VisualDensity.standard));
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        expect(VisualDensity.defaultDensityForPlatform(debugDefaultTargetPlatformOverride!), equals(VisualDensity.compact));
    }
  }, variant: TargetPlatformVariant.all());

  testWidgets('VisualDensity in ThemeData defaults to "compact" on desktop and "standard" on mobile', (WidgetTester tester) async {
    final ThemeData themeData = ThemeData();
    switch (debugDefaultTargetPlatformOverride!) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        expect(themeData.visualDensity, equals(VisualDensity.standard));
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        expect(themeData.visualDensity, equals(VisualDensity.compact));
    }
  }, variant: TargetPlatformVariant.all());

  testWidgets('VisualDensity in ThemeData defaults to the right thing when a platform is supplied to it', (WidgetTester tester) async {
    final ThemeData themeData = ThemeData(platform: debugDefaultTargetPlatformOverride! == TargetPlatform.android ? TargetPlatform.linux : TargetPlatform.android);
    switch (debugDefaultTargetPlatformOverride!) {
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        expect(themeData.visualDensity, equals(VisualDensity.standard));
      case TargetPlatform.android:
        expect(themeData.visualDensity, equals(VisualDensity.compact));
    }
  }, variant: TargetPlatformVariant.all());

  testWidgets('Ensure Visual Density effective constraints are clamped', (WidgetTester tester) async {
    const BoxConstraints square = BoxConstraints.tightFor(width: 35, height: 35);
    BoxConstraints expanded = const VisualDensity(horizontal: 4.0, vertical: 4.0).effectiveConstraints(square);
    expect(expanded.minWidth, equals(35));
    expect(expanded.minHeight, equals(35));
    expect(expanded.maxWidth, equals(35));
    expect(expanded.maxHeight, equals(35));

    BoxConstraints contracted = const VisualDensity(horizontal: -4.0, vertical: -4.0).effectiveConstraints(square);
    expect(contracted.minWidth, equals(19));
    expect(contracted.minHeight, equals(19));
    expect(expanded.maxWidth, equals(35));
    expect(expanded.maxHeight, equals(35));

    const BoxConstraints small = BoxConstraints.tightFor(width: 4, height: 4);
    expanded = const VisualDensity(horizontal: 4.0, vertical: 4.0).effectiveConstraints(small);
    expect(expanded.minWidth, equals(4));
    expect(expanded.minHeight, equals(4));
    expect(expanded.maxWidth, equals(4));
    expect(expanded.maxHeight, equals(4));

    contracted = const VisualDensity(horizontal: -4.0, vertical: -4.0).effectiveConstraints(small);
    expect(contracted.minWidth, equals(0));
    expect(contracted.minHeight, equals(0));
    expect(expanded.maxWidth, equals(4));
    expect(expanded.maxHeight, equals(4));
  });

  testWidgets('Ensure Visual Density effective constraints expand and contract', (WidgetTester tester) async {
    const BoxConstraints square = BoxConstraints();
    final BoxConstraints expanded = const VisualDensity(horizontal: 4.0, vertical: 4.0).effectiveConstraints(square);
    expect(expanded.minWidth, equals(16));
    expect(expanded.minHeight, equals(16));
    expect(expanded.maxWidth, equals(double.infinity));
    expect(expanded.maxHeight, equals(double.infinity));

    final BoxConstraints contracted = const VisualDensity(horizontal: -4.0, vertical: -4.0).effectiveConstraints(square);
    expect(contracted.minWidth, equals(0));
    expect(contracted.minHeight, equals(0));
    expect(expanded.maxWidth, equals(double.infinity));
    expect(expanded.maxHeight, equals(double.infinity));
  });

  group('Theme extensions', () {
    const Key containerKey = Key('container');

    testWidgets('can be obtained', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: const <ThemeExtension<dynamic>>{
              MyThemeExtensionA(
                color1: Colors.black,
                color2: Colors.amber,
              ),
              MyThemeExtensionB(
                textStyle: TextStyle(fontSize: 50),
              ),
            },
          ),
          home: Container(key: containerKey),
        ),
      );

      final ThemeData theme = Theme.of(
        tester.element(find.byKey(containerKey)),
      );

      expect(theme.extension<MyThemeExtensionA>()!.color1, Colors.black);
      expect(theme.extension<MyThemeExtensionA>()!.color2, Colors.amber);
      expect(theme.extension<MyThemeExtensionB>()!.textStyle, const TextStyle(fontSize: 50));
    });

    testWidgets('can use copyWith', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>{
              const MyThemeExtensionA(
                color1: Colors.black,
                color2: Colors.amber,
              ).copyWith(color1: Colors.blue),
            },
          ),
          home: Container(key: containerKey),
        ),
      );

      final ThemeData theme = Theme.of(
        tester.element(find.byKey(containerKey)),
      );

      expect(theme.extension<MyThemeExtensionA>()!.color1, Colors.blue);
      expect(theme.extension<MyThemeExtensionA>()!.color2, Colors.amber);
    });

    testWidgets('can lerp', (WidgetTester tester) async {
      const MyThemeExtensionA extensionA1 = MyThemeExtensionA(
        color1: Colors.black,
        color2: Colors.amber,
      );
      const MyThemeExtensionA extensionA2 = MyThemeExtensionA(
        color1: Colors.white,
        color2: Colors.blue,
      );
      const MyThemeExtensionB extensionB1 = MyThemeExtensionB(
        textStyle: TextStyle(fontSize: 50),
      );
      const MyThemeExtensionB extensionB2 = MyThemeExtensionB(
        textStyle: TextStyle(fontSize: 100),
      );

      // Both ThemeData arguments include both extensions.
      ThemeData lerped = ThemeData.lerp(
        ThemeData(
          extensions: const <ThemeExtension<dynamic>>[
            extensionA1,
            extensionB1,
          ],
        ),
        ThemeData(
          extensions: const <ThemeExtension<dynamic>>{
            extensionA2,
            extensionB2,
          },
        ),
        0.5,
      );

      expect(lerped.extension<MyThemeExtensionA>()!.color1, const Color(0xff7f7f7f));
      expect(lerped.extension<MyThemeExtensionA>()!.color2, const Color(0xff90ab7d));
      expect(lerped.extension<MyThemeExtensionB>()!.textStyle, const TextStyle(fontSize: 75));

      // Missing from 2nd ThemeData
      lerped = ThemeData.lerp(
        ThemeData(
          extensions: const <ThemeExtension<dynamic>>{
            extensionA1,
            extensionB1,
          },
        ),
        ThemeData(
          extensions: const <ThemeExtension<dynamic>>{
            extensionB2,
          },
        ),
        0.5,
      );
      expect(lerped.extension<MyThemeExtensionA>()!.color1, Colors.black); // Not lerped
      expect(lerped.extension<MyThemeExtensionA>()!.color2, Colors.amber); // Not lerped
      expect(lerped.extension<MyThemeExtensionB>()!.textStyle, const TextStyle(fontSize: 75));

      // Missing from 1st ThemeData
      lerped = ThemeData.lerp(
        ThemeData(
          extensions: const <ThemeExtension<dynamic>>{
            extensionA1,
          },
        ),
        ThemeData(
          extensions: const <ThemeExtension<dynamic>>{
            extensionA2,
            extensionB2,
          },
        ),
        0.5,
      );
      expect(lerped.extension<MyThemeExtensionA>()!.color1, const Color(0xff7f7f7f));
      expect(lerped.extension<MyThemeExtensionA>()!.color2, const Color(0xff90ab7d));
      expect(lerped.extension<MyThemeExtensionB>()!.textStyle, const TextStyle(fontSize: 100)); // Not lerped
    });

    testWidgets('should return null on extension not found', (WidgetTester tester) async {
      final ThemeData theme = ThemeData(
        extensions: const <ThemeExtension<dynamic>>{},
      );

      expect(theme.extension<MyThemeExtensionA>(), isNull);
    });
  });

  test('copyWith, ==, hashCode basics', () {
    expect(ThemeData(), ThemeData().copyWith());
    expect(ThemeData().hashCode, ThemeData().copyWith().hashCode);
  });

  testWidgets('ThemeData.copyWith correctly creates new ThemeData with all copied arguments', (WidgetTester tester) async {
    final SliderThemeData sliderTheme = SliderThemeData.fromPrimaryColors(
      primaryColor: Colors.black,
      primaryColorDark: Colors.black,
      primaryColorLight: Colors.black,
      valueIndicatorTextStyle: const TextStyle(color: Colors.black),
    );

    final ChipThemeData chipTheme = ChipThemeData.fromDefaults(
      primaryColor: Colors.black,
      secondaryColor: Colors.white,
      labelStyle: const TextStyle(color: Colors.black),
    );

    const PageTransitionsTheme pageTransitionTheme = PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      },
    );

    final ThemeData theme = ThemeData.raw(
      // For the sanity of the reader, make sure these properties are in the same
      // order everywhere that they are separated by section comments (e.g.
      // GENERAL CONFIGURATION). Each section except for deprecations should be
      // alphabetical by symbol name.

      // GENERAL CONFIGURATION
      cupertinoOverrideTheme: null,
      extensions: const <Object, ThemeExtension<dynamic>>{},
      inputDecorationTheme: ThemeData.dark().inputDecorationTheme.copyWith(border: const OutlineInputBorder()),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      pageTransitionsTheme: pageTransitionTheme,
      platform: TargetPlatform.iOS,
      scrollbarTheme: const ScrollbarThemeData(radius: Radius.circular(10.0)),
      splashFactory: InkRipple.splashFactory,
      visualDensity: VisualDensity.standard,
      // COLOR
      colorScheme: ColorScheme.m3DefaultLight,
      stateTheme: const StateThemeData(),
      // TYPOGRAPHY & ICONOGRAPHY
      iconTheme: ThemeData.dark().iconTheme,
      textTheme: ThemeData.dark().textTheme,
      typography: Typography.material2021(),
      // COMPONENT THEMES
      actionIconTheme: const ActionIconThemeData(),
      appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
      badgeTheme: const BadgeThemeData(backgroundColor: Colors.black),
      bannerTheme: const MaterialBannerThemeData(backgroundColor: Colors.black),
      bottomAppBarTheme: const BottomAppBarTheme(color: Colors.black),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(type: BottomNavigationBarType.fixed),
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.black),
      buttonBarTheme: const ButtonBarThemeData(alignment: MainAxisAlignment.start),
      cardTheme: const CardTheme(color: Colors.black),
      checkboxTheme: const CheckboxThemeData(),
      chipTheme: chipTheme,
      dataTableTheme: const DataTableThemeData(),
      datePickerTheme: const DatePickerThemeData(),
      dialogTheme: const DialogTheme(backgroundColor: Colors.black),
      dividerTheme: const DividerThemeData(color: Colors.black),
      drawerTheme: const DrawerThemeData(),
      dropdownMenuTheme: const DropdownMenuThemeData(),
      elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(backgroundColor: Colors.green)),
      expansionTileTheme: const ExpansionTileThemeData(backgroundColor: Colors.black),
      filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(foregroundColor: Colors.green)),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Colors.black),
      iconButtonTheme: IconButtonThemeData(style: IconButton.styleFrom(foregroundColor: Colors.pink)),
      listTileTheme: const ListTileThemeData(),
      menuBarTheme: const MenuBarThemeData(style: MenuStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.black))),
      menuButtonTheme: MenuButtonThemeData(style: MenuItemButton.styleFrom(backgroundColor: Colors.black)),
      menuTheme: const MenuThemeData(style: MenuStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.black))),
      navigationBarTheme: const NavigationBarThemeData(backgroundColor: Colors.black),
      navigationDrawerTheme: const NavigationDrawerThemeData(backgroundColor: Colors.black),
      navigationRailTheme: const NavigationRailThemeData(backgroundColor: Colors.black),
      outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(foregroundColor: Colors.blue)),
      popupMenuTheme: const PopupMenuThemeData(color: Colors.black),
      progressIndicatorTheme: const ProgressIndicatorThemeData(),
      radioTheme: const RadioThemeData(),
      searchBarTheme: const SearchBarThemeData(),
      searchViewTheme: const SearchViewThemeData(),
      segmentedButtonTheme: const SegmentedButtonThemeData(),
      sliderTheme: sliderTheme,
      snackBarTheme: const SnackBarThemeData(backgroundColor: Colors.black),
      switchTheme: const SwitchThemeData(),
      tabBarTheme: const TabBarTheme(labelColor: Colors.black),
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: Colors.red)),
      textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.black),
      timePickerTheme: const TimePickerThemeData(backgroundColor: Colors.black),
      toggleButtonsTheme: const ToggleButtonsThemeData(textStyle: TextStyle(color: Colors.black)),
      tooltipTheme: const TooltipThemeData(height: 100),
    );

    final SliderThemeData otherSliderTheme = SliderThemeData.fromPrimaryColors(
      primaryColor: Colors.white,
      primaryColorDark: Colors.white,
      primaryColorLight: Colors.white,
      valueIndicatorTextStyle: const TextStyle(color: Colors.white),
    );

    final ChipThemeData otherChipTheme = ChipThemeData.fromDefaults(
      primaryColor: Colors.white,
      secondaryColor: Colors.black,
      labelStyle: const TextStyle(color: Colors.white),
    );

    final ThemeData otherTheme = ThemeData.raw(
      // For the sanity of the reader, make sure these properties are in the same
      // order everywhere that they are separated by section comments (e.g.
      // GENERAL CONFIGURATION). Each section except for deprecations should be
      // alphabetical by symbol name.

      // GENERAL CONFIGURATION
      cupertinoOverrideTheme: ThemeData.light().cupertinoOverrideTheme,
      extensions: const <Object, ThemeExtension<dynamic>>{
        MyThemeExtensionB: MyThemeExtensionB(textStyle: TextStyle()),
      },
      inputDecorationTheme: ThemeData.light().inputDecorationTheme.copyWith(border: InputBorder.none),
      materialTapTargetSize: MaterialTapTargetSize.padded,
      pageTransitionsTheme: const PageTransitionsTheme(),
      platform: TargetPlatform.android,
      scrollbarTheme: const ScrollbarThemeData(radius: Radius.circular(10.0)),
      splashFactory: InkRipple.splashFactory,
      
      visualDensity: VisualDensity.standard,
      // COLOR
      colorScheme: ColorScheme.m3DefaultLight,
      stateTheme: const StateThemeData(
        hoverOpacity: 0.1,
        disabledOpacity: 0.1,
        dragOpacity: 0.1,
        focusOpacity: 0.1,
        pressOpacity: 0.1,
      ),
      // TYPOGRAPHY & ICONOGRAPHY
      iconTheme: ThemeData.light().iconTheme,
      textTheme: ThemeData.light().textTheme,
      typography: Typography.material2021(platform: TargetPlatform.iOS),

      // COMPONENT THEMES
      actionIconTheme: const ActionIconThemeData(),
      appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
      badgeTheme: const BadgeThemeData(backgroundColor: Colors.black),
      bannerTheme: const MaterialBannerThemeData(backgroundColor: Colors.white),
      bottomAppBarTheme: const BottomAppBarTheme(color: Colors.white),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(type: BottomNavigationBarType.shifting),
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.white),
      buttonBarTheme: const ButtonBarThemeData(alignment: MainAxisAlignment.end),
      cardTheme: const CardTheme(color: Colors.white),
      checkboxTheme: const CheckboxThemeData(),
      chipTheme: otherChipTheme,
      dataTableTheme: const DataTableThemeData(),
      datePickerTheme: const DatePickerThemeData(backgroundColor: Colors.amber),
      dialogTheme: const DialogTheme(backgroundColor: Colors.white),
      dividerTheme: const DividerThemeData(color: Colors.white),
      drawerTheme: const DrawerThemeData(),
      dropdownMenuTheme: const DropdownMenuThemeData(),
      elevatedButtonTheme: const ElevatedButtonThemeData(),
      expansionTileTheme: const ExpansionTileThemeData(backgroundColor: Colors.black),
      filledButtonTheme: const FilledButtonThemeData(),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Colors.white),
      iconButtonTheme: const IconButtonThemeData(),
      listTileTheme: const ListTileThemeData(),
      menuBarTheme: const MenuBarThemeData(style: MenuStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.white))),
      menuButtonTheme: MenuButtonThemeData(style: MenuItemButton.styleFrom(backgroundColor: Colors.black)),
      menuTheme: const MenuThemeData(style: MenuStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.white))),
      navigationBarTheme: const NavigationBarThemeData(backgroundColor: Colors.white),
      navigationDrawerTheme: const NavigationDrawerThemeData(backgroundColor: Colors.white),
      navigationRailTheme: const NavigationRailThemeData(backgroundColor: Colors.white),
      outlinedButtonTheme: const OutlinedButtonThemeData(),
      popupMenuTheme: const PopupMenuThemeData(color: Colors.white),
      progressIndicatorTheme: const ProgressIndicatorThemeData(),
      radioTheme: const RadioThemeData(),
      searchBarTheme: const SearchBarThemeData(),
      searchViewTheme: const SearchViewThemeData(),
      segmentedButtonTheme: const SegmentedButtonThemeData(),
      sliderTheme: otherSliderTheme,
      snackBarTheme: const SnackBarThemeData(backgroundColor: Colors.white),
      switchTheme: const SwitchThemeData(),
      tabBarTheme: const TabBarTheme(labelColor: Colors.white),
      textButtonTheme: const TextButtonThemeData(),
      textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.white),
      timePickerTheme: const TimePickerThemeData(backgroundColor: Colors.white),
      toggleButtonsTheme: const ToggleButtonsThemeData(textStyle: TextStyle(color: Colors.white)),
      tooltipTheme: const TooltipThemeData(height: 100),
    );

    final ThemeData themeDataCopy = theme.copyWith(
      // For the sanity of the reader, make sure these properties are in the same
      // order everywhere that they are separated by section comments (e.g.
      // GENERAL CONFIGURATION). Each section except for deprecations should be
      // alphabetical by symbol name.

      // GENERAL CONFIGURATION
      cupertinoOverrideTheme: otherTheme.cupertinoOverrideTheme,
      extensions: otherTheme.extensions.values,
      inputDecorationTheme: otherTheme.inputDecorationTheme,
      materialTapTargetSize: otherTheme.materialTapTargetSize,
      pageTransitionsTheme: otherTheme.pageTransitionsTheme,
      platform: otherTheme.platform,
      scrollbarTheme: otherTheme.scrollbarTheme,
      splashFactory: otherTheme.splashFactory,
      visualDensity: otherTheme.visualDensity,

      // COLOR
      colorScheme: otherTheme.colorScheme,
      stateTheme: otherTheme.stateTheme,
      // TYPOGRAPHY & ICONOGRAPHY
      iconTheme: otherTheme.iconTheme,
      textTheme: otherTheme.textTheme,
      typography: otherTheme.typography,

      // COMPONENT THEMES
      actionIconTheme: otherTheme.actionIconTheme,
      appBarTheme: otherTheme.appBarTheme,
      badgeTheme: otherTheme.badgeTheme,
      bannerTheme: otherTheme.bannerTheme,
      bottomAppBarTheme: otherTheme.bottomAppBarTheme,
      bottomNavigationBarTheme: otherTheme.bottomNavigationBarTheme,
      bottomSheetTheme: otherTheme.bottomSheetTheme,
      buttonBarTheme: otherTheme.buttonBarTheme,
      cardTheme: otherTheme.cardTheme,
      checkboxTheme: otherTheme.checkboxTheme,
      chipTheme: otherTheme.chipTheme,
      dataTableTheme: otherTheme.dataTableTheme,
      dialogTheme: otherTheme.dialogTheme,
      datePickerTheme: otherTheme.datePickerTheme,
      dividerTheme: otherTheme.dividerTheme,
      drawerTheme: otherTheme.drawerTheme,
      elevatedButtonTheme: otherTheme.elevatedButtonTheme,
      expansionTileTheme: otherTheme.expansionTileTheme,
      filledButtonTheme: otherTheme.filledButtonTheme,
      floatingActionButtonTheme: otherTheme.floatingActionButtonTheme,
      iconButtonTheme: otherTheme.iconButtonTheme,
      listTileTheme: otherTheme.listTileTheme,
      menuBarTheme: otherTheme.menuBarTheme,
      menuButtonTheme: otherTheme.menuButtonTheme,
      menuTheme: otherTheme.menuTheme,
      navigationBarTheme: otherTheme.navigationBarTheme,
      navigationDrawerTheme: otherTheme.navigationDrawerTheme,
      navigationRailTheme: otherTheme.navigationRailTheme,
      outlinedButtonTheme: otherTheme.outlinedButtonTheme,
      popupMenuTheme: otherTheme.popupMenuTheme,
      progressIndicatorTheme: otherTheme.progressIndicatorTheme,
      radioTheme: otherTheme.radioTheme,
      searchBarTheme: otherTheme.searchBarTheme,
      searchViewTheme: otherTheme.searchViewTheme,
      sliderTheme: otherTheme.sliderTheme,
      snackBarTheme: otherTheme.snackBarTheme,
      switchTheme: otherTheme.switchTheme,
      tabBarTheme: otherTheme.tabBarTheme,
      textButtonTheme: otherTheme.textButtonTheme,
      textSelectionTheme: otherTheme.textSelectionTheme,
      timePickerTheme: otherTheme.timePickerTheme,
      toggleButtonsTheme: otherTheme.toggleButtonsTheme,
      tooltipTheme: otherTheme.tooltipTheme,
    );

    // For the sanity of the reader, make sure these properties are in the same
    // order everywhere that they are separated by section comments (e.g.
    // GENERAL CONFIGURATION). Each section except for deprecations should be
    // alphabetical by symbol name.

    // GENERAL CONFIGURATION
    expect(themeDataCopy.cupertinoOverrideTheme, equals(otherTheme.cupertinoOverrideTheme));
    expect(themeDataCopy.extensions, equals(otherTheme.extensions));
    expect(themeDataCopy.inputDecorationTheme, equals(otherTheme.inputDecorationTheme));
    expect(themeDataCopy.materialTapTargetSize, equals(otherTheme.materialTapTargetSize));
    expect(themeDataCopy.pageTransitionsTheme, equals(otherTheme.pageTransitionsTheme));
    expect(themeDataCopy.platform, equals(otherTheme.platform));
    expect(themeDataCopy.scrollbarTheme, equals(otherTheme.scrollbarTheme));
    expect(themeDataCopy.splashFactory, equals(otherTheme.splashFactory));
    expect(themeDataCopy.visualDensity, equals(otherTheme.visualDensity));

    // COLOR
    expect(themeDataCopy.colorScheme, equals(otherTheme.colorScheme));
    // TYPOGRAPHY & ICONOGRAPHY
    expect(themeDataCopy.iconTheme, equals(otherTheme.iconTheme));
    expect(themeDataCopy.textTheme, equals(otherTheme.textTheme));
    expect(themeDataCopy.typography, equals(otherTheme.typography));

    // COMPONENT THEMES
    expect(themeDataCopy.actionIconTheme, equals(otherTheme.actionIconTheme));
    expect(themeDataCopy.appBarTheme, equals(otherTheme.appBarTheme));
    expect(themeDataCopy.badgeTheme, equals(otherTheme.badgeTheme));
    expect(themeDataCopy.bannerTheme, equals(otherTheme.bannerTheme));
    expect(themeDataCopy.bottomAppBarTheme, equals(otherTheme.bottomAppBarTheme));
    expect(themeDataCopy.bottomNavigationBarTheme, equals(otherTheme.bottomNavigationBarTheme));
    expect(themeDataCopy.bottomSheetTheme, equals(otherTheme.bottomSheetTheme));
    expect(themeDataCopy.buttonBarTheme, equals(otherTheme.buttonBarTheme));
    expect(themeDataCopy.cardTheme, equals(otherTheme.cardTheme));
    expect(themeDataCopy.checkboxTheme, equals(otherTheme.checkboxTheme));
    expect(themeDataCopy.chipTheme, equals(otherTheme.chipTheme));
    expect(themeDataCopy.dataTableTheme, equals(otherTheme.dataTableTheme));
    expect(themeDataCopy.datePickerTheme, equals(otherTheme.datePickerTheme));
    expect(themeDataCopy.dialogTheme, equals(otherTheme.dialogTheme));
    expect(themeDataCopy.dividerTheme, equals(otherTheme.dividerTheme));
    expect(themeDataCopy.drawerTheme, equals(otherTheme.drawerTheme));
    expect(themeDataCopy.elevatedButtonTheme, equals(otherTheme.elevatedButtonTheme));
    expect(themeDataCopy.expansionTileTheme, equals(otherTheme.expansionTileTheme));
    expect(themeDataCopy.filledButtonTheme, equals(otherTheme.filledButtonTheme));
    expect(themeDataCopy.floatingActionButtonTheme, equals(otherTheme.floatingActionButtonTheme));
    expect(themeDataCopy.iconButtonTheme, equals(otherTheme.iconButtonTheme));
    expect(themeDataCopy.listTileTheme, equals(otherTheme.listTileTheme));
    expect(themeDataCopy.menuBarTheme, equals(otherTheme.menuBarTheme));
    expect(themeDataCopy.menuButtonTheme, equals(otherTheme.menuButtonTheme));
    expect(themeDataCopy.menuTheme, equals(otherTheme.menuTheme));
    expect(themeDataCopy.navigationBarTheme, equals(otherTheme.navigationBarTheme));
    expect(themeDataCopy.navigationRailTheme, equals(otherTheme.navigationRailTheme));
    expect(themeDataCopy.outlinedButtonTheme, equals(otherTheme.outlinedButtonTheme));
    expect(themeDataCopy.popupMenuTheme, equals(otherTheme.popupMenuTheme));
    expect(themeDataCopy.progressIndicatorTheme, equals(otherTheme.progressIndicatorTheme));
    expect(themeDataCopy.radioTheme, equals(otherTheme.radioTheme));
    expect(themeDataCopy.searchBarTheme, equals(otherTheme.searchBarTheme));
    expect(themeDataCopy.searchViewTheme, equals(otherTheme.searchViewTheme));
    expect(themeDataCopy.sliderTheme, equals(otherTheme.sliderTheme));
    expect(themeDataCopy.snackBarTheme, equals(otherTheme.snackBarTheme));
    expect(themeDataCopy.switchTheme, equals(otherTheme.switchTheme));
    expect(themeDataCopy.tabBarTheme, equals(otherTheme.tabBarTheme));
    expect(themeDataCopy.textButtonTheme, equals(otherTheme.textButtonTheme));
    expect(themeDataCopy.textSelectionTheme, equals(otherTheme.textSelectionTheme));
    expect(themeDataCopy.textSelectionTheme.selectionColor, equals(otherTheme.textSelectionTheme.selectionColor));
    expect(themeDataCopy.textSelectionTheme.cursorColor, equals(otherTheme.textSelectionTheme.cursorColor));
    expect(themeDataCopy.textSelectionTheme.selectionHandleColor, equals(otherTheme.textSelectionTheme.selectionHandleColor));
    expect(themeDataCopy.timePickerTheme, equals(otherTheme.timePickerTheme));
    expect(themeDataCopy.toggleButtonsTheme, equals(otherTheme.toggleButtonsTheme));
    expect(themeDataCopy.tooltipTheme, equals(otherTheme.tooltipTheme));
  });

  testWidgets('ThemeData.toString has less than 200 characters output', (WidgetTester tester) async {
    // This test makes sure that the ThemeData debug output doesn't get too
    // verbose, which has been a problem in the past.

    final ColorScheme darkColors = ColorScheme.m3DefaultDark;
    final ThemeData darkTheme = ThemeData.from(colorScheme: darkColors);

    expect(darkTheme.toString().length, lessThan(200));

    final ColorScheme lightColors = ColorScheme.m3DefaultLight;
    final ThemeData lightTheme = ThemeData.from(colorScheme: lightColors);

    expect(lightTheme.toString().length, lessThan(200));
  });

  test('ThemeData diagnostics include all properties', () {
    // List of properties must match the properties in ThemeData.hashCode()
    final Set<String> expectedPropertyNames = <String>{
      // GENERAL CONFIGURATION
      'cupertinoOverrideTheme',
      'extensions',
      'inputDecorationTheme',
      'materialTapTargetSize',
      'pageTransitionsTheme',
      'platform',
      'scrollbarTheme',
      'splashFactory',
      'visualDensity',
      // COLOR
      'colorScheme',
      'stateTheme',
      // TYPOGRAPHY & ICONOGRAPHY
      'typography',
      'textTheme',
      'iconTheme',
      // COMPONENT THEMES
      'actionIconTheme',
      'appBarTheme',
      'badgeTheme',
      'bannerTheme',
      'bottomAppBarTheme',
      'bottomNavigationBarTheme',
      'bottomSheetTheme',
      'buttonBarTheme',
      'cardTheme',
      'checkboxTheme',
      'chipTheme',
      'dataTableTheme',
      'datePickerTheme',
      'dialogTheme',
      'dividerTheme',
      'drawerTheme',
      'dropdownMenuTheme',
      'elevatedButtonTheme',
      'expansionTileTheme',
      'filledButtonTheme',
      'floatingActionButtonTheme',
      'iconButtonTheme',
      'listTileTheme',
      'menuBarTheme',
      'menuButtonTheme',
      'menuTheme',
      'navigationBarTheme',
      'navigationDrawerTheme',
      'navigationRailTheme',
      'outlinedButtonTheme',
      'popupMenuTheme',
      'progressIndicatorTheme',
      'radioTheme',
      'searchBarTheme',
      'searchViewTheme',
      'segmentedButtonTheme',
      'sliderTheme',
      'snackBarTheme',
      'switchTheme',
      'tabBarTheme',
      'textButtonTheme',
      'textSelectionTheme',
      'timePickerTheme',
      'toggleButtonsTheme',
      'tooltipTheme',
    };

    final DiagnosticPropertiesBuilder properties = DiagnosticPropertiesBuilder();
    ThemeData.light().debugFillProperties(properties);
    final List<String> propertyNameList = properties.properties
      .map((final DiagnosticsNode node) => node.name)
      .whereType<String>()
      .toList();
    final Set<String> propertyNames = propertyNameList.toSet();

    // Ensure there are no duplicates.
    expect(propertyNameList.length, propertyNames.length);

    // Ensure they are all there.
    expect(propertyNames, expectedPropertyNames);
  });
}

@immutable
class MyThemeExtensionA extends ThemeExtension<MyThemeExtensionA> {
  const MyThemeExtensionA({
    required this.color1,
    required this.color2,
  });

  final Color? color1;
  final Color? color2;

  @override
  MyThemeExtensionA copyWith({Color? color1, Color? color2}) {
    return MyThemeExtensionA(
      color1: color1 ?? this.color1,
      color2: color2 ?? this.color2,
    );
  }

  @override
  MyThemeExtensionA lerp(MyThemeExtensionA? other, double t) {
    if (other is! MyThemeExtensionA) {
      return this;
    }
    return MyThemeExtensionA(
      color1: Color.lerp(color1, other.color1, t),
      color2: Color.lerp(color2, other.color2, t),
    );
  }
}

@immutable
class MyThemeExtensionB extends ThemeExtension<MyThemeExtensionB> {
  const MyThemeExtensionB({
    required this.textStyle,
  });

  final TextStyle? textStyle;

  @override
  MyThemeExtensionB copyWith({Color? color, TextStyle? textStyle}) {
    return MyThemeExtensionB(
      textStyle: textStyle ?? this.textStyle,
    );
  }

  @override
  MyThemeExtensionB lerp(MyThemeExtensionB? other, double t) {
    if (other is! MyThemeExtensionB) {
      return this;
    }
    return MyThemeExtensionB(
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
    );
  }
}

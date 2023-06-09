// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show Color, lerpDouble;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../material.dart';
import 'action_buttons.dart';
import 'action_icons_theme.dart';
import 'app_bar_theme.dart';
import 'badge_theme.dart';
import 'bottom_app_bar_theme.dart';
import 'bottom_navigation_bar_theme.dart';
import 'bottom_sheet_theme.dart';
import 'buttons/button_style.dart';
import 'buttons/expandable_floating_action_button_theme.dart';
import 'buttons/floating_action_button_theme.dart';
import 'cards/card_theme.dart';
import 'checkbox_theme.dart';
import 'chips/chip_list_theme.dart';
import 'chips/chip_theme.dart';
import 'color_scheme.dart';
import 'colors.dart';
import 'constants.dart';
import 'date_picker_theme.dart';
import 'dialog_theme.dart';
import 'divider_theme.dart';
import 'drawer_theme.dart';
// import 'src/dropdown_menu_theme.dart';
import 'expansion_tile_theme.dart';
import 'ink_ripple.dart';
import 'ink_sparkle.dart';
import 'ink_splash.dart';
import 'ink_well.dart' show InteractiveInkFeatureFactory;
import 'list_tile.dart';
import 'list_tile_theme.dart';
import 'menu_bar_theme.dart';
import 'menu_button_theme.dart';
import 'menu_theme.dart';
import 'navigation_bar_theme.dart';
import 'navigation_drawer_theme.dart';
import 'navigation_rail_theme.dart';
import 'page_transitions_theme.dart';
import 'popup_menu_theme.dart';
import 'progress_indicator_theme.dart';
import 'radio_theme.dart';
import 'scrollbar_theme.dart';
import 'search_bar_theme.dart';
import 'search_view_theme.dart';
import 'slider_theme.dart';
import 'snack_bar_theme.dart';
import 'state_theme.dart';
import 'switch_theme.dart';
import 'tab_bar_theme.dart';
import 'text_field/input_decorator.dart';
import 'text_field/text_field_theme.dart';
import 'text_selection_theme.dart';
import 'text_theme.dart';
// import 'src/time_picker_theme.dart';
import 'tooltip_theme.dart';
import 'typography.dart';

export 'package:flutter/services.dart' show Brightness;

// Examples can assume:
// late BuildContext context;

/// An interface that defines custom additions to a [ThemeData] object.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=8-szcYzFVao}
///
/// Typically used for custom colors. To use, subclass [ThemeExtension],
/// define a number of fields (e.g. [Color]s), and implement the [copyWith] and
/// [lerp] methods. The latter will ensure smooth transitions of properties when
/// switching themes.
///
/// {@tool dartpad}
/// This sample shows how to create and use a subclass of [ThemeExtension] that
/// defines two colors.
///
/// ** See code in examples/api/lib/material/theme/theme_extension.1.dart **
/// {@end-tool}
abstract class ThemeExtension<T extends ThemeExtension<T>> {
  /// Enable const constructor for subclasses.
  const ThemeExtension();

  /// The extension's type.
  Object get type => T;

  /// Creates a copy of this theme extension with the given fields
  /// replaced by the non-null parameter values.
  ThemeExtension<T> copyWith();

  /// Linearly interpolate with another [ThemeExtension] object.
  ///
  /// {@macro dart.ui.shadow.lerp}
  ThemeExtension<T> lerp(covariant ThemeExtension<T>? other, double t);
}

/// {@template alternative_material_3.MaterialTapTargetSize}
/// Configures the tap target and layout size of certain Material widgets.
///
/// Changing the value in [ThemeData.materialTapTargetSize] will affect the
/// accessibility experience.
/// {@endtemplate}
///
/// Some of the impacted widgets include:
///
///   * [FloatingActionButton], only the mini tap target size is increased.
///   * [MaterialButton]
///   * [OutlinedButton]
///   * [TextButton]
///   * [ElevatedButton]
///   * [IconButton]
///   * The time picker widget ([showTimePicker])
///   * [SnackBar]
///   * [Chip]
///   * [RawChip]
///   * [InputChip]
///   * [ChoiceChip]
///   * [FilterChip]
///   * [ActionChip]
///   * [Radio]
///   * [Switch]
///   * [Checkbox]
enum MaterialTapTargetSize {
  /// Expands the minimum tap target size to 48px by 48px.
  ///
  /// This is the default value of [ThemeData.materialTapTargetSize] and the
  /// recommended size to conform to Android accessibility scanner
  /// recommendations.
  padded,

  /// Shrinks the tap target size to the minimum provided by the Material
  /// specification.
  shrinkWrap,
}

/// Defines the configuration of the overall visual [Theme] for a [MaterialApp]
/// or a widget subtree within the app.
///
/// The [MaterialApp] theme property can be used to configure the appearance
/// of the entire app. Widget subtree's within an app can override the app's
/// theme by including a [Theme] widget at the top of the subtree.
///
/// Widgets whose appearance should align with the overall theme can obtain the
/// current theme's configuration with [Theme.of]. Material components typically
/// depend exclusively on the [colorScheme] and [textTheme]. These properties
/// are guaranteed to have non-null values.
///
/// The static [Theme.of] method finds the [ThemeData] value specified for the
/// nearest [BuildContext] ancestor. This lookup is inexpensive, essentially
/// just a single HashMap access. It can sometimes be a little confusing
/// because [Theme.of] can not see a [Theme] widget that is defined in the
/// current build method's context. To overcome that, create a new custom widget
/// for the subtree that appears below the new [Theme], or insert a widget
/// that creates a new BuildContext, like [Builder].
///
/// {@tool snippet}
/// In this example, the [Container] widget uses [Theme.of] to retrieve the
/// primary color from the theme's [colorScheme] to draw an amber square.
/// The [Builder] widget separates the parent theme's [BuildContext] from the
/// child's [BuildContext].
///
/// ![](https://flutter.github.io/assets-for-api-docs/assets/material/theme_data.png)
///
/// ```dart
/// Theme(
///   data: ThemeData.from(
///     colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.amber),
///   ),
///   child: Builder(
///     builder: (BuildContext context) {
///       return Container(
///         width: 100,
///         height: 100,
///         color: Theme.of(context).colorScheme.primary,
///       );
///     },
///   ),
/// )
/// ```
/// {@end-tool}
///
/// {@tool snippet}
///
/// This sample creates a [MaterialApp] with a [Theme] whose
/// [ColorScheme] is based on [Colors.blue], but with the color
/// scheme's [ColorScheme.secondary] color overridden to be green. The
/// [AppBar] widget uses the color scheme's [ColorScheme.primary] as
/// its default background color and the [FloatingActionButton] widget
/// uses the color scheme's [ColorScheme.secondary] for its default
/// background. By default, the [Text] widget uses
/// [TextTheme.bodyMedium], and the color of that [TextStyle] has been
/// changed to purple.
///
/// ![](https://flutter.github.io/assets-for-api-docs/assets/material/material_app_theme_data.png)
///
/// ```dart
/// MaterialApp(
///   theme: ThemeData(
///     colorScheme: ColorScheme.fromSwatch().copyWith(
///       secondary: Colors.green,
///     ),
///     textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.purple)),
///   ),
///   home: Scaffold(
///     appBar: AppBar(
///       title: const Text('ThemeData Demo'),
///     ),
///     floatingActionButton: FloatingActionButton(
///       child: const Icon(Icons.add),
///       onPressed: () {},
///     ),
///     body: const Center(
///       child: Text('Button pressed 0 times'),
///     ),
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See <https://material.io/design/color/> for
/// more discussion on how to pick the right colors.

@immutable
class ThemeData with Diagnosticable {
  /// Create a [ThemeData] that's used to configure a [Theme].
  ///
  /// The [colorScheme] and [textTheme] are used by the Material components to
  /// compute default values for visual properties. The API documentation for
  /// each component widget explains exactly how the defaults are computed.
  ///
  /// When providing a [ColorScheme], apps can either provide one directly
  /// with the [colorScheme] parameter, or have one generated for them by
  /// using the [colorSchemeSeed] and [brightness] parameters. A generated
  /// color scheme will be based on the tones of [colorSchemeSeed] and all of
  /// its contrasting color will meet accessibility guidelines for readability.
  /// (See [ColorScheme.fromSeed] for more details.)
  ///
  /// If the app wants to customize a generated color scheme, it can use
  /// [ColorScheme.fromSeed] directly and then [ColorScheme.copyWith] on the
  /// result to override any colors that need to be replaced. The result of
  /// this can be used as the [colorScheme] directly.
  ///
  /// For historical reasons, instead of using a [colorSchemeSeed] or
  /// [colorScheme], you can provide either a [primaryColor] or [primarySwatch]
  /// to construct the [colorScheme], but the results will not be as complete
  /// as when using generation from a seed color.
  ///
  /// If [colorSchemeSeed] is non-null then [colorScheme], [primaryColor] and
  /// [primarySwatch] must all be null.
  ///
  /// The [textTheme] [TextStyle] colors are black if the color scheme's
  /// brightness is [Brightness.light], and white for [Brightness.dark].
  ///
  /// To override the appearance of specific components, provide
  /// a component theme parameter like [sliderTheme], [toggleButtonsTheme],
  /// or [bottomNavigationBarTheme].
  ///
  /// See also:
  ///
  ///  * [ThemeData.from], which creates a ThemeData from a [ColorScheme].
  ///  * [ThemeData.light], which creates a light blue theme.
  ///  * [ThemeData.dark], which creates dark theme with a teal secondary [ColorScheme] color.
  ///  * [ColorScheme.fromSeed], which is used to create a [ColorScheme] from a seed color.
  factory ThemeData({
    // For the sanity of the reader, make sure these properties are in the same
    // order in every place that they are separated by section comments (e.g.
    // GENERAL CONFIGURATION). Each section except for deprecations should be
    // alphabetical by symbol name.

    // GENERAL CONFIGURATION
    NoDefaultCupertinoThemeData? cupertinoOverrideTheme,
    Iterable<ThemeExtension<dynamic>>? extensions,
    MaterialTapTargetSize? materialTapTargetSize,
    double? minInteractiveDimension,
    bool? alwaysPadTapTarget,
    PageTransitionsTheme? pageTransitionsTheme,
    TargetPlatform? platform,
    ScrollbarThemeData? scrollbarTheme,
    InteractiveInkFeatureFactory? splashFactory,
    VisualDensity? visualDensity,
    // COLOR
    ColorScheme? colorScheme,
    StateThemeData? stateTheme,
    // TYPOGRAPHY & ICONOGRAPHY
    String? fontFamily,
    List<String>? fontFamilyFallback,
    String? package,
    IconThemeData? iconTheme,
    TextTheme? textTheme,
    Typography? typography,
    // COMPONENT THEMES
    ActionIconThemeData? actionIconTheme,
    AppBarTheme? appBarTheme,
    BadgeThemeData? badgeTheme,
    BottomAppBarTheme? bottomAppBarTheme,
    BottomNavigationBarThemeData? bottomNavigationBarTheme,
    BottomSheetThemeData? bottomSheetTheme,
    CardThemeData? elevatedCardTheme,
    CardThemeData? filledCardTheme,
    CardThemeData? outlinedCardTheme,
    CheckboxThemeData? checkboxTheme,
    ChipThemeData? chipTheme,
    ChipListThemeData? chipListTheme,
    DatePickerThemeData? datePickerTheme,
    DialogTheme? dialogTheme,
    DividerThemeData? dividerTheme,
    DrawerThemeData? drawerTheme,
    // DropdownMenuThemeData? dropdownMenuTheme,
    ElevatedButtonThemeData? elevatedButtonTheme,
    ExpandableFloatingActionButtonThemeData? expandableFloatingActionButtonTheme,
    ExpansionTileThemeData? expansionTileTheme,
    FilledButtonThemeData? filledButtonTheme,
    FilledIconButtonThemeData? filledIconButtonTheme,
    FilledTonalButtonThemeData? filledTonalButtonTheme,
    FilledTonalIconButtonThemeData? filledTonalIconButtonTheme,
    FloatingActionButtonThemeData? floatingActionButtonTheme,
    IconButtonThemeData? iconButtonTheme,
    ListTileThemeData? listTileTheme,
    MenuBarThemeData? menuBarTheme,
    MenuButtonThemeData? menuButtonTheme,
    MenuThemeData? menuTheme,
    NavigationBarThemeData? navigationBarTheme,
    NavigationDrawerThemeData? navigationDrawerTheme,
    NavigationRailThemeData? navigationRailTheme,
    OutlinedButtonThemeData? outlinedButtonTheme,
    OutlinedIconButtonThemeData? outlinedIconButtonTheme,
    PopupMenuThemeData? popupMenuTheme,
    ProgressIndicatorThemeData? progressIndicatorTheme,
    RadioThemeData? radioTheme,
    SearchBarThemeData? searchBarTheme,
    SearchViewThemeData? searchViewTheme,
    SegmentedButtonThemeData? segmentedButtonTheme,
    SliderThemeData? sliderTheme,
    SnackBarThemeData? snackBarTheme,
    IconButtonThemeData? standardIconButtonTheme,
    SwitchThemeData? switchTheme,
    TabBarTheme? tabBarTheme,
    TextButtonThemeData? textButtonTheme,
    TextFieldThemeData? textFieldTheme,
    TextSelectionThemeData? textSelectionTheme,
    // TimePickerThemeData? timePickerTheme,
    TooltipThemeData? tooltipTheme,
 }) {
    // GENERAL CONFIGURATION
    cupertinoOverrideTheme = cupertinoOverrideTheme?.noDefault();
    extensions ??= <ThemeExtension<dynamic>>[];
    platform ??= defaultTargetPlatform;
    switch (platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        materialTapTargetSize ??= MaterialTapTargetSize.padded;
        minInteractiveDimension ??= kMinInteractiveDimension;
      case TargetPlatform.iOS:
        materialTapTargetSize ??= MaterialTapTargetSize.padded;
        minInteractiveDimension ??= 44.0;
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        materialTapTargetSize ??= MaterialTapTargetSize.shrinkWrap;
        minInteractiveDimension ??= 0.0;
    }
    alwaysPadTapTarget ??= false;

    pageTransitionsTheme ??= const PageTransitionsTheme();
    scrollbarTheme ??= const ScrollbarThemeData();
    visualDensity ??= VisualDensity.defaultDensityForPlatform(platform);
    final bool useInkSparkle = platform == TargetPlatform.android && !kIsWeb;
    splashFactory ??= useInkSparkle ? InkSparkle.splashFactory : InkRipple.splashFactory;

    // COLOR
    colorScheme ??= ColorScheme.m3DefaultLight;

    stateTheme ??= const StateThemeData();

      // TYPOGRAPHY & ICONOGRAPHY
    typography ??= Typography.material2021(platform: platform, colorScheme: colorScheme);
    textTheme = textThemeFor(
      colorScheme: colorScheme,
      typography: typography,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      package: package
    ).merge(textTheme);

    iconTheme ??= iconThemeFor(colorScheme);

    // COMPONENT THEMES
    appBarTheme ??= const AppBarTheme();
    badgeTheme ??= const BadgeThemeData();
    bottomAppBarTheme ??= const BottomAppBarTheme();
    bottomNavigationBarTheme ??= const BottomNavigationBarThemeData();
    bottomSheetTheme ??= const BottomSheetThemeData();
    elevatedCardTheme ??= const CardThemeData();
    filledCardTheme ??= const CardThemeData();
    outlinedCardTheme ??= const CardThemeData();
    checkboxTheme ??= const CheckboxThemeData();
    chipTheme ??= const ChipThemeData();
    chipListTheme ??= const ChipListThemeData();
    datePickerTheme ??= const DatePickerThemeData();
    dialogTheme ??= const DialogTheme();
    dividerTheme ??= const DividerThemeData();
    drawerTheme ??= const DrawerThemeData();
    // dropdownMenuTheme ??= const DropdownMenuThemeData();
    elevatedButtonTheme ??= const ElevatedButtonThemeData();
    expandableFloatingActionButtonTheme ??= const ExpandableFloatingActionButtonThemeData();
    expansionTileTheme ??= const ExpansionTileThemeData();
    filledButtonTheme ??= const FilledButtonThemeData();
    filledIconButtonTheme ??= const FilledIconButtonThemeData();
    filledTonalButtonTheme ??= const FilledTonalButtonThemeData();
    filledTonalIconButtonTheme ??= const FilledTonalIconButtonThemeData();
    floatingActionButtonTheme ??= const FloatingActionButtonThemeData();
    iconButtonTheme ??= const IconButtonThemeData();
    listTileTheme ??= const ListTileThemeData();
    menuBarTheme ??= const MenuBarThemeData();
    menuButtonTheme ??= const MenuButtonThemeData();
    menuTheme ??= const MenuThemeData();
    navigationBarTheme ??= const NavigationBarThemeData();
    navigationDrawerTheme ??= const NavigationDrawerThemeData();
    navigationRailTheme ??= const NavigationRailThemeData();
    outlinedButtonTheme ??= const OutlinedButtonThemeData();
    outlinedIconButtonTheme ??= const OutlinedIconButtonThemeData();
    popupMenuTheme ??= const PopupMenuThemeData();
    progressIndicatorTheme ??= const ProgressIndicatorThemeData();
    radioTheme ??= const RadioThemeData();
    searchBarTheme ??= const SearchBarThemeData();
    searchViewTheme ??= const SearchViewThemeData();
    segmentedButtonTheme ??= const SegmentedButtonThemeData();
    sliderTheme ??= const SliderThemeData();
    snackBarTheme ??= const SnackBarThemeData();
    standardIconButtonTheme ??= const IconButtonThemeData();
    switchTheme ??= const SwitchThemeData();
    tabBarTheme ??= const TabBarTheme();
    textButtonTheme ??= const TextButtonThemeData();
    textFieldTheme ??= const TextFieldThemeData();
    textSelectionTheme ??= const TextSelectionThemeData();
    // timePickerTheme ??= const TimePickerThemeData();
    tooltipTheme ??= const TooltipThemeData();

    return ThemeData.raw(
      // For the sanity of the reader, make sure these properties are in the same
      // order in every place that they are separated by section comments (e.g.
      // GENERAL CONFIGURATION). Each section except for deprecations should be
      // alphabetical by symbol name.

      // GENERAL CONFIGURATION
      cupertinoOverrideTheme: cupertinoOverrideTheme,
      extensions: _themeExtensionIterableToMap(extensions),
      materialTapTargetSize: materialTapTargetSize,
      minInteractiveDimension: minInteractiveDimension,
      alwaysPadTapTarget: alwaysPadTapTarget,
      pageTransitionsTheme: pageTransitionsTheme,
      platform: platform,
      scrollbarTheme: scrollbarTheme,
      splashFactory: splashFactory,
      visualDensity: visualDensity,
      // COLOR
      colorScheme: colorScheme,
      stateTheme: stateTheme,
      // TYPOGRAPHY & ICONOGRAPHY
      iconTheme: iconTheme,
      textTheme: textTheme,
      typography: typography,
      // COMPONENT THEMES
      actionIconTheme: actionIconTheme,
      appBarTheme: appBarTheme,
      badgeTheme: badgeTheme,
      bottomAppBarTheme: bottomAppBarTheme,
      bottomNavigationBarTheme: bottomNavigationBarTheme,
      bottomSheetTheme: bottomSheetTheme,
      elevatedCardTheme: elevatedCardTheme,
      filledCardTheme: filledCardTheme,
      outlinedCardTheme: outlinedCardTheme,
      checkboxTheme: checkboxTheme,
      chipTheme: chipTheme,
      chipListTheme: chipListTheme,
      datePickerTheme: datePickerTheme,
      dialogTheme: dialogTheme,
      dividerTheme: dividerTheme,
      drawerTheme: drawerTheme,
      // dropdownMenuTheme: dropdownMenuTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      expandableFloatingActionButtonTheme: expandableFloatingActionButtonTheme,
      expansionTileTheme: expansionTileTheme,
      filledButtonTheme: filledButtonTheme,
      filledIconButtonTheme: filledIconButtonTheme,
      filledTonalButtonTheme: filledTonalButtonTheme,
      filledTonalIconButtonTheme: filledTonalIconButtonTheme,
      floatingActionButtonTheme: floatingActionButtonTheme,
      iconButtonTheme: iconButtonTheme,
      listTileTheme: listTileTheme,
      menuBarTheme: menuBarTheme,
      menuButtonTheme: menuButtonTheme,
      menuTheme: menuTheme,
      navigationBarTheme: navigationBarTheme,
      navigationDrawerTheme: navigationDrawerTheme,
      navigationRailTheme: navigationRailTheme,
      outlinedButtonTheme: outlinedButtonTheme,
      outlinedIconButtonTheme: outlinedIconButtonTheme,
      popupMenuTheme: popupMenuTheme,
      progressIndicatorTheme: progressIndicatorTheme,
      radioTheme: radioTheme,
      searchBarTheme: searchBarTheme,
      searchViewTheme: searchViewTheme,
      segmentedButtonTheme: segmentedButtonTheme,
      sliderTheme: sliderTheme,
      snackBarTheme: snackBarTheme,
      standardIconButtonTheme: standardIconButtonTheme,
      switchTheme: switchTheme,
      tabBarTheme: tabBarTheme,
      textButtonTheme: textButtonTheme,
      textFieldTheme: textFieldTheme,
      textSelectionTheme: textSelectionTheme,
      // timePickerTheme: timePickerTheme,
      tooltipTheme: tooltipTheme,
    );
  }

  /// Create a [ThemeData] given a set of exact values. Most values must be
  /// specified. They all must also be non-null except for
  /// [cupertinoOverrideTheme], and deprecated members.
  ///
  /// This will rarely be used directly. It is used by [lerp] to
  /// create intermediate themes based on two themes created with the
  /// [ThemeData] constructor.
  const ThemeData.raw({
    // For the sanity of the reader, make sure these properties are in the same
    // order in every place that they are separated by section comments (e.g.
    // GENERAL CONFIGURATION). Each section except for deprecations should be
    // alphabetical by symbol name.

    // GENERAL CONFIGURATION
    required this.cupertinoOverrideTheme,
    required this.extensions,
    required this.materialTapTargetSize,
    required this.minInteractiveDimension,
    required this.alwaysPadTapTarget,
    required this.pageTransitionsTheme,
    required this.platform,
    required this.scrollbarTheme,
    required this.splashFactory,
    required this.visualDensity,
    // COLOR
    required this.colorScheme,
    required this.stateTheme,
    // TYPOGRAPHY & ICONOGRAPHY
    required this.iconTheme,
    required this.textTheme,
    required this.typography,
    // COMPONENT THEMES
    required this.actionIconTheme,
    required this.appBarTheme,
    required this.badgeTheme,
    required this.bottomAppBarTheme,
    required this.bottomNavigationBarTheme,
    required this.bottomSheetTheme,
    required this.elevatedCardTheme,
    required this.filledCardTheme,
    required this.outlinedCardTheme,
    required this.checkboxTheme,
    required this.chipTheme,
    required this.chipListTheme,
    required this.datePickerTheme,
    required this.dialogTheme,
    required this.dividerTheme,
    required this.drawerTheme,
    // required this.dropdownMenuTheme,
    required this.elevatedButtonTheme,
    required this.expandableFloatingActionButtonTheme,
    required this.expansionTileTheme,
    required this.filledButtonTheme,
    required this.filledIconButtonTheme,
    required this.filledTonalButtonTheme,
    required this.filledTonalIconButtonTheme,
    required this.floatingActionButtonTheme,
    required this.iconButtonTheme,
    required this.listTileTheme,
    required this.menuBarTheme,
    required this.menuButtonTheme,
    required this.menuTheme,
    required this.navigationBarTheme,
    required this.navigationDrawerTheme,
    required this.navigationRailTheme,
    required this.outlinedButtonTheme,
    required this.outlinedIconButtonTheme,
    required this.popupMenuTheme,
    required this.progressIndicatorTheme,
    required this.radioTheme,
    required this.searchBarTheme,
    required this.searchViewTheme,
    required this.segmentedButtonTheme,
    required this.sliderTheme,
    required this.snackBarTheme,
    required this.standardIconButtonTheme,
    required this.switchTheme,
    required this.tabBarTheme,
    required this.textButtonTheme,
    required this.textFieldTheme,
    required this.textSelectionTheme,
    // required this.timePickerTheme,
    required this.tooltipTheme,
  });

  /// Create a [ThemeData] based on the colors in the given [colorScheme] and
  /// text styles of the optional [textTheme].
  ///
  /// The [colorScheme] can not be null.
  ///
  /// If [colorScheme].brightness is [Brightness.dark] then
  /// [ThemeData.applyElevationOverlayColor] will be set to true to support
  /// the Material dark theme method for indicating elevation by applying
  /// a semi-transparent onSurface color on top of the surface color.
  ///
  /// This is the recommended method to theme your application. As we move
  /// forward we will be converting all the widget implementations to only use
  /// colors or colors derived from those in [ColorScheme].
  ///
  /// {@tool snippet}
  /// This example will set up an application to use the baseline Material
  /// Design light and dark themes.
  ///
  /// ```dart
  /// MaterialApp(
  ///   theme: ThemeData.from(colorScheme: ColorScheme.m3DefaultLight),
  ///   darkTheme: ThemeData.from(colorScheme: ColorScheme.m3DefaultDark),
  /// )
  /// ```
  /// {@end-tool}
  ///
  /// See <https://material.io/design/color/> for
  /// more discussion on how to pick the right colors.
  factory ThemeData.from({
    required ColorScheme colorScheme,
    TextTheme? textTheme,
  }) {
    return ThemeData(
      colorScheme: colorScheme,
      textTheme: textTheme,
    );
  }

  /// Default light or dark theme
  factory ThemeData.ofBrightness(Brightness brightness) =>
      brightness == Brightness.light
        ? ThemeData.light()
        : ThemeData.dark();


  /// A default light blue theme.
  ///
  /// This theme does not contain text geometry. Instead, it is expected that
  /// this theme is localized using text geometry using [ThemeData.localize].
  factory ThemeData.light() => ThemeData(
    colorScheme: ColorScheme.m3DefaultLight
  );

  /// A default dark theme with a teal secondary [ColorScheme] color.
  ///
  /// This theme does not contain text geometry. Instead, it is expected that
  /// this theme is localized using text geometry using [ThemeData.localize].
  factory ThemeData.dark() => ThemeData(
      colorScheme: ColorScheme.m3DefaultDark
  );

  /// The default color theme. Same as [ThemeData.light].
  ///
  /// This is used by [Theme.of] when no theme has been specified.
  ///
  /// This theme does not contain text geometry. Instead, it is expected that
  /// this theme is localized using text geometry using [ThemeData.localize].
  ///
  /// Most applications would use [Theme.of], which provides correct localized
  /// text geometry.
  factory ThemeData.fallback() => ThemeData.light();

  /// Create a [TextTheme] matching the brightness of the [colorScheme].
  /// Also apply any non-null type parameters.
  static TextTheme textThemeFor({
    required ColorScheme colorScheme,
    required Typography typography,
    String? package,
    String? fontFamily,
    List<String>? fontFamilyFallback,
  }) {
    final bool isDark = colorScheme.brightness == Brightness.dark;
    // typography ??= Typography.material2021(platform: platform, colorScheme: colorScheme);
    TextTheme defaultTextTheme = isDark ? typography.white : typography.black;
    if (fontFamily != null) {
      defaultTextTheme = defaultTextTheme.apply(fontFamily: fontFamily);
    }
    if (fontFamilyFallback != null) {
      defaultTextTheme = defaultTextTheme.apply(fontFamilyFallback: fontFamilyFallback);
    }
    if (package != null) {
      defaultTextTheme = defaultTextTheme.apply(package: package);
    }
    return defaultTextTheme;
  }

  /// Create an [IconThemeData] matching the brightness of the [colorScheme].
  static IconThemeData iconThemeFor(ColorScheme colorScheme) {
    return colorScheme.brightness == Brightness.dark
        ? const IconThemeData(color: kDefaultIconLightColor)
        : const IconThemeData(color: kDefaultIconDarkColor);
  }

  /// The overall theme brightness.
  ///
  /// The default [TextStyle] color for the [textTheme] is black if the
  /// theme is constructed with [Brightness.light] and white if the
  /// theme is constructed with [Brightness.dark].
  Brightness get brightness => colorScheme.brightness;

  // For the sanity of the reader, make sure these properties are in the same
  // order in every place that they are separated by section comments (e.g.
  // GENERAL CONFIGURATION). Each section except for deprecations should be
  // alphabetical by symbol name.

  // GENERAL CONFIGURATION

  /// Components of the [CupertinoThemeData] to override from the Material
  /// [ThemeData] adaptation.
  ///
  /// By default, [cupertinoOverrideTheme] is null and Cupertino widgets
  /// descendant to the Material [Theme] will adhere to a [CupertinoTheme]
  /// derived from the Material [ThemeData]. e.g. [ThemeData]'s [ColorScheme]
  /// will also inform the [CupertinoThemeData]'s `primaryColor` etc.
  ///
  /// This cascading effect for individual attributes of the [CupertinoThemeData]
  /// can be overridden using attributes of this [cupertinoOverrideTheme].
  final NoDefaultCupertinoThemeData? cupertinoOverrideTheme;

  /// Arbitrary additions to this theme.
  ///
  /// To define extensions, pass an [Iterable] containing one or more [ThemeExtension]
  /// subclasses to [ThemeData.new] or [copyWith].
  ///
  /// To obtain an extension, use [extension].
  ///
  /// {@tool dartpad}
  /// This sample shows how to create and use a subclass of [ThemeExtension] that
  /// defines two colors.
  ///
  /// ** See code in examples/api/lib/material/theme/theme_extension.1.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  /// * [extension], a convenience function for obtaining a specific extension.
  final Map<Object, ThemeExtension<dynamic>> extensions;

  /// Used to obtain a particular [ThemeExtension] from [extensions].
  ///
  /// Obtain with `Theme.of(context).extension<MyThemeExtension>()`.
  ///
  /// See [extensions] for an interactive example.
  T? extension<T>() => extensions[T] as T?;

  /// Configures the hit test size of certain Material widgets.
  ///
  /// Defaults to a [platform]-appropriate size: [MaterialTapTargetSize.padded]
  /// on mobile platforms, [MaterialTapTargetSize.shrinkWrap] on desktop
  /// platforms.
  final MaterialTapTargetSize materialTapTargetSize;

  /// The minimum dimension of any interactive region according to Material
  /// guidelines. This may add padding to widgets as needed, depending on the
  /// value of [alwaysPadTapTarget].
  ///
  /// This is used to avoid small regions that are hard for the user to interact
  /// with. It applies to both dimensions of a region, so a square of size
  /// kMinInteractiveDimension x kMinInteractiveDimension is the smallest
  /// acceptable region that should respond to gestures.
  ///
  /// The defaults are
  ///  * 48dp for Android and Fuchsia
  ///  * 44dp fro iOS
  ///  * 0dp for desktop
  ///
  /// See also:
  ///
  ///  * [kMinInteractiveDimensionCupertino]
  ///  * The Material spec on touch targets at <https://material.io/design/usability/accessibility.html#layout-typography>.
  final double minInteractiveDimension;

  /// If true, always apply [minInteractiveDimension] to when laying out widgets
  /// and only apply [materialTapTargetSize] to the interaction. This will
  /// result in consistently padded widgets across platforms.
  ///
  /// If false, apply [materialTapTargetSize] when laying out widgets.
  /// This will result in platform dependent padding.
  final bool alwaysPadTapTarget;

  /// The
  double get effectiveMinInteractiveDimension =>
      materialTapTargetSize == MaterialTapTargetSize.padded || alwaysPadTapTarget
      ? minInteractiveDimension : 0.0;

  /// Default [MaterialPageRoute] transitions per [TargetPlatform].
  ///
  /// [MaterialPageRoute.buildTransitions] delegates to a [platform] specific
  /// [PageTransitionsBuilder]. If a matching builder is not found, a builder
  /// whose platform is null is used.
  final PageTransitionsTheme pageTransitionsTheme;

  /// The platform the material widgets should adapt to target.
  ///
  /// Defaults to the current platform, as exposed by [defaultTargetPlatform].
  /// This should be used in order to style UI elements according to platform
  /// conventions.
  ///
  /// Widgets from the material library should use this getter (via [Theme.of])
  /// to determine the current platform for the purpose of emulating the
  /// platform behavior (e.g. scrolling or haptic effects). Widgets and render
  /// objects at lower layers that try to emulate the underlying platform
  /// can depend on [defaultTargetPlatform] directly, or may require
  /// that the target platform be provided as an argument. The
  /// [dart:io.Platform] object should only be used directly when it's critical
  /// to actually know the current platform, without any overrides possible (for
  /// example, when a system API is about to be called).
  ///
  /// In a test environment, the platform returned is [TargetPlatform.android]
  /// regardless of the host platform. (Android was chosen because the tests
  /// were originally written assuming Android-like behavior, and we added
  /// platform adaptations for other platforms later). Tests can check behavior
  /// for other platforms by setting the [platform] of the [Theme] explicitly to
  /// another [TargetPlatform] value, or by setting
  /// [debugDefaultTargetPlatformOverride].
  ///
  /// Determines the defaults for [typography] and [materialTapTargetSize].
  final TargetPlatform platform;

  /// A theme for customizing the colors, thickness, and shape of [Scrollbar]s.
  final ScrollbarThemeData scrollbarTheme;

  /// Defines the appearance of ink splashes produces by [InkWell]
  /// and [InkResponse].
  ///
  /// See also:
  ///
  ///  * [InkSplash.splashFactory], which defines the default splash.
  ///  * [InkRipple.splashFactory], which defines a splash that spreads out
  ///    more aggressively than the default.
  ///  * [InkSparkle.splashFactory], which defines a more aggressive and organic
  ///    splash with sparkle effects.
  final InteractiveInkFeatureFactory splashFactory;

  /// The density value for specifying the compactness of various UI components.
  ///
  /// {@template flutter.material.themedata.visualDensity}
  /// Density, in the context of a UI, is the vertical and horizontal
  /// "compactness" of the elements in the UI. It is unitless, since it means
  /// different things to different UI elements. For buttons, it affects the
  /// spacing around the centered label of the button. For lists, it affects the
  /// distance between baselines of entries in the list.
  ///
  /// Typically, density values are integral, but any value in range may be
  /// used. The range includes values from [VisualDensity.minimumDensity] (which
  /// is -4), to [VisualDensity.maximumDensity] (which is 4), inclusive, where
  /// negative values indicate a denser, more compact, UI, and positive values
  /// indicate a less dense, more expanded, UI. If a component doesn't support
  /// the value given, it will clamp to the nearest supported value.
  ///
  /// The default for visual densities is zero for both vertical and horizontal
  /// densities, which corresponds to the default visual density of components
  /// in the Material Design specification.
  ///
  /// As a rule of thumb, a change of 1 or -1 in density corresponds to 4
  /// logical pixels. However, this is not a strict relationship since
  /// components interpret the density values appropriately for their needs.
  ///
  /// A larger value translates to a spacing increase (less dense), and a
  /// smaller value translates to a spacing decrease (more dense).
  ///
  /// In Material Design 3, the [visualDensity] does not override the value of
  /// [IconButton.visualDensity] which defaults to [VisualDensity.standard]
  /// for all platforms. To override the default value of [IconButton.visualDensity],
  /// use [ThemeData.iconButtonTheme] instead.
  /// {@endtemplate}
  final VisualDensity visualDensity;

  // COLOR

  /// {@macro flutter.material.color_scheme.ColorScheme}
  ///
  /// This property was added much later than the theme's set of highly specific
  /// colors, like [cardColor], [canvasColor] etc. New components can be defined
  /// exclusively in terms of [colorScheme]. Existing components will gradually
  /// migrate to it, to the extent that is possible without significant
  /// backwards compatibility breaks.
  final ColorScheme colorScheme;

  /// A theme for customizing state opacities.
  final StateThemeData stateTheme;

  // TYPOGRAPHY & ICONOGRAPHY

  /// An icon theme that contrasts with the card and canvas colors.
  final IconThemeData iconTheme;

  /// Text with a color that contrasts with the card and canvas colors.
  final TextTheme textTheme;

  /// The color and geometry [TextTheme] values used to configure [textTheme].
  ///
  /// Defaults to a [platform]-appropriate typography.
  final Typography typography;

  // COMPONENT THEMES

  /// A theme for customizing icons of [BackButtonIcon], [CloseButtonIcon],
  /// [DrawerButtonIcon], or [EndDrawerButtonIcon].
  final ActionIconThemeData? actionIconTheme;

  /// A theme for customizing the color, elevation, brightness, iconTheme and
  /// textTheme of [AppBar]s.
  final AppBarTheme appBarTheme;

  /// A theme for customizing the color of [Badge]s.
  final BadgeThemeData badgeTheme;

  /// A theme for customizing the shape, elevation, and color of a [BottomAppBar].
  final BottomAppBarTheme bottomAppBarTheme;

  /// A theme for customizing the appearance and layout of [BottomNavigationBar]
  /// widgets.
  final BottomNavigationBarThemeData bottomNavigationBarTheme;

  /// A theme for customizing the color, elevation, and shape of a bottom sheet.
  final BottomSheetThemeData bottomSheetTheme;

  /// The colors and styles used to render [ElevatedCard].
  ///
  /// This is the value returned from [ElevatedCardTheme.of].
  final CardThemeData elevatedCardTheme;

  /// The colors and styles used to render [FilledCard].
  ///
  /// This is the value returned from [FilledCardTheme.of].
  final CardThemeData filledCardTheme;

  /// The colors and styles used to render [OutlineCard].
  ///
  /// This is the value returned from [OutlineCardTheme.of].
  final CardThemeData outlinedCardTheme;

  /// A theme for customizing the appearance and layout of [Checkbox] widgets.
  final CheckboxThemeData checkboxTheme;

  /// The colors and styles used to render [Chip]s.
  ///
  /// This is the value returned from [ChipTheme.of].
  final ChipThemeData chipTheme;

  /// The style used o render [ChipLists]s.
  ///
  /// This is the value returned from [ChipListTheme.of].
  final ChipListThemeData chipListTheme;

  /// A theme for customizing the appearance and layout of [DatePickerDialog]
  /// widgets.
  final DatePickerThemeData datePickerTheme;

  /// A theme for customizing the shape of a dialog.
  final DialogTheme dialogTheme;

  /// A theme for customizing the color, thickness, and indents of [Divider]s,
  /// [VerticalDivider]s, etc.
  final DividerThemeData dividerTheme;

  /// A theme for customizing the appearance and layout of [Drawer] widgets.
  final DrawerThemeData drawerTheme;

  /// A theme for customizing the appearance and layout of [DropdownMenu] widgets.
  // final DropdownMenuThemeData dropdownMenuTheme;

  /// A theme for customizing the appearance and internal layout of
  /// [ElevatedButton]s.
  final ElevatedButtonThemeData elevatedButtonTheme;

  /// A theme for customizing the shape of an
  /// [ExpandableFloatingActionButton].
  final ExpandableFloatingActionButtonThemeData expandableFloatingActionButtonTheme;

  /// A theme for customizing the visual properties of [ExpansionTile]s.
  final ExpansionTileThemeData expansionTileTheme;

  /// A theme for customizing the appearance and internal layout of
  /// [FilledButton]s.
  final FilledButtonThemeData filledButtonTheme;

  /// A theme for customizing the appearance and internal layout of
  /// [FilledIconButton]s.
  final FilledIconButtonThemeData filledIconButtonTheme;

  /// A theme for customizing the appearance and internal layout of
  /// [FilledTonalButton]s.
  final FilledTonalButtonThemeData filledTonalButtonTheme;

  /// A theme for customizing the appearance and internal layout of
  /// [FilledTonalIconButton]s.
  final FilledTonalIconButtonThemeData filledTonalIconButtonTheme;

  /// A theme for customizing the shape, elevation, and color of a
  /// [FloatingActionButton].
  final FloatingActionButtonThemeData floatingActionButtonTheme;

  /// A theme for customizing the appearance and internal layout of
  /// [IconButton]s.
  final IconButtonThemeData iconButtonTheme;

  /// A theme for customizing the appearance of [ListTile] widgets.
  final ListTileThemeData listTileTheme;

  /// A theme for customizing the color, shape, elevation, and other [MenuStyle]
  /// aspects of the menu bar created by the [MenuBar] widget.
  final MenuBarThemeData menuBarTheme;

  /// A theme for customizing the color, shape, elevation, and text style of
  /// cascading menu buttons created by [SubmenuButton] or [MenuItemButton].
  final MenuButtonThemeData menuButtonTheme;

  /// A theme for customizing the color, shape, elevation, and other [MenuStyle]
  /// attributes of menus created by the [SubmenuButton] widget.
  final MenuThemeData menuTheme;

  /// A theme for customizing the background color, text style, and icon themes
  /// of a [NavigationBar].
  final NavigationBarThemeData navigationBarTheme;

  /// A theme for customizing the background color, text style, and icon themes
  /// of a [NavigationDrawer].
  final NavigationDrawerThemeData navigationDrawerTheme;

  /// A theme for customizing the background color, elevation, text style, and
  /// icon themes of a [NavigationRail].
  final NavigationRailThemeData navigationRailTheme;

  /// A theme for customizing the appearance and internal layout of
  /// [OutlinedButton]s.
  final OutlinedButtonThemeData outlinedButtonTheme;

  /// A theme for customizing the appearance and internal layout of
  /// [OutlinedIconButton]s.
  final OutlinedIconButtonThemeData outlinedIconButtonTheme;

  /// A theme for customizing the color, shape, elevation, and text style of
  /// popup menus.
  final PopupMenuThemeData popupMenuTheme;

  /// A theme for customizing the appearance and layout of [ProgressIndicator] widgets.
  final ProgressIndicatorThemeData progressIndicatorTheme;

  /// A theme for customizing the appearance and layout of [Radio] widgets.
  final RadioThemeData radioTheme;

  /// A theme for customizing the appearance and layout of [SearchBar] widgets.
  final SearchBarThemeData searchBarTheme;

  /// A theme for customizing the appearance and layout of search views created by [SearchAnchor] widgets.
  final SearchViewThemeData searchViewTheme;

  /// A theme for customizing the appearance and layout of [SegmentedButton] widgets.
  final SegmentedButtonThemeData segmentedButtonTheme;

  /// The colors and shapes used to render [Slider].
  ///
  /// This is the value returned from [SliderTheme.of].
  final SliderThemeData sliderTheme;

  /// A theme for customizing colors, shape, elevation, and behavior of a [SnackBar].
  final SnackBarThemeData snackBarTheme;

  /// A theme for customizing the appearance and internal layout of
  /// standard [IconButton]s.
  final IconButtonThemeData standardIconButtonTheme;

  /// A theme for customizing the appearance and layout of [Switch] widgets.
  final SwitchThemeData switchTheme;

  /// A theme for customizing the size, shape, and color of the tab bar indicator.
  final TabBarTheme tabBarTheme;

  /// A theme for customizing the appearance and internal layout of
  /// [TextButton]s.
  final TextButtonThemeData textButtonTheme;

  /// A theme for customizing the appearance and internal layout of
  /// [TextField]s.
  final TextFieldThemeData textFieldTheme;

  /// A theme for customizing the appearance and layout of [TextField] widgets.
  final TextSelectionThemeData textSelectionTheme;

  /// A theme for customizing the appearance and layout of time picker widgets.
  // final TimePickerThemeData timePickerTheme;

  /// A theme for customizing the visual properties of [Tooltip]s.
  ///
  /// This is the value returned from [TooltipTheme.of].
  final TooltipThemeData tooltipTheme;

  // The number 5 was chosen without any real science or research behind it. It
  // copies of ThemeData in memory comfortably) and not too small (most apps
  // shouldn't have more than 5 theme/localization pairs).
  static const int _localizedThemeDataCacheSize = 5;
  /// Caches localized themes to speed up the [localize] method.

  /// Creates a copy of this theme but with the given fields replaced with the new values.
  ///
  /// The [brightness] value is applied to the [colorScheme].
  ThemeData copyWith({
    // For the sanity of the reader, make sure these properties are in the same
    // order in every place that they are separated by section comments (e.g.
    // GENERAL CONFIGURATION). Each section except for deprecations should be
    // alphabetical by symbol name.

    // GENERAL CONFIGURATION
    bool? applyElevationOverlayColor,
    NoDefaultCupertinoThemeData? cupertinoOverrideTheme,
    Iterable<ThemeExtension<dynamic>>? extensions,
    MaterialTapTargetSize? materialTapTargetSize,
    double? minInteractiveDimension,
    bool? alwaysPadTapTarget,
    PageTransitionsTheme? pageTransitionsTheme,
    TargetPlatform? platform,
    ScrollbarThemeData? scrollbarTheme,
    InteractiveInkFeatureFactory? splashFactory,
    VisualDensity? visualDensity,
    // COLOR
    ColorScheme? colorScheme,
    StateThemeData? stateTheme,
    // TYPOGRAPHY & ICONOGRAPHY
    IconThemeData? iconTheme,
    IconThemeData? primaryIconTheme,
    TextTheme? primaryTextTheme,
    TextTheme? textTheme,
    Typography? typography,
    // COMPONENT THEMES
    ActionIconThemeData? actionIconTheme,
    AppBarTheme? appBarTheme,
    BadgeThemeData? badgeTheme,
    BottomAppBarTheme? bottomAppBarTheme,
    BottomNavigationBarThemeData? bottomNavigationBarTheme,
    BottomSheetThemeData? bottomSheetTheme,
    CardThemeData? elevatedCardTheme,
    CardThemeData? filledCardTheme,
    CardThemeData? outlinedCardTheme,
    CheckboxThemeData? checkboxTheme,
    ChipThemeData? chipTheme,
    ChipListThemeData? chipListTheme,
    DatePickerThemeData? datePickerTheme,
    DialogTheme? dialogTheme,
    DividerThemeData? dividerTheme,
    DrawerThemeData? drawerTheme,
    // DropdownMenuThemeData? dropdownMenuTheme,
    ElevatedButtonThemeData? elevatedButtonTheme,
    ExpandableFloatingActionButtonThemeData? expandableFloatingActionButtonTheme,
    ExpansionTileThemeData? expansionTileTheme,
    FilledButtonThemeData? filledButtonTheme,
    FilledIconButtonThemeData? filledIconButtonTheme,
    FilledTonalButtonThemeData? filledTonalButtonTheme,
    FilledTonalIconButtonThemeData? filledTonalIconButtonTheme,
    FloatingActionButtonThemeData? floatingActionButtonTheme,
    IconButtonThemeData? iconButtonTheme,
    ListTileThemeData? listTileTheme,
    MenuBarThemeData? menuBarTheme,
    MenuButtonThemeData? menuButtonTheme,
    MenuThemeData? menuTheme,
    NavigationBarThemeData? navigationBarTheme,
    NavigationDrawerThemeData? navigationDrawerTheme,
    NavigationRailThemeData? navigationRailTheme,
    OutlinedButtonThemeData? outlinedButtonTheme,
    OutlinedIconButtonThemeData? outlinedIconButtonTheme,
    PopupMenuThemeData? popupMenuTheme,
    ProgressIndicatorThemeData? progressIndicatorTheme,
    RadioThemeData? radioTheme,
    SearchBarThemeData? searchBarTheme,
    SearchViewThemeData? searchViewTheme,
    SegmentedButtonThemeData? segmentedButtonTheme,
    SliderThemeData? sliderTheme,
    SnackBarThemeData? snackBarTheme,
    IconButtonThemeData? standardIconButtonTheme,
    SwitchThemeData? switchTheme,
    TabBarTheme? tabBarTheme,
    TextButtonThemeData? textButtonTheme,
    TextFieldThemeData? textFieldTheme,
    TextSelectionThemeData? textSelectionTheme,
    // TimePickerThemeData? timePickerTheme,
    TooltipThemeData? tooltipTheme,
  }) {
    cupertinoOverrideTheme = cupertinoOverrideTheme?.noDefault();
    return ThemeData.raw(
      // For the sanity of the reader, make sure these properties are in the same
      // order in every place that they are separated by section comments (e.g.
      // GENERAL CONFIGURATION). Each section except for deprecations should be
      // alphabetical by symbol name.

      // GENERAL CONFIGURATION
      cupertinoOverrideTheme: cupertinoOverrideTheme ?? this.cupertinoOverrideTheme,
      extensions: (extensions != null) ? _themeExtensionIterableToMap(extensions) : this.extensions,
      materialTapTargetSize: materialTapTargetSize ?? this.materialTapTargetSize,
      minInteractiveDimension: minInteractiveDimension ?? this.minInteractiveDimension,
      alwaysPadTapTarget: alwaysPadTapTarget ?? this.alwaysPadTapTarget,
      pageTransitionsTheme: pageTransitionsTheme ?? this.pageTransitionsTheme,
      platform: platform ?? this.platform,
      scrollbarTheme: scrollbarTheme ?? this.scrollbarTheme,
      splashFactory: splashFactory ?? this.splashFactory,
      visualDensity: visualDensity ?? this.visualDensity,
      // COLOR
      colorScheme: colorScheme ?? this.colorScheme,
      stateTheme: stateTheme ?? this.stateTheme,
      // TYPOGRAPHY & ICONOGRAPHY
      iconTheme: iconTheme ?? this.iconTheme,
      textTheme: textTheme ?? this.textTheme,
      typography: typography ?? this.typography,
      // COMPONENT THEMES
      actionIconTheme: actionIconTheme ?? this.actionIconTheme,
      appBarTheme: appBarTheme ?? this.appBarTheme,
      badgeTheme: badgeTheme ?? this.badgeTheme,
      bottomAppBarTheme: bottomAppBarTheme ?? this.bottomAppBarTheme,
      bottomNavigationBarTheme: bottomNavigationBarTheme ?? this.bottomNavigationBarTheme,
      bottomSheetTheme: bottomSheetTheme ?? this.bottomSheetTheme,
      elevatedCardTheme: elevatedCardTheme ?? this.elevatedCardTheme,
      filledCardTheme: filledCardTheme ?? this.filledCardTheme,
      outlinedCardTheme: outlinedCardTheme ?? this.outlinedCardTheme,
      checkboxTheme: checkboxTheme ?? this.checkboxTheme,
      chipTheme: chipTheme ?? this.chipTheme,
      chipListTheme: chipListTheme ?? this.chipListTheme,
      datePickerTheme: datePickerTheme ?? this.datePickerTheme,
      dialogTheme: dialogTheme ?? this.dialogTheme,
      dividerTheme: dividerTheme ?? this.dividerTheme,
      drawerTheme: drawerTheme ?? this.drawerTheme,
      // dropdownMenuTheme: dropdownMenuTheme ?? this.dropdownMenuTheme,
      elevatedButtonTheme: elevatedButtonTheme ?? this.elevatedButtonTheme,
      expandableFloatingActionButtonTheme: expandableFloatingActionButtonTheme ?? this.expandableFloatingActionButtonTheme,
      expansionTileTheme: expansionTileTheme ?? this.expansionTileTheme,
      filledButtonTheme: filledButtonTheme ?? this.filledButtonTheme,
      filledIconButtonTheme: filledIconButtonTheme ?? this.filledIconButtonTheme,
      filledTonalButtonTheme: filledTonalButtonTheme ?? this.filledTonalButtonTheme,
      filledTonalIconButtonTheme: filledTonalIconButtonTheme ?? this.filledTonalIconButtonTheme,
      floatingActionButtonTheme: floatingActionButtonTheme ?? this.floatingActionButtonTheme,
      iconButtonTheme: iconButtonTheme ?? this.iconButtonTheme,
      listTileTheme: listTileTheme ?? this.listTileTheme,
      menuBarTheme: menuBarTheme ?? this.menuBarTheme,
      menuButtonTheme: menuButtonTheme ?? this.menuButtonTheme,
      menuTheme: menuTheme ?? this.menuTheme,
      navigationBarTheme: navigationBarTheme ?? this.navigationBarTheme,
      navigationDrawerTheme: navigationDrawerTheme ?? this.navigationDrawerTheme,
      navigationRailTheme: navigationRailTheme ?? this.navigationRailTheme,
      outlinedButtonTheme: outlinedButtonTheme ?? this.outlinedButtonTheme,
      outlinedIconButtonTheme: outlinedIconButtonTheme ?? this.outlinedIconButtonTheme,
      popupMenuTheme: popupMenuTheme ?? this.popupMenuTheme,
      progressIndicatorTheme: progressIndicatorTheme ?? this.progressIndicatorTheme,
      radioTheme: radioTheme ?? this.radioTheme,
      searchBarTheme: searchBarTheme ?? this.searchBarTheme,
      searchViewTheme: searchViewTheme ?? this.searchViewTheme,
      segmentedButtonTheme: segmentedButtonTheme ?? this.segmentedButtonTheme,
      sliderTheme: sliderTheme ?? this.sliderTheme,
      snackBarTheme: snackBarTheme ?? this.snackBarTheme,
      standardIconButtonTheme: standardIconButtonTheme ?? this.standardIconButtonTheme,
      switchTheme: switchTheme ?? this.switchTheme,
      tabBarTheme: tabBarTheme ?? this.tabBarTheme,
      textButtonTheme: textButtonTheme ?? this.textButtonTheme,
      textFieldTheme: textFieldTheme ?? this.textFieldTheme,
      textSelectionTheme: textSelectionTheme ?? this.textSelectionTheme,
      // timePickerTheme: timePickerTheme ?? this.timePickerTheme,
      tooltipTheme: tooltipTheme ?? this.tooltipTheme,
    );
  }

  // just seemed like a number that's not too big (we should be able to fit 5
  static final _FifoCache<_IdentityThemeDataCacheKey, ThemeData> _localizedThemeDataCache =
      _FifoCache<_IdentityThemeDataCacheKey, ThemeData>(_localizedThemeDataCacheSize);

  /// Returns a new theme built by merging the text geometry provided by the
  /// [localTextGeometry] theme with the [baseTheme].
  ///
  /// For those text styles in the [baseTheme] whose [TextStyle.inherit] is set
  /// to true, the returned theme's text styles inherit the geometric properties
  /// of [localTextGeometry]. The resulting text styles' [TextStyle.inherit] is
  /// set to those provided by [localTextGeometry].
  static ThemeData localize(ThemeData baseTheme, TextTheme localTextGeometry) {
    // WARNING: this method memoizes the result in a cache based on the
    // previously seen baseTheme and localTextGeometry. Memoization is safe
    // because all inputs and outputs of this function are deeply immutable, and
    // the computations are referentially transparent. It only short-circuits
    // the computation if the new inputs are identical() to the previous ones.
    // It does not use the == operator, which performs a costly deep comparison.
    //
    // When changing this method, make sure the memoization logic is correct.
    // Remember:
    //
    // There are only two hard things in Computer Science: cache invalidation
    // and naming things. -- Phil Karlton

    return _localizedThemeDataCache.putIfAbsent(
      _IdentityThemeDataCacheKey(baseTheme, localTextGeometry),
      () {
        return baseTheme.copyWith(
          textTheme: localTextGeometry.merge(baseTheme.textTheme),
        );
      },
    );
  }

  /// Determines whether the given [Color] is [Brightness.light] or
  /// [Brightness.dark].
  ///
  /// This compares the luminosity of the given color to a threshold value that
  /// matches the Material Design specification.
  static Brightness estimateBrightnessForColor(Color color) {
    final double relativeLuminance = color.computeLuminance();

    // See <https://www.w3.org/TR/WCAG20/#contrast-ratiodef>
    // The spec says to use kThreshold=0.0525, but Material Design appears to bias
    // more towards using light text than WCAG20 recommends. Material Design spec
    // doesn't say what value to use, but 0.15 seemed close to what the Material
    // Design spec shows for its color palette on
    // <https://material.io/go/design-theming#color-color-palette>.
    const double kThreshold = 0.15;
    if ((relativeLuminance + 0.05) * (relativeLuminance + 0.05) > kThreshold) {
      return Brightness.light;
    }
    return Brightness.dark;
  }

  /// Linearly interpolate between two [extensions].
  ///
  /// Includes all theme extensions in [a] and [b].
  ///
  /// {@macro dart.ui.shadow.lerp}
  static Map<Object, ThemeExtension<dynamic>> _lerpThemeExtensions(ThemeData a, ThemeData b, double t) {
    // Lerp [a].
    final Map<Object, ThemeExtension<dynamic>> newExtensions = a.extensions.map((Object id, ThemeExtension<dynamic> extensionA) {
        final ThemeExtension<dynamic>? extensionB = b.extensions[id];
        return MapEntry<Object, ThemeExtension<dynamic>>(id, extensionA.lerp(extensionB, t));
      });
    // Add [b]-only extensions.
    newExtensions.addEntries(b.extensions.entries.where(
      (MapEntry<Object, ThemeExtension<dynamic>> entry) =>
          !a.extensions.containsKey(entry.key)));

    return newExtensions;
  }

  /// Convert the [extensionsIterable] passed to [ThemeData.new] or [copyWith]
  /// to the stored [extensions] map, where each entry's key consists of the extension's type.
  static Map<Object, ThemeExtension<dynamic>> _themeExtensionIterableToMap(Iterable<ThemeExtension<dynamic>> extensionsIterable) {
    return Map<Object, ThemeExtension<dynamic>>.unmodifiable(<Object, ThemeExtension<dynamic>>{
      // Strangely, the cast is necessary for tests to run.
      for (final ThemeExtension<dynamic> extension in extensionsIterable) extension.type: extension as ThemeExtension<ThemeExtension<dynamic>>,
    });
  }

  /// Linearly interpolate between two themes.
  ///
  /// The arguments must not be null.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static ThemeData lerp(ThemeData a, ThemeData b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return ThemeData.raw(
      // For the sanity of the reader, make sure these properties are in the same
      // order in every place that they are separated by section comments (e.g.
      // GENERAL CONFIGURATION). Each section except for deprecations should be
      // alphabetical by symbol name.

      // GENERAL CONFIGURATION
      cupertinoOverrideTheme: t < 0.5 ? a.cupertinoOverrideTheme : b.cupertinoOverrideTheme,
      extensions: _lerpThemeExtensions(a, b, t),
      materialTapTargetSize: t < 0.5 ? a.materialTapTargetSize : b.materialTapTargetSize,
      minInteractiveDimension: lerpDouble(a.minInteractiveDimension, b.minInteractiveDimension, t)!,
      alwaysPadTapTarget: t < 0.5 ? a.alwaysPadTapTarget : b.alwaysPadTapTarget,
      pageTransitionsTheme: t < 0.5 ? a.pageTransitionsTheme : b.pageTransitionsTheme,
      platform: t < 0.5 ? a.platform : b.platform,
      scrollbarTheme: ScrollbarThemeData.lerp(a.scrollbarTheme, b.scrollbarTheme, t),
      splashFactory: t < 0.5 ? a.splashFactory : b.splashFactory,
      visualDensity: VisualDensity.lerp(a.visualDensity, b.visualDensity, t),
      // COLOR
      colorScheme: ColorScheme.lerp(a.colorScheme, b.colorScheme, t),
      stateTheme: StateThemeData.lerp(a.stateTheme, b.stateTheme, t),
      // TYPOGRAPHY & ICONOGRAPHY
      iconTheme: IconThemeData.lerp(a.iconTheme, b.iconTheme, t),
      textTheme: TextTheme.lerp(a.textTheme, b.textTheme, t)!,
      typography: Typography.lerp(a.typography, b.typography, t),
      // COMPONENT THEMES
      actionIconTheme: ActionIconThemeData.lerp(a.actionIconTheme, b.actionIconTheme, t),
      appBarTheme: AppBarTheme.lerp(a.appBarTheme, b.appBarTheme, t),
      badgeTheme: BadgeThemeData.lerp(a.badgeTheme, b.badgeTheme, t),
      bottomAppBarTheme: BottomAppBarTheme.lerp(a.bottomAppBarTheme, b.bottomAppBarTheme, t),
      bottomNavigationBarTheme: BottomNavigationBarThemeData.lerp(a.bottomNavigationBarTheme, b.bottomNavigationBarTheme, t),
      bottomSheetTheme: BottomSheetThemeData.lerp(a.bottomSheetTheme, b.bottomSheetTheme, t)!,
      elevatedCardTheme: CardThemeData.lerp(a.elevatedCardTheme, b.elevatedCardTheme, t),
      filledCardTheme: CardThemeData.lerp(a.filledCardTheme, b.filledCardTheme, t),
      outlinedCardTheme: CardThemeData.lerp(a.outlinedCardTheme, b.outlinedCardTheme, t),
      checkboxTheme: CheckboxThemeData.lerp(a.checkboxTheme, b.checkboxTheme, t),
      chipTheme: ChipThemeData.lerp(a.chipTheme, b.chipTheme, t)!,
      chipListTheme: ChipListThemeData.lerp(a.chipListTheme, b.chipListTheme, t)!,
      datePickerTheme: DatePickerThemeData.lerp(a.datePickerTheme, b.datePickerTheme, t),
      dialogTheme: DialogTheme.lerp(a.dialogTheme, b.dialogTheme, t),
      dividerTheme: DividerThemeData.lerp(a.dividerTheme, b.dividerTheme, t),
      drawerTheme: DrawerThemeData.lerp(a.drawerTheme, b.drawerTheme, t)!,
      // dropdownMenuTheme: DropdownMenuThemeData.lerp(a.dropdownMenuTheme, b.dropdownMenuTheme, t),
      elevatedButtonTheme: ElevatedButtonThemeData.lerp(a.elevatedButtonTheme, b.elevatedButtonTheme, t)!,
      expandableFloatingActionButtonTheme: ExpandableFloatingActionButtonThemeData.lerp(a.expandableFloatingActionButtonTheme, b.expandableFloatingActionButtonTheme, t)!,
      expansionTileTheme: ExpansionTileThemeData.lerp(a.expansionTileTheme, b.expansionTileTheme, t)!,
      filledButtonTheme: FilledButtonThemeData.lerp(a.filledButtonTheme, b.filledButtonTheme, t)!,
      filledIconButtonTheme: FilledIconButtonThemeData.lerp(a.filledIconButtonTheme, b.filledIconButtonTheme, t)!,
      filledTonalButtonTheme: FilledTonalButtonThemeData.lerp(a.filledTonalButtonTheme, b.filledTonalButtonTheme, t)!,
      filledTonalIconButtonTheme: FilledTonalIconButtonThemeData.lerp(a.filledTonalIconButtonTheme, b.filledTonalIconButtonTheme, t)!,
      floatingActionButtonTheme: FloatingActionButtonThemeData.lerp(a.floatingActionButtonTheme, b.floatingActionButtonTheme, t)!,
      iconButtonTheme: IconButtonThemeData.lerp(a.iconButtonTheme, b.iconButtonTheme, t)!,
      listTileTheme: ListTileThemeData.lerp(a.listTileTheme, b.listTileTheme, t)!,
      menuBarTheme: MenuBarThemeData.lerp(a.menuBarTheme, b.menuBarTheme, t)!,
      menuButtonTheme: MenuButtonThemeData.lerp(a.menuButtonTheme, b.menuButtonTheme, t)!,
      menuTheme: MenuThemeData.lerp(a.menuTheme, b.menuTheme, t)!,
      navigationBarTheme: NavigationBarThemeData.lerp(a.navigationBarTheme, b.navigationBarTheme, t)!,
      navigationDrawerTheme: NavigationDrawerThemeData.lerp(a.navigationDrawerTheme, b.navigationDrawerTheme, t)!,
      navigationRailTheme: NavigationRailThemeData.lerp(a.navigationRailTheme, b.navigationRailTheme, t)!,
      outlinedButtonTheme: OutlinedButtonThemeData.lerp(a.outlinedButtonTheme, b.outlinedButtonTheme, t)!,
      outlinedIconButtonTheme: OutlinedIconButtonThemeData.lerp(a.outlinedIconButtonTheme, b.outlinedIconButtonTheme, t)!,
      popupMenuTheme: PopupMenuThemeData.lerp(a.popupMenuTheme, b.popupMenuTheme, t)!,
      progressIndicatorTheme: ProgressIndicatorThemeData.lerp(a.progressIndicatorTheme, b.progressIndicatorTheme, t)!,
      radioTheme: RadioThemeData.lerp(a.radioTheme, b.radioTheme, t),
      searchBarTheme: SearchBarThemeData.lerp(a.searchBarTheme, b.searchBarTheme, t)!,
      searchViewTheme: SearchViewThemeData.lerp(a.searchViewTheme, b.searchViewTheme, t)!,
      segmentedButtonTheme: SegmentedButtonThemeData.lerp(a.segmentedButtonTheme, b.segmentedButtonTheme, t),
      sliderTheme: SliderThemeData.lerp(a.sliderTheme, b.sliderTheme, t),
      snackBarTheme: SnackBarThemeData.lerp(a.snackBarTheme, b.snackBarTheme, t),
      standardIconButtonTheme: IconButtonThemeData.lerp(a.standardIconButtonTheme, b.standardIconButtonTheme, t)!,
      switchTheme: SwitchThemeData.lerp(a.switchTheme, b.switchTheme, t),
      tabBarTheme: TabBarTheme.lerp(a.tabBarTheme, b.tabBarTheme, t),
      textButtonTheme: TextButtonThemeData.lerp(a.textButtonTheme, b.textButtonTheme, t)!,
      textFieldTheme: TextFieldThemeData.lerp(a.textFieldTheme, b.textFieldTheme, t)!,
      textSelectionTheme: TextSelectionThemeData.lerp(a.textSelectionTheme, b.textSelectionTheme, t)!,
      // timePickerTheme: TimePickerThemeData.lerp(a.timePickerTheme, b.timePickerTheme, t),
      tooltipTheme: TooltipThemeData.lerp(a.tooltipTheme, b.tooltipTheme, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is ThemeData &&
        // For the sanity of the reader, make sure these properties are in the same
        // order in every place that they are separated by section comments (e.g.
        // GENERAL CONFIGURATION). Each section except for deprecations should be
        // alphabetical by symbol name.

        // GENERAL CONFIGURATION
        other.cupertinoOverrideTheme == cupertinoOverrideTheme &&
        mapEquals(other.extensions, extensions) &&
        other.materialTapTargetSize == materialTapTargetSize &&
        other.minInteractiveDimension == minInteractiveDimension &&
        other.alwaysPadTapTarget == alwaysPadTapTarget &&
        other.pageTransitionsTheme == pageTransitionsTheme &&
        other.platform == platform &&
        other.scrollbarTheme == scrollbarTheme &&
        other.splashFactory == splashFactory &&
        other.visualDensity == visualDensity &&
        // COLOR
        other.colorScheme == colorScheme &&
        other.stateTheme == stateTheme &&
        // TYPOGRAPHY & ICONOGRAPHY
        other.iconTheme == iconTheme &&
        other.textTheme == textTheme &&
        other.typography == typography &&
        // COMPONENT THEMES
        other.actionIconTheme == actionIconTheme &&
        other.appBarTheme == appBarTheme &&
        other.badgeTheme == badgeTheme &&
        other.bottomAppBarTheme == bottomAppBarTheme &&
        other.bottomNavigationBarTheme == bottomNavigationBarTheme &&
        other.bottomSheetTheme == bottomSheetTheme &&
        other.elevatedCardTheme == elevatedCardTheme &&
        other.filledCardTheme == filledCardTheme &&
        other.outlinedCardTheme == outlinedCardTheme &&
        other.checkboxTheme == checkboxTheme &&
        other.chipTheme == chipTheme &&
        other.chipListTheme == chipListTheme &&
        other.datePickerTheme == datePickerTheme &&
        other.dialogTheme == dialogTheme &&
        other.dividerTheme == dividerTheme &&
        other.drawerTheme == drawerTheme &&
        // other.dropdownMenuTheme == dropdownMenuTheme &&
        other.elevatedButtonTheme == elevatedButtonTheme &&
        other.expandableFloatingActionButtonTheme == expandableFloatingActionButtonTheme &&
        other.expansionTileTheme == expansionTileTheme &&
        other.filledButtonTheme == filledButtonTheme &&
        other.filledIconButtonTheme == filledIconButtonTheme &&
        other.filledTonalButtonTheme == filledTonalButtonTheme &&
        other.filledTonalIconButtonTheme == filledTonalIconButtonTheme &&
        other.floatingActionButtonTheme == floatingActionButtonTheme &&
        other.iconButtonTheme == iconButtonTheme &&
        other.listTileTheme == listTileTheme &&
        other.menuBarTheme == menuBarTheme &&
        other.menuButtonTheme == menuButtonTheme &&
        other.menuTheme == menuTheme &&
        other.navigationBarTheme == navigationBarTheme &&
        other.navigationDrawerTheme == navigationDrawerTheme &&
        other.navigationRailTheme == navigationRailTheme &&
        other.outlinedButtonTheme == outlinedButtonTheme &&
        other.outlinedIconButtonTheme == outlinedIconButtonTheme &&
        other.popupMenuTheme == popupMenuTheme &&
        other.progressIndicatorTheme == progressIndicatorTheme &&
        other.radioTheme == radioTheme &&
        other.searchBarTheme == searchBarTheme &&
        other.searchViewTheme == searchViewTheme &&
        other.segmentedButtonTheme == segmentedButtonTheme &&
        other.sliderTheme == sliderTheme &&
        other.snackBarTheme == snackBarTheme &&
        other.standardIconButtonTheme == standardIconButtonTheme &&
        other.switchTheme == switchTheme &&
        other.tabBarTheme == tabBarTheme &&
        other.textFieldTheme == textFieldTheme &&
        other.textButtonTheme == textButtonTheme &&
        other.textSelectionTheme == textSelectionTheme &&
        // other.timePickerTheme == timePickerTheme &&
        other.tooltipTheme == tooltipTheme;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      // For the sanity of the reader, make sure these properties are in the same
      // order in every place that they are separated by section comments (e.g.
      // GENERAL CONFIGURATION). Each section except for deprecations should be
      // alphabetical by symbol name.

      // GENERAL CONFIGURATION
      cupertinoOverrideTheme,
      ...extensions.keys,
      ...extensions.values,
      materialTapTargetSize,
      minInteractiveDimension,
      alwaysPadTapTarget,
      pageTransitionsTheme,
      platform,
      scrollbarTheme,
      splashFactory,
      visualDensity,
      // COLOR
      colorScheme,
      stateTheme,
      // TYPOGRAPHY & ICONOGRAPHY
      iconTheme,
      textTheme,
      typography,
      // COMPONENT THEMES
      actionIconTheme,
      appBarTheme,
      badgeTheme,
      bottomAppBarTheme,
      bottomNavigationBarTheme,
      bottomSheetTheme,
      elevatedCardTheme,
      filledCardTheme,
      outlinedCardTheme,
      checkboxTheme,
      chipTheme,
      chipListTheme,
      datePickerTheme,
      dialogTheme,
      dividerTheme,
      drawerTheme,
      // dropdownMenuTheme,
      elevatedButtonTheme,
      expandableFloatingActionButtonTheme,
      expansionTileTheme,
      filledButtonTheme,
      filledIconButtonTheme,
      filledTonalButtonTheme,
      filledTonalIconButtonTheme,
      floatingActionButtonTheme,
      iconButtonTheme,
      listTileTheme,
      menuBarTheme,
      menuButtonTheme,
      menuTheme,
      navigationBarTheme,
      navigationDrawerTheme,
      navigationRailTheme,
      outlinedButtonTheme,
      outlinedIconButtonTheme,
      popupMenuTheme,
      progressIndicatorTheme,
      radioTheme,
      searchBarTheme,
      searchViewTheme,
      segmentedButtonTheme,
      sliderTheme,
      snackBarTheme,
      standardIconButtonTheme,
      switchTheme,
      tabBarTheme,
      textButtonTheme,
      textFieldTheme,
      textSelectionTheme,
      // timePickerTheme,
      tooltipTheme,
    ];
    return Object.hashAll(values);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final ThemeData defaultData = ThemeData.fallback();
    // For the sanity of the reader, make sure these properties are in the same
    // order in every place that they are separated by section comments (e.g.
    // GENERAL CONFIGURATION). Each section except for deprecations should be
    // alphabetical by symbol name.

    // GENERAL CONFIGURATION
    properties.add(DiagnosticsProperty<NoDefaultCupertinoThemeData>('cupertinoOverrideTheme', cupertinoOverrideTheme, defaultValue: defaultData.cupertinoOverrideTheme, level: DiagnosticLevel.debug));
    properties.add(IterableProperty<ThemeExtension<dynamic>>('extensions', extensions.values, defaultValue: defaultData.extensions.values, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<MaterialTapTargetSize>('materialTapTargetSize', materialTapTargetSize, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<double>('minInteractiveDimension', minInteractiveDimension, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<bool>('alwaysPadTapTarget', alwaysPadTapTarget, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<PageTransitionsTheme>('pageTransitionsTheme', pageTransitionsTheme, level: DiagnosticLevel.debug));
    properties.add(EnumProperty<TargetPlatform>('platform', platform, defaultValue: defaultTargetPlatform, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<ScrollbarThemeData>('scrollbarTheme', scrollbarTheme, defaultValue: defaultData.scrollbarTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<InteractiveInkFeatureFactory>('splashFactory', splashFactory, defaultValue: defaultData.splashFactory, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<VisualDensity>('visualDensity', visualDensity, defaultValue: defaultData.visualDensity, level: DiagnosticLevel.debug));
    // COLORS
    properties.add(DiagnosticsProperty<ColorScheme>('colorScheme', colorScheme, defaultValue: defaultData.colorScheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<StateThemeData>('stateTheme', stateTheme, defaultValue: defaultData.stateTheme, level: DiagnosticLevel.debug));
    // TYPOGRAPHY & ICONOGRAPHY
    properties.add(DiagnosticsProperty<IconThemeData>('iconTheme', iconTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<TextTheme>('textTheme', textTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<Typography>('typography', typography, defaultValue: defaultData.typography, level: DiagnosticLevel.debug));
    // COMPONENT THEMES
    properties.add(DiagnosticsProperty<ActionIconThemeData>('actionIconTheme', actionIconTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<AppBarTheme>('appBarTheme', appBarTheme, defaultValue: defaultData.appBarTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<BadgeThemeData>('badgeTheme', badgeTheme, defaultValue: defaultData.badgeTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<BottomAppBarTheme>('bottomAppBarTheme', bottomAppBarTheme, defaultValue: defaultData.bottomAppBarTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<BottomNavigationBarThemeData>('bottomNavigationBarTheme', bottomNavigationBarTheme, defaultValue: defaultData.bottomNavigationBarTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<BottomSheetThemeData>('bottomSheetTheme', bottomSheetTheme, defaultValue: defaultData.bottomSheetTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<CardThemeData>('elevatedCardTheme', elevatedCardTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<CardThemeData>('filledCardTheme', filledCardTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<CardThemeData>('outlinedCardTheme', outlinedCardTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<CheckboxThemeData>('checkboxTheme', checkboxTheme, defaultValue: defaultData.checkboxTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<ChipThemeData>('chipTheme', chipTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<DatePickerThemeData>('datePickerTheme', datePickerTheme, defaultValue: defaultData.datePickerTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<DialogTheme>('dialogTheme', dialogTheme, defaultValue: defaultData.dialogTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<DividerThemeData>('dividerTheme', dividerTheme, defaultValue: defaultData.dividerTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<DrawerThemeData>('drawerTheme', drawerTheme, defaultValue: defaultData.drawerTheme, level: DiagnosticLevel.debug));
    // properties.add(DiagnosticsProperty<DropdownMenuThemeData>('dropdownMenuTheme', dropdownMenuTheme, defaultValue: defaultData.dropdownMenuTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<ElevatedButtonThemeData>('elevatedButtonTheme', elevatedButtonTheme, defaultValue: defaultData.elevatedButtonTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<ExpansionTileThemeData>('expansionTileTheme', expansionTileTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<ExpandableFloatingActionButtonThemeData>('expandableFloatingActionButtonTheme', expandableFloatingActionButtonTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<FilledButtonThemeData>('filledButtonTheme', filledButtonTheme, defaultValue: defaultData.filledButtonTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<FilledIconButtonThemeData>('filledIconButtonTheme', filledIconButtonTheme, defaultValue: defaultData.filledIconButtonTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<FilledTonalButtonThemeData>('filledTonalButtonTheme', filledTonalButtonTheme, defaultValue: defaultData.filledTonalButtonTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<FilledTonalIconButtonThemeData>('filledTonalIconButtonTheme', filledTonalIconButtonTheme, defaultValue: defaultData.filledTonalIconButtonTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<FloatingActionButtonThemeData>('floatingActionButtonTheme', floatingActionButtonTheme, defaultValue: defaultData.floatingActionButtonTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<IconButtonThemeData>('iconButtonTheme', iconButtonTheme, defaultValue: defaultData.iconButtonTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<ListTileThemeData>('listTileTheme', listTileTheme, defaultValue: defaultData.listTileTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<MenuBarThemeData>('menuBarTheme', menuBarTheme, defaultValue: defaultData.menuBarTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<MenuButtonThemeData>('menuButtonTheme', menuButtonTheme, defaultValue: defaultData.menuButtonTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<MenuThemeData>('menuTheme', menuTheme, defaultValue: defaultData.menuTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<NavigationBarThemeData>('navigationBarTheme', navigationBarTheme, defaultValue: defaultData.navigationBarTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<NavigationDrawerThemeData>('navigationDrawerTheme', navigationDrawerTheme, defaultValue: defaultData.navigationDrawerTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<NavigationRailThemeData>('navigationRailTheme', navigationRailTheme, defaultValue: defaultData.navigationRailTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<OutlinedButtonThemeData>('outlinedButtonTheme', outlinedButtonTheme, defaultValue: defaultData.outlinedButtonTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<OutlinedIconButtonThemeData>('outlinedIconButtonTheme', outlinedIconButtonTheme, defaultValue: defaultData.outlinedIconButtonTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<PopupMenuThemeData>('popupMenuTheme', popupMenuTheme, defaultValue: defaultData.popupMenuTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<ProgressIndicatorThemeData>('progressIndicatorTheme', progressIndicatorTheme, defaultValue: defaultData.progressIndicatorTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<RadioThemeData>('radioTheme', radioTheme, defaultValue: defaultData.radioTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<SearchBarThemeData>('searchBarTheme', searchBarTheme, defaultValue: defaultData.searchBarTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<SearchViewThemeData>('searchViewTheme', searchViewTheme, defaultValue: defaultData.searchViewTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<SegmentedButtonThemeData>('segmentedButtonTheme', segmentedButtonTheme, defaultValue: defaultData.segmentedButtonTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<SliderThemeData>('sliderTheme', sliderTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<SnackBarThemeData>('snackBarTheme', snackBarTheme, defaultValue: defaultData.snackBarTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<IconButtonThemeData>('standardIconButtonTheme', standardIconButtonTheme, defaultValue: defaultData.standardIconButtonTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<SwitchThemeData>('switchTheme', switchTheme, defaultValue: defaultData.switchTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<TabBarTheme>('tabBarTheme', tabBarTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<TextButtonThemeData>('textButtonTheme', textButtonTheme, defaultValue: defaultData.textButtonTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<TextFieldThemeData>('textFieldTheme', textFieldTheme, defaultValue: defaultData.textFieldTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<TextSelectionThemeData>('textSelectionTheme', textSelectionTheme, defaultValue: defaultData.textSelectionTheme, level: DiagnosticLevel.debug));
    // properties.add(DiagnosticsProperty<TimePickerThemeData>('timePickerTheme', timePickerTheme, defaultValue: defaultData.timePickerTheme, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<TooltipThemeData>('tooltipTheme', tooltipTheme, level: DiagnosticLevel.debug));
  }
}

/// A [CupertinoThemeData] that defers unspecified theme attributes to an
/// upstream Material [ThemeData].
///
/// This type of [CupertinoThemeData] is used by the Material [Theme] to
/// harmonize the [CupertinoTheme] with the material theme's colors and text
/// styles.
///
/// In the most basic case, [ThemeData]'s `cupertinoOverrideTheme` is null and
/// descendant Cupertino widgets' styling is derived from the Material theme.
///
/// To override individual parts of the Material-derived Cupertino styling,
/// `cupertinoOverrideTheme`'s construction parameters can be used.
///
/// To completely decouple the Cupertino styling from Material theme derivation,
/// another [CupertinoTheme] widget can be inserted as a descendant of the
/// Material [Theme]. On a [MaterialApp], this can be done using the `builder`
/// parameter on the constructor.
///
/// See also:
///
///  * [CupertinoThemeData], whose null constructor parameters default to
///    reasonable iOS styling defaults rather than harmonizing with a Material
///    theme.
///  * [Theme], widget which inserts a [CupertinoTheme] with this
///    [MaterialBasedCupertinoThemeData].
// This class subclasses CupertinoThemeData rather than composes one because it
// _is_ a CupertinoThemeData with partially altered behavior. e.g. its textTheme
// is from the superclass and based on the primaryColor but the primaryColor
// comes from the Material theme unless overridden.
class MaterialBasedCupertinoThemeData extends CupertinoThemeData {
  /// Create a [MaterialBasedCupertinoThemeData] based on a Material [ThemeData]
  /// and its `cupertinoOverrideTheme`.
  ///
  /// The [materialTheme] parameter must not be null.
  MaterialBasedCupertinoThemeData({
    required ThemeData materialTheme,
  }) : this._(
    materialTheme,
    (materialTheme.cupertinoOverrideTheme ?? const CupertinoThemeData()).noDefault(),
  );

  MaterialBasedCupertinoThemeData._(
    this._materialTheme,
    this._cupertinoOverrideTheme,
  ) : // Pass all values to the superclass so Material-agnostic properties
      // like barBackgroundColor can still behave like a normal
      // CupertinoThemeData.
      super.raw(
        _cupertinoOverrideTheme.brightness,
        _cupertinoOverrideTheme.primaryColor,
        _cupertinoOverrideTheme.primaryContrastingColor,
        _cupertinoOverrideTheme.textTheme,
        _cupertinoOverrideTheme.barBackgroundColor,
        _cupertinoOverrideTheme.scaffoldBackgroundColor,
        _cupertinoOverrideTheme.applyThemeToAll,
      );

  final ThemeData _materialTheme;
  final NoDefaultCupertinoThemeData _cupertinoOverrideTheme;

  @override
  Brightness get brightness => _cupertinoOverrideTheme.brightness ?? _materialTheme.brightness;

  @override
  Color get primaryColor => _cupertinoOverrideTheme.primaryColor ?? _materialTheme.colorScheme.primary;

  @override
  Color get primaryContrastingColor => _cupertinoOverrideTheme.primaryContrastingColor ?? _materialTheme.colorScheme.onPrimary;

  @override
  Color get scaffoldBackgroundColor => _cupertinoOverrideTheme.scaffoldBackgroundColor ?? _materialTheme.colorScheme.surface;

  /// Copies the [ThemeData]'s `cupertinoOverrideTheme`.
  ///
  /// Only the specified override attributes of the [ThemeData]'s
  /// `cupertinoOverrideTheme` and the newly specified parameters are in the
  /// returned [CupertinoThemeData]. No derived attributes from iOS defaults or
  /// from cascaded Material theme attributes are copied.
  ///
  /// This [copyWith] cannot change the base Material [ThemeData]. To change the
  /// base Material [ThemeData], create a new Material [Theme] and use
  /// [ThemeData.copyWith] on the Material [ThemeData] instead.
  @override
  MaterialBasedCupertinoThemeData copyWith({
    Brightness? brightness,
    Color? primaryColor,
    Color? primaryContrastingColor,
    CupertinoTextThemeData? textTheme,
    Color? barBackgroundColor,
    Color? scaffoldBackgroundColor,
    bool? applyThemeToAll,
  }) {
    return MaterialBasedCupertinoThemeData._(
      _materialTheme,
      _cupertinoOverrideTheme.copyWith(
        brightness: brightness,
        primaryColor: primaryColor,
        primaryContrastingColor: primaryContrastingColor,
        textTheme: textTheme,
        barBackgroundColor: barBackgroundColor,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        applyThemeToAll: applyThemeToAll,
      ),
    );
  }

  @override
  CupertinoThemeData resolveFrom(BuildContext context) {
    // Only the cupertino override theme part will be resolved.
    // If the color comes from the material theme it's not resolved.
    return MaterialBasedCupertinoThemeData._(
      _materialTheme,
      _cupertinoOverrideTheme.resolveFrom(context),
    );
  }
}

@immutable
class _IdentityThemeDataCacheKey {
  const _IdentityThemeDataCacheKey(this.baseTheme, this.localTextGeometry);

  final ThemeData baseTheme;
  final TextTheme localTextGeometry;

  // Using XOR to make the hash function as fast as possible (e.g. Jenkins is
  // noticeably slower).
  @override
  int get hashCode => identityHashCode(baseTheme) ^ identityHashCode(localTextGeometry);

  @override
  bool operator ==(Object other) {
    // We are explicitly ignoring the possibility that the types might not
    // match in the interests of speed.
    return other is _IdentityThemeDataCacheKey
        && identical(other.baseTheme, baseTheme)
        && identical(other.localTextGeometry, localTextGeometry);
  }
}

/// Cache of objects of limited size that uses the first in first out eviction
/// strategy (a.k.a least recently inserted).
///
/// The key that was inserted before all other keys is evicted first, i.e. the
/// one inserted least recently.
class _FifoCache<K, V> {
  _FifoCache(this._maximumSize) : assert(_maximumSize > 0);

  /// In Dart the map literal uses a linked hash-map implementation, whose keys
  /// are stored such that [Map.keys] returns them in the order they were
  /// inserted.
  final Map<K, V> _cache = <K, V>{};

  /// Maximum number of entries to store in the cache.
  ///
  /// Once this many entries have been cached, the entry inserted least recently
  /// is evicted when adding a new entry.
  final int _maximumSize;

  /// Returns the previously cached value for the given key, if available;
  /// if not, calls the given callback to obtain it first.
  ///
  /// The arguments must not be null.
  V putIfAbsent(K key, V Function() loader) {
    assert(key != null);
    final V? result = _cache[key];
    if (result != null) {
      return result;
    }
    if (_cache.length == _maximumSize) {
      _cache.remove(_cache.keys.first);
    }
    return _cache[key] = loader();
  }
}

/// Defines the visual density of user interface components.
///
/// Density, in the context of a UI, is the vertical and horizontal
/// "compactness" of the components in the UI. It is unitless, since it means
/// different things to different UI components.
///
/// The default for visual densities is zero for both vertical and horizontal
/// densities, which corresponds to the default visual density of components in
/// the Material Design specification. It does not affect text sizes, icon
/// sizes, or padding values.
///
/// For example, for buttons, it affects the spacing around the child of the
/// button. For lists, it affects the distance between baselines of entries in
/// the list. For chips, it only affects the vertical size, not the horizontal
/// size.
///
/// Here are some examples of widgets that respond to density changes:
///
///  * [Checkbox]
///  * [Chip]
///  * [ElevatedButton]
///  * [IconButton]
///  * [InputDecorator] (which gives density support to [TextField], etc.)
///  * [ListTile]
///  * [MaterialButton]
///  * [OutlinedButton]
///  * [Radio]
///  * [RawMaterialButton]
///  * [TextButton]
///
/// See also:
///
///  * [ThemeData.visualDensity], where this property is used to specify the base
///    horizontal density of Material components.
///  * [Material design guidance on density](https://material.io/design/layout/applying-density.html).
@immutable
class VisualDensity with Diagnosticable {
  /// A const constructor for [VisualDensity].
  ///
  /// All of the arguments must be non-null, and [horizontal] and [vertical]
  /// must be in the interval between [minimumDensity] and [maximumDensity],
  /// inclusive.
  const VisualDensity({
    this.horizontal = 0.0,
    this.vertical = 0.0,
  }) : assert(vertical <= maximumDensity),
       assert(vertical <= maximumDensity),
       assert(vertical >= minimumDensity),
       assert(horizontal <= maximumDensity),
       assert(horizontal >= minimumDensity);

  /// The minimum allowed density.
  static const double minimumDensity = -4.0;

  /// The maximum allowed density.
  static const double maximumDensity = 4.0;

  /// The default profile for [VisualDensity] in [ThemeData].
  ///
  /// This default value represents a visual density that is less dense than
  /// either [comfortable] or [compact], and corresponds to density values of
  /// zero in both axes.
  static const VisualDensity standard = VisualDensity();

  /// The profile for a "comfortable" interpretation of [VisualDensity].
  ///
  /// Individual components will interpret the density value independently,
  /// making themselves more visually dense than [standard] and less dense than
  /// [compact] to different degrees based on the Material Design specification
  /// of the "comfortable" setting for their particular use case.
  ///
  /// It corresponds to a density value of -1 in both axes.
  static const VisualDensity comfortable = VisualDensity(horizontal: -1.0, vertical: -1.0);

  /// The profile for a "compact" interpretation of [VisualDensity].
  ///
  /// Individual components will interpret the density value independently,
  /// making themselves more visually dense than [standard] and [comfortable] to
  /// different degrees based on the Material Design specification of the
  /// "comfortable" setting for their particular use case.
  ///
  /// It corresponds to a density value of -2 in both axes.
  static const VisualDensity compact = VisualDensity(horizontal: -2.0, vertical: -2.0);

  /// Returns a [VisualDensity] that is adaptive based on the current platform
  /// on which the framework is executing, from [defaultTargetPlatform].
  ///
  /// When [defaultTargetPlatform] is a desktop platform, this returns
  /// [compact], and for other platforms, it returns a default-constructed
  /// [VisualDensity].
  ///
  /// See also:
  ///
  /// * [defaultDensityForPlatform] which returns a [VisualDensity] that is
  ///   adaptive based on the platform given to it.
  /// * [defaultTargetPlatform] which returns the platform on which the
  ///   framework is currently executing.
  static VisualDensity get adaptivePlatformDensity => defaultDensityForPlatform(defaultTargetPlatform);

  /// Returns a [VisualDensity] that is adaptive based on the given [platform].
  ///
  /// For desktop platforms, this returns [compact], and for other platforms, it
  /// returns a default-constructed [VisualDensity].
  ///
  /// See also:
  ///
  /// * [adaptivePlatformDensity] which returns a [VisualDensity] that is
  ///   adaptive based on [defaultTargetPlatform].
  static VisualDensity defaultDensityForPlatform(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        break;
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return compact;
    }
    return VisualDensity.standard;
  }

  /// Copy the current [VisualDensity] with the given values replacing the
  /// current values.
  VisualDensity copyWith({
    double? horizontal,
    double? vertical,
  }) {
    return VisualDensity(
      horizontal: horizontal ?? this.horizontal,
      vertical: vertical ?? this.vertical,
    );
  }

  /// The horizontal visual density of UI components.
  ///
  /// This property affects only the horizontal spacing between and within
  /// components, to allow for different UI visual densities. It does not affect
  /// text sizes, icon sizes, or padding values. The default value is 0.0,
  /// corresponding to the metrics specified in the Material Design
  /// specification. The value can range from [minimumDensity] to
  /// [maximumDensity], inclusive.
  ///
  /// See also:
  ///
  ///  * [ThemeData.visualDensity], where this property is used to specify the base
  ///    horizontal density of Material components.
  ///  * [Material design guidance on density](https://material.io/design/layout/applying-density.html).
  final double horizontal;

  /// The vertical visual density of UI components.
  ///
  /// This property affects only the vertical spacing between and within
  /// components, to allow for different UI visual densities. It does not affect
  /// text sizes, icon sizes, or padding values. The default value is 0.0,
  /// corresponding to the metrics specified in the Material Design
  /// specification. The value can range from [minimumDensity] to
  /// [maximumDensity], inclusive.
  ///
  /// See also:
  ///
  ///  * [ThemeData.visualDensity], where this property is used to specify the base
  ///    vertical density of Material components.
  ///  * [Material design guidance on density](https://material.io/design/layout/applying-density.html).
  final double vertical;

  /// The base adjustment in logical pixels of the visual density of UI components.
  ///
  /// The input density values are multiplied by a constant to arrive at a base
  /// size adjustment that fits Material Design guidelines.
  ///
  /// Individual components may adjust this value based upon their own
  /// individual interpretation of density.
  Offset get baseSizeAdjustment {
    // The number of logical pixels represented by an increase or decrease in
    // density by one. The Material Design guidelines say to increment/decrement
    // sizes in terms of four pixel increments.
    const double interval = 4.0;

    return Offset(horizontal, vertical) * interval;
  }

  /// Linearly interpolate between two densities.
  static VisualDensity lerp(VisualDensity? a, VisualDensity? b, double t) {
    if (identical(a, b) && a != null) {
      return a;
    }
    return VisualDensity(
      horizontal: lerpDouble(a?.horizontal, b?.horizontal, t) ?? 0.0,
      vertical: lerpDouble(a?.vertical, b?.vertical, t) ?? 0.0,
    );
  }

  /// Return a copy of [constraints] whose minimum width and height have been
  /// updated with the [baseSizeAdjustment].
  ///
  /// The resulting minWidth and minHeight values are clamped to not exceed the
  /// maxWidth and maxHeight values, respectively.
  BoxConstraints effectiveConstraints(BoxConstraints constraints) {
    assert(constraints.debugAssertIsValid());
    return constraints.copyWith(
      minWidth: clampDouble(constraints.minWidth + baseSizeAdjustment.dx, 0.0, constraints.maxWidth),
      minHeight: clampDouble(constraints.minHeight + baseSizeAdjustment.dy, 0.0, constraints.maxHeight),
    );
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is VisualDensity
        && other.horizontal == horizontal
        && other.vertical == vertical;
  }

  @override
  int get hashCode => Object.hash(horizontal, vertical);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('horizontal', horizontal, defaultValue: 0.0));
    properties.add(DoubleProperty('vertical', vertical, defaultValue: 0.0));
  }

  @override
  String toStringShort() {
    return '${super.toStringShort()}(h: ${debugFormatDouble(horizontal)}, v: ${debugFormatDouble(vertical)})';
  }
}

// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../color_extensions.dart';
import '../color_scheme.dart';
import '../colors.dart';
import '../elevation.dart';
import '../material_state.dart';
import '../state_theme.dart';
import '../text_theme.dart';
import '../theme.dart';
import '../theme_data.dart';

/// Applies a chip theme to descendant [RawChip]-based widgets, like [Chip],
/// [InputChip], [ChoiceChip], [FilterChip], and [ActionChip].
///
/// A chip theme describes the color, shape and text styles for the chips it is
/// applied to.
///
/// Descendant widgets obtain the current theme's [ChipThemeData] object using
/// [ChipTheme.of]. When a widget uses [ChipTheme.of], it is automatically
/// rebuilt if the theme later changes.
///
/// The [ThemeData] object given by the [Theme.of] call also contains a default
/// [ThemeData.chipTheme] that can be customized by copying it (using
/// [ChipThemeData.copyWith]).
///
/// See also:
///
///  * [Chip], a chip that displays information and can be deleted.
///  * [InputChip], a chip that represents a complex piece of information, such
///    as an entity (person, place, or thing) or conversational text, in a
///    compact form.
///  * [ChoiceChip], allows a single selection from a set of options. Choice
///    chips contain related descriptive text or categories.
///  * [FilterChip], uses tags or descriptive words as a way to filter content.
///  * [ActionChip], represents an action related to primary content.
///  * [ChipThemeData], which describes the actual configuration of a chip
///    theme.
///  * [ThemeData], which describes the overall theme information for the
///    application.
class ChipTheme extends InheritedTheme {
  /// Applies the given theme [data] to [child].
  ///
  /// The [data] and [child] arguments must not be null.
  const ChipTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// Specifies the color, shape, and text style values for descendant chip
  /// widgets.
  final ChipThemeData data;

  /// Returns the data from the closest [ChipTheme] instance that encloses
  /// the given context.
  ///
  /// Defaults to the ambient [ThemeData.chipTheme] if there is no
  /// [ChipTheme] in the given build context.
  ///
  /// {@tool snippet}
  ///
  /// ```dart
  /// class Spaceship extends StatelessWidget {
  ///   const Spaceship({super.key});
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return ChipTheme(
  ///       data: ChipTheme.of(context).copyWith(backgroundColor: Colors.red),
  ///       child: ActionChip(
  ///         label: const Text('Launch'),
  ///         onPressed: () { print('We have liftoff!'); },
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [ChipThemeData], which describes the actual configuration of a chip
  ///    theme.
  static ChipThemeData of(BuildContext context) {
    final ChipTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<ChipTheme>();
    return inheritedTheme?.data ?? Theme.of(context).chipTheme;
  }

  /// Return a [CheckboxThemeData] that merges the nearest ancestor [CheckboxTheme]
  /// and the [CheckboxThemeData] provided by the nearest [Theme].
  ///
  /// A current context theme can also be provided, used when the
  /// StateThemeData is passed as a parameter to a widget other than
  /// StateTheme.
  ///
  /// See also:
  ///
  /// * [BuildContext.dependOnInheritedWidgetOfExactType]
  static ChipThemeData resolve(
    BuildContext context, {
    ChipThemeData? currentContextTheme,
  }) {
    final ancestorTheme =
        context.dependOnInheritedWidgetOfExactType<ChipTheme>()?.data;
    final List<ChipThemeData> ancestorThemes = [
      Theme.of(context).chipTheme,
      if (ancestorTheme != null) ancestorTheme,
      if (currentContextTheme != null) currentContextTheme,
    ];
    if (ancestorThemes.length > 1) {
      return ancestorThemes
          .reduce((acc, e) => acc.mergeWith(e))
          .withContext(context);
    }
    return ancestorThemes.first
        .withContext(context);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return ChipTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(ChipTheme oldWidget) => data != oldWidget.data;
}

/// Holds the color, shape, and text styles for a Material Design chip theme.
///
/// Use this class to configure a [ChipTheme] widget, or to set the
/// [ThemeData.chipTheme] for a [Theme] widget.
///
/// To obtain the current ambient chip theme, use [ChipTheme.of].
///
/// The parts of a chip are:
///
///  * The "avatar", which is a widget that appears at the beginning of the
///    chip. This is typically a [CircleAvatar] widget.
///  * The "label", which is the widget displayed in the center of the chip.
///    Typically this is a [Text] widget.
///  * The "delete icon", which is a widget that appears at the end of the chip.
///  * The chip is disabled when it is not accepting user input. Only some chips
///    have a disabled state: [ActionChip], [ChoiceChip], [FilterChip], and
///    [InputChip].
///
/// The simplest way to create a ChipThemeData is to use [copyWith] on the one
/// you get from [ChipTheme.of], or create an entirely new one with
/// [ChipThemeData.fromDefaults].
///
/// {@tool snippet}
///
/// ```dart
/// class CarColor extends StatefulWidget {
///   const CarColor({super.key});
///
///   @override
///   State createState() => _CarColorState();
/// }
///
/// class _CarColorState extends State<CarColor> {
///   Color _color = Colors.red;
///
///   @override
///   Widget build(BuildContext context) {
///     return ChipTheme(
///       data: ChipTheme.of(context).copyWith(backgroundColor: Colors.lightBlue),
///       child: ChoiceChip(
///         label: const Text('Light Blue'),
///         onSelected: (bool value) {
///           setState(() {
///             _color = value ? Colors.lightBlue : Colors.red;
///           });
///         },
///         selected: _color == Colors.lightBlue,
///       ),
///     );
///   }
/// }
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [Chip], a chip that displays information and can be deleted.
///  * [InputChip], a chip that represents a complex piece of information, such
///    as an entity (person, place, or thing) or conversational text, in a
///    compact form.
///  * [ChoiceChip], allows a single selection from a set of options. Choice
///    chips contain related descriptive text or categories.
///  * [FilterChip], uses tags or descriptive words as a way to filter content.
///  * [ActionChip], represents an action related to primary content.
///  * [CircleAvatar], which shows images or initials of entities.
///  * [Wrap], A widget that displays its children in multiple horizontal or
///    vertical runs.
///  * [ChipTheme] widget, which can override the chip theme of its
///    children.
///  * [Theme] widget, which performs a similar function to [ChipTheme],
///    but for overall themes.
///  * [ThemeData], which has a default [ChipThemeData].
@immutable
class ChipThemeData with Diagnosticable {
  /// Create a [ChipThemeData] given a set of exact values. All the values
  /// must be specified except for [shadowColor], [selectedShadowColor],
  /// [elevation], and [pressElevation], which may be null.
  ///
  /// This will rarely be used directly. It is used by [lerp] to
  /// create intermediate themes based on two themes.
  const ChipThemeData({
    StateThemeData? stateTheme,
    MaterialStateProperty<StateLayerColors>? stateLayers,
    MaterialStateProperty<Elevation>? outlinedElevation,
    MaterialStateProperty<Elevation>? elevatedElevation,
    double? outlineSize,
    MaterialStateProperty<Color>? outlineColor,
    MaterialStateProperty<Color>? outlinedContainerColor,
    MaterialStateProperty<Color>? containerColor,
    Color? dropdownContainerColor,
    Color? dropdownContainerTint,
    Color? shadowColor,
    TextStyle? labelTextStyle,
    MaterialStateProperty<Color>? labelColor,
    MaterialStateProperty<Color>? leadingIconColor,
    MaterialStateProperty<Color>? trailingIconColor,
    double? containerHeight,
    double? containerBorderRadius,
    double? dropdownContainerBorderRadius,
    double? iconSize,
    double? avatarSize,
    double? labelStartPadding,
    double? labelEndPadding,
    double? iconPadding,
    double? avatarStartPadding,
    double? avatarEndPadding,
    MaterialStateProperty<MouseCursor>? mouseCursor,
    MaterialTapTargetSize? materialTapTargetSize,
    VisualDensity? visualDensity,
  })  : _stateTheme = stateTheme,
        _stateLayers = stateLayers,
        _outlinedContainerColor = outlinedContainerColor,
        _outlinedElevation = outlinedElevation,
        _elevatedElevation = elevatedElevation,
        _outlineSize = outlineSize,
        _outlineColor = outlineColor,
        _containerColor = containerColor,
        _dropdownContainerColor = dropdownContainerColor,
        _dropdownContainerTint = dropdownContainerTint,
        _shadowColor = shadowColor,
        _labelTextStyle = labelTextStyle,
        _labelColor = labelColor,
        _leadingIconColor = leadingIconColor,
        _trailingIconColor = trailingIconColor,
        _containerHeight = containerHeight,
        _containerBorderRadius = containerBorderRadius,
        _dropdownContainerBorderRadius = dropdownContainerBorderRadius,
        _iconSize = iconSize,
        _avatarSize = avatarSize,
        _labelStartPadding = labelStartPadding,
        _labelEndPadding = labelEndPadding,
        _iconPadding = iconPadding,
        _avatarStartPadding = avatarStartPadding,
        _avatarEndPadding = avatarEndPadding,
        _mouseCursor = mouseCursor,
        _materialTapTargetSize = materialTapTargetSize,
        _visualDensity = visualDensity;

  ChipThemeData._clone(ChipThemeData other)
      : _stateTheme = other._stateTheme,
        _stateLayers = other._stateLayers,
        _outlinedElevation = other._outlinedElevation,
        _elevatedElevation = other._elevatedElevation,
        _outlineSize = other._outlineSize,
        _outlinedContainerColor = other._outlinedContainerColor,
        _outlineColor = other._outlineColor,
        _containerColor = other._containerColor,
        _dropdownContainerColor = other._dropdownContainerColor,
        _dropdownContainerTint = other._dropdownContainerTint,
        _shadowColor = other._shadowColor,
        _labelTextStyle = other._labelTextStyle,
        _labelColor = other._labelColor,
        _leadingIconColor = other._leadingIconColor,
        _trailingIconColor = other._trailingIconColor,
        _containerHeight = other._containerHeight,
        _containerBorderRadius = other._containerBorderRadius,
        _dropdownContainerBorderRadius = other._dropdownContainerBorderRadius,
        _iconSize = other._iconSize,
        _avatarSize = other._avatarSize,
        _labelStartPadding = other._labelStartPadding,
        _labelEndPadding = other._labelEndPadding,
        _iconPadding = other._iconPadding,
        _avatarStartPadding = other._avatarStartPadding,
        _avatarEndPadding = other._avatarEndPadding,
        _mouseCursor = other._mouseCursor,
        _materialTapTargetSize = other._materialTapTargetSize,
        _visualDensity = other._visualDensity;

  /// Copy this ChipThemeData and set any default values that
  /// require a [BuildContext] set, such as colors and text themes.
  ChipThemeData withContext(
    BuildContext context) =>
      _LateResolvingChipThemeData(this, context);

  /// Defines the state layer opacities applied to this chip.
  ///
  /// Default value is [ThemeData.stateTheme] .
  StateThemeData get stateTheme => _stateTheme!;
  final StateThemeData? _stateTheme;

  /// Defines the state layers applied to this list tile.
  ///
  /// Default color values are [ColorScheme.onSurface] and the
  /// opacities are from [ListTileThemeData.stateThemeData].
  MaterialStateProperty<StateLayerColors> get stateLayers => _stateLayers!;
  final MaterialStateProperty<StateLayerColors>? _stateLayers;

  /// The elevation of this chip based on the material state.
  MaterialStateProperty<Elevation> get outlinedElevation => _outlinedElevation!;
  final MaterialStateProperty<Elevation>? _outlinedElevation;

  /// The elevation of this chip based on the material state.
  MaterialStateProperty<Elevation> get elevatedElevation => _elevatedElevation!;
  final MaterialStateProperty<Elevation>? _elevatedElevation;

  /// The width of the outline of an outline chip.
  double get outlineSize => _outlineSize ?? 1.0;
  final double? _outlineSize;

  /// The color of the outline of an outline chip.
  MaterialStateProperty<Color> get outlineColor => _outlineColor!;
  final MaterialStateProperty<Color>? _outlineColor;

  /// The color of the container of an outline chip.
  MaterialStateProperty<Color> get outlinedContainerColor =>
      _outlinedContainerColor!;
  final MaterialStateProperty<Color>? _outlinedContainerColor;

  /// The color of the container of an elevated chip.
  MaterialStateProperty<Color> get containerColor => _containerColor!;
  final MaterialStateProperty<Color>? _containerColor;

  /// The color of the container of a chip's drowpdown menu.
  ///
  /// The default is [ColorScheme.surfaceContainer].
  Color get dropdownContainerColor => _dropdownContainerColor!;
  final Color? _dropdownContainerColor;

  /// A tint to apply to the container of a chip's drowpdown menu.
  ///
  /// The default is [ColorScheme.secondaryContainer] with an opacity
  /// of 0.50.
  Color get dropdownContainerTint => _dropdownContainerTint!;
  final Color? _dropdownContainerTint;

  /// The shadow color of an elevated chip.
  ///
  /// The default is [ColorScheme.shadow].
  Color get shadowColor => _shadowColor!;
  final Color? _shadowColor;

  /// The text style applied to the label.
  ///
  /// The default is [TextTheme.labelLarge].
  TextStyle get labelTextStyle => _labelTextStyle!;
  final TextStyle? _labelTextStyle;

  /// The color to apply to the label.
  MaterialStateProperty<Color> get labelColor => _labelColor!;
  final MaterialStateProperty<Color>? _labelColor;

  /// The color to apply to the leading icon.
  MaterialStateProperty<Color> get leadingIconColor => _leadingIconColor!;
  final MaterialStateProperty<Color>? _leadingIconColor;

  /// The color to apply to the trailing icon.
  MaterialStateProperty<Color> get trailingIconColor => _trailingIconColor!;
  final MaterialStateProperty<Color>? _trailingIconColor;

  /// The height of the visible container.
  ///
  /// The default value is 32.0.
  double get containerHeight => _containerHeight ?? 32.0;
  final double? _containerHeight;

  /// The radius to apply to the chip's container.
  ///
  /// The default value is 8.0.
  double get containerBorderRadius => _containerBorderRadius ?? 8.0;
  final double? _containerBorderRadius;

  /// The radius to apply to a filter chip's dropdown container.
  ///
  /// The default value is 4.0.
  double get dropdownContainerBorderRadius =>
      _dropdownContainerBorderRadius ?? 4.0;
  final double? _dropdownContainerBorderRadius;

  /// The size of any leading and trailing icons.
  ///
  /// The default is 18.0.
  double get iconSize => _iconSize ?? 18.0;
  final double? _iconSize;

  /// The size of any leading avatar.
  ///
  /// The default is 24.0.
  double get avatarSize => _avatarSize ?? 24.0;
  final double? _avatarSize;

  /// The padding before the label when no other lead element is present.
  ///
  /// The default value is 16.0 for all chips except input, which
  /// has the default value of 12.0.
  double get labelStartPadding => _labelStartPadding ?? 16.0;
  final double? _labelStartPadding;

  /// The padding before the label when no other lead element is present.
  ///
  /// The default value is 16.0 for all chips except input, which
  /// has the default value of 12.0.
  double get labelEndPadding => _labelEndPadding ?? 16.0;
  final double? _labelEndPadding;

  /// The padding before and after an icon.
  ///
  /// The default value is 8.0.
  double get iconPadding => _iconPadding ?? 8.0;
  final double? _iconPadding;

  /// The padding before an avatar.
  ///
  /// The default value is 4.0.
  double get avatarStartPadding => _avatarStartPadding ?? 4.0;
  final double? _avatarStartPadding;

  /// The padding after an avatar.
  ///
  /// The default value is 8.0.
  double get avatarEndPadding => _avatarEndPadding ?? 8.0;
  final double? _avatarEndPadding;

  /// {@template flutter.material.chipTheme.mouseCursor}
  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// widget.
  ///
  /// If [mouseCursor] is a [MaterialStateProperty<MouseCursor>],
  /// [MaterialStateProperty.resolve] is used for the following [MaterialState]s:
  ///
  ///  * [MaterialState.selected].
  ///  * [MaterialState.disabled].
  /// {@endtemplate}
  ///
  /// If null, then the value of [ListTileThemeData.mouseCursor] is used. If
  /// that is also null, then [MaterialStateMouseCursor.clickable] is used.
  ///
  /// See also:
  ///
  ///  * [MaterialStateMouseCursor], which can be used to create a [MouseCursor]
  ///    that is also a [MaterialStateProperty<MouseCursor>].
  MaterialStateProperty<MouseCursor> get mouseCursor =>
      _mouseCursor ?? MaterialStateMouseCursor.clickable;
  final MaterialStateProperty<MouseCursor>? _mouseCursor;

  /// {@template flutter.material.checkbox.materialTapTargetSize}
  /// Configures the minimum size of the tap target.
  /// {@endtemplate}
  ///
  /// The default value is
  /// [ThemeData.materialTapTargetSize].
  ///
  /// See also:
  ///
  ///  * [MaterialTapTargetSize], for a description of how this affects tap targets.
  MaterialTapTargetSize get materialTapTargetSize => _materialTapTargetSize!;
  final MaterialTapTargetSize? _materialTapTargetSize;

  /// {@template flutter.material.chip.visualDensity}
  /// Defines how compact the chip's layout will be.
  /// {@endtemplate}
  ///
  /// {@macro flutter.material.themedata.visualDensity}
  ///
  /// The default value is [ThemeData.visualDensity].
  ///
  /// See also:
  ///
  ///  * [ThemeData.visualDensity], which specifies the [visualDensity] for all
  ///    widgets within a [Theme].
  VisualDensity get visualDensity => _visualDensity!;
  final VisualDensity? _visualDensity;

  /// Creates a copy of this object but with the given fields replaced with the
  /// new values.
  ChipThemeData copyWith({
    StateThemeData? stateTheme,
    MaterialStateProperty<StateLayerColors>? stateLayers,
    MaterialStateProperty<Elevation>? outlinedElevation,
    MaterialStateProperty<Elevation>? elevatedElevation,
    double? outlineSize,
    MaterialStateProperty<Color>? outlineColor,
    MaterialStateProperty<Color>? outlinedContainerColor,
    MaterialStateProperty<Color>? containerColor,
    Color? dropdownContainerColor,
    Color? dropdownContainerTint,
    Color? shadowColor,
    TextStyle? labelTextStyle,
    MaterialStateProperty<Color>? labelColor,
    MaterialStateProperty<Color>? leadingIconColor,
    MaterialStateProperty<Color>? trailingIconColor,
    double? containerHeight,
    double? containerBorderRadius,
    double? dropdownContainerBorderRadius,
    double? iconSize,
    double? avatarSize,
    double? labelStartPadding,
    double? labelEndPadding,
    double? iconPadding,
    double? avatarStartPadding,
    double? avatarEndPadding,
    MaterialStateProperty<MouseCursor>? mouseCursor,
    MaterialTapTargetSize? materialTapTargetSize,
    VisualDensity? visualDensity,
  }) {
    return ChipThemeData(
      stateTheme: stateTheme ?? _stateTheme,
      stateLayers: stateLayers ?? _stateLayers,
      outlinedElevation: outlinedElevation ?? _outlinedElevation,
      elevatedElevation: elevatedElevation ?? _elevatedElevation,
      outlineSize: outlineSize ?? _outlineSize,
      outlineColor: outlineColor ?? _outlineColor,
      outlinedContainerColor: outlinedContainerColor ?? _outlinedContainerColor,
      containerColor: containerColor ?? _containerColor,
      dropdownContainerColor: dropdownContainerColor ?? _dropdownContainerColor,
      dropdownContainerTint: dropdownContainerTint ?? _dropdownContainerTint,
      shadowColor: shadowColor ?? _shadowColor,
      labelTextStyle: labelTextStyle ?? _labelTextStyle,
      labelColor: labelColor ?? _labelColor,
      leadingIconColor: leadingIconColor ?? _leadingIconColor,
      trailingIconColor: trailingIconColor ?? _trailingIconColor,
      containerHeight: containerHeight ?? _containerHeight,
      containerBorderRadius: containerBorderRadius ?? _containerBorderRadius,
      dropdownContainerBorderRadius:
          dropdownContainerBorderRadius ?? _dropdownContainerBorderRadius,
      iconSize: iconSize ?? _iconSize,
      avatarSize: avatarSize ?? _avatarSize,
      labelStartPadding: labelStartPadding ?? _labelStartPadding,
      labelEndPadding: labelEndPadding ?? _labelEndPadding,
      iconPadding: iconPadding ?? _iconPadding,
      avatarStartPadding: avatarStartPadding ?? _avatarStartPadding,
      avatarEndPadding: avatarEndPadding ?? _avatarEndPadding,
      mouseCursor: mouseCursor ?? _mouseCursor,
      materialTapTargetSize: materialTapTargetSize ?? _materialTapTargetSize,
      visualDensity: visualDensity ?? _visualDensity,
    );
  }

  /// Creates a copy of this object with fields replaced with the
  /// non-null values from [other].
  ChipThemeData mergeWith(ChipThemeData? other) {
    return copyWith(
      stateTheme: other?._stateTheme,
      stateLayers: other?._stateLayers,
      outlinedElevation: other?._outlinedElevation,
      elevatedElevation: other?._elevatedElevation,
      outlineSize: other?._outlineSize,
      outlineColor: other?._outlineColor,
      outlinedContainerColor: other?._outlinedContainerColor,
      containerColor: other?._containerColor,
      dropdownContainerColor: other?._dropdownContainerColor,
      dropdownContainerTint: other?._dropdownContainerTint,
      shadowColor: other?._shadowColor,
      labelTextStyle: other?._labelTextStyle,
      labelColor: other?._labelColor,
      leadingIconColor: other?._leadingIconColor,
      trailingIconColor: other?._trailingIconColor,
      containerHeight: other?._containerHeight,
      containerBorderRadius: other?._containerBorderRadius,
      dropdownContainerBorderRadius: other?._dropdownContainerBorderRadius,
      iconSize: other?._iconSize,
      avatarSize: other?._avatarSize,
      labelStartPadding: other?._labelStartPadding,
      labelEndPadding: other?._labelEndPadding,
      iconPadding: other?._iconPadding,
      avatarStartPadding: other?._avatarStartPadding,
      avatarEndPadding: other?._avatarEndPadding,
      mouseCursor: other?._mouseCursor,
      materialTapTargetSize: other?._materialTapTargetSize,
      visualDensity: other?._visualDensity,
    );
  }

  /// Linearly interpolate between two chip themes.
  ///
  /// The arguments must not be null.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static ChipThemeData? lerp(ChipThemeData? a, ChipThemeData? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return ChipThemeData(
      stateTheme: StateThemeData.lerp(a?._stateTheme, b?._stateTheme, t),
      stateLayers: MaterialStateProperty.lerpNonNull(
          a?._stateLayers, b?._stateLayers, t, StateLayerColors.lerp),
      outlinedElevation: MaterialStateProperty.lerpNonNull(
          a?._outlinedElevation, b?._outlinedElevation, t, Elevation.lerp),
      elevatedElevation: MaterialStateProperty.lerpNonNull(
          a?._elevatedElevation, b?._elevatedElevation, t, Elevation.lerp),
      outlineSize: lerpDouble(a?._outlineSize, b?._outlineSize, t),
      outlineColor: MaterialStateProperty.lerpNonNull(
          a?._outlineColor, b?._outlineColor, t, ColorExtensions.lerpNonNull),
      outlinedContainerColor: MaterialStateProperty.lerpNonNull(
        a?._outlinedContainerColor,
        b?._outlinedContainerColor,
        t,
        ColorExtensions.lerpNonNull,
      ),
      containerColor: MaterialStateProperty.lerpNonNull(a?._containerColor,
          b?._containerColor, t, ColorExtensions.lerpNonNull),
      dropdownContainerColor:
          Color.lerp(a?._dropdownContainerColor, b?._dropdownContainerColor, t),
      dropdownContainerTint:
          Color.lerp(a?._dropdownContainerTint, b?._dropdownContainerTint, t),
      shadowColor: Color.lerp(a?._shadowColor, b?._shadowColor, t),
      labelTextStyle: TextStyle.lerp(a?._labelTextStyle, b?._labelTextStyle, t),
      labelColor: MaterialStateProperty.lerpNonNull(
          a?._labelColor, b?._labelColor, t, ColorExtensions.lerpNonNull),
      leadingIconColor: MaterialStateProperty.lerpNonNull(a?._leadingIconColor,
          b?._leadingIconColor, t, ColorExtensions.lerpNonNull),
      trailingIconColor: MaterialStateProperty.lerpNonNull(
        a?._trailingIconColor,
        b?._trailingIconColor,
        t,
        ColorExtensions.lerpNonNull,
      ),
      containerHeight: lerpDouble(a?._containerHeight, b?._containerHeight, t),
      containerBorderRadius:
          lerpDouble(a?._containerBorderRadius, b?._containerBorderRadius, t),
      dropdownContainerBorderRadius: lerpDouble(
        a?._dropdownContainerBorderRadius,
        b?._dropdownContainerBorderRadius,
        t,
      ),
      iconSize: lerpDouble(a?._iconSize, b?._iconSize, t),
      avatarSize: lerpDouble(a?._avatarSize, b?._avatarSize, t),
      labelStartPadding:
          lerpDouble(a?._labelStartPadding, b?._labelStartPadding, t),
      labelEndPadding: lerpDouble(a?._labelEndPadding, b?._labelEndPadding, t),
      iconPadding: lerpDouble(a?._iconPadding, b?._iconPadding, t),
      avatarStartPadding:
          lerpDouble(a?._avatarStartPadding, b?._avatarStartPadding, t),
      avatarEndPadding:
          lerpDouble(a?._avatarEndPadding, b?._avatarEndPadding, t),
      mouseCursor: t < 0.5 ? a?._mouseCursor : b?._mouseCursor,
      materialTapTargetSize:
          t < 0.5 ? a?._materialTapTargetSize : b?._materialTapTargetSize,
      visualDensity:
          VisualDensity.lerp(a?._visualDensity, b?._visualDensity, t),
    );
  }

  @override
  int get hashCode => Object.hashAll(<Object?>[
        _stateTheme,
        _stateLayers,
        _outlinedElevation,
        _elevatedElevation,
        _outlineSize,
        _outlineColor,
        _outlinedContainerColor,
        _containerColor,
        _dropdownContainerColor,
        _dropdownContainerTint,
        _shadowColor,
        _labelTextStyle,
        _labelColor,
        _leadingIconColor,
        _trailingIconColor,
        _containerHeight,
        _containerBorderRadius,
        _dropdownContainerBorderRadius,
        _iconSize,
        _avatarSize,
        _labelStartPadding,
        _labelEndPadding,
        _iconPadding,
        _avatarStartPadding,
        _avatarEndPadding,
        _mouseCursor,
        _materialTapTargetSize,
        _visualDensity,
      ]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is ChipThemeData &&
        other._stateTheme == _stateTheme &&
        other._stateLayers == _stateLayers &&
        other._outlinedElevation == _outlinedElevation &&
        other._elevatedElevation == _elevatedElevation &&
        other._outlineSize == _outlineSize &&
        other._outlineColor == _outlineColor &&
        other._outlinedContainerColor == _outlinedContainerColor &&
        other._containerColor == _containerColor &&
        other._dropdownContainerColor == _dropdownContainerColor &&
        other._dropdownContainerTint == _dropdownContainerTint &&
        other._shadowColor == _shadowColor &&
        other._labelTextStyle == _labelTextStyle &&
        other._labelColor == _labelColor &&
        other._leadingIconColor == _leadingIconColor &&
        other._trailingIconColor == _trailingIconColor &&
        other._containerHeight == _containerHeight &&
        other._containerBorderRadius == _containerBorderRadius &&
        other._dropdownContainerBorderRadius ==
            _dropdownContainerBorderRadius &&
        other._iconSize == _iconSize &&
        other._avatarSize == _avatarSize &&
        other._labelStartPadding == _labelStartPadding &&
        other._labelEndPadding == _labelEndPadding &&
        other._iconPadding == _iconPadding &&
        other._avatarStartPadding == _avatarStartPadding &&
        other._avatarEndPadding == _avatarEndPadding &&
        other._mouseCursor == _mouseCursor &&
        other._materialTapTargetSize == _materialTapTargetSize &&
        other._visualDensity == _visualDensity;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<StateThemeData>(
        'stateTheme', _stateTheme,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<StateLayerColors>>(
        'stateLayers', _stateLayers,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Elevation>>(
        'outlinedElevation', _outlinedElevation,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Elevation>>(
        'elevatedElevation', _elevatedElevation,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>('outlineSize', _outlineSize,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>(
        'outlineColor', _outlineColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>(
        'outlinedContainerColor', _outlinedContainerColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>(
        'containerColor', _containerColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Color>(
        'dropdownContainerColor', _dropdownContainerColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Color>(
        'dropdownContainerTint', _dropdownContainerTint,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Color>('shadowColor', _shadowColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle>(
        'labelTextStyle', _labelTextStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>(
        'labelColor', _labelColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>(
        'leadingIconColor', _leadingIconColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>(
        'trailingIconColor', _trailingIconColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>(
        'containerHeight', _containerHeight,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>(
        'containerBorderRadius', _containerBorderRadius,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>(
        'dropdownContainerBorderRadius', _dropdownContainerBorderRadius,
        defaultValue: null));
    properties.add(
      DiagnosticsProperty<double>('iconSize', _iconSize, defaultValue: null),
    );
    properties.add(DiagnosticsProperty<double>('avatarSize', _avatarSize,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>(
        'labelStartPadding', _labelStartPadding,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>(
        'labelEndPadding', _labelEndPadding,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>('iconPadding', _iconPadding,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>(
        'avatarStartPadding', _avatarStartPadding,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>(
        'avatarEndPadding', _avatarEndPadding,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<MouseCursor>>(
        'mouseCursor', _mouseCursor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialTapTargetSize>(
        'materialTapTargetSize', _materialTapTargetSize,
        defaultValue: null));
    properties.add(DiagnosticsProperty<VisualDensity>(
        'visualDensity', _visualDensity,
        defaultValue: null));
  }
}

class _LateResolvingChipThemeData extends ChipThemeData {
  _LateResolvingChipThemeData(
    super.other,
    this.context,
  ) : super._clone();

  final BuildContext context;

  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;
  late final TextTheme _textTheme = _theme.textTheme;

  @override
  StateThemeData get stateTheme => _stateTheme ?? _theme.stateTheme;

  @override
  MaterialStateProperty<StateLayerColors> get stateLayers =>
      _stateLayers ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return StateLayerColors(
            dragColor: StateLayer(
                _colors.onSecondaryContainer, stateTheme.dragOpacity),
            pressColor: StateLayer(
                _colors.onSecondaryContainer, stateTheme.pressOpacity),
            hoverColor: StateLayer(
                _colors.onSecondaryContainer, stateTheme.hoverOpacity),
            focusColor: StateLayer(
                _colors.onSecondaryContainer, stateTheme.focusOpacity),
          );
        }
        return StateLayerColors(
          dragColor:
              StateLayer(_colors.onSurfaceVariant, stateTheme.dragOpacity),
          pressColor:
              StateLayer(_colors.onSurfaceVariant, stateTheme.pressOpacity),
          hoverColor:
              StateLayer(_colors.onSurfaceVariant, stateTheme.hoverOpacity),
          focusColor:
              StateLayer(_colors.onSurfaceVariant, stateTheme.focusOpacity),
        );
      });

  @override
  MaterialStateProperty<Elevation> get outlinedElevation =>
      _outlinedElevation ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return Elevation.level0;
        }
        if (states.contains(MaterialState.dragged)) {
          return Elevation.level4;
        }

        return Elevation.level0;
      });

  @override
  MaterialStateProperty<Elevation> get elevatedElevation =>
      _elevatedElevation ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return Elevation.level0;
        }
        if (states.contains(MaterialState.dragged)) {
          return Elevation.level4;
        }
        if (states.contains(MaterialState.hovered)) {
          return Elevation.level2;
        }
        return Elevation.level1;
      });

  @override
  MaterialStateProperty<Color> get outlineColor =>
      _outlineColor ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return _colors.onSurface.withOpacity(stateTheme.disabledOpacityLight);
        }
        if (states.contains(MaterialState.selected)) {
          return Colors.transparent;
        }
        return _colors.outline;
      });

  @override
  MaterialStateProperty<Color> get outlinedContainerColor =>
      _outlinedContainerColor ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          if (states.contains(MaterialState.disabled)) {
            return _colors.onSurface
                .withOpacity(stateTheme.disabledOpacityLight);
          }
          return _colors.secondaryContainer;
        }
        return Colors.transparent;
      });

  @override
  MaterialStateProperty<Color> get containerColor =>
      _containerColor ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          if (states.contains(MaterialState.disabled)) {
            return _colors.onSurface
                .withOpacity(stateTheme.disabledOpacityLight);
          }
          return _colors.secondaryContainer;
        }
        if (states.contains(MaterialState.disabled)) {
          return _colors.onSurface.withOpacity(stateTheme.disabledOpacityLight);
        }
        return _colors.surfaceContainerLow;
      });

  @override
  Color get dropdownContainerColor =>
      _dropdownContainerColor ?? _colors.surfaceContainer;

  @override
  Color get dropdownContainerTint =>
      _dropdownContainerColor ?? _colors.secondaryContainer.withOpacity(0.50);

  @override
  Color get shadowColor => _shadowColor ?? _colors.shadow;

  @override
  TextStyle get labelTextStyle => _labelTextStyle ?? _textTheme.labelLarge;

  @override
  MaterialStateProperty<Color> get labelColor =>
      _labelColor ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          // Disabled opacity is handled in the widget
          return _colors.onSurface;
        }
        if (states.contains(MaterialState.selected)) {
          return _colors.onSecondaryContainer;
        }
        // the default for all chips except assist
        return _colors.onSurfaceVariant;
      });

  @override
  MaterialStateProperty<Color> get leadingIconColor =>
      _leadingIconColor ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          // Disabled opacity is handled in the widget
          return _colors.onSurface;
        }
        if (states.contains(MaterialState.selected)) {
          return _colors.onSecondaryContainer;
        }
        // the default for all chips except assist
        return _colors.onSurfaceVariant;
      });

  @override
  MaterialStateProperty<Color> get trailingIconColor =>
      _trailingIconColor ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          // Disabled opacity is handled in the widget
          return _colors.onSurface;
        }
        if (states.contains(MaterialState.selected)) {
          return _colors.onSecondaryContainer;
        }
        // the default for all chips except assist
        return _colors.onSurfaceVariant;
      });

  @override
  MaterialTapTargetSize get materialTapTargetSize =>
      _materialTapTargetSize ?? _theme.materialTapTargetSize;

  @override
  VisualDensity get visualDensity => _visualDensity ?? _theme.visualDensity;
}

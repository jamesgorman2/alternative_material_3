// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library button_style;

import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../color_extensions.dart';
import '../color_scheme.dart';
import '../colors.dart';
import '../constants.dart';
import '../elevation.dart';
import '../icons.dart';
import '../ink_well.dart';
import '../material_state.dart';
import '../state_theme.dart';
import '../text_theme.dart';
import '../theme.dart';
import '../theme_data.dart';

part 'elevated_button_theme.dart';

part 'filled_button_theme.dart';

part 'filled_icon_button_theme.dart';

part 'filled_tonal_button_theme.dart';

part 'filled_tonal_icon_button_theme.dart';

part 'icon_button_theme.dart';

part 'outlined_button_theme.dart';

part 'outlined_icon_button_theme.dart';

part 'segmented_button_theme.dart';

part 'text_button_theme.dart';

/// The visual properties that most buttons have in common.
///
/// Buttons and their themes have a ButtonStyle property which defines the visual
/// properties whose default values are to be overridden. The default values are
/// defined by the individual button widgets and are typically based on overall
/// theme's [ThemeData.colorScheme] and [ThemeData.textTheme].
///
/// All of the ButtonStyle properties are null by default.
///
/// Many of the ButtonStyle properties are [MaterialStateProperty] objects which
/// resolve to different values depending on the button's state. For example
/// the [Color] properties are defined with `MaterialStateProperty<Color>` and
/// can resolve to different colors depending on if the button is pressed,
/// hovered, focused, disabled, etc.
///
/// These properties can override the default value for just one state or all of
/// them. For example to create a [ElevatedButton] whose background color is the
/// color scheme’s primary color with 50% opacity, but only when the button is
/// pressed, one could write:
///
/// ```dart
/// ElevatedButton(
///   style: ButtonStyle(
///     backgroundColor: MaterialStateProperty.resolveWith<Color?>(
///       (Set<MaterialState> states) {
///         if (states.contains(MaterialState.pressed)) {
///           return Theme.of(context).colorScheme.primary.withOpacity(0.5);
///         }
///         return null; // Use the component's default.
///       },
///     ),
///   ),
///   child: const Text('Fly me to the moon'),
///   onPressed: () {
///     // ...
///   },
/// ),
/// ```
///
/// In this case the background color for all other button states would fallback
/// to the ElevatedButton’s default values. To unconditionally set the button's
/// [containerColor] for all states one could write:
///
/// ```dart
/// ElevatedButton(
///   style: const ButtonStyle(
///     backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
///   ),
///   child: const Text('Let me play among the stars'),
///   onPressed: () {
///     // ...
///   },
/// ),
/// ```
///
/// Configuring a ButtonStyle directly makes it possible to very
/// precisely control the button’s visual attributes for all states.
/// This level of control is typically required when a custom
/// “branded” look and feel is desirable. However, in many cases it’s
/// useful to make relatively sweeping changes based on a few initial
/// parameters with simple values. The button styleFrom() methods
/// enable such sweeping changes. See for example:
/// [ElevatedButton.styleFrom], [FilledButton.styleFrom],
/// [OutlinedButton.styleFrom], [TextButton.styleFrom].
///
/// For example, to override the default text and icon colors for a
/// [TextButton], as well as its overlay color, with all of the
/// standard opacity adjustments for the pressed, focused, and
/// hovered states, one could write:
///
/// ```dart
/// TextButton(
///   style: TextButton.styleFrom(foregroundColor: Colors.green),
///   child: const Text('Let me see what spring is like'),
///   onPressed: () {
///     // ...
///   },
/// ),
/// ```
///
/// To configure all of the application's text buttons in the same
/// way, specify the overall theme's `textButtonTheme`:
///
/// ```dart
/// MaterialApp(
///   theme: ThemeData(
///     textButtonTheme: TextButtonThemeData(
///       style: TextButton.styleFrom(foregroundColor: Colors.green),
///     ),
///   ),
///   home: const MyAppHome(),
/// ),
/// ```
///
/// ## Material 3 button types
///
/// Material Design 3 specifies five types of common buttons. Flutter provides
/// support for these using the following button classes:
/// <style>table,td,th { border-collapse: collapse; padding: 0.45em; } td { border: 1px solid }</style>
///
/// | Type         | Flutter implementation  |
/// | :----------- | :---------------------- |
/// | Elevated     | [ElevatedButton]        |
/// | Filled       | [FilledButton]          |
/// | Filled Tonal | [FilledButton.tonal]    |
/// | Outlined     | [OutlinedButton]        |
/// | Text         | [TextButton]            |
///
/// {@tool dartpad}
/// This sample shows how to create each of the Material 3 button types with Flutter.
///
/// ** See code in examples/api/lib/material/button_style/button_style.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [ElevatedButtonTheme], the theme for [ElevatedButton]s.
///  * [FilledButtonTheme], the theme for [FilledButton]s.
///  * [OutlinedButtonTheme], the theme for [OutlinedButton]s.
///  * [TextButtonTheme], the theme for [TextButton]s.
@immutable
class ButtonStyle with Diagnosticable {
  /// Create a [ButtonStyle].
  const ButtonStyle({
    double? iconSize,
    MaterialStateProperty<Color>? iconColor,
    TextStyle? labelStyle,
    MaterialStateProperty<Color>? labelColor,
    MaterialStateProperty<Color>? containerColor,
    StateThemeData? stateTheme,
    MaterialStateProperty<StateLayerTheme>? stateLayers,
    Color? shadowColor,
    MaterialStateProperty<Elevation>? elevation,
    double? iconPadding,
    double? internalPadding,
    double? labelPadding,
    OutlinedBorder? containerShape,
    MaterialStateProperty<BorderSide?>? outline,
    double? containerHeight,
    double? minimumContainerWidth,
    double? maximumContainerWidth,
    MaterialStateProperty<MouseCursor>? mouseCursor,
    VisualDensity? visualDensity,
    MaterialTapTargetSize? tapTargetSize,
    Duration? animationDuration,
    bool? enableFeedback,
    AlignmentGeometry? alignment,
    InteractiveInkFeatureFactory? splashFactory,
  })  : _iconSize = iconSize,
        _iconColor = iconColor,
        _labelStyle = labelStyle,
        _labelColor = labelColor,
        _containerColor = containerColor,
        _stateTheme = stateTheme,
        _stateLayers = stateLayers,
        _shadowColor = shadowColor,
        _elevation = elevation,
        _iconPadding = iconPadding,
        _internalPadding = internalPadding,
        _labelPadding = labelPadding,
        _containerShape = containerShape,
        _outline = outline,
        _containerHeight = containerHeight,
        _minimumContainerWidth = minimumContainerWidth,
        _maximumContainerWidth = maximumContainerWidth,
        _mouseCursor = mouseCursor,
        _visualDensity = visualDensity,
        _tapTargetSize = tapTargetSize,
        _animationDuration = animationDuration,
        _enableFeedback = enableFeedback,
        _alignment = alignment,
        _splashFactory = splashFactory;

  /// Make a copy of this object.
  ButtonStyle.clone(ButtonStyle other)
      : _iconSize = other._iconSize,
        _iconColor = other._iconColor,
        _labelStyle = other._labelStyle,
        _labelColor = other._labelColor,
        _containerColor = other._containerColor,
        _stateTheme = other._stateTheme,
        _stateLayers = other._stateLayers,
        _shadowColor = other._shadowColor,
        _elevation = other._elevation,
        _iconPadding = other._iconPadding,
        _internalPadding = other._internalPadding,
        _labelPadding = other._labelPadding,
        _containerShape = other._containerShape,
        _outline = other._outline,
        _containerHeight = other._containerHeight,
        _minimumContainerWidth = other._minimumContainerWidth,
        _maximumContainerWidth = other._maximumContainerWidth,
        _mouseCursor = other._mouseCursor,
        _visualDensity = other._visualDensity,
        _tapTargetSize = other._tapTargetSize,
        _animationDuration = other._animationDuration,
        _enableFeedback = other._enableFeedback,
        _alignment = other._alignment,
        _splashFactory = other._splashFactory;

  /// Copy this ButtonStyle and set any default values that
  /// require a [BuildContext] set, such as colors and text themes.
  ButtonStyle withContext(BuildContext context) {
    return _LateResolvingButtonStyle(this, context);
  }

  /// The icon's size inside of the button.
  ///
  /// The default value is 18.
  double get iconSize => _iconSize ?? 18.0;
  final double? _iconSize;

  /// The icon's color inside of the button.
  ///
  /// If this is null, the icon color will be [textColor].
  MaterialStateProperty<Color>? get iconColor => _iconColor;
  final MaterialStateProperty<Color>? _iconColor;

  /// The style for a button's [Text] widget descendants.
  ///
  /// The color of the [labelStyle] is typically not used directly, the
  /// [textColor] is used instead.
  TextStyle get labelStyle => _labelStyle!;
  final TextStyle? _labelStyle;

  /// The color for the button's [Text] and [Icon] widget descendants.
  ///
  /// This color is typically used instead of the color of the [labelStyle]. All
  /// of the components that compute defaults from [ButtonStyle] values
  /// compute a default [labelColor] and use that instead of the
  /// [labelStyle]'s color.
  MaterialStateProperty<Color> get labelColor => _labelColor!;
  final MaterialStateProperty<Color>? _labelColor;

  /// The button's background fill color.
  MaterialStateProperty<Color> get containerColor => _containerColor!;
  final MaterialStateProperty<Color>? _containerColor;

  /// Defines the state layer opacities applied to this button.
  ///
  /// Default value is [ThemeData.stateTheme] .
  StateThemeData get stateTheme => _stateTheme!;
  final StateThemeData? _stateTheme;

  /// Defines the state layers applied to this list tile.
  ///
  /// Default color values are [ColorScheme.onSurface] and the
  /// opacities are from [ListTileThemeData.stateThemeData].
  MaterialStateProperty<StateLayerTheme> get stateLayers => _stateLayers!;
  final MaterialStateProperty<StateLayerTheme>? _stateLayers;

  /// The shadow color of the button's [Material].
  Color get shadowColor => _shadowColor!;
  final Color? _shadowColor;

  /// The elevation of the button's [Material].
  MaterialStateProperty<Elevation> get elevation => _elevation!;
  final MaterialStateProperty<Elevation>? _elevation;

  /// The horizontal padding to apply between an icon and the edge of the
  /// container.
  ///
  /// The default value is 16;
  double get iconPadding => _iconPadding ?? 16.0;
  final double? _iconPadding;

  /// The padding to apply between internal elements.
  ///
  /// The default value is 8;
  double get internalPadding => _internalPadding ?? 8.0;
  final double? _internalPadding;

  /// The horizontal padding to apply around a label and the edge of the
  /// container.
  ///
  /// The default value is 24;
  double get labelPadding => _labelPadding ?? 24.0;
  final double? _labelPadding;

  /// The shape of the button.
  ///
  /// The default value is [StadiumBorder].
  OutlinedBorder get containerShape => _containerShape ?? const StadiumBorder();
  final OutlinedBorder? _containerShape;

  /// The button's outline.
  ///
  /// The default value is null;
  MaterialStateProperty<BorderSide?> get outline =>
      _outline ?? MaterialStateProperty.all<BorderSide?>(null);
  final MaterialStateProperty<BorderSide?>? _outline;

  /// The height of the button container.
  ///
  /// The height the button lies within may be larger
  /// per [tapTargetSize].
  ///
  /// The default value is 40.
  double get containerHeight => _containerHeight ?? 40.0;
  final double? _containerHeight;

  /// The minimum width of the button's container.
  ///
  /// A [Size.infinite] or null value for this property means that
  /// the button's minimum width is not constrained.
  ///
  /// If the resolved value is greater than or equal to the resolved value of
  /// [maximumContainerWidth], [minimumContainerWidth] will be ignored.
  double? get minimumContainerWidth => _minimumContainerWidth;
  final double? _minimumContainerWidth;

  /// The maximum width of the button's container.
  ///
  /// A [Size.infinite] or null value for this property means that
  /// the button's maximum width is not constrained.
  ///
  /// If the resolved value is less than or equal to the resolved value of
  /// [minimumContainerWidth], [minimumContainerWidth] will be ignored.
  double? get maximumContainerWidth => _maximumContainerWidth;
  final double? _maximumContainerWidth;

  /// The cursor for a mouse pointer when it enters or is hovering over
  /// this button's container.
  ///
  /// The default value is [MaterialStateMouseCursor.clickable].
  MaterialStateProperty<MouseCursor> get mouseCursor =>
      _mouseCursor ?? MaterialStateMouseCursor.clickable;
  final MaterialStateProperty<MouseCursor>? _mouseCursor;

  /// Defines how compact the button's layout will be.
  ///
  /// {@macro flutter.material.themedata.visualDensity}
  ///
  /// See also:
  ///
  ///  * [ThemeData.visualDensity], which specifies the [visualDensity] for all widgets
  ///    within a [Theme].
  VisualDensity get visualDensity => _visualDensity!;
  final VisualDensity? _visualDensity;

  /// Configures the minimum size of the area within which the button may be pressed.
  ///
  /// If the [tapTargetSize] is larger than [containerHeight], the button will include
  /// a transparent margin that responds to taps.
  ///
  /// Always defaults to [ThemeData.materialTapTargetSize].
  MaterialTapTargetSize get tapTargetSize => _tapTargetSize!;
  final MaterialTapTargetSize? _tapTargetSize;

  /// Defines the duration of animated changes for [shape] and [elevation].
  ///
  /// Typically the component default value is [kThemeChangeDuration].
  Duration get animationDuration => _animationDuration ?? kThemeChangeDuration;
  final Duration? _animationDuration;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  ///
  /// For example, on Android a tap will produce a clicking sound and a
  /// long-press will produce a short vibration, when feedback is enabled.
  ///
  /// Typically the component default value is true.
  ///
  /// See also:
  ///
  ///  * [Feedback] for providing platform-specific feedback to certain actions.
  bool get enableFeedback => _enableFeedback ?? true;
  final bool? _enableFeedback;

  /// The horizontal alignment of the button's child.
  ///
  /// Typically buttons are sized to be just big enough to contain the child and its
  /// padding. If the button's size is constrained to a fixed size, for example by
  /// enclosing it with a [SizedBox], this property defines how the child is aligned
  /// within the available space.
  ///
  /// Always defaults to [Alignment.center].
  AlignmentGeometry get alignment => _alignment ?? Alignment.center;
  final AlignmentGeometry? _alignment;

  /// {@template alternative_material_3.button_style.splashFactory}
  /// Creates the [InkWell] splash factory, which defines the appearance of
  /// "ink" splashes that occur in response to taps.
  ///
  /// Use [NoSplash.splashFactory] to defeat ink splash rendering. For example:
  /// ```dart
  /// ElevatedButton(
  ///   style: ElevatedButton.styleFrom(
  ///     splashFactory: NoSplash.splashFactory,
  ///   ),
  ///   onPressed: () { },
  ///   child: const Text('No Splash'),
  /// )
  /// ```
  /// {@endtemplate}
  InteractiveInkFeatureFactory? get splashFactory => _splashFactory;
  final InteractiveInkFeatureFactory? _splashFactory;

  /// Returns a copy of this ButtonStyle with the given fields replaced with
  /// the new values.
  ButtonStyle copyWith({
    double? iconSize,
    MaterialStateProperty<Color>? iconColor,
    TextStyle? labelStyle,
    MaterialStateProperty<Color>? labelColor,
    MaterialStateProperty<Color>? containerColor,
    MaterialStateProperty<StateLayerTheme>? stateLayers,
    StateThemeData? stateTheme,
    Color? shadowColor,
    MaterialStateProperty<Elevation>? elevation,
    double? iconPadding,
    double? internalPadding,
    double? labelPadding,
    OutlinedBorder? containerShape,
    MaterialStateProperty<BorderSide?>? outline,
    double? containerHeight,
    double? minimumContainerWidth,
    double? maximumContainerWidth,
    MaterialStateProperty<MouseCursor>? mouseCursor,
    VisualDensity? visualDensity,
    MaterialTapTargetSize? tapTargetSize,
    Duration? animationDuration,
    bool? enableFeedback,
    AlignmentGeometry? alignment,
    InteractiveInkFeatureFactory? splashFactory,
  }) {
    return ButtonStyle(
      iconSize: iconSize ?? _iconSize,
      iconColor: iconColor ?? _iconColor,
      labelStyle: labelStyle ?? _labelStyle,
      labelColor: labelColor ?? _labelColor,
      containerColor: containerColor ?? _containerColor,
      stateTheme: stateTheme ?? _stateTheme,
      stateLayers: stateLayers ?? _stateLayers,
      shadowColor: shadowColor ?? _shadowColor,
      elevation: elevation ?? _elevation,
      iconPadding: iconPadding ?? _iconPadding,
      internalPadding: internalPadding ?? _internalPadding,
      labelPadding: labelPadding ?? _labelPadding,
      containerShape: containerShape ?? _containerShape,
      outline: outline ?? _outline,
      containerHeight: containerHeight ?? _containerHeight,
      minimumContainerWidth: minimumContainerWidth ?? _minimumContainerWidth,
      maximumContainerWidth: maximumContainerWidth ?? _maximumContainerWidth,
      mouseCursor: mouseCursor ?? _mouseCursor,
      visualDensity: visualDensity ?? _visualDensity,
      tapTargetSize: tapTargetSize ?? _tapTargetSize,
      animationDuration: animationDuration ?? _animationDuration,
      enableFeedback: enableFeedback ?? _enableFeedback,
      alignment: alignment ?? _alignment,
      splashFactory: splashFactory ?? _splashFactory,
    );
  }

  /// Returns a copy of this ButtonStyle where the non-null fields in [style]
  /// have replaced the corresponding null fields in this ButtonStyle.
  ///
  /// In other words, [style] is used to fill in unspecified (null) fields
  /// this ButtonStyle.
  ButtonStyle merge(ButtonStyle? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      iconSize: other._iconSize,
      iconColor: other._iconColor,
      labelStyle: other._labelStyle,
      labelColor: other._labelColor,
      containerColor: other._containerColor,
      stateTheme: other._stateTheme,
      stateLayers: other._stateLayers,
      shadowColor: other._shadowColor,
      elevation: other._elevation,
      iconPadding: other._iconPadding,
      internalPadding: other._internalPadding,
      labelPadding: other._labelPadding,
      containerShape: other._containerShape,
      containerHeight: other._containerHeight,
      minimumContainerWidth: other._minimumContainerWidth,
      maximumContainerWidth: other._maximumContainerWidth,
      mouseCursor: other._mouseCursor,
      visualDensity: other._visualDensity,
      tapTargetSize: other._tapTargetSize,
      animationDuration: other._animationDuration,
      enableFeedback: other._enableFeedback,
      alignment: other._alignment,
      splashFactory: other._splashFactory,
    );
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      _iconSize,
      _iconColor,
      _labelStyle,
      _labelColor,
      _containerColor,
      _stateTheme,
      _stateLayers,
      _shadowColor,
      _elevation,
      _iconPadding,
      _internalPadding,
      _labelPadding,
      _containerShape,
      _outline,
      _containerHeight,
      _minimumContainerWidth,
      _maximumContainerWidth,
      _mouseCursor,
      _visualDensity,
      _tapTargetSize,
      _animationDuration,
      _enableFeedback,
      _alignment,
      _splashFactory,
    ];
    return Object.hashAll(values);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is ButtonStyle &&
        other._iconSize == _iconSize &&
        other._iconColor == _iconColor &&
        other._labelStyle == _labelStyle &&
        other._labelColor == _labelColor &&
        other._containerColor == _containerColor &&
        other._stateTheme == _stateTheme &&
        other._stateLayers == _stateLayers &&
        other._shadowColor == _shadowColor &&
        other._elevation == _elevation &&
        other._iconPadding == _iconPadding &&
        other._internalPadding == _internalPadding &&
        other._labelPadding == _labelPadding &&
        other._containerShape == _containerShape &&
        other._outline == _outline &&
        other._containerHeight == _containerHeight &&
        other._minimumContainerWidth == _minimumContainerWidth &&
        other._maximumContainerWidth == _maximumContainerWidth &&
        other._mouseCursor == _mouseCursor &&
        other._visualDensity == _visualDensity &&
        other._tapTargetSize == _tapTargetSize &&
        other._animationDuration == _animationDuration &&
        other._enableFeedback == _enableFeedback &&
        other._alignment == _alignment &&
        other._splashFactory == _splashFactory;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<double>('iconSize', _iconSize, defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>(
        'iconColor', _iconColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle>('labelStyle', _labelStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>(
        'labelColor', _labelColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>(
        'containerColor', _containerColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<StateThemeData>(
        'stateTheme', _stateTheme,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<StateLayerTheme>>(
        'stateLayers', _stateLayers,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Color>('shadowColor', _shadowColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Elevation>>(
        'elevation', _elevation,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>('iconPadding', _iconPadding,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>(
        'internalPadding', _internalPadding,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>('labelPadding', _labelPadding,
        defaultValue: null));
    properties.add(DiagnosticsProperty<OutlinedBorder>(
        'containerShape', _containerShape,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<BorderSide?>>(
        'outline', _outline,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>(
        'containerHeight', _containerHeight,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>(
        'minimumContainerWidth', _minimumContainerWidth,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>(
        'maximumContainerWidth', _maximumContainerWidth,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<MouseCursor>>(
        'mouseCursor', _mouseCursor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<VisualDensity>(
        'visualDensity', _visualDensity,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialTapTargetSize>(
        'tapTargetSize', _tapTargetSize,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Duration>(
        'animationDuration', _animationDuration,
        defaultValue: null));
    properties.add(DiagnosticsProperty<bool>('enableFeedback', _enableFeedback,
        defaultValue: null));
    properties.add(DiagnosticsProperty<AlignmentGeometry>(
        'alignment', _alignment,
        defaultValue: null));
    properties.add(DiagnosticsProperty<InteractiveInkFeatureFactory>(
        'splashFactory', _splashFactory,
        defaultValue: null));
  }

  /// Linearly interpolate between two [ButtonStyle]s.
  static ButtonStyle? lerp(ButtonStyle? a, ButtonStyle? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return ButtonStyle(
      iconSize: lerpDouble(a?._iconSize, b?._iconSize, t),
      iconColor: MaterialStateProperty.lerpNonNull(
        a?._iconColor,
        b?._iconColor,
        t,
        ColorExtensions.lerpNonNull,
      ),
      labelStyle: TextStyle.lerp(a?._labelStyle, b?._labelStyle, t),
      labelColor: MaterialStateProperty.lerpNonNull(
        a?._labelColor,
        b?._labelColor,
        t,
        ColorExtensions.lerpNonNull,
      ),
      containerColor: MaterialStateProperty.lerpNonNull(
        a?._containerColor,
        b?._containerColor,
        t,
        ColorExtensions.lerpNonNull,
      ),
      stateTheme: StateThemeData.lerp(a?._stateTheme, b?._stateTheme, t),
      stateLayers: MaterialStateProperty.lerpNonNull(
        a?._stateLayers,
        b?._stateLayers,
        t,
        StateLayerTheme.lerp,
      ),
      shadowColor: Color.lerp(a?._shadowColor, b?._shadowColor, t),
      elevation: MaterialStateProperty.lerpNonNull(
        a?._elevation,
        b?._elevation,
        t,
        Elevation.lerp,
      ),
      iconPadding: lerpDouble(a?._iconPadding, b?._iconPadding, t),
      internalPadding: lerpDouble(a?._internalPadding, b?._internalPadding, t),
      labelPadding: lerpDouble(a?._labelPadding, b?._labelPadding, t),
      containerShape:
          OutlinedBorder.lerp(a?._containerShape, b?._containerShape, t),
      outline: _lerpSides(a?._outline, b?._outline, t),
      containerHeight: lerpDouble(a?._containerHeight, b?._containerHeight, t),
      minimumContainerWidth: lerpDouble(
        a?._minimumContainerWidth,
        b?._minimumContainerWidth,
        t,
      ),
      maximumContainerWidth: lerpDouble(
        a?._maximumContainerWidth,
        b?._maximumContainerWidth,
        t,
      ),
      mouseCursor: t < 0.5 ? a?._mouseCursor : b?._mouseCursor,
      visualDensity:
          VisualDensity.lerp(a?._visualDensity, b?._visualDensity, t),
      tapTargetSize: t < 0.5 ? a?._tapTargetSize : b?._tapTargetSize,
      animationDuration:
          _lerpDuration(a?._animationDuration, b?._animationDuration, t),
      enableFeedback: t < 0.5 ? a?._enableFeedback : b?._enableFeedback,
      alignment: t < 0.5 ? a?._alignment : b?._alignment,
      splashFactory: t < 0.5 ? a?._splashFactory : b?._splashFactory,
    );
  }

  static Duration? _lerpDuration(Duration? a, Duration? b, double t) {
    if (a == b) {
      return a;
    } else if (a == null || b == null) {
      return t < 0.5 ? a : b;
    }

    return Duration(
      microseconds:
          lerpDouble(a.inMicroseconds, b.inMicroseconds, t)?.round() ?? 0,
    );
  }

  // Special case because BorderSide.lerp() doesn't support null arguments
  static MaterialStateProperty<BorderSide?>? _lerpSides(
      MaterialStateProperty<BorderSide?>? a,
      MaterialStateProperty<BorderSide?>? b,
      double t) {
    if (a == null && b == null) {
      return null;
    }
    return _LerpSides(a, b, t);
  }
}

class _LerpSides implements MaterialStateProperty<BorderSide?> {
  const _LerpSides(this.a, this.b, this.t);

  final MaterialStateProperty<BorderSide?>? a;
  final MaterialStateProperty<BorderSide?>? b;
  final double t;

  @override
  BorderSide? resolve(Set<MaterialState> states) {
    final BorderSide? resolvedA = a?.resolve(states);
    final BorderSide? resolvedB = b?.resolve(states);
    if (resolvedA == null && resolvedB == null) {
      return null;
    }
    if (resolvedA == null) {
      return BorderSide.lerp(
          BorderSide(width: 0, color: resolvedB!.color.withAlpha(0)),
          resolvedB,
          t);
    }
    if (resolvedB == null) {
      return BorderSide.lerp(resolvedA,
          BorderSide(width: 0, color: resolvedA.color.withAlpha(0)), t);
    }
    return BorderSide.lerp(resolvedA, resolvedB, t);
  }
}

class _LateResolvingButtonStyle extends ButtonStyle {
  _LateResolvingButtonStyle(super.other, this.context) : super.clone();

  final BuildContext context;

  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;
  late final TextTheme _textTheme = _theme.textTheme;

  @override
  StateThemeData get stateTheme => _stateTheme ?? _theme.stateTheme;

  @override
  TextStyle get labelStyle => _textTheme.labelLarge;

  @override
  Color get shadowColor => _colors.shadow;

  @override
  VisualDensity get visualDensity => _visualDensity ?? _theme.visualDensity;

  @override
  MaterialTapTargetSize get tapTargetSize =>
      _tapTargetSize ?? _theme.materialTapTargetSize;
}

// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'button_style.dart';

/// A [ButtonStyle] that overrides the default appearance of
/// [FilledTonalButton]s when it's used with [FilledTonalButtonTheme] or with the
/// overall [Theme]'s [ThemeData.filledTonalButtonTheme].
///
/// The [style]'s properties override [FilledTonalButton]'s default style,
/// i.e. the [ButtonStyle] returned by [FilledTonalButton.defaultStyleOf]. Only
/// the style's non-null property values or resolved non-null
/// [MaterialStateProperty] values are used.
///
/// See also:
///
///  * [FilledTonalButtonTheme], the theme which is configured with this class.
///  * [FilledTonalButton.defaultStyleOf], which returns the default [ButtonStyle]
///    for text buttons.
///  * [FilledTonalButton.styleFrom], which converts simple values into a
///    [ButtonStyle] that's consistent with [FilledTonalButton]'s defaults.
///  * [MaterialStateProperty.resolve], "resolve" a material state property
///    to a simple value based on a set of [MaterialState]s.
///  * [ThemeData.filledTonalButtonTheme], which can be used to override the default
///    [ButtonStyle] for [FilledTonalButton]s below the overall [Theme].
@immutable
class FilledTonalButtonThemeData with Diagnosticable {
  /// Creates an [FilledTonalButtonThemeData].
  ///
  /// The [style] may be null.
  const FilledTonalButtonThemeData({ButtonStyle? style}) : style = style ?? const ButtonStyle();

  /// Copy this FilledTonalButtonThemeData and set any default values that
  /// require a [BuildContext] set, such as colors and text themes.
  FilledTonalButtonThemeData withContext(BuildContext context) =>
      FilledTonalButtonThemeData(
        style: _LateResolvingFilledTonalButtonStyle(style, context),
      );

  /// Overrides for [FilledTonalButton]'s default style.
  ///
  /// Non-null properties or non-null resolved [MaterialStateProperty]
  /// values override the [ButtonStyle] returned by
  /// [FilledTonalButton.defaultStyleOf].
  ///
  /// If [style] is null, then this theme doesn't override anything.
  final ButtonStyle style;

  /// Linearly interpolate between two filled button themes.
  static FilledTonalButtonThemeData? lerp(
      FilledTonalButtonThemeData? a, FilledTonalButtonThemeData? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return FilledTonalButtonThemeData(
      style: ButtonStyle.lerp(a?.style, b?.style, t) ?? const ButtonStyle(),
    );
  }

  /// Creates a copy of this object with fields replaced with the
  /// non-null values from [other].
  FilledTonalButtonThemeData mergeWith(FilledTonalButtonThemeData? other) {
    return FilledTonalButtonThemeData(
      style: style.merge(other?.style),
    );
  }

  @override
  int get hashCode => style.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is FilledTonalButtonThemeData && other.style == style;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ButtonStyle>('style', style,
        defaultValue: const ButtonStyle()));
  }
}

/// Overrides the default [ButtonStyle] of its [FilledTonalButton] descendants.
///
/// See also:
///
///  * [FilledTonalButtonThemeData], which is used to configure this theme.
///  * [FilledTonalButton.defaultStyleOf], which returns the default [ButtonStyle]
///    for filled buttons.
///  * [FilledTonalButton.styleFrom], which converts simple values into a
///    [ButtonStyle] that's consistent with [FilledTonalButton]'s defaults.
///  * [ThemeData.filledTonalButtonTheme], which can be used to override the default
///    [ButtonStyle] for [FilledTonalButton]s below the overall [Theme].
class FilledTonalButtonTheme extends InheritedTheme {
  /// Create a [FilledTonalButtonTheme].
  ///
  /// The [data] parameter must not be null.
  const FilledTonalButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final FilledTonalButtonThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [FilledTonalButtonTheme] widget, then
  /// [ThemeData.filledTonalButtonTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// FilledTonalButtonThemeData theme = FilledTonalButtonTheme.of(context);
  /// ```
  static FilledTonalButtonThemeData of(BuildContext context) {
    final FilledTonalButtonTheme? buttonTheme =
        context.dependOnInheritedWidgetOfExactType<FilledTonalButtonTheme>();
    return buttonTheme?.data ?? Theme.of(context).filledTonalButtonTheme;
  }

  /// Return an [FilledTonalButtonThemeData] that merges the nearest ancestor
  /// [FilledTonalButtonTheme]
  /// and the [FilledTonalButtonThemeData] provided by the nearest [Theme].
  ///
  /// A current context theme can also be provided, used when the
  /// StateThemeData is passed as a parameter to a widget other than
  /// StateTheme.
  ///
  /// See also:
  ///
  /// * [BuildContext.dependOnInheritedWidgetOfExactType]
  static FilledTonalButtonThemeData resolve(
    BuildContext context, [
    FilledTonalButtonThemeData? currentContextTheme,
  ]) {
    final ancestorTheme = context
        .dependOnInheritedWidgetOfExactType<FilledTonalButtonTheme>()
        ?.data;
    final List<FilledTonalButtonThemeData> ancestorThemes = [
      Theme.of(context).filledTonalButtonTheme,
      if (ancestorTheme != null) ancestorTheme,
      if (currentContextTheme != null) currentContextTheme,
    ];
    if (ancestorThemes.length > 1) {
      return ancestorThemes
          .reduce((acc, e) => acc.mergeWith(e))
          .withContext(context);
    }
    return ancestorThemes.first.withContext(context);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return FilledTonalButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(FilledTonalButtonTheme oldWidget) =>
      data != oldWidget.data;
}

class _LateResolvingFilledTonalButtonStyle extends _LateResolvingButtonStyle {
  _LateResolvingFilledTonalButtonStyle(super.other, super.context) : super();

  @override
  MaterialStateProperty<Color> get labelColor =>
      _labelColor ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return _colors.onSurface.withOpacity(stateTheme.disabledOpacity);
        }
        return _colors.onSecondaryContainer;
      });

  @override
  MaterialStateProperty<Color> get containerColor =>
      _containerColor ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return _colors.onSurface.withOpacity(stateTheme.disabledOpacityLight);
        }
        return _colors.secondaryContainer;
      });

  @override
  MaterialStateProperty<StateLayerTheme> get stateLayers =>
      _stateLayers ??
      MaterialStateProperty.all(
        StateLayerTheme(
          hoverColor:
              StateLayer(_colors.onSecondaryContainer, stateTheme.hoverOpacity),
          focusColor:
              StateLayer(_colors.onSecondaryContainer, stateTheme.focusOpacity),
          pressColor:
              StateLayer(_colors.onSecondaryContainer, stateTheme.pressOpacity),
        ),
      );

  @override
  MaterialStateProperty<Elevation> get elevation =>
      _elevation ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return Elevation.level0;
        }
        if (states.contains(MaterialState.hovered)) {
          return Elevation.level1;
        }
        return Elevation.level0;
      });
}

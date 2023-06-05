// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'button_style.dart';

// Examples can assume:
// late BuildContext context;

/// A [ButtonStyle] that overrides the default appearance of
/// [FilledButton]s when it's used with [FilledButtonTheme] or with the
/// overall [Theme]'s [ThemeData.filledButtonTheme].
///
/// The [style]'s properties override [FilledButton]'s default style,
/// i.e. the [ButtonStyle] returned by [FilledButton.defaultStyleOf]. Only
/// the style's non-null property values or resolved non-null
/// [MaterialStateProperty] values are used.
///
/// See also:
///
///  * [FilledButtonTheme], the theme which is configured with this class.
///  * [FilledButton.defaultStyleOf], which returns the default [ButtonStyle]
///    for text buttons.
///  * [FilledButton.styleFrom], which converts simple values into a
///    [ButtonStyle] that's consistent with [FilledButton]'s defaults.
///  * [MaterialStateProperty.resolve], "resolve" a material state property
///    to a simple value based on a set of [MaterialState]s.
///  * [ThemeData.filledButtonTheme], which can be used to override the default
///    [ButtonStyle] for [FilledButton]s below the overall [Theme].
@immutable
class FilledButtonThemeData with Diagnosticable {
  /// Creates an [FilledButtonThemeData].
  ///
  /// The [style] may be null.
  const FilledButtonThemeData({ButtonStyle? style}) : style = style ?? const ButtonStyle();

  /// Copy this FilledButtonThemeData and set any default values that
  /// require a [BuildContext] set, such as colors and text themes.
  FilledButtonThemeData withContext(BuildContext context) =>
      FilledButtonThemeData(
        style: _LateResolvingFilledButtonStyle(style, context),
      );

  /// Overrides for [FilledButton]'s default style.
  ///
  /// Non-null properties or non-null resolved [MaterialStateProperty]
  /// values override the [ButtonStyle] returned by
  /// [FilledButton.defaultStyleOf].
  ///
  /// If [style] is null, then this theme doesn't override anything.
  final ButtonStyle style;

  /// Linearly interpolate between two filled button themes.
  static FilledButtonThemeData? lerp(
      FilledButtonThemeData? a, FilledButtonThemeData? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return FilledButtonThemeData(
      style: ButtonStyle.lerp(a?.style, b?.style, t) ?? const ButtonStyle(),
    );
  }

  /// Creates a copy of this object with fields replaced with the
  /// non-null values from [other].
  FilledButtonThemeData mergeWith(FilledButtonThemeData? other) {
    return FilledButtonThemeData(
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
    return other is FilledButtonThemeData && other.style == style;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ButtonStyle>('style', style,
        defaultValue: const ButtonStyle()));
  }
}

/// Overrides the default [ButtonStyle] of its [FilledButton] descendants.
///
/// See also:
///
///  * [FilledButtonThemeData], which is used to configure this theme.
///  * [FilledButton.defaultStyleOf], which returns the default [ButtonStyle]
///    for filled buttons.
///  * [FilledButton.styleFrom], which converts simple values into a
///    [ButtonStyle] that's consistent with [FilledButton]'s defaults.
///  * [ThemeData.filledButtonTheme], which can be used to override the default
///    [ButtonStyle] for [FilledButton]s below the overall [Theme].
class FilledButtonTheme extends InheritedTheme {
  /// Create a [FilledButtonTheme].
  ///
  /// The [data] parameter must not be null.
  const FilledButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final FilledButtonThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [FilledButtonTheme] widget, then
  /// [ThemeData.filledButtonTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// FilledButtonThemeData theme = FilledButtonTheme.of(context);
  /// ```
  static FilledButtonThemeData of(BuildContext context) {
    final FilledButtonTheme? buttonTheme =
        context.dependOnInheritedWidgetOfExactType<FilledButtonTheme>();
    return buttonTheme?.data ?? Theme.of(context).filledButtonTheme;
  }

  /// Return an [FilledButtonThemeData] that merges the nearest ancestor
  /// [FilledButtonTheme]
  /// and the [FilledButtonThemeData] provided by the nearest [Theme].
  ///
  /// A current context theme can also be provided, used when the
  /// StateThemeData is passed as a parameter to a widget other than
  /// StateTheme.
  ///
  /// See also:
  ///
  /// * [BuildContext.dependOnInheritedWidgetOfExactType]
  static FilledButtonThemeData resolve(
    BuildContext context, [
    FilledButtonThemeData? currentContextTheme,
  ]) {
    final ancestorTheme =
        context.dependOnInheritedWidgetOfExactType<FilledButtonTheme>()?.data;
    final List<FilledButtonThemeData> ancestorThemes = [
      Theme.of(context).filledButtonTheme,
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
    return FilledButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(FilledButtonTheme oldWidget) =>
      data != oldWidget.data;
}

class _LateResolvingFilledButtonStyle extends _LateResolvingButtonStyle {
  _LateResolvingFilledButtonStyle(super.other, super.context) : super();

  @override
  MaterialStateProperty<Color> get labelColor =>
      _labelColor ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return _colors.onSurface.withOpacity(stateTheme.disabledOpacity);
        }
        return _colors.onPrimary;
      });

  @override
  MaterialStateProperty<Color> get containerColor =>
      _containerColor ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return _colors.onSurface.withOpacity(stateTheme.disabledOpacityLight);
        }
        return _colors.primary;
      });

  @override
  MaterialStateProperty<StateLayerTheme> get stateLayers =>
      _stateLayers ??
      MaterialStateProperty.all(
        StateLayerTheme(
          hoverColor: StateLayer(_colors.onPrimary, stateTheme.hoverOpacity),
          focusColor: StateLayer(_colors.onPrimary, stateTheme.focusOpacity),
          pressColor: StateLayer(_colors.onPrimary, stateTheme.pressOpacity),
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

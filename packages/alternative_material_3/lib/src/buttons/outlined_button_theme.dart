// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'button_style.dart';

/// A [ButtonStyle] that overrides the default appearance of
/// [OutlinedButton]s when it's used with [OutlinedButtonTheme] or with the
/// overall [Theme]'s [ThemeData.outlinedButtonTheme].
///
/// The [style]'s properties override [OutlinedButton]'s default style,
/// i.e. the [ButtonStyle] returned by [OutlinedButton.defaultStyleOf]. Only
/// the style's non-null property values or resolved non-null
/// [MaterialStateProperty] values are used.
///
/// See also:
///
///  * [OutlinedButtonTheme], the theme which is configured with this class.
///  * [OutlinedButton.defaultStyleOf], which returns the default [ButtonStyle]
///    for outlined buttons.
///  * [OutlinedButton.styleFrom], which converts simple values into a
///    [ButtonStyle] that's consistent with [OutlinedButton]'s defaults.
///  * [MaterialStateProperty.resolve], "resolve" a material state property
///    to a simple value based on a set of [MaterialState]s.
///  * [ThemeData.outlinedButtonTheme], which can be used to override the default
///    [ButtonStyle] for [OutlinedButton]s below the overall [Theme].
@immutable
class OutlinedButtonThemeData with Diagnosticable {
  /// Creates a [OutlinedButtonThemeData].
  ///
  /// The [style] may be null.
  const OutlinedButtonThemeData({ButtonStyle? style}) : style = style ?? const ButtonStyle();

  /// Copy this OutlinedButtonThemeData and set any default values that
  /// require a [BuildContext] set, such as colors and text themes.
  OutlinedButtonThemeData withContext(BuildContext context) =>
      OutlinedButtonThemeData(
        style: _LateResolvingOutlinedButtonStyle(style, context),
      );

  /// Overrides for [OutlinedButton]'s default style.
  ///
  /// Non-null properties or non-null resolved [MaterialStateProperty]
  /// values override the [ButtonStyle] returned by
  /// [OutlinedButton.defaultStyleOf].
  ///
  /// If [style] is null, then this theme doesn't override anything.
  final ButtonStyle style;

  /// Linearly interpolate between two outlined button themes.
  static OutlinedButtonThemeData? lerp(
      OutlinedButtonThemeData? a, OutlinedButtonThemeData? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return OutlinedButtonThemeData(
      style: ButtonStyle.lerp(a?.style, b?.style, t) ?? const ButtonStyle(),
    );
  }

  /// Creates a copy of this object with fields replaced with the
  /// non-null values from [other].
  OutlinedButtonThemeData mergeWith(OutlinedButtonThemeData? other) {
    return OutlinedButtonThemeData(
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
    return other is OutlinedButtonThemeData && other.style == style;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ButtonStyle>('style', style,
        defaultValue: const ButtonStyle()));
  }
}

/// Overrides the default [ButtonStyle] of its [OutlinedButton] descendants.
///
/// See also:
///
///  * [OutlinedButtonThemeData], which is used to configure this theme.
///  * [OutlinedButton.defaultStyleOf], which returns the default [ButtonStyle]
///    for outlined buttons.
///  * [OutlinedButton.styleFrom], which converts simple values into a
///    [ButtonStyle] that's consistent with [OutlinedButton]'s defaults.
///  * [ThemeData.outlinedButtonTheme], which can be used to override the default
///    [ButtonStyle] for [OutlinedButton]s below the overall [Theme].
class OutlinedButtonTheme extends InheritedTheme {
  /// Create a [OutlinedButtonTheme].
  ///
  /// The [data] parameter must not be null.
  const OutlinedButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final OutlinedButtonThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [OutlinedButtonTheme] widget, then
  /// [ThemeData.outlinedButtonTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// OutlinedButtonThemeData theme = OutlinedButtonTheme.of(context);
  /// ```
  static OutlinedButtonThemeData of(BuildContext context) {
    final OutlinedButtonTheme? buttonTheme =
        context.dependOnInheritedWidgetOfExactType<OutlinedButtonTheme>();
    return buttonTheme?.data ?? Theme.of(context).outlinedButtonTheme;
  }

  /// Return an [OutlinedButtonThemeData] that merges the nearest ancestor
  /// [OutlinedButtonTheme]
  /// and the [OutlinedButtonThemeData] provided by the nearest [Theme].
  ///
  /// A current context theme can also be provided, used when the
  /// StateThemeData is passed as a parameter to a widget other than
  /// StateTheme.
  ///
  /// See also:
  ///
  /// * [BuildContext.dependOnInheritedWidgetOfExactType]
  static OutlinedButtonThemeData resolve(
    BuildContext context, [
    OutlinedButtonThemeData? currentContextTheme,
  ]) {
    final ancestorTheme =
        context.dependOnInheritedWidgetOfExactType<OutlinedButtonTheme>()?.data;
    final List<OutlinedButtonThemeData> ancestorThemes = [
      Theme.of(context).outlinedButtonTheme,
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
    return OutlinedButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(OutlinedButtonTheme oldWidget) =>
      data != oldWidget.data;
}

class _LateResolvingOutlinedButtonStyle extends _LateResolvingButtonStyle {
  _LateResolvingOutlinedButtonStyle(super.other, super.context) : super();

  @override
  MaterialStateProperty<Color> get labelColor =>
      _labelColor ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return _colors.onSurface.withOpacity(stateTheme.disabledOpacity);
        }
        return _colors.primary;
      });

  @override
  MaterialStateProperty<Color> get containerColor =>
      _containerColor ?? MaterialStateProperty.all(Colors.transparent);

  @override
  MaterialStateProperty<StateLayerTheme> get stateLayers =>
      _stateLayers ??
      MaterialStateProperty.all(
        StateLayerTheme(
          hoverColor: StateLayer(_colors.primary, stateTheme.hoverOpacity),
          focusColor: StateLayer(_colors.primary, stateTheme.focusOpacity),
          pressColor: StateLayer(_colors.primary, stateTheme.pressOpacity),
        ),
      );

  @override
  MaterialStateProperty<Elevation> get elevation =>
      _elevation ?? MaterialStateProperty.all(Elevation.level0);

  @override
  MaterialStateProperty<BorderSide?> get outline =>
      _outline ??
      MaterialStateProperty.resolveWith((states) {
        Color resolveColor() {
          if (states.contains(MaterialState.disabled)) {
            _colors.onSurface.withOpacity(stateTheme.disabledOpacityLight);
          }
          if (states.contains(MaterialState.hovered)) {
            return _colors.outline;
          }
          if (states.contains(MaterialState.focused)) {
            return _colors.primary;
          }
          if (states.contains(MaterialState.pressed)) {
            return _colors.outline;
          }
          return _colors.outline;
        }

        return BorderSide(
          color: resolveColor(),
        );
      });
}

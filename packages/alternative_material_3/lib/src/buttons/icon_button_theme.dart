// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'button_style.dart';

/// A [ButtonStyle] that overrides the default appearance of
/// [StandardIconButton]s when it's used with [IconButtonTheme] or with the
/// overall [Theme]'s [ThemeData.standardIconButtonTheme].
///
/// The [style]'s properties override [StandardIconButton]'s default style,
/// i.e. the [ButtonStyle] returned by [StandardIconButton.defaultStyleOf]. Only
/// the style's non-null property values or resolved non-null
/// [MaterialStateProperty] values are used.
///
/// See also:
///
///  * [IconButtonTheme], the theme which is configured with this class.
///  * [StandardIconButton.defaultStyleOf], which returns the default [ButtonStyle]
///    for text buttons.
///  * [StandardIconButton.styleFrom], which converts simple values into a
///    [ButtonStyle] that's consistent with [StandardIconButton]'s defaults.
///  * [MaterialStateProperty.resolve], "resolve" a material state property
///    to a simple value based on a set of [MaterialState]s.
///  * [ThemeData.standardIconButtonTheme], which can be used to override the default
///    [ButtonStyle] for [StandardIconButton]s below the overall [Theme].
@immutable
class IconButtonThemeData with Diagnosticable {
  /// Creates an [IconButtonThemeData].
  ///
  /// The [style] may be null.
  const IconButtonThemeData({ButtonStyle? style})
      : style = style ?? const ButtonStyle();

  /// Copy this StandardIconButtonThemeData and set any default values that
  /// require a [BuildContext] set, such as colors and text themes.
  IconButtonThemeData withContext(BuildContext context) => IconButtonThemeData(
        style: _LateResolvingToggleableIconButtonStyle(
          style,
          context,
        ),
      );

  /// Overrides for [StandardIconButton]'s default style.
  ///
  /// Non-null properties or non-null resolved [MaterialStateProperty]
  /// values override the [ButtonStyle] returned by
  /// [StandardIconButton.defaultStyleOf].
  ///
  /// If [style] is null, then this theme doesn't override anything.
  final ButtonStyle style;

  /// Linearly interpolate between two filled button themes.
  static IconButtonThemeData? lerp(
      IconButtonThemeData? a, IconButtonThemeData? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return IconButtonThemeData(
      style: ButtonStyle.lerp(a?.style, b?.style, t) ?? const ButtonStyle(),
    );
  }

  /// Creates a copy of this object with fields replaced with the
  /// non-null values from [other].
  IconButtonThemeData mergeWith(IconButtonThemeData? other) {
    return IconButtonThemeData(
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
    return other is IconButtonThemeData && other.style == style;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ButtonStyle>('style', style,
        defaultValue: const ButtonStyle()));
  }
}

/// Overrides the default [ButtonStyle] of its [StandardIconButton] descendants.
///
/// See also:
///
///  * [IconButtonThemeData], which is used to configure this theme.
///  * [StandardIconButton.defaultStyleOf], which returns the default [ButtonStyle]
///    for filled buttons.
///  * [StandardIconButton.styleFrom], which converts simple values into a
///    [ButtonStyle] that's consistent with [StandardIconButton]'s defaults.
///  * [ThemeData.standardIconButtonTheme], which can be used to override the default
///    [ButtonStyle] for [StandardIconButton]s below the overall [Theme].
class IconButtonTheme extends InheritedTheme {
  /// Create a [IconButtonTheme].
  ///
  /// The [data] parameter must not be null.
  const IconButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final IconButtonThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [IconButtonTheme] widget, then
  /// [ThemeData.standardIconButtonTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// StandardIconButtonThemeData theme = StandardIconButtonTheme.of(context);
  /// ```
  static IconButtonThemeData of(BuildContext context) {
    final IconButtonTheme? buttonTheme =
        context.dependOnInheritedWidgetOfExactType<IconButtonTheme>();
    return buttonTheme?.data ?? Theme.of(context).standardIconButtonTheme;
  }

  /// Return an [IconButtonThemeData] that merges the nearest ancestor
  /// [IconButtonTheme]
  /// and the [IconButtonThemeData] provided by the nearest [Theme].
  ///
  /// A current context theme can also be provided, used when the
  /// StateThemeData is passed as a parameter to a widget other than
  /// StateTheme.
  ///
  /// See also:
  ///
  /// * [BuildContext.dependOnInheritedWidgetOfExactType]
  static IconButtonThemeData resolve(
    BuildContext context, [
    IconButtonThemeData? currentContextTheme,
  ]) {
    final ancestorTheme =
        context.dependOnInheritedWidgetOfExactType<IconButtonTheme>()?.data;
    final List<IconButtonThemeData> ancestorThemes = [
      Theme.of(context).standardIconButtonTheme,
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
    return IconButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(IconButtonTheme oldWidget) => data != oldWidget.data;
}

class _LateResolvingToggleableIconButtonStyle
    extends _LateResolvingIconButtonStyle {
  _LateResolvingToggleableIconButtonStyle(super.other, super.context) : super();

  @override
  MaterialStateProperty<Color> get labelColor =>
      _labelColor ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return _colors.onSurface.withOpacity(stateTheme.disabledOpacity);
        }
        if (states.contains(MaterialState.selected)) {
          return _colors.primary;
        }
        return _colors.onSurfaceVariant;
      });

  @override
  MaterialStateProperty<Color> get containerColor =>
      _containerColor ?? MaterialStateProperty.all(Colors.transparent);

  @override
  MaterialStateProperty<StateLayerTheme> get stateLayers =>
      _stateLayers ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return StateLayerTheme(
            hoverColor: StateLayer(
              _colors.primary,
              stateTheme.hoverOpacity,
            ),
            focusColor: StateLayer(
              _colors.primary,
              stateTheme.focusOpacity,
            ),
            pressColor: StateLayer(
              _colors.primary,
              stateTheme.pressOpacity,
            ),
          );
        }
        return StateLayerTheme(
          hoverColor: StateLayer(
            _colors.onSurfaceVariant,
            stateTheme.hoverOpacity,
          ),
          focusColor: StateLayer(
            _colors.onSurfaceVariant,
            stateTheme.focusOpacity,
          ),
          pressColor: StateLayer(
            _colors.onSurfaceVariant,
            stateTheme.pressOpacity,
          ),
        );
      });
}

/// Shared default state
class _LateResolvingIconButtonStyle extends _LateResolvingButtonStyle {
  _LateResolvingIconButtonStyle(super.other, super.context) : super();

  @override
  double get iconSize => _iconSize ?? 24;

  @override
  MaterialStateProperty<double?>? get minimumContainerWidth =>
      MaterialStateProperty.resolveWith((states) {
        return _maximumContainerWidth?.resolve(states) ?? containerHeight;
      });

  @override
  MaterialStateProperty<double?>? get maximumContainerWidth =>
      MaterialStateProperty.resolveWith((states) {
        return _maximumContainerWidth?.resolve(states) ?? containerHeight;
      });

  @override
  MaterialStateProperty<Elevation> get elevation =>
      _elevation ?? MaterialStateProperty.all(Elevation.level0);

  @override
  double get labelPadding => _labelPadding ?? 0.0;

  @override
  double get iconPadding => _iconPadding ?? 0.0;
}

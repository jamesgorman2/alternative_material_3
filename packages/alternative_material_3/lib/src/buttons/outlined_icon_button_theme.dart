// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'button_style.dart';

/// A [ButtonStyle] that overrides the default appearance of
/// [OutlinedIconButton]s when it's used with [OutlinedIconButtonTheme] or with the
/// overall [Theme]'s [ThemeData.outlinedIconButtonTheme].
///
/// The [style]'s properties override [OutlinedIconButton]'s default style,
/// i.e. the [ButtonStyle] returned by [OutlinedIconButton.defaultStyleOf]. Only
/// the style's non-null property values or resolved non-null
/// [MaterialStateProperty] values are used.
///
/// See also:
///
///  * [OutlinedIconButtonTheme], the theme which is configured with this class.
///  * [OutlinedIconButton.defaultStyleOf], which returns the default [ButtonStyle]
///    for text buttons.
///  * [OutlinedIconButton.styleFrom], which converts simple values into a
///    [ButtonStyle] that's consistent with [OutlinedIconButton]'s defaults.
///  * [MaterialStateProperty.resolve], "resolve" a material state property
///    to a simple value based on a set of [MaterialState]s.
///  * [ThemeData.outlinedIconButtonTheme], which can be used to override the default
///    [ButtonStyle] for [OutlinedIconButton]s below the overall [Theme].
@immutable
class OutlinedIconButtonThemeData with Diagnosticable {
  /// Creates an [OutlinedIconButtonThemeData].
  ///
  /// The [style] may be null.
  const OutlinedIconButtonThemeData({ButtonStyle? style})
      : style = style ?? const ButtonStyle();

  /// Copy this OutlinedIconButtonThemeData and set any default values that
  /// require a [BuildContext] set, such as colors and text themes.
  OutlinedIconButtonThemeData withContext(BuildContext context) =>
      OutlinedIconButtonThemeData(
        style: _LateResolvingToggleableOutlinedIconButtonStyle(
          style,
          context,
        ),
      );

  /// Overrides for [OutlinedIconButton]'s default style.
  ///
  /// Non-null properties or non-null resolved [MaterialStateProperty]
  /// values override the [ButtonStyle] returned by
  /// [OutlinedIconButton.defaultStyleOf].
  ///
  /// If [style] is null, then this theme doesn't override anything.
  final ButtonStyle style;

  /// Linearly interpolate between two filled button themes.
  static OutlinedIconButtonThemeData? lerp(OutlinedIconButtonThemeData? a,
      OutlinedIconButtonThemeData? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return OutlinedIconButtonThemeData(
      style: ButtonStyle.lerp(a?.style, b?.style, t) ?? const ButtonStyle(),
    );
  }

  /// Creates a copy of this object with fields replaced with the
  /// non-null values from [other].
  OutlinedIconButtonThemeData mergeWith(OutlinedIconButtonThemeData? other) {
    return OutlinedIconButtonThemeData(
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
    return other is OutlinedIconButtonThemeData && other.style == style;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ButtonStyle>('style', style,
        defaultValue: const ButtonStyle()));
  }
}

/// Overrides the default [ButtonStyle] of its [OutlinedIconButton] descendants.
///
/// See also:
///
///  * [OutlinedIconButtonThemeData], which is used to configure this theme.
///  * [OutlinedIconButton.defaultStyleOf], which returns the default [ButtonStyle]
///    for filled buttons.
///  * [OutlinedIconButton.styleFrom], which converts simple values into a
///    [ButtonStyle] that's consistent with [OutlinedIconButton]'s defaults.
///  * [ThemeData.outlinedIconButtonTheme], which can be used to override the default
///    [ButtonStyle] for [OutlinedIconButton]s below the overall [Theme].
class OutlinedIconButtonTheme extends InheritedTheme {
  /// Create a [OutlinedIconButtonTheme].
  ///
  /// The [data] parameter must not be null.
  const OutlinedIconButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final OutlinedIconButtonThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [OutlinedIconButtonTheme] widget, then
  /// [ThemeData.outlinedIconButtonTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// OutlinedIconButtonThemeData theme = OutlinedIconButtonTheme.of(context);
  /// ```
  static OutlinedIconButtonThemeData of(BuildContext context) {
    final OutlinedIconButtonTheme? buttonTheme =
        context.dependOnInheritedWidgetOfExactType<OutlinedIconButtonTheme>();
    return buttonTheme?.data ?? Theme.of(context).outlinedIconButtonTheme;
  }

  /// Return an [OutlinedIconButtonThemeData] that merges the nearest ancestor
  /// [OutlinedIconButtonTheme]
  /// and the [OutlinedIconButtonThemeData] provided by the nearest [Theme].
  ///
  /// A current context theme can also be provided, used when the
  /// StateThemeData is passed as a parameter to a widget other than
  /// StateTheme.
  ///
  /// See also:
  ///
  /// * [BuildContext.dependOnInheritedWidgetOfExactType]
  static OutlinedIconButtonThemeData resolve(
    BuildContext context, [
    OutlinedIconButtonThemeData? currentContextTheme,
  ]) {
    final ancestorTheme = context
        .dependOnInheritedWidgetOfExactType<OutlinedIconButtonTheme>()
        ?.data;
    final List<OutlinedIconButtonThemeData> ancestorThemes = [
      Theme.of(context).outlinedIconButtonTheme,
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
    return OutlinedIconButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(OutlinedIconButtonTheme oldWidget) =>
      data != oldWidget.data;
}

class _LateResolvingToggleableOutlinedIconButtonStyle
    extends _LateResolvingIconButtonStyle {
  _LateResolvingToggleableOutlinedIconButtonStyle(super.other, super.context)
      : super();

  @override
  MaterialStateProperty<Color> get labelColor =>
      _labelColor ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return _colors.onSurface.withOpacity(stateTheme.disabledOpacity);
        }
        if (states.contains(MaterialState.selected)) {
          return _colors.inverseOnSurface;
        }
        return _colors.onSurfaceVariant;
      });

  @override
  MaterialStateProperty<Color> get containerColor =>
      _containerColor ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected) &&
            !states.contains(MaterialState.disabled)) {
          return _colors.inverseSurface;
        }
        return _colors.inverseSurface.withOpacity(0.0);
      });

  @override
  MaterialStateProperty<BorderSide?> get outline =>
      _outline ??
      MaterialStateProperty.resolveWith((states) {
        Color resolveColor() {
          if (states.contains(MaterialState.disabled)) {
            return _colors.onSurface.withOpacity(stateTheme.disabledOpacityLight);
          }
          if (states.contains(MaterialState.selected)) {
            return _colors.outline.withOpacity(0.0);
          }
          return _colors.outline;
        }

        return BorderSide(
          color: resolveColor(),
        );
      });

  @override
  MaterialStateProperty<StateLayerColors> get stateLayers =>
      _stateLayers ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return StateLayerColors.from(_colors.inverseOnSurface, stateTheme);
        }
        return StateLayerColors.from(_colors.onSurfaceVariant, stateTheme);
      });
}

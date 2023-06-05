// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'button_style.dart';

/// A [ButtonStyle] that overrides the default appearance of
/// [FilledIconButton]s when it's used with [FilledIconButtonTheme] or with the
/// overall [Theme]'s [ThemeData.filledIconButtonTheme].
///
/// The [style]'s properties override [FilledIconButton]'s default style,
/// i.e. the [ButtonStyle] returned by [FilledIconButton.defaultStyleOf]. Only
/// the style's non-null property values or resolved non-null
/// [MaterialStateProperty] values are used.
///
/// See also:
///
///  * [FilledIconButtonTheme], the theme which is configured with this class.
///  * [FilledIconButton.defaultStyleOf], which returns the default [ButtonStyle]
///    for text buttons.
///  * [FilledIconButton.styleFrom], which converts simple values into a
///    [ButtonStyle] that's consistent with [FilledIconButton]'s defaults.
///  * [MaterialStateProperty.resolve], "resolve" a material state property
///    to a simple value based on a set of [MaterialState]s.
///  * [ThemeData.filledIconButtonTheme], which can be used to override the default
///    [ButtonStyle] for [FilledIconButton]s below the overall [Theme].
@immutable
class FilledIconButtonThemeData with Diagnosticable {
  /// Creates an [FilledIconButtonThemeData].
  ///
  /// The [style] may be null.
  const FilledIconButtonThemeData({
    ButtonStyle? plainStyle,
    ButtonStyle? toggleableStyle,
  })  : plainStyle = plainStyle ?? const ButtonStyle(),
        toggleableStyle = toggleableStyle ?? const ButtonStyle();

  /// Copy this FilledIconButtonThemeData and set any default values that
  /// require a [BuildContext] set, such as colors and text themes.
  FilledIconButtonThemeData withContext(BuildContext context) =>
      FilledIconButtonThemeData(
        plainStyle: _LateResolvingFilledIconButtonStyle(plainStyle, context),
        toggleableStyle: _LateResolvingToggleableFilledIconButtonStyle(
            toggleableStyle, context),
      );

  /// Overrides for [FilledIconButton]'s default style when it is not
  /// toggleable.
  ///
  /// Non-null properties or non-null resolved [MaterialStateProperty]
  /// values override the [ButtonStyle] returned by
  /// [FilledIconButton.defaultStyleOf].
  ///
  /// If [style] is null, then this theme doesn't override anything.
  final ButtonStyle plainStyle;

  /// Overrides for [FilledIconButton]'s default style when it is toggleable.
  ///
  /// Non-null properties or non-null resolved [MaterialStateProperty]
  /// values override the [ButtonStyle] returned by
  /// [FilledIconButton.defaultStyleOf].
  ///
  /// If [style] is null, then this theme doesn't override anything.
  final ButtonStyle toggleableStyle;

  /// Linearly interpolate between two filled button themes.
  static FilledIconButtonThemeData? lerp(
      FilledIconButtonThemeData? a, FilledIconButtonThemeData? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return FilledIconButtonThemeData(
      plainStyle: ButtonStyle.lerp(a?.plainStyle, b?.plainStyle, t) ??
          const ButtonStyle(),
      toggleableStyle:
          ButtonStyle.lerp(a?.toggleableStyle, b?.toggleableStyle, t) ??
              const ButtonStyle(),
    );
  }

  /// Creates a copy of this object with fields replaced with the
  /// non-null values from [other].
  FilledIconButtonThemeData mergeWith(FilledIconButtonThemeData? other) {
    return FilledIconButtonThemeData(
      plainStyle: plainStyle.merge(other?.plainStyle),
      toggleableStyle: toggleableStyle.merge(other?.toggleableStyle),
    );
  }

  @override
  int get hashCode => Object.hash(plainStyle, toggleableStyle);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is FilledIconButtonThemeData &&
        other.plainStyle == plainStyle &&
        other.toggleableStyle == toggleableStyle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ButtonStyle>('plainStyle', plainStyle,
        defaultValue: const ButtonStyle()));
    properties.add(DiagnosticsProperty<ButtonStyle>(
        'toggleableStyle', toggleableStyle,
        defaultValue: const ButtonStyle()));
  }
}

/// Overrides the default [ButtonStyle] of its [FilledIconButton] descendants.
///
/// See also:
///
///  * [FilledIconButtonThemeData], which is used to configure this theme.
///  * [FilledIconButton.defaultStyleOf], which returns the default [ButtonStyle]
///    for filled buttons.
///  * [FilledIconButton.styleFrom], which converts simple values into a
///    [ButtonStyle] that's consistent with [FilledIconButton]'s defaults.
///  * [ThemeData.filledIconButtonTheme], which can be used to override the default
///    [ButtonStyle] for [FilledIconButton]s below the overall [Theme].
class FilledIconButtonTheme extends InheritedTheme {
  /// Create a [FilledIconButtonTheme].
  ///
  /// The [data] parameter must not be null.
  const FilledIconButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final FilledIconButtonThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [FilledIconButtonTheme] widget, then
  /// [ThemeData.filledIconButtonTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// FilledIconButtonThemeData theme = FilledIconButtonTheme.of(context);
  /// ```
  static FilledIconButtonThemeData of(BuildContext context) {
    final FilledIconButtonTheme? buttonTheme =
        context.dependOnInheritedWidgetOfExactType<FilledIconButtonTheme>();
    return buttonTheme?.data ?? Theme.of(context).filledIconButtonTheme;
  }

  /// Return an [FilledIconButtonThemeData] that merges the nearest ancestor
  /// [FilledIconButtonTheme]
  /// and the [FilledIconButtonThemeData] provided by the nearest [Theme].
  ///
  /// A current context theme can also be provided, used when the
  /// StateThemeData is passed as a parameter to a widget other than
  /// StateTheme.
  ///
  /// See also:
  ///
  /// * [BuildContext.dependOnInheritedWidgetOfExactType]
  static FilledIconButtonThemeData resolve(
    BuildContext context, [
    FilledIconButtonThemeData? currentContextTheme,
  ]) {
    final ancestorTheme = context
        .dependOnInheritedWidgetOfExactType<FilledIconButtonTheme>()
        ?.data;
    final List<FilledIconButtonThemeData> ancestorThemes = [
      Theme.of(context).filledIconButtonTheme,
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
    return FilledIconButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(FilledIconButtonTheme oldWidget) =>
      data != oldWidget.data;
}

class _LateResolvingFilledIconButtonStyle
    extends _LateResolvingIconButtonStyle {
  _LateResolvingFilledIconButtonStyle(super.other, super.context) : super();

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
}

class _LateResolvingToggleableFilledIconButtonStyle
    extends _LateResolvingIconButtonStyle {
  _LateResolvingToggleableFilledIconButtonStyle(super.other, super.context)
      : super();

  @override
  MaterialStateProperty<Color> get labelColor =>
      _labelColor ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return _colors.onSurface.withOpacity(stateTheme.disabledOpacity);
        }
        if (states.contains(MaterialState.selected)) {
          return _colors.onPrimary;
        }
        return _colors.primary;
      });

  @override
  MaterialStateProperty<Color> get containerColor =>
      _containerColor ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return _colors.onSurface.withOpacity(stateTheme.disabledOpacityLight);
        }
        if (states.contains(MaterialState.selected)) {
          return _colors.primary;
        }
        return _colors.surfaceContainerHighest;
      });

  @override
  MaterialStateProperty<StateLayerTheme> get stateLayers =>
      _stateLayers ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return StateLayerTheme(
            hoverColor: StateLayer(_colors.onPrimary, stateTheme.hoverOpacity),
            focusColor: StateLayer(_colors.onPrimary, stateTheme.focusOpacity),
            pressColor: StateLayer(_colors.onPrimary, stateTheme.pressOpacity),
          );
        }
        return StateLayerTheme(
          hoverColor: StateLayer(_colors.primary, stateTheme.hoverOpacity),
          focusColor: StateLayer(_colors.primary, stateTheme.focusOpacity),
          pressColor: StateLayer(_colors.primary, stateTheme.pressOpacity),
        );
      });
}

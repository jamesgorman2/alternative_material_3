// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'button_style.dart';

/// A [ButtonStyle] that overrides the default appearance of
/// [FilledTonalIconButton]s when it's used with [FilledTonalIconButtonTheme] or with the
/// overall [Theme]'s [ThemeData.filledTonalIconButtonTheme].
///
/// The [style]'s properties override [FilledTonalIconButton]'s default style,
/// i.e. the [ButtonStyle] returned by [FilledTonalIconButton.defaultStyleOf]. Only
/// the style's non-null property values or resolved non-null
/// [MaterialStateProperty] values are used.
///
/// See also:
///
///  * [FilledTonalIconButtonTheme], the theme which is configured with this class.
///  * [FilledTonalIconButton.defaultStyleOf], which returns the default [ButtonStyle]
///    for text buttons.
///  * [FilledTonalIconButton.styleFrom], which converts simple values into a
///    [ButtonStyle] that's consistent with [FilledTonalIconButton]'s defaults.
///  * [MaterialStateProperty.resolve], "resolve" a material state property
///    to a simple value based on a set of [MaterialState]s.
///  * [ThemeData.filledTonalIconButtonTheme], which can be used to override the default
///    [ButtonStyle] for [FilledTonalIconButton]s below the overall [Theme].
@immutable
class FilledTonalIconButtonThemeData with Diagnosticable {
  /// Creates an [FilledTonalIconButtonThemeData].
  ///
  /// The [style] may be null.
  const FilledTonalIconButtonThemeData({
    ButtonStyle? plainStyle,
    ButtonStyle? toggleableStyle,
  })  : plainStyle = plainStyle ?? const ButtonStyle(),
        toggleableStyle = toggleableStyle ?? const ButtonStyle();

  /// Copy this FilledTonalIconButtonThemeData and set any default values that
  /// require a [BuildContext] set, such as colors and text themes.
  FilledTonalIconButtonThemeData withContext(BuildContext context) =>
      FilledTonalIconButtonThemeData(
        plainStyle:
            _LateResolvingFilledTonalIconButtonStyle(plainStyle, context),
        toggleableStyle: _LateResolvingToggleableFilledTonalIconButtonStyle(
          toggleableStyle,
          context,
        ),
      );

  /// Overrides for [FilledTonalIconButton]'s default style when it is not
  /// toggleable.
  ///
  /// Non-null properties or non-null resolved [MaterialStateProperty]
  /// values override the [ButtonStyle] returned by
  /// [FilledTonalIconButton.defaultStyleOf].
  ///
  /// If [style] is null, then this theme doesn't override anything.
  final ButtonStyle plainStyle;

  /// Overrides for [FilledTonalIconButton]'s default style when it is toggleable.
  ///
  /// Non-null properties or non-null resolved [MaterialStateProperty]
  /// values override the [ButtonStyle] returned by
  /// [FilledTonalIconButton.defaultStyleOf].
  ///
  /// If [style] is null, then this theme doesn't override anything.
  final ButtonStyle toggleableStyle;

  /// Linearly interpolate between two filled button themes.
  static FilledTonalIconButtonThemeData? lerp(FilledTonalIconButtonThemeData? a,
      FilledTonalIconButtonThemeData? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return FilledTonalIconButtonThemeData(
      plainStyle: ButtonStyle.lerp(a?.plainStyle, b?.plainStyle, t) ??
          const ButtonStyle(),
      toggleableStyle:
          ButtonStyle.lerp(a?.toggleableStyle, b?.toggleableStyle, t) ??
              const ButtonStyle(),
    );
  }

  /// Creates a copy of this object with fields replaced with the
  /// non-null values from [other].
  FilledTonalIconButtonThemeData mergeWith(
      FilledTonalIconButtonThemeData? other) {
    return FilledTonalIconButtonThemeData(
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
    return other is FilledTonalIconButtonThemeData &&
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

/// Overrides the default [ButtonStyle] of its [FilledTonalIconButton] descendants.
///
/// See also:
///
///  * [FilledTonalIconButtonThemeData], which is used to configure this theme.
///  * [FilledTonalIconButton.defaultStyleOf], which returns the default [ButtonStyle]
///    for filled buttons.
///  * [FilledTonalIconButton.styleFrom], which converts simple values into a
///    [ButtonStyle] that's consistent with [FilledTonalIconButton]'s defaults.
///  * [ThemeData.filledTonalIconButtonTheme], which can be used to override the default
///    [ButtonStyle] for [FilledTonalIconButton]s below the overall [Theme].
class FilledTonalIconButtonTheme extends InheritedTheme {
  /// Create a [FilledTonalIconButtonTheme].
  ///
  /// The [data] parameter must not be null.
  const FilledTonalIconButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final FilledTonalIconButtonThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [FilledTonalIconButtonTheme] widget, then
  /// [ThemeData.filledTonalIconButtonTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// FilledTonalIconButtonThemeData theme = FilledTonalIconButtonTheme.of(context);
  /// ```
  static FilledTonalIconButtonThemeData of(BuildContext context) {
    final FilledTonalIconButtonTheme? buttonTheme = context
        .dependOnInheritedWidgetOfExactType<FilledTonalIconButtonTheme>();
    return buttonTheme?.data ?? Theme.of(context).filledTonalIconButtonTheme;
  }

  /// Return an [FilledTonalIconButtonThemeData] that merges the nearest ancestor
  /// [FilledTonalIconButtonTheme]
  /// and the [FilledTonalIconButtonThemeData] provided by the nearest [Theme].
  ///
  /// A current context theme can also be provided, used when the
  /// StateThemeData is passed as a parameter to a widget other than
  /// StateTheme.
  ///
  /// See also:
  ///
  /// * [BuildContext.dependOnInheritedWidgetOfExactType]
  static FilledTonalIconButtonThemeData resolve(
    BuildContext context, [
    FilledTonalIconButtonThemeData? currentContextTheme,
  ]) {
    final ancestorTheme = context
        .dependOnInheritedWidgetOfExactType<FilledTonalIconButtonTheme>()
        ?.data;
    final List<FilledTonalIconButtonThemeData> ancestorThemes = [
      Theme.of(context).filledTonalIconButtonTheme,
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
    return FilledTonalIconButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(FilledTonalIconButtonTheme oldWidget) =>
      data != oldWidget.data;
}

class _LateResolvingFilledTonalIconButtonStyle
    extends _LateResolvingIconButtonStyle {
  _LateResolvingFilledTonalIconButtonStyle(super.other, super.context)
      : super();

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
}

class _LateResolvingToggleableFilledTonalIconButtonStyle
    extends _LateResolvingIconButtonStyle {
  _LateResolvingToggleableFilledTonalIconButtonStyle(super.other, super.context)
      : super();

  @override
  MaterialStateProperty<Color> get labelColor =>
      _labelColor ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return _colors.onSurface.withOpacity(stateTheme.disabledOpacity);
        }
        if (states.contains(MaterialState.selected)) {
          return _colors.onSecondaryContainer;
        }
        return _colors.onSurfaceVariant;
      });

  @override
  MaterialStateProperty<Color> get containerColor =>
      _containerColor ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return _colors.onSurface.withOpacity(stateTheme.disabledOpacityLight);
        }
        if (states.contains(MaterialState.selected)) {
          return _colors.secondaryContainer;
        }
        return _colors.surfaceContainerHighest;
      });

  @override
  MaterialStateProperty<StateLayerTheme> get stateLayers =>
      _stateLayers ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return StateLayerTheme(
            hoverColor: StateLayer(
                _colors.onSecondaryContainer, stateTheme.hoverOpacity),
            focusColor: StateLayer(
                _colors.onSecondaryContainer, stateTheme.focusOpacity),
            pressColor: StateLayer(
                _colors.onSecondaryContainer, stateTheme.pressOpacity),
          );
        }
        return StateLayerTheme(
          hoverColor:
              StateLayer(_colors.onSurfaceVariant, stateTheme.hoverOpacity),
          focusColor:
              StateLayer(_colors.onSurfaceVariant, stateTheme.focusOpacity),
          pressColor:
              StateLayer(_colors.onSurfaceVariant, stateTheme.pressOpacity),
        );
      });
}

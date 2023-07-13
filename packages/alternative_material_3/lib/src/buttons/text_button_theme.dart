// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'button_style.dart';

/// A [ButtonStyle] that overrides the default appearance of
/// [TextButton]s when it's used with [TextButtonTheme] or with the
/// overall [Theme]'s [ThemeData.textButtonTheme].
///
/// The [style]'s properties override [TextButton]'s default style,
/// i.e. the [ButtonStyle] returned by [TextButton.defaultStyleOf]. Only
/// the style's non-null property values or resolved non-null
/// [MaterialStateProperty] values are used.
///
/// See also:
///
///  * [TextButtonTheme], the theme which is configured with this class.
///  * [TextButton.defaultStyleOf], which returns the default [ButtonStyle]
///    for text buttons.
///  * [TextButton.styleFrom], which converts simple values into a
///    [ButtonStyle] that's consistent with [TextButton]'s defaults.
///  * [MaterialStateProperty.resolve], "resolve" a material state property
///    to a simple value based on a set of [MaterialState]s.
///  * [ThemeData.textButtonTheme], which can be used to override the default
///    [ButtonStyle] for [TextButton]s below the overall [Theme].
@immutable
class TextButtonThemeData with Diagnosticable {
  /// Creates a [TextButtonThemeData].
  ///
  /// The [style] may be null.
  const TextButtonThemeData({ButtonStyle? style}) : style = style ?? const ButtonStyle();

  /// Copy this TextButtonThemeData and set any default values that
  /// require a [BuildContext] set, such as colors and text themes.
  TextButtonThemeData withContext(BuildContext context) => TextButtonThemeData(
        style: _LateResolvingTextButtonStyle(style, context),
      );

  /// Overrides for [TextButton]'s default style.
  ///
  /// Non-null properties or non-null resolved [MaterialStateProperty]
  /// values override the [ButtonStyle] returned by
  /// [TextButton.defaultStyleOf].
  ///
  /// If [style] is null, then this theme doesn't override anything.
  final ButtonStyle style;

  /// Linearly interpolate between two text button themes.
  static TextButtonThemeData? lerp(
      TextButtonThemeData? a, TextButtonThemeData? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return TextButtonThemeData(
      style: ButtonStyle.lerp(a?.style, b?.style, t) ?? const ButtonStyle(),
    );
  }

  /// Creates a copy of this object with fields replaced with the
  /// non-null values from [other].
  TextButtonThemeData mergeWith(TextButtonThemeData? other) {
    return TextButtonThemeData(
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
    return other is TextButtonThemeData && other.style == style;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ButtonStyle>('style', style,
        defaultValue: const ButtonStyle()));
  }
}

/// Overrides the default [ButtonStyle] of its [TextButton] descendants.
///
/// See also:
///
///  * [TextButtonThemeData], which is used to configure this theme.
///  * [TextButton.defaultStyleOf], which returns the default [ButtonStyle]
///    for text buttons.
///  * [TextButton.styleFrom], which converts simple values into a
///    [ButtonStyle] that's consistent with [TextButton]'s defaults.
///  * [ThemeData.textButtonTheme], which can be used to override the default
///    [ButtonStyle] for [TextButton]s below the overall [Theme].
class TextButtonTheme extends InheritedTheme {
  /// Create a [TextButtonTheme].
  ///
  /// The [data] parameter must not be null.
  const TextButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final TextButtonThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [TextButtonTheme] widget, then
  /// [ThemeData.textButtonTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// TextButtonThemeData theme = TextButtonTheme.of(context);
  /// ```
  static TextButtonThemeData of(BuildContext context) {
    final TextButtonTheme? buttonTheme =
        context.dependOnInheritedWidgetOfExactType<TextButtonTheme>();
    return buttonTheme?.data ?? Theme.of(context).textButtonTheme;
  }

  /// Return an [TextButtonThemeData] that merges the nearest ancestor
  /// [TextButtonThemeData]
  /// and the [TextButtonThemeData] provided by the nearest [Theme].
  ///
  /// A current context theme can also be provided, used when the
  /// StateThemeData is passed as a parameter to a widget other than
  /// StateTheme.
  ///
  /// See also:
  ///
  /// * [BuildContext.dependOnInheritedWidgetOfExactType]
  static TextButtonThemeData resolve(
    BuildContext context, [
    TextButtonThemeData? currentContextTheme,
  ]) {
    final ancestorTheme =
        context.dependOnInheritedWidgetOfExactType<TextButtonTheme>()?.data;
    final List<TextButtonThemeData> ancestorThemes = [
      Theme.of(context).textButtonTheme,
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
    return TextButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(TextButtonTheme oldWidget) => data != oldWidget.data;
}

class _LateResolvingTextButtonStyle extends _LateResolvingButtonStyle {
  _LateResolvingTextButtonStyle(super.other, super.context) : super();

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
  MaterialStateProperty<StateLayerColors> get stateLayers =>
      _stateLayers ??
      MaterialStateProperty.all(
        StateLayerColors.from(_colors.primary, stateTheme),
      );

  @override
  MaterialStateProperty<Elevation> get elevation =>
      _elevation ?? MaterialStateProperty.all(Elevation.level0);

  @override
  double get iconPadding => 12.0;

  @override
  double get labelPadding => 12.0;
}

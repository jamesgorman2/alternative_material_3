// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'button_style.dart';

/// Overrides the default values of visual properties for descendant
/// [SegmentedButton] widgets.
///
/// Descendant widgets obtain the current [SegmentedButtonThemeData] object with
/// [SegmentedButtonTheme.of]. Instances of [SegmentedButtonTheme] can
/// be customized with [SegmentedButtonThemeData.copyWith].
///
/// Typically a [SegmentedButtonTheme] is specified as part of the overall
/// [Theme] with [ThemeData.segmentedButtonTheme].
///
/// All [SegmentedButtonThemeData] properties are null by default. When null,
/// the [SegmentedButton] computes its own default values, typically based on
/// the overall theme's [ThemeData.colorScheme], [ThemeData.textTheme], and
/// [ThemeData.iconTheme].
@immutable
class SegmentedButtonThemeData with Diagnosticable {
  /// Creates a [SegmentedButtonThemeData] that can be used to override default properties
  /// in a [SegmentedButtonTheme] widget.
  const SegmentedButtonThemeData({
    ButtonStyle? style,
    Widget? selectedIcon,
  })  : style = style ?? const ButtonStyle(),
        _selectedIcon = selectedIcon;

  /// Copy this OutlinedButtonThemeData and set any default values that
  /// require a [BuildContext] set, such as colors and text themes.
  SegmentedButtonThemeData withContext(BuildContext context) =>
      SegmentedButtonThemeData(
        style: _LateResolvingSegmentedButtonStyle(style, context),
        selectedIcon: selectedIcon,
      );

  /// Overrides the [SegmentedButton]'s default style.
  ///
  /// Non-null properties or non-null resolved [MaterialStateProperty]
  /// values override the default values used by [SegmentedButton].
  ///
  /// If [style] is null, then this theme doesn't override anything.
  final ButtonStyle style;

  /// Override for [SegmentedButton.selectedIcon] property.
  ///
  /// The default value is [Icons.check_outlined].
  Widget get selectedIcon => _selectedIcon ?? const Icon(Icons.check_outlined);
  final Widget? _selectedIcon;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  SegmentedButtonThemeData copyWith({
    ButtonStyle? style,
    Widget? selectedIcon,
  }) {
    return SegmentedButtonThemeData(
      style: style ?? this.style,
      selectedIcon: selectedIcon ?? this.selectedIcon,
    );
  }

  /// Creates a copy of this object with fields replaced with the
  /// non-null values from [other].
  SegmentedButtonThemeData mergeWith(SegmentedButtonThemeData? other) {
    return SegmentedButtonThemeData(
      style: style.merge(other?.style),
      selectedIcon: other?.selectedIcon ?? selectedIcon,
    );
  }

  /// Linearly interpolates between two segmented button themes.
  static SegmentedButtonThemeData lerp(
      SegmentedButtonThemeData? a, SegmentedButtonThemeData? b, double t) {
    if (identical(a, b) && a != null) {
      return a;
    }
    return SegmentedButtonThemeData(
      style: ButtonStyle.lerp(a?.style, b?.style, t),
      selectedIcon: t < 0.5 ? a?.selectedIcon : b?.selectedIcon,
    );
  }

  @override
  int get hashCode => Object.hash(
        style,
        selectedIcon,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SegmentedButtonThemeData &&
        other.style == style &&
        other.selectedIcon == selectedIcon;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<ButtonStyle>('style', style, defaultValue: null));
    properties.add(DiagnosticsProperty<Widget>('selectedIcon', selectedIcon,
        defaultValue: null));
  }
}

/// An inherited widget that defines the visual properties for
/// [SegmentedButton]s in this widget's subtree.
///
/// Values specified here are used for [SegmentedButton] properties that are not
/// given an explicit non-null value.
class SegmentedButtonTheme extends InheritedTheme {
  /// Creates a [SegmentedButtonTheme] that controls visual parameters for
  /// descendent [SegmentedButton]s.
  const SegmentedButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// Specifies the visual properties used by descendant [SegmentedButton]
  /// widgets.
  final SegmentedButtonThemeData data;

  /// The [data] from the closest instance of this class that encloses the given
  /// context.
  ///
  /// If there is no [SegmentedButtonTheme] in scope, this will return
  /// [ThemeData.segmentedButtonTheme] from the ambient [Theme].
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// SegmentedButtonThemeData theme = SegmentedButtonTheme.of(context);
  /// ```
  ///
  /// See also:
  ///
  ///  * [maybeOf], which returns null if it doesn't find a
  ///    [SegmentedButtonTheme] ancestor.
  static SegmentedButtonThemeData of(BuildContext context) {
    return maybeOf(context) ?? Theme.of(context).segmentedButtonTheme;
  }

  /// The data from the closest instance of this class that encloses the given
  /// context, if any.
  ///
  /// Use this function if you want to allow situations where no
  /// [SegmentedButtonTheme] is in scope. Prefer using [SegmentedButtonTheme.of]
  /// in situations where a [SegmentedButtonThemeData] is expected to be
  /// non-null.
  ///
  /// If there is no [SegmentedButtonTheme] in scope, then this function will
  /// return null.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// SegmentedButtonThemeData? theme = SegmentedButtonTheme.maybeOf(context);
  /// if (theme == null) {
  ///   // Do something else instead.
  /// }
  /// ```
  ///
  /// See also:
  ///
  ///  * [of], which will return [ThemeData.segmentedButtonTheme] if it doesn't
  ///    find a [SegmentedButtonTheme] ancestor, instead of returning null.
  static SegmentedButtonThemeData? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SegmentedButtonTheme>()
        ?.data;
  }

  /// Return an [SegmentedButtonThemeData] that merges the nearest ancestor
  /// [SegmentedButtonTheme]
  /// and the [SegmentedButtonThemeData] provided by the nearest [Theme].
  ///
  /// A current context theme can also be provided, used when the
  /// StateThemeData is passed as a parameter to a widget other than
  /// StateTheme.
  ///
  /// See also:
  ///
  /// * [BuildContext.dependOnInheritedWidgetOfExactType]
  static SegmentedButtonThemeData resolve(
    BuildContext context, [
    SegmentedButtonThemeData? currentContextTheme,
  ]) {
    final ancestorTheme = context
        .dependOnInheritedWidgetOfExactType<SegmentedButtonTheme>()
        ?.data;
    final List<SegmentedButtonThemeData> ancestorThemes = [
      Theme.of(context).segmentedButtonTheme,
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
    return SegmentedButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(SegmentedButtonTheme oldWidget) =>
      data != oldWidget.data;
}

class _LateResolvingSegmentedButtonStyle extends _LateResolvingButtonStyle {
  _LateResolvingSegmentedButtonStyle(super.other, super.context) : super();

  @override
  double get iconPadding => 12.0;

  @override
  double get labelPadding => 12.0;

  @override
  double get internalPadding => 8.0;

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
        return _colors.onSurface;
      });

  @override
  MaterialStateProperty<Color> get containerColor =>
      _containerColor ??
      MaterialStateProperty.resolveWith((states) {
        if (!states.contains(MaterialState.disabled) &&
            states.contains(MaterialState.selected)) {
          return _colors.secondaryContainer;
        }
        return _colors.secondaryContainer.withOpacity(0.0);
      });

  @override
  MaterialStateProperty<StateLayerColors> get stateLayers =>
      _stateLayers ??
      MaterialStateProperty.all(
        StateLayerColors.from(_colors.onSecondaryContainer, stateTheme),
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
            return _colors.onSurface.withOpacity(stateTheme.disabledOpacityLight);
          }
          return _colors.outline;
        }

        return BorderSide(
          color: resolveColor(),
        );
      });
}

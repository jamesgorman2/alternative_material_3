import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'colors.dart';
import 'theme.dart';

/// Defines state and state layer opacities.
///
/// See also:
///
/// * https://m3.material.io/foundations/interaction/states/overview
@immutable
class StateThemeData with Diagnosticable {
  /// Creates a theme that can be used for [ThemeData.stateTheme].
  ///
  /// All values must be between 0.0 and 1.0, inclusive.
  const StateThemeData({
    double? disabledOpacity,
    double? disabledOpacityLight,
    double? hoverOpacity,
    double? focusOpacity,
    double? pressOpacity,
    double? dragOpacity,
  })  : _disabledOpacity = disabledOpacity,
        _disabledOpacityLight = disabledOpacityLight,
        _hoverOpacity = hoverOpacity,
        _focusOpacity = focusOpacity,
        _pressOpacity = pressOpacity,
        _dragOpacity = dragOpacity,
        assert(
        disabledOpacityLight == null ||
              (disabledOpacityLight >= 0.0 && disabledOpacityLight <= 1.0),
        ),
        assert(
          disabledOpacity == null ||
              (disabledOpacity >= 0.0 && disabledOpacity <= 1.0),
        ),
        assert(
          hoverOpacity == null || (hoverOpacity >= 0.0 && hoverOpacity <= 1.0),
        ),
        assert(
          focusOpacity == null || (focusOpacity >= 0.0 && focusOpacity <= 1.0),
        ),
        assert(
          pressOpacity == null || (pressOpacity >= 0.0 && pressOpacity <= 1.0),
        ),
        assert(
          dragOpacity == null || (dragOpacity >= 0.0 && dragOpacity <= 1.0),
        );

  /// The opacity to use when drawing disabled widgets.
  ///
  /// The default value is 0.38.
  double get disabledOpacity => _disabledOpacity ?? 0.38;
  final double? _disabledOpacity;

  /// The alternate, lighter opacity to use when drawing disabled widgets.
  ///
  /// The default value is 0.12.
  double get disabledOpacityLight => _disabledOpacityLight ?? 0.12;
  final double? _disabledOpacityLight;

  /// The opacity to use when drawing hover state layers.
  ///
  /// The default value is 0.06.
  double get hoverOpacity => _hoverOpacity ?? 0.06;
  final double? _hoverOpacity;

  /// The opacity to use when drawing focus state layers.
  ///
  /// The default value is 0.12.
  double get focusOpacity => _focusOpacity ?? 0.12;
  final double? _focusOpacity;

  /// The opacity to use when drawing press state layers.
  ///
  /// The default value is 0.12.
  double get pressOpacity => _pressOpacity ?? 0.12;
  final double? _pressOpacity;

  /// The opacity to use when drawing drag state layers.
  ///
  /// The default value is 0.16.
  double get dragOpacity => _dragOpacity ?? 0.16;
  final double? _dragOpacity;

  /// Creates a copy of this object with the given fields replaced with the
  /// non-null values provided.
  StateThemeData copyWith({
    double? disabledOpacity,
    double? disabledOpacityLight,
    double? hoverOpacity,
    double? focusOpacity,
    double? pressOpacity,
    double? dragOpacity,
  }) {
    assert(
      disabledOpacity == null ||
          (disabledOpacity >= 0.0 && disabledOpacity <= 1.0),
    );
    assert(
    disabledOpacityLight == null ||
          (disabledOpacityLight >= 0.0 && disabledOpacityLight <= 1.0),
    );
    assert(
      hoverOpacity == null || (hoverOpacity >= 0.0 && hoverOpacity <= 1.0),
    );
    assert(
      focusOpacity == null || (focusOpacity >= 0.0 && focusOpacity <= 1.0),
    );
    assert(
      pressOpacity == null || (pressOpacity >= 0.0 && pressOpacity <= 1.0),
    );
    assert(
      dragOpacity == null || (dragOpacity >= 0.0 && dragOpacity <= 1.0),
    );
    return StateThemeData(
      disabledOpacity: disabledOpacity ?? _disabledOpacity,
      disabledOpacityLight: disabledOpacityLight ?? _disabledOpacityLight,
      hoverOpacity: hoverOpacity ?? _hoverOpacity,
      focusOpacity: focusOpacity ?? _focusOpacity,
      pressOpacity: pressOpacity ?? _pressOpacity,
      dragOpacity: dragOpacity ?? _dragOpacity,
    );
  }

  /// Creates a copy of this object with fields replaced with the
  /// non-null values from [other].
  StateThemeData mergeWith(StateThemeData other) {
    return copyWith(
      disabledOpacity: other._disabledOpacity,
      disabledOpacityLight: other._disabledOpacityLight,
      hoverOpacity: other._hoverOpacity,
      focusOpacity: other._focusOpacity,
      pressOpacity: other._pressOpacity,
      dragOpacity: other._dragOpacity,
    );
  }

  /// Linearly interpolate between two StateThemes.
  static StateThemeData lerp(StateThemeData? a, StateThemeData? b, double t) {
    if (identical(a, b) && a != null) {
      return a;
    }

    return StateThemeData(
      disabledOpacity: lerpDouble(a?.disabledOpacity, b?.disabledOpacity, t),
      disabledOpacityLight: lerpDouble(a?.disabledOpacityLight, b?.disabledOpacityLight, t),
      hoverOpacity: lerpDouble(a?.hoverOpacity, b?.hoverOpacity, t),
      focusOpacity: lerpDouble(a?.focusOpacity, b?.focusOpacity, t),
      pressOpacity: lerpDouble(a?.pressOpacity, b?.pressOpacity, t),
      dragOpacity: lerpDouble(a?.dragOpacity, b?.dragOpacity, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is StateThemeData &&
        other._disabledOpacity == _disabledOpacity &&
        other._disabledOpacityLight == _disabledOpacityLight &&
        other._hoverOpacity == _hoverOpacity &&
        other._focusOpacity == _focusOpacity &&
        other._pressOpacity == _pressOpacity &&
        other._dragOpacity == _dragOpacity;
  }

  @override
  int get hashCode => Object.hash(
        _disabledOpacity,
        _disabledOpacityLight,
        _hoverOpacity,
        _focusOpacity,
        _pressOpacity,
        _dragOpacity,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DoubleProperty('disabledOpacity', _disabledOpacity, defaultValue: 0.38));
    properties.add(
        DoubleProperty('disabledOpacityLight', _disabledOpacityLight, defaultValue: 0.12));
    properties
        .add(DoubleProperty('hoverOpacity', _hoverOpacity, defaultValue: 0.06));
    properties
        .add(DoubleProperty('focusOpacity', _focusOpacity, defaultValue: 0.12));
    properties
        .add(DoubleProperty('pressOpacity', _pressOpacity, defaultValue: 0.12));
    properties
        .add(DoubleProperty('dragOpacity', _dragOpacity, defaultValue: 0.16));
  }
}

/// An inherited widget that defines the configuration in this widget's
/// descendants' state opacities.
class StateTheme extends InheritedTheme {
  /// Creates a const theme that controls the configurations for
  /// state opacity.
  const StateTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The properties for state opacity in this widget's
  /// descendants.
  final StateThemeData data;

  /// Returns the closest instance of this class's [data] value that encloses
  /// the given context. If there is no ancestor, it returns
  /// [ThemeData.stateTheme].
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return StateTheme(
  ///     data: const StateThemeData(
  ///       disabled: 0.47,
  ///     ),
  ///     child: child,
  ///   );
  /// }
  /// ```
  static StateThemeData of(BuildContext context) {
    final StateTheme? stateTheme =
        context.dependOnInheritedWidgetOfExactType<StateTheme>();
    return stateTheme?.data ?? Theme.of(context).stateTheme;
  }

  /// Return a [StateThemeData] that merges all the ancestor [StateTheme]s
  /// and the [StateThemeData] provided by the nearest [Theme]. It will
  /// not include any ancestor StateThemes earlier than the Theme.
  ///
  /// A current context theme can also be provided, used when the
  /// StateThemeData is passed as a parameter to a widget other than
  /// StateTheme.
  ///
  /// When merging, the most recent theme data will supersede later theme data.
  ///
  /// See also:
  ///
  /// * [BuildContext.dependOnInheritedWidgetOfExactType]
  static StateThemeData resolve(
    BuildContext context, [
    StateThemeData? currentContextTheme,
  ]) {
    final List<StateThemeData> ancestorThemes = [
      if (currentContextTheme != null) currentContextTheme,
      ...context.dependOnAllAncestorsOfType<StateTheme>().map((e) => e.data),
      Theme.of(context).stateTheme
    ];
    if (ancestorThemes.length > 1) {
      return ancestorThemes.reduce((acc, e) => acc.mergeWith(e));
    }
    return ancestorThemes.first;
  }

  @override
  bool updateShouldNotify(StateTheme oldWidget) => oldWidget.data != data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return StateTheme(data: data, child: child);
  }
}

/// A Material 3 state layer, consisting of a color and and opacity.
///
/// This extends [Color] so it can be used directly as a Color argument.
class StateLayer extends Color {
  /// Construct a StateLayer for a color and an opacity
  StateLayer(this.stateLayerColor, double opacity)
      : super(stateLayerColor.withOpacity(opacity).value);

  /// The base color of this state layer.
  final Color stateLayerColor;

  @override
  String toString() {
    return 'StateLayer(color: $stateLayerColor, opacity: $opacity)';
  }

  /// Linearly interpolate between two [StateLayer]s.
  static StateLayer? lerp(StateLayer? a, StateLayer? b, double t) {
    if (identical(a, b) && a != null) {
      return a;
    }
    return StateLayer(
      Color.lerp(a?.stateLayerColor, b?.stateLayerColor, t) ?? Colors.transparent,
      lerpDouble(a?.opacity, b?.opacity, t) ?? 0.0,
    );
  }
}

/// The state layers for a widget.
@immutable
class StateLayerTheme with Diagnosticable {
  ///
  StateLayerTheme({
    this.hoverColor,
    this.focusColor,
    this.pressColor,
    this.dragColor,
  });

  final StateLayer? hoverColor;
  final StateLayer? focusColor;
  final StateLayer? pressColor;
  final StateLayer? dragColor;

  /// Creates a copy of this object with fields replaced with the
  /// non-null values provided.
  StateLayerTheme copyWith({
    StateLayer? hoverColor,
    StateLayer? focusColor,
    StateLayer? pressColor,
    StateLayer? dragColor,
  }) {
    return StateLayerTheme(
      hoverColor: hoverColor ?? this.hoverColor,
      focusColor: focusColor ?? this.focusColor,
      pressColor: pressColor ?? this.pressColor,
      dragColor: dragColor ?? this.dragColor,
    );
  }

  /// Creates a copy of this object with fields replaced with the
  /// non-null values from [other].
  StateLayerTheme mergeWith(StateLayerTheme other) {
    return copyWith(
      hoverColor: other.hoverColor,
      focusColor:  other.focusColor,
      pressColor: other.pressColor,
      dragColor:  other.dragColor,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StateLayerTheme &&
        other.hoverColor == hoverColor &&
        other.focusColor == focusColor &&
        other.pressColor == pressColor &&
        other.dragColor == dragColor;
  }

  @override
  int get hashCode => Object.hash(
        hoverColor,
        focusColor,
        pressColor,
        dragColor,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<StateLayer?>('hoverColor', hoverColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<StateLayer?>('focusColor', focusColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<StateLayer?>('pressColor', pressColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<StateLayer?>('dragColor', dragColor,
        defaultValue: null));
  }

  /// Linearly interpolate between two [StateLayerTheme]s.
  static StateLayerTheme? lerp(StateLayerTheme? a, StateLayerTheme? b, double t,) {
    if (identical(a, b) && a != null) {
      return a;
    }
    return StateLayerTheme(
      hoverColor: StateLayer.lerp(a?.hoverColor, b?.hoverColor, t),
      focusColor: StateLayer.lerp(a?.focusColor, b?.focusColor, t),
      pressColor: StateLayer.lerp(a?.pressColor, b?.pressColor, t),
      dragColor: StateLayer.lerp(a?.dragColor, b?.dragColor, t),
    );
  }
}

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

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
    double? hoverOpacity,
    double? focusOpacity,
    double? pressOpacity,
    double? dragOpacity,
  })  : disabledOpacity = disabledOpacity ?? 0.38,
        hoverOpacity = hoverOpacity ?? 0.08,
        focusOpacity = focusOpacity ?? 0.12,
        pressOpacity = pressOpacity ?? 0.12,
        dragOpacity = dragOpacity ?? 0.16,
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
  final double disabledOpacity;

  /// The opacity to use when drawing hover state layers.
  ///
  /// The default value is 0.06.
  final double hoverOpacity;

  /// The opacity to use when drawing focus state layers.
  ///
  /// The default value is 0.12.
  final double focusOpacity;

  /// The opacity to use when drawing press state layers.
  ///
  /// The default value is 0.12.
  final double pressOpacity;

  /// The opacity to use when drawing drag state layers.
  ///
  /// The default value is 0.16.
  final double dragOpacity;

  /// Set the opacity of the given color to the disabled state opacity.
  Color disabledColor(Color c) => c.withOpacity(disabledOpacity);

  /// Set the opacity of the given color to the hover state layer opacity.
  Color hoverColor(Color c) => c.withOpacity(hoverOpacity);

  /// Set the opacity of the given color to the focus state layer opacity.
  Color focusColor(Color c) => c.withOpacity(focusOpacity);

  /// Set the opacity of the given color to the press state layer opacity.
  Color pressColor(Color c) => c.withOpacity(pressOpacity);

  /// Set the opacity of the given color to the drag state layer opacity.
  Color dragColor(Color c) => c.withOpacity(dragOpacity);

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  StateThemeData copyWith(
    double? disabledOpacity,
    double? hoverOpacity,
    double? focusOpacity,
    double? pressOpacity,
    double? dragOpacity,
  ) {
    assert(
      disabledOpacity == null ||
          (disabledOpacity >= 0.0 && disabledOpacity <= 1.0),
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
      disabledOpacity: disabledOpacity ?? this.disabledOpacity,
      hoverOpacity: hoverOpacity ?? this.hoverOpacity,
      focusOpacity: focusOpacity ?? this.focusOpacity,
      pressOpacity: pressOpacity ?? this.pressOpacity,
      dragOpacity: dragOpacity ?? this.dragOpacity,
    );
  }

  /// Linearly interpolate between two StateThemes.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static StateThemeData lerp(StateThemeData? a, StateThemeData? b, double t) {
    if (identical(a, b) && a != null) {
      return a;
    }

    return StateThemeData(
      disabledOpacity: lerpDouble(a?.disabledOpacity, b?.disabledOpacity, t),
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
        other.disabledOpacity == disabledOpacity &&
        other.hoverOpacity == hoverOpacity &&
        other.focusOpacity == focusOpacity &&
        other.pressOpacity == pressOpacity &&
        other.dragOpacity == dragOpacity;
  }

  @override
  int get hashCode => Object.hash(
        disabledOpacity,
        hoverOpacity,
        focusOpacity,
        pressOpacity,
        dragOpacity,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DoubleProperty('disabledOpacity', disabledOpacity, defaultValue: 0.38));
    properties
        .add(DoubleProperty('hoverOpacity', hoverOpacity, defaultValue: 0.06));
    properties
        .add(DoubleProperty('focusOpacity', focusOpacity, defaultValue: 0.12));
    properties
        .add(DoubleProperty('pressOpacity', pressOpacity, defaultValue: 0.12));
    properties
        .add(DoubleProperty('dragOpacity', dragOpacity, defaultValue: 0.16));
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
    final StateTheme? stateTheme = context.dependOnInheritedWidgetOfExactType<StateTheme>();
    return stateTheme?.data ?? Theme.of(context).stateTheme;
  }

  @override
  bool updateShouldNotify(StateTheme oldWidget) =>
      oldWidget.data != data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return StateTheme(data: data, child: child);
  }
}

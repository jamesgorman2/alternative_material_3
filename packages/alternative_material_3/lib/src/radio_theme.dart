// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'color_extensions.dart';
import 'color_scheme.dart';
import 'colors.dart';
import 'constants.dart';
import 'material_state.dart';
import 'state_theme.dart';
import 'theme.dart';
import 'theme_data.dart';

// Examples can assume:
// late BuildContext context;

/// Defines default property values for descendant [Radio] widgets.
///
/// Descendant widgets obtain the current [RadioThemeData] object using
/// `RadioTheme.of(context)`. Instances of [RadioThemeData] can be customized
/// with [RadioThemeData.copyWith].
///
/// Typically a [RadioThemeData] is specified as part of the overall [Theme]
/// with [ThemeData.radioTheme].
///
/// All [RadioThemeData] properties are `null` by default. When null, the
/// [Radio] will use the values from [ThemeData] if they exist, otherwise it
/// will provide its own defaults based on the overall [Theme]'s colorScheme.
/// See the individual [Radio] properties for details.
///
/// See also:
///
///  * [ThemeData], which describes the overall theme information for the
///    application.
///  * [RadioTheme], which is used by descendants to obtain the
///    [RadioThemeData].
@immutable
class RadioThemeData with Diagnosticable {
  /// Creates a theme that can be used for [ThemeData.radioTheme].
  const RadioThemeData({
    MaterialStateProperty<MouseCursor>? mouseCursor,
    MaterialStateProperty<Color>? containerColor,
    MaterialStateProperty<Color>? stateLayerColor,
    StateThemeData? stateTheme,
    double? splashRadius,
    MaterialTapTargetSize? materialTapTargetSize,
    VisualDensity? visualDensity,
  })  : _mouseCursor = mouseCursor,
        _containerColor = containerColor,
        _stateLayerColor = stateLayerColor,
        _stateTheme = stateTheme,
        _splashRadius = splashRadius,
        _materialTapTargetSize = materialTapTargetSize,
        _visualDensity = visualDensity;

  RadioThemeData._clone(RadioThemeData other)
      : _mouseCursor = other._mouseCursor,
        _containerColor = other._containerColor,
        _stateLayerColor = other._stateLayerColor,
        _stateTheme = other._stateTheme,
        _splashRadius = other._splashRadius,
        _materialTapTargetSize = other._materialTapTargetSize,
        _visualDensity = other._visualDensity;

  /// Copy this RadioThemeData and set any default values that
  /// require a [BuildContext] set, such as colors and text themes.
  RadioThemeData withContext(BuildContext context) =>
      _LateResolvingRadioThemeData(this, context);

  /// {@template flutter.material.radio.mouseCursor}
  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// widget.
  ///
  /// If [mouseCursor] is a [MaterialStateProperty<MouseCursor>],
  /// [MaterialStateProperty.resolve] is used for the following [MaterialState]s:
  ///
  ///  * [MaterialState.selected].
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  ///  * [MaterialState.disabled].
  /// {@endtemplate}
  ///
  /// The default value is [MaterialStateMouseCursor.clickable].
  ///
  /// See also:
  ///
  ///  * [MaterialStateMouseCursor], a [MouseCursor] that implements
  ///    `MaterialStateProperty` which is used in APIs that need to accept
  ///    either a [MouseCursor] or a [MaterialStateProperty<MouseCursor>].
  MaterialStateProperty<MouseCursor> get mouseCursor =>
      _mouseCursor ?? MaterialStateMouseCursor.clickable;
  final MaterialStateProperty<MouseCursor>? _mouseCursor;

  /// {@template flutter.material.radio.fillColor}
  /// The color that fills the radio button, in all [MaterialState]s.
  ///
  /// Resolves in the following states:
  ///  * [MaterialState.selected].
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  ///  * [MaterialState.disabled].
  ///
  /// {@tool snippet}
  /// This example resolves the [containerColor] based on the current [MaterialState]
  /// of the [Radio], providing a different [Color] when it is
  /// [MaterialState.disabled].
  ///
  /// ```dart
  /// Radio<int>(
  ///   value: 1,
  ///   groupValue: 1,
  ///   onChanged: (_){},
  ///   fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
  ///     if (states.contains(MaterialState.disabled)) {
  ///       return Colors.orange.withOpacity(.32);
  ///     }
  ///     return Colors.orange;
  ///   })
  /// )
  /// ```
  /// {@end-tool}
  /// {@endtemplate}
  ///
  /// The default is to use the colors in the Material 3 specification
  ///
  /// See also:
  ///
  /// * https://m3.material.io/components/radio-button/specs
  MaterialStateProperty<Color> get containerColor => _containerColor!;
  final MaterialStateProperty<Color>? _containerColor;

  /// {@template flutter.material.radio.overlayColor}
  /// The color for the radio's [Material].
  ///
  /// Resolves in the following states:
  ///  * [MaterialState.pressed].
  ///  * [MaterialState.selected].
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  /// {@endtemplate}
  ///
  /// The default is to use the colors in the Material 3 specification
  ///
  /// See also:
  ///
  /// * https://m3.material.io/components/radio-button/specs
  MaterialStateProperty<Color> get stateLayerColor => _stateLayerColor!;
  final MaterialStateProperty<Color>? _stateLayerColor;

  /// Defines the state layer opacities applied to this radio.
  ///
  /// Default value is [ThemeData.stateTheme] .
  StateThemeData get stateTheme => _stateTheme!;
  final StateThemeData? _stateTheme;

  /// {@template flutter.material.radio.splashRadius}
  /// The splash radius of the circular [Material] ink response.
  /// {@endtemplate}
  ///
  /// The default is [kRadialReactionRadius].
  double get splashRadius => _splashRadius ?? kRadialReactionRadius;
  final double? _splashRadius;

  /// {@template flutter.material.radio.materialTapTargetSize}
  /// Configures the minimum size of the tap target.
  /// {@endtemplate}
  ///
  /// The default is [ThemeData.materialTapTargetSize].
  ///
  /// See also:
  ///
  ///  * [MaterialTapTargetSize], for a description of how this affects tap targets.
  MaterialTapTargetSize get materialTapTargetSize => _materialTapTargetSize!;
  final MaterialTapTargetSize? _materialTapTargetSize;

  /// {@template flutter.material.radio.visualDensity}
  /// Defines how compact the radio's layout will be.
  /// {@endtemplate}
  ///
  /// {@macro flutter.material.themedata.visualDensity}
  ///
  /// The default is [ThemeData.visualDensity].
  ///
  /// See also:
  ///
  ///  * [ThemeData.visualDensity], which specifies the [visualDensity] for all
  ///    widgets within a [Theme].
  VisualDensity get visualDensity => _visualDensity!;
  final VisualDensity? _visualDensity;

  /// Creates a copy of this object but with the given fields replaced with the
  /// new values.
  RadioThemeData copyWith({
    MaterialStateProperty<MouseCursor>? mouseCursor,
    MaterialStateProperty<Color>? containerColor,
    MaterialStateProperty<Color>? stateLayerColor,
    StateThemeData? stateTheme,
    double? splashRadius,
    MaterialTapTargetSize? materialTapTargetSize,
    VisualDensity? visualDensity,
  }) {
    return RadioThemeData(
      mouseCursor: mouseCursor ?? _mouseCursor,
      containerColor: containerColor ?? _containerColor,
      stateLayerColor: stateLayerColor ?? _stateLayerColor,
      stateTheme: stateTheme ?? _stateTheme,
      splashRadius: splashRadius ?? _splashRadius,
      materialTapTargetSize: materialTapTargetSize ?? _materialTapTargetSize,
      visualDensity: visualDensity ?? _visualDensity,
    );
  }

  /// Linearly interpolate between two [RadioThemeData]s.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static RadioThemeData lerp(RadioThemeData? a, RadioThemeData? b, double t) {
    if (identical(a, b) && a != null) {
      return a;
    }
    return RadioThemeData(
      mouseCursor: t < 0.5 ? a?.mouseCursor : b?.mouseCursor,
      containerColor: MaterialStateProperty.lerpNonNull<Color>(
          a?._containerColor,
          b?._containerColor,
          t,
          ColorExtensions.lerpNonNull),
      materialTapTargetSize:
          t < 0.5 ? a?.materialTapTargetSize : b?.materialTapTargetSize,
      stateLayerColor: MaterialStateProperty.lerpNonNull<Color>(
          a?._stateLayerColor,
          b?._stateLayerColor,
          t,
          ColorExtensions.lerpNonNull),
      splashRadius: lerpDouble(a?.splashRadius, b?.splashRadius, t),
      visualDensity: t < 0.5 ? a?.visualDensity : b?.visualDensity,
    );
  }

  @override
  int get hashCode => Object.hash(
        _mouseCursor,
        _containerColor,
        _stateLayerColor,
        _stateTheme,
        _splashRadius,
        _materialTapTargetSize,
        _visualDensity,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is RadioThemeData &&
        other._mouseCursor == _mouseCursor &&
        other._containerColor == _containerColor &&
        other._stateLayerColor == _stateLayerColor &&
        other._stateTheme == _stateTheme &&
        other._splashRadius == _splashRadius &&
        other._materialTapTargetSize == _materialTapTargetSize &&
        other._visualDensity == _visualDensity;
  }

  /// Creates a copy of this object with fields replaced with the
  /// non-null values from [other].
  RadioThemeData mergeWith(RadioThemeData? other) {
    return copyWith(
      mouseCursor: other?._mouseCursor,
      containerColor: other?._containerColor,
      stateLayerColor: other?._stateLayerColor,
      stateTheme: other?._stateTheme,
      splashRadius: other?._splashRadius,
      materialTapTargetSize: other?._materialTapTargetSize,
      visualDensity: other?._visualDensity,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<MaterialStateProperty<MouseCursor>>(
        'mouseCursor', _mouseCursor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>(
        'containerColor', _containerColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>(
        'stateLayerColor', _stateLayerColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<StateThemeData>(
        'stateTheme', _stateTheme,
        defaultValue: null));
    properties
        .add(DoubleProperty('splashRadius', _splashRadius, defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialTapTargetSize>(
        'materialTapTargetSize', _materialTapTargetSize,
        defaultValue: null));
    properties.add(DiagnosticsProperty<VisualDensity>(
        'visualDensity', _visualDensity,
        defaultValue: null));
  }
}

class _LateResolvingRadioThemeData extends RadioThemeData {
  _LateResolvingRadioThemeData(super.other, this.context) : super._clone();

  final BuildContext context;

  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;

  @override
  StateThemeData get stateTheme => _stateTheme ?? _theme.stateTheme;

  @override
  MaterialStateProperty<Color> get containerColor =>
      _containerColor ??
      MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          if (states.contains(MaterialState.disabled)) {
            return _colors.onSurface.withOpacity(stateTheme.disabledOpacity);
          }
          return _colors.primary;
        }
        if (states.contains(MaterialState.disabled)) {
          return _colors.onSurface.withOpacity(stateTheme.disabledOpacity);
        }
        if (states.contains(MaterialState.pressed)) {
          return _colors.onSurface;
        }
        if (states.contains(MaterialState.hovered)) {
          return _colors.onSurface;
        }
        if (states.contains(MaterialState.focused)) {
          return _colors.onSurface;
        }
        return _colors.onSurfaceVariant;
      });

  @override
  MaterialStateProperty<Color> get stateLayerColor =>
      _stateLayerColor ??
      MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          if (states.contains(MaterialState.pressed)) {
            return _colors.onSurface.withOpacity(stateTheme.pressOpacity);
          }
          if (states.contains(MaterialState.hovered)) {
            return _colors.primary.withOpacity(stateTheme.hoverOpacity);
          }
          if (states.contains(MaterialState.focused)) {
            return _colors.primary.withOpacity(stateTheme.focusOpacity);
          }
          return Colors.transparent;
        }
        if (states.contains(MaterialState.pressed)) {
          return _colors.primary.withOpacity(stateTheme.pressOpacity);
        }
        if (states.contains(MaterialState.hovered)) {
          return _colors.onSurface.withOpacity(stateTheme.hoverOpacity);
        }
        if (states.contains(MaterialState.focused)) {
          return _colors.onSurface.withOpacity(stateTheme.focusOpacity);
        }
        return Colors.transparent;
      });

  @override
  MaterialTapTargetSize get materialTapTargetSize =>
      _materialTapTargetSize ?? _theme.materialTapTargetSize;

  @override
  VisualDensity get visualDensity => _visualDensity ?? _theme.visualDensity;
}

/// Applies a radio theme to descendant [Radio] widgets.
///
/// Descendant widgets obtain the current theme's [RadioTheme] object using
/// [RadioTheme.of]. When a widget uses [RadioTheme.of], it is automatically
/// rebuilt if the theme later changes.
///
/// A radio theme can be specified as part of the overall Material theme using
/// [ThemeData.radioTheme].
///
/// See also:
///
///  * [RadioThemeData], which describes the actual configuration of a radio
///    theme.
class RadioTheme extends InheritedWidget {
  /// Constructs a radio theme that configures all descendant [Radio] widgets.
  const RadioTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The properties used for all descendant [Radio] widgets.
  final RadioThemeData data;

  /// Returns the configuration [data] from the closest [RadioTheme] ancestor.
  /// If there is no ancestor, it returns [ThemeData.radioTheme].
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// RadioThemeData theme = RadioTheme.of(context);
  /// ```
  static RadioThemeData of(BuildContext context) {
    final RadioTheme? radioTheme =
        context.dependOnInheritedWidgetOfExactType<RadioTheme>();
    return radioTheme?.data ?? Theme.of(context).radioTheme;
  }

  /// Return a [RadioThemeData] that merges the nearest ancestor [RadioTheme]
  /// and the [RadioThemeData] provided by the nearest [Theme].
  ///
  /// A current context theme can also be provided, used when the
  /// StateThemeData is passed as a parameter to a widget other than
  /// StateTheme.
  ///
  /// See also:
  ///
  /// * [BuildContext.dependOnInheritedWidgetOfExactType]
  static RadioThemeData resolve(
    BuildContext context, [
    RadioThemeData? currentContextTheme,
  ]) {
    final ancestorTheme =
        context.dependOnInheritedWidgetOfExactType<RadioTheme>()?.data;
    final List<RadioThemeData> ancestorThemes = [
      Theme.of(context).radioTheme,
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
  bool updateShouldNotify(RadioTheme oldWidget) => data != oldWidget.data;
}

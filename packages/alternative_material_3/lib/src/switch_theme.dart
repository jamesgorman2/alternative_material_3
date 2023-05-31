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
import 'icons.dart';
import 'material_state.dart';
import 'state_theme.dart';
import 'theme.dart';
import 'theme_data.dart';

// Examples can assume:
// late BuildContext context;

/// Defines default property values for descendant [Switch] widgets.
///
/// Descendant widgets obtain the current [SwitchThemeData] object using
/// `SwitchTheme.of(context)`. Instances of [SwitchThemeData] can be customized
/// with [SwitchThemeData.copyWith].
///
/// Typically a [SwitchThemeData] is specified as part of the overall [Theme]
/// with [ThemeData.switchTheme].
///
/// All [SwitchThemeData] properties are `null` by default. When null, the
/// [Switch] will use the values from [ThemeData] if they exist, otherwise it
/// will provide its own defaults based on the overall [Theme]'s colorScheme.
/// See the individual [Switch] properties for details.
///
/// See also:
///
///  * [ThemeData], which describes the overall theme information for the
///    application.
@immutable
class SwitchThemeData with Diagnosticable {
  /// Creates a theme that can be used for [ThemeData.switchTheme].
  const SwitchThemeData({
    MaterialStateProperty<Color>? thumbColor,
    MaterialStateProperty<Color>? trackColor,
    MaterialStateProperty<Color>? trackOutlineColor,
    MaterialTapTargetSize? materialTapTargetSize,
    MaterialStateProperty<MouseCursor>? mouseCursor,
    MaterialStateProperty<Color>? stateLayerColor,
    StateThemeData? stateTheme,
    double? splashRadius,
    MaterialStateProperty<Icon?>? thumbIcon,
  }) : _thumbColor = thumbColor,
  _trackColor = trackColor,
  _trackOutlineColor = trackOutlineColor,
  _materialTapTargetSize = materialTapTargetSize,
  _mouseCursor = mouseCursor,
  _stateLayerColor = stateLayerColor,
  _stateTheme = stateTheme,
  _splashRadius = splashRadius,
  _thumbIcon = thumbIcon;
  
  SwitchThemeData._clone(SwitchThemeData other)
      : _thumbColor = other._thumbColor,
        _trackColor = other._trackColor,
        _trackOutlineColor = other._trackOutlineColor,
        _materialTapTargetSize = other._materialTapTargetSize,
        _mouseCursor = other._mouseCursor,
        _stateLayerColor = other._stateLayerColor,
        _stateTheme = other._stateTheme,
        _splashRadius = other._splashRadius,
        _thumbIcon = other._thumbIcon;

  /// Copy this SwitchThemeData and set any default values that
  /// require a [BuildContext] set, such as colors and text themes.
  SwitchThemeData withContext(BuildContext context) =>
      _LateResolvingSwitchThemeData(this, context);

  /// {@template flutter.material.switch.thumbColor}
  /// The color of this [Switch]'s thumb.
  ///
  /// Resolved in the following states:
  ///  * [MaterialState.selected].
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  ///  * [MaterialState.disabled].
  MaterialStateProperty<Color> get thumbColor => _thumbColor!;
  final MaterialStateProperty<Color>? _thumbColor;

  /// {@template flutter.material.switch.trackColor}
  /// The color of this [Switch]'s track.
  ///
  /// Resolved in the following states:
  ///  * [MaterialState.selected].
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  ///  * [MaterialState.disabled].

  MaterialStateProperty<Color> get trackColor => _trackColor!;
  final MaterialStateProperty<Color>? _trackColor;

  /// {@template flutter.material.switch.trackOutlineColor}
  /// The outline color of this [Switch]'s track.
  ///
  /// Resolved in the following states:
  ///  * [MaterialState.selected].
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  ///  * [MaterialState.disabled].
  MaterialStateProperty<Color> get trackOutlineColor => _trackOutlineColor!;
  final MaterialStateProperty<Color>? _trackOutlineColor;


  /// {@template flutter.material.switch.materialTapTargetSize}
  /// Configures the minimum size of the tap target.
  /// {@endtemplate}
  ///
  /// The default value is
  /// [ThemeData.materialTapTargetSize].
  ///
  /// See also:
  ///
  ///  * [MaterialTapTargetSize], for a description of how this affects tap targets.
  MaterialTapTargetSize get materialTapTargetSize => _materialTapTargetSize!;
  final MaterialTapTargetSize? _materialTapTargetSize;

  /// {@template flutter.material.switch.mouseCursor}
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
  MaterialStateProperty<MouseCursor> get mouseCursor => _mouseCursor
    ?? MaterialStateMouseCursor.clickable;
  final MaterialStateProperty<MouseCursor>? _mouseCursor;

  /// {@template flutter.material.switch.overlayColor}
  /// The state layer color for the switch's [Material].
  ///
  /// Resolves in the following states:
  ///  * [MaterialState.pressed].
  ///  * [MaterialState.selected].
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  /// {@endtemplate}

  MaterialStateProperty<Color> get stateLayerColor => _stateLayerColor!;
  final MaterialStateProperty<Color>? _stateLayerColor;

  /// Defines the state layer opacities applied to this radio.
  ///
  /// Default value is [ThemeData.stateTheme] .
  StateThemeData get stateTheme => _stateTheme!;
  final StateThemeData? _stateTheme;

  /// {@template flutter.material.switch.splashRadius}
  /// The splash radius of the circular [Material] ink response.
  /// {@endtemplate}
  ///
  /// The default is [kRadialReactionRadius].
  double get splashRadius => _splashRadius ?? kRadialReactionRadius;
  final double? _splashRadius;

  /// {@template flutter.material.switch.thumbIcon}
  /// The icon to use on the thumb of this switch
  ///
  /// Resolved in the following states:
  ///  * [MaterialState.selected].
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  ///  * [MaterialState.disabled].
  MaterialStateProperty<Icon?> get thumbIcon => _thumbIcon
      ?? MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const Icon(Icons.check_outlined);
        }
        return null;
      });
  final MaterialStateProperty<Icon?>? _thumbIcon;

  /// Creates a copy of this object but with the given fields replaced with the
  /// new values.
  SwitchThemeData copyWith({
    MaterialStateProperty<Color>? thumbColor,
    MaterialStateProperty<Color>? trackColor,
    MaterialStateProperty<Color>? trackOutlineColor,
    MaterialTapTargetSize? materialTapTargetSize,
    MaterialStateProperty<MouseCursor>? mouseCursor,
    MaterialStateProperty<Color>? stateLayerColor,
    StateThemeData? stateTheme,
    double? splashRadius,
    MaterialStateProperty<Icon?>? thumbIcon,
  }) {
    return SwitchThemeData(
      thumbColor: thumbColor ?? _thumbColor,
      trackOutlineColor: trackOutlineColor ?? _trackOutlineColor,
      materialTapTargetSize: materialTapTargetSize ?? _materialTapTargetSize,
      mouseCursor: mouseCursor ?? _mouseCursor,
      stateLayerColor: stateLayerColor ?? _stateLayerColor,
      stateTheme: stateTheme ?? _stateTheme,
      splashRadius: splashRadius ?? _splashRadius,
      thumbIcon: thumbIcon ?? _thumbIcon,
    );
  }

  /// Creates a copy of this object with null fields replaced with the
  /// values from [other].
  SwitchThemeData mergeWith(SwitchThemeData other) {
    return copyWith(
      thumbColor: other._thumbColor,
      trackOutlineColor: other._trackOutlineColor,
      materialTapTargetSize: other._materialTapTargetSize,
      mouseCursor: other._mouseCursor,
      stateLayerColor: other._stateLayerColor,
      stateTheme: other._stateTheme,
      splashRadius: other._splashRadius,
      thumbIcon: other._thumbIcon,
    );
  }
  
  /// Linearly interpolate between two [SwitchThemeData]s.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static SwitchThemeData lerp(SwitchThemeData? a, SwitchThemeData? b, double t) {
    if (identical(a, b) && a != null) {
      return a;
    }
    return SwitchThemeData(
      thumbColor: MaterialStateProperty.lerpNonNull<Color>(a?._thumbColor, b?._thumbColor, t, ColorExtensions.lerpNonNull),
      trackColor: MaterialStateProperty.lerpNonNull<Color>(a?._trackColor, b?._trackColor, t, ColorExtensions.lerpNonNull),
      trackOutlineColor: MaterialStateProperty.lerpNonNull<Color>(a?._trackOutlineColor, b?._trackOutlineColor, t, ColorExtensions.lerpNonNull),
      materialTapTargetSize: t < 0.5 ? a?._materialTapTargetSize : b?._materialTapTargetSize,
      mouseCursor: t < 0.5 ? a?._mouseCursor : b?._mouseCursor,
      stateLayerColor: MaterialStateProperty.lerpNonNull<Color>(a?._stateLayerColor, b?._stateLayerColor, t, ColorExtensions.lerpNonNull),
      stateTheme: StateThemeData.lerp(a?._stateTheme, b?._stateTheme, t),
      splashRadius: lerpDouble(a?._splashRadius, b?._splashRadius, t),
      thumbIcon: t < 0.5 ? a?._thumbIcon : b?._thumbIcon,
    );
  }

  @override
  int get hashCode => Object.hash(
    _thumbColor,
    _trackColor,
    _trackOutlineColor,
    _materialTapTargetSize,
    _mouseCursor,
    _stateLayerColor,
    _stateTheme,
    _splashRadius,
    _thumbIcon,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SwitchThemeData
      && other._thumbColor == _thumbColor
      && other._trackColor == _trackColor
      && other._trackOutlineColor == _trackOutlineColor
      && other._materialTapTargetSize == _materialTapTargetSize
      && other._mouseCursor == _mouseCursor
      && other._stateLayerColor == _stateLayerColor
      && other._stateTheme == _stateTheme
      && other._splashRadius == _splashRadius
      && other._thumbIcon == _thumbIcon;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>('thumbColor', _thumbColor, defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>('trackColor', _trackColor, defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>('trackOutlineColor', _trackOutlineColor, defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialTapTargetSize>('materialTapTargetSize', _materialTapTargetSize, defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<MouseCursor?>>('mouseCursor', _mouseCursor, defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>('stateLayerColor', _stateLayerColor, defaultValue: null));
    properties.add(DiagnosticsProperty<StateThemeData>('stateTheme', _stateTheme, defaultValue: null));
    properties.add(DoubleProperty('splashRadius', _splashRadius, defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Icon?>>('thumbIcon', _thumbIcon, defaultValue: null));
  }
}

class _LateResolvingSwitchThemeData extends SwitchThemeData {
  _LateResolvingSwitchThemeData(super.other, this.context) : super._clone();

  final BuildContext context;

  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;

  @override
  StateThemeData get stateTheme => _stateTheme ?? _theme.stateTheme;

  @override
  MaterialStateProperty<Color> get thumbColor {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        if (states.contains(MaterialState.selected)) {
          return _colors.surface;
        }
        return _colors.onSurface.withOpacity(stateTheme.disabledOpacity);
      }
      if (states.contains(MaterialState.selected)) {
        if (states.contains(MaterialState.pressed)) {
          return _colors.primaryContainer;
        }
        if (states.contains(MaterialState.hovered)) {
          return _colors.primaryContainer;
        }
        if (states.contains(MaterialState.focused)) {
          return _colors.primaryContainer;
        }
        return _colors.onPrimary;
      }
      if (states.contains(MaterialState.pressed)) {
        return _colors.onSurfaceVariant;
      }
      if (states.contains(MaterialState.hovered)) {
        return _colors.onSurfaceVariant;
      }
      if (states.contains(MaterialState.focused)) {
        return _colors.onSurfaceVariant;
      }
      return _colors.outline;
    });
  }

  @override
  MaterialStateProperty<Color> get trackColor {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        if (states.contains(MaterialState.selected)) {
          return _colors.onSurface.withOpacity(stateTheme.disabledOpacityLight);
        }
        return _colors.surface.withOpacity(stateTheme.disabledOpacityLight);
      }
      if (states.contains(MaterialState.selected)) {
        return _colors.primary;
      }
      if (states.contains(MaterialState.pressed)) {
        return _colors.surfaceContainerHighest;
      }
      if (states.contains(MaterialState.hovered)) {
        return _colors.surfaceContainerHighest;
      }
      if (states.contains(MaterialState.focused)) {
        return _colors.surfaceContainerHighest;
      }
      return _colors.surfaceContainerHighest;
    });
  }

  @override
  MaterialStateProperty<Color> get trackOutlineColor {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.transparent;
      }
      if (states.contains(MaterialState.disabled)) {
        return _colors.onSurface.withOpacity(stateTheme.disabledOpacityLight);
      }
      return _colors.outline;
    });
  }

  @override
  MaterialStateProperty<Color> get stateLayerColor {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        if (states.contains(MaterialState.pressed)) {
          return _colors.primary.withOpacity(stateTheme.pressOpacity);
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
        return _colors.onSurface.withOpacity(stateTheme.pressOpacity);
      }
      if (states.contains(MaterialState.hovered)) {
        return _colors.onSurface.withOpacity(stateTheme.hoverOpacity);
      }
      if (states.contains(MaterialState.focused)) {
        return _colors.onSurface.withOpacity(stateTheme.focusOpacity);
      }
      return Colors.transparent;
    });
  }

  @override
  MaterialTapTargetSize? get _materialTapTargetSize => _theme.materialTapTargetSize;
}

/// Applies a switch theme to descendant [Switch] widgets.
///
/// Descendant widgets obtain the current theme's [SwitchTheme] object using
/// [SwitchTheme.of]. When a widget uses [SwitchTheme.of], it is automatically
/// rebuilt if the theme later changes.
///
/// A switch theme can be specified as part of the overall Material theme using
/// [ThemeData.switchTheme].
///
/// See also:
///
///  * [SwitchThemeData], which describes the actual configuration of a switch
///    theme.
class SwitchTheme extends InheritedWidget {
  /// Constructs a switch theme that configures all descendant [Switch] widgets.
  const SwitchTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The properties used for all descendant [Switch] widgets.
  final SwitchThemeData data;

  /// Returns the configuration [data] from the closest [SwitchTheme] ancestor.
  /// If there is no ancestor, it returns [ThemeData.switchTheme].
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// SwitchThemeData theme = SwitchTheme.of(context);
  /// ```
  static SwitchThemeData of(BuildContext context) {
    final SwitchTheme? switchTheme = context.dependOnInheritedWidgetOfExactType<SwitchTheme>();
    return switchTheme?.data ?? Theme.of(context).switchTheme;
  }
  /// Return a [SwitchThemeData] that merges the nearest ancestor [SwitchTheme]
  /// and the [SwitchThemeData] provided by the nearest [Theme].
  ///
  /// A current context theme can also be provided, used when the
  /// StateThemeData is passed as a parameter to a widget other than
  /// StateTheme.
  ///
  /// See also:
  ///
  /// * [BuildContext.dependOnInheritedWidgetOfExactType]
  static SwitchThemeData resolve(
      BuildContext context, [
        SwitchThemeData? currentContextTheme,
      ]) {
    final ancestorTheme =
        context.dependOnInheritedWidgetOfExactType<SwitchTheme>()?.data;
    final List<SwitchThemeData> ancestorThemes = [
      Theme.of(context).switchTheme,
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
  bool updateShouldNotify(SwitchTheme oldWidget) => data != oldWidget.data;
}

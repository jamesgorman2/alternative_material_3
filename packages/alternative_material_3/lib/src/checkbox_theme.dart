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

/// Defines default property values for descendant [Checkbox] widgets.
///
/// Descendant widgets obtain the current [CheckboxThemeData] object using
/// `CheckboxTheme.of(context)`. Instances of [CheckboxThemeData] can be
/// customized with [CheckboxThemeData.copyWith].
///
/// Typically a [CheckboxThemeData] is specified as part of the overall [Theme]
/// with [ThemeData.checkboxTheme].
///
/// All [CheckboxThemeData] properties are `null` by default. When null, the
/// [Checkbox] will use the values from [ThemeData] if they exist, otherwise it
/// will provide its own defaults based on the overall [Theme]'s colorScheme.
/// See the individual [Checkbox] properties for details.
///
/// See also:
///
///  * [ThemeData], which describes the overall theme information for the
///    application.
@immutable
class CheckboxThemeData with Diagnosticable {
  /// Creates a theme that can be used for [ThemeData.checkboxTheme].
  const CheckboxThemeData({
    MaterialStateProperty<MouseCursor>? mouseCursor,
    MaterialStateProperty<Color>? containerColor,
    MaterialStateProperty<Color>? checkColor,
    MaterialStateProperty<Color>? stateLayerColor,
    StateThemeData? stateTheme,
    double? splashRadius,
    MaterialTapTargetSize? materialTapTargetSize,
    VisualDensity? visualDensity,
    OutlinedBorder? shape,
    MaterialStateBorderSide? side,
  })  : _mouseCursor = mouseCursor,
        _containerColor = containerColor,
        _iconColor = checkColor,
        _stateLayerColor = stateLayerColor,
        _stateTheme = stateTheme,
        _splashRadius = splashRadius,
        _materialTapTargetSize = materialTapTargetSize,
        _visualDensity = visualDensity,
        _shape = shape,
        _side = side;

  CheckboxThemeData._clone(CheckboxThemeData other)
      : _mouseCursor = other._mouseCursor,
        _containerColor = other._containerColor,
        _iconColor = other._iconColor,
        _stateLayerColor = other._stateLayerColor,
        _stateTheme = other._stateTheme,
        _splashRadius = other._splashRadius,
        _materialTapTargetSize = other._materialTapTargetSize,
        _visualDensity = other._visualDensity,
        _shape = other._shape,
        _side = other._side;

  /// Copy this ListTileThemeData and set any default values that
  /// require a [BuildContext] set, such as colors and text themes.
  CheckboxThemeData withContext(BuildContext context) =>
      _LateResolvingCheckboxThemeData(this, context);

  /// {@template flutter.material.checkbox.mouseCursor}
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
  /// When [value] is null and [tristate] is true, [MaterialState.selected] is
  /// included as a state.
  ///
  /// The default value is [MaterialStateMouseCursor.clickable].
  ///
  /// See also:
  ///
  ///  * [MaterialStateMouseCursor], a [MouseCursor] that implements
  ///    `MaterialStateProperty` which is used in APIs that need to accept
  ///    either a [MouseCursor] or a [MaterialStateProperty<MouseCursor>].
  MaterialStateProperty<MouseCursor> get mouseCursor => _mouseCursor
      ?? MaterialStateMouseCursor.clickable;
  final MaterialStateProperty<MouseCursor>? _mouseCursor;

  /// {@template flutter.material.checkbox.fillColor}
  /// The color that fills the checkbox, in all [MaterialState]s.
  ///
  /// Resolves in the following states:
  ///  * [MaterialState.selected].
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  ///  * [MaterialState.disabled].
  ///
  /// {@tool snippet}
  /// This example resolves the [containerColor] based on the current [MaterialState]
  /// of the [Checkbox], providing a different [Color] when it is
  /// [MaterialState.disabled].
  ///
  /// ```dart
  /// Checkbox(
  ///   value: true,
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
  /// The default value is [ColorScheme.secondary] in the
  /// selected state, and [ColorScheme.onSurface] is in the
  /// default state.
  MaterialStateProperty<Color> get containerColor => _containerColor!;
  final MaterialStateProperty<Color>? _containerColor;

  /// {@template flutter.material.checkbox.checkColor}
  /// The color to use for the check icon when this checkbox is checked.
  /// {@endtemplate}
  ///
  /// The default value is [ColorScheme.onPrimary].
  ///
  /// Resolves in the following states:
  ///  * [MaterialState.selected].
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  ///  * [MaterialState.disabled].
  ///
  /// If specified, overrides the default value of [Checkbox.expandedIconColor].
  MaterialStateProperty<Color> get iconColor => _iconColor!;
  final MaterialStateProperty<Color>? _iconColor;

  /// {@template flutter.material.checkbox.overlayColor}
  /// The color for the checkbox's [Material].
  ///
  /// Resolves in the following states:
  ///  * [MaterialState.pressed].
  ///  * [MaterialState.selected].
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  /// {@endtemplate}
  ///
  /// The default color value for all states is
  /// [ColorScheme.onSurface].
  /// The default opacity is [StateThemeData].
  MaterialStateProperty<Color> get stateLayerColor => _stateLayerColor!;
  final MaterialStateProperty<Color>? _stateLayerColor;

  /// Defines the state layer opacities applied to this checkbox.
  ///
  /// Default value is [ThemeData.stateTheme] .
  StateThemeData get stateTheme => _stateTheme!;
  final StateThemeData? _stateTheme;

  /// {@template flutter.material.checkbox.splashRadius}
  /// The splash radius of the circular [Material] ink response.
  /// {@endtemplate}
  ///
  /// The default value is [kRadialReactionRadius].
  double get splashRadius => _splashRadius ?? kRadialReactionRadius;
  final double? _splashRadius;

  /// {@template flutter.material.checkbox.materialTapTargetSize}
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

  /// {@template flutter.material.checkbox.visualDensity}
  /// Defines how compact the checkbox's layout will be.
  /// {@endtemplate}
  ///
  /// {@macro flutter.material.themedata.visualDensity}
  ///
  /// The default value is [ThemeData.visualDensity].
  ///
  /// See also:
  ///
  ///  * [ThemeData.visualDensity], which specifies the [visualDensity] for all
  ///    widgets within a [Theme].
  VisualDensity get visualDensity => _visualDensity!;
  final VisualDensity? _visualDensity;

  /// {@template flutter.material.checkbox.shape}
  /// The shape of the checkbox's [Material].
  /// {@endtemplate}
  ///
  /// The default is [RoundedRectangleBorder]
  /// with a circular corner radius of 2.0.
  OutlinedBorder get shape =>
      _shape ??
      const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      );
  final OutlinedBorder? _shape;

  /// {@template flutter.material.checkbox.side}
  /// The color and width of the checkbox's border.
  ///
  /// This property can be a [MaterialStateBorderSide] that can
  /// specify different border color and widths depending on the
  /// checkbox's state.
  ///
  /// Resolves in the following states:
  ///  * [MaterialState.pressed].
  ///  * [MaterialState.selected].
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  ///  * [MaterialState.disabled].
  ///  * [MaterialState.error].
  ///
  /// The default value is [BorderSide] with width 2.
  MaterialStateBorderSide get side => _side!;
  final MaterialStateBorderSide? _side;

  /// Creates a copy of this object but with the given fields replaced with the
  /// new values.
  CheckboxThemeData copyWith({
    MaterialStateProperty<MouseCursor>? mouseCursor,
    MaterialStateProperty<Color>? containerColor,
    MaterialStateProperty<Color>? checkColor,
    MaterialStateProperty<Color>? stateLayerColor,
    StateThemeData? stateTheme,
    double? splashRadius,
    MaterialTapTargetSize? materialTapTargetSize,
    VisualDensity? visualDensity,
    OutlinedBorder? shape,
    MaterialStateBorderSide? side,
  }) {
    return CheckboxThemeData(
      mouseCursor: mouseCursor ?? _mouseCursor,
      containerColor: containerColor ?? _containerColor,
      checkColor: checkColor ?? _iconColor,
      stateLayerColor: stateLayerColor ?? _stateLayerColor,
      stateTheme: stateTheme ?? _stateTheme,
      splashRadius: splashRadius ?? _splashRadius,
      materialTapTargetSize: materialTapTargetSize ?? _materialTapTargetSize,
      visualDensity: visualDensity ?? _visualDensity,
      shape: shape ?? _shape,
      side: side ?? _side,
    );
  }

  /// Linearly interpolate between two [CheckboxThemeData]s.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static CheckboxThemeData lerp(
      CheckboxThemeData? a, CheckboxThemeData? b, double t) {
    if (identical(a, b) && a != null) {
      return a;
    }
    return CheckboxThemeData(
      mouseCursor: t < 0.5 ? a?.mouseCursor : b?.mouseCursor,
      containerColor: MaterialStateProperty.lerpNonNull<Color>(
          a?._containerColor,
          b?._containerColor,
          t,
          ColorExtensions.lerpNonNull),
      checkColor: MaterialStateProperty.lerpNonNull<Color>(
          a?.iconColor, b?.iconColor, t, ColorExtensions.lerpNonNull),
      stateLayerColor: MaterialStateProperty.lerpNonNull<Color>(
          a?._stateLayerColor,
          b?._stateLayerColor,
          t,
          ColorExtensions.lerpNonNull),
      stateTheme: StateThemeData.lerp(a?._stateTheme, b?._stateTheme, t),
      splashRadius: lerpDouble(a?._splashRadius, b?._splashRadius, t),
      materialTapTargetSize:
          t < 0.5 ? a?._materialTapTargetSize : b?._materialTapTargetSize,
      visualDensity: t < 0.5 ? a?._visualDensity : b?._visualDensity,
      shape: ShapeBorder.lerp(a?._shape, b?._shape, t) as OutlinedBorder?,
      side: MaterialStateBorderSide.lerp(a?._side, b?._side, t),
    );
  }

  @override
  int get hashCode => Object.hash(
        _mouseCursor,
        _containerColor,
        _iconColor,
        _stateLayerColor,
        _stateTheme,
        _splashRadius,
        _materialTapTargetSize,
        _visualDensity,
        _shape,
        _side,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is CheckboxThemeData &&
        other._mouseCursor == _mouseCursor &&
        other._containerColor == _containerColor &&
        other._iconColor == _iconColor &&
        other._stateLayerColor == _stateLayerColor &&
        other._stateTheme == _stateTheme &&
        other._splashRadius == _splashRadius &&
        other._materialTapTargetSize == _materialTapTargetSize &&
        other._visualDensity == _visualDensity &&
        other._shape == _shape &&
        other._side == _side;
  }

  /// Creates a copy of this object with fields replaced with the
  /// non-null values from [other].
  CheckboxThemeData mergeWith(CheckboxThemeData other) {
    return copyWith(
      mouseCursor: other._mouseCursor,
      containerColor: other._containerColor,
      checkColor: other._iconColor,
      stateLayerColor: other._stateLayerColor,
      stateTheme: other._stateTheme,
      splashRadius: other._splashRadius,
      materialTapTargetSize:
          other._materialTapTargetSize,
      visualDensity: other._visualDensity,
      shape: other._shape,
      side: other._side,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<MaterialStateProperty<MouseCursor>>(
        'mouseCursor',
        _mouseCursor,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<MaterialStateProperty<Color>>(
        'fillColor',
        _containerColor,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<MaterialStateProperty<Color>>(
        'checkColor',
        _iconColor,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<MaterialStateProperty<Color>>(
        'overlayColor',
        _stateLayerColor,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<StateThemeData>(
        'stateTheme',
        _stateTheme,
        defaultValue: null,
      ),
    );
    properties.add(
      DoubleProperty(
        'splashRadius',
        _splashRadius,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<MaterialTapTargetSize>(
        'materialTapTargetSize',
        _materialTapTargetSize,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<VisualDensity>(
        'visualDensity',
        _visualDensity,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<OutlinedBorder>(
        'shape',
        _shape,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<MaterialStateBorderSide>(
        'side',
        _side,
        defaultValue: null,
      ),
    );
  }
}

class _LateResolvingCheckboxThemeData extends CheckboxThemeData {
  _LateResolvingCheckboxThemeData(super.other, this.context) : super._clone();

  final BuildContext context;

  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;

  @override
  StateThemeData get stateTheme => _stateTheme ?? _theme.stateTheme;

  @override
  MaterialStateProperty<Color> get containerColor {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return _colors.onSurface.withOpacity(stateTheme.disabledOpacity);
      }
      if (states.contains(MaterialState.error)) {
        return _colors.error;
      }
      if (states.contains(MaterialState.selected)) {
        return _colors.primary;
      }
      return _colors.onSurface;
    });
  }

  @override
  MaterialStateProperty<Color> get iconColor {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        if (states.contains(MaterialState.selected)) {
          return _colors.surface.withOpacity(stateTheme.disabledOpacity);
        }
        return Colors
            .transparent; // No icons available when the checkbox is unselected.
      }
      if (states.contains(MaterialState.selected)) {
        if (states.contains(MaterialState.error)) {
          return _colors.onError;
        }
        return _colors.onPrimary;
      }
      return Colors
          .transparent; // No icons available when the checkbox is unselected.
    });
  }

  @override
  MaterialStateProperty<Color> get stateLayerColor {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return Colors.transparent;
      }
      if (states.contains(MaterialState.error)) {
        if (states.contains(MaterialState.pressed)) {
          return _colors.error.withOpacity(stateTheme.pressOpacity);
        }
        if (states.contains(MaterialState.hovered)) {
          return _colors.error.withOpacity(stateTheme.hoverOpacity);
        }
        if (states.contains(MaterialState.focused)) {
          return _colors.error.withOpacity(stateTheme.focusOpacity);
        }
      }
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
  }

  @override
  MaterialTapTargetSize get materialTapTargetSize =>
      _materialTapTargetSize ?? _theme.materialTapTargetSize;

  @override
  VisualDensity get visualDensity => _visualDensity ?? _theme.visualDensity;

  @override
  MaterialStateBorderSide get side =>
      MaterialStateBorderSide.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return null;
        }
        if (states.contains(MaterialState.disabled)) {
          return BorderSide(
              color: _colors.onSurface.withOpacity(stateTheme.disabledOpacity),
              width: 2.0);
        }
        if (states.contains(MaterialState.error)) {
          return BorderSide(color: _colors.error, width: 2.0);
        }
        return BorderSide(color: _colors.onSurface, width: 2.0);
      });
}

/// Applies a checkbox theme to descendant [Checkbox] widgets.
///
/// Descendant widgets obtain the current theme's [CheckboxTheme] object using
/// [CheckboxTheme.of]. When a widget uses [CheckboxTheme.of], it is
/// automatically rebuilt if the theme later changes.
///
/// A checkbox theme can be specified as part of the overall Material theme
/// using [ThemeData.checkboxTheme].
///
/// See also:
///
///  * [CheckboxThemeData], which describes the actual configuration of a
///  checkbox theme.
class CheckboxTheme extends InheritedWidget {
  /// Constructs a checkbox theme that configures all descendant [Checkbox]
  /// widgets.
  const CheckboxTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The properties used for all descendant [Checkbox] widgets.
  final CheckboxThemeData data;

  /// Returns the configuration [data] from the closest [CheckboxTheme]
  /// ancestor. If there is no ancestor, it returns [ThemeData.checkboxTheme].
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// CheckboxThemeData theme = CheckboxTheme.of(context);
  /// ```
  static CheckboxThemeData of(BuildContext context) {
    final CheckboxTheme? checkboxTheme =
        context.dependOnInheritedWidgetOfExactType<CheckboxTheme>();
    return checkboxTheme?.data ?? Theme.of(context).checkboxTheme;
  }

  /// Return a [CheckboxThemeData] that merges the nearest ancestor [CheckboxTheme]
  /// and the [CheckboxThemeData] provided by the nearest [Theme].
  ///
  /// A current context theme can also be provided, used when the
  /// StateThemeData is passed as a parameter to a widget other than
  /// StateTheme.
  ///
  /// See also:
  ///
  /// * [BuildContext.dependOnInheritedWidgetOfExactType]
  static CheckboxThemeData resolve(
    BuildContext context, [
    CheckboxThemeData? currentContextTheme,
  ]) {
    final ancestorTheme =
        context.dependOnInheritedWidgetOfExactType<CheckboxTheme>()?.data;
    final List<CheckboxThemeData> ancestorThemes = [
      Theme.of(context).checkboxTheme,
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
  bool updateShouldNotify(CheckboxTheme oldWidget) => data != oldWidget.data;
}

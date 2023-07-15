// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../color_extensions.dart';
import '../color_scheme.dart';
import '../elevation.dart';
import '../ink_well.dart';
import '../material.dart';
import '../material_state.dart';
import '../painting/borders.dart';
import '../state_theme.dart';
import '../theme.dart';

/// Defines default property values for descendant [Card] widgets.
///
/// Descendant widgets obtain the current [CardThemeData] object using
/// `CardTheme.of(context)`. Instances of [CardThemeData] can be
/// customized with [CardThemeData.copyWith].
///
/// Typically a [CardTheme] is specified as part of the overall [Theme]
/// with [ThemeData.cardTheme].
///
/// All [CardTheme] properties are `null` by default. When null, the [Card]
/// will use the values from [ThemeData] if they exist, otherwise it will
/// provide its own defaults.
///
/// See also:
///
///  * [ThemeData], which describes the overall theme information for the
///    application.
@immutable
class CardThemeData with Diagnosticable {
  /// Creates a theme that can be used for [ThemeData.cardTheme].
  const CardThemeData({
    Clip? clipBehavior,
    MaterialStateProperty<Color>? color,
    Color? shadowColor,
    MaterialStateProperty<Elevation>? elevation,
    OutlinedBorder? shape,
    MaterialStateProperty<BorderSide?>? outline,
    MaterialStateProperty<MouseCursor>? defaultMouseCursor,
    MaterialStateProperty<MouseCursor>? interactiveMouseCursor,
    bool? enableFeedback,
    InteractiveInkFeatureFactory? splashFactory,
    StateLayerColors? stateLayers,
  })  : _clipBehavior = clipBehavior,
        _color = color,
        _shadowColor = shadowColor,
        _elevation = elevation,
        _shape = shape,
        _outline = outline,
        _defaultMouseCursor = defaultMouseCursor,
        _interactiveMouseCursor = interactiveMouseCursor,
        _enableFeedback = enableFeedback,
        _splashFactory = splashFactory,
        _stateLayers = stateLayers;

  @protected
  CardThemeData.clone(CardThemeData other)
      : _clipBehavior = other._clipBehavior,
        _color = other._color,
        _shadowColor = other._shadowColor,
        _elevation = other._elevation,
        _shape = other._shape,
        _outline = other._outline,
        _defaultMouseCursor = other._defaultMouseCursor,
        _interactiveMouseCursor = other._interactiveMouseCursor,
        _enableFeedback = other._enableFeedback,
        _splashFactory = other._splashFactory,
        _stateLayers = other._stateLayers;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// If null, [Card] uses [Clip.hardEdge].
  Clip get clipBehavior => _clipBehavior ?? Clip.hardEdge;
  final Clip? _clipBehavior;

  /// The card's background color.
  ///
  /// Defines the card's [Material.color].
  ///
  /// If this property is null then [ColorScheme.surface] of
  /// [ThemeData.colorScheme] is used.
  MaterialStateProperty<Color> get color => _color!;
  final MaterialStateProperty<Color>? _color;

  /// The color to paint the shadow below the card.
  ///
  /// If null then [ThemeData.colorScheme.shadow] is used.
  Color get shadowColor => _shadowColor!;
  final Color? _shadowColor;

  /// The z-coordinate at which to place this card. This controls the size of
  /// the shadow below the card.
  ///
  /// Defines the card's [Material.elevation].
  ///
  /// The default value is [Elevation.level1].
  MaterialStateProperty<Elevation> get elevation => _elevation!;
  final MaterialStateProperty<Elevation>? _elevation;

  /// The shape of the card's [Material].
  ///
  /// Defines the card's [Material.shape].
  ///
  /// The default value is a [RoundedRectangleBorder]
  /// with a circular corner radius of 12.0.
  OutlinedBorder get shape =>
      _shape ??
      const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      );
  final OutlinedBorder? _shape;

  /// The card's outline.
  MaterialStateProperty<BorderSide?> get outline =>
      _outline ?? MaterialStateProperty.all<BorderSide?>(null);
  final MaterialStateProperty<BorderSide?>? _outline;

  /// {@template flutter.material.cardTheme.mouseCursor}
  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// widget when the card is non-interactive.
  /// {@endtemplate}
  ///
  /// The default value is [MaterialStateMouseCursor.basic].
  ///
  /// See also:
  ///
  ///  * [MaterialStateMouseCursor], which can be used to create a [MouseCursor]
  ///    that is also a [MaterialStateProperty<MouseCursor>].
  MaterialStateProperty<MouseCursor> get defaultMouseCursor =>
      _defaultMouseCursor ?? MaterialStateMouseCursor.basic;
  final MaterialStateProperty<MouseCursor>? _defaultMouseCursor;

  /// {@template flutter.material.cardTheme.interactiveMouseCursor}
  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// widget when the card is interactive.
  /// {@endtemplate}
  ///
  /// The default value is [MaterialStateMouseCursor.clickable].
  ///
  /// See also:
  ///
  ///  * [MaterialStateMouseCursor], which can be used to create a [MouseCursor]
  ///    that is also a [MaterialStateProperty<MouseCursor>].
  MaterialStateProperty<MouseCursor> get interactiveMouseCursor =>
      _interactiveMouseCursor ?? MaterialStateMouseCursor.clickable;
  final MaterialStateProperty<MouseCursor>? _interactiveMouseCursor;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  ///
  /// For example, on Android a tap will produce a clicking sound and a
  /// long-press will produce a short vibration, when feedback is enabled.
  ///
  /// Typically the component default value is true.
  ///
  /// See also:
  ///
  ///  * [Feedback] for providing platform-specific feedback to certain actions.
  bool get enableFeedback => _enableFeedback ?? true;
  final bool? _enableFeedback;

  /// {@template alternative_material_3.card.splashFactory}
  /// Creates the [InkWell] splash factory, which defines the appearance of
  /// "ink" splashes that occur in response to taps when the card is
  /// interactive.
  ///
  /// Use [NoSplash.splashFactory] to defeat ink splash rendering. For example:
  /// ```dart
  /// ElevatedButton(
  ///   style: ElevatedButton.styleFrom(
  ///     splashFactory: NoSplash.splashFactory,
  ///   ),
  ///   onPressed: () { },
  ///   child: const Text('No Splash'),
  /// )
  /// ```
  /// {@endtemplate}
  InteractiveInkFeatureFactory? get splashFactory => _splashFactory;
  final InteractiveInkFeatureFactory? _splashFactory;

  /// Defines the state layers applied to this card.
  StateLayerColors get stateLayers => _stateLayers!;
  final StateLayerColors? _stateLayers;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  CardThemeData copyWith({
    Clip? clipBehavior,
    MaterialStateProperty<Color>? color,
    Color? shadowColor,
    MaterialStateProperty<Elevation>? elevation,
    OutlinedBorder? shape,
    MaterialStateProperty<BorderSide?>? outline,
    MaterialStateProperty<MouseCursor>? defaultMouseCursor,
    MaterialStateProperty<MouseCursor>? interactiveMouseCursor,
    bool? enableFeedback,
    InteractiveInkFeatureFactory? splashFactory,
    StateLayerColors? stateLayers,
  }) {
    return CardThemeData(
      clipBehavior: clipBehavior ?? _clipBehavior,
      color: color ?? _color,
      shadowColor: shadowColor ?? _shadowColor,
      elevation: elevation ?? _elevation,
      shape: shape ?? _shape,
      outline: outline ?? _outline,
      defaultMouseCursor: defaultMouseCursor ?? _defaultMouseCursor,
      interactiveMouseCursor: interactiveMouseCursor ?? _interactiveMouseCursor,
      enableFeedback: enableFeedback ?? _enableFeedback,
      splashFactory: splashFactory ?? _splashFactory,
      stateLayers: stateLayers ?? _stateLayers,
    );
  }

  /// Returns a copy of this CardThemeData where the non-null fields in [other]
  /// have replaced the corresponding null fields in this CardThemeData.
  CardThemeData mergeWith(CardThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      clipBehavior: other._clipBehavior,
      color: other._color,
      shadowColor: other._shadowColor,
      elevation: other._elevation,
      shape: other._shape,
      outline: other._outline,
      defaultMouseCursor: other._defaultMouseCursor,
      interactiveMouseCursor: other._interactiveMouseCursor,
      enableFeedback: other._enableFeedback,
      splashFactory: other._splashFactory,
      stateLayers: other._stateLayers,
    );
  }

  /// Linearly interpolate between two Card themes.
  ///
  /// The argument `t` must not be null.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static CardThemeData lerp(CardThemeData? a, CardThemeData? b, double t) {
    if (identical(a, b) && a != null) {
      return a;
    }
    return CardThemeData(
        clipBehavior: t < 0.5 ? a?.clipBehavior : b?.clipBehavior,
        color: MaterialStateProperty.lerpNonNull(
          a?.color,
          b?.color,
          t,
          ColorExtensions.lerpNonNull,
        ),
        shadowColor: Color.lerp(a?.shadowColor, b?.shadowColor, t),
        elevation: MaterialStateProperty.lerpNonNull(
          a?.elevation,
          b?.elevation,
          t,
          Elevation.lerp,
        ),
        shape: OutlinedBorder.lerp(a?.shape, b?.shape, t),
        outline: BorderSideExtensions.lerpNull(a?._outline, b?._outline, t),
        defaultMouseCursor:
            t < 0.5 ? a?._defaultMouseCursor : b?._defaultMouseCursor,
        interactiveMouseCursor:
            t < 0.5 ? a?._interactiveMouseCursor : b?._interactiveMouseCursor,
        enableFeedback: t < 0.5 ? a?._enableFeedback : b?._enableFeedback,
        splashFactory: t < 0.5 ? a?._splashFactory : b?._splashFactory,
        stateLayers:
            StateLayerColors.lerp(a?._stateLayers, b?._stateLayers, t));
  }

  @override
  int get hashCode => Object.hash(
        _clipBehavior,
        _color,
        _shadowColor,
        _elevation,
        _shape,
        _outline,
        _defaultMouseCursor,
        _interactiveMouseCursor,
        _enableFeedback,
        _splashFactory,
        _stateLayers,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is CardThemeData &&
        other._clipBehavior == _clipBehavior &&
        other._color == _color &&
        other._shadowColor == _shadowColor &&
        other._elevation == _elevation &&
        other._shape == _shape &&
        other._outline == _outline &&
        other._defaultMouseCursor == _defaultMouseCursor &&
        other._interactiveMouseCursor == _interactiveMouseCursor &&
        other._enableFeedback == _enableFeedback &&
        other._splashFactory == _splashFactory &&
        other._stateLayers == _stateLayers;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Clip>('clipBehavior', _clipBehavior,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>(
        'color', _color,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Color>('shadowColor', _shadowColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Elevation>>(
        'elevation', _elevation,
        defaultValue: null));
    properties.add(DiagnosticsProperty<OutlinedBorder>('shape', _shape,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<BorderSide?>>(
        'outline', _outline,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<MouseCursor>>(
        'defaultMouseCursor', _defaultMouseCursor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<MouseCursor>>(
        'interactiveMouseCursor', _interactiveMouseCursor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<bool>('enableFeedback', _enableFeedback,
        defaultValue: null));
    properties.add(DiagnosticsProperty<InteractiveInkFeatureFactory>(
        'splashFactory', _splashFactory,
        defaultValue: null));
    properties.add(DiagnosticsProperty<StateLayerColors>(
        'stateLayers', _stateLayers,
        defaultValue: null));
  }
}

class ElevatedCardThemeData extends CardThemeData {
  ///
  ElevatedCardThemeData(
    super.other,
    BuildContext context,
  )   : _context = context,
        super.clone();
  final BuildContext _context;

  late final ThemeData _theme = Theme.of(_context);
  late final ColorScheme _colors = _theme.colorScheme;
  late final StateThemeData _stateTheme = StateTheme.resolve(_context);

  @override
  MaterialStateProperty<Color> get color =>
      _color ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return _colors.surfaceVariant
              .withOpacity(_stateTheme.disabledOpacity);
        }
        return _colors.surfaceContainerLow;
      });

  @override
  Color get shadowColor => _shadowColor ?? _colors.shadow;

  @override
  MaterialStateProperty<Elevation> get elevation =>
      _elevation ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return Elevation.level0;
        }
        if (states.contains(MaterialState.dragged)) {
          return Elevation.level3;
        }
        if (states.contains(MaterialState.pressed)) {
          return Elevation.level1;
        }
        if (states.contains(MaterialState.hovered)) {
          return Elevation.level2;
        }
        return Elevation.level1;
      });

  @override
  StateLayerColors get stateLayers =>
      _stateLayers ?? StateLayerColors.from(_colors.onSurface, _stateTheme);
}

class FilledCardThemeData extends CardThemeData {
  ///
  FilledCardThemeData(
    super.other,
    BuildContext context,
  )   : _context = context,
        super.clone();
  final BuildContext _context;

  late final ThemeData _theme = Theme.of(_context);
  late final ColorScheme _colors = _theme.colorScheme;
  late final StateThemeData _stateTheme = StateTheme.resolve(_context);

  @override
  MaterialStateProperty<Color> get color =>
      _color ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return _colors.surface.withOpacity(_stateTheme.disabledOpacity);
        }
        return _colors.surfaceContainerHighest;
      });

  @override
  Color get shadowColor => _shadowColor ?? _colors.shadow;

  @override
  MaterialStateProperty<Elevation> get elevation =>
      _elevation ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return Elevation.level0;
        }
        if (states.contains(MaterialState.dragged)) {
          return Elevation.level3;
        }
        if (states.contains(MaterialState.pressed)) {
          return Elevation.level0;
        }
        if (states.contains(MaterialState.hovered)) {
          return Elevation.level1;
        }
        return Elevation.level0;
      });

  @override
  StateLayerColors get stateLayers =>
      _stateLayers ?? StateLayerColors.from(_colors.onSurface, _stateTheme);
}

class OutlinedCardThemeData extends CardThemeData {
  ///
  OutlinedCardThemeData(
    super.other,
    BuildContext context,
  )   : _context = context,
        super.clone();
  final BuildContext _context;

  late final ThemeData _theme = Theme.of(_context);
  late final ColorScheme _colors = _theme.colorScheme;
  late final StateThemeData _stateTheme = StateTheme.resolve(_context);

  @override
  MaterialStateProperty<Color> get color =>
      _color ?? MaterialStateProperty.all(_colors.surface);

  @override
  Color get shadowColor => _shadowColor ?? _colors.shadow;

  @override
  MaterialStateProperty<Elevation> get elevation =>
      _elevation ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return Elevation.level0;
        }
        if (states.contains(MaterialState.dragged)) {
          return Elevation.level3;
        }
        if (states.contains(MaterialState.pressed)) {
          return Elevation.level0;
        }
        if (states.contains(MaterialState.hovered)) {
          return Elevation.level1;
        }
        return Elevation.level0;
      });

  @override
  MaterialStateProperty<BorderSide?> get outline =>
      _outline ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return BorderSide(
            color:
                _colors.outline.withOpacity(_stateTheme.disabledOpacityLight),
          );
        }
        return BorderSide(
          color: _colors.outline,
        );
      });

  @override
  StateLayerColors get stateLayers =>
      _stateLayers ?? StateLayerColors.from(_colors.onSurface, _stateTheme);
}

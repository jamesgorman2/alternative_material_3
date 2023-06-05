// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../color_scheme.dart';
import '../constants.dart';
import '../elevation.dart';
import '../ink_well.dart';
import '../material_state.dart';
import '../state_theme.dart';
import '../text_theme.dart';
import '../theme.dart';
import '../theme_data.dart';

/// Standard FAB sizes. Used to generate default theme values.
enum FloatingActionButtonType {
  /// A 56x56 FAB. The default FAB size.
  regular,

  /// A 40x40 FAB. A small FAB is used for a secondary, supporting
  /// action, or in place of a default FAB on smaller screens.
  ///
  /// Mini floating action buttons have a height
  /// and width of 40.0 logical pixels with a layout width and height of 48.0
  /// logical pixels. (The extra 4 pixels of padding on each side are added as a
  /// result of the floating action button having [MaterialTapTargetSize.padded]
  /// set on the underlying [RawMaterialButton.materialTapTargetSize].)
  small,

  /// A 96x96 FAB. A large FAB is useful when the layout calls for a
  /// clear and prominent primary action, and where a larger footprint
  /// would help the user engage. For example, when appearing on taller
  /// and larger device screens.
  large,

  /// A regular FAB with a text label.
  extended,
}

/// Standard FAB color themes. Used to generate default theme values.
enum FloatingActionButtonColorTheme {
  /// Colors based on primary container.
  primary,

  /// Colors based on secondary container.
  secondary,

  /// Colors based on tertiary container.
  tertiary,

  /// Colors based on surface and primary.
  surface,
}

/// The height model for the FAB.
enum FloatingActionButtonHeight {
  /// A level 3 FAB.
  regular,

  /// A level 1 FAB.
  lowered,

  /// A level 0 FAB.
  flat,
}

/// Defines default property values for descendant [FloatingActionButton]
/// widgets.
///
/// Descendant widgets obtain the current [FloatingActionButtonThemeData] object
/// using `Theme.of(context).floatingActionButtonTheme`. Instances of
/// [FloatingActionButtonThemeData] can be customized with
/// [FloatingActionButtonThemeData.copyWith].
///
/// Typically a [FloatingActionButtonThemeData] is specified as part of the
/// overall [Theme] with [ThemeData.floatingActionButtonTheme].
///
/// All [FloatingActionButtonThemeData] properties are `null` by default.
/// When null, the [FloatingActionButton] will use the values from [ThemeData]
/// if they exist, otherwise it will provide its own defaults.
///
/// See also:
///
///  * [ThemeData], which describes the overall theme information for the
///    application.
@immutable
class FloatingActionButtonThemeData with Diagnosticable {
  /// Creates a theme that can be used for
  /// [ThemeData.floatingActionButtonTheme].
  const FloatingActionButtonThemeData({
    Color? foregroundColor,
    Color? backgroundColor,
    Color? shadowColor,
    StateThemeData? stateTheme,
    StateLayerTheme? stateLayers,
    MaterialStateProperty<Elevation>? elevation,
    OutlinedBorder? shape,
    Clip? clipBehavior,
    bool? enableFeedback,
    double? iconSize,
    BoxConstraints? sizeConstraints,
    double? extendedIconPadding,
    double? extendedIconLabelSpacing,
    double? extendedLabelPadding,
    TextStyle? extendedTextStyle,
    MaterialStateProperty<MouseCursor>? mouseCursor,
    MaterialTapTargetSize? materialTapTargetSize,
    Duration? animationDuration,
    InteractiveInkFeatureFactory? splashFactory,
  })  : _foregroundColor = foregroundColor,
        _backgroundColor = backgroundColor,
  _shadowColor = shadowColor,
        _stateTheme = stateTheme,
        _stateLayers = stateLayers,
        _elevation = elevation,
        _shape = shape,
        _clipBehavior = clipBehavior,
        _enableFeedback = enableFeedback,
        _iconSize = iconSize,
        _sizeConstraints = sizeConstraints,
        _extendedIconPadding = extendedIconPadding,
        _extendedIconLabelSpacing = extendedIconLabelSpacing,
        _extendedLabelPadding = extendedLabelPadding,
        _extendedTextStyle = extendedTextStyle,
        _mouseCursor = mouseCursor,
        _materialTapTargetSize = materialTapTargetSize,
      _animationDuration = animationDuration,
        _splashFactory = splashFactory  ;

  FloatingActionButtonThemeData._clone(FloatingActionButtonThemeData other)
      : _foregroundColor = other._foregroundColor,
        _backgroundColor = other._backgroundColor,
        _shadowColor = other._shadowColor,
        _stateTheme = other._stateTheme,
        _stateLayers = other._stateLayers,
        _elevation = other._elevation,
        _shape = other._shape,
        _clipBehavior = other._clipBehavior,
        _enableFeedback = other._enableFeedback,
        _iconSize = other._iconSize,
        _sizeConstraints = other._sizeConstraints,
        _extendedIconPadding = other._extendedIconPadding,
        _extendedIconLabelSpacing = other._extendedIconLabelSpacing,
        _extendedLabelPadding = other._extendedLabelPadding,
        _extendedTextStyle = other._extendedTextStyle,
        _mouseCursor = other._mouseCursor,
        _materialTapTargetSize = other._materialTapTargetSize,
        _animationDuration = other._animationDuration,
        _splashFactory = other._splashFactory ;

  /// Copy this ElevatedButtonThemeData and set any default values that
  /// require a [BuildContext] set, such as colors and text themes.
  FloatingActionButtonThemeData withContext({
    required BuildContext context,
    required FloatingActionButtonType type,
    required FloatingActionButtonColorTheme colorTheme,
    required FloatingActionButtonHeight height,
  }) =>
      _LateResolvingFABButtonThemeData(
        this,
        context,
        type,
        colorTheme,
        height,
      );

  /// Return the [FloatingActionButtonThemeData] provided
  /// by the nearest [Theme].
  ///
  /// A current context theme can also be provided, used when the
  /// StateThemeData is passed as a parameter to a widget other than
  /// StateTheme.
  ///
  /// See also:
  ///
  /// * [BuildContext.dependOnInheritedWidgetOfExactType]
  static FloatingActionButtonThemeData resolve(
    BuildContext context, {
    required FloatingActionButtonType type,
    required FloatingActionButtonColorTheme colorTheme,
    required FloatingActionButtonHeight height,
    FloatingActionButtonThemeData? currentContextTheme,
  }) {
    final List<FloatingActionButtonThemeData> ancestorThemes = [
      Theme.of(context).floatingActionButtonTheme,
      if (currentContextTheme != null) currentContextTheme,
    ];
    if (ancestorThemes.length > 1) {
      return ancestorThemes.reduce((acc, e) => acc.mergeWith(e)).withContext(
            context: context,
            type: type,
            colorTheme: colorTheme,
            height: height,
          );
    }
    return ancestorThemes.first.withContext(
      context: context,
      type: type,
      colorTheme: colorTheme,
      height: height,
    );
  }

  /// The default foreground color for icons and text within the button.
  Color get foregroundColor => _foregroundColor!;
  final Color? _foregroundColor;

  /// The button's background color.
  Color get backgroundColor => _backgroundColor!;
  final Color? _backgroundColor;

  /// The shadow color of the button's [Material].
  Color get shadowColor => _shadowColor!;
  final Color? _shadowColor;

  /// Defines the state layer opacities applied to this button.
  ///
  /// Default value is [ThemeData.stateTheme] .
  StateThemeData get stateTheme => _stateTheme!;
  final StateThemeData? _stateTheme;

  /// Defines the state layers applied to this button.
  ///
  /// Default color values are [ColorScheme.onSurface] and the
  /// opacities are from [ListTileThemeData.stateThemeData].
  StateLayerTheme get stateLayers => _stateLayers!;
  final StateLayerTheme? _stateLayers;

  /// The z-coordinate at which to place this button relative to its parent.
  ///
  /// This controls the size of the shadow below the floating action button.
  ///
  /// Defaults to level 3.
  MaterialStateProperty<Elevation> get elevation => _elevation!;
  final MaterialStateProperty<Elevation>? _elevation;

  /// The shape of the button's [Material].
  ///
  /// The button's highlight and splash are clipped to this shape. If the
  /// button has an elevation, then its drop shadow is defined by this
  /// shape as well.
  OutlinedBorder get shape => _shape!;
  final OutlinedBorder? _shape;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.none].
  Clip get clipBehavior => _clipBehavior ?? Clip.none;
  final Clip? _clipBehavior;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  ///
  /// For example, on Android a tap will produce a clicking sound and a
  /// long-press will produce a short vibration, when feedback is enabled.
  ///
  /// If null, [FloatingActionButtonThemeData.enableFeedback] is used.
  /// If both are null, then default value is true.
  ///
  /// See also:
  ///
  ///  * [Feedback] for providing platform-specific feedback to certain actions.
  bool get enableFeedback => _enableFeedback ?? true;
  final bool? _enableFeedback;

  /// Overrides the default icon size for the [FloatingActionButton];
  double get iconSize => _iconSize!;
  final double? _iconSize;

  /// Overrides the default size constraints for the [FloatingActionButton].
  BoxConstraints get sizeConstraints => _sizeConstraints!;
  final BoxConstraints? _sizeConstraints;

  /// The start padding padding for an extended [FloatingActionButton]'s
  /// content.
  double get extendedIconPadding => _extendedIconPadding ?? 16.0;
  final double? _extendedIconPadding;

  /// The spacing between the icon and the label for an extended
  /// [FloatingActionButton].
  double get extendedIconLabelSpacing => _extendedIconLabelSpacing ?? 8.0;
  final double? _extendedIconLabelSpacing;

  /// The stat and end padding for an extended [FloatingActionButton]'s label.
  double get extendedLabelPadding => _extendedLabelPadding ?? 20.0;
  final double? _extendedLabelPadding;

  /// The text style for an extended [FloatingActionButton]'s label.
  TextStyle get extendedTextStyle => _extendedTextStyle!;
  final TextStyle? _extendedTextStyle;

  /// {@macro flutter.material.RawMaterialButton.mouseCursor}
  ///
  /// If this property is null, [MaterialStateMouseCursor.clickable] will be used.
  MaterialStateProperty<MouseCursor> get mouseCursor =>
      _mouseCursor ??
      const MaterialStatePropertyAll(MaterialStateMouseCursor.clickable);
  final MaterialStateProperty<MouseCursor>? _mouseCursor;

  /// Configures the minimum size of the tap target.
  ///
  /// Defaults to [ThemeData.materialTapTargetSize].
  ///
  /// See also:
  ///
  ///  * [MaterialTapTargetSize], for a description of how this affects tap targets.
  MaterialTapTargetSize get materialTapTargetSize => _materialTapTargetSize!;
  final MaterialTapTargetSize? _materialTapTargetSize;

  /// Defines the duration of animated changes for [shape] and [elevation].
  ///
  /// Typically the component default value is [kThemeChangeDuration].
  Duration get animationDuration => _animationDuration ?? kThemeChangeDuration;
  final Duration? _animationDuration;

  /// {@macro alternative_material_3.button_style.splashFactory}
  InteractiveInkFeatureFactory? get splashFactory => _splashFactory;
  final InteractiveInkFeatureFactory? _splashFactory;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  FloatingActionButtonThemeData copyWith({
    Color? foregroundColor,
    Color? backgroundColor,
    StateThemeData? stateTheme,
    StateLayerTheme? stateLayers,
    MaterialStateProperty<Elevation>? elevation,
    OutlinedBorder? shape,
    Clip? clipBehavior,
    bool? enableFeedback,
    double? iconSize,
    BoxConstraints? sizeConstraints,
    double? extendedIconPadding,
    double? extendedIconLabelSpacing,
    double? extendedLabelPadding,
    TextStyle? extendedTextStyle,
    MaterialStateProperty<MouseCursor>? mouseCursor,
    MaterialTapTargetSize? materialTapTargetSize,
  }) {
    return FloatingActionButtonThemeData(
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      stateTheme: stateTheme,
      stateLayers: stateLayers,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      enableFeedback: enableFeedback,
      iconSize: iconSize,
      sizeConstraints: sizeConstraints,
      extendedIconPadding: extendedIconPadding,
      extendedIconLabelSpacing: extendedIconLabelSpacing,
      extendedLabelPadding: extendedLabelPadding,
      extendedTextStyle: extendedTextStyle,
      mouseCursor: mouseCursor,
      materialTapTargetSize: materialTapTargetSize,
    );
  }

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  FloatingActionButtonThemeData mergeWith(
      FloatingActionButtonThemeData? other) {
    return FloatingActionButtonThemeData(
      foregroundColor: other?._foregroundColor ?? _foregroundColor,
      backgroundColor: other?._backgroundColor ?? _backgroundColor,
      stateTheme: other?._stateTheme ?? _stateTheme,
      stateLayers: other?._stateLayers ?? _stateLayers,
      elevation: other?._elevation ?? _elevation,
      shape: other?._shape ?? _shape,
      clipBehavior: other?._clipBehavior ?? _clipBehavior,
      enableFeedback: other?._enableFeedback ?? _enableFeedback,
      iconSize: other?._iconSize ?? _iconSize,
      sizeConstraints: other?._sizeConstraints ?? _sizeConstraints,
      extendedIconPadding: other?._extendedIconPadding ?? _extendedIconPadding,
      extendedIconLabelSpacing:
          other?._extendedIconLabelSpacing ?? _extendedIconLabelSpacing,
      extendedLabelPadding:
          other?._extendedLabelPadding ?? _extendedLabelPadding,
      extendedTextStyle: other?._extendedTextStyle ?? _extendedTextStyle,
      mouseCursor: other?._mouseCursor ?? _mouseCursor,
      materialTapTargetSize:
          other?._materialTapTargetSize ?? _materialTapTargetSize,
    );
  }

  /// Linearly interpolate between two floating action button themes.
  ///
  /// If both arguments are null then null is returned.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static FloatingActionButtonThemeData? lerp(FloatingActionButtonThemeData? a,
      FloatingActionButtonThemeData? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return FloatingActionButtonThemeData(
      foregroundColor: Color.lerp(a?._foregroundColor, b?._foregroundColor, t),
      backgroundColor: Color.lerp(a?._backgroundColor, b?._backgroundColor, t),
      stateTheme: StateThemeData.lerp(a?._stateTheme, b?._stateTheme, t),
      stateLayers: StateLayerTheme.lerp(a?._stateLayers, b?._stateLayers, t),
      elevation: MaterialStateProperty.lerpNonNull(
          a?._elevation, b?._elevation, t, Elevation.lerp),
      shape: OutlinedBorder.lerp(a?._shape, b?._shape, t),
      clipBehavior: t < 0.5 ? a?._clipBehavior : b?._clipBehavior,
      enableFeedback: t < 0.5 ? a?._enableFeedback : b?._enableFeedback,
      iconSize: lerpDouble(a?._iconSize, b?._iconSize, t),
      sizeConstraints:
          BoxConstraints.lerp(a?._sizeConstraints, b?._sizeConstraints, t),
      extendedIconPadding:
          lerpDouble(a?._extendedIconPadding, b?._extendedIconPadding, t),
      extendedIconLabelSpacing: lerpDouble(
          a?._extendedIconLabelSpacing, b?._extendedIconLabelSpacing, t),
      extendedLabelPadding:
          lerpDouble(a?._extendedLabelPadding, b?._extendedLabelPadding, t),
      extendedTextStyle:
          TextStyle.lerp(a?._extendedTextStyle, b?._extendedTextStyle, t),
      mouseCursor: t < 0.5 ? a?._mouseCursor : b?._mouseCursor,
      materialTapTargetSize:
          t < 0.5 ? a?._materialTapTargetSize : b?._materialTapTargetSize,
    );
  }

  @override
  int get hashCode => Object.hash(
        _foregroundColor,
        _backgroundColor,
        _shadowColor,
        _stateTheme,
        _stateLayers,
        _elevation,
        _shape,
        _clipBehavior,
        _enableFeedback,
        _iconSize,
        _sizeConstraints,
        _extendedIconPadding,
        _extendedIconLabelSpacing,
        _extendedLabelPadding,
        _extendedTextStyle,
        _mouseCursor,
        _materialTapTargetSize,
    _animationDuration,
    _splashFactory,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is FloatingActionButtonThemeData &&
        other._foregroundColor == _foregroundColor &&
        other._backgroundColor == _backgroundColor &&
        other._shadowColor == _shadowColor &&
        other._stateTheme == _stateTheme &&
        other._stateLayers == _stateLayers &&
        other._elevation == _elevation &&
        other._shape == _shape &&
        other._clipBehavior == _clipBehavior &&
        other._enableFeedback == _enableFeedback &&
        other._iconSize == _iconSize &&
        other._sizeConstraints == _sizeConstraints &&
        other._extendedIconPadding == _extendedIconPadding &&
        other._extendedIconLabelSpacing == _extendedIconLabelSpacing &&
        other._extendedLabelPadding == _extendedLabelPadding &&
        other._extendedTextStyle == _extendedTextStyle &&
        other._mouseCursor == _mouseCursor &&
        other._materialTapTargetSize == _materialTapTargetSize &&
    other._animationDuration == _animationDuration &&
    other._splashFactory == _splashFactory;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(
        ColorProperty('foregroundColor', _foregroundColor, defaultValue: null));
    properties.add(
        ColorProperty('backgroundColor', _backgroundColor, defaultValue: null));
    properties.add(
        ColorProperty('shadowColor', _shadowColor, defaultValue: null));
    properties.add(DiagnosticsProperty<StateThemeData>(
        'stateTheme', _stateTheme,
        defaultValue: null));
    properties.add(DiagnosticsProperty<StateLayerTheme>(
        'stateLayers', _stateLayers,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Elevation>>(
        'elevation', _elevation,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty<OutlinedBorder>('shape', _shape, defaultValue: null));
    properties.add(DiagnosticsProperty<Clip>('clipBehavior', _clipBehavior,
        defaultValue: null));
    properties.add(DiagnosticsProperty<bool>('enableFeedback', _enableFeedback,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty<double>('iconSize', _iconSize, defaultValue: null));
    properties.add(DiagnosticsProperty<BoxConstraints>(
        'sizeConstraints', _sizeConstraints,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>(
        'extendedIconPadding', _extendedIconPadding,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>(
        'extendedIconLabelSpacing', _extendedIconLabelSpacing,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>(
        'extendedLabelPadding', _extendedLabelPadding,
        defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle>(
        'extendedTextStyle', _extendedTextStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<MouseCursor>>(
        'mouseCursor', _mouseCursor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialTapTargetSize>(
        'materialTapTargetSize', _materialTapTargetSize,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Duration>(
        'animationDuration', _animationDuration,
        defaultValue: null));
    properties.add(DiagnosticsProperty<InteractiveInkFeatureFactory>(
        'splashFactory', _splashFactory,
        defaultValue: null));
  }
}

class _LateResolvingFABButtonThemeData extends FloatingActionButtonThemeData {
  _LateResolvingFABButtonThemeData(
    super.other,
    this.context,
    this.type,
    this.colorTheme,
    this.height,
  ) : super._clone();

  final BuildContext context;
  final FloatingActionButtonType type;
  final FloatingActionButtonColorTheme colorTheme;
  final FloatingActionButtonHeight height;

  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;
  late final TextTheme _textTheme = _theme.textTheme;

  Color _containerForColorTheme() {
    switch (colorTheme) {
      case FloatingActionButtonColorTheme.primary:
        return _colors.primaryContainer;
      case FloatingActionButtonColorTheme.secondary:
        return _colors.secondaryContainer;
      case FloatingActionButtonColorTheme.tertiary:
        return _colors.tertiaryContainer;
      case FloatingActionButtonColorTheme.surface:
        {
          if (height == FloatingActionButtonHeight.regular) {
            return _colors.surfaceContainerHigh;
          }
          return _colors.surfaceContainerLow;
        }
    }
  }

  Color _onContainerForColorTheme() {
    switch (colorTheme) {
      case FloatingActionButtonColorTheme.primary:
        return _colors.onPrimaryContainer;
      case FloatingActionButtonColorTheme.secondary:
        return _colors.onSecondaryContainer;
      case FloatingActionButtonColorTheme.tertiary:
        return _colors.onTertiaryContainer;
      case FloatingActionButtonColorTheme.surface:
        return _colors.primary;
    }
  }

  late final Color _containerColor = _containerForColorTheme();
  late final Color _onContainerColor = _onContainerForColorTheme();

  @override
  StateThemeData get stateTheme => _stateTheme ?? _theme.stateTheme;

  @override
  Color get foregroundColor => _foregroundColor ?? _onContainerColor;

  @override
  Color get backgroundColor => _backgroundColor ?? _containerColor;

  @override
  Color get shadowColor => _shadowColor ?? _colors.shadow;

  @override
  StateLayerTheme get stateLayers =>
      _stateLayers ??
      StateLayerTheme(
        pressColor: StateLayer(_onContainerColor, stateTheme.pressOpacity),
        hoverColor: StateLayer(_onContainerColor, stateTheme.hoverOpacity),
        focusColor: StateLayer(_onContainerColor, stateTheme.focusOpacity),
      );

  @override
  MaterialStateProperty<Elevation> get elevation =>
      _elevation ??
      MaterialStateProperty.resolveWith((states) {
        if (height == FloatingActionButtonHeight.flat) {
          return Elevation.level0;
        }
        if (height == FloatingActionButtonHeight.lowered) {
          if (states.contains(MaterialState.hovered)) {
            return Elevation.level2;
          }
          return Elevation.level1;
        }
        if (states.contains(MaterialState.hovered)) {
          return Elevation.level4;
        }
        return Elevation.level3;
      });

  @override
  double get iconSize {
    if (_iconSize != null) {
      return _iconSize!;
    }
    switch (type) {
      case FloatingActionButtonType.regular:
        return 24.0;
      case FloatingActionButtonType.small:
        return 24.0;
      case FloatingActionButtonType.large:
        return 36.0;
      case FloatingActionButtonType.extended:
        return 24.0;
    }
  }

  @override
  TextStyle get extendedTextStyle =>
      _extendedTextStyle ?? _textTheme.labelLarge;

  @override
  OutlinedBorder get shape {
    if (_shape != null) {
      return _shape!;
    }
    switch (type) {
      case FloatingActionButtonType.regular:
        return const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)));
      case FloatingActionButtonType.small:
        return const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)));
      case FloatingActionButtonType.large:
        return const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(28.0)));
      case FloatingActionButtonType.extended:
        return const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)));
    }
  }

  @override
  BoxConstraints get sizeConstraints {
    if (_sizeConstraints != null) {
      return _sizeConstraints!;
    }
    switch (type) {
      case FloatingActionButtonType.regular:
        return const BoxConstraints.tightFor(
          width: 56.0,
          height: 56.0,
        );
      case FloatingActionButtonType.small:
        return const BoxConstraints.tightFor(
          width: 40.0,
          height: 40.0,
        );
      case FloatingActionButtonType.large:
        return const BoxConstraints.tightFor(
          width: 96.0,
          height: 96.0,
        );
      case FloatingActionButtonType.extended:
        return const BoxConstraints(
          minWidth: 80.0,
          minHeight: 56.0,
          maxHeight: 56.0,
        );
    }
  }

  @override
  MaterialTapTargetSize get materialTapTargetSize =>
      _materialTapTargetSize ?? _theme.materialTapTargetSize;
}

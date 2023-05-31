// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

import 'color_scheme.dart';
import 'constants.dart';
import 'debug.dart';
import 'material_state.dart';
import 'shadows.dart';
import 'state_theme.dart';
import 'switch_theme.dart';
import 'theme.dart';
import 'theme_data.dart';
import 'toggleable.dart';

// Examples can assume:
// bool _giveVerse = true;
// late StateSetter setState;

const double _kSwitchMinSize = kMinInteractiveDimension - 8.0;

enum _SwitchType { material, adaptive }

/// A Material Design switch.
///
/// Used to toggle the on/off state of a single setting.
///
/// The switch itself does not maintain any state. Instead, when the state of
/// the switch changes, the widget calls the [onChanged] callback. Most widgets
/// that use a switch will listen for the [onChanged] callback and rebuild the
/// switch with a new [value] to update the visual appearance of the switch.
///
/// If the [onChanged] callback is null, then the switch will be disabled (it
/// will not respond to input). A disabled switch's thumb and track are rendered
/// in shades of grey by default. The default appearance of a disabled switch
/// can be overridden with [inactiveThumbColor] and [inactiveTrackColor].
///
/// Requires one of its ancestors to be a [Material] widget.
///
/// Material Design 3 provides the option to add icons on the thumb of the [Switch].
/// If [ThemeData.useMaterial3] is set to true, users can use [Switch.thumbIcon]
/// to add optional Icons based on the different [MaterialState]s of the [Switch].
///
/// {@tool dartpad}
/// This example shows a toggleable [Switch]. When the thumb slides to the other
/// side of the track, the switch is toggled between on/off.
///
/// ** See code in examples/api/lib/material/switch/switch.0.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This example shows how to customize [Switch] using [MaterialStateProperty]
/// switch properties.
///
/// ** See code in examples/api/lib/material/switch/switch.1.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This example shows how to add icons on the thumb of the [Switch] using the
/// [Switch.thumbIcon] property.
///
/// ** See code in examples/api/lib/material/switch/switch.2.dart **
/// {@end-tool}
///
/// See also:
///
///  * [SwitchListTile], which combines this widget with a [ListTile] so that
///    you can give the switch a label.
///  * [Checkbox], another widget with similar semantics.
///  * [Radio], for selecting among a set of explicit values.
///  * [Slider], for selecting a value in a range.
///  * [MaterialStateProperty], an interface for objects that "resolve" to
///    different values depending on a widget's material state.
///  * <https://material.io/design/components/selection-controls.html#switches>
class Switch extends StatelessWidget {
  /// Creates a Material Design switch.
  ///
  /// The switch itself does not maintain any state. Instead, when the state of
  /// the switch changes, the widget calls the [onChanged] callback. Most widgets
  /// that use a switch will listen for the [onChanged] callback and rebuild the
  /// switch with a new [value] to update the visual appearance of the switch.
  ///
  /// The following arguments are required:
  ///
  /// * [value] determines whether this switch is on or off.
  /// * [onChanged] is called when the user toggles the switch on or off.
  const Switch({
    super.key,
    required this.value,
    required this.onChanged,
    this.theme,
    this.dragStartBehavior = DragStartBehavior.start,
    this.focusNode,
    this.onFocusChange,
    this.autofocus = false,
  })  : _switchType = _SwitchType.material,
        applyCupertinoTheme = false;

  /// Return a switch without the default checked icon when selected.
  ///
  /// This will override any [StateThemeData.thumbIcon] values.
  factory Switch.plain({
    Key? key,
    required bool value,
    ValueChanged<bool>? onChanged,
    SwitchThemeData? theme,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    FocusNode? focusNode,
    ValueChanged<bool>? onFocusChange,
    bool autofocus = false,
  }) {
    final MaterialStateProperty<Icon?> thumbIcon =
        MaterialStateProperty.all<Icon?>(null);
    return Switch(
      value: value,
      onChanged: onChanged,
      theme: theme?.copyWith(thumbIcon: thumbIcon) ??
          SwitchThemeData(thumbIcon: thumbIcon),
      dragStartBehavior: dragStartBehavior,
      focusNode: focusNode,
      onFocusChange: onFocusChange,
      autofocus: autofocus,
    );
  }

  /// Creates an adaptive [Switch] based on whether the target platform is iOS
  /// or macOS, following Material design's
  /// [Cross-platform guidelines](https://material.io/design/platform-guidance/cross-platform-adaptation.html).
  ///
  /// On iOS and macOS, this constructor creates a [CupertinoSwitch], which has
  /// matching functionality and presentation as Material switches, and are the
  /// graphics expected on iOS. On other platforms, this creates a Material
  /// design [Switch].
  ///
  /// If a [CupertinoSwitch] is created, the following parameters are ignored:
  /// [activeTrackColor], [inactiveThumbColor], [inactiveTrackColor],
  /// [activeThumbImage], [onActiveThumbImageError], [inactiveThumbImage],
  /// [onInactiveThumbImageError], [materialTapTargetSize].
  ///
  /// The target platform is based on the current [Theme]: [ThemeData.platform].
  const Switch.adaptive({
    super.key,
    required this.value,
    required this.onChanged,
    this.theme,
    this.dragStartBehavior = DragStartBehavior.start,
    this.focusNode,
    this.onFocusChange,
    this.autofocus = false,
    this.applyCupertinoTheme,
  }) : _switchType = _SwitchType.adaptive;

  /// Whether this switch is on or off.
  ///
  /// This property must not be null.
  final bool value;

  /// Called when the user toggles the switch on or off.
  ///
  /// The switch passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the switch with the new
  /// value.
  ///
  /// If null, the switch will be displayed as disabled.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// Switch(
  ///   value: _giveVerse,
  ///   onChanged: (bool newValue) {
  ///     setState(() {
  ///       _giveVerse = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<bool>? onChanged;

  /// SwitchTheme overrides that only apply to this switch.
  final SwitchThemeData? theme;

  final _SwitchType _switchType;

  /// {@macro flutter.cupertino.CupertinoSwitch.applyTheme}
  final bool? applyCupertinoTheme;

  /// {@macro flutter.cupertino.CupertinoSwitch.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.material.inkwell.onFocusChange}
  final ValueChanged<bool>? onFocusChange;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  Size _getSwitchSize(BuildContext context) {
    final SwitchThemeData switchTheme = SwitchTheme.resolve(context);
    final _SwitchConfig switchConfig = _SwitchConfigM3(context);

    final MaterialTapTargetSize effectiveMaterialTapTargetSize =
        switchTheme.materialTapTargetSize;
    switch (effectiveMaterialTapTargetSize) {
      case MaterialTapTargetSize.padded:
        return Size(switchConfig.switchWidth, switchConfig.switchHeight);
      case MaterialTapTargetSize.shrinkWrap:
        return Size(
            switchConfig.switchWidth, switchConfig.switchHeightCollapsed);
    }
  }

  Widget _buildCupertinoSwitch(BuildContext context) {
    final SwitchThemeData switchTheme = SwitchTheme.resolve(context, theme);
    final Size size = _getSwitchSize(context);
    return Focus(
      focusNode: focusNode,
      onFocusChange: onFocusChange,
      autofocus: autofocus,
      child: Container(
        width: size.width, // Same size as the Material switch.
        height: size.height,
        alignment: Alignment.center,
        child: CupertinoSwitch(
          dragStartBehavior: dragStartBehavior,
          value: value,
          onChanged: onChanged,
          // FIXME
          activeColor: switchTheme.thumbColor.resolve({MaterialState.selected}),
          trackColor: switchTheme.trackColor.resolve({}),
          applyTheme: applyCupertinoTheme,
        ),
      ),
    );
  }

  Widget _buildMaterialSwitch(BuildContext context) {
    return _MaterialSwitch(
      value: value,
      onChanged: onChanged,
      theme: theme,
      size: _getSwitchSize(context),
      dragStartBehavior: dragStartBehavior,
      focusNode: focusNode,
      onFocusChange: onFocusChange,
      autofocus: autofocus,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_switchType) {
      case _SwitchType.material:
        return _buildMaterialSwitch(context);

      case _SwitchType.adaptive:
        {
          final ThemeData theme = Theme.of(context);
          switch (theme.platform) {
            case TargetPlatform.android:
            case TargetPlatform.fuchsia:
            case TargetPlatform.linux:
            case TargetPlatform.windows:
              return _buildMaterialSwitch(context);
            case TargetPlatform.iOS:
            case TargetPlatform.macOS:
              return _buildCupertinoSwitch(context);
          }
        }
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('value',
        value: value, ifTrue: 'on', ifFalse: 'off', showName: true));
    properties.add(ObjectFlagProperty<ValueChanged<bool>>(
        'onChanged', onChanged,
        ifNull: 'disabled'));
  }
}

class _MaterialSwitch extends StatefulWidget {
  const _MaterialSwitch({
    required this.value,
    required this.onChanged,
    this.theme,
    required this.size,
    this.dragStartBehavior = DragStartBehavior.start,
    this.focusNode,
    this.onFocusChange,
    this.autofocus = false,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final SwitchThemeData? theme;
  final DragStartBehavior dragStartBehavior;
  final FocusNode? focusNode;
  final Function(bool)? onFocusChange;
  final bool autofocus;
  final Size size;

  @override
  State<StatefulWidget> createState() => _MaterialSwitchState();
}

class _MaterialSwitchState extends State<_MaterialSwitch>
    with TickerProviderStateMixin, ToggleableStateMixin {
  final _SwitchPainter _painter = _SwitchPainter();

  @override
  void didUpdateWidget(_MaterialSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      // During a drag we may have modified the curve, reset it if its possible
      // to do without visual discontinuation.
      if (position.value == 0.0 || position.value == 1.0) {
        position
          ..curve = Curves.easeOutBack
          ..reverseCurve = Curves.easeOutBack.flipped;
      }
      animateToValue();
    }
  }

  @override
  void dispose() {
    _painter.dispose();
    super.dispose();
  }

  @override
  ValueChanged<bool?>? get onChanged =>
      widget.onChanged != null ? _handleChanged : null;

  @override
  bool get tristate => false;

  @override
  bool? get value => widget.value;

  double get _trackInnerLength => widget.size.width - _kSwitchMinSize;

  void _handleDragStart(DragStartDetails details) {
    if (isInteractive) {
      reactionController.forward();
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (isInteractive) {
      position
        ..curve = Curves.linear
        ..reverseCurve = null;
      final double delta = details.primaryDelta! / _trackInnerLength;
      switch (Directionality.of(context)) {
        case TextDirection.rtl:
          positionController.value -= delta;
        case TextDirection.ltr:
          positionController.value += delta;
      }
    }
  }

  bool _needsPositionAnimation = false;

  void _handleDragEnd(DragEndDetails details) {
    if (position.value >= 0.5 != widget.value) {
      widget.onChanged?.call(!widget.value);
      // Wait with finishing the animation until widget.value has changed to
      // !widget.value as part of the widget.onChanged call above.
      setState(() {
        _needsPositionAnimation = true;
      });
    } else {
      animateToValue();
    }
    reactionController.reverse();
  }

  void _handleChanged(bool? value) {
    assert(value != null);
    assert(widget.onChanged != null);
    widget.onChanged?.call(value!);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));

    if (_needsPositionAnimation) {
      _needsPositionAnimation = false;
      animateToValue();
    }

    final ThemeData theme = Theme.of(context);
    final SwitchThemeData switchTheme =
        SwitchTheme.resolve(context, widget.theme);
    final _SwitchConfig switchConfig = _SwitchConfigM3(context);

    positionController.duration =
        Duration(milliseconds: switchConfig.toggleDuration);

    // Colors need to be resolved in selected and non selected states separately
    // so that they can be lerped between.
    final Set<MaterialState> activeStates = states..add(MaterialState.selected);
    final Set<MaterialState> inactiveStates = states
      ..remove(MaterialState.selected);

    final Color effectiveActiveThumbColor =
        switchTheme.thumbColor.resolve(activeStates);
    final Color effectiveInactiveThumbColor =
        switchTheme.thumbColor.resolve(inactiveStates);
    final Color effectiveActiveTrackColor =
        switchTheme.trackColor.resolve(activeStates);
    final Color effectiveActiveTrackOutlineColor =
        switchTheme.trackOutlineColor.resolve(activeStates);

    final Color effectiveInactiveTrackColor =
        switchTheme.trackColor.resolve(inactiveStates);
    final Color effectiveInactiveTrackOutlineColor =
        switchTheme.trackOutlineColor.resolve(inactiveStates);

    final Icon? effectiveActiveIcon =
        switchTheme.thumbIcon.resolve(activeStates);
    final Icon? effectiveInactiveIcon =
        switchTheme.thumbIcon.resolve(inactiveStates);

    final Color effectiveActiveIconColor = effectiveActiveIcon?.color ??
        switchConfig.iconColor.resolve(activeStates);
    final Color effectiveInactiveIconColor = effectiveInactiveIcon?.color ??
        switchConfig.iconColor.resolve(inactiveStates);

    final Set<MaterialState> focusedStates = states..add(MaterialState.focused);
    final Color effectiveFocusOverlayColor =
        switchTheme.stateLayerColor.resolve(focusedStates);

    final Set<MaterialState> hoveredStates = states..add(MaterialState.hovered);
    final Color effectiveHoverOverlayColor =
        switchTheme.stateLayerColor.resolve(hoveredStates);

    final Set<MaterialState> activePressedStates = activeStates
      ..add(MaterialState.pressed);
    final Color effectiveActivePressedThumbColor =
        switchTheme.thumbColor.resolve(activePressedStates);
    final Color effectiveActivePressedOverlayColor =
        switchTheme.stateLayerColor.resolve(activePressedStates);

    final Set<MaterialState> inactivePressedStates = inactiveStates
      ..add(MaterialState.pressed);
    final Color effectiveInactivePressedThumbColor =
        switchTheme.thumbColor.resolve(inactivePressedStates);
    final Color effectiveInactivePressedOverlayColor =
        switchTheme.stateLayerColor.resolve(inactivePressedStates);

    final double effectiveActiveThumbRadius = effectiveActiveIcon == null
        ? switchConfig.activeThumbRadius
        : switchConfig.thumbRadiusWithIcon;
    final double effectiveInactiveThumbRadius = effectiveInactiveIcon == null
        ? switchConfig.inactiveThumbRadius
        : switchConfig.thumbRadiusWithIcon;

    return Semantics(
      toggled: widget.value,
      child: GestureDetector(
        excludeFromSemantics: true,
        onHorizontalDragStart: _handleDragStart,
        onHorizontalDragUpdate: _handleDragUpdate,
        onHorizontalDragEnd: _handleDragEnd,
        dragStartBehavior: widget.dragStartBehavior,
        child: buildToggleable(
          mouseCursor: switchTheme.mouseCursor,
          focusNode: widget.focusNode,
          onFocusChange: widget.onFocusChange,
          autofocus: widget.autofocus,
          size: widget.size,
          painter: _painter
            ..position = position
            ..reaction = reaction
            ..reactionFocusFade = reactionFocusFade
            ..reactionHoverFade = reactionHoverFade
            ..inactiveReactionColor = effectiveInactivePressedOverlayColor
            ..reactionColor = effectiveActivePressedOverlayColor
            ..hoverColor = effectiveHoverOverlayColor
            ..focusColor = effectiveFocusOverlayColor
            ..splashRadius = switchTheme.splashRadius
            ..downPosition = downPosition
            ..isFocused = states.contains(MaterialState.focused)
            ..isHovered = states.contains(MaterialState.hovered)
            ..activeColor = effectiveActiveThumbColor
            ..inactiveColor = effectiveInactiveThumbColor
            ..activePressedColor = effectiveActivePressedThumbColor
            ..inactivePressedColor = effectiveInactivePressedThumbColor
            ..activeTrackColor = effectiveActiveTrackColor
            ..activeTrackOutlineColor = effectiveActiveTrackOutlineColor
            ..inactiveTrackColor = effectiveInactiveTrackColor
            ..inactiveTrackOutlineColor = effectiveInactiveTrackOutlineColor
            ..configuration = createLocalImageConfiguration(context)
            ..isInteractive = isInteractive
            ..trackInnerLength = _trackInnerLength
            ..textDirection = Directionality.of(context)
            ..surfaceColor = theme.colorScheme.surface
            ..inactiveThumbRadius = effectiveInactiveThumbRadius
            ..activeThumbRadius = effectiveActiveThumbRadius
            ..pressedThumbRadius = switchConfig.pressedThumbRadius
            ..thumbOffset = switchConfig.thumbOffset
            ..trackHeight = switchConfig.trackHeight
            ..trackWidth = switchConfig.trackWidth
            ..activeIconColor = effectiveActiveIconColor
            ..inactiveIconColor = effectiveInactiveIconColor
            ..activeIcon = effectiveActiveIcon
            ..inactiveIcon = effectiveInactiveIcon
            ..iconTheme = IconTheme.of(context)
            ..thumbShadow = switchConfig.thumbShadow
            ..transitionalThumbSize = switchConfig.transitionalThumbSize
            ..positionController = positionController,
        ),
      ),
    );
  }
}

class _SwitchPainter extends ToggleablePainter {
  AnimationController get positionController => _positionController!;
  AnimationController? _positionController;

  set positionController(AnimationController? value) {
    assert(value != null);
    if (value == _positionController) {
      return;
    }
    _positionController = value;
    notifyListeners();
  }

  Icon? get activeIcon => _activeIcon;
  Icon? _activeIcon;

  set activeIcon(Icon? value) {
    if (value == _activeIcon) {
      return;
    }
    _activeIcon = value;
    notifyListeners();
  }

  Icon? get inactiveIcon => _inactiveIcon;
  Icon? _inactiveIcon;

  set inactiveIcon(Icon? value) {
    if (value == _inactiveIcon) {
      return;
    }
    _inactiveIcon = value;
    notifyListeners();
  }

  IconThemeData? get iconTheme => _iconTheme;
  IconThemeData? _iconTheme;

  set iconTheme(IconThemeData? value) {
    if (value == _iconTheme) {
      return;
    }
    _iconTheme = value;
    notifyListeners();
  }

  Color get activeIconColor => _activeIconColor!;
  Color? _activeIconColor;

  set activeIconColor(Color value) {
    if (value == _activeIconColor) {
      return;
    }
    _activeIconColor = value;
    notifyListeners();
  }

  Color get inactiveIconColor => _inactiveIconColor!;
  Color? _inactiveIconColor;

  set inactiveIconColor(Color value) {
    if (value == _inactiveIconColor) {
      return;
    }
    _inactiveIconColor = value;
    notifyListeners();
  }

  Color get activePressedColor => _activePressedColor!;
  Color? _activePressedColor;

  set activePressedColor(Color? value) {
    assert(value != null);
    if (value == _activePressedColor) {
      return;
    }
    _activePressedColor = value;
    notifyListeners();
  }

  Color get inactivePressedColor => _inactivePressedColor!;
  Color? _inactivePressedColor;

  set inactivePressedColor(Color? value) {
    assert(value != null);
    if (value == _inactivePressedColor) {
      return;
    }
    _inactivePressedColor = value;
    notifyListeners();
  }

  double get activeThumbRadius => _activeThumbRadius!;
  double? _activeThumbRadius;

  set activeThumbRadius(double value) {
    if (value == _activeThumbRadius) {
      return;
    }
    _activeThumbRadius = value;
    notifyListeners();
  }

  double get inactiveThumbRadius => _inactiveThumbRadius!;
  double? _inactiveThumbRadius;

  set inactiveThumbRadius(double value) {
    if (value == _inactiveThumbRadius) {
      return;
    }
    _inactiveThumbRadius = value;
    notifyListeners();
  }

  double get pressedThumbRadius => _pressedThumbRadius!;
  double? _pressedThumbRadius;

  set pressedThumbRadius(double value) {
    if (value == _pressedThumbRadius) {
      return;
    }
    _pressedThumbRadius = value;
    notifyListeners();
  }

  double? get thumbOffset => _thumbOffset;
  double? _thumbOffset;

  set thumbOffset(double? value) {
    if (value == _thumbOffset) {
      return;
    }
    _thumbOffset = value;
    notifyListeners();
  }

  Size get transitionalThumbSize => _transitionalThumbSize!;
  Size? _transitionalThumbSize;

  set transitionalThumbSize(Size value) {
    if (value == _transitionalThumbSize) {
      return;
    }
    _transitionalThumbSize = value;
    notifyListeners();
  }

  double get trackHeight => _trackHeight!;
  double? _trackHeight;

  set trackHeight(double value) {
    if (value == _trackHeight) {
      return;
    }
    _trackHeight = value;
    notifyListeners();
  }

  double get trackWidth => _trackWidth!;
  double? _trackWidth;

  set trackWidth(double value) {
    if (value == _trackWidth) {
      return;
    }
    _trackWidth = value;
    notifyListeners();
  }

  ImageProvider? get activeThumbImage => _activeThumbImage;
  ImageProvider? _activeThumbImage;

  set activeThumbImage(ImageProvider? value) {
    if (value == _activeThumbImage) {
      return;
    }
    _activeThumbImage = value;
    notifyListeners();
  }

  ImageErrorListener? get onActiveThumbImageError => _onActiveThumbImageError;
  ImageErrorListener? _onActiveThumbImageError;

  set onActiveThumbImageError(ImageErrorListener? value) {
    if (value == _onActiveThumbImageError) {
      return;
    }
    _onActiveThumbImageError = value;
    notifyListeners();
  }

  ImageProvider? get inactiveThumbImage => _inactiveThumbImage;
  ImageProvider? _inactiveThumbImage;

  set inactiveThumbImage(ImageProvider? value) {
    if (value == _inactiveThumbImage) {
      return;
    }
    _inactiveThumbImage = value;
    notifyListeners();
  }

  ImageErrorListener? get onInactiveThumbImageError =>
      _onInactiveThumbImageError;
  ImageErrorListener? _onInactiveThumbImageError;

  set onInactiveThumbImageError(ImageErrorListener? value) {
    if (value == _onInactiveThumbImageError) {
      return;
    }
    _onInactiveThumbImageError = value;
    notifyListeners();
  }

  Color get activeTrackColor => _activeTrackColor!;
  Color? _activeTrackColor;

  set activeTrackColor(Color value) {
    if (value == _activeTrackColor) {
      return;
    }
    _activeTrackColor = value;
    notifyListeners();
  }

  Color? get activeTrackOutlineColor => _activeTrackOutlineColor;
  Color? _activeTrackOutlineColor;

  set activeTrackOutlineColor(Color? value) {
    if (value == _activeTrackOutlineColor) {
      return;
    }
    _activeTrackOutlineColor = value;
    notifyListeners();
  }

  Color? get inactiveTrackOutlineColor => _inactiveTrackOutlineColor;
  Color? _inactiveTrackOutlineColor;

  set inactiveTrackOutlineColor(Color? value) {
    if (value == _inactiveTrackOutlineColor) {
      return;
    }
    _inactiveTrackOutlineColor = value;
    notifyListeners();
  }

  Color get inactiveTrackColor => _inactiveTrackColor!;
  Color? _inactiveTrackColor;

  set inactiveTrackColor(Color value) {
    if (value == _inactiveTrackColor) {
      return;
    }
    _inactiveTrackColor = value;
    notifyListeners();
  }

  ImageConfiguration get configuration => _configuration!;
  ImageConfiguration? _configuration;

  set configuration(ImageConfiguration value) {
    if (value == _configuration) {
      return;
    }
    _configuration = value;
    notifyListeners();
  }

  TextDirection get textDirection => _textDirection!;
  TextDirection? _textDirection;

  set textDirection(TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    notifyListeners();
  }

  Color get surfaceColor => _surfaceColor!;
  Color? _surfaceColor;

  set surfaceColor(Color value) {
    if (value == _surfaceColor) {
      return;
    }
    _surfaceColor = value;
    notifyListeners();
  }

  bool get isInteractive => _isInteractive!;
  bool? _isInteractive;

  set isInteractive(bool value) {
    if (value == _isInteractive) {
      return;
    }
    _isInteractive = value;
    notifyListeners();
  }

  double get trackInnerLength => _trackInnerLength!;
  double? _trackInnerLength;

  set trackInnerLength(double value) {
    if (value == _trackInnerLength) {
      return;
    }
    _trackInnerLength = value;
    notifyListeners();
  }

  List<BoxShadow>? get thumbShadow => _thumbShadow;
  List<BoxShadow>? _thumbShadow;

  set thumbShadow(List<BoxShadow>? value) {
    if (value == _thumbShadow) {
      return;
    }
    _thumbShadow = value;
    notifyListeners();
  }

  Color? _cachedThumbColor;
  ImageProvider? _cachedThumbImage;
  ImageErrorListener? _cachedThumbErrorListener;
  BoxPainter? _cachedThumbPainter;

  ShapeDecoration _createDefaultThumbDecoration(
      Color color, ImageProvider? image, ImageErrorListener? errorListener) {
    return ShapeDecoration(
      color: color,
      image: image == null
          ? null
          : DecorationImage(image: image, onError: errorListener),
      shape: const StadiumBorder(),
      shadows: thumbShadow,
    );
  }

  bool _isPainting = false;

  void _handleDecorationChanged() {
    // If the image decoration is available synchronously, we'll get called here
    // during paint. There's no reason to mark ourselves as needing paint if we
    // are already in the middle of painting. (In fact, doing so would trigger
    // an assert).
    if (!_isPainting) {
      notifyListeners();
    }
  }

  bool _stopPressAnimation = false;
  double? _pressedInactiveThumbRadius;
  double? _pressedActiveThumbRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final double currentValue = position.value;

    final double visualPosition;
    switch (textDirection) {
      case TextDirection.rtl:
        visualPosition = 1.0 - currentValue;
      case TextDirection.ltr:
        visualPosition = currentValue;
    }
    if (reaction.status == AnimationStatus.reverse && !_stopPressAnimation) {
      _stopPressAnimation = true;
    } else {
      _stopPressAnimation = false;
    }

    // To get the thumb radius when the press ends, the value can be any number
    // between activeThumbRadius/inactiveThumbRadius and pressedThumbRadius.
    if (!_stopPressAnimation) {
      if (reaction.isCompleted) {
        // This happens when the thumb is dragged instead of being tapped.
        _pressedInactiveThumbRadius =
            lerpDouble(inactiveThumbRadius, pressedThumbRadius, reaction.value);
        _pressedActiveThumbRadius =
            lerpDouble(activeThumbRadius, pressedThumbRadius, reaction.value);
      }
      if (currentValue == 0) {
        _pressedInactiveThumbRadius =
            lerpDouble(inactiveThumbRadius, pressedThumbRadius, reaction.value);
        _pressedActiveThumbRadius = activeThumbRadius;
      }
      if (currentValue == 1) {
        _pressedActiveThumbRadius =
            lerpDouble(activeThumbRadius, pressedThumbRadius, reaction.value);
        _pressedInactiveThumbRadius = inactiveThumbRadius;
      }
    }

    final Size inactiveThumbSize =
        Size.fromRadius(_pressedInactiveThumbRadius ?? inactiveThumbRadius);
    final Size activeThumbSize =
        Size.fromRadius(_pressedActiveThumbRadius ?? activeThumbRadius);
    Animation<Size> thumbSizeAnimation(bool isForward) {
      List<TweenSequenceItem<Size>> thumbSizeSequence;
      if (isForward) {
        thumbSizeSequence = <TweenSequenceItem<Size>>[
          TweenSequenceItem<Size>(
            tween: Tween<Size>(
                    begin: inactiveThumbSize, end: transitionalThumbSize)
                .chain(CurveTween(curve: const Cubic(0.31, 0.00, 0.56, 1.00))),
            weight: 11,
          ),
          TweenSequenceItem<Size>(
            tween: Tween<Size>(
                    begin: transitionalThumbSize, end: activeThumbSize)
                .chain(CurveTween(curve: const Cubic(0.20, 0.00, 0.00, 1.00))),
            weight: 72,
          ),
          TweenSequenceItem<Size>(
            tween: ConstantTween<Size>(activeThumbSize),
            weight: 17,
          )
        ];
      } else {
        thumbSizeSequence = <TweenSequenceItem<Size>>[
          TweenSequenceItem<Size>(
            tween: ConstantTween<Size>(inactiveThumbSize),
            weight: 17,
          ),
          TweenSequenceItem<Size>(
            tween: Tween<Size>(
                    begin: inactiveThumbSize, end: transitionalThumbSize)
                .chain(CurveTween(
                    curve: const Cubic(0.20, 0.00, 0.00, 1.00).flipped)),
            weight: 72,
          ),
          TweenSequenceItem<Size>(
            tween:
                Tween<Size>(begin: transitionalThumbSize, end: activeThumbSize)
                    .chain(CurveTween(
                        curve: const Cubic(0.31, 0.00, 0.56, 1.00).flipped)),
            weight: 11,
          ),
        ];
      }

      return TweenSequence<Size>(thumbSizeSequence).animate(positionController);
    }

    Size thumbSize;
    if (reaction.isCompleted) {
      thumbSize = Size.fromRadius(pressedThumbRadius);
    } else {
      if (position.isDismissed || position.status == AnimationStatus.forward) {
        thumbSize = thumbSizeAnimation(true).value;
      } else {
        thumbSize = thumbSizeAnimation(false).value;
      }
    }

    // The thumb contracts slightly during the animation in Material 2.
    final double inset = thumbOffset == null
        ? 0
        : 1.0 - (currentValue - thumbOffset!).abs() * 2.0;
    thumbSize = Size(thumbSize.width - inset, thumbSize.height - inset);

    final double colorValue = CurvedAnimation(
            parent: positionController,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn)
        .value;
    final Color trackColor =
        Color.lerp(inactiveTrackColor, activeTrackColor, colorValue)!;
    final Color? trackOutlineColor = inactiveTrackOutlineColor == null
        ? null
        : Color.lerp(
            inactiveTrackOutlineColor, activeTrackOutlineColor, colorValue);
    Color lerpedThumbColor;
    if (!reaction.isDismissed) {
      lerpedThumbColor =
          Color.lerp(inactivePressedColor, activePressedColor, colorValue)!;
    } else if (positionController.status == AnimationStatus.forward) {
      lerpedThumbColor =
          Color.lerp(inactivePressedColor, activeColor, colorValue)!;
    } else if (positionController.status == AnimationStatus.reverse) {
      lerpedThumbColor =
          Color.lerp(inactiveColor, activePressedColor, colorValue)!;
    } else {
      lerpedThumbColor = Color.lerp(inactiveColor, activeColor, colorValue)!;
    }

    // Blend the thumb color against a `surfaceColor` background in case the
    // thumbColor is not opaque. This way we do not see through the thumb to the
    // track underneath.
    final Color thumbColor = Color.alphaBlend(lerpedThumbColor, surfaceColor);

    final Icon? thumbIcon = currentValue < 0.5 ? inactiveIcon : activeIcon;

    final ImageProvider? thumbImage =
        currentValue < 0.5 ? inactiveThumbImage : activeThumbImage;

    final ImageErrorListener? thumbErrorListener = currentValue < 0.5
        ? onInactiveThumbImageError
        : onActiveThumbImageError;

    final Paint paint = Paint()..color = trackColor;

    final Offset trackPaintOffset =
        _computeTrackPaintOffset(size, trackWidth, trackHeight);
    final Offset thumbPaintOffset =
        _computeThumbPaintOffset(trackPaintOffset, thumbSize, visualPosition);
    final Offset radialReactionOrigin =
        Offset(thumbPaintOffset.dx + thumbSize.height / 2, size.height / 2);

    _paintTrackWith(canvas, paint, trackPaintOffset, trackOutlineColor);
    paintRadialReaction(canvas: canvas, origin: radialReactionOrigin);
    _paintThumbWith(
      thumbPaintOffset,
      canvas,
      colorValue,
      thumbColor,
      thumbImage,
      thumbErrorListener,
      thumbIcon,
      thumbSize,
      inset,
    );
  }

  /// Computes canvas offset for track's upper left corner
  Offset _computeTrackPaintOffset(
      Size canvasSize, double trackWidth, double trackHeight) {
    final double horizontalOffset = (canvasSize.width - trackWidth) / 2.0;
    final double verticalOffset = (canvasSize.height - trackHeight) / 2.0;

    return Offset(horizontalOffset, verticalOffset);
  }

  /// Computes canvas offset for thumb's upper left corner as if it were a
  /// square
  Offset _computeThumbPaintOffset(
      Offset trackPaintOffset, Size thumbSize, double visualPosition) {
    // How much thumb radius extends beyond the track
    final double trackRadius = trackHeight / 2;
    final double additionalThumbRadius = thumbSize.height / 2 - trackRadius;
    final double additionalRectWidth = (thumbSize.width - thumbSize.height) / 2;

    final double horizontalProgress = visualPosition * trackInnerLength;
    final double thumbHorizontalOffset = trackPaintOffset.dx -
        additionalThumbRadius -
        additionalRectWidth +
        horizontalProgress;
    final double thumbVerticalOffset =
        trackPaintOffset.dy - additionalThumbRadius;

    return Offset(thumbHorizontalOffset, thumbVerticalOffset);
  }

  void _paintTrackWith(Canvas canvas, Paint paint, Offset trackPaintOffset,
      Color? trackOutlineColor) {
    final Rect trackRect = Rect.fromLTWH(
      trackPaintOffset.dx,
      trackPaintOffset.dy,
      trackWidth,
      trackHeight,
    );
    final double trackRadius = trackHeight / 2;
    final RRect trackRRect = RRect.fromRectAndRadius(
      trackRect,
      Radius.circular(trackRadius),
    );

    canvas.drawRRect(trackRRect, paint);

    if (trackOutlineColor != null) {
      // paint track outline
      final Rect outlineTrackRect = Rect.fromLTWH(
        trackPaintOffset.dx + 1,
        trackPaintOffset.dy + 1,
        trackWidth - 2,
        trackHeight - 2,
      );
      final RRect outlineTrackRRect = RRect.fromRectAndRadius(
        outlineTrackRect,
        Radius.circular(trackRadius),
      );
      final Paint outlinePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = trackOutlineColor;
      canvas.drawRRect(outlineTrackRRect, outlinePaint);
    }
  }

  void _paintThumbWith(
    Offset thumbPaintOffset,
    Canvas canvas,
    double currentValue,
    Color thumbColor,
    ImageProvider? thumbImage,
    ImageErrorListener? thumbErrorListener,
    Icon? thumbIcon,
    Size thumbSize,
    double inset,
  ) {
    try {
      _isPainting = true;
      if (_cachedThumbPainter == null ||
          thumbColor != _cachedThumbColor ||
          thumbImage != _cachedThumbImage ||
          thumbErrorListener != _cachedThumbErrorListener) {
        _cachedThumbColor = thumbColor;
        _cachedThumbImage = thumbImage;
        _cachedThumbErrorListener = thumbErrorListener;
        _cachedThumbPainter?.dispose();
        _cachedThumbPainter = _createDefaultThumbDecoration(
                thumbColor, thumbImage, thumbErrorListener)
            .createBoxPainter(_handleDecorationChanged);
      }
      final BoxPainter thumbPainter = _cachedThumbPainter!;

      thumbPainter.paint(
        canvas,
        thumbPaintOffset,
        configuration.copyWith(size: thumbSize),
      );

      if (thumbIcon != null && thumbIcon.icon != null) {
        final Color iconColor =
            Color.lerp(inactiveIconColor, activeIconColor, currentValue)!;
        final double iconSize = thumbIcon.size ?? _SwitchConfigM3.iconSize;
        final IconData iconData = thumbIcon.icon!;
        final double? iconWeight = thumbIcon.weight ?? iconTheme?.weight;
        final double? iconFill = thumbIcon.fill ?? iconTheme?.fill;
        final double? iconGrade = thumbIcon.grade ?? iconTheme?.grade;
        final double? iconOpticalSize =
            thumbIcon.opticalSize ?? iconTheme?.opticalSize;
        final List<Shadow>? iconShadows =
            thumbIcon.shadows ?? iconTheme?.shadows;

        final TextSpan textSpan = TextSpan(
          text: String.fromCharCode(iconData.codePoint),
          style: TextStyle(
            fontVariations: <FontVariation>[
              if (iconFill != null) FontVariation('FILL', iconFill),
              if (iconWeight != null) FontVariation('wght', iconWeight),
              if (iconGrade != null) FontVariation('GRAD', iconGrade),
              if (iconOpticalSize != null)
                FontVariation('opsz', iconOpticalSize),
            ],
            color: iconColor,
            fontSize: iconSize,
            inherit: false,
            fontFamily: iconData.fontFamily,
            package: iconData.fontPackage,
            shadows: iconShadows,
          ),
        );
        final TextPainter textPainter = TextPainter(
          textDirection: textDirection,
          text: textSpan,
        );
        textPainter.layout();
        final double additionalHorizontalOffset =
            (thumbSize.width - iconSize) / 2;
        final double additionalVerticalOffset =
            (thumbSize.height - iconSize) / 2;
        final Offset offset = thumbPaintOffset +
            Offset(additionalHorizontalOffset, additionalVerticalOffset);

        textPainter.paint(canvas, offset);
      }
    } finally {
      _isPainting = false;
    }
  }

  @override
  void dispose() {
    _cachedThumbPainter?.dispose();
    _cachedThumbPainter = null;
    _cachedThumbColor = null;
    _cachedThumbImage = null;
    _cachedThumbErrorListener = null;
    super.dispose();
  }
}

mixin _SwitchConfig {
  double get trackHeight;

  double get trackWidth;

  double get switchWidth;

  double get switchHeight;

  double get switchHeightCollapsed;

  double get activeThumbRadius;

  double get inactiveThumbRadius;

  double get pressedThumbRadius;

  double get thumbRadiusWithIcon;

  List<BoxShadow>? get thumbShadow;

  MaterialStateProperty<Color> get iconColor;

  double? get thumbOffset;

  Size get transitionalThumbSize;

  int get toggleDuration;
}

class _SwitchConfigM3 with _SwitchConfig {
  _SwitchConfigM3(this.context);

  final BuildContext context;

  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;
  late final StateThemeData stateTheme = _theme.stateTheme;

  static const double iconSize = 16.0;

  @override
  double get activeThumbRadius => 24.0 / 2;

  @override
  MaterialStateProperty<Color> get iconColor {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        if (states.contains(MaterialState.selected)) {
          return _colors.onSurfaceVariant.withOpacity(stateTheme.disabledOpacity);
        }
        return _colors.surfaceContainerHighest
            .withOpacity(stateTheme.disabledOpacity);
      }
      if (states.contains(MaterialState.selected)) {
        if (states.contains(MaterialState.pressed)) {
          return _colors.onPrimaryContainer;
        }
        if (states.contains(MaterialState.hovered)) {
          return _colors.onPrimaryContainer;
        }
        if (states.contains(MaterialState.focused)) {
          return _colors.onPrimaryContainer;
        }
        return _colors.onPrimaryContainer;
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
  double get inactiveThumbRadius => 16.0 / 2;

  @override
  double get pressedThumbRadius => 28.0 / 2;

  @override
  double get switchHeight => _kSwitchMinSize + 8.0;

  @override
  double get switchHeightCollapsed => _kSwitchMinSize;

  @override
  double get switchWidth =>
      trackWidth - 2 * (trackHeight / 2.0) + _kSwitchMinSize;

  @override
  double get thumbRadiusWithIcon => 24.0 / 2;

  @override
  List<BoxShadow>? get thumbShadow => kElevationToShadow[0];

  @override
  double get trackHeight => 32.0;

  @override
  double get trackWidth => 52.0;

  // The thumb size at the middle of the track. Hand coded default based on the animation specs.
  @override
  Size get transitionalThumbSize => const Size(34, 22);

  // Hand coded default based on the animation specs.
  @override
  int get toggleDuration => 300;

  // Hand coded default based on the animation specs.
  @override
  double? get thumbOffset => null;
}

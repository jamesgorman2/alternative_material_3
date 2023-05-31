// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';

import 'checkbox_theme.dart';
import 'constants.dart';
import 'debug.dart';
import 'material_state.dart';
import 'theme.dart';
import 'theme_data.dart';
import 'toggleable.dart';

// Examples can assume:
// bool _throwShotAway = false;
// late StateSetter setState;

enum _CheckboxType { material, adaptive }

/// A Material Design checkbox.
///
/// The checkbox itself does not maintain any state. Instead, when the state of
/// the checkbox changes, the widget calls the [onChanged] callback. Most
/// widgets that use a checkbox will listen for the [onChanged] callback and
/// rebuild the checkbox with a new [value] to update the visual appearance of
/// the checkbox.
///
/// The checkbox can optionally display three values - true, false, and null -
/// if [tristate] is true. When [value] is null a dash is displayed. By default
/// [tristate] is false and the checkbox's [value] must be true or false.
///
/// Requires one of its ancestors to be a [Material] widget.
///
/// {@tool dartpad}
/// This example shows how you can override the default theme of
/// a [Checkbox] with a [MaterialStateProperty].
/// In this example, the checkbox's color will be `Colors.blue` when the [Checkbox]
/// is being pressed, hovered, or focused. Otherwise, the checkbox's color will
/// be `Colors.red`.
///
/// ** See code in examples/api/lib/material/checkbox/checkbox.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [CheckboxListTile], which combines this widget with a [ListTile] so that
///    you can give the checkbox a label.
///  * [Switch], a widget with semantics similar to [Checkbox].
///  * [Radio], for selecting among a set of explicit values.
///  * [Slider], for selecting a value in a range.
///  * <https://material.io/design/components/selection-controls.html#checkboxes>
///  * <https://material.io/design/components/lists.html#types>
class Checkbox extends StatefulWidget {
  /// Creates a Material Design checkbox.
  ///
  /// The checkbox itself does not maintain any state. Instead, when the state of
  /// the checkbox changes, the widget calls the [onChanged] callback. Most
  /// widgets that use a checkbox will listen for the [onChanged] callback and
  /// rebuild the checkbox with a new [value] to update the visual appearance of
  /// the checkbox.
  ///
  /// The following arguments are required:
  ///
  /// * [value], which determines whether the checkbox is checked. The [value]
  ///   can only be null if [tristate] is true.
  /// * [onChanged], which is called when the value of the checkbox should
  ///   change. It can be set to null to disable the checkbox.
  ///
  /// The values of [tristate] and [autofocus] must not be null.
  const Checkbox({
    super.key,
    this.theme,
    required this.value,
    this.tristate = false,
    required this.onChanged,
    this.focusNode,
    this.autofocus = false,
    this.isError = false,
  }) : _checkboxType = _CheckboxType.material,
       assert(tristate || value != null);

  /// Creates an adaptive [Checkbox] based on whether the target platform is iOS
  /// or macOS, following Material design's
  /// [Cross-platform guidelines](https://material.io/design/platform-guidance/cross-platform-adaptation.html).
  ///
  /// On iOS and macOS, this constructor creates a [CupertinoCheckbox], which has
  /// matching functionality and presentation as Material checkboxes, and are the
  /// graphics expected on iOS. On other platforms, this creates a Material
  /// design [Checkbox].
  ///
  /// If a [CupertinoCheckbox] is created, the following parameters are ignored:
  /// [mouseCursor], [hoverColor], [stateLayerColor], [splashRadius],
  /// [materialTapTargetSize], [visualDensity], [isError]. However, [shape] and
  /// [side] will still affect the [CupertinoCheckbox] and should be handled if
  /// native fidelity is important.
  ///
  /// The target platform is based on the current [Theme]: [ThemeData.platform].
  const Checkbox.adaptive({
    super.key,
    this.theme,
    required this.value,
    this.tristate = false,
    required this.onChanged,
    this.focusNode,
    this.autofocus = false,
    this.isError = false,
  }) : _checkboxType = _CheckboxType.adaptive,
       assert(tristate || value != null);

  /// CheckboxTheme overrides that only apply to this checkbox.
  final CheckboxThemeData? theme;

  /// Whether this checkbox is checked.
  ///
  /// When [tristate] is true, a value of null corresponds to the mixed state.
  /// When [tristate] is false, this value must not be null.
  final bool? value;

  /// Called when the value of the checkbox should change.
  ///
  /// The checkbox passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the checkbox with the new
  /// value.
  ///
  /// If this callback is null, the checkbox will be displayed as disabled
  /// and will not respond to input gestures.
  ///
  /// When the checkbox is tapped, if [tristate] is false (the default) then
  /// the [onChanged] callback will be applied to `!value`. If [tristate] is
  /// true this callback cycle from false to true to null.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// Checkbox(
  ///   value: _throwShotAway,
  ///   onChanged: (bool? newValue) {
  ///     setState(() {
  ///       _throwShotAway = newValue!;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<bool?>? onChanged;

  /// If true the checkbox's [value] can be true, false, or null.
  ///
  /// [Checkbox] displays a dash when its value is null.
  ///
  /// When a tri-state checkbox ([tristate] is true) is tapped, its [onChanged]
  /// callback will be applied to true if the current value is false, to null if
  /// value is true, and to false if value is null (i.e. it cycles through false
  /// => true => null => false when tapped).
  ///
  /// If tristate is false (the default), [value] must not be null.
  final bool tristate;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// {@template flutter.material.checkbox.isError}
  /// True if this checkbox wants to show an error state.
  ///
  /// The checkbox will have different default container color and check color when
  /// this is true. This is only used when [ThemeData.useMaterial3] is set to true.
  /// {@endtemplate}
  ///
  /// Must not be null. Defaults to false.
  final bool isError;

  /// The width of a checkbox widget.
  static const double width = 18.0;

  final _CheckboxType _checkboxType;

  @override
  State<Checkbox> createState() => _CheckboxState();
}

class _CheckboxState extends State<Checkbox> with TickerProviderStateMixin, ToggleableStateMixin {
  final _CheckboxPainter _painter = _CheckboxPainter();
  bool? _previousValue;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
  }

  @override
  void didUpdateWidget(Checkbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
      animateToValue();
    }
  }

  @override
  void dispose() {
    _painter.dispose();
    super.dispose();
  }

  @override
  ValueChanged<bool?>? get onChanged => widget.onChanged;

  @override
  bool get tristate => widget.tristate;

  @override
  bool? get value => widget.value;

  @override
  Widget build(BuildContext context) {
    final CheckboxThemeData checkboxTheme = CheckboxTheme.resolve(context, widget.theme);
    switch (widget._checkboxType) {
      case _CheckboxType.material:
        break;

      case _CheckboxType.adaptive:
        final ThemeData theme = Theme.of(context);
        switch (theme.platform) {
          case TargetPlatform.android:
          case TargetPlatform.fuchsia:
          case TargetPlatform.linux:
          case TargetPlatform.windows:
            break;
          case TargetPlatform.iOS:
          case TargetPlatform.macOS:
            return CupertinoCheckbox(
              value: value,
              tristate: tristate,
              onChanged: onChanged,
              //FIXME
              activeColor: checkboxTheme.iconColor.resolve({MaterialState.selected}),
              checkColor: checkboxTheme.iconColor.resolve({}),
              focusColor: checkboxTheme.containerColor.resolve({}),
              focusNode: widget.focusNode,
              autofocus: widget.autofocus,
              side: checkboxTheme.side,
              shape: checkboxTheme.shape,
            );
        }
    }

    assert(debugCheckHasMaterial(context));
    Size size;
    switch (checkboxTheme.materialTapTargetSize) {
      case MaterialTapTargetSize.padded:
        size = const Size(kMinInteractiveDimension, kMinInteractiveDimension);
      case MaterialTapTargetSize.shrinkWrap:
        size = const Size(kMinInteractiveDimension - 8.0, kMinInteractiveDimension - 8.0);
    }
    size += checkboxTheme.visualDensity.baseSizeAdjustment;

    // Colors need to be resolved in selected and non selected states separately
    // so that they can be lerped between.
    final Set<MaterialState> errorState = states..add(MaterialState.error);
    final Set<MaterialState> activeStates = widget.isError ? (errorState..add(MaterialState.selected)) : states..add(MaterialState.selected);
    final Set<MaterialState> inactiveStates = widget.isError ? (errorState..remove(MaterialState.selected)) : states..remove(MaterialState.selected);

    final Color activeColor = checkboxTheme.containerColor.resolve(activeStates);
    final Color inactiveColor = checkboxTheme.containerColor.resolve(inactiveStates);

    final Set<MaterialState> focusedStates = widget.isError ? (errorState..add(MaterialState.focused)) : states..add(MaterialState.focused);
    Color focusOverlayColor =
      checkboxTheme.stateLayerColor.resolve(focusedStates);

    final Set<MaterialState> hoveredStates = widget.isError ? (errorState..add(MaterialState.hovered)) : states..add(MaterialState.hovered);
    Color hverOverlayColor =
      checkboxTheme.stateLayerColor.resolve(hoveredStates);

    final Set<MaterialState> activePressedStates = activeStates..add(MaterialState.pressed);
    final Color activePressedOverlayColor =
      checkboxTheme.stateLayerColor.resolve(activePressedStates);

    final Set<MaterialState> inactivePressedStates = inactiveStates..add(MaterialState.pressed);
    final Color inactivePressedOverlayColor = checkboxTheme.stateLayerColor.resolve(inactivePressedStates);

    if (downPosition != null) {
      hverOverlayColor = states.contains(MaterialState.selected)
        ? activePressedOverlayColor
        : inactivePressedOverlayColor;
      focusOverlayColor = states.contains(MaterialState.selected)
        ? activePressedOverlayColor
        : inactivePressedOverlayColor;
    }

    final Set<MaterialState> checkStates = widget.isError ? (states..add(MaterialState.error)) : states;

    return Semantics(
      checked: widget.value ?? false,
      mixed: widget.tristate ? widget.value == null : null,
      child: buildToggleable(
        mouseCursor: checkboxTheme.mouseCursor,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        size: size,
        painter: _painter
          ..position = position
          ..reaction = reaction
          ..reactionFocusFade = reactionFocusFade
          ..reactionHoverFade = reactionHoverFade
          ..inactiveReactionColor = inactivePressedOverlayColor
          ..reactionColor = activePressedOverlayColor
          ..hoverColor = hverOverlayColor
          ..focusColor = focusOverlayColor
          ..splashRadius = checkboxTheme.splashRadius
          ..downPosition = downPosition
          ..isFocused = states.contains(MaterialState.focused)
          ..isHovered = states.contains(MaterialState.hovered)
          ..activeColor = activeColor
          ..inactiveColor = inactiveColor
          ..checkColor = checkboxTheme.iconColor.resolve(checkStates)
          ..value = value
          ..previousValue = _previousValue
          ..shape = checkboxTheme.shape
          ..side = checkboxTheme.side.resolve(states),
      ),
    );
  }
}

const double _kEdgeSize = Checkbox.width;
const double _kStrokeWidth = 2.0;

class _CheckboxPainter extends ToggleablePainter {
  Color get checkColor => _checkColor!;
  Color? _checkColor;
  set checkColor(Color value) {
    if (_checkColor == value) {
      return;
    }
    _checkColor = value;
    notifyListeners();
  }

  bool? get value => _value;
  bool? _value;
  set value(bool? value) {
    if (_value == value) {
      return;
    }
    _value = value;
    notifyListeners();
  }

  bool? get previousValue => _previousValue;
  bool? _previousValue;
  set previousValue(bool? value) {
    if (_previousValue == value) {
      return;
    }
    _previousValue = value;
    notifyListeners();
  }

  OutlinedBorder get shape => _shape!;
  OutlinedBorder? _shape;
  set shape(OutlinedBorder value) {
    if (_shape == value) {
      return;
    }
    _shape = value;
    notifyListeners();
  }

  BorderSide? get side => _side;
  BorderSide? _side;
  set side(BorderSide? value) {
    if (_side == value) {
      return;
    }
    _side = value;
    notifyListeners();
  }

  // The square outer bounds of the checkbox at t, with the specified origin.
  // At t == 0.0, the outer rect's size is _kEdgeSize (Checkbox.width)
  // At t == 0.5, .. is _kEdgeSize - _kStrokeWidth
  // At t == 1.0, .. is _kEdgeSize
  Rect _outerRectAt(Offset origin, double t) {
    final double inset = 1.0 - (t - 0.5).abs() * 2.0;
    final double size = _kEdgeSize - inset * _kStrokeWidth;
    final Rect rect = Rect.fromLTWH(origin.dx + inset, origin.dy + inset, size, size);
    return rect;
  }

  // The checkbox's border color if value == false, or its fill color when
  // value == true or null.
  Color _colorAt(double t) {
    // As t goes from 0.0 to 0.25, animate from the inactiveColor to activeColor.
    return t >= 0.25 ? activeColor : Color.lerp(inactiveColor, activeColor, t * 4.0)!;
  }

  // White stroke used to paint the check and dash.
  Paint _createStrokePaint() {
    return Paint()
      ..color = checkColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _kStrokeWidth;
  }

  void _drawBox(Canvas canvas, Rect outer, Paint paint, BorderSide? side, bool fill) {
    if (fill) {
      canvas.drawPath(shape.getOuterPath(outer), paint);
    }
    if (side != null) {
      shape.copyWith(side: side).paint(canvas, outer);
    }
  }

  void _drawCheck(Canvas canvas, Offset origin, double t, Paint paint) {
    assert(t >= 0.0 && t <= 1.0);
    // As t goes from 0.0 to 1.0, animate the two check mark strokes from the
    // short side to the long side.
    final Path path = Path();
    const Offset start = Offset(_kEdgeSize * 0.15, _kEdgeSize * 0.45);
    const Offset mid = Offset(_kEdgeSize * 0.4, _kEdgeSize * 0.7);
    const Offset end = Offset(_kEdgeSize * 0.85, _kEdgeSize * 0.25);
    if (t < 0.5) {
      final double strokeT = t * 2.0;
      final Offset drawMid = Offset.lerp(start, mid, strokeT)!;
      path.moveTo(origin.dx + start.dx, origin.dy + start.dy);
      path.lineTo(origin.dx + drawMid.dx, origin.dy + drawMid.dy);
    } else {
      final double strokeT = (t - 0.5) * 2.0;
      final Offset drawEnd = Offset.lerp(mid, end, strokeT)!;
      path.moveTo(origin.dx + start.dx, origin.dy + start.dy);
      path.lineTo(origin.dx + mid.dx, origin.dy + mid.dy);
      path.lineTo(origin.dx + drawEnd.dx, origin.dy + drawEnd.dy);
    }
    canvas.drawPath(path, paint);
  }

  void _drawDash(Canvas canvas, Offset origin, double t, Paint paint) {
    assert(t >= 0.0 && t <= 1.0);
    // As t goes from 0.0 to 1.0, animate the horizontal line from the
    // mid point outwards.
    const Offset start = Offset(_kEdgeSize * 0.2, _kEdgeSize * 0.5);
    const Offset mid = Offset(_kEdgeSize * 0.5, _kEdgeSize * 0.5);
    const Offset end = Offset(_kEdgeSize * 0.8, _kEdgeSize * 0.5);
    final Offset drawStart = Offset.lerp(start, mid, 1.0 - t)!;
    final Offset drawEnd = Offset.lerp(mid, end, t)!;
    canvas.drawLine(origin + drawStart, origin + drawEnd, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintRadialReaction(canvas: canvas, origin: size.center(Offset.zero));

    final Paint strokePaint = _createStrokePaint();
    final Offset origin = size / 2.0 - const Size.square(_kEdgeSize) / 2.0 as Offset;
    final AnimationStatus status = position.status;
    final double tNormalized = status == AnimationStatus.forward || status == AnimationStatus.completed
      ? position.value
      : 1.0 - position.value;

    // Four cases: false to null, false to true, null to false, true to false
    if (previousValue == false || value == false) {
      final double t = value == false ? 1.0 - tNormalized : tNormalized;
      final Rect outer = _outerRectAt(origin, t);
      final Paint paint = Paint()..color = _colorAt(t);

      if (t <= 0.5) {
        final BorderSide border = side ?? BorderSide(width: 2, color: paint.color);
        _drawBox(canvas, outer, paint, border, false); // only paint the border
      } else {
        _drawBox(canvas, outer, paint, side, true);
        final double tShrink = (t - 0.5) * 2.0;
        if (previousValue == null || value == null) {
          _drawDash(canvas, origin, tShrink, strokePaint);
        } else {
          _drawCheck(canvas, origin, tShrink, strokePaint);
        }
      }
    } else { // Two cases: null to true, true to null
      final Rect outer = _outerRectAt(origin, 1.0);
      final Paint paint = Paint() ..color = _colorAt(1.0);

      _drawBox(canvas, outer, paint, side, true);
      if (tNormalized <= 0.5) {
        final double tShrink = 1.0 - tNormalized * 2.0;
        if (previousValue ?? false) {
          _drawCheck(canvas, origin, tShrink, strokePaint);
        } else {
          _drawDash(canvas, origin, tShrink, strokePaint);
        }
      } else {
        final double tExpand = (tNormalized - 0.5) * 2.0;
        if (value ?? false) {
          _drawCheck(canvas, origin, tExpand, strokePaint);
        } else {
          _drawDash(canvas, origin, tExpand, strokePaint);
        }
      }
    }
  }
}

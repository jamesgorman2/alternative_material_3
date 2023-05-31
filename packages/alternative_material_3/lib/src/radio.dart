// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';

import 'constants.dart';
import 'debug.dart';
import 'material_state.dart';
import 'radio_theme.dart';
import 'theme.dart';
import 'theme_data.dart';
import 'toggleable.dart';

enum _RadioType { material, adaptive }

const double _kOuterRadius = 8.0;
const double _kInnerRadius = 4.5;

/// A Material Design radio button.
///
/// Used to select between a number of mutually exclusive values. When one radio
/// button in a group is selected, the other radio buttons in the group cease to
/// be selected. The values are of type `T`, the type parameter of the [Radio]
/// class. Enums are commonly used for this purpose.
///
/// The radio button itself does not maintain any state. Instead, selecting the
/// radio invokes the [onChanged] callback, passing [value] as a parameter. If
/// [groupValue] and [value] match, this radio will be selected. Most widgets
/// will respond to [onChanged] by calling [State.setState] to update the
/// radio button's [groupValue].
///
/// {@tool dartpad}
/// Here is an example of Radio widgets wrapped in ListTiles, which is similar
/// to what you could get with the RadioListTile widget.
///
/// The currently selected character is passed into `groupValue`, which is
/// maintained by the example's `State`. In this case, the first [Radio]
/// will start off selected because `_character` is initialized to
/// `SingingCharacter.lafayette`.
///
/// If the second radio button is pressed, the example's state is updated
/// with `setState`, updating `_character` to `SingingCharacter.jefferson`.
/// This causes the buttons to rebuild with the updated `groupValue`, and
/// therefore the selection of the second button.
///
/// Requires one of its ancestors to be a [Material] widget.
///
/// ** See code in examples/api/lib/material/radio/radio.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [RadioListTile], which combines this widget with a [ListTile] so that
///    you can give the radio button a label.
///  * [Slider], for selecting a value in a range.
///  * [Checkbox] and [Switch], for toggling a particular value on or off.
///  * <https://material.io/design/components/selection-controls.html#radio-buttons>
class Radio<T> extends StatefulWidget {
  /// Creates a Material Design radio button.
  ///
  /// The radio button itself does not maintain any state. Instead, when the
  /// radio button is selected, the widget calls the [onChanged] callback. Most
  /// widgets that use a radio button will listen for the [onChanged] callback
  /// and rebuild the radio button with a new [groupValue] to update the visual
  /// appearance of the radio button.
  ///
  /// The following arguments are required:
  ///
  /// * [value] and [groupValue] together determine whether the radio button is
  ///   selected.
  /// * [onChanged] is called when the user selects this radio button.
  const Radio({
    super.key,
    this.theme,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.toggleable = false,
    this.focusNode,
    this.autofocus = false,
  }) : _radioType = _RadioType.material;

  /// Creates an adaptive [Radio] based on whether the target platform is iOS
  /// or macOS, following Material design's
  /// [Cross-platform guidelines](https://material.io/design/platform-guidance/cross-platform-adaptation.html).
  ///
  /// On iOS and macOS, this constructor creates a [CupertinoRadio], which has
  /// matching functionality and presentation as Material checkboxes, and are the
  /// graphics expected on iOS. On other platforms, this creates a Material
  /// design [Radio].
  ///
  /// If a [CupertinoRadio] is created, the following parameters are ignored:
  /// [mouseCursor], [fillColor], [hoverColor], [stateLayerColor], [splashRadius],
  /// [materialTapTargetSize], [visualDensity].
  ///
  /// The target platform is based on the current [Theme]: [ThemeData.platform].
  const Radio.adaptive({
    super.key,
    this.theme,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.toggleable = false,
    this.focusNode,
    this.autofocus = false,
  }) : _radioType = _RadioType.adaptive;

  /// RadioTheme overrides that only apply to this checkbox.
  final RadioThemeData? theme;

  /// The value represented by this radio button.
  final T value;

  /// The currently selected value for a group of radio buttons.
  ///
  /// This radio button is considered selected if its [value] matches the
  /// [groupValue].
  final T? groupValue;

  /// Called when the user selects this radio button.
  ///
  /// The radio button passes [value] as a parameter to this callback. The radio
  /// button does not actually change state until the parent widget rebuilds the
  /// radio button with the new [groupValue].
  ///
  /// If null, the radio button will be displayed as disabled.
  ///
  /// The provided callback will not be invoked if this radio button is already
  /// selected.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// Radio<SingingCharacter>(
  ///   value: SingingCharacter.lafayette,
  ///   groupValue: _character,
  ///   onChanged: (SingingCharacter? newValue) {
  ///     setState(() {
  ///       _character = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<T?>? onChanged;

  /// Set to true if this radio button is allowed to be returned to an
  /// indeterminate state by selecting it again when selected.
  ///
  /// To indicate returning to an indeterminate state, [onChanged] will be
  /// called with null.
  ///
  /// If true, [onChanged] can be called with [value] when selected while
  /// [groupValue] != [value], or with null when selected again while
  /// [groupValue] == [value].
  ///
  /// If false, [onChanged] will be called with [value] when it is selected
  /// while [groupValue] != [value], and only by selecting another radio button
  /// in the group (i.e. changing the value of [groupValue]) can this radio
  /// button be unselected.
  ///
  /// The default is false.
  ///
  /// {@tool dartpad}
  /// This example shows how to enable deselecting a radio button by setting the
  /// [toggleable] attribute.
  ///
  /// ** See code in examples/api/lib/material/radio/radio.toggleable.0.dart **
  /// {@end-tool}
  final bool toggleable;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  final _RadioType _radioType;

  bool get _selected => value == groupValue;

  @override
  State<Radio<T>> createState() => _RadioState<T>();
}

class _RadioState<T> extends State<Radio<T>> with TickerProviderStateMixin, ToggleableStateMixin {
  final _RadioPainter _painter = _RadioPainter();

  void _handleChanged(bool? selected) {
    if (selected == null) {
      widget.onChanged!(null);
      return;
    }
    if (selected) {
      widget.onChanged!(widget.value);
    }
  }

  @override
  void didUpdateWidget(Radio<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._selected != oldWidget._selected) {
      animateToValue();
    }
  }

  @override
  void dispose() {
    _painter.dispose();
    super.dispose();
  }

  @override
  ValueChanged<bool?>? get onChanged => widget.onChanged != null ? _handleChanged : null;

  @override
  bool get tristate => widget.toggleable;

  @override
  bool? get value => widget._selected;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    final RadioThemeData radioTheme = RadioTheme.resolve(context, widget.theme);
    switch (widget._radioType) {
      case _RadioType.material:
        break;

      case _RadioType.adaptive:
        final ThemeData theme = Theme.of(context);
        switch (theme.platform) {
          case TargetPlatform.android:
          case TargetPlatform.fuchsia:
          case TargetPlatform.linux:
          case TargetPlatform.windows:
            break;
          case TargetPlatform.iOS:
          case TargetPlatform.macOS:
            return CupertinoRadio<T>(
              value: widget.value,
              groupValue: widget.groupValue,
              onChanged: widget.onChanged,
              toggleable: widget.toggleable,
              //FIXME
              activeColor: radioTheme.containerColor.resolve({MaterialState.selected}),
              focusColor: radioTheme.containerColor.resolve({}),
              focusNode: widget.focusNode,
              autofocus: widget.autofocus,
            );
        }
    }

    final MaterialTapTargetSize materialTapTargetSize = radioTheme.materialTapTargetSize;
    final VisualDensity visualDensity = radioTheme.visualDensity;
    Size size;
    switch (materialTapTargetSize) {
      case MaterialTapTargetSize.padded:
        size = const Size(kMinInteractiveDimension, kMinInteractiveDimension);
      case MaterialTapTargetSize.shrinkWrap:
        size = const Size(kMinInteractiveDimension - 8.0, kMinInteractiveDimension - 8.0);
    }
    size += visualDensity.baseSizeAdjustment;

    // Colors need to be resolved in selected and non selected states separately
    // so that they can be lerped between.
    final Set<MaterialState> activeStates = states..add(MaterialState.selected);
    final Set<MaterialState> inactiveStates = states..remove(MaterialState.selected);
    final Color activeColor = radioTheme.containerColor.resolve(activeStates);
    final Color inactiveColor = radioTheme.containerColor.resolve(inactiveStates);

    final Set<MaterialState> focusedStates = states..add(MaterialState.focused);
    Color focusOverlayColor = radioTheme.stateLayerColor.resolve(focusedStates);

    final Set<MaterialState> hoveredStates = states..add(MaterialState.hovered);
    Color hoverOverlayColor = radioTheme.stateLayerColor.resolve(hoveredStates);

    final Set<MaterialState> activePressedStates = activeStates..add(MaterialState.pressed);
    final Color activePressedOverlayColor = radioTheme.stateLayerColor.resolve(activePressedStates);

    final Set<MaterialState> inactivePressedStates = inactiveStates..add(MaterialState.pressed);
    final Color inactivePressedOverlayColor = radioTheme.stateLayerColor.resolve(inactivePressedStates);

    if (downPosition != null) {
      hoverOverlayColor = states.contains(MaterialState.selected)
        ? activePressedOverlayColor
        : inactivePressedOverlayColor;
      focusOverlayColor = states.contains(MaterialState.selected)
        ? activePressedOverlayColor
        : inactivePressedOverlayColor;
    }

    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: widget._selected,
      child: buildToggleable(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        mouseCursor: radioTheme.mouseCursor,
        size: size,
        painter: _painter
          ..position = position
          ..reaction = reaction
          ..reactionFocusFade = reactionFocusFade
          ..reactionHoverFade = reactionHoverFade
          ..inactiveReactionColor = inactivePressedOverlayColor
          ..reactionColor = activePressedOverlayColor
          ..hoverColor = hoverOverlayColor
          ..focusColor = focusOverlayColor
          ..splashRadius = radioTheme.splashRadius
          ..downPosition = downPosition
          ..isFocused = states.contains(MaterialState.focused)
          ..isHovered = states.contains(MaterialState.hovered)
          ..activeColor = activeColor
          ..inactiveColor = inactiveColor,
      ),
    );
  }
}

class _RadioPainter extends ToggleablePainter {
  @override
  void paint(Canvas canvas, Size size) {
    paintRadialReaction(canvas: canvas, origin: size.center(Offset.zero));

    final Offset center = (Offset.zero & size).center;

    // Outer circle
    final Paint paint = Paint()
      ..color = Color.lerp(inactiveColor, activeColor, position.value)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, _kOuterRadius, paint);

    // Inner circle
    if (!position.isDismissed) {
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(center, _kInnerRadius * position.value, paint);
    }
  }
}

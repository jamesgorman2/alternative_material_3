// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../animation/animated_row.dart';
import '../colors.dart';
import '../elevation.dart';
import '../ink_well.dart';
import '../interaction/hit_detection.dart';
import '../material.dart';
import '../material_state.dart';
import '../state_theme.dart';
import '../theme.dart';
import '../theme_data.dart';
import 'button_style.dart';

export 'button_style.dart';
export 'elevated_button.dart';
export 'expandable_floating_action_button.dart';
export 'expandable_floating_action_button_theme.dart';
export 'filled_button.dart';
export 'filled_icon_button.dart';
export 'filled_tonal_button.dart';
export 'filled_tonal_icon_button.dart';
export 'floating_action_button.dart';
export 'floating_action_button_location.dart';
export 'floating_action_button_theme.dart';
export 'icon_button.dart';
export 'outlined_button.dart';
export 'outlined_icon_button.dart';
export 'segmented_button.dart';
export 'text_button.dart';

/// The base [StatefulWidget] class for buttons whose style is defined by a [ButtonStyle] object.
///
/// Concrete subclasses must override [defaultStyleOf] and [themeStyleOf].
///
/// See also:
///  * [ElevatedButton], a filled button whose material elevates when pressed.
///  * [FilledButton], a filled button that doesn't elevate when pressed.
///  * [FilledButton.tonal], a filled button variant that uses a secondary fill color.
///  * [OutlinedButton], a button with an outlined border and no fill color.
///  * [TextButton], a button with no outline or fill color.
///  * <https://m3.material.io/components/buttons/overview>, an overview of each of
///    the Material Design button types and how they should be used in designs.
abstract class ButtonStyleButton extends StatefulWidget {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const ButtonStyleButton({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.statesController,
    this.icon,
    this.label,
    this.isSelected = false,
  });

  /// {@template alternative_material_3.button.onPressed}
  /// Called when the button is tapped or otherwise activated.
  ///
  /// If this callback and [onLongPress] are null, then the button will be disabled.
  ///
  /// See also:
  ///
  ///  * [enabled], which is true if the button is enabled.
  /// {@endtemplate}
  final VoidCallback? onPressed;

  /// {@template alternative_material_3.button.onLongPress}
  /// Called when the button is long-pressed.
  ///
  /// If this callback and [onPressed] are null, then the button will be disabled.
  ///
  /// See also:
  ///
  ///  * [enabled], which is true if the button is enabled.
  /// {@endtemplate}
  final VoidCallback? onLongPress;

  /// {@template alternative_material_3.button.onHover}
  /// Called when a pointer enters or exits the button response area.
  ///
  /// The value passed to the callback is true if a pointer has entered this
  /// part of the material and false if a pointer has exited this part of the
  /// material.
  /// {@endtemplate}
  final ValueChanged<bool>? onHover;

  /// {@template alternative_material_3.button.onFocusChange}
  /// Handler called when the focus changes.
  ///
  /// Called with true if this widget's node gains focus, and false if it loses
  /// focus.
  /// {@endtemplate}
  final ValueChanged<bool>? onFocusChange;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.none], and must not be null.
  /// {@endtemplate}
  final Clip clipBehavior;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// {@macro flutter.material.inkwell.statesController}
  final MaterialStatesController? statesController;

  /// {@template alternative_material_3.button.icon}
  /// An optional icon to display before the button's label.
  /// {@endtemplate}
  final Widget? icon;

  /// {@template alternative_material_3.button.label}
  /// The button's label.
  /// {@endtemplate}
  final Widget? label;

  /// {@template alternative_material_3.button.isSelected}
  /// Sets [MaterialState.selected].
  /// {@endtemplate}
  final bool isSelected;

  /// {@template alternative_material_3.button.isSelected}
  /// True if the button has a focus node and is focussed.
  /// {@endtemplate}
  bool get isFocussed => focusNode?.hasFocus ?? false;

  /// {@template alternative_material_3.button.resolveStyle}
  /// Returns a non-null [ButtonStyle] that's based primarily on the [Theme]'s
  /// [ThemeData.textTheme] and [ThemeData.colorScheme].
  ///
  /// The returned style can be overridden by the [style] parameter and
  /// by the style returned by [themeStyleOf]. For example the default
  /// style of the [TextButton] subclass can be overridden with its
  /// [TextButton.style] constructor parameter, or with a
  /// [TextButtonTheme].
  ///
  /// Concrete button subclasses should return a ButtonStyle that
  /// has no null properties, and where all of the [MaterialStateProperty]
  /// properties resolve to non-null values.
  /// {@endtemplate}
  @protected
  ButtonStyle resolveStyle(BuildContext context);

  /// Whether the button is enabled or disabled.
  ///
  /// Buttons are disabled by default. To enable a button, set its [onPressed]
  /// or [onLongPress] properties to a non-null value.
  bool get enabled => onPressed != null || onLongPress != null;

  @override
  State<ButtonStyleButton> createState() => _ButtonStyleState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(FlagProperty('enabled', value: enabled, ifFalse: 'disabled'));
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode,
        defaultValue: null));
  }

  /// Returns null if [value] is null, otherwise `MaterialStatePropertyAll<T>(value)`.
  ///
  /// A convenience method for subclasses.
  static MaterialStateProperty<T>? allOrNull<T>(T? value) =>
      value == null ? null : MaterialStatePropertyAll<T>(value);

  /// Returns an interpolated value based on the [textScaleFactor] parameter:
  ///
  ///  * 0 - 1 [geometry1x]
  ///  * 1 - 2 lerp([geometry1x], [geometry2x], [textScaleFactor] - 1)
  ///  * 2 - 3 lerp([geometry2x], [geometry3x], [textScaleFactor] - 2)
  ///  * otherwise [geometry3x]
  ///
  /// A convenience method for subclasses.
  static EdgeInsetsGeometry scaledPadding(
    EdgeInsetsGeometry geometry1x,
    EdgeInsetsGeometry geometry2x,
    EdgeInsetsGeometry geometry3x,
    double textScaleFactor,
  ) {
    if (textScaleFactor <= 1) {
      return geometry1x;
    } else if (textScaleFactor >= 3) {
      return geometry3x;
    } else if (textScaleFactor <= 2) {
      return EdgeInsetsGeometry.lerp(
          geometry1x, geometry2x, textScaleFactor - 1)!;
    }
    return EdgeInsetsGeometry.lerp(
        geometry2x, geometry3x, textScaleFactor - 2)!;
  }

  /// Returns an interpolated value based on the [textScaleFactor] parameter:
  ///
  ///  * 0 - 1 [geometry1x]
  ///  * 1 - 2 lerp([geometry1x], [geometry2x], [textScaleFactor] - 1)
  ///  * 2 - 3 lerp([geometry2x], [geometry3x], [textScaleFactor] - 2)
  ///  * otherwise [geometry3x]
  ///
  /// A convenience method for subclasses.
  static double scaledPaddingDouble(
    double geometry1x,
    double geometry2x,
    double geometry3x,
    double textScaleFactor,
  ) {
    if (textScaleFactor <= 1) {
      return geometry1x;
    } else if (textScaleFactor >= 3) {
      return geometry3x;
    } else if (textScaleFactor <= 2) {
      return lerpDouble(geometry1x, geometry2x, textScaleFactor - 1)!;
    }
    return lerpDouble(geometry2x, geometry3x, textScaleFactor - 2)!;
  }
}

/// The base [State] class for buttons whose style is defined by a [ButtonStyle] object.
///
/// See also:
///
///  * [ButtonStyleButton], the [StatefulWidget] subclass for which this class is the [State].
///  * [ElevatedButton], a filled button whose material elevates when pressed.
///  * [FilledButton], a filled ButtonStyleButton that doesn't elevate when pressed.
///  * [OutlinedButton], similar to [TextButton], but with an outline.
///  * [TextButton], a simple button without a shadow.
class _ButtonStyleState extends State<ButtonStyleButton>
    with TickerProviderStateMixin {
  MaterialStatesController? internalStatesController;

  void handleStatesControllerChange() {
    // Force a rebuild to resolve MaterialStateProperty properties
    setState(() {});
  }

  void handleFocusChanged() {
    statesController.update(MaterialState.focused, widget.isFocussed);
  }

  MaterialStatesController get statesController =>
      widget.statesController ?? internalStatesController!;

  void initStatesController() {
    if (widget.statesController == null) {
      internalStatesController = MaterialStatesController();
    }
    statesController.update(MaterialState.disabled, !widget.enabled);
    statesController.update(MaterialState.selected, widget.isSelected);
    statesController.update(MaterialState.focused, widget.isFocussed);
    statesController.addListener(handleStatesControllerChange);
  }

  @override
  void initState() {
    super.initState();
    initStatesController();
    widget.focusNode?.addListener(handleFocusChanged);
  }

  @override
  void didUpdateWidget(ButtonStyleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.statesController != oldWidget.statesController) {
      oldWidget.statesController?.removeListener(handleStatesControllerChange);
      if (widget.statesController != null) {
        internalStatesController?.dispose();
        internalStatesController = null;
      }
      initStatesController();
    }
    if (widget.enabled != oldWidget.enabled) {
      statesController.update(MaterialState.disabled, !widget.enabled);
      if (!widget.enabled) {
        // The button may have been disabled while a press gesture is currently underway.
        statesController.update(MaterialState.pressed, false);
      }
    }
    if (widget.isSelected != oldWidget.isSelected) {
      statesController.update(MaterialState.selected, widget.isSelected);
    }
    if (widget.isFocussed != oldWidget.isFocussed) {
      statesController.update(MaterialState.focused, widget.isFocussed);
    }
  }

  @override
  void dispose() {
    statesController.removeListener(handleStatesControllerChange);
    internalStatesController?.dispose();
    widget.focusNode?.removeListener(handleFocusChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = widget.resolveStyle(context);
    final Set<MaterialState> states = statesController.value;

    final Color labelColor = style.labelColor.resolve(states);
    final Color iconColor = style.iconColor?.resolve(states) ?? labelColor;
    final double iconSize = style.iconSize;
    final TextStyle textStyle = style.labelStyle.copyWith(color: labelColor);
    final Color containerColor = style.containerColor.resolve(states);
    final Color shadowColor = style.shadowColor;

    final Elevation elevation = style.elevation.resolve(states);

    final double iconPadding = style.iconPadding;
    final double internalPadding = style.internalPadding;
    final double labelPadding = style.labelPadding;

    final double containerHeight = style.containerHeight;
    final double minimumContainerWidth = style.minimumContainerWidth ?? 0.0;
    final double maximumContainerWidth =
        style.maximumContainerWidth ?? double.infinity;

    final BorderSide? outline = style.outline.resolve(states);
    final OutlinedBorder containerShape =
        style.containerShape.copyWith(side: outline);

    final MouseCursor mouseCursor = style.mouseCursor.resolve(states);

    final StateLayerTheme stateLayers = style.stateLayers.resolve(states);

    final VisualDensity visualDensity = style.visualDensity;
    final Offset densityAdjustment = visualDensity.baseSizeAdjustment;

    final MaterialTapTargetSize tapTargetSize = style.tapTargetSize;
    final Duration animationDuration = style.animationDuration;
    final bool enableFeedback = style.enableFeedback;
    final AlignmentGeometry alignment = style.alignment;
    final InteractiveInkFeatureFactory? resolvedSplashFactory =
        style.splashFactory;

    final BoxConstraints containerConstraints = BoxConstraints(
      minWidth: minimumContainerWidth,
      maxWidth: maximumContainerWidth < minimumContainerWidth
          ? minimumContainerWidth
          : maximumContainerWidth,
      minHeight: containerHeight,
      maxHeight: containerHeight,
    );

    final textScaleFactor = MediaQuery.textScaleFactorOf(context);

    double scalePadding(double padding1x) =>
        ButtonStyleButton.scaledPaddingDouble(
          padding1x,
          padding1x / 2,
          padding1x / 2 / 2,
          textScaleFactor,
        );

    // Per the Material Design team: don't allow the VisualDensity
    // adjustment to reduce the width of the left/right padding. If we
    // did, VisualDensity.compact, the default for desktop/web, would
    // reduce the horizontal padding to zero.
    final double dx = math.max(0, densityAdjustment.dx);

    // final double startPadding = widget.label == null
    //     ? 0.0
    //     : math.max(
    //         scalePadding(widget.icon != null ? iconPadding : labelPadding) + dx,
    //         0.0,
    //       );
    // final double endPadding = widget.label == null
    //     ? 0.0
    //     : math.max(scalePadding(labelPadding) + dx, 0.0);

    final double startPadding = math.max(
      scalePadding(widget.icon != null ? iconPadding : labelPadding) + dx,
      0.0,
    );
    final double endPadding = math.max(
      scalePadding(widget.label == null ? iconPadding : labelPadding) + dx,
      0.0,
    );

    print('startPadding ${startPadding}');
    print('endPadding  $endPadding');

    final Widget result = ConstrainedBox(
      constraints: containerConstraints,
      child: SizedBox(
        height: containerHeight,
        child: Material(
          elevation: elevation,
          textStyle: textStyle,
          shape: containerShape,
          color: containerColor,
          shadowColor: shadowColor,
          type: MaterialType.button,
          animationDuration: animationDuration,
          clipBehavior: widget.clipBehavior,
          child: InkWell(
            onTap: widget.onPressed,
            onLongPress: widget.onLongPress,
            onHover: widget.onHover,
            mouseCursor: mouseCursor,
            enableFeedback: enableFeedback,
            focusNode: widget.focusNode,
            canRequestFocus: widget.enabled,
            onFocusChange: widget.onFocusChange,
            autofocus: widget.autofocus,
            splashFactory: resolvedSplashFactory,
            highlightColor: Colors.transparent,
            customBorder: containerShape.copyWith(side: outline),
            statesController: statesController,
            hoverColor: stateLayers.hoverColor,
            focusColor: stateLayers.focusColor,
            splashColor: stateLayers.pressColor,
            child: IconTheme.merge(
              data: IconThemeData(color: iconColor, size: iconSize),
              child: Align(
                alignment: alignment,
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: AnimatedRow(
                  duration: animationDuration,
                  children: [
                    SizedBox(width: startPadding),
                    widget.icon ?? const SizedBox.shrink(),
                    SizedBox(
                      width: widget.icon == null || widget.label == null
                          ? 0.0
                          : scalePadding(internalPadding),
                    ),
                    widget.label,
                    SizedBox(width: endPadding),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return Semantics(
      container: true,
      button: true,
      enabled: widget.enabled,
      child: RedirectingHitDetectionWidget(
        widgetBox: Size(maximumContainerWidth, containerHeight),
        visualDensity: visualDensity,
        materialTapTargetSize: tapTargetSize,
        child: result,
      ),
    );
  }
}

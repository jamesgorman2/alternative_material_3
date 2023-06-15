// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import '../colors.dart';
import '../elevation.dart';
import '../ink_well.dart';
import '../interaction/hit_detection.dart';
import '../material.dart';
import '../material_state.dart';
import '../state_theme.dart';
import '../theme_data.dart';
import '../tooltip.dart';
import 'button.dart';
import 'button_style.dart';

///
class IconButton extends SelectableIconButton {
  ///
  const IconButton({
    super.key,
    required super.onPressed,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior = Clip.none,
    super.statesController,
    required super.icon,
    super.selectedIcon,
    super.isSelected = false,
    super.tooltipMessage,
    this.theme,
  });

  /// {@template alternative_material_3.icon_button.theme}
  /// Customizes this button's appearance.
  ///
  /// Non-null properties of this style override the corresponding
  /// properties in [themeStyleOf] and [defaultStyleOf]. [MaterialStateProperty]s
  /// that resolve to non-null values will similarly override the corresponding
  /// [MaterialStateProperty]s in [themeStyleOf] and [defaultStyleOf].
  ///
  /// Null by default.
  /// {@endtemplate}
  final IconButtonThemeData? theme;

  @override
  ButtonStyle resolveStyle(BuildContext context) {
    return IconButtonTheme.resolve(context, theme).style;
  }
}

///
abstract class SelectableIconButton extends StatefulWidget {
  ///
  const SelectableIconButton({
    super.key,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    required this.clipBehavior,
    this.focusNode,
    required this.autofocus,
    this.statesController,
    required this.icon,
    Widget? selectedIcon,
    required this.isSelected,
    this.tooltipMessage,
  }) : selectedIcon = selectedIcon ?? icon;

  /// {@macro alternative_material_3.button.onPressed}
  final VoidCallback? onPressed;

  /// {@macro alternative_material_3.button.onLongPress}
  final VoidCallback? onLongPress;

  /// {@macro alternative_material_3.button.onHover}
  final ValueChanged<bool>? onHover;

  /// {@macro alternative_material_3.button.onFocusChange}
  final ValueChanged<bool>? onFocusChange;

  /// {@macro alternative_material_3.button.clipBehavior}
  final Clip clipBehavior;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// {@macro flutter.material.inkwell.statesController}
  final MaterialStatesController? statesController;

  /// {@template alternative_material_3.icon_button.icon}
  ///
  /// {@endtemplate}
  final Widget icon;

  /// {@template alternative_material_3.icon_button.selectedIcon}
  ///
  /// {@endtemplate}
  final Widget selectedIcon;

  /// {@macro alternative_material_3.button.isSelected}
  /// {@endtemplate}
  final bool isSelected;

  /// {@macro alternative_material_3.button.isFocussed}
  /// {@endtemplate}
  bool get isFocussed => focusNode?.hasFocus ?? false;

  /// {@template alternative_material_3.icon_button.theme}
  /// An optional message to display when the button is hovered.
  /// {@endtemplate}
  final String? tooltipMessage;

  /// Whether the button is enabled or disabled.
  ///
  /// Buttons are disabled by default. To enable a button, set its [onPressed]
  /// or [onLongPress] properties to a non-null value.
  bool get enabled => onPressed != null || onLongPress != null;

  /// {@macro alternative_material_3.button.resolveStyle}
  ButtonStyle resolveStyle(BuildContext context);

  @override
  State<SelectableIconButton> createState() => _SelectableIconButtonState();
}

class _SelectableIconButtonState extends State<SelectableIconButton> {
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
  void didUpdateWidget(SelectableIconButton oldWidget) {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.resolveStyle(context);

    final Set<MaterialState> states = statesController.value;

    final Color labelColor = style.labelColor.resolve(states);
    final Color iconColor = style.iconColor?.resolve(states) ?? labelColor;
    final double iconSize = style.iconSize;
    final TextStyle textStyle = style.labelStyle.copyWith(color: labelColor);
    final Color containerColor = style.containerColor.resolve(states);
    final Color shadowColor = style.shadowColor;

    final Elevation elevation = style.elevation.resolve(states);

    final double containerHeight = style.containerHeight;

    final BorderSide? outline = style.outline.resolve(states);
    final OutlinedBorder containerShape =
        style.containerShape.copyWith(side: outline);

    final MouseCursor mouseCursor = style.mouseCursor.resolve(states);

    final StateLayerTheme stateLayers = style.stateLayers.resolve(states);

    final Duration animationDuration = style.animationDuration;
    final bool enableFeedback = style.enableFeedback;
    final AlignmentGeometry alignment = style.alignment;
    final InteractiveInkFeatureFactory? resolvedSplashFactory =
        style.splashFactory;

    final BoxConstraints containerConstraints = BoxConstraints.tightFor(
      width: containerHeight,
      height: containerHeight,
    );

    final label = Builder(builder: (context) {
      return AnimatedSwitcher(
        duration: style.animationDuration,
        switchInCurve: Curves.easeInOut,
        child: widget.isSelected
            ? Container(key: const Key('sel'), child: widget.selectedIcon)
            : Container(key: const Key('unsel'), child: widget.icon),
      );
    });

    final Widget button = ConstrainedBox(
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
                child: label,
              ),
            ),
          ),
        ),
      ),
    );

    Widget tooltip({required Widget child}) {
      if (widget.tooltipMessage != null) {
        return Tooltip(
          message: widget.tooltipMessage,
          child: child,
        );
      }
      return child;
    }

    return RedirectingHitDetectionWidget(
      widgetBox: Size(containerHeight, containerHeight),
      visualDensity: style.visualDensity,
      materialTapTargetSize: style.tapTargetSize,
      child: tooltip(
        child: Semantics(
          container: true,
          button: true,
          enabled: widget.enabled,
          child: button,
        ),
      ),
    );
  }
}

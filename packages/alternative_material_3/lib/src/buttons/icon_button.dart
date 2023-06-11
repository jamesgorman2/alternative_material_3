// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import '../material_state.dart';
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
abstract class SelectableIconButton extends StatelessWidget {
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

  /// {@template alternative_material_3.icon_button.theme}
  /// An optional message to display when the button is hovered.
  /// {@endtemplate}
  final String? tooltipMessage;

  /// {@macro alternative_material_3.button.resolveStyle}
  ButtonStyle resolveStyle(BuildContext context);

  @override
  Widget build(BuildContext context) {
    Widget wrap(Widget w) {
      if (tooltipMessage != null) {
        return Tooltip(
          message: tooltipMessage,
          child: w,
        );
      }
      return w;
    }

    return wrap(
      _IconButton(
        onPressed: onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        focusNode: focusNode,
        autofocus: autofocus,
        icon: Builder(builder: (context) {
          return AnimatedSwitcher(
            duration: resolveStyle(context).animationDuration,
            switchInCurve: Curves.easeInOut,
            child: isSelected
                ? Container(key: const Key('sel'), child: selectedIcon)
                : Container(key: const Key('unsel'), child: icon),
          );
        }),
        isSelected: isSelected,
        clipBehavior: clipBehavior,
        resolveStyle: resolveStyle,
      ),
    );
  }
}

class _IconButton extends ButtonStyleButton {
  const _IconButton({
    required super.onPressed,
    required super.onLongPress,
    required super.onHover,
    required super.onFocusChange,
    required super.focusNode,
    required super.autofocus,
    required super.icon,
    required super.isSelected,
    super.clipBehavior,
    required ButtonStyle Function(BuildContext context) resolveStyle,
  }) : _resolveStyle = resolveStyle;

  final ButtonStyle Function(BuildContext context) _resolveStyle;

  @override
  ButtonStyle resolveStyle(BuildContext context) {
    return _resolveStyle(context);
  }
}

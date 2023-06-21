// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import '../debug.dart';
import '../icons.dart';
import 'chip.dart';

/// Input chips represent discrete pieces of information entered by a user,
/// such as Gmail contacts or filter options within a search field.
///
/// They enable user input and verify that input by converting text into chips.
@immutable
class InputChip extends StatelessWidget {
  /// Create an input chip.
  const InputChip({
    super.key,
    this.enabled = true,
    this.theme,
    this.tooltip,
    this.icon,
    this.avatar,
    required this.label,
    this.deleteIcon,
    this.deleteIconTooltip,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onDeleteHover,
    this.onFocusChange,
    this.onDeletePressed,
    this.focusNode,
    this.autofocus = false,
    this.isSelected = false,
    this.hideDeleteIcon,
  });

  /// {@macro alternative_material_3.chip.theme}
  final ChipThemeData? theme;

  /// {@macro alternative_material_3.chip.isEnabled}
  final bool enabled;

  /// {@macro alternative_material_3.chip.isSelected}
  final bool isSelected;

  /// {@macro alternative_material_3.chip.tooltipMessage}
  final String? tooltip;

  /// {@macro alternative_material_3.chip.leadingIcon}
  final Widget? icon;

  /// {@macro alternative_material_3.chip.avatar}
  final Widget? avatar;

  /// {@macro alternative_material_3.chip.label}
  final Widget label;

  /// {@template alternative_material_3.inputChip.deleteIcon}
  /// The trailing delete icon.
  ///
  /// The default value is Icon(Icons.close).
  /// {@endtemplate}
  final Widget? deleteIcon;

  /// {@template alternative_material_3.inputChip.deleteIconTooltip}
  /// Text to display in a [Tooltip] when the delete icon is hovered.
  /// {@endtemplate}
  final String? deleteIconTooltip;

  /// {@template alternative_material_3.inputChip.hideDeleteIcon}
  /// If true, do not show the delete button, even if [onDeletePressed]
  /// is not null.
  ///
  /// Tne default is to hide the delete button on mobile only.
  /// {@endtemplate}
  final bool Function()? hideDeleteIcon;

  /// {@macro alternative_material_3.chip.onPressed}
  final VoidCallback? onPressed;

  /// {@macro alternative_material_3.chip.onLongPress}
  final ValueChanged<bool>? onLongPress;

  /// {@macro alternative_material_3.chip.onHover}
  final ValueChanged<bool>? onHover;

  /// {@template alternative_material_3.inputChip.onDeletePressed}
  /// Called when the trailing delete icon of the chip is tapped or
  /// otherwise activated.
  ///
  /// If this is null, the delete icon will not be shown.
  /// {@endtemplate}
  final VoidCallback? onDeletePressed;

  /// {@template alternative_material_3.inputChip.onDeleteHover}
  /// Called when a pointer enters or exits the delete icon area.
  ///
  /// The value passed to the callback is true if a pointer has entered this
  /// part of the material and false if a pointer has exited this part of the
  /// material.
  /// {@endtemplate}
  final ValueChanged<bool>? onDeleteHover;

  /// {@macro alternative_material_3.chip.onFocusChange}
  final ValueChanged<bool>? onFocusChange;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    const ChipThemeData defaultInputChipTheme = ChipThemeData(
      labelStartPadding: 12.0,
      labelEndPadding: 12.0,

    );
    final bool hideDelete = hideDeleteIcon != null
        ? hideDeleteIcon!()
        : MediaQuery.of(context).size.shortestSide < 600;

    return Chip(
      theme: defaultInputChipTheme.mergeWith(theme),
      isElevatedChip: false,
      isEnabled: enabled,
      isSelected: isSelected,
      tooltipMessage: tooltip,
      leadingIcon: icon,
      avatar: avatar,
      label: label,
      trailingIcon: hideDelete ? null : deleteIcon ?? const Icon(Icons.close),
      onPressed: onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onTrailingIconHover: onDeleteHover,
      onFocusChange: onFocusChange,
      onTrailingIconPressed: onDeletePressed,
      trailingIconTooltipMessage: deleteIconTooltip,
      focusNode: focusNode,
      autofocus: autofocus,
      tapEnabled: true,
    );
  }
}

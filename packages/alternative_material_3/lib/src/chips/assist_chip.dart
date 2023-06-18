// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import '../color_scheme.dart';
import '../material_state.dart';
import '../theme.dart';
import 'chip.dart';

/// Assist chips represent smart or automated actions that can span multiple
/// apps, such as opening a calendar event from the home screen. Assist
/// chips function as though the user asked an assistant to complete the
/// action. They should appear dynamically and contextually in a UI.
///
/// An alternative to assist chips are buttons, which should appear
/// persistently and consistently.
///
/// AssistChip requires an ancestor [Material] widget to paint its state
/// effects.
@immutable
class AssistChip extends StatelessWidget {
  /// Create an outlined assist chip.
  const AssistChip({
    super.key,
    this.enabled = true,
    this.theme,
    this.tooltipMessage,
    this.icon,
    required this.label,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.focusNode,
    this.autofocus = false,
  }) : _isElevated = false;

  /// Create an elevated assist chip.
  const AssistChip.elevated({
    super.key,
    this.enabled = true,
    this.theme,
    this.tooltipMessage,
    this.icon,
    required this.label,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.focusNode,
    this.autofocus = false,
  }) : _isElevated = true;

  /// True if this uses the elevated theme
  final bool _isElevated;

  /// {@macro alternative_material_3.chip.isEnabled}
  final bool enabled;

  /// {@macro alternative_material_3.chip.theme}
  final ChipThemeData? theme;

  /// {@macro alternative_material_3.chip.tooltipMessage}
  final String? tooltipMessage;

  /// {@macro alternative_material_3.chip.leadingIcon}
  final Widget? icon;

  /// {@macro lternative_material_3.chip.label}
  final Widget label;

  /// {@macro alternative_material_3.chip.onPressed}
  final VoidCallback? onPressed;

  /// {@macro alternative_material_3.chip.onLongPress}
  final ValueChanged<bool>? onLongPress;

  /// {@macro alternative_material_3.chip.onHover}
  final ValueChanged<bool>? onHover;

  /// {@macro alternative_material_3.chip.onFocusChange}
  final ValueChanged<bool>? onFocusChange;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    // Disabled opacity is handled in the widget
    final defaultAssistChipTheme = ChipThemeData(
      labelColor: MaterialStateProperty.resolveWith((states) => colors.onSurface),
      leadingIconColor: MaterialStateProperty.resolveWith((states) =>
          states.contains(MaterialState.disabled)
              ? colors.onSurface
              : colors.primary),
    );
    return Chip(
      theme: defaultAssistChipTheme.mergeWith(theme),
      isElevatedChip: _isElevated,
      isEnabled: enabled && onPressed != null,
      tooltipMessage: tooltipMessage,
      leadingIcon: icon,
      label: label,
      onPressed: onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      focusNode: focusNode,
      autofocus: autofocus,
      tapEnabled: true,
    );
  }
}

// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import '../debug.dart';
import 'chip.dart';

/// Suggestion chips help narrow a user’s intent by presenting dynamically
/// generated suggestions, such as possible responses or search filters.
@immutable
class SuggestionChip extends StatelessWidget {
  /// Create an outlined suggestion chip.
  const SuggestionChip({
    super.key,
    this.enabled = true,
    this.theme,
    this.tooltip,
    required this.label,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.focusNode,
    this.autofocus = false,
    this.isSelected = false,
  }) : _isElevated = false;

  /// Create an elevated suggestion chip.
  const SuggestionChip.elevated({
    super.key,
    this.enabled = true,
    this.theme,
    this.isSelected = false,
    this.tooltip,
    required this.label,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.focusNode,
    this.autofocus = false,
  }) : _isElevated = true;

  final bool _isElevated;

  /// {@macro alternative_material_3.chip.isEnabled}
  final bool enabled;

  /// {@macro alternative_material_3.chip.theme}
  final ChipThemeData? theme;

  /// {@macro alternative_material_3.chip.isSelected}
  final bool isSelected;

  /// {@macro alternative_material_3.chip.tooltipMessage}
  final String? tooltip;

  /// {@macro alternative_material_3.chip.label}
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
    assert(debugCheckHasMaterial(context));
    return Chip(
      theme: theme,
      isElevatedChip: _isElevated,
      isEnabled: enabled,
      isSelected: isSelected,
      tooltipMessage: tooltip,
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

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

  /// True if this chip is enabled.
  final bool enabled;
  
  /// Chip overrides that only apply to this chip.
  final ChipThemeData? theme;

  /// True if this chip is selected.
  final bool isSelected;

  /// Text to display in a [Tooltip] when the chip is hovered.
  final String? tooltip;

  /// The label of the assist chip. This will be constrained
  /// to one line.
  final Widget label;

  /// Called when the chip is tapped or otherwise activated.
  ///
  /// If this callback and [onLongPress] are null, then the
  /// chip will be disabled.
  ///
  /// See also:
  ///
  ///  * [enabled], which is true if the button is enabled.
  final VoidCallback? onPressed;

  /// Called when the chip is long-pressed.
  ///
  /// If this callback and [onPressed] are null, then
  /// the chip will be disabled.
  ///
  /// See also:
  ///
  ///  * [enabled], which is true if the button is enabled.
  final ValueChanged<bool>? onLongPress;

  /// Called when a pointer enters or exits the chip response area.
  ///
  /// The value passed to the callback is true if a pointer has entered this
  /// part of the material and false if a pointer has exited this part of the
  /// material.
  final ValueChanged<bool>? onHover;

  /// Handler called when the focus changes.
  ///
  /// Called with true if this widget's node gains focus, and false if it loses
  /// focus.
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

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
  /// Create an outlined assist chip.
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
    this.onFocusChange,
    this.onDeletePressed,
    this.focusNode,
    this.autofocus = false,
    this.isSelected = false,
    this.hideDeleteIcon,
  });

  /// Chip overrides that only apply to this chip.
  final ChipThemeData? theme;

  /// True if this chip is enabled.
  final bool enabled;

  /// True if this chip is selected.
  final bool isSelected;

  /// Text to display in a [Tooltip] when the chip is hovered.
  final String? tooltip;

  /// An optional leading icon.
  ///
  /// If [avatar] is not null, [avatar] will be displayed instead of [icon].
  final Widget? icon;

  /// An optional leading avatar.
  ///
  /// If [avatar] is not null, [avatar] will be displayed instead of [icon].
  final Widget? avatar;

  /// The label of the assist chip. This will be constrained
  /// to one line.
  final Widget label;

  /// The trailing delete icon.
  ///
  /// The default value is Icon(Icons.close).
  final Widget? deleteIcon;

  /// Text to display in a [Tooltip] when the delete icon is hovered.
  final String? deleteIconTooltip;

  /// If true, do not show the delete button, even if [onDeletePressed]
  /// is not null.
  ///
  /// Tne default is to hide the delete button on mobile only.
  final bool Function()? hideDeleteIcon;

  /// Called when the chip is tapped or otherwise activated.
  ///
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

  /// Called when the trailing delate icon of the chip is tapped or
  /// otherwise activated.
  ///
  /// If this is null, the delete icon will not be shown.
  final VoidCallback? onDeletePressed;

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
      trailingIcon: hideDelete
          ? null
          : deleteIcon ?? const Icon(Icons.close),
      onPressed: onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      onTrailingIconPressed: onDeletePressed,
      trailingIconTooltipMessage: deleteIconTooltip,
      focusNode: focusNode,
      autofocus: autofocus,
      tapEnabled: true,
    );
  }
}

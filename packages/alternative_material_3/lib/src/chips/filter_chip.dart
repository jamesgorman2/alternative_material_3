// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../constants.dart';
import '../debug.dart';
import '../elevation.dart';
import '../icons.dart';
import '../ink_well.dart';
import '../material.dart';
import '../material_state.dart';
import 'chip.dart';

/// Filter chips use tags or descriptive words to filter content.
/// They can be a good alternative to toggle buttons or checkboxes.
///
/// Tapping on a filter chip activates it and appends a leading
/// checkmark icon to the starting edge of the chip label.
@immutable
class FilterChip extends StatelessWidget {
  /// Create an outlined filter chip.
  const FilterChip({
    super.key,
    this.enabled = true,
    this.theme,
    required this.isSelected,
    this.tooltipMessage,
    this.selectedIcon,
    required this.label,
    this.trailingIcon,
    this.trailingIconTooltip,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.onTrailingIconPressed,
    this.onTrailingIconHover,
    this.onTrailingIconFocusChange,
    this.focusNode,
    this.trailingFocusNode,
    this.autofocus = false,
  }) : _isElevated = false;

  /// Create an elevated filter chip.
  const FilterChip.elevated({
    super.key,
    this.enabled = true,
    this.theme,
    required this.isSelected,
    this.tooltipMessage,
    this.selectedIcon,
    required this.label,
    this.trailingIcon,
    this.trailingIconTooltip,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.onTrailingIconPressed,
    this.onTrailingIconHover,
    this.onTrailingIconFocusChange,
    this.focusNode,
    this.trailingFocusNode,
    this.autofocus = false,
  }) : _isElevated = true;

  final bool _isElevated;

  /// {@macro alternative_material_3.chip.enabled}
  final bool enabled;

  /// {@macro alternative_material_3.chip.theme}
  final ChipThemeData? theme;

  /// {@macro alternative_material_3.chip.isSelected}
  final bool isSelected;

  /// {@macro alternative_material_3.chip.tooltipMessage}
  final String? tooltipMessage;

  /// The icon to use when this chip is selected.
  ///
  /// This will be constrained to [ChipThemeData.iconSize].
  ///
  /// The default value is [Icons.check_outlined].
  final Widget? selectedIcon;

  /// {@macro alternative_material_3.chip.label}
  final Widget label;

  /// {@macro alternative_material_3.chip.trailingIcon}
  final Widget? trailingIcon;

  /// {@macro alternative_material_3.chip.trailingIconTooltip}
  final String? trailingIconTooltip;

  /// {@macro alternative_material_3.chip.onPressed}
  final VoidCallback? onPressed;

  /// {@macro alternative_material_3.chip.onLongPress}
  final ValueChanged<bool>? onLongPress;

  /// {@macro alternative_material_3.chip.onHover}
  final ValueChanged<bool>? onHover;

  /// {@macro alternative_material_3.chip.onFocusChange}
  final ValueChanged<bool>? onFocusChange;

  /// {@macro alternative_material_3.chip.onTrailingIconPressed}
  final VoidCallback? onTrailingIconPressed;

  /// {@macro alternative_material_3.chip.onTrailingIconHover}
  final ValueChanged<bool>? onTrailingIconHover;

  /// {@macro alternative_material_3.chip.onTrailingIconFocusChange}
  final ValueChanged<bool>? onTrailingIconFocusChange;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? trailingFocusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Chip(
      theme: theme,
      isElevatedChip: _isElevated,
      isEnabled: enabled,
      isSelected: isSelected,
      tooltipMessage: tooltipMessage,
      leadingIcon:
          isSelected ? selectedIcon ?? const Icon(Icons.check_outlined) : null,
      label: label,
      trailingIcon: trailingIcon,
      trailingIconTooltipMessage: trailingIconTooltip,
      onPressed: onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      onTrailingIconPressed: onTrailingIconPressed,
      onTrailingIconHover: onTrailingIconHover,
      onTrailingIconFocusChange: onTrailingIconFocusChange,
      focusNode: focusNode,
      trailingFocusNode: trailingFocusNode,
      autofocus: autofocus,
      tapEnabled: true,
    );
  }
}

/// A filter chip with drop down to choose from a list of filters.
///
/// When [onPressed] is not null the chip the body of the chip will trigger
/// [onPressed] and the trailing icon will trigger the drop down.
///
/// When [onPressed] is null the entire chip will trigger the drop down.
class MultiSelectFilterChip<T> extends StatefulWidget {
  /// Create an outlined filter chip.
  const MultiSelectFilterChip({
    super.key,
    required this.filters,
    required this.initialFilterValue,
    required this.onFilterChanged,
    this.enabled = true,
    this.theme,
    required this.isSelected,
    this.tooltipMessage,
    this.selectedIcon,
    this.trailingIcon,
    this.trailingIconTooltip,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.onTrailingIconPressed,
    this.onTrailingIconHover,
    this.onTrailingIconFocusChange,
    this.focusNode,
    this.trailingFocusNode,
    this.autofocus = false,
    this.scrollControllers = const [],
  }) : _isElevated = false;

  /// Create an elevated filter chip.
  const MultiSelectFilterChip.elevated({
    super.key,
    required this.filters,
    required this.initialFilterValue,
    required this.onFilterChanged,
    this.enabled = true,
    this.theme,
    required this.isSelected,
    this.tooltipMessage,
    this.selectedIcon,
    this.trailingIcon,
    this.trailingIconTooltip,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.onTrailingIconPressed,
    this.onTrailingIconHover,
    this.onTrailingIconFocusChange,
    this.focusNode,
    this.trailingFocusNode,
    this.autofocus = false,
    this.scrollControllers = const [],
  }) : _isElevated = true;

  final bool _isElevated;

  /// The list of filters that can be chosen from.
  final List<FilterChipChoice<T>> filters;

  /// The value of the currently selected filter.
  ///
  /// This must have a corresponding value in [filters].
  final T initialFilterValue;

  /// Called when the filter is changed.
  final ValueChanged<T> onFilterChanged;

  /// {@macro alternative_material_3.chip.enabled}
  final bool enabled;

  /// {@macro alternative_material_3.chip.theme}
  final ChipThemeData? theme;

  /// {@macro alternative_material_3.chip.isSelected}
  final bool isSelected;

  /// {@macro alternative_material_3.chip.tooltipMessage}
  final String? tooltipMessage;

  /// The icon to use when this chip is selected.
  ///
  /// This will be constrained to [ChipThemeData.iconSize].
  ///
  /// The default value is [Icons.check_outlined].
  final Widget? selectedIcon;

  /// An optional element to display after the label.
  ///
  /// This will be constrained to [ChipThemeData.iconSize].
  ///
  /// The default value is [Icons.arrow_drop_down_outlined].
  final Widget? trailingIcon;

  /// {@macro alternative_material_3.chip.trailingIconTooltip}
  final String? trailingIconTooltip;

  /// {@macro alternative_material_3.chip.onPressed}
  final VoidCallback? onPressed;

  /// {@macro alternative_material_3.chip.onLongPress}
  final ValueChanged<bool>? onLongPress;

  /// {@macro alternative_material_3.chip.onHover}
  final ValueChanged<bool>? onHover;

  /// {@macro alternative_material_3.chip.onFocusChange}
  final ValueChanged<bool>? onFocusChange;

  /// {@macro alternative_material_3.chip.onTrailingIconPressed}
  final VoidCallback? onTrailingIconPressed;

  /// {@macro alternative_material_3.chip.onTrailingIconHover}
  final ValueChanged<bool>? onTrailingIconHover;

  /// {@macro alternative_material_3.chip.onTrailingIconFocusChange}
  final ValueChanged<bool>? onTrailingIconFocusChange;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? trailingFocusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// A list of [ScrollController]s that will be moved when the dropdown
  /// menu is scrolled.
  ///
  /// This is used to allow scroll events to propagate below the dropdown
  /// (such as when the [MultiSelectFilterChip] is in a
  /// [SingleChildScrollView]). It is provided as a list to allow for the
  /// control of stacked scrolling widgets.
  final List<ScrollController> scrollControllers;

  @override
  State<MultiSelectFilterChip<T>> createState() =>
      _MultiSelectFilterChipState();
}

const Duration _kExpandDuration = Duration(milliseconds: 200);
const Duration _kMenuFadeInDuration = Duration(milliseconds: 50);

class _MultiSelectFilterChipState<T> extends State<MultiSelectFilterChip<T>>
    with TickerProviderStateMixin {
  GlobalKey chipKey = GlobalKey();

  // anonymous group for for this instance
  final Object _tapRegionGroup = Object();

  late T selectedValue;
  _MenuState _menuState = _MenuState.closed;
  OverlayEntry? _menuEntry;

  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  late AnimationController _animationController;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;

  final LayerLink link = LayerLink();

  @override
  void initState() {
    assert(
      widget.filters.any((f) => f.value == widget.initialFilterValue),
    );
    super.initState();
    _animationController =
        AnimationController(duration: _kExpandDuration, vsync: this);
    _iconTurns = _animationController.drive(_halfTween.chain(_easeInTween));
    _heightFactor = _animationController.drive(_easeInTween);
    selectedValue = widget.initialFilterValue;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _menuEntry?.remove();
    _menuEntry?.dispose();
    super.dispose();
  }

  void _handleShowMenu(BuildContext context, ChipThemeData chipTheme) {
    switch (_menuState) {
      case _MenuState.closed:
      case _MenuState.closing:
        _showMenu(context, chipTheme);
      case _MenuState.open:
      case _MenuState.opening:
        _hideMenu();
    }
  }

  // TODO move me somehwere and share
  bool get _isMobile => MediaQuery.of(context).size.shortestSide < 600;

  Widget _menu(BuildContext context, ChipThemeData chipTheme) {
    final Set<MaterialState> states = {
      if (widget.isSelected) MaterialState.selected,
    };
    final elevation = (widget._isElevated
        ? chipTheme.elevatedElevation.resolve({})
        : chipTheme.outlinedElevation.resolve({}));

    return TapRegion(
      groupId: _tapRegionGroup,
      onTapOutside: (PointerDownEvent event) => _hideMenu(),
      child: Material(
        color: Color.alphaBlend(
          chipTheme.dropdownContainerTint,
          chipTheme.dropdownContainerColor,
        ),
        elevation: elevation,
        shadowColor: chipTheme.shadowColor,
        animationDuration: _kMenuFadeInDuration,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(chipTheme.dropdownContainerBorderRadius),
        ),
        clipBehavior: Clip.hardEdge,
        child: IntrinsicHeight(
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _menuItems(context, chipTheme, states),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _menuItems(
    BuildContext context,
    ChipThemeData chipTheme,
    Set<MaterialState> states,
  ) {
    // TODO use menu theme for padding
    return widget.filters.map<Widget>(
      (filter) {
        final stateLayerTheme = chipTheme.stateLayers.resolve(states);
        return InkWell(
          focusColor: stateLayerTheme.focusColor,
          hoverColor: stateLayerTheme.hoverColor,
          splashColor: stateLayerTheme.pressColor,
          onTap: () => _handleFilterSelected(filter.value),
          child: SizedBox(
            height: _isMobile
                ? kMinInteractiveDimension
                : chipTheme.containerHeight,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12, //menu padding
                  ),
                  child: IconTheme.merge(
                    data: IconThemeData(
                      color: chipTheme.trailingIconColor.resolve(states),
                      size: chipTheme.iconSize,
                    ),
                    child: SizedBox.square(
                      dimension: chipTheme.iconSize,
                      child: filter.icon,
                    ),
                  ),
                ),
                DefaultTextStyle(
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  softWrap: false,
                  style: chipTheme.labelTextStyle.copyWith(
                    color: chipTheme.labelColor.resolve(states),
                  ),
                  child: filter.label,
                ),
                SizedBox(
                  width: chipTheme.iconSize + 24, // menu padding
                ),
              ],
            ),
          ),
        );
      },
    ).toList();
  }

  void _handleFilterSelected(T newFilterValue) {
    if (newFilterValue != selectedValue) {
      setState(() {
        selectedValue = newFilterValue;
      });
      widget.onFilterChanged(newFilterValue);
    }
    _hideMenu();
  }

  bool get _openDropdownFromChip => widget.onPressed == null;

  void _handleScrollEvent(PointerSignalEvent pointerSignal) {
    if (pointerSignal is PointerScrollEvent) {
      widget.scrollControllers.forEach((controller) {
        final oldOffset = controller.offset;
        final delta = controller.position.axis == Axis.horizontal
            ? pointerSignal.scrollDelta.dx
            : pointerSignal.scrollDelta.dy;

        controller.position.jumpTo(
          oldOffset + delta,
        );
      });
    }
  }

  void _showMenu(BuildContext context, ChipThemeData chipTheme) {
    final OverlayState overlayState = Overlay.of(context);
    final textDirection = Directionality.maybeOf(context) ?? TextDirection.ltr;

    _menuEntry?.remove();
    _menuEntry?.dispose();

    final RenderBox chipBox =
        (chipKey.currentContext?.findRenderObject())! as RenderBox;
    final Offset chipPosition =
        chipBox.localToGlobal(Offset.zero); //this is global position

    const double shadowPadding = 4.0;

    // This is a bodge so it doesn't look like the menu is overlapping
    // an elevated widget when it is just overlapping the shadow.
    final elevation = (widget._isElevated
        ? chipTheme.elevatedElevation.resolve({})
        : chipTheme.outlinedElevation.resolve({}));
    final elevationVerticalOffset = elevation >= Elevation.level1 ? 1.0 : 0.0;

    _menuEntry = OverlayEntry(
      builder: (BuildContext context) => AnimatedBuilder(
        animation: _animationController.view,
        builder: (BuildContext context, Widget? child) => Positioned(
          top: chipPosition.dy,
          child: CompositedTransformFollower(
            link: link,
            offset: Offset(
              textDirection == TextDirection.ltr
                  ? -shadowPadding : shadowPadding,
              -(chipBox.size.height - chipTheme.containerHeight) / 2.0 +
                  elevationVerticalOffset,
            ),
            targetAnchor: textDirection == TextDirection.ltr
                ? Alignment.bottomLeft
                : Alignment.bottomRight,
            followerAnchor: textDirection == TextDirection.ltr
                ? Alignment.topLeft
                : Alignment.topRight,
            child: ClipRect(
              child: Align(
                heightFactor: _heightFactor.value,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: shadowPadding,
                    right: shadowPadding,
                    bottom: shadowPadding,
                  ),
                  child: Listener(
                    onPointerSignal: _handleScrollEvent,
                    child: SingleChildScrollView(
                      child: _menu(context, chipTheme),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    overlayState.insert(_menuEntry!);

    _menuState = _MenuState.opening;
    _animationController.forward().then((void value) {
      _menuState = _MenuState.open;
      if (mounted) {
        setState(() {
          // Rebuild without widget.children.
        });
      }
    });
  }

  void _hideMenu() {
    _menuState = _MenuState.closing;
    _animationController.reverse().then((void value) {
      _menuEntry?.remove();
      _menuEntry?.dispose();
      _menuEntry = null;
      _menuState = _MenuState.closed;
      if (mounted) {
        setState(() {
          // Rebuild without widget.children.
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    debugCheckHasTapRegionSurface(context);

    final chipTheme = ChipTheme.resolve(context, widget.theme);

    return TapRegion(
      groupId: _tapRegionGroup,
      child: CompositedTransformTarget(
        link: link,
        child: Chip(
          key: chipKey,
          theme: widget.theme,
          isElevatedChip: widget._isElevated,
          isEnabled: widget.enabled,
          isSelected: widget.isSelected,
          tooltipMessage: widget.tooltipMessage,
          leadingIcon: widget.isSelected
              ? widget.selectedIcon ?? const Icon(Icons.check_outlined)
              : null,
          label: widget.filters
              .firstWhere((filter) => filter.value == selectedValue)
              .label,
          trailingIcon: RotationTransition(
            turns: _iconTurns,
            child: widget.trailingIcon ??
                const Icon(Icons.arrow_drop_down_outlined),
          ),
          trailingIconTooltipMessage: widget.trailingIconTooltip,
          onPressed: _openDropdownFromChip
              ? () => _handleShowMenu(context, chipTheme)
              : widget.onPressed,
          onLongPress: widget.onLongPress,
          onHover: widget.onHover,
          onFocusChange: widget.onFocusChange,
          onTrailingIconPressed: _openDropdownFromChip
              ? null
              : () => _handleShowMenu(context, chipTheme),
          onTrailingIconHover: widget.onTrailingIconHover,
          onTrailingIconFocusChange: widget.onTrailingIconFocusChange,
          focusNode: widget.focusNode,
          trailingFocusNode: widget.trailingFocusNode,
          autofocus: widget.autofocus,
          tapEnabled: true,
        ),
      ),
    );
  }
}

enum _MenuState {
  closed,
  opening,
  open,
  closing,
}

/// A single row in a filter chip drop down.
///
/// This will generate both the details in the chip and the drop down.
@immutable
class FilterChipChoice<T> {
  /// Create a new filter chip choice.
  const FilterChipChoice({
    required this.value,
    this.icon,
    required this.label,
  });

  /// The value used to identify the filter and returned by
  /// [MultiSelectFilterChip.onFilterChanged].
  final T value;

  /// The optional icon to be used by the filter in the drop down.
  final Widget? icon;

  /// {@macro alternative_material_3.chip.label}
  final Widget label;
}

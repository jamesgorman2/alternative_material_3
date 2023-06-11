// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../debug.dart';
import '../elevation.dart';
import '../ink_well.dart';
import '../interaction/hit_detection.dart';
import '../material.dart';
import '../material_state.dart';
import '../material_state_mixin.dart';
import '../theme.dart';
import '../tooltip.dart';
import 'chip_theme.dart';

export 'assist_chip.dart';
export 'chip_theme.dart';
export 'filter_chip.dart';
export 'input_chip.dart';
export 'suggestion_chip.dart';

// Some design constants
const Duration _kSelectDuration = Duration(milliseconds: 195);

const Duration _kWidthChangeDuration =
    _kSelectDuration; //Duration(milliseconds: 250);

const Duration _kCheckmarkDuration = Duration(milliseconds: 150);
const Duration _kCheckmarkReverseDuration = Duration(milliseconds: 100);
const Duration _kDrawerDuration = Duration(milliseconds: 150);
const Duration _kReverseDrawerDuration = Duration(milliseconds: 100);
const Duration _kDisableDuration = Duration(milliseconds: 75);

/// A raw Material Design chip.
///
/// This serves as the basis for all of the chip widget types to aggregate.
/// It is typically not created directly, one of the other chip types
/// that are appropriate for the use case are used instead:
///
///  * [Chip] a simple chip that can only display information and be deleted.
///  * [InputChip] represents a complex piece of information, such as an entity
///    (person, place, or thing) or conversational text, in a compact form.
///  * [ChoiceChip] allows a single selection from a set of options.
///  * [FilterChip] a chip that uses tags or descriptive words as a way to
///    filter content.
///  * [ActionChip]s display a set of actions related to primary content.
///
/// Raw chips are typically only used if you want to create your own custom chip
/// type.
///
/// Raw chips can be selected by setting [onLongPress], deleted by setting
/// [onDeleted], and pushed like a button with [onPressed]. They have a [label],
/// and they can have a leading icon (see [avatar]) and a trailing icon
/// ([deleteIcon]). Colors and padding can be customized.
///
/// Requires one of its ancestors to be a [Material] widget.
///
/// See also:
///
///  * [CircleAvatar], which shows images or initials of people.
///  * [Wrap], A widget that displays its children in multiple horizontal or
///    vertical runs.
///  * <https://material.io/design/components/chips.html>
class Chip extends StatefulWidget {
  /// Creates a RawChip.
  ///
  /// The [onPressed] and [onLongPress] callbacks must not both be specified at
  /// the same time.
  ///
  /// The [label], [isEnabled], [selected], [autofocus], and [clipBehavior]
  /// arguments must not be null. The [pressElevation] and [elevation] must be
  /// null or non-negative. Typically, [pressElevation] is greater than
  /// [elevation].
  const Chip({
    super.key,
    this.theme,
    required this.isElevatedChip,
    required this.isEnabled,
    this.isSelected = false,
    this.tooltipMessage,
    this.leadingIcon,
    this.avatar,
    required this.label,
    this.trailingIcon,
    this.trailingIconTooltipMessage,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.onTrailingIconPressed,
    this.onTrailingIconHover,
    this.onTrailingIconFocusChange,
    this.focusNode,
    this.trailingFocusNode,
    required this.autofocus,
    required this.tapEnabled,
  });

  /// {@template alternative_material_3.chip.theme}
  /// Override chip theme properties.
  /// {@endtemplate}
  final ChipThemeData? theme;

  /// {@template alternative_material_3.chip.isElevatedChip}
  /// True if this uses the elevated theme
  /// {@endtemplate}
  final bool isElevatedChip;

  /// {@template alternative_material_3.chip.isEnabled}
  /// True if this chip is enabled.
  /// {@endtemplate}
  final bool isEnabled;

  /// {@template alternative_material_3.chip.isSelected}
  /// True if this chip is selected.
  /// {@endtemplate}
  final bool isSelected;

  /// {@template alternative_material_3.chip.tooltipMessage}
  /// Text to display in a [Tooltip] when the chip is hovered.
  /// {@endtemplate}
  final String? tooltipMessage;

  /// {@template alternative_material_3.chip.leadingIcon}
  /// An optional leading icon or image.
  ///
  /// When both [avatar] and [leadingIcon] are present, [avatar]
  /// will be used.
  ///
  /// This will be constrained to the [ChipThemeData.iconSize].
  /// {@endtemplate}
  final Widget? leadingIcon;

  /// {@template alternative_material_3.chip.avatar}
  /// An optional leading avatar.
  ///
  /// When both [avatar] and [leadingIcon] are present, [avatar]
  /// will be used.
  ///
  /// This will be constrained to the [ChipThemeData.avatarSize].
  /// {@endtemplate}
  final Widget? avatar;

  /// {@template alternative_material_3.chip.label}
  /// The label of the assist chip. This will be constrained
  /// to one line.
  /// {@endtemplate}
  final Widget label;

  /// {@template alternative_material_3.chip.trailingIcon}
  /// An optional trailing icon or image.
  ///
  /// This will be constrained to [ChipThemeData.iconSize].
  /// {@endtemplate}
  final Widget? trailingIcon;

  /// {@template alternative_material_3.chip.trailingIconTooltipMessage}
  /// Text to display in a [Tooltip] when the trailing icon is hovered.
  /// {@endtemplate}
  final String? trailingIconTooltipMessage;

  /// {@template alternative_material_3.chip.onPressed}
  /// Called when the chip is tapped or otherwise activated.
  ///
  /// If this callback and [onLongPress] are null,
  /// then the chip will be disabled.
  ///
  /// See also:
  ///
  ///  * [isEnabled], which is true if the button is enabled.
  /// {@endtemplate}
  final VoidCallback? onPressed;

  /// {@template alternative_material_3.chip.onLongPress}
  /// Called when the chip is long-pressed.
  ///
  /// If this callback and [onPressed] are null,
  /// then the chip will be disabled.
  ///
  /// See also:
  ///
  ///  * [isEnabled], which is true if the button is enabled.
  /// {@endtemplate}
  final ValueChanged<bool>? onLongPress;

  /// {@template alternative_material_3.chip.onHover}
  /// Called when a pointer enters or exits the chip response area.
  ///
  /// The value passed to the callback is true if a pointer has entered this
  /// part of the material and false if a pointer has exited this part of the
  /// material.
  /// {@endtemplate}
  final ValueChanged<bool>? onHover;

  /// {@template alternative_material_3.chip.onFocusChange}
  /// Handler called when the focus changes.
  ///
  /// Called with true if this widget's node gains focus, and false if it loses
  /// focus.
  /// {@endtemplate}
  final ValueChanged<bool>? onFocusChange;

  /// {@template alternative_material_3.chip.onTrailingIconPressed}
  /// Called when the trailing icon of the chip is tapped or
  /// otherwise activated.
  /// {@endtemplate}
  final VoidCallback? onTrailingIconPressed;

  /// {@template alternative_material_3.chip.onTrailingIconHover}
  /// Called when a pointer enters or exits the trailing icon area.
  ///
  /// The value passed to the callback is true if a pointer has entered this
  /// part of the material and false if a pointer has exited this part of the
  /// material.
  /// {@endtemplate}
  final ValueChanged<bool>? onTrailingIconHover;

  /// {@template alternative_material_3.chip.onFocusChange}
  /// Handler called when the focus changes in the trailing icon.
  ///
  /// Called with true if this widget's node gains focus, and false if it loses
  /// focus.
  /// {@endtemplate}
  final ValueChanged<bool>? onTrailingIconFocusChange;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? trailingFocusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// {@template alternative_material_3.chip.tapEnabled}
  /// If set, this indicates that the chip should be disabled if all of the
  /// tap callbacks ([onLongPress], [onPressed]) are null.
  ///
  /// For example, the [SuggestionChip] class sets this to false because it can't be
  /// disabled, even if no callbacks are set on it, since it is used for
  /// displaying information only.
  ///
  /// Defaults to true.
  /// {@endtemplate}
  final bool tapEnabled;

  @override
  State<Chip> createState() => _ChipState();
}

class _ChipState extends State<Chip>
    with MaterialStateMixin, TickerProviderStateMixin<Chip> {
  static const Duration pressedAnimationDuration = Duration(milliseconds: 75);

  late AnimationController selectController;
  late AnimationController leadingDrawerController;
  late AnimationController trailingDrawerController;
  late AnimationController enableController;
  late Animation<double> leadingIconAnimation;
  late Animation<double> avatarDrawerAnimation;
  late Animation<double> trailingDrawerAnimation;
  late Animation<double> enableAnimation;
  late Animation<double> selectionFade;

  bool get hasTrailing => widget.trailingIcon != null;

  bool get hasLeading => widget.avatar != null || widget.leadingIcon != null;

  bool get canTap {
    return widget.isEnabled &&
        widget.tapEnabled &&
        (widget.onPressed != null || widget.onLongPress != null);
  }

  bool _isTapping = false;

  bool get isTapping => canTap && _isTapping;

  @override
  void initState() {
    assert(widget.onLongPress == null || widget.onPressed == null);
    super.initState();

    setMaterialState(MaterialState.disabled, !widget.isEnabled);
    setMaterialState(MaterialState.selected, widget.isSelected);

    selectController = AnimationController(
      duration: _kSelectDuration,
      value: widget.isSelected ? 1.0 : 0.0,
      vsync: this,
    );
    selectionFade = CurvedAnimation(
      parent: selectController,
      curve: Curves.fastOutSlowIn,
    );
    leadingDrawerController = AnimationController(
      duration: _kDrawerDuration,
      value: hasLeading || widget.isSelected ? 1.0 : 0.0,
      vsync: this,
    );
    trailingDrawerController = AnimationController(
      duration: _kDrawerDuration,
      value: hasTrailing ? 1.0 : 0.0,
      vsync: this,
    );
    enableController = AnimationController(
      duration: _kDisableDuration,
      value: widget.isEnabled ? 1.0 : 0.0,
      vsync: this,
    );

    // These will delay the start of some animations, and/or reduce their
    // length compared to the overall select animation, using Intervals.
    final double leadingIconPercentage =
        _kCheckmarkDuration.inMilliseconds / _kSelectDuration.inMilliseconds;
    final double leadingIconReversePercentage =
        _kCheckmarkReverseDuration.inMilliseconds /
            _kSelectDuration.inMilliseconds;
    final double avatarDrawerReversePercentage =
        _kReverseDrawerDuration.inMilliseconds /
            _kSelectDuration.inMilliseconds;
    leadingIconAnimation = CurvedAnimation(
      parent: selectController,
      curve: Interval(1.0 - leadingIconPercentage, 1.0,
          curve: Curves.fastOutSlowIn),
      reverseCurve: Interval(
        1.0 - leadingIconReversePercentage,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
    );
    trailingDrawerAnimation = CurvedAnimation(
      parent: trailingDrawerController,
      curve: Curves.fastOutSlowIn,
    );
    avatarDrawerAnimation = CurvedAnimation(
      parent: leadingDrawerController,
      curve: Curves.fastOutSlowIn,
      reverseCurve: Interval(
        1.0 - avatarDrawerReversePercentage,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
    );
    enableAnimation = CurvedAnimation(
      parent: enableController,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    selectController.dispose();
    leadingDrawerController.dispose();
    trailingDrawerController.dispose();
    enableController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!canTap) {
      return;
    }
    setMaterialState(MaterialState.pressed, true);
    setState(() {
      _isTapping = true;
    });
  }

  void _handleTapCancel() {
    if (!canTap) {
      return;
    }
    setMaterialState(MaterialState.pressed, false);
    setState(() {
      _isTapping = false;
    });
  }

  void _handleTap() {
    if (!canTap) {
      return;
    }
    setMaterialState(MaterialState.pressed, false);
    setState(() {
      _isTapping = false;
    });
    // Only one of these can be set, so only one will be called.
    widget.onLongPress?.call(!widget.isSelected);
    widget.onPressed?.call();
  }

  bool _trailingIsHovered = false;

  void _handleTrailingHover(bool isHovered) {
    if (isHovered != _trailingIsHovered) {
      setState(() {
        _trailingIsHovered = isHovered;
      });
    }
  }

  @override
  void didUpdateWidget(Chip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isEnabled != widget.isEnabled) {
      setState(() {
        setMaterialState(MaterialState.disabled, !widget.isEnabled);
        if (widget.isEnabled) {
          enableController.forward();
        } else {
          enableController.reverse();
        }
      });
    }
    if (oldWidget.avatar != widget.avatar ||
        oldWidget.isSelected != widget.isSelected) {
      setState(() {
        if (hasLeading || widget.isSelected) {
          leadingDrawerController.forward();
        } else {
          leadingDrawerController.reverse();
        }
      });
    }
    if (oldWidget.isSelected != widget.isSelected) {
      setState(() {
        setMaterialState(MaterialState.selected, widget.isSelected);
        if (widget.isSelected) {
          selectController.forward();
        } else {
          selectController.reverse();
        }
      });
    }
    if (oldWidget.onTrailingIconPressed != widget.onTrailingIconPressed) {
      setState(() {
        if (hasTrailing) {
          trailingDrawerController.forward();
        } else {
          trailingDrawerController.reverse();
        }
      });
    }
  }

  Widget? _wrapWithTooltip({
    String? tooltip,
    bool enabled = true,
    Widget? child,
  }) {
    if (child == null || !enabled || tooltip == null) {
      return child;
    }
    return Tooltip(
      message: tooltip,
      child: child,
    );
  }

  Widget _buildTrailingIcon(
    BuildContext context,
    ThemeData theme,
    ChipThemeData chipTheme,
  ) {
    Widget wrapIcon(Widget icon) {
      final IconThemeData trailingIconTheme = IconThemeData(
        color: chipTheme.trailingIconColor.resolve(materialStates),
        size: chipTheme.iconSize,
      );

      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: chipTheme.iconPadding,
          vertical: (chipTheme.containerHeight - chipTheme.iconSize) / 2.0,
        ),
        child: SizedBox(
          width: chipTheme.iconSize,
          height: chipTheme.iconSize,
          child: Opacity(
            opacity:
                widget.isEnabled ? 1.0 : chipTheme.stateTheme.disabledOpacity,
            child: IconTheme.merge(
              data: trailingIconTheme,
              child: icon,
            ),
          ),
        ),
      );
    }

    if (!hasTrailing) {
      return SizedBox(width: chipTheme.labelEndPadding);
    }
    if (widget.onTrailingIconPressed == null) {
      return wrapIcon(widget.trailingIcon!);
    }
    // Radius should be slightly less than the full size of the chip.
    // 2 dp in from closest edge
    final splashRadius = math.min(
          chipTheme.iconSize / 0.2 + chipTheme.iconPadding,
          chipTheme.containerHeight / 2.0,
        ) -
        1.75;

    return Semantics(
      container: true,
      button: true,
      child: _wrapWithTooltip(
        tooltip: widget.trailingIconTooltipMessage,
        enabled: widget.onTrailingIconPressed != null,
        child: InkResponse(
          focusNode: widget.trailingFocusNode,
          radius: splashRadius,
          // Keeps the splash from being constrained to the icon alone.
          splashFactory:
              _UnconstrainedInkSplashFactory(Theme.of(context).splashFactory),
          onTap: widget.isEnabled ? widget.onTrailingIconPressed : null,
          onHover: _handleTrailingHover,
          focusColor: chipTheme.stateLayers.resolve(materialStates).focusColor,
          hoverColor: chipTheme.stateLayers.resolve(materialStates).hoverColor,
          splashColor: chipTheme.stateLayers.resolve(materialStates).pressColor,
          child: wrapIcon(widget.trailingIcon!),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMediaQuery(context));
    assert(debugCheckHasDirectionality(context));
    assert(debugCheckHasMaterialLocalizations(context));

    final ChipThemeData chipTheme = ChipTheme.resolve(context, widget.theme);

    final ThemeData theme = Theme.of(context);

    final OutlinedBorder containerBorder = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(chipTheme.containerBorderRadius),
      side: widget.isElevatedChip
          ? BorderSide.none
          : BorderSide(
              width: chipTheme.outlineSize,
              color: chipTheme.outlineColor
                  .resolve(materialStates), //_outlineColor(chipTheme),
            ),
    );
    final ShapeDecoration containerDecoration = ShapeDecoration(
      shape: containerBorder,
    );

    final Elevation elevation = widget.isElevatedChip
        ? chipTheme.elevatedElevation.resolve(materialStates)
        : chipTheme.outlinedElevation.resolve(materialStates);
    final Color shadowColor = chipTheme.shadowColor;

    final TextStyle labelStyle = chipTheme.labelTextStyle
        .copyWith(color: chipTheme.labelColor.resolve(materialStates));

    final IconThemeData leadingIconTheme = IconThemeData(
      color: chipTheme.leadingIconColor.resolve(materialStates),
      size: chipTheme.iconSize,
    );

    final Widget leading;
    if (widget.avatar != null) {
      leading = Padding(
        padding: EdgeInsetsDirectional.only(
          start: chipTheme.avatarStartPadding,
          end: chipTheme.avatarEndPadding,
        ),
        child: SizedBox(
          width: chipTheme.avatarSize,
          height: chipTheme.avatarSize,
          child: Opacity(
            opacity:
                widget.isEnabled ? 1.0 : chipTheme.stateTheme.disabledOpacity,
            child: widget.avatar,
          ),
        ),
      );
    } else if (widget.leadingIcon != null) {
      leading = Padding(
        padding: EdgeInsets.symmetric(horizontal: chipTheme.iconPadding),
        child: SizedBox(
          width: chipTheme.iconSize,
          height: chipTheme.iconSize,
          child: Opacity(
            opacity:
                widget.isEnabled ? 1.0 : chipTheme.stateTheme.disabledOpacity,
            child: IconTheme.merge(
              data: leadingIconTheme,
              child: widget.leadingIcon!,
            ),
          ),
        ),
      );
    } else {
      leading = SizedBox(width: chipTheme.labelStartPadding);
    }

    final Widget label = Opacity(
      opacity: widget.isEnabled ? 1.0 : chipTheme.stateTheme.disabledOpacity,
      child: DefaultTextStyle(
        overflow: TextOverflow.fade,
        textAlign: TextAlign.start,
        maxLines: 1,
        softWrap: false,
        style: labelStyle,
        child: widget.label,
      ),
    );

    final Widget trailing = _buildTrailingIcon(context, theme, chipTheme);

    Widget result = AnimatedBuilder(
      animation: Listenable.merge(
        <Listenable>[selectController, enableController],
      ),
      builder: (BuildContext context, Widget? child) {
        final stateLayerTheme = chipTheme.stateLayers.resolve(materialStates);
        return Material(
          elevation: elevation,
          shadowColor: shadowColor,
          color: widget.isElevatedChip
              ? chipTheme.containerColor.resolve(materialStates)
              : chipTheme.outlinedContainerColor.resolve(materialStates),
          animationDuration: pressedAnimationDuration,
          shape: containerBorder,
          clipBehavior: Clip.hardEdge,
          child: DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: containerDecoration,
            child: InkWell(
              onFocusChange: updateMaterialState(MaterialState.focused),
              focusNode: widget.focusNode,
              autofocus: widget.autofocus,
              canRequestFocus: widget.isEnabled,
              onTap: canTap ? _handleTap : null,
              onTapDown: canTap ? _handleTapDown : null,
              onTapCancel: canTap ? _handleTapCancel : null,
              onHover:
                  canTap ? updateMaterialState(MaterialState.hovered) : null,
              focusColor: stateLayerTheme.focusColor,
              hoverColor: stateLayerTheme.hoverColor,
              splashColor: stateLayerTheme.pressColor,
              customBorder: containerBorder,
              child: SizedBox(
                height: chipTheme.containerHeight,
                child: Row(
                  children: [
                    AnimatedSize(
                      duration: _kWidthChangeDuration,
                      child: leading,
                    ),
                    AnimatedSize(
                      duration: _kWidthChangeDuration,
                      child: label,
                    ),
                    AnimatedSize(
                      duration: _kWidthChangeDuration,
                      child: trailing,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    result = RedirectingHitDetectionWidget(
      visualDensity: chipTheme.visualDensity,
      materialTapTargetSize: chipTheme.materialTapTargetSize,
      widgetBox: Size(double.infinity, chipTheme.containerHeight),
      child: result,
    );
    return Semantics(
      button: widget.tapEnabled,
      container: true,
      selected: widget.isSelected,
      enabled: widget.tapEnabled ? canTap : null,
      child: result,
    );
  }
}

class _UnconstrainedInkSplashFactory extends InteractiveInkFeatureFactory {
  const _UnconstrainedInkSplashFactory(this.parentFactory);

  final InteractiveInkFeatureFactory parentFactory;

  @override
  InteractiveInkFeature create({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required Offset position,
    required Color color,
    required TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
  }) {
    return parentFactory.create(
      controller: controller,
      referenceBox: referenceBox,
      position: position,
      color: color,
      rectCallback: rectCallback,
      borderRadius: borderRadius,
      customBorder: customBorder,
      radius: radius,
      onRemoved: onRemoved,
      textDirection: textDirection,
    );
  }
}

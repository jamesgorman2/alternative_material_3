// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../material_state.dart';
import '../scaffold.dart';
import '../tooltip.dart';
import 'button.dart';

class _DefaultHeroTag {
  const _DefaultHeroTag();

  @override
  String toString() => '<default FloatingActionButton tag>';
}

/// A Material Design floating action button.
///
/// A floating action button is a circular icon button that hovers over content
/// to promote a primary action in the application. Floating action buttons are
/// most commonly used in the [Scaffold.floatingActionButton] field.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=2uaoEDOgk_I}
///
/// Use at most a single floating action button per screen. Floating action
/// buttons should be used for positive actions such as "create", "share", or
/// "navigate". (If more than one floating action button is used within a
/// [Route], then make sure that each button has a unique [heroTag], otherwise
/// an exception will be thrown.)
///
/// If the [onPressed] callback is null, then the button will be disabled and
/// will not react to touch. It is highly discouraged to disable a floating
/// action button as there is no indication to the user that the button is
/// disabled. Consider changing the [backgroundColor] if disabling the floating
/// action button.
///
/// {@tool dartpad}
/// This example shows how to display a [FloatingActionButton] in a
/// [Scaffold], with a pink [backgroundColor] and a thumbs up [Icon].
///
/// ![](https://flutter.github.io/assets-for-api-docs/assets/material/floating_action_button.png)
///
/// ** See code in examples/api/lib/material/floating_action_button/floating_action_button.0.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This example shows how to make an extended [FloatingActionButton] in a
/// [Scaffold], with a pink [backgroundColor], a thumbs up [Icon] and a
/// [Text] label that reads "Approve".
///
/// ![](https://flutter.github.io/assets-for-api-docs/assets/material/floating_action_button_label.png)
///
/// ** See code in examples/api/lib/material/floating_action_button/floating_action_button.1.dart **
/// {@end-tool}
///
/// Material Design 3 introduced new types of floating action buttons.
/// {@tool dartpad}
/// This sample shows the creation of [FloatingActionButton] widget in the typical location in a Scaffold,
/// as described in: https://m3.material.io/components/floating-action-button/overview
///
/// ** See code in examples/api/lib/material/floating_action_button/floating_action_button.2.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This sample shows the creation of all the variants of [FloatingActionButton] widget as
/// described in: https://m3.material.io/components/floating-action-button/overview
///
/// ** See code in examples/api/lib/material/floating_action_button/floating_action_button.3.dart **
/// {@end-tool}
///
/// See also:
///
///  * [Scaffold], in which floating action buttons typically live.
///  * [ElevatedButton], a filled button whose material elevates when pressed.
///  * <https://material.io/design/components/buttons-floating-action-button.html>
///  * <https://m3.material.io/components/floating-action-button>
class FloatingActionButton extends StatelessWidget {
  /// Creates a circular floating action button.
  ///
  /// The [mini] and [clipBehavior] arguments must not be null. Additionally,
  /// [elevation], [highlightElevation], and [disabledElevation] (if specified)
  /// must be non-negative.
  const FloatingActionButton({
    super.key,
    required Widget this.icon,
    this.theme,
    this.colorTheme = FloatingActionButtonColorTheme.primary,
    this.height = FloatingActionButtonHeight.regular,
    this.tooltip,
    this.heroTag = const _DefaultHeroTag(),
    required this.onPressed,
    this.focusNode,
    this.autofocus = false,
    FloatingActionButtonType type = FloatingActionButtonType.regular,
  })  : _floatingActionButtonType = type,
        label = null;

  /// Creates a small circular floating action button.
  ///
  /// This constructor overrides the default size constraints of the floating
  /// action button.
  ///
  /// The [clipBehavior] and [autofocus] arguments must not be null.
  /// Additionally, [elevation], [focusElevation], [hoverElevation],
  /// [highlightElevation], and [disabledElevation] (if specified) must be
  /// non-negative.
  const FloatingActionButton.small({
    super.key,
    required Widget this.icon,
    this.theme,
    this.colorTheme = FloatingActionButtonColorTheme.primary,
    this.height = FloatingActionButtonHeight.regular,
    this.tooltip,
    this.heroTag = const _DefaultHeroTag(),
    required this.onPressed,
    this.focusNode,
    this.autofocus = false,
  })  : _floatingActionButtonType = FloatingActionButtonType.small,
        label = null;

  /// Creates a wider [StadiumBorder]-shaped floating action button with
  /// an optional [icon] and a [label].
  ///
  /// The [label], [autofocus], and [clipBehavior] arguments must not be null.
  /// Additionally, [elevation], [highlightElevation], and [disabledElevation]
  /// (if specified) must be non-negative.
  ///
  /// See also:
  ///  * <https://m3.material.io/components/extended-fab>
  const FloatingActionButton.extended({
    super.key,
    this.icon,
    this.label,
    this.theme,
    this.colorTheme = FloatingActionButtonColorTheme.primary,
    this.height = FloatingActionButtonHeight.regular,
    this.tooltip,
    this.heroTag = const _DefaultHeroTag(),
    required this.onPressed,
    this.focusNode,
    this.autofocus = false,
  }) : _floatingActionButtonType = label != null
            ? FloatingActionButtonType.extended
            : FloatingActionButtonType.regular;

  /// Creates a large circular floating action button.
  ///
  /// This constructor overrides the default size constraints of the floating
  /// action button.
  ///
  /// The [clipBehavior] and [autofocus] arguments must not be null.
  /// Additionally, [elevation], [focusElevation], [hoverElevation],
  /// [highlightElevation], and [disabledElevation] (if specified) must be
  /// non-negative.
  const FloatingActionButton.large({
    super.key,
    required Widget this.icon,
    this.theme,
    this.colorTheme = FloatingActionButtonColorTheme.primary,
    this.height = FloatingActionButtonHeight.regular,
    this.tooltip,
    this.heroTag = const _DefaultHeroTag(),
    required this.onPressed,
    this.focusNode,
    this.autofocus = false,
  })  : _floatingActionButtonType = FloatingActionButtonType.large,
        label = null;

  /// The widget below this widget in the tree.
  ///
  /// Typically an [Icon].
  final Widget? icon;

  /// Override FAB theme properties.
  final FloatingActionButtonThemeData? theme;

  /// Defines the default palette for the FAB. Can be overridden
  /// by specific settings in the theme.
  ///
  /// The default is [FloatingActionButtonColorTheme.primary].
  final FloatingActionButtonColorTheme colorTheme;

  /// The elevation model of the FAB.
  ///
  /// Default value is [FloatingActionButtonHeight.regular];
  final FloatingActionButtonHeight height;

  /// Text that describes the action that will occur when the button is pressed.
  ///
  /// This text is displayed when the user long-presses on the button and is
  /// used for accessibility.
  final String? tooltip;

  /// The tag to apply to the button's [Hero] widget.
  ///
  /// Defaults to a tag that matches other floating action buttons.
  ///
  /// Set this to null explicitly if you don't want the floating action button to
  /// have a hero tag.
  ///
  /// If this is not explicitly set, then there can only be one
  /// [FloatingActionButton] per route (that is, per screen), since otherwise
  /// there would be a tag conflict (multiple heroes on one route can't have the
  /// same tag). The Material Design specification recommends only using one
  /// floating action button per screen.
  final Object? heroTag;

  /// The callback that is called when the button is tapped or otherwise activated.
  ///
  /// If this is set to null, the button will be disabled.
  final VoidCallback? onPressed;

  /// True if this is an "extended" floating action button.
  ///
  /// Typically [extended] buttons have a [StadiumBorder] [shape]
  /// and have been created with the [FloatingActionButton.extended]
  /// constructor.
  ///
  /// The [Scaffold] animates the appearance of ordinary floating
  /// action buttons with scale and rotation transitions. Extended
  /// floating action buttons are scaled and faded in.
  bool get isExtended => label != null;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  final FloatingActionButtonType _floatingActionButtonType;

  /// {@macro alternative_material_3.button.label}
  final Widget? label;

  @override
  Widget build(BuildContext context) {
    final FloatingActionButtonThemeData fabTheme =
        FloatingActionButtonThemeData.resolve(
      context,
      type: _floatingActionButtonType,
      colorTheme: colorTheme,
      height: height,
      currentContextTheme: theme,
    );

    final ButtonStyle buttonStyle = ButtonStyle(
      containerColor: MaterialStateProperty.all(fabTheme.backgroundColor),
      labelColor: MaterialStateProperty.all(fabTheme.foregroundColor),
      labelStyle: fabTheme.extendedTextStyle,
      stateTheme: fabTheme.stateTheme,
      stateLayers: MaterialStateProperty.all(fabTheme.stateLayers),
      elevation: fabTheme.elevation,
      iconSize: fabTheme.iconSize,
      iconPadding:
          _floatingActionButtonType != FloatingActionButtonType.extended
              ? (fabTheme.sizeConstraints.minWidth - fabTheme.iconSize) / 2.0
              : fabTheme.extendedIconPadding,
      internalPadding: fabTheme.extendedIconLabelSpacing,
      labelPadding: fabTheme.extendedLabelPadding,
      containerShape: fabTheme.shape,
      animationDuration: fabTheme.animationDuration,
      containerHeight: fabTheme.sizeConstraints.minHeight,
      minimumContainerWidth: fabTheme.sizeConstraints.minWidth,
      maximumContainerWidth: fabTheme.sizeConstraints.maxWidth,
      enableFeedback: fabTheme.enableFeedback,
      mouseCursor: fabTheme.mouseCursor,
      shadowColor: fabTheme.shadowColor,
      tapTargetSize: fabTheme.materialTapTargetSize,
      splashFactory: fabTheme.splashFactory,
    ).withContext(context);

    Widget result = _FabButtonStyleButton(
      onPressed: onPressed,
      icon: icon,
      label: label,
      clipBehavior: fabTheme.clipBehavior,
      focusNode: focusNode,
      autofocus: autofocus,
      style: buttonStyle,
    );

    if (tooltip != null) {
      result = Tooltip(
        message: tooltip,
        child: result,
      );
    }

    if (heroTag != null) {
      result = Hero(
        tag: heroTag!,
        child: result,
      );
    }

    return MergeSemantics(child: result);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback>('onPressed', onPressed,
        ifNull: 'disabled'));
    properties.add(StringProperty('tooltip', tooltip, defaultValue: null));
    properties
        .add(ObjectFlagProperty<Object>('heroTag', heroTag, ifPresent: 'hero'));
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode,
        defaultValue: null));
  }
}

@immutable
class _FabButtonStyleButton extends ButtonStyleButton {
  const _FabButtonStyleButton({
    required super.onPressed,
    required super.label,
    required super.icon,
    required super.clipBehavior,
    required super.autofocus,
    required super.focusNode,
    required this.style,
  });

  final ButtonStyle style;

  @override
  ButtonStyle resolveStyle(BuildContext context) {
    return style;
  }
}

/// A [FloatingActionButton] that listens to scroll events and
/// hides the label when the top level scrolls down.
class ExpandingFloatingActionButton extends StatefulWidget {
  /// Create a new expanding FAB
  const ExpandingFloatingActionButton({
    super.key,
    this.expandAbove = 56.0,
    this.expandAndContractVelocity = 200.0,
    this.icon,
    this.theme,
    this.colorTheme = FloatingActionButtonColorTheme.primary,
    this.height = FloatingActionButtonHeight.regular,
    this.tooltip,
    this.heroTag = const _DefaultHeroTag(),
    required this.onPressed,
    this.focusNode,
    this.autofocus = false,
    required this.label,
  });

  /// The height above which the FAB must be expanded.
  ///
  /// The default value is 56;
  final double expandAbove;

  /// The when this scroll velocity in dps per seconds
  /// is exceeded in the downwards direction
  /// the FAB will contract if the scroll is below [expandAbove].
  /// The when this scroll velocity is exceeded in the upwards direction
  /// the FAB will expand.
  ///
  /// The default value is 150.
  final double expandAndContractVelocity;

  /// The widget below this widget in the tree.
  ///
  /// Typically an [Icon].
  final Widget? icon;

  /// Override FAB theme properties.
  final FloatingActionButtonThemeData? theme;

  /// Defines the default palette for the FAB. Can be overridden
  /// by specific settings in the theme.
  ///
  /// The default is [FloatingActionButtonColorTheme.primary].
  final FloatingActionButtonColorTheme colorTheme;

  /// The elevation model of the FAB.
  ///
  /// Default value is [FloatingActionButtonHeight.regular];
  final FloatingActionButtonHeight height;

  /// Text that describes the action that will occur when the button is pressed.
  ///
  /// This text is displayed when the user long-presses on the button and is
  /// used for accessibility.
  final String? tooltip;

  /// The tag to apply to the button's [Hero] widget.
  ///
  /// Defaults to a tag that matches other floating action buttons.
  ///
  /// Set this to null explicitly if you don't want the floating action button to
  /// have a hero tag.
  ///
  /// If this is not explicitly set, then there can only be one
  /// [FloatingActionButton] per route (that is, per screen), since otherwise
  /// there would be a tag conflict (multiple heroes on one route can't have the
  /// same tag). The Material Design specification recommends only using one
  /// floating action button per screen.
  final Object? heroTag;

  /// The callback that is called when the button is tapped or otherwise activated.
  ///
  /// If this is set to null, the button will be disabled.
  final VoidCallback? onPressed;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// The label to display when the FAB is expanded
  final Widget label;

  @override
  State<ExpandingFloatingActionButton> createState() =>
      _ExpandingFloatingActionButtonState();
}

class _ExpandingFloatingActionButtonState
    extends State<ExpandingFloatingActionButton> {
  ScrollNotificationObserverState? _scrollNotificationObserver;
  bool isExtended = true;

  double? lastScrollPixels;
  DateTime? lastScrollNotificationTimestamp;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollNotificationObserver?.removeListener(_handleScrollNotification);
    _scrollNotificationObserver = ScrollNotificationObserver.maybeOf(context);
    _scrollNotificationObserver?.addListener(_handleScrollNotification);
  }

  @override
  void dispose() {
    if (_scrollNotificationObserver != null) {
      _scrollNotificationObserver!.removeListener(_handleScrollNotification);
      _scrollNotificationObserver = null;
    }
    super.dispose();
  }

  double _velocityOf(ScrollNotification notification) {
    final ScrollMetrics metrics = notification.metrics;
    final timestamp = DateTime.timestamp();

    final double? startPixels = lastScrollPixels;
    final double endPixels = metrics.axisDirection == AxisDirection.up
        ? metrics.extentAfter
        : metrics.extentBefore;
    final DateTime? startTimestamp = lastScrollNotificationTimestamp;
    final DateTime endTimestamp = timestamp;

    if (notification is ScrollUpdateNotification) {
      if (startPixels == null || startTimestamp == null) {
        lastScrollPixels = endPixels;
        lastScrollNotificationTimestamp = endTimestamp;
      } else {
        final double seconds =
            endTimestamp.difference(startTimestamp).inMicroseconds / 1000000.0;
        final double pixels = endPixels - startPixels;
        if (seconds > 0.005) {
          // longer sample time to reduce jitter
          lastScrollPixels = endPixels;
          lastScrollNotificationTimestamp = endTimestamp;
          return pixels / seconds;
        } else {
          return 0.0;
        }
      }
    }
    return 0.0;
  }

  void _handleScrollNotification(ScrollNotification notification) {
    final isTopLevelScroll = defaultScrollNotificationPredicate(notification);
    final ScrollMetrics metrics = notification.metrics;
    if (!isTopLevelScroll ||
        notification is! ScrollUpdateNotification ||
        metrics.axisDirection == AxisDirection.right ||
        metrics.axisDirection == AxisDirection.left) {
      // Scrolled under is only supported in the vertical axis, and should
      // not be altered based on horizontal notifications of the same
      // predicate since it could be a 2D scroller.
      return;
    }

    bool isInForcedExpansionRange = metrics.axisDirection == AxisDirection.up
        ? metrics.extentAfter <= widget.expandAbove
        : metrics.extentBefore <= widget.expandAbove;
    final bool oldIsExtended = isExtended;

    if (isInForcedExpansionRange) {
      isExtended = true;
    } else {
      final double velocity = _velocityOf(notification);
      if (velocity > widget.expandAndContractVelocity) {
        isExtended = false;
      } else if (velocity < -widget.expandAndContractVelocity) {
        isExtended = true;
      }
    }

    if (isExtended != oldIsExtended) {
      setState(() {
        // React to a change in MaterialState.scrolledUnder
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      icon: widget.icon,
      theme: widget.theme,
      colorTheme: widget.colorTheme,
      height: widget.height,
      tooltip: widget.tooltip,
      heroTag: widget.heroTag,
      onPressed: widget.onPressed,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      label: isExtended ? widget.label : null,
    );
  }
}

// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import '../disabled.dart';
import '../ink_well.dart';
import '../material.dart';
import '../material_state.dart';
import '../no_splash.dart';
import '../state_theme.dart';
import 'card_theme.dart';

/// A Material Design card.
///
/// A card is a sheet of [Material] used to represent some related information,
/// for example an album, a geographical location, a meal, contact details, etc.
///
/// See also:
///
///  * [showDialog], to display a modal card.
///  * <https://m3.material.io/components/cards>
abstract class Card extends StatefulWidget {
  /// Creates a Material Design card.
  const Card({
    super.key,
    this.theme,
    bool enabled = true,
    this.interactive = false,
    this.borderOnForeground = true,
    this.semanticContainer = true,
    this.ignoreSemanticsWhenDisabled = true,
    this.focusNode,
    this.autofocus = false,
    this.statesController,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.child,
  }) : enabled = enabled &&
            (!interactive || onPressed != null || onLongPress != null);

  /// [CardThemeData] that only apply to this card.
  final CardThemeData? theme;

  /// Is the card enabled. The default value is true.
  final bool enabled;

  /// Is this card interactive. If if true the card will respond to
  /// tap, hover focus, etc state events when the one of [onPressed]
  /// or [onLongPress] are present.
  ///
  /// The default value is false.
  final bool interactive;

  /// {@template alternative_material_3.card.onPressed}
  /// An optional call-back when the card is tapped or otherwise activated.
  ///
  /// If this callback and [onLongPress] are null, then the button will be disabled.
  ///
  /// See also:
  ///
  ///  * [enabled], which is true if the button is enabled.
  /// {@endtemplate}
  final VoidCallback? onPressed;

  /// {@template alternative_material_3.card.onLongPress}
  /// An optional call-back when the card is long-pressed.
  ///
  /// If this callback and [onPressed] are null, then the button will be disabled.
  ///
  /// See also:
  ///
  ///  * [enabled], which is true if the button is enabled.
  /// {@endtemplate}
  final VoidCallback? onLongPress;

  /// {@template alternative_material_3.card.onHover}
  /// Called when a pointer enters or exits the button response area.
  ///
  /// The value passed to the callback is true if a pointer has entered this
  /// part of the material and false if a pointer has exited this part of the
  /// material.
  /// {@endtemplate}
  final ValueChanged<bool>? onHover;

  /// {@template alternative_material_3.card.onFocusChange}
  /// Handler called when the focus changes.
  ///
  /// Called with true if this widget's node gains focus, and false if it loses
  /// focus.
  /// {@endtemplate}
  final ValueChanged<bool>? onFocusChange;

  /// Whether to paint the [shape] border in front of the [child].
  ///
  /// The default value is true.
  /// If false, the border will be painted behind the [child].
  final bool borderOnForeground;

  /// Whether this widget represents a single semantic container, or if false
  /// a collection of individual semantic nodes.
  ///
  /// Defaults to true.
  ///
  /// Setting this flag to true will attempt to merge all child semantics into
  /// this node. Setting this flag to false will force all child semantic nodes
  /// to be explicit.
  ///
  /// This flag should be false if the card contains multiple different types
  /// of content.
  final bool semanticContainer;

  /// {@macro alternative_material_3.disabled.ignoringSemantics}
  final bool ignoreSemanticsWhenDisabled;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// {@macro flutter.material.inkwell.statesController}
  final MaterialStatesController? statesController;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  /// True if the card has a focus node and is focussed.
  bool get isFocussed => focusNode?.hasFocus ?? false;

  @protected
  CardThemeData resolveTheme(BuildContext context, CardThemeData? theme);

  @override
  State<Card> createState() => _CardState();
}

class _CardState extends State<Card> with TickerProviderStateMixin {
  MaterialStatesController? internalStatesController;

  MaterialStatesController get statesController =>
      widget.statesController ?? internalStatesController!;

  void handleStatesControllerChange() {
    // Force a rebuild to resolve MaterialStateProperty properties
    setState(() {});
  }

  void handleFocusChanged() {
    statesController.update(MaterialState.focused, widget.isFocussed);
  }

  @override
  void initState() {
    super.initState();
    initStatesController();
    widget.focusNode?.addListener(handleFocusChanged);
  }

  void initStatesController() {
    if (widget.statesController == null) {
      internalStatesController = MaterialStatesController();
    }
    final disabled = widget.interactive
        ? !widget.enabled ||
            widget.onPressed == null ||
            widget.onLongPress == null
        : !widget.enabled;
    statesController.update(MaterialState.disabled, disabled);
    statesController.update(MaterialState.focused, widget.isFocussed);
    statesController.addListener(handleStatesControllerChange);
  }

  @override
  void didUpdateWidget(Card oldWidget) {
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
    if (widget.isFocussed != oldWidget.isFocussed) {
      statesController.update(MaterialState.focused, widget.isFocussed);
    }
  }

  @override
  void dispose() {
    statesController.removeListener(handleStatesControllerChange);
    internalStatesController?.dispose();
    widget.focusNode?.removeListener(handleFocusChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CardThemeData cardTheme = widget.resolveTheme(context, widget.theme);
    final Set<MaterialState> states = statesController.value;

    Widget interactive({required Widget child}) {
      if (widget.interactive) {
        return InkWell(
          onTap: widget.enabled ? widget.onPressed : null,
          onLongPress: widget.enabled ? widget.onLongPress : null,
          onHover: widget.onHover,
          mouseCursor: (widget.interactive
                  ? cardTheme.interactiveMouseCursor
                  : cardTheme.defaultMouseCursor)
              .resolve(states),
          enableFeedback: cardTheme.enableFeedback,
          focusNode: widget.focusNode,
          canRequestFocus: widget.enabled && widget.focusNode != null,
          splashFactory: widget.interactive
              ? cardTheme.splashFactory
              : NoSplash.splashFactory,
          autofocus: widget.autofocus,
          statesController: statesController,
          customBorder: cardTheme.shape,
          overlayColor: widget.interactive
              ? cardTheme.stateLayers
              : StateLayerColors.none,
          child: child,
        );
      }
      return child;
    }

    return Semantics(
      container: widget.semanticContainer,
      child: Material(
        type: MaterialType.card,
        color: cardTheme.color.resolve(states),
        shadowColor: cardTheme.shadowColor,
        elevation: cardTheme.elevation.resolve(states),
        shape: cardTheme.shape.copyWith(
          side: cardTheme.outline.resolve(states),
        ),
        borderOnForeground: widget.borderOnForeground,
        clipBehavior: cardTheme.clipBehavior,
        child: interactive(
          child: Semantics(
            explicitChildNodes: !widget.semanticContainer,
            child: Disabled(
              isDisabled: !widget.enabled,
              ignoringSemantics: widget.ignoreSemanticsWhenDisabled,
              child: widget.child ?? const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}

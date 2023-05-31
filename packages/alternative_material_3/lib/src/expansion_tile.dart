// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'colors.dart';
import 'divider.dart';
import 'expansion_tile_theme.dart';
import 'icons.dart';
import 'list_tile.dart';
import 'list_tile_element.dart';
import 'list_tile_theme.dart';
import 'material.dart';

const Duration _kExpand = Duration(milliseconds: 200);

/// Enables control over a single [ExpansionTile]'s expanded/collapsed state.
///
/// It can be useful to expand or collapse an [ExpansionTile]
/// programatically, for example to reconfigure an existing expansion
/// tile based on a system event. To do so, create an [ExpansionTile]
/// with an [ExpansionTileController] that's owned by a stateful widget
/// or look up the tile's automatically created [ExpansionTileController]
/// with [ExpansionTileController.of]
///
/// The controller's [expand] and [collapse] methods cause the
/// the [ExpansionTile] to rebuild, so they may not be called from
/// a build method.
class ExpansionTileController {
  /// Create a controller to be used with [ExpansionTile.controller].
  ExpansionTileController();

  _ExpansionTileState? _state;

  /// Whether the [ExpansionTile] built with this controller is in expanded state.
  ///
  /// This property doesn't take the animation into account. It reports `true`
  /// even if the expansion animation is not completed.
  ///
  /// See also:
  ///
  ///  * [expand], which expands the [ExpansionTile].
  ///  * [collapse], which collapses the [ExpansionTile].
  ///  * [ExpansionTile.controller] to create an ExpansionTile with a controller.
  bool get isExpanded {
    assert(_state != null);
    return _state!._isExpanded;
  }

  /// Expands the [ExpansionTile] that was built with this controller;
  ///
  /// Normally the tile is expanded automatically when the user taps on the header.
  /// It is sometimes useful to trigger the expansion programmatically due
  /// to external changes.
  ///
  /// If the tile is already in the expanded state (see [isExpanded]), calling
  /// this method has no effect.
  ///
  /// Calling this method may cause the [ExpansionTile] to rebuild, so it may
  /// not be called from a build method.
  ///
  /// Calling this method will trigger an [ExpansionTile.onExpansionChangeStart] callback.
  ///
  /// See also:
  ///
  ///  * [collapse], which collapses the tile.
  ///  * [isExpanded] to check whether the tile is expanded.
  ///  * [ExpansionTile.controller] to create an ExpansionTile with a controller.
  void expand() {
    assert(_state != null);
    if (!isExpanded) {
      _state!._toggleExpansion();
    }
  }

  /// Collapses the [ExpansionTile] that was built with this controller.
  ///
  /// Normally the tile is collapsed automatically when the user taps on the header.
  /// It can be useful sometimes to trigger the collapse programmatically due
  /// to some external changes.
  ///
  /// If the tile is already in the collapsed state (see [isExpanded]), calling
  /// this method has no effect.
  ///
  /// Calling this method may cause the [ExpansionTile] to rebuild, so it may
  /// not be called from a build method.
  ///
  /// Calling this method will trigger an [ExpansionTile.onExpansionChangeStart] callback.
  ///
  /// See also:
  ///
  ///  * [expand], which expands the tile.
  ///  * [isExpanded] to check whether the tile is expanded.
  ///  * [ExpansionTile.controller] to create an ExpansionTile with a controller.
  void collapse() {
    assert(_state != null);
    if (isExpanded) {
      _state!._toggleExpansion();
    }
  }

  /// Finds the [ExpansionTileController] for the closest [ExpansionTile] instance
  /// that encloses the given context.
  ///
  /// If no [ExpansionTile] encloses the given context, calling this
  /// method will cause an assert in debug mode, and throw an
  /// exception in release mode.
  ///
  /// To return null if there is no [ExpansionTile] use [maybeOf] instead.
  ///
  /// {@tool dartpad}
  /// Typical usage of the [ExpansionTileController.of] function is to call it from within the
  /// `build` method of a descendant of an [ExpansionTile].
  ///
  /// When the [ExpansionTile] is actually created in the same `build`
  /// function as the callback that refers to the controller, then the
  /// `context` argument to the `build` function can't be used to find
  /// the [ExpansionTileController] (since it's "above" the widget
  /// being returned in the widget tree). In cases like that you can
  /// add a [Builder] widget, which provides a new scope with a
  /// [BuildContext] that is "under" the [ExpansionTile]:
  ///
  /// ** See code in examples/api/lib/material/expansion_tile/expansion_tile.1.dart **
  /// {@end-tool}
  ///
  /// A more efficient solution is to split your build function into
  /// several widgets. This introduces a new context from which you
  /// can obtain the [ExpansionTileController]. With this approach you
  /// would have an outer widget that creates the [ExpansionTile]
  /// populated by instances of your new inner widgets, and then in
  /// these inner widgets you would use [ExpansionTileController.of].
  static ExpansionTileController of(BuildContext context) {
    final _ExpansionTileState? result =
        context.findAncestorStateOfType<_ExpansionTileState>();
    if (result != null) {
      return result._tileController;
    }
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
        'ExpansionTileController.of() called with a context that does not contain a ExpansionTile.',
      ),
      ErrorDescription(
        'No ExpansionTile ancestor could be found starting from the context that was passed to ExpansionTileController.of(). '
        'This usually happens when the context provided is from the same StatefulWidget as that '
        'whose build function actually creates the ExpansionTile widget being sought.',
      ),
      ErrorHint(
        'There are several ways to avoid this problem. The simplest is to use a Builder to get a '
        'context that is "under" the ExpansionTile. For an example of this, please see the '
        'documentation for ExpansionTileController.of():\n'
        '  https://api.flutter.dev/flutter/material/ExpansionTile/of.html',
      ),
      ErrorHint(
        'A more efficient solution is to split your build function into several widgets. This '
        'introduces a new context from which you can obtain the ExpansionTile. In this solution, '
        'you would have an outer widget that creates the ExpansionTile populated by instances of '
        'your new inner widgets, and then in these inner widgets you would use ExpansionTileController.of().\n'
        'An other solution is assign a GlobalKey to the ExpansionTile, '
        'then use the key.currentState property to obtain the ExpansionTile rather than '
        'using the ExpansionTileController.of() function.',
      ),
      context.describeElement('The context used was'),
    ]);
  }

  /// Finds the [ExpansionTile] from the closest instance of this class that
  /// encloses the given context and returns its [ExpansionTileController].
  ///
  /// If no [ExpansionTile] encloses the given context then return null.
  /// To throw an exception instead, use [of] instead of this function.
  ///
  /// See also:
  ///
  ///  * [of], a similar function to this one that throws if no [ExpansionTile]
  ///    encloses the given context. Also includes some sample code in its
  ///    documentation.
  static ExpansionTileController? maybeOf(BuildContext context) {
    return context
        .findAncestorStateOfType<_ExpansionTileState>()
        ?._tileController;
  }
}

/// A single-line [ListTile] with an expansion arrow icon that expands or collapses
/// the tile to reveal or hide the [child].
///
/// This widget is typically used with [ListView] to create an
/// "expand / collapse" list entry. When used with scrolling widgets like
/// [ListView], a unique [PageStorageKey] must be specified to enable the
/// [ExpansionTile] to save and restore its expanded state when it is scrolled
/// in and out of view.
///
/// This class overrides the [ListTileThemeData.expandedIconColor] and [ListTileThemeData.headlineColor]
/// theme properties for its [ListTile]. These colors animate between values when
/// the tile is expanded and collapsed: between [expandedIconColor], [collapsedIconColor] and
/// between [expandedHeadlineColor] and [collapsedHeadlineColor].
///
/// The expansion arrow icon is shown on the right by default in left-to-right languages
/// (i.e. the trailing edge). This can be changed using [controlAffinity]. This maps
/// to the [leading] and [trailing] properties of [ExpansionTile].
///
/// {@tool dartpad}
/// This example demonstrates how the [ExpansionTile] icon's location and appearance
/// can be customized.
///
/// ** See code in examples/api/lib/material/expansion_tile/expansion_tile.0.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This example demonstrates how an [ExpansionTileController] can be used to
/// programatically expand or collapse an [ExpansionTile].
///
/// ** See code in examples/api/lib/material/expansion_tile/expansion_tile.1.dart **
/// {@end-tool}
///
/// See also:
///
///  * [ListTile], useful for creating expansion tile [child] when the
///    expansion tile represents a sublist.
///  * The "Expand and collapse" section of
///    <https://material.io/components/lists#types>
class ExpansionTile extends StatefulWidget {
  /// Creates a single-line [ListTile] with an expansion arrow icon that expands or collapses
  /// the tile to reveal or hide the [child]. The [initiallyExpanded] property must
  /// be non-null.
  const ExpansionTile({
    super.key,
    this.theme,
    this.listTileTheme,
    this.layout,
    this.overline,
    this.headline,
    this.supportingText,
    this.onExpansionChangeStart,
    this.onExpansionChangeComplete,
    required this.child,
    this.secondary,
    this.initiallyExpanded = false,
    this.maintainState = false,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.controller,
  }) : assert(layout == null ||
            layout == ListTileLayout.threeLine ||
            (layout == ListTileLayout.oneLine &&
                overline == null &&
                supportingText == null) ||
            (layout == ListTileLayout.twoLine &&
                (overline == null || supportingText == null)));

  /// ExpansionTileThemeData overrides that only apply to this expansion tile.
  final ExpansionTileThemeData? theme;

  /// ListTileThemeData overrides that only apply to this expansion tile.
  final ListTileThemeData? listTileTheme;

  /// The line layout of the [ListTile]. When no layout is passed in during
  /// construction the value will be calculated base on the presence
  /// or absence of [overline] and [supportingText], and the length of
  /// [supportingText].
  final ListTileLayout? layout;

  /// Typically a [Text] widget.
  final Widget? overline;

  /// The primary content of the list item.
  ///
  /// Typically a [Text] widget.
  final Widget? headline;

  /// Additional content displayed below the title.
  ///
  /// Typically a [Text] widget.
  final Widget? supportingText;

  /// Called when the tile expands or collapses.
  ///
  /// When the tile starts expanding, this function is called with the value
  /// true. When the tile starts collapsing, this function is called with
  /// the value false.
  final ValueChanged<bool>? onExpansionChangeStart;

  /// Called when the tile expands or collapses. This will only be calle if
  /// the animation is not cancelled.
  ///
  /// When the tile completes expanding, this function is called with the value
  /// true. When the tile completes collapsing, this function is called with
  /// the value false.
  final ValueChanged<bool>? onExpansionChangeComplete;

  /// The widget that is displayed when the tile expands.
  final Widget child;

  /// A widget to display on the opposite side of the tile from the expansion icon.
  final ListTileElement? secondary;

  /// Specifies if the list tile is initially expanded (true) or collapsed (false, the default).
  final bool initiallyExpanded;

  /// Specifies whether the state of the children is maintained when the tile expands and collapses.
  ///
  /// When true, the children are kept in the tree while the tile is collapsed.
  /// When false (default), the children are removed from the tree when the tile is
  /// collapsed and recreated upon expansion.
  final bool maintainState;

  /// Typically used to force the expansion arrow icon to the tile's leading or trailing edge.
  ///
  /// By default, the value of [controlAffinity] is [ListTileControlAffinity.platform],
  /// which means that the expansion arrow icon will appear on the tile's trailing edge.
  final ListTileControlAffinity controlAffinity;

  /// If provided, the controller can be used to expand and collapse tiles.
  ///
  /// In cases were control over the tile's state is needed from a callback triggered
  /// by a widget within the tile, [ExpansionTileController.of] may be more convenient
  /// than supplying a controller.
  final ExpansionTileController? controller;

  @override
  State<ExpansionTile> createState() => _ExpansionTileState();
}

class _ExpansionTileState extends State<ExpansionTile>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween =
      CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  final ShapeBorderTween _borderTween = ShapeBorderTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  late AnimationController _animationController;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  late Animation<ShapeBorder?> _border;
  late Animation<Color?> _headerColor;
  late Animation<Color?> _iconColor;
  late Animation<Color?> _backgroundColor;

  bool _isExpanded = false;
  late ExpansionTileController _tileController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _animationController.drive(_easeInTween);
    _iconTurns = _animationController.drive(_halfTween.chain(_easeInTween));
    _border = _animationController.drive(_borderTween.chain(_easeOutTween));
    _headerColor = _animationController.drive(
      _headerColorTween.chain(_easeInTween),
    );
    _iconColor = _animationController.drive(
      _iconColorTween.chain(_easeInTween),
    );
    _backgroundColor = _animationController.drive(
      _backgroundColorTween.chain(_easeOutTween),
    );

    _isExpanded = PageStorage.maybeOf(context)?.readState(context) as bool? ??
        widget.initiallyExpanded;
    if (_isExpanded) {
      _animationController.value = 1.0;
    }

    assert(widget.controller?._state == null);
    _tileController = widget.controller ?? ExpansionTileController();
    _tileController._state = this;
  }

  @override
  void dispose() {
    _tileController._state = null;
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      final isExpanded = _isExpanded;
      final tickerFuture = _isExpanded
          ? _animationController.forward()
          : _animationController.reverse().then<void>((void value) {
              if (!mounted) {
                return;
              }
              setState(() {
                // Rebuild without widget.children.
              });
            });
      tickerFuture
          .then((value) => widget.onExpansionChangeComplete?.call(isExpanded));
      PageStorage.maybeOf(context)?.writeState(context, _isExpanded);
    });
    widget.onExpansionChangeStart?.call(_isExpanded);
  }

  void _handleTap() {
    _toggleExpansion();
  }

  Widget _buildIcon() {
    return RotationTransition(
      turns: _iconTurns,
      child: const Icon(Icons.expand_more),
    );
  }

  bool _shouldAnimateDividers(ExpansionTileThemeData theme) =>
      theme.showTopDividerWhenExpanded || theme.showBottomDividerWhenExpanded;

  bool _shouldAnimateIconColor(ExpansionTileThemeData theme) =>
      theme.expandedIconColor != null || theme.collapsedIconColor != null;

  bool _shouldAnimateHeadlineColor(ExpansionTileThemeData theme) =>
      theme.expandedHeadlineColor != null ||
      theme.collapsedHeadlineColor != null;

  Widget _buildChild(BuildContext context, Widget? child) {
    final ExpansionTileThemeData expansionTileTheme =
        ExpansionTileTheme.resolve(context, widget.theme);

    final ShapeBorder expansionTileBorder = _border.value ??
        Border(
          top: Divider.createBorderSide(context, color: Colors.transparent),
          bottom: Divider.createBorderSide(context, color: Colors.transparent),
        );
    final Clip clipBehavior = expansionTileTheme.clipBehavior;

    ListTileElement? leading;
    ListTileElement? trailing;
    ListTileThemeData effectiveListTileTheme;
    switch (widget.controlAffinity) {
      case ListTileControlAffinity.leading:
        leading = ListTileElement.icon24(child: _buildIcon());
        trailing = widget.secondary;
        effectiveListTileTheme = ListTileThemeData(
          headlineColor: _shouldAnimateHeadlineColor(expansionTileTheme)
              ? _headerColor.value
              : null,
          leadingColor: _shouldAnimateIconColor(expansionTileTheme)
              ? _iconColor.value
              : null,
        );
      case ListTileControlAffinity.platform:
      case ListTileControlAffinity.trailing:
        leading = widget.secondary;
        trailing = ListTileElement.icon24(child: _buildIcon());
        effectiveListTileTheme = ListTileThemeData(
          headlineColor: _shouldAnimateHeadlineColor(expansionTileTheme)
              ? _headerColor.value
              : null,
          trailingColor: _shouldAnimateIconColor(expansionTileTheme)
              ? _iconColor.value
              : null,
        );
    }

    return Container(
      clipBehavior: clipBehavior,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: _backgroundColor.value ??
            expansionTileTheme.expandedBackgroundColor,
      ),
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: ShapeDecoration(
          shape: expansionTileBorder,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTileTheme.merge(
              data: effectiveListTileTheme,
              child: ListTile(
                theme: widget.listTileTheme,
                onTap: _handleTap,
                layout: widget.layout,
                leading: leading,
                overline: widget.overline,
                headline: widget.headline,
                supportingText: widget.supportingText,
                trailing: trailing,
              ),
            ),
            ClipRect(
              child: Align(
                alignment: expansionTileTheme.expandedAlignment,
                heightFactor: _heightFactor.value,
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final ExpansionTileThemeData expansionTileTheme =
        ExpansionTileTheme.resolve(context, widget.theme);

    if (_shouldAnimateDividers(expansionTileTheme)) {
      final BorderSide transparentBorder =
          Divider.createBorderSide(context, color: Colors.transparent);
      final BorderSide coloredBorder = Divider.createBorderSide(context);
      _borderTween
        ..begin = const Border(
          top: BorderSide(color: Colors.transparent),
          bottom: BorderSide(color: Colors.transparent),
        )
        ..end = Border(
          top: expansionTileTheme.showTopDividerWhenExpanded
              ? coloredBorder
              : transparentBorder,
          bottom: expansionTileTheme.showBottomDividerWhenExpanded
              ? coloredBorder
              : transparentBorder,
        );
    }
    if (_shouldAnimateHeadlineColor(expansionTileTheme)) {
      _headerColorTween
        ..begin = expansionTileTheme.collapsedHeadlineColor
        ..end = expansionTileTheme.expandedHeadlineColor;
    }
    if (_shouldAnimateIconColor(expansionTileTheme)) {
      print('!');
      print('expansionTileTheme.collapsedIconColor: ${expansionTileTheme.collapsedIconColor}');
      print('expansionTileTheme.expandedIconColor: ${expansionTileTheme.expandedIconColor}');
      _iconColorTween
        ..begin = expansionTileTheme.collapsedIconColor
        ..end = expansionTileTheme.expandedIconColor;
      _backgroundColorTween
        ..begin = expansionTileTheme.collapsedBackgroundColor
        ..end = expansionTileTheme.expandedBackgroundColor;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _animationController.isDismissed;
    final bool shouldRemoveChildren = closed && !widget.maintainState;

    final Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: widget.child,
      ),
    );

    return AnimatedBuilder(
      animation: _animationController.view,
      builder: _buildChild,
      child: shouldRemoveChildren ? null : result,
    );
  }
}

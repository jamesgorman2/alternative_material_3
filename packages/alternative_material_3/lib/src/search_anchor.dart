// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'button_style.dart';
import 'color_scheme.dart';
import 'colors.dart';
import 'constants.dart';
import 'divider.dart';
import 'divider_theme.dart';
import 'elevation.dart';
import 'icon_button.dart';
import 'icons.dart';
import 'ink_well.dart';
import 'input_border.dart';
import 'input_decorator.dart';
import 'material.dart';
import 'material_state.dart';
import 'search_bar_theme.dart';
import 'search_view_theme.dart';
import 'text_field.dart';
import 'text_theme.dart';
import 'theme.dart';
import 'theme_data.dart';

const int _kOpenViewMilliseconds = 600;
const Duration _kOpenViewDuration = Duration(milliseconds: _kOpenViewMilliseconds);
const Duration _kAnchorFadeDuration = Duration(milliseconds: 150);
const Curve _kViewFadeOnInterval = Interval(0.0, 1/2);
const Curve _kViewIconsFadeOnInterval = Interval(1/6, 2/6);
const Curve _kViewDividerFadeOnInterval = Interval(0.0, 1/6);
const Curve _kViewListFadeOnInterval = Interval(133 / _kOpenViewMilliseconds, 233 / _kOpenViewMilliseconds);

/// Signature for a function that creates a [Widget] which is used to open a search view.
///
/// The `controller` callback provided to [SearchAnchor.builder] can be used
/// to open the search view and control the editable field on the view.
typedef SearchAnchorChildBuilder = Widget Function(BuildContext context, SearchController controller);

/// Signature for a function that creates a [Widget] to build the suggestion list
/// based on the input in the search bar.
///
/// The `controller` callback provided to [SearchAnchor.suggestionsBuilder] can be used
/// to close the search view and control the editable field on the view.
typedef SuggestionsBuilder = Iterable<Widget> Function(BuildContext context, SearchController controller);

/// Signature for a function that creates a [Widget] to layout the suggestion list.
///
/// Parameter `suggestions` is the content list that this function wants to lay out.
typedef ViewBuilder = Widget Function(Iterable<Widget> suggestions);

/// Manages a "search view" route that allows the user to select one of the
/// suggested completions for a search query.
///
/// The search view's route can either be shown by creating a [SearchController]
/// and then calling [SearchController.openView] or by tapping on an anchor.
/// When the anchor is tapped or [SearchController.openView] is called, the search view either
/// grows to a specific size, or grows to fill the entire screen. By default,
/// the search view only shows full screen on mobile platforms. Use [SearchAnchor.isFullScreen]
/// to override the default setting.
///
/// The search view is usually opened by a [SearchBar], an [IconButton] or an [Icon].
/// If [builder] returns an Icon, or any un-tappable widgets, we don't have
/// to explicitly call [SearchController.openView].
///
/// {@tool dartpad}
/// This example shows how to use an IconButton to open a search view in a [SearchAnchor].
/// It also shows how to use [SearchController] to open or close the search view route.
///
/// ** See code in examples/api/lib/material/search_anchor/search_anchor.2.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This example shows how to set up a floating (or pinned) AppBar with a
/// [SearchAnchor] for a title.
///
/// ** See code in examples/api/lib/material/search_anchor/search_anchor.1.dart **
/// {@end-tool}
///
/// See also:
///
/// * [SearchBar], a widget that defines a search bar.
/// * [SearchBarTheme], a widget that overrides the default configuration of a search bar.
/// * [SearchViewTheme], a widget that overrides the default configuration of a search view.
class SearchAnchor extends StatefulWidget {
  /// Creates a const [SearchAnchor].
  ///
  /// The [builder] and [suggestionsBuilder] arguments are required.
  const SearchAnchor({
    super.key,
    this.isFullScreen,
    this.searchController,
    this.viewBuilder,
    this.viewLeading,
    this.viewTrailing,
    this.viewHintText,
    this.viewBackgroundColor,
    this.viewElevation,
    this.viewSurfaceTintColor,
    this.viewSide,
    this.viewShape,
    this.headerTextStyle,
    this.headerHintStyle,
    this.dividerColor,
    this.viewConstraints,
    required this.builder,
    required this.suggestionsBuilder,
  });

  /// Create a [SearchAnchor] that has a [SearchBar] which opens a search view.
  ///
  /// All the barX parameters are used to customize the anchor. Similarly, all the
  /// viewX parameters are used to override the view's defaults.
  ///
  /// {@tool dartpad}
  /// This example shows how to use a [SearchAnchor.bar] which uses a default search
  /// bar to open a search view route.
  ///
  /// ** See code in examples/api/lib/material/search_anchor/search_anchor.0.dart **
  /// {@end-tool}
  ///
  /// The [suggestionsBuilder] argument must not be null.
  factory SearchAnchor.bar({
    Widget? barLeading,
    Iterable<Widget>? barTrailing,
    String? barHintText,
    GestureTapCallback? onTap,
    MaterialStateProperty<Elevation?>? barElevation,
    MaterialStateProperty<Color?>? barBackgroundColor,
    MaterialStateProperty<Color?>? barOverlayColor,
    MaterialStateProperty<BorderSide?>? barSide,
    MaterialStateProperty<OutlinedBorder?>? barShape,
    MaterialStateProperty<EdgeInsetsGeometry?>? barPadding,
    MaterialStateProperty<TextStyle?>? barTextStyle,
    MaterialStateProperty<TextStyle?>? barHintStyle,
    Widget? viewLeading,
    Iterable<Widget>? viewTrailing,
    String? viewHintText,
    Color? viewBackgroundColor,
    Elevation? viewElevation,
    BorderSide? viewSide,
    OutlinedBorder? viewShape,
    TextStyle? viewHeaderTextStyle,
    TextStyle? viewHeaderHintStyle,
    Color? dividerColor,
    BoxConstraints? constraints,
    BoxConstraints? viewConstraints,
    bool? isFullScreen,
    SearchController searchController,
    required SuggestionsBuilder suggestionsBuilder
  }) = _SearchAnchorWithSearchBar;

  /// Whether the search view grows to fill the entire screen when the
  /// [SearchAnchor] is tapped.
  ///
  /// By default, the search view is full-screen on mobile devices. On other
  /// platforms, the search view only grows to a specific size that is determined
  /// by the anchor and the default size.
  final bool? isFullScreen;

  /// An optional controller that allows opening and closing of the search view from
  /// other widgets.
  ///
  /// If this is null, one internal search controller is created automatically
  /// and it is used to open the search view when the user taps on the anchor.
  final SearchController? searchController;

  /// Optional callback to obtain a widget to lay out the suggestion list of the
  /// search view.
  ///
  /// Default view uses a [ListView] with a vertical scroll direction.
  final ViewBuilder? viewBuilder;

  /// An optional widget to display before the text input field when the search
  /// view is open.
  ///
  /// Typically the [viewLeading] widget is an [Icon] or an [IconButton].
  ///
  /// Defaults to a back button which pops the view.
  final Widget? viewLeading;

  /// An optional widget list to display after the text input field when the search
  /// view is open.
  ///
  /// Typically the [viewTrailing] widget list only has one or two widgets.
  ///
  /// Defaults to an icon button which clears the text in the input field.
  final Iterable<Widget>? viewTrailing;

  /// Text that is displayed when the search bar's input field is empty.
  final String? viewHintText;

  /// The search view's background fill color.
  ///
  /// If null, the value of [SearchViewThemeData.backgroundColor] will be used.
  /// If this is also null, then the default value is [ColorScheme.surface].
  final Color? viewBackgroundColor;

  /// The elevation of the search view's [Material].
  ///
  /// If null, the value of [SearchViewThemeData.elevation] will be used. If this
  /// is also null, then default value is 6.0.
  final Elevation? viewElevation;

  /// The surface tint color of the search view's [Material].
  ///
  /// See [Material.surfaceTintColor] for more details.
  ///
  /// If null, the value of [SearchViewThemeData.surfaceTintColor] will be used.
  /// If this is also null, then the default value is [ColorScheme.surfaceTint].
  final Color? viewSurfaceTintColor;

  /// The color and weight of the search view's outline.
  ///
  /// This value is combined with [viewShape] to create a shape decorated
  /// with an outline. This will be ignored if the view is full-screen.
  ///
  /// If null, the value of [SearchViewThemeData.side] will be used. If this is
  /// also null, the search view doesn't have a side by default.
  final BorderSide? viewSide;

  /// The shape of the search view's underlying [Material].
  ///
  /// This shape is combined with [viewSide] to create a shape decorated
  /// with an outline.
  ///
  /// If null, the value of [SearchViewThemeData.shape] will be used.
  /// If this is also null, then the default value is a rectangle shape for full-screen
  /// mode and a [RoundedRectangleBorder] shape with a 28.0 radius otherwise.
  final OutlinedBorder? viewShape;

  /// The style to use for the text being edited on the search view.
  ///
  /// If null, defaults to the `bodyLarge` text style from the current [Theme].
  /// The default text color is [ColorScheme.onSurface].
  final TextStyle? headerTextStyle;

  /// The style to use for the [viewHintText] on the search view.
  ///
  /// If null, the value of [SearchViewThemeData.headerHintStyle] will be used.
  /// If this is also null, the value of [headerTextStyle] will be used. If this is also null,
  /// defaults to the `bodyLarge` text style from the current [Theme]. The default
  /// text color is [ColorScheme.onSurfaceVariant].
  final TextStyle? headerHintStyle;

  /// The color of the divider on the search view.
  ///
  /// If this property is null, then [SearchViewThemeData.dividerColor] is used.
  /// If that is also null, the default value is [ColorScheme.outline].
  final Color? dividerColor;

  /// Optional size constraints for the search view.
  ///
  /// By default, the search view has the same width as the anchor and is 2/3
  /// the height of the screen. If the width and height of the view are within
  /// the [viewConstraints], the view will show its default size. Otherwise,
  /// the size of the view will be constrained by this property.
  ///
  /// If null, the value of [SearchViewThemeData.constraints] will be used. If
  /// this is also null, then the constraints defaults to:
  /// ```dart
  /// const BoxConstraints(minWidth: 360.0, minHeight: 240.0)
  /// ```
  final BoxConstraints? viewConstraints;

  /// Called to create a widget which can open a search view route when it is tapped.
  ///
  /// The widget returned by this builder is faded out when it is tapped.
  /// At the same time a search view route is faded in.
  ///
  /// This must not be null.
  final SearchAnchorChildBuilder builder;

  /// Called to get the suggestion list for the search view.
  ///
  /// By default, the list returned by this builder is laid out in a [ListView].
  /// To get a different layout, use [viewBuilder] to override.
  final SuggestionsBuilder suggestionsBuilder;

  @override
  State<SearchAnchor> createState() => _SearchAnchorState();
}

class _SearchAnchorState extends State<SearchAnchor> {
  bool _anchorIsVisible = true;
  final GlobalKey _anchorKey = GlobalKey();
  bool get _viewIsOpen => !_anchorIsVisible;
  late SearchController? _internalSearchController;
  SearchController get _searchController => widget.searchController ?? _internalSearchController!;

  @override
  void initState() {
    super.initState();
    if (widget.searchController == null) {
      _internalSearchController = SearchController();
    }
    _searchController._attach(this);
  }

  @override
  void dispose() {
    super.dispose();
    _searchController._detach(this);
    _internalSearchController = null;
  }

  void _openView() {
    Navigator.of(context).push(_SearchViewRoute(
      viewLeading: widget.viewLeading,
      viewTrailing: widget.viewTrailing,
      viewHintText: widget.viewHintText,
      viewBackgroundColor: widget.viewBackgroundColor,
      viewElevation: widget.viewElevation,
      viewSurfaceTintColor: widget.viewSurfaceTintColor,
      viewSide: widget.viewSide,
      viewShape: widget.viewShape,
      viewHeaderTextStyle: widget.headerTextStyle,
      viewHeaderHintStyle: widget.headerHintStyle,
      dividerColor: widget.dividerColor,
      viewConstraints: widget.viewConstraints,
      showFullScreenView: getShowFullScreenView(),
      toggleVisibility: toggleVisibility,
      textDirection: Directionality.of(context),
      viewBuilder: widget.viewBuilder,
      anchorKey: _anchorKey,
      searchController: _searchController,
      suggestionsBuilder: widget.suggestionsBuilder,
    ));
  }

  void _closeView(String? selectedText) {
    if (selectedText != null) {
      _searchController.text = selectedText;
    }
    Navigator.of(context).pop();
  }

  Rect? getRect(GlobalKey key) {
    final BuildContext? context = key.currentContext;
    if (context != null) {
      final RenderBox searchBarBox = context.findRenderObject()! as RenderBox;
      final Size boxSize = searchBarBox.size;
      final Offset boxLocation = searchBarBox.localToGlobal(Offset.zero);
      return boxLocation & boxSize;
    }
    return null;
  }

  bool toggleVisibility() {
    setState(() {
      _anchorIsVisible = !_anchorIsVisible;
    });
    return _anchorIsVisible;
  }

  bool getShowFullScreenView() {
    if (widget.isFullScreen != null) {
      return widget.isFullScreen!;
    }

    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return true;
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      key: _anchorKey,
      opacity: _anchorIsVisible ? 1.0 : 0.0,
      duration: _kAnchorFadeDuration,
      child: GestureDetector(
        onTap: _openView,
        child: widget.builder(context, _searchController),
      ),
    );
  }
}

class _SearchViewRoute extends PopupRoute<_SearchViewRoute> {
  _SearchViewRoute({
    this.toggleVisibility,
    this.textDirection,
    this.viewBuilder,
    this.viewLeading,
    this.viewTrailing,
    this.viewHintText,
    this.viewBackgroundColor,
    this.viewElevation,
    this.viewSurfaceTintColor,
    this.viewSide,
    this.viewShape,
    this.viewHeaderTextStyle,
    this.viewHeaderHintStyle,
    this.dividerColor,
    this.viewConstraints,
    required this.showFullScreenView,
    required this.anchorKey,
    required this.searchController,
    required this.suggestionsBuilder,
  });

  final ValueGetter<bool>? toggleVisibility;
  final TextDirection? textDirection;
  final ViewBuilder? viewBuilder;
  final Widget? viewLeading;
  final Iterable<Widget>? viewTrailing;
  final String? viewHintText;
  final Color? viewBackgroundColor;
  final Elevation? viewElevation;
  final Color? viewSurfaceTintColor;
  final BorderSide? viewSide;
  final OutlinedBorder? viewShape;
  final TextStyle? viewHeaderTextStyle;
  final TextStyle? viewHeaderHintStyle;
  final Color? dividerColor;
  final BoxConstraints? viewConstraints;
  final bool showFullScreenView;
  final GlobalKey anchorKey;
  final SearchController searchController;
  final SuggestionsBuilder suggestionsBuilder;

  @override
  Color? get barrierColor => Colors.transparent;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Dismiss';

  late final SearchViewThemeData viewDefaults;
  late final SearchViewThemeData viewTheme;
  late final DividerThemeData dividerTheme;
  final RectTween _rectTween = RectTween();

  Rect? getRect() {
    final BuildContext? context = anchorKey.currentContext;
    if (context != null) {
      final RenderBox searchBarBox = context.findRenderObject()! as RenderBox;
      final Size boxSize = searchBarBox.size;
      final Offset boxLocation = searchBarBox.localToGlobal(Offset.zero);
      return boxLocation & boxSize;
    }
    return null;
  }

  @override
  TickerFuture didPush() {
    assert(anchorKey.currentContext != null);
    updateViewConfig(anchorKey.currentContext!);
    updateTweens(anchorKey.currentContext!);
    toggleVisibility?.call();
    return super.didPush();
  }

  @override
  bool didPop(_SearchViewRoute? result) {
    assert(anchorKey.currentContext != null);
    updateTweens(anchorKey.currentContext!);
    toggleVisibility?.call();
    return super.didPop(result);
  }

  void updateViewConfig(BuildContext context) {
    viewDefaults = _SearchViewDefaultsM3(context, isFullScreen: showFullScreenView);
    viewTheme = SearchViewTheme.of(context);
    dividerTheme = DividerTheme.of(context);
  }

  void updateTweens(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final Rect anchorRect = getRect() ?? Rect.zero;

    final BoxConstraints effectiveConstraints = viewConstraints ?? viewTheme.constraints ?? viewDefaults.constraints!;
    _rectTween.begin = anchorRect;

    final double viewWidth = clampDouble(anchorRect.width, effectiveConstraints.minWidth, effectiveConstraints.maxWidth);
    final double viewHeight = clampDouble(screenSize.height * 2 / 3, effectiveConstraints.minHeight, effectiveConstraints.maxHeight);

    switch (textDirection ?? TextDirection.ltr) {
      case TextDirection.ltr:
        final double viewLeftToScreenRight = screenSize.width - anchorRect.left;
        final double viewTopToScreenBottom = screenSize.height - anchorRect.top;

        // Make sure the search view doesn't go off the screen. If the search view
        // doesn't fit, move the top-left corner of the view to fit the window.
        // If the window is smaller than the view, then we resize the view to fit the window.
        Offset topLeft = anchorRect.topLeft;
        if (viewLeftToScreenRight < viewWidth) {
          topLeft = Offset(screenSize.width - math.min(viewWidth, screenSize.width), topLeft.dy);
        }
        if (viewTopToScreenBottom < viewHeight) {
          topLeft = Offset(topLeft.dx, screenSize.height - math.min(viewHeight, screenSize.height));
        }
        final Size endSize = Size(viewWidth, viewHeight);
        _rectTween.end = showFullScreenView ? Offset.zero & screenSize : (topLeft & endSize);
        return;
      case TextDirection.rtl:
        final double viewRightToScreenLeft = anchorRect.right;
        final double viewTopToScreenBottom = screenSize.height - anchorRect.top;

        // Make sure the search view doesn't go off the screen.
        Offset topLeft = Offset(math.max(anchorRect.right - viewWidth, 0.0), anchorRect.top);
        if (viewRightToScreenLeft < viewWidth) {
          topLeft = Offset(0.0, topLeft.dy);
        }
        if (viewTopToScreenBottom < viewHeight) {
          topLeft = Offset(topLeft.dx, screenSize.height - math.min(viewHeight, screenSize.height));
        }
        final Size endSize = Size(viewWidth, viewHeight);
        _rectTween.end = showFullScreenView ? Offset.zero & screenSize : (topLeft & endSize);
    }
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {

    return Directionality(
      textDirection: textDirection ?? TextDirection.ltr,
      child: AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          final Animation<double> curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubicEmphasized,
            reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
          );

          final Rect viewRect = _rectTween.evaluate(curvedAnimation)!;
          final double topPadding = showFullScreenView
            ? lerpDouble(0.0, MediaQuery.paddingOf(context).top, curvedAnimation.value)!
            : 0.0;

          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: _kViewFadeOnInterval,
              reverseCurve: _kViewFadeOnInterval.flipped,
            ),
            child: _ViewContent(
              viewLeading: viewLeading,
              viewTrailing: viewTrailing,
              viewHintText: viewHintText,
              viewBackgroundColor: viewBackgroundColor,
              viewElevation: viewElevation,
              viewSurfaceTintColor: viewSurfaceTintColor,
              viewSide: viewSide,
              viewShape: viewShape,
              viewHeaderTextStyle: viewHeaderTextStyle,
              viewHeaderHintStyle: viewHeaderHintStyle,
              dividerColor: dividerColor,
              viewConstraints: viewConstraints,
              showFullScreenView: showFullScreenView,
              animation: curvedAnimation,
              getRect: getRect,
              topPadding: topPadding,
              viewRect: viewRect,
              viewDefaults: viewDefaults,
              viewTheme: viewTheme,
              dividerTheme: dividerTheme,
              viewBuilder: viewBuilder,
              searchController: searchController,
              suggestionsBuilder: suggestionsBuilder,
            ),
          );
        }
      ),
    );
  }

  @override
  Duration get transitionDuration => _kOpenViewDuration;
}

class _ViewContent extends StatefulWidget {
  const _ViewContent({
    this.viewBuilder,
    this.viewLeading,
    this.viewTrailing,
    this.viewHintText,
    this.viewBackgroundColor,
    this.viewElevation,
    this.viewSurfaceTintColor,
    this.viewSide,
    this.viewShape,
    this.viewHeaderTextStyle,
    this.viewHeaderHintStyle,
    this.dividerColor,
    this.viewConstraints,
    required this.showFullScreenView,
    required this.getRect,
    required this.topPadding,
    required this.animation,
    required this.viewRect,
    required this.viewDefaults,
    required this.viewTheme,
    required this.dividerTheme,
    required this.searchController,
    required this.suggestionsBuilder,
  });

  final ViewBuilder? viewBuilder;
  final Widget? viewLeading;
  final Iterable<Widget>? viewTrailing;
  final String? viewHintText;
  final Color? viewBackgroundColor;
  final Elevation? viewElevation;
  final Color? viewSurfaceTintColor;
  final BorderSide? viewSide;
  final OutlinedBorder? viewShape;
  final TextStyle? viewHeaderTextStyle;
  final TextStyle? viewHeaderHintStyle;
  final Color? dividerColor;
  final BoxConstraints? viewConstraints;
  final bool showFullScreenView;
  final ValueGetter<Rect?> getRect;
  final double topPadding;
  final Animation<double> animation;
  final Rect viewRect;
  final SearchViewThemeData viewDefaults;
  final SearchViewThemeData viewTheme;
  final DividerThemeData dividerTheme;
  final SearchController searchController;
  final SuggestionsBuilder suggestionsBuilder;

  @override
  State<_ViewContent> createState() => _ViewContentState();
}

class _ViewContentState extends State<_ViewContent> {
  Size? _screenSize;
  late Rect _viewRect;
  late final SearchController _controller;
  late Iterable<Widget> result;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _viewRect = widget.viewRect;
    _controller = widget.searchController;
    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
    }
  }

  @override
  void didUpdateWidget(covariant _ViewContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.viewRect != oldWidget.viewRect) {
      setState(() {
        _viewRect = widget.viewRect;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    result = widget.suggestionsBuilder(context, _controller);
    final Size updatedScreenSize = MediaQuery.of(context).size;

    if (_screenSize != updatedScreenSize) {
      _screenSize = updatedScreenSize;
      setState(() {
        final Rect anchorRect = widget.getRect() ?? _viewRect;
        final BoxConstraints constraints = widget.viewConstraints ?? widget.viewTheme.constraints ?? widget.viewDefaults.constraints!;
        final double viewWidth = clampDouble(anchorRect.width, constraints.minWidth, constraints.maxWidth);
        final double viewHeight = clampDouble(_screenSize!.height * 2 / 3, constraints.minHeight, constraints.maxHeight);
        final Size updatedViewSize = Size(viewWidth, viewHeight);

        switch (Directionality.of(context)) {
          case TextDirection.ltr:
            final double viewLeftToScreenRight = _screenSize!.width - anchorRect.left;
            final double viewTopToScreenBottom = _screenSize!.height - anchorRect.top;

            // Make sure the search view doesn't go off the screen when the screen
            // size is changed. If the search view doesn't fit, move the top-left
            // corner of the view to fit the window. If the window is smaller than
            // the view, then we resize the view to fit the window.
            Offset topLeft = anchorRect.topLeft;
            if (viewLeftToScreenRight < viewWidth) {
              topLeft = Offset(_screenSize!.width - math.min(viewWidth, _screenSize!.width), anchorRect.top);
            }
            if (viewTopToScreenBottom < viewHeight) {
              topLeft = Offset(topLeft.dx, _screenSize!.height - math.min(viewHeight, _screenSize!.height));
            }
            _viewRect = topLeft & updatedViewSize;
            return;
          case TextDirection.rtl:
            final double viewTopToScreenBottom = _screenSize!.height - anchorRect.top;
            Offset topLeft = Offset(
              math.max(anchorRect.right - viewWidth, 0.0),
              anchorRect.top,
            );
            if (viewTopToScreenBottom < viewHeight) {
              topLeft = Offset(topLeft.dx, _screenSize!.height - math.min(viewHeight, _screenSize!.height));
            }
            _viewRect = topLeft & updatedViewSize;
        }
      });
    }
  }

  Widget viewBuilder(Iterable<Widget> suggestions) {
    if (widget.viewBuilder == null) {
      return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          children: suggestions.toList()
        ),
      );
    }
    return widget.viewBuilder!(suggestions);
  }

  void updateSuggestions() {
    setState(() {
      result = widget.suggestionsBuilder(context, _controller);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget defaultLeading = IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () { Navigator.of(context).pop(); },
      style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
    );

    final List<Widget> defaultTrailing = <Widget>[
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          _controller.clear();
          updateSuggestions();
        },
      ),
    ];

    final Color effectiveBackgroundColor = widget.viewBackgroundColor
      ?? widget.viewTheme.backgroundColor
      ?? widget.viewDefaults.backgroundColor!;
    final Color effectiveSurfaceTint = widget.viewSurfaceTintColor
      ?? widget.viewTheme.surfaceTintColor
      ?? widget.viewDefaults.surfaceTintColor!;
    final Elevation effectiveElevation = widget.viewElevation
      ?? widget.viewTheme.elevation
      ?? widget.viewDefaults.elevation!;
    final BorderSide? effectiveSide = widget.viewSide
      ?? widget.viewTheme.side
      ?? widget.viewDefaults.side;
    OutlinedBorder effectiveShape = widget.viewShape
      ?? widget.viewTheme.shape
      ?? widget.viewDefaults.shape!;
    if (effectiveSide != null) {
      effectiveShape = effectiveShape.copyWith(side: effectiveSide);
    }
    final Color effectiveDividerColor = widget.dividerColor
      ?? widget.viewTheme.dividerColor
      ?? widget.dividerTheme.color
      ?? widget.viewDefaults.dividerColor!;
    final TextStyle? effectiveTextStyle = widget.viewHeaderTextStyle
      ?? widget.viewTheme.headerTextStyle
      ?? widget.viewDefaults.headerTextStyle;
    final TextStyle? effectiveHintStyle = widget.viewHeaderHintStyle
      ?? widget.viewTheme.headerHintStyle
      ?? widget.viewHeaderTextStyle
      ?? widget.viewTheme.headerTextStyle
      ?? widget.viewDefaults.headerHintStyle;

    final Widget viewDivider = DividerTheme(
      data: widget.dividerTheme.copyWith(color: effectiveDividerColor),
      child: const Divider(height: 1),
    );

    return Align(
      alignment: Alignment.topLeft,
      child: Transform.translate(
        offset: _viewRect.topLeft,
        child: SizedBox(
          width: _viewRect.width,
          height: _viewRect.height,
          child: Material(
            shape: effectiveShape,
            color: effectiveBackgroundColor,
            surfaceTintColor: effectiveSurfaceTint,
            elevation: effectiveElevation,
            child: FadeTransition(
              opacity: CurvedAnimation(
                parent: widget.animation,
                curve: _kViewIconsFadeOnInterval,
                reverseCurve: _kViewIconsFadeOnInterval.flipped,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: widget.topPadding),
                    child: SafeArea(
                      top: false,
                      bottom: false,
                      child: SearchBar(
                        constraints: widget.showFullScreenView ? BoxConstraints(minHeight: _SearchViewDefaultsM3.fullScreenBarHeight) : null,
                        focusNode: _focusNode,
                        leading: widget.viewLeading ?? defaultLeading,
                        trailing: widget.viewTrailing ?? defaultTrailing,
                        hintText: widget.viewHintText,
                        backgroundColor: const MaterialStatePropertyAll<Color>(Colors.transparent),
                        overlayColor: const MaterialStatePropertyAll<Color>(Colors.transparent),
                        elevation: const MaterialStatePropertyAll<Elevation>(Elevation.level0),
                        textStyle: MaterialStatePropertyAll<TextStyle?>(effectiveTextStyle),
                        hintStyle: MaterialStatePropertyAll<TextStyle?>(effectiveHintStyle),
                        controller: _controller,
                        onChanged: (_) {
                          updateSuggestions();
                        },
                      ),
                    ),
                  ),
                  FadeTransition(
                    opacity: CurvedAnimation(
                      parent: widget.animation,
                      curve: _kViewDividerFadeOnInterval,
                      reverseCurve: _kViewFadeOnInterval.flipped,
                    ),
                    child: viewDivider),
                  Expanded(
                    child: FadeTransition(
                      opacity: CurvedAnimation(
                        parent: widget.animation,
                        curve: _kViewListFadeOnInterval,
                        reverseCurve: _kViewListFadeOnInterval.flipped,
                      ),
                      child: viewBuilder(result),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchAnchorWithSearchBar extends SearchAnchor {
  _SearchAnchorWithSearchBar({
    Widget? barLeading,
    Iterable<Widget>? barTrailing,
    String? barHintText,
    GestureTapCallback? onTap,
    MaterialStateProperty<Elevation?>? barElevation,
    MaterialStateProperty<Color?>? barBackgroundColor,
    MaterialStateProperty<Color?>? barOverlayColor,
    MaterialStateProperty<BorderSide?>? barSide,
    MaterialStateProperty<OutlinedBorder?>? barShape,
    MaterialStateProperty<EdgeInsetsGeometry?>? barPadding,
    MaterialStateProperty<TextStyle?>? barTextStyle,
    MaterialStateProperty<TextStyle?>? barHintStyle,
    super.viewLeading,
    super.viewTrailing,
    String? viewHintText,
    super.viewBackgroundColor,
    super.viewElevation,
    super.viewSide,
    super.viewShape,
    TextStyle? viewHeaderTextStyle,
    TextStyle? viewHeaderHintStyle,
    super.dividerColor,
    BoxConstraints? constraints,
    super.viewConstraints,
    super.isFullScreen,
    super.searchController,
    required super.suggestionsBuilder
  }) : super(
    viewHintText: viewHintText ?? barHintText,
    headerTextStyle: viewHeaderTextStyle,
    headerHintStyle: viewHeaderHintStyle,
    builder: (BuildContext context, SearchController controller) {
      return SearchBar(
        constraints: constraints,
        controller: controller,
        onTap: () {
          controller.openView();
          onTap?.call();
        },
        onChanged: (_) {
          controller.openView();
        },
        hintText: barHintText,
        hintStyle: barHintStyle,
        textStyle: barTextStyle,
        elevation: barElevation,
        backgroundColor: barBackgroundColor,
        overlayColor: barOverlayColor,
        side: barSide,
        shape: barShape,
        padding: barPadding ?? const MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16.0)),
        leading: barLeading ?? const Icon(Icons.search),
        trailing: barTrailing,
      );
    }
  );
}

/// A controller to manage a search view created by [SearchAnchor].
///
/// A [SearchController] is used to control a menu after it has been created,
/// with methods such as [openView] and [closeView]. It can also control the text in the
/// input field.
///
/// See also:
///
/// * [SearchAnchor], a widget that defines a region that opens a search view.
/// * [TextEditingController], A controller for an editable text field.
class SearchController extends TextEditingController {
  // The anchor that this controller controls.
  //
  // This is set automatically when a [SearchController] is given to the anchor
  // it controls.
  _SearchAnchorState? _anchor;

  /// Whether or not the associated search view is currently open.
  bool get isOpen {
    assert(_anchor != null);
    return _anchor!._viewIsOpen;
  }

  /// Opens the search view that this controller is associated with.
  void openView() {
    assert(_anchor != null);
    _anchor!._openView();
  }

  /// Close the search view that this search controller is associated with.
  ///
  /// If `selectedText` is given, then the text value of the controller is set to
  /// `selectedText`.
  void closeView(String? selectedText) {
    assert(_anchor != null);
    _anchor!._closeView(selectedText);
  }

  // ignore: use_setters_to_change_properties
  void _attach(_SearchAnchorState anchor) {
    _anchor = anchor;
  }

  void _detach(_SearchAnchorState anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }
}

/// A Material Design search bar.
///
/// Search bars include a [leading] Search icon, a text input field and optional
/// [trailing] icons. A search bar is typically used to open a search view.
/// It is the default trigger for a search view.
///
/// For [TextDirection.ltr], the [leading] widget is on the left side of the bar.
/// It should contain either a navigational action (such as a menu or up-arrow)
/// or a non-functional search icon.
///
/// The [trailing] is an optional list that appears at the other end of
/// the search bar. Typically only one or two action icons are included.
/// These actions can represent additional modes of searching (like voice search),
/// a separate high-level action (such as current location) or an overflow menu.
class SearchBar extends StatefulWidget {
  /// Creates a Material Design search bar.
  const SearchBar({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.leading,
    this.trailing,
    this.onTap,
    this.onChanged,
    this.constraints,
    this.elevation,
    this.backgroundColor,
    this.shadowColor,
    this.surfaceTintColor,
    this.overlayColor,
    this.side,
    this.shape,
    this.padding,
    this.textStyle,
    this.hintStyle,
  });

  /// Controls the text being edited in the search bar's text field.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// Text that suggests what sort of input the field accepts.
  ///
  /// Displayed at the same location on the screen where text may be entered
  /// when the input is empty.
  ///
  /// Defaults to null.
  final String? hintText;

  /// A widget to display before the text input field.
  ///
  /// Typically the [leading] widget is an [Icon] or an [IconButton].
  final Widget? leading;

  /// A list of Widgets to display in a row after the text field.
  ///
  /// Typically these actions can represent additional modes of searching
  /// (like voice search), an avatar, a separate high-level action (such as
  /// current location) or an overflow menu. There should not be more than
  /// two trailing actions.
  final Iterable<Widget>? trailing;

  /// Called when the user taps this search bar.
  final GestureTapCallback? onTap;

  /// Invoked upon user input.
  final ValueChanged<String>? onChanged;

  /// Optional size constraints for the search bar.
  ///
  /// If null, the value of [SearchBarThemeData.constraints] will be used. If
  /// this is also null, then the constraints defaults to:
  /// ```dart
  /// const BoxConstraints(minWidth: 360.0, maxWidth: 800.0, minHeight: 56.0)
  /// ```
  final BoxConstraints? constraints;

  /// The elevation of the search bar's [Material].
  ///
  /// If null, the value of [SearchBarThemeData.elevation] will be used. If this
  /// is also null, then default value is 6.0.
  final MaterialStateProperty<Elevation?>? elevation;

  /// The search bar's background fill color.
  ///
  /// If null, the value of [SearchBarThemeData.backgroundColor] will be used.
  /// If this is also null, then the default value is [ColorScheme.surface].
  final MaterialStateProperty<Color?>? backgroundColor;

  /// The shadow color of the search bar's [Material].
  ///
  /// If null, the value of [SearchBarThemeData.shadowColor] will be used.
  /// If this is also null, then the default value is [ColorScheme.shadow].
  final MaterialStateProperty<Color?>? shadowColor;

  /// The surface tint color of the search bar's [Material].
  ///
  /// See [Material.surfaceTintColor] for more details.
  ///
  /// If null, the value of [SearchBarThemeData.surfaceTintColor] will be used.
  /// If this is also null, then the default value is [ColorScheme.surfaceTint].
  final MaterialStateProperty<Color?>? surfaceTintColor;

  /// The highlight color that's typically used to indicate that
  /// the search bar is focused, hovered, or pressed.
  final MaterialStateProperty<Color?>? overlayColor;

  /// The color and weight of the search bar's outline.
  ///
  /// This value is combined with [shape] to create a shape decorated
  /// with an outline.
  ///
  /// If null, the value of [SearchBarThemeData.side] will be used. If this is
  /// also null, the search bar doesn't have a side by default.
  final MaterialStateProperty<BorderSide?>? side;

  /// The shape of the search bar's underlying [Material].
  ///
  /// This shape is combined with [side] to create a shape decorated
  /// with an outline.
  ///
  /// If null, the value of [SearchBarThemeData.shape] will be used.
  /// If this is also null, defaults to [StadiumBorder].
  final MaterialStateProperty<OutlinedBorder?>? shape;

  /// The padding between the search bar's boundary and its contents.
  ///
  /// If null, the value of [SearchBarThemeData.padding] will be used.
  /// If this is also null, then the default value is 16.0 horizontally.
  final MaterialStateProperty<EdgeInsetsGeometry?>? padding;

  /// The style to use for the text being edited.
  ///
  /// If null, defaults to the `bodyLarge` text style from the current [Theme].
  /// The default text color is [ColorScheme.onSurface].
  final MaterialStateProperty<TextStyle?>? textStyle;

  /// The style to use for the [hintText].
  ///
  /// If null, the value of [SearchBarThemeData.hintStyle] will be used. If this
  /// is also null, the value of [textStyle] will be used. If this is also null,
  /// defaults to the `bodyLarge` text style from the current [Theme].
  /// The default text color is [ColorScheme.onSurfaceVariant].
  final MaterialStateProperty<TextStyle?>? hintStyle;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late final MaterialStatesController _internalStatesController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _internalStatesController = MaterialStatesController();
    _internalStatesController.addListener(() {
      setState(() {});
    });
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    _internalStatesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final IconThemeData iconTheme = IconTheme.of(context);
    final SearchBarThemeData searchBarTheme = SearchBarTheme.of(context);
    final SearchBarThemeData defaults = _SearchBarDefaultsM3(context);

    T? resolve<T>(
      MaterialStateProperty<T>? widgetValue,
      MaterialStateProperty<T>? themeValue,
      MaterialStateProperty<T>? defaultValue,
    ) {
      final Set<MaterialState> states = _internalStatesController.value;
      return widgetValue?.resolve(states) ?? themeValue?.resolve(states) ?? defaultValue?.resolve(states);
    }

    final TextStyle? effectiveTextStyle = resolve<TextStyle?>(widget.textStyle, searchBarTheme.textStyle, defaults.textStyle);
    final Elevation? effectiveElevation = resolve<Elevation?>(widget.elevation, searchBarTheme.elevation, defaults.elevation);
    final Color? effectiveShadowColor = resolve<Color?>(widget.shadowColor, searchBarTheme.shadowColor, defaults.shadowColor);
    final Color? effectiveBackgroundColor = resolve<Color?>(widget.backgroundColor, searchBarTheme.backgroundColor, defaults.backgroundColor);
    final Color? effectiveSurfaceTintColor = resolve<Color?>(widget.surfaceTintColor, searchBarTheme.surfaceTintColor, defaults.surfaceTintColor);
    final OutlinedBorder? effectiveShape = resolve<OutlinedBorder?>(widget.shape, searchBarTheme.shape, defaults.shape);
    final BorderSide? effectiveSide = resolve<BorderSide?>(widget.side, searchBarTheme.side, defaults.side);
    final EdgeInsetsGeometry? effectivePadding = resolve<EdgeInsetsGeometry?>(widget.padding, searchBarTheme.padding, defaults.padding);
    final MaterialStateProperty<Color?>? effectiveOverlayColor = widget.overlayColor ?? searchBarTheme.overlayColor ?? defaults.overlayColor;

    final Set<MaterialState> states = _internalStatesController.value;
    final TextStyle? effectiveHintStyle = widget.hintStyle?.resolve(states)
      ?? searchBarTheme.hintStyle?.resolve(states)
      ?? widget.textStyle?.resolve(states)
      ?? searchBarTheme.textStyle?.resolve(states)
      ?? defaults.hintStyle?.resolve(states);

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    bool isIconThemeColorDefault(Color? color) {
      if (isDark) {
        return color == kDefaultIconLightColor;
      }
      return color == kDefaultIconDarkColor;
    }

    Widget? leading;
    if (widget.leading != null) {
      leading = IconTheme.merge(
        data: isIconThemeColorDefault(iconTheme.color)
          ? IconThemeData(color: colorScheme.onSurface)
          : iconTheme,
        child: widget.leading!,
      );
    }

    List<Widget>? trailing;
    if (widget.trailing != null) {
      trailing = widget.trailing?.map((Widget trailing) => IconTheme.merge(
        data: isIconThemeColorDefault(iconTheme.color)
          ? IconThemeData(color: colorScheme.onSurfaceVariant)
          : iconTheme,
        child: trailing,
      )).toList();
    }

    return ConstrainedBox(
      constraints: widget.constraints ?? searchBarTheme.constraints ?? defaults.constraints!,
      child: Material(
        elevation: effectiveElevation!,
        shadowColor: effectiveShadowColor,
        color: effectiveBackgroundColor,
        surfaceTintColor: effectiveSurfaceTintColor,
        shape: effectiveShape?.copyWith(side: effectiveSide),
        child: InkWell(
          onTap: () {
            widget.onTap?.call();
            _focusNode.requestFocus();
          },
          overlayColor: effectiveOverlayColor,
          customBorder: effectiveShape?.copyWith(side: effectiveSide),
          statesController: _internalStatesController,
          child: Padding(
            padding: effectivePadding!,
            child: Row(
              textDirection: textDirection,
              children: <Widget>[
                if (leading != null) leading,
                Expanded(
                  child: IgnorePointer(
                    child: Padding(
                      padding: effectivePadding,
                      child: TextField(
                        focusNode: _focusNode,
                        onChanged: widget.onChanged,
                        controller: widget.controller,
                        style: effectiveTextStyle,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: widget.hintText,
                          hintStyle: effectiveHintStyle,
                        ),
                      ),
                    ),
                  )
                ),
                if (trailing != null) ...trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// BEGIN GENERATED TOKEN PROPERTIES - SearchBar

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// Token database version: v0_162

class _SearchBarDefaultsM3 extends SearchBarThemeData {
  _SearchBarDefaultsM3(this.context);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  @override
  MaterialStateProperty<Color?>? get backgroundColor =>
    MaterialStatePropertyAll<Color>(_colors.surface);

  @override
  MaterialStateProperty<Elevation>? get elevation =>
    const MaterialStatePropertyAll<Elevation>(Elevation.level3);

  @override
  MaterialStateProperty<Color>? get shadowColor =>
    MaterialStatePropertyAll<Color>(_colors.shadow);

  @override
  MaterialStateProperty<Color>? get surfaceTintColor =>
    MaterialStatePropertyAll<Color>(_colors.surfaceTint);

  @override
  MaterialStateProperty<Color?>? get overlayColor =>
    MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return _colors.onSurface.withOpacity(0.12);
      }
      if (states.contains(MaterialState.hovered)) {
        return _colors.onSurface.withOpacity(0.08);
      }
      if (states.contains(MaterialState.focused)) {
        return Colors.transparent;
      }
      return Colors.transparent;
    });

  // No default side

  @override
  MaterialStateProperty<OutlinedBorder>? get shape =>
    const MaterialStatePropertyAll<OutlinedBorder>(StadiumBorder());

  @override
  MaterialStateProperty<EdgeInsetsGeometry>? get padding =>
    const MaterialStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 8.0));

  @override
  MaterialStateProperty<TextStyle?> get textStyle =>
    MaterialStatePropertyAll<TextStyle?>(_textTheme.bodyLarge.copyWith(color: _colors.onSurface));

  @override
  MaterialStateProperty<TextStyle?> get hintStyle =>
    MaterialStatePropertyAll<TextStyle?>(_textTheme.bodyLarge.copyWith(color: _colors.onSurfaceVariant));

  @override
  BoxConstraints get constraints =>
    const BoxConstraints(minWidth: 360.0, maxWidth: 800.0, minHeight: 56.0);
}

// END GENERATED TOKEN PROPERTIES - SearchBar

// BEGIN GENERATED TOKEN PROPERTIES - SearchView

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// Token database version: v0_162

class _SearchViewDefaultsM3 extends SearchViewThemeData {
  _SearchViewDefaultsM3(this.context, {required this.isFullScreen});

  final BuildContext context;
  final bool isFullScreen;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  static double fullScreenBarHeight = 72.0;

  @override
  Color? get backgroundColor => _colors.surface;

  @override
  Elevation? get elevation => Elevation.level3;

  @override
  Color? get surfaceTintColor => _colors.surfaceTint;

  // No default side

  @override
  OutlinedBorder? get shape => isFullScreen
    ? const RoundedRectangleBorder()
    : const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(28.0)));

  @override
  TextStyle? get headerTextStyle => _textTheme.bodyLarge.copyWith(color: _colors.onSurface);

  @override
  TextStyle? get headerHintStyle => _textTheme.bodyLarge.copyWith(color: _colors.onSurfaceVariant);

  @override
  BoxConstraints get constraints => const BoxConstraints(minWidth: 360.0, minHeight: 240.0);

  @override
  Color? get dividerColor => _colors.outline;
}

// END GENERATED TOKEN PROPERTIES - SearchView

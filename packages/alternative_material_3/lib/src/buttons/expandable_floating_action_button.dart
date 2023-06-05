import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../constants.dart';
import '../theme.dart';
import '../theme_data.dart';
import 'button.dart';
import 'expandable_floating_action_button_theme.dart';

///
@immutable
class ExpandableFloatingActionButtonEntry {
  ///
  const ExpandableFloatingActionButtonEntry(
      {required this.icon,
      this.label,
      this.theme,
      this.colorTheme,
      this.type,
      this.onPressed,
      this.heroTag,
      this.focusNode,
      this.tooltip});

  /// The widget below this widget in the tree.
  ///
  /// Typically an [Icon].
  final Widget icon;

  final Widget? label;

  final FloatingActionButtonThemeData? theme;

  final FloatingActionButtonColorTheme? colorTheme;

  final FloatingActionButtonType? type;

  final VoidCallback? onPressed;

  final Object? heroTag;

  final FocusNode? focusNode;

  final String? tooltip;
}

class ExpandableFloatingActionButton extends StatefulWidget {
  ///
  const ExpandableFloatingActionButton({
    super.key,
    this.theme,
    required this.primaryFab,
    required this.supportingFabs,
    this.collapsedHeight = FloatingActionButtonHeight.regular,
    this.expandedHeight = FloatingActionButtonHeight.regular,
    this.primaryColorTheme = FloatingActionButtonColorTheme.primary,
    this.supportingColorTheme = FloatingActionButtonColorTheme.secondary,
    this.fabTheme,
    this.isInitiallyOpen = false,
  });

  final ExpandableFloatingActionButtonThemeData? theme;
  final FloatingActionButtonThemeData? fabTheme;
  final FloatingActionButtonHeight collapsedHeight;
  final FloatingActionButtonHeight expandedHeight;
  final FloatingActionButtonColorTheme primaryColorTheme;
  final FloatingActionButtonColorTheme supportingColorTheme;
  final ExpandableFloatingActionButtonEntry primaryFab;
  final List<ExpandableFloatingActionButtonEntry> supportingFabs;
  final bool isInitiallyOpen;

  @override
  ExpandableFloatingActionButtonState createState() =>
      ExpandableFloatingActionButtonState();
}

class ExpandableFloatingActionButtonState
    extends State<ExpandableFloatingActionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  late final Animation<double> _opacityAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _isOpen = widget.isInitiallyOpen;
    _controller = AnimationController(
      value: _isOpen ? 1.0 : 0.0,
      duration: kThemeChangeDuration,
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
    _opacityAnimation = CurvedAnimation(
      curve: Curves.fastLinearToSlowEaseIn,
      reverseCurve: Curves.fastLinearToSlowEaseIn,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleToggleOpen() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final expandableTheme =
        ExpandableFloatingActionButtonThemeData.resolve(context, widget.theme);
    final primaryFabTheme = FloatingActionButtonThemeData.resolve(
      context,
      type: FloatingActionButtonType.regular,
      colorTheme: widget.supportingColorTheme,
      height: _isOpen ? widget.expandedHeight : widget.collapsedHeight,
    );
    final miniFabTheme = FloatingActionButtonThemeData.resolve(
      context,
      type: FloatingActionButtonType.small,
      colorTheme: widget.supportingColorTheme,
      height: _isOpen ? widget.expandedHeight : widget.collapsedHeight,
    );

    final double primaryFabHeight = primaryFabTheme.sizeConstraints.minHeight;
    final double miniFabHeight = miniFabTheme.sizeConstraints.minHeight;
    final double tapHeight =
        theme.materialTapTargetSize == MaterialTapTargetSize.shrinkWrap &&
                !theme.alwaysPadTapTarget
            ? 0.0
            : theme.minInteractiveDimension;
    final double topOffset = math.max(0.0, tapHeight - miniFabHeight / 2.0);

    final totalHeight = primaryFabHeight +
        expandableTheme.primaryPadding +
                widget.supportingFabs.length * miniFabHeight +
                (widget.supportingFabs.length - 1) *
                    expandableTheme.supportingPadding +
                topOffset;

    List<Widget> positionSupportingButtons() {
      Widget miniFab(ExpandableFloatingActionButtonEntry e) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: FloatingActionButton.small(
            icon: e.icon,
            onPressed: e.onPressed,
            colorTheme: widget.supportingColorTheme,
            theme: widget.fabTheme,
            focusNode: e.focusNode,
            heroTag: e.heroTag,
            height: _isOpen ? widget.expandedHeight : widget.collapsedHeight,
            tooltip: e.tooltip,
          ),
        );
      }

      return widget.supportingFabs.reversed.indexed.map((e) {
        final int index = e.$1;

        final top = topOffset +
            index * miniFabHeight +
            index * expandableTheme.supportingPadding;

        return Positioned(
          top: lerpDouble(totalHeight - primaryFabHeight, top, _expandAnimation.value),
          child: miniFab(e.$2),
        );
      }).toList();
    }

    Widget buildPrimaryFab() {
      return _isOpen && widget.primaryFab.label != null
          ? FloatingActionButton.extended(
              icon: widget.primaryFab.icon,
              label: widget.primaryFab.label!,
              onPressed: _handleToggleOpen,
              colorTheme: widget.primaryColorTheme,
              theme: widget.fabTheme,
              focusNode: widget.primaryFab.focusNode,
              heroTag: widget.primaryFab.heroTag,
              height: _isOpen ? widget.expandedHeight : widget.collapsedHeight,
              tooltip: widget.primaryFab.tooltip,
            )
          : _isOpen
              ? FloatingActionButton(
                  icon: widget.primaryFab.icon,
                  onPressed: _handleToggleOpen,
                  colorTheme: widget.primaryColorTheme,
                  theme: widget.fabTheme,
                  focusNode: widget.primaryFab.focusNode,
                  heroTag: widget.primaryFab.heroTag,
                  height: _isOpen ? widget.expandedHeight : widget.collapsedHeight,
                  tooltip: widget.primaryFab.tooltip,
                )
              : FloatingActionButton(
                  icon: widget.primaryFab.icon,
                  onPressed: _handleToggleOpen,
                  colorTheme: widget.primaryColorTheme,
                  theme: widget.fabTheme,
                  focusNode: widget.primaryFab.focusNode,
                  heroTag: widget.primaryFab.heroTag,
                  height: _isOpen ? widget.expandedHeight : widget.collapsedHeight,
                  tooltip: widget.primaryFab.tooltip,
                );
    }

    List<Widget> positionedWidgets() {
      return [
        ...positionSupportingButtons(),
        Positioned(
          bottom: 0.0,
          child: buildPrimaryFab(),
        ),
      ];
    }
    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (BuildContext context, Widget? child) {
        return SizedBox(
          height: totalHeight,
          child: Stack(
            alignment: Alignment.centerRight, // FIXME
            clipBehavior: Clip.none,
            children: positionedWidgets(),
          ),
        );
      },
    );
  }
}

class _ExpandableFloatingActionButton extends RenderObjectWidget
    with SlottedMultiChildRenderObjectWidgetMixin<int> {
  _ExpandableFloatingActionButton({
    required this.isOpen,
    required this.primaryFab,
    required this.supportingFabs,
  });

  final bool isOpen;
  final Widget primaryFab;
  final List<Widget> supportingFabs;

  @override
  Widget? childForSlot(int slot) {
    throw UnimplementedError();
  }

  @override
  SlottedContainerRenderObjectMixin<int> createRenderObject(
    BuildContext context,
  ) {
    return _RenderExpandableFloatingActionButton();
  }

  @override
  void updateRenderObject(BuildContext context,
      _RenderExpandableFloatingActionButton renderObject) {
    super.updateRenderObject(context, renderObject);
  }

  @override
  Iterable<int> get slots => List.generate(
        supportingFabs.length + 1,
        (index) => index,
      );
}

class _RenderExpandableFloatingActionButton extends RenderBox
    with SlottedContainerRenderObjectMixin<int> {
  @override
  void performLayout() {
    // TODO: implement performLayout
    super.performLayout();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    void doPaint(RenderBox? child) {
      if (child != null) {
        final BoxParentData parentData = child.parentData! as BoxParentData;
        context.paintChild(child, parentData.offset + offset);
      }
    }

    /// Paint highest first so the primary is on top
    children.toList().reversed.forEach(doPaint);
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (final RenderBox child in children) {
      final BoxParentData parentData = child.parentData! as BoxParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: parentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - parentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );
      if (isHit) {
        return true;
      }
    }
    return false;
  }
}

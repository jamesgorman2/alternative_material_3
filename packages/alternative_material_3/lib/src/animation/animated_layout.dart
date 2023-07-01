// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'array_distribution.dart';

/// A widget that displays its children in a horizontal array.
///
/// {@macro alternative_material_3.animatedLayout}
@immutable
class AnimatedColumn extends AnimatedLayout {
  /// Creates a vertical array of children.
  ///
  /// The [mainAxisAlignment], [mainAxisSize], [crossAxisAlignment], and
  /// [verticalDirection] arguments must not be null.
  /// If [crossAxisAlignment] is [CrossAxisAlignment.baseline], then
  /// [textBaseline] must not be null.
  ///
  /// The [textDirection] argument defaults to the ambient [Directionality], if
  /// any. If there is no ambient directionality, and a text direction is going
  /// to be necessary to determine the layout order (which is always the case
  /// unless the row has no children or only one child) or to disambiguate
  /// `start` or `end` values for the [mainAxisAlignment], the [textDirection]
  /// must not be null.
  const AnimatedColumn({
    super.key,
    required super.duration,
    super.fadeOutCurve,
    super.fadeInCurve,
    super.sizeCurve,
    super.animateFrom,
    super.animationClipBehaviour,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.clipBehavior,
    super.mainAxisFit,
    required super.children,
  }) : super(
          direction: Axis.vertical,
        );
}

/// A widget that displays its children in a horizontal array.
///
/// {@macro alternative_material_3.animatedLayout}
@immutable
class AnimatedRow extends AnimatedLayout {
  /// Creates a horizontal array of children.
  ///
  /// The [mainAxisAlignment], [mainAxisSize], [crossAxisAlignment], and
  /// [verticalDirection] arguments must not be null.
  /// If [crossAxisAlignment] is [CrossAxisAlignment.baseline], then
  /// [textBaseline] must not be null.
  ///
  /// The [textDirection] argument defaults to the ambient [Directionality], if
  /// any. If there is no ambient directionality, and a text direction is going
  /// to be necessary to determine the layout order (which is always the case
  /// unless the row has no children or only one child) or to disambiguate
  /// `start` or `end` values for the [mainAxisAlignment], the [textDirection]
  /// must not be null.
  const AnimatedRow({
    super.key,
    required super.duration,
    super.fadeOutCurve,
    super.fadeInCurve,
    super.sizeCurve,
    super.animateFrom,
    super.animationClipBehaviour,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.clipBehavior,
    super.mainAxisFit,
    required super.children,
  }) : super(
          direction: Axis.horizontal,
        );
}

/// {@template alternative_material_3.MainAxisFit}
/// Describes how children are distributed.
/// {@endtemplate}
enum MainAxisFit {
  /// Evenly distribute children according to their flex value.
  /// The first child will be at least its minimum size. Children
  /// will then be fitted from start to end.
  start,

  /// Evenly distribute children according to their flex value.
  /// The last child will be at least its minimum size. Children
  /// will then be fitted from end top start.
  end,

  /// Evenly distribute children according to their flex value.
  /// The first and last children will be at least their minimum size.
  /// Children will then be fitted by alternating from start and end towards
  /// the middle.
  startAndEnd,
}

/// A [Flex]-like that will animate the size and opacity of it's elements
/// as they are changed.
///
/// {@template alternative_material_3.animatedLayout}
/// To reduce complexity and resource consumption it will only allow a single
/// animation set to play at any time, effectively debouncing rapid changes.
///
/// In addition to [mainAxisSize], it will optional constrain it's children
/// to the parent constraints using the rules in [MainAxisFit].
/// {@endtemplate}
///
/// See also:
///
/// * [Flex]
class AnimatedLayout extends StatefulWidget {
  /// create the animated row.
  const AnimatedLayout({
    super.key,
    required this.duration,
    this.fadeOutCurve = Curves.easeInOutCirc,
    this.fadeInCurve = Curves.easeInOut,
    this.sizeCurve = Curves.easeInOut,
    AlignmentDirectional? animateFrom,
    this.animationClipBehaviour = Clip.hardEdge,
    required this.direction,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.clipBehavior = Clip.none,
    this.mainAxisFit = MainAxisFit.start,
    required this.children,
  }) : animateFrom = animateFrom ??
            (direction == Axis.horizontal
                ? AlignmentDirectional.centerStart
                : AlignmentDirectional.topCenter);

  /// The duration when transitioning this widget's size and opacity.
  final Duration duration;

  /// The animation curve when fading out a child widget.
  ///
  /// Defaults to [Curves.].
  final Curve fadeOutCurve;

  /// The animation curve when fading in a child widget.
  ///
  /// Defaults to [Curves.].
  final Curve fadeInCurve;

  /// The animation curve when changing the size of child widget.
  /// If transitioning between two non-empty widgets, this applies to the
  /// size transition of both.
  ///
  /// Defaults to [Curves.].
  final Curve sizeCurve;

  /// The alignment when animating size transitions.
  ///
  /// The default value is [AlignmentDirectional.centerStart] when
  /// [direction] is [Axis.horizontal] and [AlignmentDirectional.topCenter]
  /// when [direction] is [Axis.vertical]
  final AlignmentDirectional animateFrom;

  /// How to clip size animation.
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip animationClipBehaviour;

  /// The direction to use as the main axis.
  ///
  /// If you know the axis in advance, then consider using an [AnimatedRow] (if it's
  /// horizontal) or [AnimatedColumn] (if it's vertical) instead of an [AnimatedLayout], since that
  /// will be less verbose. (For [AnimatedRow] and [AnimatedColumn] this property is fixed to
  /// the appropriate axis.)
  final Axis direction;

  /// How the children should be placed along the main axis.
  ///
  /// For example, [MainAxisAlignment.start], the default, places the children
  /// at the start (i.e., the left for an [AnimatedRow] or the top for
  /// an [AnimatedColumn]) of the main axis.
  final MainAxisAlignment mainAxisAlignment;

  /// How much space should be occupied in the main axis.
  ///
  /// After allocating space to children, there might be some remaining free
  /// space. This value controls whether to maximize or minimize the amount of
  /// free space, subject to the incoming layout constraints.
  ///
  /// If some children have a non-zero flex factors (and none have a fit of
  /// [FlexFit.loose]), they will expand to consume all the available space and
  /// there will be no remaining free space to maximize or minimize, making this
  /// value irrelevant to the final layout.
  final MainAxisSize mainAxisSize;

  /// How the children should be placed along the cross axis.
  ///
  /// For example, [CrossAxisAlignment.center], the default, centers the
  /// children in the cross axis (e.g., horizontally for an [AnimatedColumn]).
  final CrossAxisAlignment crossAxisAlignment;

  /// Determines the order to lay children out horizontally and how to interpret
  /// `start` and `end` in the horizontal direction.
  ///
  /// Defaults to the ambient [Directionality].
  ///
  /// If [textDirection] is [TextDirection.rtl], then the direction in which
  /// text flows starts from right to left. Otherwise, if [textDirection] is
  /// [TextDirection.ltr], then the direction in which text flows starts from
  /// left to right.
  ///
  /// If the [direction] is [Axis.horizontal], this controls the order in which
  /// the children are positioned (left-to-right or right-to-left), and the
  /// meaning of the [mainAxisAlignment] property's [MainAxisAlignment.start] and
  /// [MainAxisAlignment.end] values.
  ///
  /// If the [direction] is [Axis.horizontal], and either the
  /// [mainAxisAlignment] is either [MainAxisAlignment.start] or
  /// [MainAxisAlignment.end], or there's more than one child, then the
  /// [textDirection] (or the ambient [Directionality]) must not be null.
  ///
  /// If the [direction] is [Axis.vertical], this controls the meaning of the
  /// [crossAxisAlignment] property's [CrossAxisAlignment.start] and
  /// [CrossAxisAlignment.end] values.
  ///
  /// If the [direction] is [Axis.vertical], and the [crossAxisAlignment] is
  /// either [CrossAxisAlignment.start] or [CrossAxisAlignment.end], then the
  /// [textDirection] (or the ambient [Directionality]) must not be null.
  final TextDirection? textDirection;

  /// Determines the order to lay children out vertically and how to interpret
  /// `start` and `end` in the vertical direction.
  ///
  /// Defaults to [VerticalDirection.down].
  ///
  /// If the [direction] is [Axis.vertical], this controls which order children
  /// are painted in (down or up), the meaning of the [mainAxisAlignment]
  /// property's [MainAxisAlignment.start] and [MainAxisAlignment.end] values.
  ///
  /// If the [direction] is [Axis.vertical], and either the [mainAxisAlignment]
  /// is either [MainAxisAlignment.start] or [MainAxisAlignment.end], or there's
  /// more than one child, then the [verticalDirection] must not be null.
  ///
  /// If the [direction] is [Axis.horizontal], this controls the meaning of the
  /// [crossAxisAlignment] property's [CrossAxisAlignment.start] and
  /// [CrossAxisAlignment.end] values.
  ///
  /// If the [direction] is [Axis.horizontal], and the [crossAxisAlignment] is
  /// either [CrossAxisAlignment.start] or [CrossAxisAlignment.end], then the
  /// [verticalDirection] must not be null.
  final VerticalDirection verticalDirection;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  /// {@macro alternative_material_3.MainAxisFit}
  ///
  /// Defaults to [MainAxisFit.start].
  final MainAxisFit mainAxisFit;

  /// The widgets below this widget in the tree.
  final List<Widget?> children;

  @override
  State<AnimatedLayout> createState() => _AnimatedLayoutState();
}

class _AnimatedLayoutState extends State<AnimatedLayout>
    with SingleTickerProviderStateMixin<AnimatedLayout> {
  late AnimationController animationController;
  late Animation<double> fadeOutAnimation;
  late Animation<double> fadeInAnimation;
  late Animation<double> sizeAnimation;
  late Animation<double> reverseSizeAnimation;

  List<Widget>? lastToWidgets;
  List<Widget>? currentAnimations;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    fadeOutAnimation = CurvedAnimation(
      parent: Animation.fromValueListenable(
        animationController,
        transformer: (p0) => 1 - p0,
      ),
      curve: widget.fadeOutCurve,
    );
    fadeInAnimation = CurvedAnimation(
      parent: animationController,
      curve: widget.fadeInCurve,
    );
    sizeAnimation = CurvedAnimation(
      parent: animationController,
      curve: widget.sizeCurve,
    );
    reverseSizeAnimation = CurvedAnimation(
      parent: Animation.fromValueListenable(
        animationController,
        transformer: (p0) => 1 - p0,
      ),
      curve: widget.sizeCurve,
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      animationController.duration = widget.duration;
    }
    if (oldWidget.fadeOutCurve != widget.fadeOutCurve) {
      fadeOutAnimation = CurvedAnimation(
        parent: animationController,
        curve: widget.fadeOutCurve,
      );
    }
    if (oldWidget.fadeInCurve != widget.fadeInCurve) {
      fadeInAnimation = CurvedAnimation(
        parent: animationController,
        curve: widget.fadeInCurve,
      );
    }
    if (oldWidget.sizeCurve != widget.sizeCurve) {
      sizeAnimation = CurvedAnimation(
        parent: animationController,
        curve: widget.sizeCurve,
      );
    }
    if (!listEquality.equals(oldWidget.children, widget.children)) {
      hasChanges = true;
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  bool get isFirstBuild => lastToWidgets == null;

  bool get isAnimating => animationController.isAnimating;

  bool hasChanges = false;

  static const Widget empty = SizedBox.shrink();
  static const ListEquality<Widget?> listEquality =
      ListEquality(_WidgetEquality());

  List<Widget> withoutNulls(List<Widget?> l) =>
      l.map((e) => e ?? empty).toList(growable: false);

  void handleAnimationChange() {
    // setState(() {});
  }

  void handleAnimationStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      currentAnimations = null;
      setState(() {});
    }
  }

  void setUpAnimation() {
    animationController.removeListener(handleAnimationChange);
    animationController.removeStatusListener(handleAnimationStatusChange);
    animationController.reset();
    animationController.addListener(handleAnimationChange);
    animationController.addStatusListener(handleAnimationStatusChange);
  }

  List<Widget> animateChildren(
      TextDirection textDirection) {
    if (isFirstBuild) {
      lastToWidgets = withoutNulls(widget.children);
      return lastToWidgets!;
    }
    if (isAnimating) {
      return currentAnimations!;
    } else {
      currentAnimations = null;
    }
    if (hasChanges) {
      setUpAnimation();
      final length = math.max(lastToWidgets!.length, widget.children.length);
      currentAnimations = [];
      final fromWidgets = lastToWidgets!;
      final toWidgets = withoutNulls(widget.children);
      lastToWidgets = toWidgets;
      for (int i = 0; i < length; ++i) {
        final Widget from = i < fromWidgets.length ? fromWidgets[i] : empty;
        final Widget to = (i < toWidgets.length ? toWidgets[i] : empty);
        if (from == to) {
          currentAnimations!.add(to);
        } else {
          final crossAxis = widget.direction == Axis.horizontal
              ? Axis.vertical
              : Axis.horizontal;
          currentAnimations!.add(
            _CrossFade(
              from: from,
              to: to,
              doNotAnimate: from == empty || to == empty ? crossAxis : null,
              animationController: animationController,
              fadeOutAnimation: fadeOutAnimation,
              fadeInAnimation: fadeInAnimation,
              sizeAnimation: sizeAnimation,
              alignment: widget.animateFrom,
              clipBehaviour: widget.animationClipBehaviour,
              textDirection: textDirection,
            ),
          );
        }
      }
      animationController.forward();
      hasChanges = false;
      return currentAnimations!;
    }
    return lastToWidgets!;
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = widget.textDirection ??
        Directionality.maybeOf(context) ??
        TextDirection.ltr;
    return ArrayDistribution(
      direction: widget.direction,
      mainAxisAlignment: widget.mainAxisAlignment,
      mainAxisSize: widget.mainAxisSize,
      crossAxisAlignment: widget.crossAxisAlignment,
      textDirection: textDirection,
      clipBehavior: widget.clipBehavior,
      mainAxisFit: widget.mainAxisFit,
      children: animateChildren(textDirection),
    );
  }
}

@immutable
class _WidgetEquality implements Equality<Widget?> {
  const _WidgetEquality();

  @override
  bool equals(Widget? e1, Widget? e2) {
    if (identical(e1, e2)) {
      return true;
    }
    if (e1?.key == e2?.key && e1?.key != null) {
      return true;
    }
    if (e1 == null || e2 == null) {
      return false;
    }
    if (e1 is Icon && e2 is Icon) {
      return e1.icon == e2.icon;
    }
    if (e1 is Text && e2 is Text) {
      return e1.data == e2.data && e1.textSpan == e2.textSpan;
    }
    if (e1 is SizedBox && e2 is SizedBox) {
      return e1.width == e2.width && e1.height == e2.height &&
          equals(e1.child, e2.child);
    }
    if (e1 is ConstrainedBox && e2 is ConstrainedBox) {
      return e1.constraints == e2.constraints &&
        equals(e1.child, e2.child);
    }
    return e1 == e2;
  }

  @override
  int hash(Widget? e) {
    return e.hashCode;
  }

  @override
  bool isValidKey(Object? o) {
    return o is Widget;
  }
}

enum _CrossFadeSlot {
  from,
  to,
}

class _CrossFade extends RenderObjectWidget
    with SlottedMultiChildRenderObjectWidgetMixin<_CrossFadeSlot> {
  const _CrossFade({
    required this.from,
    required this.to,
    required this.doNotAnimate,
    required this.animationController,
    required this.fadeOutAnimation,
    required this.fadeInAnimation,
    required this.sizeAnimation,
    required this.alignment,
    required this.clipBehaviour,
    required this.textDirection,
  });

  final Widget from;
  final Widget to;
  final Axis? doNotAnimate;
  final AnimationController animationController;
  final Animation<double> fadeOutAnimation;
  final Animation<double> fadeInAnimation;
  final Animation<double> sizeAnimation;
  final AlignmentDirectional alignment;
  final Clip clipBehaviour;
  final TextDirection textDirection;

  @override
  Widget? childForSlot(_CrossFadeSlot slot) {
    Widget animatedOpacity(Widget w, Animation<double> a) {
      return AnimatedBuilder(
        animation: a,
        builder: (context, child) => Opacity(
          opacity: a.value,
          child: child,
        ),
        child: w,
      );
    }

    switch (slot) {
      case _CrossFadeSlot.from:
        return IgnorePointer(
          child: ExcludeSemantics(
            child: ExcludeFocus(
              child: animatedOpacity(from, fadeOutAnimation),
            ),
          ),
        );
      case _CrossFadeSlot.to:
        return animatedOpacity(to, fadeInAnimation);
    }
  }

  @override
  _RenderCrossFade createRenderObject(BuildContext context) {
    return _RenderCrossFade(
      doNotAnimate: doNotAnimate,
      textDirection: textDirection,
      animationController: animationController,
      sizeAnimation: sizeAnimation,
      alignment: alignment,
      clipBehavior: clipBehaviour,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderCrossFade renderObject) {
    renderObject
      ..doNotAnimate = doNotAnimate
      ..textDirection = textDirection
      ..animationController = animationController
      ..sizeAnimation = sizeAnimation
      ..alignment = alignment
      ..clipBehavior = clipBehaviour;
  }

  @override
  Iterable<_CrossFadeSlot> get slots => _CrossFadeSlot.values;
}

class _RenderCrossFade extends RenderBox
    with SlottedContainerRenderObjectMixin<_CrossFadeSlot> {
  _RenderCrossFade({
    required Axis? doNotAnimate,
    required TextDirection textDirection,
    required AnimationController animationController,
    required Animation<double> sizeAnimation,
    required AlignmentDirectional alignment,
    Clip clipBehavior = Clip.hardEdge,
  })  : _doNotAnimate = doNotAnimate,
        _textDirection = textDirection,
        _animationController = animationController,
        _sizeAnimation = sizeAnimation,
        _alignment = alignment,
        _clipBehavior = clipBehavior;

  RenderBox? get from => childForSlot(_CrossFadeSlot.from);

  RenderBox? get to => childForSlot(_CrossFadeSlot.to);

  late bool _hasVisualOverflow;
  double? _lastValue;

  Axis? get doNotAnimate => _doNotAnimate;
  Axis? _doNotAnimate;

  set doNotAnimate(Axis? value) {
    if (value != _doNotAnimate) {
      _doNotAnimate = value;
      markNeedsLayout();
    }
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;

  set textDirection(TextDirection value) {
    if (value != _textDirection) {
      _textDirection = value;
      markNeedsLayout();
    }
  }

  AnimationController get animationController => _animationController;
  AnimationController _animationController;

  set animationController(AnimationController value) {
    if (value != _animationController) {
      _animationController = value;
      markNeedsLayout();
    }
  }

  Animation<double> get sizeAnimation => _sizeAnimation;
  Animation<double> _sizeAnimation;

  set sizeAnimation(Animation<double> value) {
    if (value != _sizeAnimation) {
      _sizeAnimation = value;
      markNeedsLayout();
    }
  }

  AlignmentDirectional get alignment => _alignment;
  AlignmentDirectional _alignment;

  set alignment(AlignmentDirectional value) {
    if (value != _alignment) {
      _alignment = value;
      markNeedsLayout();
    }
  }

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge], and must not be null.
  Clip get clipBehavior => _clipBehavior;
  Clip _clipBehavior = Clip.hardEdge;

  set clipBehavior(Clip value) {
    if (value != _clipBehavior) {
      _clipBehavior = value;
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  /// Whether the size is being currently animated towards the child's size.
  ///
  /// See [RenderAnimatedSizeState] for situations when we may not be animating
  /// the size.
  bool get isAnimating => _animationController.isAnimating;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    animationController.addListener(handleAnimationChange);
    if (_lastValue != _animationController.value) {
      // Call markNeedsLayout in case the RenderObject isn't marked dirty
      // already, to resume interrupted resizing animation.
      markNeedsLayout();
    }
  }

  void handleAnimationChange() {
    if (_lastValue != _animationController.value) {
      // Call markNeedsLayout in case the RenderObject isn't marked dirty
      // already, to resume interrupted resizing animation.
      markNeedsLayout();
    }
  }

  @override
  void detach() {
    animationController.removeListener(handleAnimationChange);
    super.detach();
  }

  static Size _layoutBox(RenderBox? box, BoxConstraints constraints) {
    if (box == null) {
      return Size.zero;
    }
    box.layout(constraints, parentUsesSize: true);
    return box.size;
  }

  static Size _dryLayout(RenderBox? box, BoxConstraints constraints) {
    if (box == null) {
      return Size.zero;
    }
    box.computeDryLayout(constraints);
    return box.size;
  }

  static void _positionBox(RenderBox? box, Offset offset) {
    if (box != null) {
      final BoxParentData parentData = box.parentData! as BoxParentData;
      parentData.offset = offset;
    }
  }

  @override
  void performLayout() {
    _lastValue = _animationController.value;
    _hasVisualOverflow = false;
    final BoxConstraints constraints = this.constraints;

    final fromSize = _layoutBox(from, constraints);
    final toSize = _layoutBox(to, constraints);

    final Size animatedSize;
    switch (doNotAnimate) {
      case Axis.horizontal:
        animatedSize = Size(
          math.max(fromSize.width, toSize.width),
          lerpDouble(fromSize.height, toSize.height, sizeAnimation.value)!,
        );
      case Axis.vertical:
        animatedSize = Size(
          lerpDouble(fromSize.width, toSize.width, sizeAnimation.value)!,
          math.max(fromSize.height, toSize.height),
        );
      case null:
        animatedSize = Size.lerp(fromSize, toSize, sizeAnimation.value)!;
    }

    size = constraints.constrain(animatedSize);

    final horizontalOffsetRatio = (alignment.start + 1.0) / 2.0;
    final verticalOffsetRatio = (alignment.y + 1.0) / 2.0;

    final fromStart = (size.width - fromSize.width) * horizontalOffsetRatio;
    final toStart = (size.width - toSize.width) * horizontalOffsetRatio;

    final fromTop = (size.height - fromSize.height) * verticalOffsetRatio;
    final toTop = (size.height - toSize.height) * verticalOffsetRatio;

    switch (textDirection) {
      case TextDirection.ltr:
        _positionBox(from, Offset(fromStart, fromTop));
        _positionBox(to, Offset(toStart, toTop));
      case TextDirection.rtl:
        _positionBox(
          from,
          Offset(size.width - fromSize.width - fromStart, fromTop),
        );
        _positionBox(to, Offset(size.width - toSize.width - toStart, toTop));
    }

    if (size.width < fromSize.width ||
        size.height < fromSize.height ||
        size.width < toSize.width ||
        size.height < toSize.height) {
      _hasVisualOverflow = true;
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final fromSize = _dryLayout(from, constraints);
    final toSize = _dryLayout(to, constraints);

    return constraints.constrain(
      Size.lerp(fromSize, toSize, sizeAnimation.value)!,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    void paintToAndFrom(PaintingContext context, Offset offset) {
      void doPaint(RenderBox? child, Offset offset) {
        if (child != null) {
          final BoxParentData parentData = child.parentData! as BoxParentData;
          context.paintChild(
            child,
            parentData.offset + offset,
          );
        }
      }

      doPaint(from, offset);
      doPaint(to, offset);
    }

    if ((from != null || to != null) &&
        _hasVisualOverflow &&
        clipBehavior != Clip.none) {
      final Rect rect = Offset.zero & size;
      _clipRectLayer.layer = context.pushClipRect(
        needsCompositing,
        offset,
        rect,
        paintToAndFrom,
        clipBehavior: clipBehavior,
        oldLayer: _clipRectLayer.layer,
      );
    } else {
      _clipRectLayer.layer = null;
      paintToAndFrom(context, offset);
    }
  }

  final LayerHandle<ClipRectLayer> _clipRectLayer =
      LayerHandle<ClipRectLayer>();

  @override
  void dispose() {
    _clipRectLayer.layer = null;
    super.dispose();
  }
}

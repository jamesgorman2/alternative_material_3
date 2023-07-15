// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'always_complete_animation_controller.dart';
import 'array_distribution.dart';
import 'cross_fade.dart';

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

  List<CrossFadeRenderWidget> currentAnimations = [];

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      duration: widget.duration,
      value: 1.0,
      vsync: this,
    );
    animationController.addStatusListener(handleAnimationStatusChange);

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
  void didUpdateWidget(AnimatedLayout oldWidget) {
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
    if (!WidgetEquality.listEquality.equals(oldWidget.children, widget.children)) {
      hasChanges = true;
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  bool isFirstBuild = true;

  bool get isAnimating => animationController.isAnimating;

  bool hasChanges = false;
  bool animationCompleteWidgetNotUpdated = false;

  static const Widget empty = SizedBox.shrink();

  List<Widget> withoutNulls(List<Widget?> l) =>
      l.map((e) => e ?? empty).toList(growable: false);

  void handleAnimationStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        animationCompleteWidgetNotUpdated = true;
      });
    }
  }

  CrossFadeRenderWidget updateCrossFade({
    CrossFadeRenderWidget? oldCrossFade,
    required Widget newWidget,
    required TextDirection textDirection,
  }) {
    const equality = WidgetEquality();
    final crossAxis =
        widget.direction == Axis.horizontal ? Axis.vertical : Axis.horizontal;
    if (oldCrossFade != null) {
      switch (oldCrossFade.direction) {
        case CrossFadeDirection.aToB:
          if (equality.equals(newWidget, oldCrossFade.b)) {
            return CrossFadeRenderWidget(
              a: empty,
              b: newWidget,
              direction: CrossFadeDirection.aToB,
              doNotAnimate: null,
              animationController: kAlwaysCompleteAnimationController,
              fadeOutAnimation: kAlwaysDismissedAnimation,
              fadeInAnimation: kAlwaysCompleteAnimation,
              sizeAnimation: kAlwaysCompleteAnimation,
              alignment: widget.animateFrom,
              clipBehaviour: widget.animationClipBehaviour,
              textDirection: textDirection,
            );
          }
          return CrossFadeRenderWidget(
            a: newWidget,
            b: oldCrossFade.b,
            direction: CrossFadeDirection.bToA,
            doNotAnimate: newWidget == empty || oldCrossFade.b == empty
                ? crossAxis
                : null,
            animationController: animationController,
            fadeOutAnimation: fadeOutAnimation,
            fadeInAnimation: fadeInAnimation,
            sizeAnimation: sizeAnimation,
            alignment: widget.animateFrom,
            clipBehaviour: widget.animationClipBehaviour,
            textDirection: textDirection,
          );
        case CrossFadeDirection.bToA:
          if (equality.equals(newWidget, oldCrossFade.a)) {
            return CrossFadeRenderWidget(
              a: newWidget,
              b: empty,
              direction: CrossFadeDirection.bToA,
              doNotAnimate: null,
              animationController: kAlwaysCompleteAnimationController,
              fadeOutAnimation: kAlwaysDismissedAnimation,
              fadeInAnimation: kAlwaysCompleteAnimation,
              sizeAnimation: kAlwaysCompleteAnimation,
              alignment: widget.animateFrom,
              clipBehaviour: widget.animationClipBehaviour,
              textDirection: textDirection,
            );
          }
          return CrossFadeRenderWidget(
            a: oldCrossFade.a,
            b: newWidget,
            direction: CrossFadeDirection.aToB,
            doNotAnimate: oldCrossFade.a == empty || newWidget == empty
                ? crossAxis
                : null,
            animationController: animationController,
            fadeOutAnimation: fadeOutAnimation,
            fadeInAnimation: fadeInAnimation,
            sizeAnimation: sizeAnimation,
            alignment: widget.animateFrom,
            clipBehaviour: widget.animationClipBehaviour,
            textDirection: textDirection,
          );
      }
    } else {
      return CrossFadeRenderWidget(
        a: newWidget,
        b: empty,
        direction: CrossFadeDirection.bToA,
        doNotAnimate: null,
        animationController: animationController,
        fadeOutAnimation: fadeOutAnimation,
        fadeInAnimation: fadeInAnimation,
        sizeAnimation: sizeAnimation,
        alignment: widget.animateFrom,
        clipBehaviour: widget.animationClipBehaviour,
        textDirection: textDirection,
      );
    }
  }

  void setUpAnimation() {
    animationController.removeStatusListener(handleAnimationStatusChange);
    animationController.reset();
    animationController.addStatusListener(handleAnimationStatusChange);
  }

  List<Widget> animateChildren(TextDirection textDirection) {
    if (isFirstBuild) {
      isFirstBuild = false;
      currentAnimations = withoutNulls(widget.children)
          .map((newWidget) => updateCrossFade(
                newWidget: newWidget,
                textDirection: textDirection,
              ))
          .toList();
      return currentAnimations;
    }
    if (animationCompleteWidgetNotUpdated) {
      animationCompleteWidgetNotUpdated = false;
      currentAnimations = currentAnimations
          .map((crossFade) => updateCrossFade(
                oldCrossFade: crossFade,
                newWidget: crossFade.direction == CrossFadeDirection.aToB
                    ? crossFade.b
                    : crossFade.a,
                textDirection: textDirection,
              ))
          .toList();
      return currentAnimations;
    }
    if (!isAnimating && hasChanges) {
      final length = math.max(currentAnimations.length, widget.children.length);
      final List<CrossFadeRenderWidget> newCurrentAnimations = [];
      final toWidgets = withoutNulls(widget.children);
      for (int i = 0; i < length; ++i) {
        final CrossFadeRenderWidget? oldCrossFace =
            i < currentAnimations.length ? currentAnimations[i] : null;
        final Widget newWidget = i < toWidgets.length ? toWidgets[i] : empty;
        newCurrentAnimations.add(
          updateCrossFade(
            oldCrossFade: oldCrossFace,
            newWidget: newWidget,
            textDirection: textDirection,
          ),
        );
      }
      setUpAnimation();
      animationController.forward();
      currentAnimations = newCurrentAnimations;
      hasChanges = false;
    }
    return currentAnimations;
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

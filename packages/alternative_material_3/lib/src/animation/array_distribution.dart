// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'animated_layout.dart';

/// A [Flex]-like layout that will fit its children into the available space.
///
/// Unlike [Flex], this does not use flexible layouts. Instead it fits its
/// children according to [mainAxisFit].
class ArrayDistribution extends MultiChildRenderObjectWidget {
  /// Creates a array layout.
  ///
  /// The [direction] is required.
  ///
  /// The [direction], [mainAxisAlignment], [crossAxisAlignment], and
  /// [verticalDirection] arguments must not be null. [crossAxisAlignment]
  /// must not be [CrossAxisAlignment.baseline].
  ///
  /// The [textDirection] argument defaults to the ambient [Directionality], if
  /// any. If there is no ambient directionality, and a text direction is going
  /// to be necessary to decide which direction to lay the children in or to
  /// disambiguate `start` or `end` values for the main or cross axis
  /// directions, the [textDirection] must not be null.
  const ArrayDistribution({
    super.key,
    required this.direction,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.clipBehavior = Clip.none,
    this.mainAxisFit = MainAxisFit.start,
    super.children,
  }) : assert(!identical(crossAxisAlignment, CrossAxisAlignment.baseline),
            'CrossAxisAlignment.baseline is only applicable to Flex layouts');

  // Cannot use == in the assert above instead of identical because of https://github.com/dart-lang/language/issues/1811.

  /// The direction to use as the main axis.
  ///
  /// If you know the axis in advance, then consider using a [Row] (if it's
  /// horizontal) or [Column] (if it's vertical) instead of a [ArrayDistribution], since that
  /// will be less verbose. (For [Row] and [Column] this property is fixed to
  /// the appropriate axis.)
  final Axis direction;

  /// How the children should be placed along the main axis.
  ///
  /// For example, [MainAxisAlignment.start], the default, places the children
  /// at the start (i.e., the left for a [Row] or the top for a [Column]) of the
  /// main axis.
  final MainAxisAlignment mainAxisAlignment;

  /// How much space should be occupied in the main axis.
  ///
  /// After allocating space to children, there might be some remaining free
  /// space. This value controls whether to maximize or minimize the amount of
  /// free space, subject to the incoming layout constraints.
  final MainAxisSize mainAxisSize;

  /// How the children should be placed along the cross axis.
  ///
  /// For example, [CrossAxisAlignment.center], the default, centers the
  /// children in the cross axis (e.g., horizontally for a [Column]).
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
  /// Defaults to [Clip.none].
  final Clip clipBehavior;

  /// {@macro alternative_material_3.MainAxisFit}
  ///
  /// Defaults to [MainAxisFit.start].
  final MainAxisFit mainAxisFit;

  bool get _needTextDirection {
    switch (direction) {
      case Axis.horizontal:
        return true; // because it affects the layout order.
      case Axis.vertical:
        return crossAxisAlignment == CrossAxisAlignment.start ||
            crossAxisAlignment == CrossAxisAlignment.end;
    }
  }

  /// The value to pass to [RenderArrayDistribution.textDirection].
  ///
  /// This value is derived from the [textDirection] property and the ambient
  /// [Directionality]. The value is null if there is no need to specify the
  /// text direction. In practice there's always a need to specify the direction
  /// except for vertical flexes (e.g. [Column]s) whose [crossAxisAlignment] is
  /// not dependent on the text direction (not `start` or `end`). In particular,
  /// a [Row] always needs a text direction because the text direction controls
  /// its layout order. (For [Column]s, the layout order is controlled by
  /// [verticalDirection], which is always specified as it does not depend on an
  /// inherited widget and defaults to [VerticalDirection.down].)
  ///
  /// This method exists so that subclasses of [ArrayDistribution] that create their own
  /// render objects that are derived from [RenderArrayDistribution] can do so and still use
  /// the logic for providing a text direction only when it is necessary.
  @protected
  TextDirection? getEffectiveTextDirection(BuildContext context) {
    return textDirection ??
        (_needTextDirection ? Directionality.maybeOf(context) : null);
  }

  @override
  RenderArrayDistribution createRenderObject(BuildContext context) {
    return RenderArrayDistribution(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: getEffectiveTextDirection(context),
      verticalDirection: verticalDirection,
      clipBehavior: clipBehavior,
      mainAxisFit: mainAxisFit,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderArrayDistribution renderObject) {
    renderObject
      ..direction = direction
      ..mainAxisAlignment = mainAxisAlignment
      ..mainAxisSize = mainAxisSize
      ..crossAxisAlignment = crossAxisAlignment
      ..textDirection = getEffectiveTextDirection(context)
      ..verticalDirection = verticalDirection
      ..clipBehavior = clipBehavior
      ..mainAxisFit = mainAxisFit;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<Axis>('direction', direction));
    properties.add(EnumProperty<MainAxisAlignment>(
        'mainAxisAlignment', mainAxisAlignment));
    properties.add(EnumProperty<MainAxisSize>('mainAxisSize', mainAxisSize,
        defaultValue: MainAxisSize.max));
    properties.add(EnumProperty<CrossAxisAlignment>(
        'crossAxisAlignment', crossAxisAlignment));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection,
        defaultValue: null));
    properties.add(EnumProperty<VerticalDirection>(
        'verticalDirection', verticalDirection,
        defaultValue: VerticalDirection.down));
    properties.add(EnumProperty<MainAxisFit>('mainAxisFit', mainAxisFit,
        defaultValue: null));
  }
}

bool? _startIsTopLeft(Axis direction, TextDirection? textDirection,
    VerticalDirection? verticalDirection) {
  // If the relevant value of textDirection or verticalDirection is null, this returns null too.
  switch (direction) {
    case Axis.horizontal:
      switch (textDirection) {
        case TextDirection.ltr:
          return true;
        case TextDirection.rtl:
          return false;
        case null:
          return null;
      }
    case Axis.vertical:
      switch (verticalDirection) {
        case VerticalDirection.down:
          return true;
        case VerticalDirection.up:
          return false;
        case null:
          return null;
      }
  }
}

/// Marker class for parent data.
class ArrayFitParentData extends ContainerBoxParentData<RenderBox> {}

typedef _ChildSizingFunction = double Function(RenderBox child, double extent);

/// Displays its children in a one-dimensional array.
///
/// ## Layout algorithm
///
/// _This section describes how the framework causes [RenderArrayDistribution] to position
/// its children._
/// _See [BoxConstraints] for an introduction to box layout models._
///
/// Layout for a [RenderArrayDistribution] proceeds in six steps:
///
///
/// See also:
///
///  * [AnimatedLayout], the widget equivalent.
///  * [AnimatedRow] and [AnimatedColumn], direction-specific variants of [AnimatedLayout].
class RenderArrayDistribution extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, ArrayFitParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, ArrayFitParentData>,
        DebugOverflowIndicatorMixin {
  /// Creates an array render object.
  ///
  /// By default, the flex layout is horizontal and children are aligned to the
  /// start of the main axis and the center of the cross axis.
  RenderArrayDistribution({
    List<RenderBox>? children,
    Axis direction = Axis.horizontal,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    Clip clipBehavior = Clip.none,
    MainAxisFit mainAxisFit = MainAxisFit.start,
  })  : _direction = direction,
        _mainAxisAlignment = mainAxisAlignment,
        _mainAxisSize = mainAxisSize,
        _crossAxisAlignment = crossAxisAlignment,
        _textDirection = textDirection,
        _verticalDirection = verticalDirection,
        _clipBehavior = clipBehavior,
        _mainAxisFit = mainAxisFit {
    addAll(children);
  }

  /// The direction to use as the main axis.
  Axis get direction => _direction;
  Axis _direction;

  set direction(Axis value) {
    if (_direction != value) {
      _direction = value;
      markNeedsLayout();
    }
  }

  /// How the children should be placed along the main axis.
  ///
  /// If the [direction] is [Axis.horizontal], and the [mainAxisAlignment] is
  /// either [MainAxisAlignment.start] or [MainAxisAlignment.end], then the
  /// [textDirection] must not be null.
  ///
  /// If the [direction] is [Axis.vertical], and the [mainAxisAlignment] is
  /// either [MainAxisAlignment.start] or [MainAxisAlignment.end], then the
  /// [verticalDirection] must not be null.
  MainAxisAlignment get mainAxisAlignment => _mainAxisAlignment;
  MainAxisAlignment _mainAxisAlignment;

  set mainAxisAlignment(MainAxisAlignment value) {
    if (_mainAxisAlignment != value) {
      _mainAxisAlignment = value;
      markNeedsLayout();
    }
  }

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
  MainAxisSize get mainAxisSize => _mainAxisSize;
  MainAxisSize _mainAxisSize;

  set mainAxisSize(MainAxisSize value) {
    if (_mainAxisSize != value) {
      _mainAxisSize = value;
      markNeedsLayout();
    }
  }

  /// How the children should be placed along the cross axis.
  ///
  /// If the [direction] is [Axis.horizontal], and the [crossAxisAlignment] is
  /// either [CrossAxisAlignment.start] or [CrossAxisAlignment.end], then the
  /// [verticalDirection] must not be null.
  ///
  /// If the [direction] is [Axis.vertical], and the [crossAxisAlignment] is
  /// either [CrossAxisAlignment.start] or [CrossAxisAlignment.end], then the
  /// [textDirection] must not be null.
  CrossAxisAlignment get crossAxisAlignment => _crossAxisAlignment;
  CrossAxisAlignment _crossAxisAlignment;

  set crossAxisAlignment(CrossAxisAlignment value) {
    if (_crossAxisAlignment != value) {
      _crossAxisAlignment = value;
      markNeedsLayout();
    }
  }

  /// Determines the order to lay children out horizontally and how to interpret
  /// `start` and `end` in the horizontal direction.
  ///
  /// If the [direction] is [Axis.horizontal], this controls the order in which
  /// children are positioned (left-to-right or right-to-left), and the meaning
  /// of the [mainAxisAlignment] property's [MainAxisAlignment.start] and
  /// [MainAxisAlignment.end] values.
  ///
  /// If the [direction] is [Axis.horizontal], and either the
  /// [mainAxisAlignment] is either [MainAxisAlignment.start] or
  /// [MainAxisAlignment.end], or there's more than one child, then the
  /// [textDirection] must not be null.
  ///
  /// If the [direction] is [Axis.vertical], this controls the meaning of the
  /// [crossAxisAlignment] property's [CrossAxisAlignment.start] and
  /// [CrossAxisAlignment.end] values.
  ///
  /// If the [direction] is [Axis.vertical], and the [crossAxisAlignment] is
  /// either [CrossAxisAlignment.start] or [CrossAxisAlignment.end], then the
  /// [textDirection] must not be null.
  TextDirection? get textDirection => _textDirection;
  TextDirection? _textDirection;

  set textDirection(TextDirection? value) {
    if (_textDirection != value) {
      _textDirection = value;
      markNeedsLayout();
    }
  }

  /// Determines the order to lay children out vertically and how to interpret
  /// `start` and `end` in the vertical direction.
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
  VerticalDirection get verticalDirection => _verticalDirection;
  VerticalDirection _verticalDirection;

  set verticalDirection(VerticalDirection value) {
    if (_verticalDirection != value) {
      _verticalDirection = value;
      markNeedsLayout();
    }
  }

  bool get _debugHasNecessaryDirections {
    if (firstChild != null && lastChild != firstChild) {
      // i.e. there's more than one child
      switch (direction) {
        case Axis.horizontal:
          assert(textDirection != null,
              'Horizontal $runtimeType with multiple children has a null textDirection, so the layout order is undefined.');
        case Axis.vertical:
          break;
      }
    }
    if (mainAxisAlignment == MainAxisAlignment.start ||
        mainAxisAlignment == MainAxisAlignment.end) {
      switch (direction) {
        case Axis.horizontal:
          assert(textDirection != null,
              'Horizontal $runtimeType with $mainAxisAlignment has a null textDirection, so the alignment cannot be resolved.');
        case Axis.vertical:
          break;
      }
    }
    if (crossAxisAlignment == CrossAxisAlignment.start ||
        crossAxisAlignment == CrossAxisAlignment.end) {
      switch (direction) {
        case Axis.horizontal:
          break;
        case Axis.vertical:
          assert(textDirection != null,
              'Vertical $runtimeType with $crossAxisAlignment has a null textDirection, so the alignment cannot be resolved.');
      }
    }
    return true;
  }

  // Set during layout if overflow occurred on the main axis.
  double _overflow = 0;

  // Check whether any meaningful overflow is present. Values below an epsilon
  // are treated as not overflowing.
  bool get _hasOverflow => _overflow > precisionErrorTolerance;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.none], and must not be null.
  Clip get clipBehavior => _clipBehavior;
  Clip _clipBehavior = Clip.none;

  set clipBehavior(Clip value) {
    if (value != _clipBehavior) {
      _clipBehavior = value;
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  /// {@macro alternative_material_3.MainAxisFit}
  ///
  /// Defaults to [MainAxisFit.start].
  MainAxisFit get mainAxisFit => _mainAxisFit;
  MainAxisFit _mainAxisFit;

  set mainAxisFit(MainAxisFit value) {
    if (value != _mainAxisFit) {
      _mainAxisFit = value;
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! ArrayFitParentData) {
      child.parentData = ArrayFitParentData();
    }
  }

  bool get _canComputeIntrinsics =>
      crossAxisAlignment != CrossAxisAlignment.baseline;

  double _getIntrinsicSize({
    required Axis sizingDirection,
    required double
        extent, // the extent in the direction that isn't the sizing direction
    required _ChildSizingFunction
        childSize, // a method to find the size in the sizing direction
  }) {
    if (!_canComputeIntrinsics) {
      // Intrinsics cannot be calculated without a full layout for
      // baseline alignment. Throw an assertion and return 0.0 as documented
      // on [RenderBox.computeMinIntrinsicWidth].
      assert(
        RenderObject.debugCheckingIntrinsics,
        'Intrinsics are not available for CrossAxisAlignment.baseline.',
      );
      return 0.0;
    }
    if (_direction == sizingDirection) {
      // INTRINSIC MAIN SIZE
      double inflexibleSpace = 0.0;
      RenderBox? child = firstChild;
      while (child != null) {
        inflexibleSpace += childSize(child, extent);
        final ArrayFitParentData childParentData =
            child.parentData! as ArrayFitParentData;
        child = childParentData.nextSibling;
      }
      return inflexibleSpace;
    } else {
      double maxCrossSize = 0.0;
      RenderBox? child = firstChild;
      while (child != null) {
        late final double mainSize;
        late final double crossSize;
        switch (_direction) {
          case Axis.horizontal:
            mainSize = child.getMaxIntrinsicWidth(double.infinity);
            crossSize = childSize(child, mainSize);
          case Axis.vertical:
            mainSize = child.getMaxIntrinsicHeight(double.infinity);
            crossSize = childSize(child, mainSize);
        }
        maxCrossSize = math.max(maxCrossSize, crossSize);
        final ArrayFitParentData childParentData =
            child.parentData! as ArrayFitParentData;
        child = childParentData.nextSibling;
      }

      return maxCrossSize;
    }
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return _getIntrinsicSize(
      sizingDirection: Axis.horizontal,
      extent: height,
      childSize: (RenderBox child, double extent) =>
          child.getMinIntrinsicWidth(extent),
    );
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _getIntrinsicSize(
      sizingDirection: Axis.horizontal,
      extent: height,
      childSize: (RenderBox child, double extent) =>
          child.getMaxIntrinsicWidth(extent),
    );
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return _getIntrinsicSize(
      sizingDirection: Axis.vertical,
      extent: width,
      childSize: (RenderBox child, double extent) =>
          child.getMinIntrinsicHeight(extent),
    );
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return _getIntrinsicSize(
      sizingDirection: Axis.vertical,
      extent: width,
      childSize: (RenderBox child, double extent) =>
          child.getMaxIntrinsicHeight(extent),
    );
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    if (_direction == Axis.horizontal) {
      return defaultComputeDistanceToHighestActualBaseline(baseline);
    }
    return defaultComputeDistanceToFirstActualBaseline(baseline);
  }

  double _getCrossSize(Size size) {
    switch (_direction) {
      case Axis.horizontal:
        return size.height;
      case Axis.vertical:
        return size.width;
    }
  }

  double _getMainSize(Size size) {
    switch (_direction) {
      case Axis.horizontal:
        return size.width;
      case Axis.vertical:
        return size.height;
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    if (!_canComputeIntrinsics) {
      assert(debugCannotComputeDryLayout(
        reason:
            'Dry layout cannot be computed for CrossAxisAlignment.baseline, which requires a full layout.',
      ));
      return Size.zero;
    }

    final _LayoutSizes sizes = _computeSizes(
      layoutChild: ChildLayoutHelper.dryLayoutChild,
      constraints: constraints,
    );

    switch (_direction) {
      case Axis.horizontal:
        return constraints.constrain(Size(sizes.mainSize, sizes.crossSize));
      case Axis.vertical:
        return constraints.constrain(Size(sizes.crossSize, sizes.mainSize));
    }
  }

  _LayoutSizes _computeSizes({
    required BoxConstraints constraints,
    required ChildLayouter layoutChild,
  }) {
    assert(_debugHasNecessaryDirections);

    RenderBox? startChild;
    RenderBox? endChild;
    bool lastWasStart = false;
    RenderBox? nextChild(RenderBox? currentChild) {
      switch (_mainAxisFit) {
        case MainAxisFit.start:
          if (currentChild != null) {
            final ArrayFitParentData childParentData =
                currentChild.parentData! as ArrayFitParentData;
            return childParentData.nextSibling;
          }
          return firstChild;
        case MainAxisFit.end:
          if (currentChild != null) {
            final ArrayFitParentData childParentData =
                currentChild.parentData! as ArrayFitParentData;
            return childParentData.previousSibling;
          }
          return lastChild;
        case MainAxisFit.startAndEnd:
          if (currentChild != null) {
            if (lastWasStart) {
              if (endChild == null) {
                endChild = lastChild;
              } else {
                final ArrayFitParentData childParentData =
                endChild!.parentData! as ArrayFitParentData;
                endChild = childParentData.previousSibling;
              }
              lastWasStart = false;
              return identical(startChild, endChild) ? null : endChild;
            } else {
              final ArrayFitParentData childParentData =
                  startChild!.parentData! as ArrayFitParentData;
              startChild = childParentData.nextSibling;
              lastWasStart = true;
              return identical(startChild, endChild) ? null : startChild;
            }
          }
          startChild = firstChild;
          return startChild;
      }
    }

    double remainingSize = _direction == Axis.horizontal
        ? constraints.maxWidth
        : constraints.maxHeight;

    double crossSize = 0.0;
    double allocatedSize =
        0.0; // Sum of the sizes of the non-flexible children.
    RenderBox? child = nextChild(null);
    while (child != null) {
      final BoxConstraints innerConstraints;
      if (crossAxisAlignment == CrossAxisAlignment.stretch) {
        switch (_direction) {
          case Axis.horizontal:
            innerConstraints = BoxConstraints(
              maxWidth: remainingSize,
              minHeight: constraints.maxHeight,
              maxHeight: constraints.maxHeight,
            );
          case Axis.vertical:
            innerConstraints = BoxConstraints(
              minWidth: constraints.maxWidth,
              maxWidth: constraints.maxWidth,
              maxHeight: remainingSize,
            );
        }
      } else {
        switch (_direction) {
          case Axis.horizontal:
            innerConstraints = BoxConstraints(
              maxWidth: remainingSize,
              maxHeight: constraints.maxHeight,
            );
          case Axis.vertical:
            innerConstraints = BoxConstraints(
              maxWidth: constraints.maxWidth,
              maxHeight: remainingSize,
            );
        }
      }
      final Size childSize = layoutChild(child, innerConstraints);
      allocatedSize += _getMainSize(childSize);
      crossSize = math.max(crossSize, _getCrossSize(childSize));
      remainingSize -=
          _direction == Axis.horizontal ? childSize.width : childSize.height;

      child = nextChild(child);
    }

    return _LayoutSizes(
      mainSize: allocatedSize,
      crossSize: crossSize,
      allocatedSize: allocatedSize,
    );
  }

  @override
  void performLayout() {
    assert(_debugHasNecessaryDirections);
    final BoxConstraints constraints = this.constraints;

    final _LayoutSizes sizes = _computeSizes(
      layoutChild: ChildLayoutHelper.layoutChild,
      constraints: constraints,
    );

    final double allocatedSize = sizes.allocatedSize;
    double actualSize = sizes.mainSize;
    double crossSize = sizes.crossSize;

    // Align items along the main axis.
    switch (_direction) {
      case Axis.horizontal:
        size = constraints.constrain(Size(actualSize, crossSize));
        actualSize = size.width;
        crossSize = size.height;
      case Axis.vertical:
        size = constraints.constrain(Size(crossSize, actualSize));
        actualSize = size.height;
        crossSize = size.width;
    }
    final double actualSizeDelta = actualSize - allocatedSize;
    _overflow = math.max(0.0, -actualSizeDelta);
    final double remainingSpace = math.max(0.0, actualSizeDelta);
    late final double leadingSpace;
    late final double betweenSpace;
    // flipMainAxis is used to decide whether to lay out
    // left-to-right/top-to-bottom (false), or right-to-left/bottom-to-top
    // (true). The _startIsTopLeft will return null if there's only one child
    // and the relevant direction is null, in which case we arbitrarily decide
    // to flip, but that doesn't have any detectable effect.
    final bool flipMainAxis =
        !(_startIsTopLeft(direction, textDirection, verticalDirection) ?? true);
    switch (_mainAxisAlignment) {
      case MainAxisAlignment.start:
        leadingSpace = 0.0;
        betweenSpace = 0.0;
      case MainAxisAlignment.end:
        leadingSpace = remainingSpace;
        betweenSpace = 0.0;
      case MainAxisAlignment.center:
        leadingSpace = remainingSpace / 2.0;
        betweenSpace = 0.0;
      case MainAxisAlignment.spaceBetween:
        leadingSpace = 0.0;
        betweenSpace = childCount > 1 ? remainingSpace / (childCount - 1) : 0.0;
      case MainAxisAlignment.spaceAround:
        betweenSpace = childCount > 0 ? remainingSpace / childCount : 0.0;
        leadingSpace = betweenSpace / 2.0;
      case MainAxisAlignment.spaceEvenly:
        betweenSpace = childCount > 0 ? remainingSpace / (childCount + 1) : 0.0;
        leadingSpace = betweenSpace;
    }

    // Position elements
    double childMainPosition =
        flipMainAxis ? actualSize - leadingSpace : leadingSpace;
    RenderBox? child = firstChild;
    while (child != null) {
      final ArrayFitParentData childParentData =
          child.parentData! as ArrayFitParentData;
      final double childCrossPosition;
      switch (_crossAxisAlignment) {
        case CrossAxisAlignment.start:
        case CrossAxisAlignment.end:
        case CrossAxisAlignment.baseline:
          childCrossPosition = _startIsTopLeft(
                      flipAxis(direction), textDirection, verticalDirection) ==
                  (_crossAxisAlignment == CrossAxisAlignment.start)
              ? 0.0
              : crossSize - _getCrossSize(child.size);
        case CrossAxisAlignment.center:
          childCrossPosition =
              crossSize / 2.0 - _getCrossSize(child.size) / 2.0;
        case CrossAxisAlignment.stretch:
          childCrossPosition = 0.0;
      }
      if (flipMainAxis) {
        childMainPosition -= _getMainSize(child.size);
      }
      switch (_direction) {
        case Axis.horizontal:
          childParentData.offset =
              Offset(childMainPosition, childCrossPosition);
        case Axis.vertical:
          childParentData.offset =
              Offset(childCrossPosition, childMainPosition);
      }
      if (flipMainAxis) {
        childMainPosition -= betweenSpace;
      } else {
        childMainPosition += _getMainSize(child.size) + betweenSpace;
      }
      child = childParentData.nextSibling;
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (!_hasOverflow) {
      defaultPaint(context, offset);
      return;
    }

    // There's no point in drawing the children if we're empty.
    if (size.isEmpty) {
      return;
    }

    _clipRectLayer.layer = context.pushClipRect(
      needsCompositing,
      offset,
      Offset.zero & size,
      defaultPaint,
      clipBehavior: clipBehavior,
      oldLayer: _clipRectLayer.layer,
    );

    assert(() {
      final List<DiagnosticsNode> debugOverflowHints = <DiagnosticsNode>[
        ErrorDescription(
          'The overflowing $runtimeType has an orientation of $_direction.',
        ),
        ErrorDescription(
          'The edge of the $runtimeType that is overflowing has been marked '
          'in the rendering with a yellow and black striped pattern. This is '
          'usually caused by the contents being too big for the $runtimeType.',
        ),
        ErrorHint(
          'Consider applying a flex factor (e.g. using an Expanded widget) to '
          'force the children of the $runtimeType to fit within the available '
          'space instead of being sized to their natural size.',
        ),
        ErrorHint(
          'This is considered an error condition because it indicates that there '
          'is content that cannot be seen. If the content is legitimately bigger '
          'than the available space, consider clipping it with a ClipRect widget '
          'before putting it in the flex, or using a scrollable container rather '
          'than a Flex, like a ListView.',
        ),
      ];

      // Simulate a child rect that overflows by the right amount. This child
      // rect is never used for drawing, just for determining the overflow
      // location and amount.
      final Rect overflowChildRect;
      switch (_direction) {
        case Axis.horizontal:
          overflowChildRect =
              Rect.fromLTWH(0.0, 0.0, size.width + _overflow, 0.0);
        case Axis.vertical:
          overflowChildRect =
              Rect.fromLTWH(0.0, 0.0, 0.0, size.height + _overflow);
      }
      paintOverflowIndicator(
          context, offset, Offset.zero & size, overflowChildRect,
          overflowHints: debugOverflowHints);
      return true;
    }());
  }

  final LayerHandle<ClipRectLayer> _clipRectLayer =
      LayerHandle<ClipRectLayer>();

  @override
  void dispose() {
    _clipRectLayer.layer = null;
    super.dispose();
  }

  @override
  Rect? describeApproximatePaintClip(RenderObject child) {
    switch (clipBehavior) {
      case Clip.none:
        return null;
      case Clip.hardEdge:
      case Clip.antiAlias:
      case Clip.antiAliasWithSaveLayer:
        return _hasOverflow ? Offset.zero & size : null;
    }
  }

  @override
  String toStringShort() {
    String header = super.toStringShort();
    if (!kReleaseMode) {
      if (_hasOverflow) {
        header += ' OVERFLOWING';
      }
    }
    return header;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<Axis>('direction', direction));
    properties.add(EnumProperty<MainAxisAlignment>(
        'mainAxisAlignment', mainAxisAlignment));
    properties.add(EnumProperty<MainAxisSize>('mainAxisSize', mainAxisSize));
    properties.add(EnumProperty<CrossAxisAlignment>(
        'crossAxisAlignment', crossAxisAlignment));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection,
        defaultValue: null));
    properties.add(EnumProperty<VerticalDirection>(
        'verticalDirection', verticalDirection,
        defaultValue: null));
    properties.add(EnumProperty<MainAxisFit>('mainAxisFit', mainAxisFit,
        defaultValue: null));
  }
}

class _LayoutSizes {
  const _LayoutSizes({
    required this.mainSize,
    required this.crossSize,
    required this.allocatedSize,
  });

  final double mainSize;
  final double crossSize;
  final double allocatedSize;
}

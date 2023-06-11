import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ButtonContent extends StatefulWidget {
  ///
  const ButtonContent({
    super.key,
    required this.startPadding,
    required this.endLeadingPadding,
    required this.startTrailingPadding,
    required this.endPadding,
    required this.leadingIcon,
    required this.label,
    required this.trailingIcon,
    required this.containerConstraints,
    required this.animationDuration,
    this.maxConcurrentAnimations = 3,
  });

  final double startPadding;
  final double endLeadingPadding;
  final double startTrailingPadding;
  final double endPadding;

  final Widget? leadingIcon;
  final Widget? label;
  final Widget? trailingIcon;

  final BoxConstraints containerConstraints;

  final Duration animationDuration;

  /// The number of concurrent animations that will be rendered
  /// per location. When this value is exceeded, the oldest
  /// animations will be dropped first.
  ///
  /// The default value is 3.
  final int maxConcurrentAnimations;

  @override
  State<ButtonContent> createState() => _ButtonContentState();
}

class _ButtonContentState extends State<ButtonContent>
    with TickerProviderStateMixin {
  late _ButtonPadding startPadding;
  late _ButtonPadding endLeadingPadding;
  late _ButtonPadding startTrailingPadding;
  late _ButtonPadding endPadding;
  final ListQueue<_ButtonElement> leadingIcons = ListQueue();
  final ListQueue<_ButtonElement> labels = ListQueue();
  final ListQueue<_ButtonElement> trailingIcons = ListQueue();

  double get _endLeadingPadding =>
      widget.leadingIcon != null && widget.label != null
          ? widget.endLeadingPadding
          : 0.0;

  double get _startTrailingPadding => widget.trailingIcon != null &&
          (widget.leadingIcon != null || widget.label != null)
      ? widget.startTrailingPadding
      : 0.0;

  @override
  void initState() {
    super.initState();
    startPadding = _FixedButtonPadding(widget.startPadding);
    endLeadingPadding = _FixedButtonPadding(_endLeadingPadding);
    startTrailingPadding = _FixedButtonPadding(_startTrailingPadding);
    endPadding = _FixedButtonPadding(widget.endPadding);

    if (widget.leadingIcon != null) {
      leadingIcons.add(
        _newElement(
          slot: _ContentSlot.leadingIcon,
          child: widget.leadingIcon,
          value: 1.0,
        ),
      );
    }
    if (widget.label != null) {
      labels.add(
        _newElement(
          slot: _ContentSlot.label,
          child: widget.label,
          value: 1.0,
        ),
      );
    }
    if (widget.trailingIcon != null) {
      trailingIcons.add(
        _newElement(
          slot: _ContentSlot.trailingIcon,
          child: widget.trailingIcon,
          value: 1.0,
        ),
      );
    }
  }

  @override
  void didUpdateWidget(covariant ButtonContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.leadingIcon != widget.leadingIcon) {
      _startNewAnimation(
        slot: _ContentSlot.leadingIcon,
        queue: leadingIcons,
        child: widget.leadingIcon,
      );
    }
    if (oldWidget.label != widget.label) {
      _startNewAnimation(
        slot: _ContentSlot.label,
        queue: labels,
        child: widget.label,
      );
    }
    if (oldWidget.trailingIcon != widget.trailingIcon) {
      _startNewAnimation(
        slot: _ContentSlot.trailingIcon,
        queue: trailingIcons,
        child: widget.trailingIcon,
      );
    }
  }

  @override
  void dispose() {
    // dispose animations
    startPadding.dispose();
    endLeadingPadding.dispose();
    startTrailingPadding.dispose();
    endPadding.dispose();
    leadingIcons.forEach((element) => element.dispose());
    labels.forEach((element) => element.dispose());
    trailingIcons.forEach((element) => element.dispose());
    super.dispose();
  }

  _ButtonElement _newElement({
    required _ContentSlot slot,
    Widget? child,
    double value = 0.0,
  }) {
    if (child == null) {
      return _NullButtonElement(slot: slot);
    }
    final controller = AnimationController(
      value: value,
      duration: widget.animationDuration,
      vsync: this,
    )..addListener(() => setState(() {}));
    return _AnimatedButtonElement(
      slot: slot,
      controller: controller,
      opacityAnimation: CurvedAnimation(
        curve: Curves.fastEaseInToSlowEaseOut,
        parent: controller,
        reverseCurve: Curves.fastEaseInToSlowEaseOut,
      ),
      widget: child,
    );
  }

  _ButtonPadding _newPaddingAnimation({
    required double begin,
    required double end,
  }) {
    if (begin == end) {
      return _FixedButtonPadding(end);
    }
    final controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    )..addListener(() => setState(() {}));
    return _AnimatedButtonPadding(
      controller,
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
        reverseCurve: Curves.easeInOut,
      ),
      Tween(begin: begin, end: end),
    );
  }

  void _startNewAnimation({
    required _ContentSlot slot,
    required ListQueue<_ButtonElement> queue,
    Widget? child,
  }) {
    while (queue.length >= widget.maxConcurrentAnimations) {
      queue.removeFirst().dispose();
    }
    queue.forEach((element) => element.reverse());

    queue.add(
      _newElement(
        slot: _ContentSlot.leadingIcon,
        child: child,
      )..forward(),
    );
  }

  void _updatePadding() {
    if (widget.startPadding != startPadding.end) {
      if (widget.startPadding == startPadding.start) {
        startPadding.reverse();
      } else {
        final newAnimation = _newPaddingAnimation(
          begin: startPadding.value,
          end: widget.startPadding,
        );
        startPadding.dispose();
        startPadding = newAnimation..forward();
      }
    }
    final effectiveEndLeadingPadding = _endLeadingPadding;
    if (effectiveEndLeadingPadding != endLeadingPadding.end) {
      if (effectiveEndLeadingPadding == endLeadingPadding.start) {
        endLeadingPadding.reverse();
      } else {
        final newAnimation = _newPaddingAnimation(
          begin: endLeadingPadding.value,
          end: effectiveEndLeadingPadding,
        );
        endLeadingPadding.dispose();
        endLeadingPadding = newAnimation..forward();
      }
    }
    final effectiveStartTrailingPadding = _startTrailingPadding;
    if (effectiveStartTrailingPadding != startTrailingPadding.end) {
      if (effectiveStartTrailingPadding == endLeadingPadding.start) {
        endLeadingPadding.reverse();
      } else {
        final newAnimation = _newPaddingAnimation(
          begin: startTrailingPadding.value,
          end: effectiveStartTrailingPadding,
        );
        startTrailingPadding.dispose();
        startTrailingPadding = newAnimation..forward();
      }
    }
    if (widget.endPadding != endPadding.end) {
      if (widget.endPadding == endLeadingPadding.start) {
        endLeadingPadding.reverse();
      } else {
        final newAnimation = _newPaddingAnimation(
          begin: endPadding.value,
          end: widget.endPadding,
        );
        endPadding.dispose();
        endPadding = newAnimation..forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _updatePadding();
    return _ButtonContent(
      startPadding: startPadding.value,
      endLeadingPadding: endLeadingPadding.value,
      startTrailingPadding: startTrailingPadding.value,
      endPadding: endPadding.value,
      leadingIcons: leadingIcons,
      labels: labels,
      trailingIcons: trailingIcons,
      containerConstraints: widget.containerConstraints,
      animationDuration: widget.animationDuration,
      vsync: this,
    );
  }
}

@immutable
abstract class _ButtonElement {
  _ContentSlot get slot;

  Widget? get widget;

  double get opacity;

  bool get isCompleted;

  bool get isDismissed;

  void forward();

  TickerFuture reverse();

  void dispose();
}

@immutable
class _NullButtonElement implements _ButtonElement {
  const _NullButtonElement({
    required this.slot,
  });

  @override
  final _ContentSlot slot;

  @override
  Widget? get widget => null;

  @override
  double get opacity => 0.0;

  @override
  bool get isCompleted => true;

  @override
  bool get isDismissed => true;

  @override
  void forward() {}

  @override
  TickerFuture reverse() {
    return TickerFuture.complete();
  }

  @override
  void dispose() {}
}

@immutable
class _AnimatedButtonElement implements _ButtonElement {
  const _AnimatedButtonElement({
    required this.slot,
    required this.controller,
    required this.opacityAnimation,
    required this.widget,
  });

  @override
  final _ContentSlot slot;

  final AnimationController controller;
  final Animation<double> opacityAnimation;
  @override
  final Widget? widget;

  @override
  double get opacity => opacityAnimation.value;

  @override
  bool get isCompleted => controller.isCompleted;

  @override
  bool get isDismissed => controller.isDismissed;

  @override
  void forward() {
    controller.forward();
  }

  @override
  TickerFuture reverse() {
    return controller.reverse();
  }

  @override
  void dispose() {
    controller.dispose();
  }
}

abstract class _ButtonPadding {
  double get value;

  double get start;

  double get end;

  bool get isCompleted;

  void forward();

  void reverse();

  void dispose();
}

@immutable
class _FixedButtonPadding implements _ButtonPadding {
  const _FixedButtonPadding(this.value);

  @override
  final double value;

  @override
  double get start => value;

  @override
  double get end => value;

  @override
  bool get isCompleted => true;

  @override
  void dispose() {}

  @override
  void forward() {}

  @override
  void reverse() {}
}

@immutable
class _AnimatedButtonPadding implements _ButtonPadding {
  const _AnimatedButtonPadding(this.controller, this.animation, this.tween);

  final AnimationController controller;
  final Animation<double> animation;
  final Tween<double> tween;

  @override
  double get value => tween.evaluate(animation);

  @override
  double get start => tween.transform(0.0);

  @override
  double get end => tween.transform(1.0);

  @override
  bool get isCompleted => controller.isCompleted;

  @override
  void forward() {
    controller.forward();
  }

  @override
  void reverse() {
    controller.reverse();
  }

  @override
  void dispose() {
    controller.dispose();
  }
}

///
enum _ContentSlot {
  oldLeadingIcons,
  oldLabels,
  oldTrailingIcons,
  leadingIcon,
  label,
  trailingIcon,
}

///
class _ButtonContent extends RenderObjectWidget
    with SlottedMultiChildRenderObjectWidgetMixin<_ContentSlot> {
  ///
  _ButtonContent({
    required this.startPadding,
    required this.endLeadingPadding,
    required this.startTrailingPadding,
    required this.endPadding,
    required this.leadingIcons,
    required this.labels,
    required this.trailingIcons,
    required this.containerConstraints,
    required this.animationDuration,
    required this.vsync,
  });

  final double startPadding;
  final double endLeadingPadding;
  final double startTrailingPadding;
  final double endPadding;

  final ListQueue<_ButtonElement> leadingIcons;
  final ListQueue<_ButtonElement> labels;
  final ListQueue<_ButtonElement> trailingIcons;

  final BoxConstraints containerConstraints;

  final Duration animationDuration;

  final TickerProvider vsync;

  @override
  _RenderButtonContent createRenderObject(BuildContext context) {
    return _RenderButtonContent(
      startPadding: startPadding,
      endLeadingPadding: endLeadingPadding,
      startTrailingPadding: startTrailingPadding,
      endPadding: endPadding,
      textDirection: Directionality.maybeOf(context) ?? TextDirection.ltr,
      containerConstraints: containerConstraints,
      animationDuration: animationDuration,
      vsync: vsync,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderButtonContent renderObject,
  ) {
    renderObject
      ..startPadding = startPadding
      ..endLeadingPadding = endLeadingPadding
      ..startTrailingPadding = startTrailingPadding
      ..endPadding = endPadding
      ..containerConstraints = containerConstraints
      ..animationDuration = animationDuration
      ..vsync = vsync;
  }

  Widget? _withOpacity(_ButtonElement? e) {
    if (e != null && e.widget != null) {
      return Opacity(opacity: e.opacity, child: e.widget);
    }
    return null;
  }

  Widget? _currentFor(ListQueue<_ButtonElement> queue) {
    return _withOpacity(queue.lastOrNull);
  }

  Widget? _oldFor(ListQueue<_ButtonElement> queue) {
    if (queue.length <= 1) {
      return null;
    }
    final List<Widget> oldElementsWithOpacity = queue
        .take(queue.length - 1)
        .map(_withOpacity)
        .where((element) => element != null)
        .cast<Widget>()
        .toList(growable: false);
    if (oldElementsWithOpacity.isNotEmpty) {
      return Stack(
        alignment: AlignmentDirectional.centerStart,
        children: oldElementsWithOpacity,
      );
    }
    return null;
  }

  @override
  Widget? childForSlot(_ContentSlot slot) {
    switch (slot) {
      case _ContentSlot.leadingIcon:
        return _currentFor(leadingIcons);
      case _ContentSlot.oldLeadingIcons:
        return _oldFor(leadingIcons);
      case _ContentSlot.label:
        return _currentFor(labels);
      case _ContentSlot.oldLabels:
        return _oldFor(labels);
      case _ContentSlot.trailingIcon:
        return _currentFor(trailingIcons);
      case _ContentSlot.oldTrailingIcons:
        return _oldFor(trailingIcons);
    }
  }

  @override
  Iterable<_ContentSlot> get slots => _ContentSlot.values;
}

///
class _RenderButtonContent extends RenderBox
    with SlottedContainerRenderObjectMixin<_ContentSlot> {
  ///
  _RenderButtonContent({
    required double startPadding,
    required double endLeadingPadding,
    required double startTrailingPadding,
    required double endPadding,
    required TextDirection textDirection,
    required BoxConstraints containerConstraints,
    required Duration animationDuration,
    required TickerProvider vsync,
  })  : _startPadding = startPadding,
        _endLeadingPadding = endLeadingPadding,
        _startTrailingPadding = startTrailingPadding,
        _endPadding = endPadding,
        _textDirection = textDirection,
        _containerConstraints = containerConstraints,
        _animationDuration = animationDuration,
        _vsync = vsync {
    _leadingAnimationController = AnimationController(
      duration: animationDuration,
      vsync: vsync,
    )..addListener(() {
        if (_leadingAnimationController.value != _lastLeadingControlValue &&
            !_disableAnimationListeners) {
          markNeedsLayout();
        }
      });
    _leadingAnimation = CurvedAnimation(
      parent: _leadingAnimationController,
      curve: Curves.easeInOut,
    );
    _leadingSizeTween = Tween(begin: Size.zero, end: Size.zero);

    _labelAnimationController = AnimationController(
      duration: animationDuration,
      vsync: vsync,
    )..addListener(() {
        if (_labelAnimationController.value != _lastLabelControlValue &&
            !_disableAnimationListeners) {
          markNeedsLayout();
        }
      });
    _labelAnimation = CurvedAnimation(
      parent: _labelAnimationController,
      curve: Curves.easeInOut,
    );
    _labelSizeTween = Tween(begin: Size.zero, end: Size.zero);

    _trailingAnimationController = AnimationController(
      duration: animationDuration,
      vsync: vsync,
    )..addListener(() {
        if (_trailingAnimationController.value != _lastTrailingControlValue &&
            !_disableAnimationListeners) {
          markNeedsLayout();
        }
      });
    _trailingAnimation = CurvedAnimation(
      parent: _trailingAnimationController,
      curve: Curves.easeInOut,
    );
    _trailingSizeTween = Tween(begin: Size.zero, end: Size.zero);
  }

  RenderBox? get leadingIcon => childForSlot(_ContentSlot.leadingIcon);

  RenderBox? get label => childForSlot(_ContentSlot.label);

  RenderBox? get trailingIcon => childForSlot(_ContentSlot.trailingIcon);

  RenderBox? get oldLeadingIcons => childForSlot(_ContentSlot.oldLeadingIcons);

  RenderBox? get oldLabels => childForSlot(_ContentSlot.oldLabels);

  RenderBox? get oldTrailingIcons =>
      childForSlot(_ContentSlot.oldTrailingIcons);

  double get startPadding => _startPadding;
  double _startPadding;

  set startPadding(double value) {
    if (value != _startPadding) {
      _startPadding = value;
      markNeedsLayout();
    }
  }

  double get endLeadingPadding => _endLeadingPadding;
  double _endLeadingPadding;

  set endLeadingPadding(double value) {
    if (value != _endLeadingPadding) {
      _endLeadingPadding = value;
      markNeedsLayout();
    }
  }

  double get startTrailingPadding => _startTrailingPadding;
  double _startTrailingPadding;

  set startTrailingPadding(double value) {
    if (value != _startTrailingPadding) {
      _startTrailingPadding = value;
      markNeedsLayout();
    }
  }

  double get endPadding => _endPadding;
  double _endPadding;

  set endPadding(double value) {
    if (value != _endPadding) {
      _endPadding = value;
      markNeedsLayout();
    }
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;

  set textDirection(TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    markNeedsLayout();
  }

  BoxConstraints get containerConstraints => _containerConstraints;
  BoxConstraints _containerConstraints;

  set containerConstraints(BoxConstraints value) {
    if (value != _containerConstraints) {
      _containerConstraints = value;
      markNeedsLayout();
    }
  }

  Duration get animationDuration => _animationDuration;
  Duration _animationDuration;

  set animationDuration(Duration value) {
    if (value != _animationDuration) {
      _animationDuration = value;
      _leadingAnimationController.duration = _animationDuration;
    }
  }

  TickerProvider get vsync => _vsync;
  TickerProvider _vsync;

  set vsync(TickerProvider value) {
    if (value != _vsync) {
      _vsync = value;
      _leadingAnimationController.resync(_vsync);
      _labelAnimationController.resync(_vsync);
      _trailingAnimationController.resync(_vsync);
    }
  }

  bool _disableAnimationListeners = false;

  late AnimationController _leadingAnimationController;
  late AnimationController _labelAnimationController;
  late AnimationController _trailingAnimationController;

  late CurvedAnimation _leadingAnimation;
  late CurvedAnimation _labelAnimation;
  late CurvedAnimation _trailingAnimation;

  late Tween<Size> _leadingSizeTween;
  late Tween<Size> _labelSizeTween;
  late Tween<Size> _trailingSizeTween;

  Size get _leadingSize => _leadingSizeTween.evaluate(_leadingAnimation);

  Size get _labelSize => _labelSizeTween.evaluate(_labelAnimation);

  Size get _trailingSize => _trailingSizeTween.evaluate(_trailingAnimation);

  double? _lastLeadingControlValue;
  double? _lastLabelControlValue;
  double? _lastTrailingControlValue;

  static void _positionBox(RenderBox? box, Offset offset) {
    if (box != null) {
      final BoxParentData parentData = box.parentData! as BoxParentData;
      parentData.offset = offset;
    }
  }

  static Size _testLayoutBox(
    RenderBox? box,
    BoxConstraints constraints,
  ) {
    if (box == null) {
      return Size.zero;
    }
    return box.getDryLayout(constraints);
  }

  static Size _layoutBox(
    RenderBox? box,
    BoxConstraints constraints,
  ) {
    if (box == null) {
      return Size.zero;
    }

    box.layout(constraints, parentUsesSize: true);
    return box.size;
  }

  void _initAnimation(Tween<Size> tween, Size value) {
    tween.begin = value;
    tween.end = value;
  }

  void _updateAnimation(
    AnimationController controller,
    Animation<double> animation,
    Tween<Size> tween,
    Size value,
  ) {
    if (value != tween.end) {
      if (value == tween.begin) {
        controller.reverse();
      }
      final currentSize = tween.evaluate(animation);
      if (currentSize.height == 0.0) {
        tween.begin = Size(currentSize.width, value.height);
      } else {
        tween.begin = currentSize;
      }
      if (value.height == 0.0) {
        tween.end = Size(value.width, currentSize.height);
      } else {
        tween.end = value;
      }
      controller
        ..reset()
        ..forward();
    }
  }

  void _updateAnimations({
    required bool firstLayout,
    required Size leadingSize,
    required Size labelSize,
    required Size trailingSize,
  }) {
    _disableAnimationListeners = true;
    if (firstLayout) {
      // no animations
      _initAnimation(_leadingSizeTween, leadingSize);
      _initAnimation(_labelSizeTween, labelSize);
      _initAnimation(_trailingSizeTween, trailingSize);
    } else {
      _updateAnimation(
        _leadingAnimationController,
        _leadingAnimation,
        _leadingSizeTween,
        leadingSize,
      );
      _updateAnimation(
        _labelAnimationController,
        _labelAnimation,
        _labelSizeTween,
        labelSize,
      );
      _updateAnimation(
        _trailingAnimationController,
        _trailingAnimation,
        _trailingSizeTween,
        trailingSize,
      );
    }
    _disableAnimationListeners = false;
  }

  @override
  void performLayout() {
    final bool firstLayout = _lastLeadingControlValue == null;

    _lastLeadingControlValue = _leadingAnimationController.value;
    _lastLabelControlValue = _labelAnimationController.value;
    _lastTrailingControlValue = _trailingAnimationController.value;

    final BoxConstraints constraints = this.constraints;

    final currentLeadingIcon = leadingIcon;
    final currentLabel = label;
    final currentTrailingIcon = trailingIcon;

    final currentOldLeadingIcons = oldLeadingIcons;
    final currentOldLabels = oldLabels;
    final currentOldTrailingIcons = oldTrailingIcons;

    // Get end animation widths
    final Size leadingDrySize = _testLayoutBox(currentLeadingIcon, constraints);
    final Size trailingDrySize =
        _testLayoutBox(currentTrailingIcon, constraints);

    final double maxDryLabelWidth = math.max(
      0.0,
      constraints.maxWidth -
          startPadding -
          leadingDrySize.width -
          endLeadingPadding -
          startTrailingPadding -
          trailingDrySize.width -
          endPadding,
    );
    final Size labelDrySize = _testLayoutBox(
      currentLabel,
      constraints.copyWith(maxWidth: maxDryLabelWidth),
    );

    _updateAnimations(
      firstLayout: firstLayout,
      leadingSize: leadingDrySize,
      labelSize: labelDrySize,
      trailingSize: trailingDrySize,
    );

    final leadingSize = _leadingSize;
    final labelSize = _labelSize;
    final trailingSize = _trailingSize;

    // layout leading and trailing icons
    final leadingConstraints = BoxConstraints(
      maxWidth: leadingSize.width,
      maxHeight: leadingSize.height,
    );
    final layoutLeadingSize =
        _layoutBox(currentLeadingIcon, leadingConstraints);
    final oldLeadingSize =
        _layoutBox(currentOldLeadingIcons, leadingConstraints);
    print(layoutLeadingSize);
    print(oldLeadingSize);
    final BoxConstraints labelConstraints = BoxConstraints(
      maxWidth: labelSize.width,
      maxHeight: labelSize.height,
    );
    final layoutLabelSize = _layoutBox(currentLabel, labelConstraints);
    final oldLabelSize = _layoutBox(currentOldLabels, labelConstraints);

    final trailingConstraints = BoxConstraints(
      maxWidth: trailingSize.width,
      maxHeight: trailingSize.height,
    );
    final layoutTrailingSize =
        _layoutBox(currentTrailingIcon, trailingConstraints);
    final oldTrailingSize =
        _layoutBox(currentOldTrailingIcons, trailingConstraints);

    // Set total container size
    size = Size(
      _widthFrom(leadingSize.width, labelSize.width, trailingSize.width),
      math.max(
        leadingSize.height,
        math.max(
          labelSize.height,
          trailingSize.height,
        ),
      ),
    );
    // get offsets
    final double startLeading = startPadding;
    final double endLeading = startLeading + leadingSize.width;
    final double startLabel = endLeading + endLeadingPadding;
    final double endLabel = startLabel + labelSize.width;
    final double startTrailing = endLabel + startTrailingPadding;
    final double endTrailing = startTrailing + trailingSize.width;

    double topFor(Size s) {
      return (size.height - s.height) / 2.0;
    }

    switch (textDirection) {
      case TextDirection.ltr:
        _positionBox(
          currentLeadingIcon,
          Offset(startLeading, topFor(layoutLeadingSize)),
        );
        _positionBox(
          currentOldLeadingIcons,
          Offset(startLeading, topFor(oldLeadingSize)),
        );

        _positionBox(
          currentLabel,
          Offset(startLabel, topFor(layoutLabelSize)),
        );
        _positionBox(
          currentOldLabels,
          Offset(startLabel, topFor(oldLabelSize)),
        );

        _positionBox(
          currentTrailingIcon,
          Offset(startTrailing, topFor(layoutTrailingSize)),
        );
        _positionBox(
          currentOldTrailingIcons,
          Offset(startTrailing, topFor(oldTrailingSize)),
        );
      case TextDirection.rtl:
        _positionBox(
          currentLeadingIcon,
          Offset(size.width - endLeading, topFor(layoutLeadingSize)),
        );
        _positionBox(
          currentOldLeadingIcons,
          Offset(size.width - endLeading, topFor(oldLeadingSize)),
        );

        _positionBox(
          currentLabel,
          Offset(size.width - endLabel, topFor(layoutLabelSize)),
        );
        _positionBox(
          currentOldLabels,
          Offset(size.width - endLabel, topFor(oldLabelSize)),
        );

        _positionBox(
          currentTrailingIcon,
          Offset(size.width - endTrailing, topFor(layoutTrailingSize)),
        );
        _positionBox(
          currentOldTrailingIcons,
          Offset(size.width - endTrailing, topFor(oldTrailingSize)),
        );
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    void doPaint(RenderBox? child) {
      if (child != null) {
        final BoxParentData parentData = child.parentData! as BoxParentData;
        context.paintChild(
          child,
          parentData.offset + offset,
        );
      }
    }

    doPaint(oldLeadingIcons);
    doPaint(oldLabels);
    doPaint(oldTrailingIcons);
    doPaint(leadingIcon);
    doPaint(label);
    doPaint(trailingIcon);
  }

  double _widthFrom(
    double leadingWidth,
    double labelWidth,
    double trailingWidth,
  ) {
    return startPadding +
        leadingWidth +
        endLeadingPadding +
        labelWidth +
        startTrailingPadding +
        trailingWidth +
        endPadding;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    if (constraints.isTight) {
      return constraints.smallest;
    }

    final Size leadingSize = _leadingSize;
    final Size labelSize = _labelSize;
    final Size trailingSize = _trailingSize;

    final totalSize = Size(
      _widthFrom(leadingSize.width, labelSize.width, trailingSize.width),
      math.max(
        leadingSize.height,
        math.max(
          labelSize.height,
          trailingSize.height,
        ),
      ),
    );

    return constraints.constrain(totalSize);
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return _widthFrom(
      _leadingSize.width,
      _labelSize.width,
      _trailingSize.width,
    );
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _widthFrom(
      _leadingSize.width,
      _labelSize.width,
      _trailingSize.width,
    );
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return math.max(
      _leadingSize.height,
      math.max(
        _labelSize.height,
        _trailingSize.height,
      ),
    );
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return math.max(
      _leadingSize.height,
      math.max(
        _labelSize.height,
        _trailingSize.height,
      ),
    );
  }

  @override
  void dispose() {
    _leadingAnimationController.dispose();
    _labelAnimationController.dispose();
    _trailingAnimationController.dispose();
    super.dispose();
  }
}

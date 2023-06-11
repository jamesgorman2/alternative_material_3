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
          child: widget.leadingIcon,
          value: 1.0,
        ),
      );
    }
    if (widget.label != null) {
      labels.add(
        _newElement(
          child: widget.label,
          value: 1.0,
        ),
      );
    }
    if (widget.trailingIcon != null) {
      trailingIcons.add(
        _newElement(
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
        queue: leadingIcons,
        child: widget.leadingIcon,
      );
    }
    if (oldWidget.label != widget.label) {
      _startNewAnimation(
        queue: labels,
        child: widget.label,
      );
    }
    if (oldWidget.trailingIcon != widget.trailingIcon) {
      _startNewAnimation(
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
    Widget? child,
    double value = 0.0,
  }) {
    if (child == null) {
      return _NullButtonElement();
    }
    final controller = AnimationController(
      value: value,
      duration: widget.animationDuration,
      vsync: this,
    )..addListener(() => setState(() {}));
    return _AnimatedButtonElement(
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
    required ListQueue<_ButtonElement> queue,
    Widget? child,
  }) {
    while (queue.length >= widget.maxConcurrentAnimations) {
      queue.removeFirst().dispose();
    }
    queue.forEach((element) => element.reverse());

    queue.add(
      _newElement(
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
      if (effectiveStartTrailingPadding == startTrailingPadding.start) {
        startTrailingPadding.reverse();
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
      if (widget.endPadding == endPadding.start) {
        endPadding.reverse();
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: startPadding.value),
        Stack(
          alignment: AlignmentDirectional.centerStart,
          children: leadingIcons
              .map((e) => e.widget != null ? Opacity(opacity: e.opacity, child: e.widget) : null)
              .where((e) => e != null)
              .cast<Widget>()
              .toList(),
        ),
        SizedBox(width: endLeadingPadding.value),
        Flexible(
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            children: labels
                .map((e) => e.widget != null ? Opacity(opacity: e.opacity, child: e.widget) : null)
                .where((e) => e != null)
                .cast<Widget>()
                .toList(),
          ),
        ),
        SizedBox(width: startTrailingPadding.value),
        Stack(
          alignment: AlignmentDirectional.centerStart,
          children: trailingIcons
              .map((e) => e.widget != null ? Opacity(opacity: e.opacity, child: e.widget) : null)
              .where((e) => e != null)
              .cast<Widget>()
              .toList(),
        ),
        SizedBox(width: endPadding.value),
      ],
    );
  }
}

@immutable
abstract class _ButtonElement {
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
    required this.controller,
    required this.opacityAnimation,
    required this.widget,
  });

  @override
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

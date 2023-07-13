import 'package:flutter/animation.dart';

final AnimationController kAlwaysCompleteAnimationController =
    _AlwaysCompleteAnimationController();
final AnimationController kAlwaysDismissedAnimationController =
    _AlwaysDismissedAnimationController();

class _AlwaysCompleteAnimationController implements AnimationController {
  // const _AlwaysCompleteAnimationController();

  @override
  Duration? duration;

  @override
  Duration? reverseDuration;

  @override
  double get value => 1.0;

  @override
  set value(double value) {}

  @override
  void addListener(VoidCallback listener) {}

  @override
  void addStatusListener(AnimationStatusListener listener) {}

  @override
  TickerFuture animateBack(double target,
      {Duration? duration, Curve curve = Curves.linear}) {
    return TickerFuture.complete();
  }

  @override
  TickerFuture animateTo(double target,
      {Duration? duration, Curve curve = Curves.linear}) {
    return TickerFuture.complete();
  }

  @override
  TickerFuture animateWith(Simulation simulation) {
    return TickerFuture.complete();
  }

  @override
  AnimationBehavior get animationBehavior => AnimationBehavior.normal;

  @override
  void clearListeners() {}

  @override
  void clearStatusListeners() {}

  @override
  String? get debugLabel => 'AlwaysCompleteAnimationController';

  @override
  void didRegisterListener() {}

  @override
  void didUnregisterListener() {}

  @override
  void dispose() {}

  @override
  Animation<U> drive<U>(Animatable<U> child) {
    return child.animate(this);
  }

  @override
  TickerFuture fling(
      {double velocity = 1.0,
      SpringDescription? springDescription,
      AnimationBehavior? animationBehavior}) {
    return TickerFuture.complete();
  }

  @override
  TickerFuture forward({double? from}) {
    return TickerFuture.complete();
  }

  @override
  bool get isAnimating => false;

  @override
  bool get isCompleted => true;

  @override
  bool get isDismissed => false;

  @override
  Duration? get lastElapsedDuration => null;

  @override
  double get lowerBound => 0.0;

  @override
  void notifyListeners() {}

  @override
  void notifyStatusListeners(AnimationStatus status) {}

  @override
  void removeListener(VoidCallback listener) {}

  @override
  void removeStatusListener(AnimationStatusListener listener) {}

  @override
  TickerFuture repeat(
      {double? min, double? max, bool reverse = false, Duration? period}) {
    return TickerFuture.complete();
  }

  @override
  void reset() {}

  @override
  void resync(TickerProvider vsync) {}

  @override
  TickerFuture reverse({double? from}) {
    return TickerFuture.complete();
  }

  @override
  AnimationStatus get status => AnimationStatus.completed;

  @override
  void stop({bool canceled = true}) {}

  @override
  String toStringDetails() {
    return debugLabel!;
  }

  @override
  double get upperBound => 1.0;

  @override
  double get velocity => 0.0;

  @override
  Animation<double> get view => this;
}

class _AlwaysDismissedAnimationController implements AnimationController {
  // const _AlwaysCompleteAnimationController();

  @override
  Duration? duration;

  @override
  Duration? reverseDuration;

  @override
  double get value => 0.0;

  @override
  set value(double value) {}

  @override
  void addListener(VoidCallback listener) {}

  @override
  void addStatusListener(AnimationStatusListener listener) {}

  @override
  TickerFuture animateBack(double target,
      {Duration? duration, Curve curve = Curves.linear}) {
    return TickerFuture.complete();
  }

  @override
  TickerFuture animateTo(double target,
      {Duration? duration, Curve curve = Curves.linear}) {
    return TickerFuture.complete();
  }

  @override
  TickerFuture animateWith(Simulation simulation) {
    return TickerFuture.complete();
  }

  @override
  AnimationBehavior get animationBehavior => AnimationBehavior.normal;

  @override
  void clearListeners() {}

  @override
  void clearStatusListeners() {}

  @override
  String? get debugLabel => 'AlwaysDismissedAnimationController';

  @override
  void didRegisterListener() {}

  @override
  void didUnregisterListener() {}

  @override
  void dispose() {}

  @override
  Animation<U> drive<U>(Animatable<U> child) {
    return child.animate(this);
  }

  @override
  TickerFuture fling(
      {double velocity = 1.0,
      SpringDescription? springDescription,
      AnimationBehavior? animationBehavior}) {
    return TickerFuture.complete();
  }

  @override
  TickerFuture forward({double? from}) {
    return TickerFuture.complete();
  }

  @override
  bool get isAnimating => false;

  @override
  bool get isCompleted => false;

  @override
  bool get isDismissed => true;

  @override
  Duration? get lastElapsedDuration => null;

  @override
  double get lowerBound => 0.0;

  @override
  void notifyListeners() {}

  @override
  void notifyStatusListeners(AnimationStatus status) {}

  @override
  void removeListener(VoidCallback listener) {}

  @override
  void removeStatusListener(AnimationStatusListener listener) {}

  @override
  TickerFuture repeat(
      {double? min, double? max, bool reverse = false, Duration? period}) {
    return TickerFuture.complete();
  }

  @override
  void reset() {}

  @override
  void resync(TickerProvider vsync) {}

  @override
  TickerFuture reverse({double? from}) {
    return TickerFuture.complete();
  }

  @override
  AnimationStatus get status => AnimationStatus.dismissed;

  @override
  void stop({bool canceled = true}) {}

  @override
  String toStringDetails() {
    return debugLabel!;
  }

  @override
  double get upperBound => 1.0;

  @override
  double get velocity => 0.0;

  @override
  Animation<double> get view => this;
}


import 'dart:ui';

class DurationExtensions {

  static Duration? lerp(Duration? a, Duration? b, double t) {
    if (a == b) {
      return a;
    } else if (a == null || b == null) {
      return t < 0.5 ? a : b;
    }

    return Duration(
      microseconds:
      lerpDouble(a.inMicroseconds, b.inMicroseconds, t)?.round() ?? 0,
    );
  }

}

import 'package:flutter/painting.dart';

import '../material_state.dart';

class BorderSideExtensions {
  /// Special case because BorderSide.lerp() doesn't support null arguments
  static MaterialStateProperty<BorderSide?>? lerpNull(
      MaterialStateProperty<BorderSide?>? a,
      MaterialStateProperty<BorderSide?>? b,
      double t) {
    if (a == null && b == null) {
      return null;
    }
    return _LerpSides(a, b, t);
  }

}

class _LerpSides implements MaterialStateProperty<BorderSide?> {
  const _LerpSides(this.a, this.b, this.t);

  final MaterialStateProperty<BorderSide?>? a;
  final MaterialStateProperty<BorderSide?>? b;
  final double t;

  @override
  BorderSide? resolve(Set<MaterialState> states) {
    final BorderSide? resolvedA = a?.resolve(states);
    final BorderSide? resolvedB = b?.resolve(states);
    if (resolvedA == null && resolvedB == null) {
      return null;
    }
    if (resolvedA == null) {
      return BorderSide.lerp(
          BorderSide(width: 0, color: resolvedB!.color.withAlpha(0)),
          resolvedB,
          t);
    }
    if (resolvedB == null) {
      return BorderSide.lerp(resolvedA,
          BorderSide(width: 0, color: resolvedA.color.withAlpha(0)), t);
    }
    return BorderSide.lerp(resolvedA, resolvedB, t);
  }
}

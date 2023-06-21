
import 'package:either_dart/either.dart';

/// Adds extension methods to [Either].
extension EitherExtensions<L, R> on Either<L, R> {
  /// If this is [Right], perform [fnR] over [Either.right], otherwise
  /// perform [fnL] over [Either.left].
  void forEach({Function(L l)? fnL, Function(R r)? fnR, }) {
    if (isLeft && fnL != null) {
      fnL(left);
    } else if (isRight && fnR != null) {
      fnR(right);
    }
  }

  /// Return the left value if it exists, otherwise return null.
  L? get leftOrNull {
    if (isLeft) {
      return left!;
    }
    return null;
  }

  /// Return the left value if it exists, otherwise return null.
  R? get rightOrNull {
    if (isRight) {
      return right!;
    }
    return null;
  }
}

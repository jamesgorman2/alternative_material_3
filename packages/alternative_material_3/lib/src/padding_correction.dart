
import 'package:flutter/material.dart';

/// A class to allow the padding around a widget to be treated as part
/// of the padding provided by the widget itself.
///
/// An example is the [IconButton]. For accessibility, this provides a padding
/// of 8 on each side to make a larger tap target. In the Material 2 & 3 List
/// specification this padding is part of the List.
/// [ListTileM3Constraint.icon24] can be used
/// to align the [Icon] part of the button correctly.
///
/// See also:
///
/// * [ListTileM3Constraint] this uses ListTileM3PaddingCorrection and can be
///   applied to a [ListTileM3].
@immutable
class PaddingCorrection extends EdgeInsetsDirectional {
  const PaddingCorrection._({
    double start = 0.0,
    double top = 0.0,
    double end = 0.0,
    double bottom = 0.0,
    this.offsetX = 0.0,
    this.offsetY = 0.0,
  }) : super.fromSTEB(start, top, end, bottom);

  /// The distance from the true center of the widget to the
  /// corrected center in the X axis.
  final double offsetX;

  /// The distance from the true center of the widget to the
  /// corrected center in the Y axis.
  final double offsetY;

  /// Do not correct the widget.
  static const PaddingCorrection noCorrection =
  PaddingCorrection._();

  /// Apply a specific correction..
  ///
  /// The this will not allow the correction to move the element off the
  /// [ListTileM3] or cause it to overlap with the [ListTileM3.headline],
  /// [ListTileM3.overline] or [ListTileM3.supportingText].
  static PaddingCorrection of(EdgeInsetsDirectional targetCorrection) {
    return PaddingCorrection._(
      start: targetCorrection.start,
      top: targetCorrection.top,
      end: targetCorrection.end,
      bottom: targetCorrection.bottom,
      offsetX: targetCorrection.end - targetCorrection.start,
      offsetY: targetCorrection.bottom - targetCorrection.top,
    );
  }

  @override
  String toString() {
    return 'PaddingCorrection('
        'start: ${start.toStringAsFixed(1)}, '
        'top: ${top.toStringAsFixed(1)}, '
        'end: ${end.toStringAsFixed(1)}, '
        'bottom: ${bottom.toStringAsFixed(1)}, '
        'offsetX: ${offsetX.toStringAsFixed(1)}, '
        'offsetY: ${offsetY.toStringAsFixed(1)}'
        ')';
  }

  @override
  bool operator ==(Object other) {
    return other is PaddingCorrection &&
        start == other.start &&
        top == other.top &&
        end == other.end &&
        bottom == other.bottom &&
        offsetX == other.offsetX &&
        offsetY == other.offsetY;
  }

  @override
  int get hashCode => Object.hash(start, top, end, bottom, offsetX, offsetY);
}

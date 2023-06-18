import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../theme.dart';
import '../theme_data.dart';

/// Redirects the [BoxHitTestResult.dy] passed to [RenderBox.hitTest] to
/// the nearest edge of the [child].
///
/// The primary purpose of this widget is to allow padding around  widgets
/// like [Button] and [Chip]
/// to trigger the child ink feature without increasing the
/// size of the material.
class RedirectingHitDetectionWidget extends StatelessWidget {
  /// Create the hit detection widget.
  const RedirectingHitDetectionWidget({
    super.key,
    required this.widgetBox,
    this.materialTapTargetSize,
    this.visualDensity,
    required this.child,
  });

  // hit box size
  final Size widgetBox;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final tapTargetSize = materialTapTargetSize ?? theme.materialTapTargetSize;
    if (tapTargetSize == MaterialTapTargetSize.shrinkWrap &&
        !theme.alwaysPadTapTarget) {
      return child;
    }
    final Offset densityAdjustment =
        (visualDensity ?? theme.visualDensity).baseSizeAdjustment;
    return _RedirectingHitDetectionWidget(
      widgetBox: widgetBox,
      minHitBox: BoxConstraints(
        minWidth: math.max(theme.minInteractiveDimension + densityAdjustment.dx, 0.0),
        minHeight: math.max(theme.minInteractiveDimension + densityAdjustment.dy, 0.0),
      ),
      materialTapTargetSize: tapTargetSize,
      child: Center(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: child,
      ),
    );
  }
}

class _RedirectingHitDetectionWidget extends SingleChildRenderObjectWidget {
  /// Create the hit detection widget.
  const _RedirectingHitDetectionWidget({
    super.key,
    this.materialTapTargetSize,
    required this.minHitBox,
    required this.widgetBox,
    required super.child,
  });

  final MaterialTapTargetSize? materialTapTargetSize;

  final BoxConstraints minHitBox;
  final Size widgetBox;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderRedirectingHitDetection(
      additionalConstraints: minHitBox,
      widgetBox: widgetBox,
      materialTapTargetSize:
          materialTapTargetSize ?? Theme.of(context).materialTapTargetSize,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderRedirectingHitDetection renderObject,
  ) {
    renderObject
      ..widgetBox = widgetBox
      ..materialTapTargetSize =
          materialTapTargetSize ?? Theme.of(context).materialTapTargetSize;
  }
}

///
class RenderRedirectingHitDetection extends RenderConstrainedBox {
  ///
    RenderRedirectingHitDetection({
    required super.additionalConstraints,
    required Size widgetBox,
    required MaterialTapTargetSize materialTapTargetSize,
  })  : _widgetBox = widgetBox,
        _materialTapTargetSize = materialTapTargetSize;

  Size get widgetBox => _widgetBox;
  Size _widgetBox;

  set widgetBox(Size value) {
    if (value != _widgetBox) {
      _widgetBox = value;
      markNeedsLayout();
    }
  }

  MaterialTapTargetSize get materialTapTargetSize => _materialTapTargetSize;
  MaterialTapTargetSize _materialTapTargetSize;

  set materialTapTargetSize(MaterialTapTargetSize value) {
    if (value != _materialTapTargetSize) {
      _materialTapTargetSize = value;
      markNeedsLayout();
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (!size.contains(position)) {
      return false;
    }

    // Redirect hit detection which occurs above and below the
    // render object to the nearest edge if not shrink wrapped.
    Offset nearestEdge() {
      if (materialTapTargetSize == MaterialTapTargetSize.shrinkWrap) {
        return position;
      }

      final double deltaX = math.max(size.width - widgetBox.width, 0.0) / 2.0;
      final double deltaY = math.max(size.height - widgetBox.height, 0.0) / 2.0;
      final childRect = Rect.fromLTRB(
        deltaX,
        deltaY,
        size.width - deltaX,
        size.height - deltaY,
      );

      final double dx;
      if (childRect.left > position.dx) {
        dx = childRect.left;
      } else if (childRect.right <= position.dx) {
        // bottom hit target is exclusively matched so we need
        // a small adjustment
        dx = childRect.right - 0.01;
      } else {
        dx = position.dx;
      }

      final double dy;
      if (childRect.top > position.dy) {
        dy = childRect.top;
      } else if (childRect.bottom <= position.dy) {
        // bottom hit target is exclusively matched so we need
        // a small adjustment
        dy = childRect.bottom - 0.01;
      } else {
        dy = position.dy;
      }

      return Offset(dx, dy);
    }

    final Offset updatedPosition = nearestEdge();
    return result.addWithRawTransform(
      transform: MatrixUtils.forceToPoint(updatedPosition),
      position: position,
      hitTest: (BoxHitTestResult result, Offset position) {
        assert(position == updatedPosition);
        return child!.hitTest(result, position: updatedPosition);
      },
    );
  }
}

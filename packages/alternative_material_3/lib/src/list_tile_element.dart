import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'padding_correction.dart';

class PaddingCorrectionGenerators {
  static PaddingCorrection noCorrection(Size widgetSize) {
    return PaddingCorrection.noCorrection;
  }

  static PaddingCorrection center24(Size widgetSize) {
    return PaddingCorrection.of(EdgeInsetsDirectional.symmetric(
      horizontal: math.max(widgetSize.width - 24.0, 0.0) / 2.0,
      vertical: math.max(widgetSize.height - 24.0, 0.0) / 2.0,
    ));
  }

  static PaddingCorrection switch_(Size widgetSize) {
    return PaddingCorrection.of(const EdgeInsetsDirectional.all(4.0));
  }
}
typedef PaddingCorrectionGenerator = PaddingCorrection Function(Size actualWidgetSize);

@immutable
class ListTileElement extends StatelessWidget {
  const ListTileElement({
    super.key,
    this.targetSize,
    required this.paddingCorrection,
    required this.child,
  });

  const ListTileElement.icon24({super.key, required this.child})
      : targetSize = null,
        paddingCorrection = PaddingCorrectionGenerators.center24;

  const ListTileElement.switch_({super.key, required this.child})
      : targetSize = null,
        paddingCorrection = PaddingCorrectionGenerators.switch_;

  const ListTileElement.avatar({super.key, required this.child})
      : targetSize = const Size.square(40.0),
        paddingCorrection = PaddingCorrectionGenerators.noCorrection;

  const ListTileElement.image({super.key, required this.child})
      : targetSize = const Size.square(56.0),
        paddingCorrection = PaddingCorrectionGenerators.noCorrection;

  const ListTileElement.video({super.key, required this.child})
      : targetSize = const Size(114.0, 64.0),
        paddingCorrection = PaddingCorrectionGenerators.noCorrection;

  const ListTileElement.supportingText({super.key, required this.child})
      : targetSize = null,
        paddingCorrection = PaddingCorrectionGenerators.noCorrection;

  const ListTileElement.unconstrained({super.key, required this.child})
      : targetSize = null,
        paddingCorrection = PaddingCorrectionGenerators.noCorrection;

  static ListTileElement? wrap(Widget? w) {
    if (w is ListTileElement) {
      return w;
    } else if (w != null) {
      return ListTileElement.unconstrained(child: w);
    }
    return null;
  }

  final Size? targetSize;

  final PaddingCorrectionGenerator paddingCorrection;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // if (targetSize != null) {
    //   return SizedBox(
    //     width: targetSize!.width,
    //     height: targetSize!.height,
    //     child: child,
    //   );
    // }
    return child;
  }
}

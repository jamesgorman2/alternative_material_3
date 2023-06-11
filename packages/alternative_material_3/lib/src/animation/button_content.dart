import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ButtonContent extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: startPadding),
        if(leadingIcon != null)
            label != null
                ? Padding(
                    padding:
                        EdgeInsetsDirectional.only(end: endLeadingPadding),
                    child: leadingIcon,
                  )
                : leadingIcon!,
        if (label != null) label!,
        if (trailingIcon != null)
            label != null || leadingIcon != null
                ? Padding(
                    padding: EdgeInsetsDirectional.only(
                        start: startTrailingPadding),
                    child: trailingIcon,
                  )
                : trailingIcon!,
        SizedBox(width: endPadding),
      ],
    );
  }
}

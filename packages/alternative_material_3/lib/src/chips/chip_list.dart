// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../theme.dart';
import '../theme_data.dart';
import 'chip.dart';
import 'widgets/wrap.dart';

/// A padded list of chips that will overflow
class ChipList extends StatelessWidget {
  /// Create the list of chips
  const ChipList({
    super.key,
    this.theme,
    this.singleLine = false,
    this.maxChipWidth = double.infinity,
    required this.children,
  });

  /// {@template alternative_material_3.chipList.theme}
  /// Chip list overrides that only apply to this list.
  /// {@endtemplate}
  final ChipListThemeData? theme;

  /// {@template alternative_material_3.chipList.singleLine}
  /// If true, this will be rendered as a single, scrollable row.
  /// If false, this will overflow once the available width is filled.
  ///
  /// The default value is false.
  /// {@endtemplate}
  final bool singleLine;

  /// {@template alternative_material_3.chipList.maxChipWidth}
  /// Set the maximum width of any single chip.
  ///
  /// If [singleLine] is false, the effective value will be the
  /// minimum of the parent constraint and [maxChipWidth].
  ///
  /// The default value is [double.infinity];
  /// {@endtemplate}
  final double maxChipWidth;

  /// The chips to render as a list.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final chipListTheme = ChipListTheme.resolve(context, this.theme);

    Widget widthConstraint({required Widget child}) {
      if (maxChipWidth.isInfinite) {
        return child;
      }
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxChipWidth),
        child: child,
      );
    }

    if (singleLine) {
      final List<Widget> paddedChildren = children.isEmpty
          ? children
          : [
              ...children.take(children.length - 1).expand(
                    (child) => [
                      widthConstraint(child: child),
                      SizedBox(width: chipListTheme.horizontalMargin),
                    ],
                  ),
              widthConstraint(child: children.last),
            ];
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: paddedChildren,
        ),
      );
    }

    final theme = Theme.of(context);
    final chipTheme = ChipTheme.resolve(context);

    final baseSizeAdjustment = chipListTheme.visualDensity.baseSizeAdjustment;

    final verticalPaddingAdjustment =
        chipTheme.containerHeight < theme.minInteractiveDimension &&
                theme.materialTapTargetSize == MaterialTapTargetSize.padded
            ? (theme.minInteractiveDimension - chipTheme.containerHeight) / 2.0
            : 0.0;
    final verticalMargin = math.max(
      chipListTheme.verticalMargin -
          verticalPaddingAdjustment +
          baseSizeAdjustment.dy,
      0.0,
    );

    final double minHeight;
    if (chipListTheme.minLines != null) {
      minHeight = (chipTheme.containerHeight * chipListTheme.minLines!) +
          (chipListTheme.verticalMargin * (chipListTheme.minLines! - 1)) +
          verticalPaddingAdjustment +
          baseSizeAdjustment.dy;
    } else {
      minHeight = 0.0;
    }
    final double maxHeight;
    final double overflowHeight = chipListTheme.overflowLineHeight > 0.0
        ? (chipTheme.containerHeight * chipListTheme.overflowLineHeight) +
            ((chipListTheme.verticalMargin + verticalPaddingAdjustment) / 2.0) +
            baseSizeAdjustment.dy
        : 0.0;
    if (chipListTheme.maxLines != null) {
      maxHeight = (chipTheme.containerHeight * chipListTheme.maxLines!) +
          (chipListTheme.verticalMargin * (chipListTheme.maxLines! - 1)) +
          verticalPaddingAdjustment +
          overflowHeight;
    } else {
      maxHeight = double.infinity;
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: minHeight,
        maxHeight: maxHeight,
      ),
      child: SingleChildScrollView(
        child: WrapWithTrailing(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: chipListTheme.horizontalMargin,
          runSpacing: verticalMargin,
          children: children.map((child) => widthConstraint(child: child)).toList(),
        ),
      ),
    );
  }
}

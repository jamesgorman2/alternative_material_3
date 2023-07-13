// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import '../theme.dart';
import 'card.dart';
import 'card_theme.dart';

class OutlinedCard extends Card {
  ///
  const OutlinedCard({
    super.key,
    super.theme,
    super.enabled = true,
    super.borderOnForeground = true,
    super.semanticContainer = true,
    super.focusNode,
    super.autofocus = false,
    super.statesController,
    super.child,
  }): super(interactive: false);

  const OutlinedCard.interactive({
    super.key,
    super.theme,
    super.enabled = true,
    super.borderOnForeground = true,
    super.semanticContainer = true,
    super.focusNode,
    super.autofocus = false,
    super.statesController,
    super.onPressed,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.child,
  }): super(interactive: true);

  @override
  CardThemeData resolveTheme(BuildContext context, CardThemeData? theme) {
    return OutlinedCardTheme.resolve(context, theme);
  }
}

/// Applies a card theme to descendant [OutlinedCard]s.
@immutable
class OutlinedCardTheme extends InheritedWidget {
  /// Applies the given theme [data] to [child].
  const OutlinedCardTheme(
      {super.key, required this.data, required super.child});

  /// Specifies the color, shape, and elevation style values for descendant
  /// card widgets.
  final CardThemeData data;

  /// The [ThemeData.cardTheme] property of the ambient [Theme].
  static CardThemeData of(BuildContext context) {
    return Theme.of(context).outlinedCardTheme;
  }

  /// Return a [TextFieldThemeData] that merges the nearest ancestor [TextFieldTheme]
  /// and the [TextFieldThemeData] provided by the nearest [Theme].
  ///
  /// A current context theme can also be provided, used when the
  /// StateThemeData is passed as a parameter to a widget other than
  /// StateTheme.
  ///
  /// See also:
  ///
  /// * [BuildContext.dependOnInheritedWidgetOfExactType]
  static CardThemeData resolve(
    BuildContext context, [
    CardThemeData? currentContextTheme,
  ]) {
    final ancestorTheme =
        context.dependOnInheritedWidgetOfExactType<OutlinedCardTheme>()?.data;
    final List<CardThemeData> ancestorThemes = [
      Theme.of(context).outlinedCardTheme,
      if (ancestorTheme != null) ancestorTheme,
      if (currentContextTheme != null) currentContextTheme,
    ];
    if (ancestorThemes.length > 1) {
      return OutlinedCardThemeData(
        ancestorThemes.reduce((acc, e) => acc.mergeWith(e)),
        context,
      );
    }
    return OutlinedCardThemeData(ancestorThemes.first, context);
  }

  @override
  bool updateShouldNotify(OutlinedCardTheme oldWidget) {
    return oldWidget.data != data;
  }
}

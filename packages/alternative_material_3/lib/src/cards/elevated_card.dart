// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import '../theme.dart';
import 'card.dart';
import 'card_theme.dart';

class ElevatedCard extends Card {
  ///
  const ElevatedCard({
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

  const ElevatedCard.interactive({
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
    return ElevatedCardTheme.resolve(context, theme);
  }
}

/// Applies a card theme to descendant [ElevatedCard]s.
@immutable
class ElevatedCardTheme extends InheritedWidget {
  /// Applies the given theme [data] to [child].
  const ElevatedCardTheme(
      {super.key, required this.data, required super.child});

  /// Specifies the color, shape, and elevation style values for descendant
  /// card widgets.
  final CardThemeData data;

  /// Returns the data from the closest [ElevatedCardTheme] instance that encloses
  /// the given context, otherwise
  /// the [ThemeData.elevatedCardTheme] property of the ambient [Theme].
  static CardThemeData of(BuildContext context) {
    final ElevatedCardTheme? inheritedTheme =
      context.dependOnInheritedWidgetOfExactType<ElevatedCardTheme>();
    return inheritedTheme?.data ?? Theme.of(context).elevatedCardTheme;
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
        context.dependOnInheritedWidgetOfExactType<ElevatedCardTheme>()?.data;
    final List<CardThemeData> ancestorThemes = [
      Theme.of(context).elevatedCardTheme,
      if (ancestorTheme != null) ancestorTheme,
      if (currentContextTheme != null) currentContextTheme,
    ];
    if (ancestorThemes.length > 1) {
      return ElevatedCardThemeData(
        ancestorThemes.reduce((acc, e) => acc.mergeWith(e)),
        context,
      );
    }
    return ElevatedCardThemeData(ancestorThemes.first, context);
  }

  @override
  bool updateShouldNotify(ElevatedCardTheme oldWidget) {
    return oldWidget.data != data;
  }
}

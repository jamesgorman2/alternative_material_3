// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import '../material_state.dart';
import '../theme.dart';
import 'button.dart';
import 'button_style.dart';

/// A Material Design "Outlined Button"; essentially a [TextButton]
/// with an outlined border.
///
/// Outlined buttons are medium-emphasis buttons. They contain actions
/// that are important, but they aren’t the primary action in an app.
///
/// An outlined button is a label [label] displayed on a (zero
/// elevation) [Material] widget. The label's [Text] and [Icon]
/// widgets are displayed in the [style]'s
/// [ButtonStyle.textColor] and the outline's weight and color
/// are defined by [ButtonStyle.side]. The button reacts to touches
/// by filling with the [style]'s [ButtonStyle.overlayColor].
///
/// The outlined button's default style is defined by [defaultStyleOf].
/// The style of this outline button can be overridden with its [style]
/// parameter. The style of all text buttons in a subtree can be
/// overridden with the [OutlinedButtonTheme] and the style of all of the
/// outlined buttons in an app can be overridden with the [Theme]'s
/// [ThemeData.outlinedButtonTheme] property.
///
/// Unlike [TextButton] or [ElevatedButton], outline buttons have a
/// default [ButtonStyle.side] which defines the appearance of the
/// outline. Because the default `side` is non-null, it
/// unconditionally overrides the shape's [OutlinedBorder.side]. In
/// other words, to specify an outlined button's shape _and_ the
/// appearance of its outline, both the [ButtonStyle.shape] and
/// [ButtonStyle.side] properties must be specified.
///
/// {@tool dartpad}
/// Here is an example of a basic [OutlinedButton].
///
/// ** See code in examples/api/lib/material/outlined_button/outlined_button.0.dart **
/// {@end-tool}
///
/// The static [styleFrom] method is a convenient way to create a
/// outlined button [ButtonStyle] from simple values.
///
/// See also:
///
///  * [ElevatedButton], a filled button whose material elevates when pressed.
///  * [FilledButton], a filled button that doesn't elevate when pressed.
///  * [FilledButton.tonal], a filled button variant that uses a secondary fill color.
///  * [TextButton], a button with no outline or fill color.
///  * <https://material.io/design/components/buttons.html>
///  * <https://m3.material.io/components/buttons>
class OutlinedButton extends ButtonStyleButton {
  /// Create an OutlinedButton.
  ///
  /// The [autofocus] and [clipBehavior] arguments must not be null.
  const OutlinedButton({
    super.key,
    required super.onPressed,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior = Clip.none,
    super.statesController,
    required super.label,
    super.icon,
    this.theme,
  });

  /// Customizes this button's appearance.
  ///
  /// Non-null properties of this style override the corresponding
  /// properties in [themeStyleOf] and [defaultStyleOf]. [MaterialStateProperty]s
  /// that resolve to non-null values will similarly override the corresponding
  /// [MaterialStateProperty]s in [themeStyleOf] and [defaultStyleOf].
  ///
  /// Null by default.
  final OutlinedButtonThemeData? theme;

  @override
  ButtonStyle resolveStyle(BuildContext context) {
    return OutlinedButtonTheme.resolve(context, theme).style;
  }
}

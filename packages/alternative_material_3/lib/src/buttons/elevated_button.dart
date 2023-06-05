// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import '../material_state.dart';
import '../theme.dart';
import 'button.dart';
import 'button_style.dart';

/// A Material Design "elevated button".
///
/// Use elevated buttons to add dimension to otherwise mostly flat
/// layouts, e.g. in long busy lists of content, or in wide
/// spaces. Avoid using elevated buttons on already-elevated content
/// such as dialogs or cards.
///
/// An elevated button is a label [label] displayed on a [Material]
/// widget whose [Material.elevation] increases when the button is
/// pressed. The label's [Text] and [Icon] widgets are displayed in
/// [style]'s [ButtonStyle.textColor] and the button's filled
/// background is the [ButtonStyle.containerColor].
///
/// The elevated button's default style is defined by
/// [defaultStyleOf]. The style of this elevated button can be
/// overridden with its [style] parameter. The style of all elevated
/// buttons in a subtree can be overridden with the
/// [ElevatedButtonTheme], and the style of all of the elevated
/// buttons in an app can be overridden with the [Theme]'s
/// [ThemeData.elevatedButtonTheme] property.
///
/// The static [styleFrom] method is a convenient way to create a
/// elevated button [ButtonStyle] from simple values.
///
/// If [onPressed] and [onLongPress] callbacks are null, then the
/// button will be disabled.
///
/// {@tool dartpad}
/// This sample produces an enabled and a disabled ElevatedButton.
///
/// ** See code in examples/api/lib/material/elevated_button/elevated_button.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [FilledButton], a filled button that doesn't elevate when pressed.
///  * [FilledButton.tonal], a filled button variant that uses a secondary fill color.
///  * [OutlinedButton], a button with an outlined border and no fill color.
///  * [TextButton], a button with no outline or fill color.
///  * <https://material.io/design/components/buttons.html>
///  * <https://m3.material.io/components/buttons>
class ElevatedButton extends ButtonStyleButton {
  /// Create an ElevatedButton.
  ///
  /// The [autofocus] and [clipBehavior] arguments must not be null.
  const ElevatedButton({
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
  final ElevatedButtonThemeData? theme;

  @override
  ButtonStyle resolveStyle(BuildContext context) {
    return ElevatedButtonTheme.resolve(context, theme).style;
  }
}

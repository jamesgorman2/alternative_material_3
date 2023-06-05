// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import '../material_state.dart';
import '../theme.dart';
import 'button.dart';

/// A Material Design filled button.
///
/// Filled buttons have the most visual impact after the [FloatingActionButton],
/// and should be used for important, final actions that complete a flow,
/// like **Save**, **Join now**, or **Confirm**.
///
/// A filled button is a label [label] displayed on a [Material]
/// widget. The label's [Text] and [Icon] widgets are displayed in
/// [style]'s [ButtonStyle.textColor] and the button's filled
/// background is the [ButtonStyle.containerColor].
///
/// The filled button's default style is defined by
/// [defaultStyleOf]. The style of this filled button can be
/// overridden with its [style] parameter. The style of all filled
/// buttons in a subtree can be overridden with the
/// [FilledTonalButtonTheme], and the style of all of the filled
/// buttons in an app can be overridden with the [Theme]'s
/// [ThemeData.filledTonalButtonTheme] property.
///
/// The static [styleFrom] method is a convenient way to create a
/// filled button [ButtonStyle] from simple values.
///
/// If [onPressed] and [onLongPress] callbacks are null, then the
/// button will be disabled.
///
/// {@tool dartpad}
/// This sample produces enabled and disabled filled and filled tonal
/// buttons.
///
/// ** See code in examples/api/lib/material/filled_button/filled_button.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [ElevatedButton], a filled button whose material elevates when pressed.
///  * [OutlinedButton], a button with an outlined border and no fill color.
///  * [TextButton], a button with no outline or fill color.
///  * <https://material.io/design/components/buttons.html>
///  * <https://m3.material.io/components/buttons>
class FilledTonalButton extends ButtonStyleButton {
  /// Create a FilledTonalButton.
  ///
  /// The [autofocus] and [clipBehavior] arguments must not be null.
  const FilledTonalButton({
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
  final FilledTonalButtonThemeData? theme;

  @override
  ButtonStyle resolveStyle(BuildContext context) {
    return FilledTonalButtonTheme.resolve(context, theme).style;
  }
}

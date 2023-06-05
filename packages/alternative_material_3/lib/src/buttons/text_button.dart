// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../color_scheme.dart';
import '../colors.dart';
import '../constants.dart';
import '../elevation.dart';
import '../ink_well.dart';
import '../material_state.dart';
import '../theme.dart';
import '../theme_data.dart';
import 'button.dart';
import 'button_style.dart';

/// A Material Design "Text Button".
///
/// Use text buttons on toolbars, in dialogs, or inline with other
/// content but offset from that content with padding so that the
/// button's presence is obvious. Text buttons do not have visible
/// borders and must therefore rely on their position relative to
/// other content for context. In dialogs and cards, they should be
/// grouped together in one of the bottom corners. Avoid using text
/// buttons where they would blend in with other content, for example
/// in the middle of lists.
///
/// A text button is a label [label] displayed on a (zero elevation)
/// [Material] widget. The label's [Text] and [Icon] widgets are
/// displayed in the [style]'s [ButtonStyle.textColor]. The
/// button reacts to touches by filling with the [style]'s
/// [ButtonStyle.containerColor].
///
/// The text button's default style is defined by [defaultStyleOf].
/// The style of this text button can be overridden with its [style]
/// parameter. The style of all text buttons in a subtree can be
/// overridden with the [TextButtonTheme] and the style of all of the
/// text buttons in an app can be overridden with the [Theme]'s
/// [ThemeData.textButtonTheme] property.
///
/// The static [styleFrom] method is a convenient way to create a
/// text button [ButtonStyle] from simple values.
///
/// If the [onPressed] and [onLongPress] callbacks are null, then this
/// button will be disabled, it will not react to touch.
///
/// {@tool dartpad}
/// This sample shows how to render a disabled TextButton, an enabled TextButton
/// and lastly a TextButton with gradient background.
///
/// ** See code in examples/api/lib/material/text_button/text_button.0.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This sample demonstrates using the [statesController] parameter to create a button
/// that adds support for [MaterialState.selected].
///
/// ** See code in examples/api/lib/material/text_button/text_button.1.dart **
/// {@end-tool}
///
/// See also:
///
///  * [ElevatedButton], a filled button whose material elevates when pressed.
///  * [FilledButton], a filled button that doesn't elevate when pressed.
///  * [FilledButton.tonal], a filled button variant that uses a secondary fill color.
///  * [OutlinedButton], a button with an outlined border and no fill color.
///  * <https://material.io/design/components/buttons.html>
///  * <https://m3.material.io/components/buttons>
class TextButton extends ButtonStyleButton {
  /// Create a TextButton.
  ///
  /// The [autofocus] and [clipBehavior] arguments must not be null.
  const TextButton({
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
  final TextButtonThemeData? theme;

  @override
  ButtonStyle resolveStyle(BuildContext context) {
    return TextButtonTheme.resolve(context, theme).style;
  }
}

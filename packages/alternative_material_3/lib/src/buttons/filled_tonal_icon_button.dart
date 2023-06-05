// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'button_style.dart';
import 'icon_button.dart';

///
class FilledTonalIconButton extends SelectableIconButton {
  ///
  const FilledTonalIconButton({
    super.key,
    required super.onPressed,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior = Clip.none,
    super.statesController,
    required super.icon,
    super.selectedIcon,
    super.isSelected = false,
    super.tooltipMessage,
    this.theme,
    bool isToggle = false,
  }) : _isToggle = isToggle;

  ///
  const FilledTonalIconButton.toggle({
    super.key,
    required super.onPressed,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior = Clip.none,
    super.statesController,
    required super.icon,
    super.selectedIcon,
    super.isSelected = false,
    super.tooltipMessage,
    this.theme,
  }) : _isToggle = true;

  /// {@macro alternative_material_3.icon_button.theme}
  final FilledTonalIconButtonThemeData? theme;

  final bool _isToggle;

  @override
  ButtonStyle resolveStyle(BuildContext context) {
    return _isToggle
        ? FilledTonalIconButtonTheme.resolve(context, theme).toggleableStyle
        : FilledTonalIconButtonTheme.resolve(context, theme).plainStyle;
  }
}

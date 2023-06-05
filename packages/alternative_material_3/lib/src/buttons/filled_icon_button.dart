// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'button_style.dart';
import 'icon_button.dart';

///
class FilledIconButton extends SelectableIconButton {
  ///
  const FilledIconButton({
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
  const FilledIconButton.toggle({
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
  final FilledIconButtonThemeData? theme;

  final bool _isToggle;

  @override
  ButtonStyle resolveStyle(BuildContext context) {
    return _isToggle
        ? FilledIconButtonTheme.resolve(context, theme).toggleableStyle
        : FilledIconButtonTheme.resolve(context, theme).plainStyle;
  }
}

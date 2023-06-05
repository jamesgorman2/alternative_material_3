// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'button_style.dart';
import 'icon_button.dart';

///
class OutlinedIconButton extends SelectableIconButton {
  ///
  const OutlinedIconButton({
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
  });

  /// {@macro alternative_material_3.icon_button.theme}
  final OutlinedIconButtonThemeData? theme;

  @override
  ButtonStyle resolveStyle(BuildContext context) {
    return OutlinedIconButtonTheme.resolve(context, theme).style;
  }
}

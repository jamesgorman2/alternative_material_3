// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../chips/chip.dart';
import '../fp/either_extensions.dart';

/// The data for creating input chips in our list. We need to create the
/// widgets late to manage focus state and keyboard interactions.
///
/// See also:
///
/// * [InputChip]
@immutable
class InputChipData<T> {
  /// Create an input chip.
  const InputChipData({
    this.key,
    required this.value,
    this.enabled = true,
    this.tooltip,
    this.icon,
    this.avatar,
    required this.label,
    this.onLongPress,
    this.onHover,
    this.onDeleteHover,
  });

  /// Controls how one widget replaces another widget in the tree.
  ///
  /// See also:
  /// * [Widget.key]
  final Key? key;

  /// Value used to identify the chip.
  ///
  /// This value must be unique across all chip in a [TextFieldInputChips].
  final T value;

  /// {@macro alternative_material_3.chip.isEnabled}
  final bool enabled;

  /// {@macro alternative_material_3.chip.tooltipMessage}
  final String? tooltip;

  /// {@macro alternative_material_3.chip.leadingIcon}
  final Widget? icon;

  /// {@macro alternative_material_3.chip.avatar}
  final Widget? avatar;

  /// {@macro alternative_material_3.chip.label}
  final Widget label;

  /// {@macro alternative_material_3.chip.onLongPress}
  final ValueChanged<bool>? onLongPress;

  /// {@macro alternative_material_3.chip.onHover}
  final ValueChanged<bool>? onHover;

  /// {@macro alternative_material_3.inputChip.onDeleteHover}
  final ValueChanged<bool>? onDeleteHover;
}

///
class TextFieldInputChips<T> {
  ///
  TextFieldInputChips({
    this.chipTheme,
    this.chipListTheme,
    this.deleteIcon,
    this.deleteIconTooltip,
    this.hideDeleteIcon,
    this.singleLine = false,
    required this.onDeleted,
    this.onFocusChanged,
    required this.chips,
  });

  /// {@macro alternative_material_3.chip.theme}
  final ChipThemeData? chipTheme;

  /// {@macro alternative_material_3.chipList.theme}
  final ChipListThemeData? chipListTheme;

  /// {@macro alternative_material_3.inputChip.deleteIcon}
  final Widget? deleteIcon;

  /// {@macro alternative_material_3.inputChip.deleteIconTooltip}
  final String? deleteIconTooltip;

  /// {@macro alternative_material_3.inputChip.hideDeleteIcon}
  final bool Function()? hideDeleteIcon;

  /// {@macro alternative_material_3.chipList.singleLine}
  final bool singleLine;

  /// The function that is called when a chip is deleted, either by using its
  /// delete icon or the backspace or delete key.
  ///
  /// The callback's parameter indicates which chip is deleted.
  final Function(T value) onDeleted;

  /// The function that is called when a chip changes focussed.
  ///
  /// The callback's parameter indicates which of chips gain or lose
  /// focus. This will not indicate if the input has gained or lost focus.
  final Function(T? from, T? to)? onFocusChanged;

  /// The list of chips to place is front of the text input.
  final List<InputChipData<T>> chips;

  /// Wrap a widget
  Widget wrap({
    required Widget input,
    required FocusNode inputFocusNode,
    required TextDirection? textDirection,
    required TextEditingController textController,
    ValueChanged<bool>? onInputFocusChanged,
    required Stream<void> inputPressed,
  }) {
    return _TextFieldChipList(
      inputChips: this,
      input: input,
      inputFocusNode: inputFocusNode,
      textDirection: textDirection,
      textController: textController,
      onInputFocusChanged: onInputFocusChanged,
      inputPressed: inputPressed,
    );
  }
}

/// Create an input widget with a [FocusNode].
typedef FocusableInputBuilder = Widget Function(FocusNode focusNode);

class _TextFieldChipList<T> extends StatefulWidget {
  const _TextFieldChipList({
    super.key,
    required this.inputChips,
    required this.input,
    required this.inputFocusNode,
    this.textDirection,
    required this.textController,
    this.onInputFocusChanged,
    required this.inputPressed,
  });

  final TextFieldInputChips<T> inputChips;
  final Widget input;
  final FocusNode inputFocusNode;
  final TextDirection? textDirection;
  final TextEditingController textController;
  final ValueChanged<bool>? onInputFocusChanged;
  final Stream<void> inputPressed;

  @override
  State<_TextFieldChipList<T>> createState() => _TextFieldChipListState();
}

typedef _CurrentFocus<T> = Either<T, FocusNode>;

class _TextFieldChipListState<T> extends State<_TextFieldChipList<T>> {
  final FocusNode parentFocusNode = FocusNode(
    descendantsAreTraversable: false,
  );

  late FocusNode inputFocusNode;
  _CurrentFocus<T>? currentFocus;

  late StreamSubscription<void> inputPressed;

  @override
  void initState() {
    super.initState();
    inputFocusNode = widget.inputFocusNode;
    inputFocusNode.addListener(handleInputFocusChange);

    inputPressed = widget.inputPressed.listen(handleInputPressed);
  }

  @override
  void didUpdateWidget(covariant _TextFieldChipList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    parentFocusNode.attach(context);

    if (oldWidget.inputFocusNode != widget.inputFocusNode) {
      if (isFocussedOnInput) {
        currentFocus = Right(widget.inputFocusNode);
      }
      inputFocusNode.removeListener(handleInputFocusChange);
      inputFocusNode = widget.inputFocusNode;
      inputFocusNode.addListener(handleInputFocusChange);
    }

    if (oldWidget.inputPressed != widget.inputPressed) {
      inputPressed.cancel();
      inputPressed = widget.inputPressed.listen(handleInputPressed);
    }
  }

  @override
  void dispose() {
    parentFocusNode.dispose();
    inputFocusNode.removeListener(handleInputFocusChange);
    inputPressed.cancel();
    super.dispose();
  }

  VoidCallback handleDeleted(T t) => () {
        widget.inputChips.onDeleted(t);
      };

  InputChipData<T>? dataFor(T t) {
    return widget.inputChips.chips
        .firstWhereOrNull((entry) => entry.value == t);
  }

  bool get isFocussedOnInput => currentFocus is Right;

  bool get isFocussedAtStartOfInput =>
      isFocussedOnInput &&
      widget.textController.selection.isCollapsed &&
      widget.textController.selection.start == 0;

  bool get inputIsEmpty => widget.textController.value.text.isEmpty;

  bool get isFocussedOnChips => currentFocus is Left;

  bool isFocussedOn(T t) {
    return currentFocus?.fold(
          (left) => left == t,
          (right) => false,
        ) ??
        false;
  }

  void focusOn(_CurrentFocus<T> node) {
    if (node != currentFocus) {
      final _CurrentFocus<T>? from = currentFocus;
      final _CurrentFocus<T> to = node;
      setState(() {
        currentFocus = node;
      });
      if (widget.inputChips.onFocusChanged != null) {
        widget.inputChips.onFocusChanged!(from?.leftOrNull, to.leftOrNull);
      }
      if (widget.onInputFocusChanged != null) {
        if (from?.isRight ?? false) {
          widget.onInputFocusChanged!(false);
        }
        if (to.isRight) {
          widget.onInputFocusChanged!(true);
        }
      }
    }
    if (!inputFocusNode.hasFocus) {
      inputFocusNode.requestFocus();
    }
  }

  void unfocus() {
    final _CurrentFocus<T>? from = currentFocus;
    parentFocusNode.unfocus();
    currentFocus?.forEach(fnR: (right) => right.unfocus());
    if (widget.inputChips.onFocusChanged != null && (from?.isLeft ?? false)) {
      widget.inputChips.onFocusChanged!(from?.leftOrNull, null);
    }
    currentFocus = null;
  }

  void focusOnPreviousChip(T t) {
    final chips = widget.inputChips.chips;
    final i = chips.indexWhere((data) => data.value == t);
    if (i > 0) {
      focusOn(Left(chips[i - 1].value));
    }
  }

  void focusOnLastChip() {
    if (widget.inputChips.chips.isNotEmpty) {
      focusOn(Left(widget.inputChips.chips.last.value));
    }
  }

  void focusOnPrevious() {
    currentFocus?.forEach(
      fnL: focusOnPreviousChip,
      fnR: (right) => focusOnLastChip(),
    );
  }

  void focusOnNext() {
    currentFocus?.forEach(
      fnL: (t) {
        final chips = widget.inputChips.chips;
        final i = chips.indexWhere((data) => data.value == t);
        if (i > -1 && i < (chips.length - 1)) {
          focusOn(Left(chips[i + 1].value));
        } else {
          focusOn(Right(inputFocusNode));
        }
      },
    );
  }

  void deleteCurrent() {
    currentFocus?.forEach(
      fnL: (t) {
        final chips = widget.inputChips.chips;
        final i = chips.indexWhere((data) => data.value == t);
        widget.inputChips.onDeleted(t);
        if (chips.length == 1) {
          focusOn(Right(inputFocusNode));
        } else if (i > -1 && i < (chips.length - 1)) {
          focusOn(Left(chips[i + 1].value));
        } else {
          focusOn(Left(chips[i - 1].value));
        }
      },
    );
  }

  void handleInputPressed(void v) {
    if (!isFocussedOnInput) {
      focusOn(Right(inputFocusNode));
    }
  }

  FocusOnKeyEventCallback handleKeyEvent(TextDirection textDirection) {
    final arrowStart = textDirection == TextDirection.ltr
        ? LogicalKeyboardKey.arrowLeft
        : LogicalKeyboardKey.arrowRight;
    final arrowEnd = textDirection == TextDirection.ltr
        ? LogicalKeyboardKey.arrowRight
        : LogicalKeyboardKey.arrowLeft;

    return (node, event) {
      if (event is! KeyDownEvent) {
        return KeyEventResult.ignored;
      }

      if (event.logicalKey == arrowStart &&
          (isFocussedAtStartOfInput || isFocussedOnChips)) {
        focusOnPrevious();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.backspace &&
          isFocussedAtStartOfInput &&
          widget.inputChips.chips.isNotEmpty &&
          inputIsEmpty) {
        focusOnPrevious();
        return KeyEventResult.handled;
      } else if (event.logicalKey == arrowEnd && isFocussedOnChips) {
        focusOnNext();
        return KeyEventResult.handled;
      } else if ((event.logicalKey == LogicalKeyboardKey.backspace ||
              event.logicalKey == LogicalKeyboardKey.delete) &&
          isFocussedOnChips) {
        deleteCurrent();
        return KeyEventResult.handled;
      } else if (isFocussedOnChips && event.character != null) {
        return KeyEventResult.handled;
      }

      return KeyEventResult.ignored;
    };
  }

  void handleParentOnChangeFocus(bool hasGainedFocus) {
    if (hasGainedFocus && currentFocus is! Left) {
      focusOn(Right(inputFocusNode));
    }
  }

  void handleInputFocusChange() {
    if (inputFocusNode.hasFocus && currentFocus == null) {
      setState(() {
        currentFocus = Right(inputFocusNode);
      });
    } else if (!inputFocusNode.hasFocus) {
      setState(() {
        currentFocus = null;
      });
    }
  }

  VoidCallback handleOnPressed(T value) => () {
        focusOn(Left(value));
      };

  @override
  Widget build(BuildContext context) {
    final textDirection = widget.textDirection ??
        Directionality.maybeOf(context) ??
        TextDirection.ltr;

    final inputChips = widget.inputChips;

    final chips = inputChips.chips.map(
      (chip) {
        return InputChip(
          key: ValueKey(chip.value),
          isSelected: isFocussedOn(chip.value),
          enabled: chip.enabled,
          theme: inputChips.chipTheme,
          icon: chip.icon,
          avatar: chip.avatar,
          label: chip.label,
          tooltip: chip.tooltip,
          deleteIcon: inputChips.deleteIcon,
          deleteIconTooltip: inputChips.deleteIconTooltip,
          hideDeleteIcon: inputChips.hideDeleteIcon,
          onPressed: handleOnPressed(chip.value),
          onLongPress: chip.onLongPress,
          onHover: chip.onHover,
          onDeletePressed: handleDeleted(chip.value),
          onDeleteHover: chip.onDeleteHover,
        );
      },
    );

    return SizedBox(
      width: double.infinity,
      child: Focus(
        focusNode: parentFocusNode,
        onFocusChange: handleParentOnChangeFocus,
        onKeyEvent: handleKeyEvent(textDirection),
        child: ChipList(
          theme: inputChips.chipListTheme,
          singleLine: inputChips.singleLine,
          children: [
            ...chips,
            widget.input,
          ],
        ),
      ),
    );
  }
}

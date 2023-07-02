// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../debug.dart';
import '../feedback.dart';
import '../material_localizations.dart';
import '../material_state.dart';
import '../selectable_text.dart' show iOSHorizontalOffset;
import '../theme.dart';
import 'input_decorator.dart';
import 'text_field_chips.dart';
import 'text_field_theme.dart';
import 'widgets/editable_text.dart';
import 'widgets/text_selection.dart';

export 'package:flutter/services.dart'
    show
        SmartDashesType,
        SmartQuotesType,
        TextCapitalization,
        TextInputAction,
        TextInputType;

export 'input_border.dart';
export 'input_decorator.dart';
export 'text_field_chips.dart';
export 'text_field_theme.dart';

/// Signature for the [TextField.buildCounter] callback.
typedef InputCounterWidgetBuilder = Widget? Function(
  /// The build context for the TextField.
  BuildContext context, {
  /// The length of the string currently in the input.
  required int currentLength,

  /// The maximum string length that can be entered into the TextField.
  required int? maxLength,

  /// Whether or not the TextField is currently focused. Mainly provided for
  /// the [liveRegion] parameter in the [Semantics] widget for accessibility.
  required bool isFocused,
});

class _TextFieldSelectionGestureDetectorBuilder
    extends TextSelectionGestureDetectorBuilderM3 {
  _TextFieldSelectionGestureDetectorBuilder({
    required _TextFieldState state,
  })  : _state = state,
        super(delegate: state);

  final _TextFieldState _state;

  @override
  void onForcePressStart(ForcePressDetails details) {
    super.onForcePressStart(details);
    if (delegate.selectionEnabled && shouldShowSelectionToolbar) {
      editableText.showToolbar();
    }
  }

  @override
  void onForcePressEnd(ForcePressDetails details) {
    // Not required.
  }

  @override
  void onSingleTapUp(TapDragUpDetails details) {
    super.onSingleTapUp(details);
    _state._requestKeyboard();
    _state.widget.onTap?.call();
  }

  @override
  void onSingleLongTapStart(LongPressStartDetails details) {
    super.onSingleLongTapStart(details);
    if (delegate.selectionEnabled) {
      switch (Theme.of(_state.context).platform) {
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          Feedback.forLongPress(_state.context);
      }
    }
  }
}

/// A Material Design text field.
///
/// A text field lets the user enter text, either with hardware keyboard or with
/// an onscreen keyboard.
///
/// The text field calls the [onChanged] callback whenever the user changes the
/// text in the field. If the user indicates that they are done typing in the
/// field (e.g., by pressing a button on the soft keyboard), the text field
/// calls the [onSubmitted] callback.
///
/// To control the text that is displayed in the text field, use the
/// [controller]. For example, to set the initial value of the text field, use
/// a [controller] that already contains some text. The [controller] can also
/// control the selection and composing region (and to observe changes to the
/// text, selection, and composing region).
///
/// By default, a text field has a [decoration] that draws a divider below the
/// text field. You can use the [decoration] property to control the decoration,
/// for example by adding a label or an icon. If you set the [decoration]
/// property to null, the decoration will be removed entirely, including the
/// extra padding introduced by the decoration to save space for the labels.
///
/// If [decoration] is non-null (which is the default), the text field requires
/// one of its ancestors to be a [Material] widget.
///
/// To integrate the [TextField] into a [Form] with other [FormField] widgets,
/// consider using [TextFormField].
///
/// {@template flutter.material.textfield.wantKeepAlive}
/// When the widget has focus, it will prevent itself from disposing via its
/// underlying [EditableTextM3]'s [AutomaticKeepAliveClientMixin.wantKeepAlive] in
/// order to avoid losing the selection. Removing the focus will allow it to be
/// disposed.
/// {@endtemplate}
///
/// Remember to call [TextEditingController.dispose] of the [TextEditingController]
/// when it is no longer needed. This will ensure we discard any resources used
/// by the object.
///
/// ## Obscured Input
///
/// {@tool dartpad}
/// This example shows how to create a [TextField] that will obscure input. The
/// [InputDecoration] surrounds the field in a border using [OutlineInputBorder]
/// and adds a label.
///
/// ** See code in examples/api/lib/material/text_field/text_field.0.dart **
/// {@end-tool}
///
/// ## Reading values
///
/// A common way to read a value from a TextField is to use the [onSubmitted]
/// callback. This callback is applied to the text field's current value when
/// the user finishes editing.
///
/// {@tool dartpad}
/// This sample shows how to get a value from a TextField via the [onSubmitted]
/// callback.
///
/// ** See code in examples/api/lib/material/text_field/text_field.1.dart **
/// {@end-tool}
///
/// {@macro flutter.widgets.EditableText.lifeCycle}
///
/// For most applications the [onSubmitted] callback will be sufficient for
/// reacting to user input.
///
/// The [onEditingComplete] callback also runs when the user finishes editing.
/// It's different from [onSubmitted] because it has a default value which
/// updates the text controller and yields the keyboard focus. Applications that
/// require different behavior can override the default [onEditingComplete]
/// callback.
///
/// Keep in mind you can also always read the current string from a TextField's
/// [TextEditingController] using [TextEditingController.text].
///
/// ## Handling emojis and other complex characters
/// {@macro flutter.widgets.EditableText.onChanged}
///
/// In the live Dartpad example above, try typing the emoji 👨‍👩‍👦
/// into the field and submitting. Because the example code measures the length
/// with `value.characters.length`, the emoji is correctly counted as a single
/// character.
///
/// {@macro flutter.widgets.editableText.showCaretOnScreen}
///
/// {@macro flutter.widgets.editableText.accessibility}
///
/// See also:
///
///  * [TextFormField], which integrates with the [Form] widget.
///  * [InputDecorator], which shows the labels and other visual elements that
///    surround the actual text editing widget.
///  * [EditableTextM3], which is the raw text editing control at the heart of a
///    [TextField]. The [EditableTextM3] widget is rarely used directly unless
///    you are implementing an entirely different design language, such as
///    Cupertino.
///  * <https://material.io/design/components/text-fields.html>
///  * Cookbook: [Create and style a text field](https://flutter.dev/docs/cookbook/forms/text-input)
///  * Cookbook: [Handle changes to a text field](https://flutter.dev/docs/cookbook/forms/text-field-changes)
///  * Cookbook: [Retrieve the value of a text field](https://flutter.dev/docs/cookbook/forms/retrieve-input)
///  * Cookbook: [Focus and text fields](https://flutter.dev/docs/cookbook/forms/focus)
class TextField extends StatefulWidget {
  /// Creates a Material Design text field.
  ///
  /// If [decoration] is non-null (which is the default), the text field requires
  /// one of its ancestors to be a [Material] widget.
  ///
  /// To remove the decoration entirely (including the extra padding introduced
  /// by the decoration to save space for the labels), set the [decoration] to
  /// null.
  ///
  /// The [maxLines] property can be set to null to remove the restriction on
  /// the number of lines. By default, it is one, meaning this is a single-line
  /// text field. [maxLines] must not be zero.
  ///
  /// The [maxLength] property is set to null by default, which means the
  /// number of characters allowed in the text field is not restricted. If
  /// [maxLength] is set a character counter will be displayed below the
  /// field showing how many characters have been entered. If the value is
  /// set to a positive integer it will also display the maximum allowed
  /// number of characters to be entered. If the value is set to
  /// [TextField.noMaxLength] then only the current length is displayed.
  ///
  /// After [maxLength] characters have been input, additional input
  /// is ignored, unless [maxLengthEnforcement] is set to
  /// [MaxLengthEnforcement.none].
  /// The text field enforces the length with a [LengthLimitingTextInputFormatter],
  /// which is evaluated after the supplied [inputFormatters], if any.
  /// The [maxLength] value must be either null or greater than zero.
  ///
  /// If [maxLengthEnforcement] is set to [MaxLengthEnforcement.none], then more
  /// than [maxLength] characters may be entered, and the error counter and
  /// divider will switch to the [decoration].errorStyle when the limit is
  /// exceeded.
  ///
  /// The text cursor is not shown if [showCursor] is false or if [showCursor]
  /// is null (the default) and [readOnly] is true.
  ///
  /// The [selectionHeightStyle] and [selectionWidthStyle] properties allow
  /// changing the shape of the selection highlighting. These properties default
  /// to [ui.BoxHeightStyle.tight] and [ui.BoxWidthStyle.tight] respectively and
  /// must not be null.
  ///
  /// The [textAlign], [autofocus], [obscureText], [readOnly], [autocorrect],
  /// [scrollPadding], [maxLines], [maxLength], [selectionHeightStyle],
  /// [selectionWidthStyle], [enableSuggestions], and
  /// [enableIMEPersonalizedLearning] arguments must not be null.
  ///
  /// See also:
  ///
  ///  * [maxLength], which discusses the precise meaning of "number of
  ///    characters" and how it may differ from the intuitive meaning.
  const TextField({
    super.key,
    this.controller,
    this.chips,
    this.theme,
    this.style,
    this.decoration = const InputDecoration(),
    this.focusNode,
    this.undoController,
    TextInputType? keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.textDirection,
    this.readOnly = false,
    this.showCursor,
    this.autofocus = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.enabled = true,
    this.dragStartBehavior = DragStartBehavior.start,
    bool? enableInteractiveSelection,
    this.onTap,
    this.onTapOutside,
    this.scrollController,
    this.autofillHints = const <String>[],
    this.restorationId,
    this.canRequestFocus = true,
    this.constraints,
  })  : assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
          (maxLines == null) || (minLines == null) || (maxLines >= minLines),
          "minLines can't be greater than maxLines",
        ),
        assert(
          !expands || (maxLines == null && minLines == null),
          'minLines and maxLines must be null when expands is true.',
        ),
        assert(!obscureText || maxLines == 1,
            'Obscured fields cannot be multiline.'),
        assert(maxLength == null ||
            maxLength == TextField.noMaxLength ||
            maxLength > 0),
        // Assert the following instead of setting it directly to avoid surprising the user by silently changing the value they set.
        assert(
          !identical(textInputAction, TextInputAction.newline) ||
              maxLines == 1 ||
              !identical(keyboardType, TextInputType.text),
          'Use keyboardType TextInputType.multiline when using TextInputAction.newline on a multiline TextField.',
        ),
        keyboardType = keyboardType ??
            (maxLines == 1 ? TextInputType.text : TextInputType.multiline),
        enableInteractiveSelection =
            enableInteractiveSelection ?? (!readOnly || !obscureText);

  /// {@template flutter.widgets.textFieldStyle.raw}
  const TextField.raw({
    Key? key,
    TextEditingController? controller,
    TextFieldInputChips<dynamic>? chips,
    TextFieldThemeData? theme,
    FocusNode? focusNode,
    UndoHistoryController? undoController,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextDirection? textDirection,
    bool readOnly = false,
    bool? showCursor,
    bool autofocus = false,
    bool obscureText = false,
    bool autocorrect = true,
    bool enableSuggestions = true,
    int maxLines = 1,
    int? minLines,
    bool expands = false,
    int? maxLength,
    ValueChanged<String>? onChanged,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onSubmitted,
    AppPrivateCommandCallback? onAppPrivateCommand,
    List<TextInputFormatter>? inputFormatters,
    bool enabled = true,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    bool? enableInteractiveSelection,
    VoidCallback? onTap,
    TapRegionCallback? onTapOutside,
    ScrollController? scrollController,
    List<String> autofillHints = const <String>[],
    String? restorationId,
    bool canRequestFocus = true,
    BoxConstraints? constraints,
  }) : this(
          key: key,
          theme: theme,
          style: TextFieldStyle.raw,
          decoration: const InputDecoration(),
          controller: controller,
          chips: chips,
          focusNode: focusNode,
          undoController: undoController,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          textDirection: textDirection,
          readOnly: readOnly,
          showCursor: showCursor,
          autofocus: autofocus,
          obscureText: obscureText,
          autocorrect: autocorrect,
          enableSuggestions: enableSuggestions,
          maxLines: maxLines,
          minLines: minLines,
          expands: expands,
          maxLength: maxLength,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          onSubmitted: onSubmitted,
          onAppPrivateCommand: onAppPrivateCommand,
          inputFormatters: inputFormatters,
          enabled: enabled,
          dragStartBehavior: dragStartBehavior,
          enableInteractiveSelection: enableInteractiveSelection,
          onTap: onTap,
          onTapOutside: onTapOutside,
          scrollController: scrollController,
          autofillHints: autofillHints,
          restorationId: restorationId,
          canRequestFocus: canRequestFocus,
          constraints: constraints,
        );

  /// {@template flutter.widgets.textFieldStyle.plain}
  const TextField.plain({
    Key? key,
    TextEditingController? controller,
    TextFieldInputChips<dynamic>? chips,
    TextFieldThemeData? theme,
    InputDecoration decoration = const InputDecoration(),
    FocusNode? focusNode,
    UndoHistoryController? undoController,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextDirection? textDirection,
    bool readOnly = false,
    bool? showCursor,
    bool autofocus = false,
    bool obscureText = false,
    bool autocorrect = true,
    bool enableSuggestions = true,
    int maxLines = 1,
    int? minLines,
    bool expands = false,
    int? maxLength,
    ValueChanged<String>? onChanged,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onSubmitted,
    AppPrivateCommandCallback? onAppPrivateCommand,
    List<TextInputFormatter>? inputFormatters,
    bool enabled = true,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    bool? enableInteractiveSelection,
    VoidCallback? onTap,
    TapRegionCallback? onTapOutside,
    ScrollController? scrollController,
    List<String> autofillHints = const <String>[],
    String? restorationId,
    bool canRequestFocus = true,
    BoxConstraints? constraints,
  }) : this(
          key: key,
          theme: theme,
          style: TextFieldStyle.plain,
          decoration: decoration,
          controller: controller,
          chips: chips,
          focusNode: focusNode,
          undoController: undoController,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          textDirection: textDirection,
          readOnly: readOnly,
          showCursor: showCursor,
          autofocus: autofocus,
          obscureText: obscureText,
          autocorrect: autocorrect,
          enableSuggestions: enableSuggestions,
          maxLines: maxLines,
          minLines: minLines,
          expands: expands,
          maxLength: maxLength,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          onSubmitted: onSubmitted,
          onAppPrivateCommand: onAppPrivateCommand,
          inputFormatters: inputFormatters,
          enabled: enabled,
          dragStartBehavior: dragStartBehavior,
          enableInteractiveSelection: enableInteractiveSelection,
          onTap: onTap,
          onTapOutside: onTapOutside,
          scrollController: scrollController,
          autofillHints: autofillHints,
          restorationId: restorationId,
          canRequestFocus: canRequestFocus,
          constraints: constraints,
        );

  /// {@template flutter.widgets.textFieldStyle.plain}
  const TextField.underlined({
    Key? key,
    TextEditingController? controller,
    TextFieldInputChips<dynamic>? chips,
    TextFieldThemeData? theme,
    InputDecoration decoration = const InputDecoration(),
    FocusNode? focusNode,
    UndoHistoryController? undoController,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextDirection? textDirection,
    bool readOnly = false,
    bool? showCursor,
    bool autofocus = false,
    bool obscureText = false,
    bool autocorrect = true,
    bool enableSuggestions = true,
    int maxLines = 1,
    int? minLines,
    bool expands = false,
    int? maxLength,
    ValueChanged<String>? onChanged,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onSubmitted,
    AppPrivateCommandCallback? onAppPrivateCommand,
    List<TextInputFormatter>? inputFormatters,
    bool enabled = true,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    bool? enableInteractiveSelection,
    VoidCallback? onTap,
    TapRegionCallback? onTapOutside,
    ScrollController? scrollController,
    List<String> autofillHints = const <String>[],
    String? restorationId,
    bool canRequestFocus = true,
    BoxConstraints? constraints,
  }) : this(
          key: key,
          theme: theme,
          style: TextFieldStyle.underlined,
          decoration: decoration,
          controller: controller,
          chips: chips,
          focusNode: focusNode,
          undoController: undoController,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          textDirection: textDirection,
          readOnly: readOnly,
          showCursor: showCursor,
          autofocus: autofocus,
          obscureText: obscureText,
          autocorrect: autocorrect,
          enableSuggestions: enableSuggestions,
          maxLines: maxLines,
          minLines: minLines,
          expands: expands,
          maxLength: maxLength,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          onSubmitted: onSubmitted,
          onAppPrivateCommand: onAppPrivateCommand,
          inputFormatters: inputFormatters,
          enabled: enabled,
          dragStartBehavior: dragStartBehavior,
          enableInteractiveSelection: enableInteractiveSelection,
          onTap: onTap,
          onTapOutside: onTapOutside,
          scrollController: scrollController,
          autofillHints: autofillHints,
          restorationId: restorationId,
          canRequestFocus: canRequestFocus,
          constraints: constraints,
        );

  /// {@template flutter.widgets.textFieldStyle.plain}
  const TextField.filled({
    Key? key,
    TextEditingController? controller,
    TextFieldInputChips<dynamic>? chips,
    TextFieldThemeData? theme,
    InputDecoration decoration = const InputDecoration(),
    FocusNode? focusNode,
    UndoHistoryController? undoController,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextDirection? textDirection,
    bool readOnly = false,
    bool? showCursor,
    bool autofocus = false,
    bool obscureText = false,
    bool autocorrect = true,
    bool enableSuggestions = true,
    int maxLines = 1,
    int? minLines,
    bool expands = false,
    int? maxLength,
    ValueChanged<String>? onChanged,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onSubmitted,
    AppPrivateCommandCallback? onAppPrivateCommand,
    List<TextInputFormatter>? inputFormatters,
    bool enabled = true,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    bool? enableInteractiveSelection,
    VoidCallback? onTap,
    TapRegionCallback? onTapOutside,
    ScrollController? scrollController,
    List<String> autofillHints = const <String>[],
    String? restorationId,
    bool canRequestFocus = true,
    BoxConstraints? constraints,
  }) : this(
          key: key,
          theme: theme,
          style: TextFieldStyle.filled,
          decoration: decoration,
          controller: controller,
          chips: chips,
          focusNode: focusNode,
          undoController: undoController,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          textDirection: textDirection,
          readOnly: readOnly,
          showCursor: showCursor,
          autofocus: autofocus,
          obscureText: obscureText,
          autocorrect: autocorrect,
          enableSuggestions: enableSuggestions,
          maxLines: maxLines,
          minLines: minLines,
          expands: expands,
          maxLength: maxLength,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          onSubmitted: onSubmitted,
          onAppPrivateCommand: onAppPrivateCommand,
          inputFormatters: inputFormatters,
          enabled: enabled,
          dragStartBehavior: dragStartBehavior,
          enableInteractiveSelection: enableInteractiveSelection,
          onTap: onTap,
          onTapOutside: onTapOutside,
          scrollController: scrollController,
          autofillHints: autofillHints,
          restorationId: restorationId,
          canRequestFocus: canRequestFocus,
          constraints: constraints,
        );

  /// {@template flutter.widgets.textFieldStyle.plain}
  const TextField.outlined({
    Key? key,
    TextEditingController? controller,
    TextFieldInputChips<dynamic>? chips,
    TextFieldThemeData? theme,
    InputDecoration decoration = const InputDecoration(),
    FocusNode? focusNode,
    UndoHistoryController? undoController,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextDirection? textDirection,
    bool readOnly = false,
    bool? showCursor,
    bool autofocus = false,
    bool obscureText = false,
    bool autocorrect = true,
    bool enableSuggestions = true,
    int maxLines = 1,
    int? minLines,
    bool expands = false,
    int? maxLength,
    ValueChanged<String>? onChanged,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onSubmitted,
    AppPrivateCommandCallback? onAppPrivateCommand,
    List<TextInputFormatter>? inputFormatters,
    bool enabled = true,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    bool? enableInteractiveSelection,
    VoidCallback? onTap,
    TapRegionCallback? onTapOutside,
    ScrollController? scrollController,
    List<String> autofillHints = const <String>[],
    String? restorationId,
    bool canRequestFocus = true,
    BoxConstraints? constraints,
  }) : this(
          key: key,
          theme: theme,
          style: TextFieldStyle.outlined,
          decoration: decoration,
          controller: controller,
          chips: chips,
          focusNode: focusNode,
          undoController: undoController,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          textDirection: textDirection,
          readOnly: readOnly,
          showCursor: showCursor,
          autofocus: autofocus,
          obscureText: obscureText,
          autocorrect: autocorrect,
          enableSuggestions: enableSuggestions,
          maxLines: maxLines,
          minLines: minLines,
          expands: expands,
          maxLength: maxLength,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          onSubmitted: onSubmitted,
          onAppPrivateCommand: onAppPrivateCommand,
          inputFormatters: inputFormatters,
          enabled: enabled,
          dragStartBehavior: dragStartBehavior,
          enableInteractiveSelection: enableInteractiveSelection,
          onTap: onTap,
          onTapOutside: onTapOutside,
          scrollController: scrollController,
          autofillHints: autofillHints,
          restorationId: restorationId,
          canRequestFocus: canRequestFocus,
          constraints: constraints,
        );

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  /// Optional [InputChip]s to place before the input text.
  final TextFieldInputChips<dynamic>? chips;

  /// Defines the keyboard focus for this widget.
  ///
  /// The [focusNode] is a long-lived object that's typically managed by a
  /// [StatefulWidget] parent. See [FocusNode] for more information.
  ///
  /// To give the keyboard focus to this widget, provide a [focusNode] and then
  /// use the current [FocusScope] to request the focus:
  ///
  /// ```dart
  /// FocusScope.of(context).requestFocus(myFocusNode);
  /// ```
  ///
  /// This happens automatically when the widget is tapped.
  ///
  /// To be notified when the widget gains or loses the focus, add a listener
  /// to the [focusNode]:
  ///
  /// ```dart
  /// myFocusNode.addListener(() { print(myFocusNode.hasFocus); });
  /// ```
  ///
  /// If null, this widget will create its own [FocusNode].
  ///
  /// ## Keyboard
  ///
  /// Requesting the focus will typically cause the keyboard to be shown
  /// if it's not showing already.
  ///
  /// On Android, the user can hide the keyboard - without changing the focus -
  /// with the system back button. They can restore the keyboard's visibility
  /// by tapping on a text field. The user might hide the keyboard and
  /// switch to a physical keyboard, or they might just need to get it
  /// out of the way for a moment, to expose something it's
  /// obscuring. In this case requesting the focus again will not
  /// cause the focus to change, and will not make the keyboard visible.
  ///
  /// This widget builds an [EditableTextM3] and will ensure that the keyboard is
  /// showing when it is tapped by calling [EditableTextState.requestKeyboard()].
  final FocusNode? focusNode;

  /// The decoration to show around the text field.
  ///
  /// By default, draws a horizontal line under the text field but can be
  /// configured to show an icon, label, hint text, and error text.
  ///
  /// Specify null to remove the decoration entirely (including the
  /// extra padding introduced by the decoration to save space for the labels).
  final InputDecoration decoration;

  /// Override the style of the theme.
  final TextFieldStyle? style;

  /// Override text field theme properties.
  final TextFieldThemeData? theme;

  /// {@macro flutter.widgets.editableText.keyboardType}
  final TextInputType keyboardType;

  /// The type of action button to use for the keyboard.
  ///
  /// Defaults to [TextInputAction.newline] if [keyboardType] is
  /// [TextInputType.multiline] and [TextInputAction.done] otherwise.
  final TextInputAction? textInputAction;

  /// {@macro flutter.widgets.editableText.textCapitalization}
  final TextCapitalization textCapitalization;

  /// {@macro flutter.widgets.editableText.textDirection}
  final TextDirection? textDirection;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;

  /// {@macro flutter.widgets.editableText.obscureText}
  final bool obscureText;

  /// {@macro flutter.widgets.editableText.autocorrect}
  final bool autocorrect;

  /// {@macro flutter.services.TextInputConfiguration.enableSuggestions}
  final bool enableSuggestions;

  /// {@macro flutter.widgets.editableText.maxLines}
  ///  * [expands], which determines whether the field should fill the height of
  ///    its parent.
  final int? maxLines;

  /// {@macro flutter.widgets.editableText.minLines}
  ///  * [expands], which determines whether the field should fill the height of
  ///    its parent.
  final int? minLines;

  /// {@macro flutter.widgets.editableText.expands}
  final bool expands;

  /// {@macro flutter.widgets.editableText.readOnly}
  final bool readOnly;

  /// {@macro flutter.widgets.editableText.showCursor}
  final bool? showCursor;

  /// If [maxLength] is set to this value, only the "current input length"
  /// part of the character counter is shown.
  static const int noMaxLength = -1;

  /// The maximum number of characters (Unicode grapheme clusters) to allow in
  /// the text field.
  ///
  /// If set, a character counter will be displayed below the
  /// field showing how many characters have been entered. If set to a number
  /// greater than 0, it will also display the maximum number allowed. If set
  /// to [TextField.noMaxLength] then only the current character count is displayed.
  ///
  /// After [maxLength] characters have been input, additional input
  /// is ignored, unless [maxLengthEnforcement] is set to
  /// [MaxLengthEnforcement.none].
  ///
  /// The text field enforces the length with a [LengthLimitingTextInputFormatter],
  /// which is evaluated after the supplied [inputFormatters], if any.
  ///
  /// This value must be either null, [TextField.noMaxLength], or greater than 0.
  /// If null (the default) then there is no limit to the number of characters
  /// that can be entered. If set to [TextField.noMaxLength], then no limit will
  /// be enforced, but the number of characters entered will still be displayed.
  ///
  /// Whitespace characters (e.g. newline, space, tab) are included in the
  /// character count.
  ///
  /// If [maxLengthEnforcement] is [MaxLengthEnforcement.none], then more than
  /// [maxLength] characters may be entered, but the error counter and divider
  /// will switch to the [decoration]'s [InputDecoration.errorStyle] when the
  /// limit is exceeded.
  ///
  /// {@macro flutter.services.lengthLimitingTextInputFormatter.maxLength}
  final int? maxLength;

  /// {@macro flutter.widgets.editableText.onChanged}
  ///
  /// See also:
  ///
  ///  * [inputFormatters], which are called before [onChanged]
  ///    runs and can validate and change ("format") the input value.
  ///  * [onEditingComplete], [onSubmitted]:
  ///    which are more specialized input change notifications.
  final ValueChanged<String>? onChanged;

  /// {@macro flutter.widgets.editableText.onEditingComplete}
  final VoidCallback? onEditingComplete;

  /// {@macro flutter.widgets.editableText.onSubmitted}
  ///
  /// See also:
  ///
  ///  * [TextInputAction.next] and [TextInputAction.previous], which
  ///    automatically shift the focus to the next/previous focusable item when
  ///    the user is done editing.
  final ValueChanged<String>? onSubmitted;

  /// {@macro flutter.widgets.editableText.onAppPrivateCommand}
  final AppPrivateCommandCallback? onAppPrivateCommand;

  /// {@macro flutter.widgets.editableText.inputFormatters}
  final List<TextInputFormatter>? inputFormatters;

  /// If false the text field is "disabled": it ignores taps and its
  /// [decoration] is rendered in grey.
  ///
  /// If non-null this property overrides the [decoration]'s
  /// [InputDecoration.enabled] property.
  final bool enabled;

  /// {@macro flutter.widgets.editableText.enableInteractiveSelection}
  final bool enableInteractiveSelection;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// {@macro flutter.widgets.editableText.selectionEnabled}
  bool get selectionEnabled => enableInteractiveSelection;

  /// {@template flutter.material.textfield.onTap}
  /// Called for each distinct tap except for every second tap of a double tap.
  ///
  /// The text field builds a [GestureDetector] to handle input events like tap,
  /// to trigger focus requests, to move the caret, adjust the selection, etc.
  /// Handling some of those events by wrapping the text field with a competing
  /// GestureDetector is problematic.
  ///
  /// To unconditionally handle taps, without interfering with the text field's
  /// internal gesture detector, provide this callback.
  ///
  /// If the text field is created with [enabled] false, taps will not be
  /// recognized.
  ///
  /// To be notified when the text field gains or loses the focus, provide a
  /// [focusNode] and add a listener to that.
  ///
  /// To listen to arbitrary pointer events without competing with the
  /// text field's internal gesture detector, use a [Listener].
  /// {@endtemplate}
  final GestureTapCallback? onTap;

  /// {@macro flutter.widgets.editableText.onTapOutside}
  ///
  /// {@tool dartpad}
  /// This example shows how to use a `TextFieldTapRegion` to wrap a set of
  /// "spinner" buttons that increment and decrement a value in the [TextField]
  /// without causing the text field to lose keyboard focus.
  ///
  /// This example includes a generic `SpinnerField<T>` class that you can copy
  /// into your own project and customize.
  ///
  /// ** See code in examples/api/lib/widgets/tap_region/text_field_tap_region.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [TapRegion] for how the region group is determined.
  final TapRegionCallback? onTapOutside;

  /// {@macro flutter.widgets.editableText.scrollController}
  final ScrollController? scrollController;

  /// {@macro flutter.widgets.editableText.autofillHints}
  /// {@macro flutter.services.AutofillConfiguration.autofillHints}
  final Iterable<String>? autofillHints;

  /// {@template flutter.material.textfield.restorationId}
  /// Restoration ID to save and restore the state of the text field.
  ///
  /// If non-null, the text field will persist and restore its current scroll
  /// offset and - if no [controller] has been provided - the content of the
  /// text field. If a [controller] has been provided, it is the responsibility
  /// of the owner of that controller to persist and restore it, e.g. by using
  /// a [RestorableTextEditingController].
  ///
  /// The state of this widget is persisted in a [RestorationBucket] claimed
  /// from the surrounding [RestorationScope] using the provided restoration ID.
  ///
  /// See also:
  ///
  ///  * [RestorationManager], which explains how state restoration works in
  ///    Flutter.
  /// {@endtemplate}
  final String? restorationId;

  /// Determine whether this text field can request the primary focus.
  ///
  /// Defaults to true. If false, the text field will not request focus
  /// when tapped, or when its context menu is displayed. If false it will not
  /// be possible to move the focus to the text field with tab key.
  final bool canRequestFocus;

  /// {@macro flutter.widgets.undoHistory.controller}
  final UndoHistoryController? undoController;

  /// Defines minimum and maximum sizes for the [TextField].
  ///
  /// Typically the TextField will fill the horizontal space it is given. For
  /// larger screens, it may be useful to have the maximum width clamped to
  /// a given value so it doesn't fill the whole screen. This property
  /// allows you to control how big the decorator will be in its available
  /// space.
  final BoxConstraints? constraints;

  @override
  State<TextField> createState() => _TextFieldState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextEditingController>(
        'controller', controller,
        defaultValue: null));
    properties.add(DiagnosticsProperty<TextFieldThemeData>('theme', theme,
        defaultValue: null));
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode,
        defaultValue: null));
    properties.add(DiagnosticsProperty<UndoHistoryController>(
        'undoController', undoController,
        defaultValue: null));
    properties
        .add(DiagnosticsProperty<bool>('enabled', enabled, defaultValue: null));
    properties.add(DiagnosticsProperty<InputDecoration>(
        'decoration', decoration,
        defaultValue: const InputDecoration()));
    properties.add(DiagnosticsProperty<TextInputType>(
        'keyboardType', keyboardType,
        defaultValue: TextInputType.text));
    properties.add(
        DiagnosticsProperty<bool>('autofocus', autofocus, defaultValue: false));
    properties.add(DiagnosticsProperty<bool>('obscureText', obscureText,
        defaultValue: false));
    properties.add(DiagnosticsProperty<bool>('autocorrect', autocorrect,
        defaultValue: true));
    properties.add(DiagnosticsProperty<bool>(
        'enableSuggestions', enableSuggestions,
        defaultValue: true));
    properties.add(IntProperty('maxLines', maxLines, defaultValue: 1));
    properties.add(IntProperty('minLines', minLines, defaultValue: null));
    properties.add(
        DiagnosticsProperty<bool>('expands', expands, defaultValue: false));
    properties.add(IntProperty('maxLength', maxLength, defaultValue: null));
    properties.add(EnumProperty<TextInputAction>(
        'textInputAction', textInputAction,
        defaultValue: null));
    properties.add(EnumProperty<TextCapitalization>(
        'textCapitalization', textCapitalization,
        defaultValue: TextCapitalization.none));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection,
        defaultValue: null));
    properties.add(FlagProperty('selectionEnabled',
        value: selectionEnabled,
        defaultValue: true,
        ifFalse: 'selection disabled'));
    properties.add(DiagnosticsProperty<ScrollController>(
        'scrollController', scrollController,
        defaultValue: null));
  }
}

class _TextFieldState extends State<TextField>
    with RestorationMixin
    implements TextSelectionGestureDetectorBuilderM3Delegate, AutofillClient {
  RestorableTextEditingController? _controller;

  TextEditingController get _effectiveController =>
      widget.controller ?? _controller!.value;

  FocusNode? _focusNode;

  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= FocusNode());

  bool _isHovering = false;

  bool get needsCounter =>
      widget.maxLength != null && widget.decoration.counterText == null;

  bool _showSelectionHandles = false;

  late _TextFieldSelectionGestureDetectorBuilder
      _selectionGestureDetectorBuilder;

  // API for TextSelectionGestureDetectorBuilderDelegate.
  @override
  late bool forcePressEnabled;

  @override
  final GlobalKey<EditableTextM3State> editableTextKey =
      GlobalKey<EditableTextM3State>();

  @override
  bool get selectionEnabled => widget.selectionEnabled;

  // End of API for TextSelectionGestureDetectorBuilderDelegate.

  bool get _isEnabled => widget.enabled;

  int get _currentLength => _effectiveController.value.text.characters.length;

  bool get _hasOverLengthError =>
      widget.maxLength != null &&
      widget.maxLength! > 0 &&
      _effectiveController.value.text.characters.length > widget.maxLength!;

  bool get _hasError =>
      widget.decoration.hasError || _hasOverLengthError;

  bool _inputHasFocus = true;

  void handleInputChipListFocusChange(bool inputHasFocus) {
    if (_inputHasFocus != inputHasFocus) {
      setState(() {
        _inputHasFocus = inputHasFocus;
      });

    }
  }

  InputDecoration _getDecorationWithCounter(TextFieldThemeData textFieldTheme) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final InputDecoration effectiveDecoration = widget.decoration;

    if (textFieldTheme.style == TextFieldStyle.raw) {
      return effectiveDecoration;
    }

    // No need to build anything if counter or counterText were given directly.
    if (effectiveDecoration.counter != null ||
        effectiveDecoration.counterText != null) {
      return effectiveDecoration;
    }

    // If buildCounter was provided, use it to generate a counter widget.
    final int currentLength = _currentLength;
    if (textFieldTheme.buildCounter != null) {
      final bool isFocused = _effectiveFocusNode.hasFocus;
      final Widget? builtCounter = textFieldTheme.buildCounter!(
        context,
        currentLength: currentLength,
        maxLength: widget.maxLength,
        isFocused: isFocused,
      );
      // If buildCounter returns null, don't add a counter widget to the field.
      if (builtCounter == null) {
        return effectiveDecoration;
      }
      return effectiveDecoration.copyWith(
          counter: Semantics(
        container: true,
        liveRegion: isFocused,
        child: builtCounter,
      ));
    }

    if (widget.maxLength == null) {
      return effectiveDecoration;
    } // No counter widget

    String counterText = '$currentLength';
    String semanticCounterText = '';

    // Handle a real maxLength (positive number)
    if (widget.maxLength! > 0) {
      // Show the maxLength in the counter
      counterText += '/${widget.maxLength}';
      final int remaining = (widget.maxLength! - currentLength)
          .clamp(0, widget.maxLength!); // ignore_clamp_double_lint
      semanticCounterText =
          localizations.remainingTextFieldCharacterCount(remaining);
    }

    return effectiveDecoration.copyWith(
      counterText: counterText,
      semanticCounterText: semanticCounterText,
    );
  }

  @override
  void initState() {
    super.initState();
    _selectionGestureDetectorBuilder =
        _TextFieldSelectionGestureDetectorBuilder(state: this);
    if (widget.controller == null) {
      _createLocalController();
    }
    _effectiveFocusNode.canRequestFocus = widget.canRequestFocus && _isEnabled;
    _effectiveFocusNode.addListener(_handleFocusChanged);
  }

  bool get _canRequestFocus {
    final NavigationMode mode =
        MediaQuery.maybeNavigationModeOf(context) ?? NavigationMode.traditional;
    switch (mode) {
      case NavigationMode.traditional:
        return widget.canRequestFocus && _isEnabled;
      case NavigationMode.directional:
        return true;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _effectiveFocusNode.canRequestFocus = _canRequestFocus;
  }

  @override
  void didUpdateWidget(TextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null && oldWidget.controller != null) {
      _createLocalController(oldWidget.controller!.value);
    } else if (widget.controller != null && oldWidget.controller == null) {
      unregisterFromRestoration(_controller!);
      _controller!.dispose();
      _controller = null;
    }

    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _focusNode)?.removeListener(_handleFocusChanged);
      (widget.focusNode ?? _focusNode)?.addListener(_handleFocusChanged);
    }

    _effectiveFocusNode.canRequestFocus = _canRequestFocus;

    if (_effectiveFocusNode.hasFocus &&
        widget.readOnly != oldWidget.readOnly &&
        _isEnabled) {
      if (_effectiveController.selection.isCollapsed) {
        _showSelectionHandles = !widget.readOnly;
      }
    }
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    if (_controller != null) {
      _registerController();
    }
  }

  void _registerController() {
    assert(_controller != null);
    registerForRestoration(_controller!, 'controller');
  }

  void _createLocalController([TextEditingValue? value]) {
    assert(_controller == null);
    _controller = value == null
        ? RestorableTextEditingController()
        : RestorableTextEditingController.fromValue(value);
    if (!restorePending) {
      _registerController();
    }
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_handleFocusChanged);
    _focusNode?.dispose();
    _controller?.dispose();
    _inputPressedStream.close();
    super.dispose();
  }

  EditableTextM3State? get _editableText => editableTextKey.currentState;

  void _requestKeyboard() {
    _editableText?.requestKeyboard();
  }

  bool _shouldShowSelectionHandles(SelectionChangedCause? cause) {
    // When the text field is activated by something that doesn't trigger the
    // selection overlay, we shouldn't show the handles either.
    if (!_selectionGestureDetectorBuilder.shouldShowSelectionToolbar) {
      return false;
    }

    if (cause == SelectionChangedCause.keyboard) {
      return false;
    }

    if (widget.readOnly && _effectiveController.selection.isCollapsed) {
      return false;
    }

    if (!_isEnabled) {
      return false;
    }

    if (cause == SelectionChangedCause.longPress ||
        cause == SelectionChangedCause.scribble) {
      return true;
    }

    if (_effectiveController.text.isNotEmpty) {
      return true;
    }

    return false;
  }

  void _handleFocusChanged() {
    setState(() {
      // Rebuild the widget on focus change to show/hide the text selection
      // highlight.
    });
  }

  void _handleSelectionChanged(
      TextSelection selection, SelectionChangedCause? cause) {
    final bool willShowSelectionHandles = _shouldShowSelectionHandles(cause);
    if (willShowSelectionHandles != _showSelectionHandles) {
      setState(() {
        _showSelectionHandles = willShowSelectionHandles;
      });
    }

    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      case TargetPlatform.fuchsia:
      case TargetPlatform.android:
        if (cause == SelectionChangedCause.longPress) {
          _editableText?.bringIntoView(selection.extent);
        }
    }

    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
      case TargetPlatform.android:
        break;
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        if (cause == SelectionChangedCause.drag) {
          _editableText?.hideToolbar();
        }
    }
  }

  /// Toggle the toolbar when a selection handle is tapped.
  void _handleSelectionHandleTapped() {
    if (_effectiveController.selection.isCollapsed) {
      _editableText!.toggleToolbar();
    }
  }

  void _handleHover(bool hovering) {
    if (hovering != _isHovering) {
      setState(() {
        _isHovering = hovering;
      });
    }
  }

  // AutofillClient implementation start.
  @override
  String get autofillId => _editableText!.autofillId;

  @override
  void autofill(TextEditingValue newEditingValue) =>
      _editableText!.autofill(newEditingValue);

  @override
  TextInputConfiguration get textInputConfiguration {
    final List<String>? autofillHints =
        widget.autofillHints?.toList(growable: false);
    final AutofillConfiguration autofillConfiguration = autofillHints != null
        ? AutofillConfiguration(
            uniqueIdentifier: autofillId,
            autofillHints: autofillHints,
            currentEditingValue: _effectiveController.value,
            hintText: widget.decoration.placeholderText,
          )
        : AutofillConfiguration.disabled;

    return _editableText!.textInputConfiguration
        .copyWith(autofillConfiguration: autofillConfiguration);
  }

  // AutofillClient implementation end.

  Set<MaterialState> get _materialState {
    return <MaterialState>{
      if (!_isEnabled) MaterialState.disabled,
      if (_isHovering) MaterialState.hovered,
      if (_effectiveFocusNode.hasFocus) MaterialState.focused,
      if (_hasError) MaterialState.error,
    };
  }

  final StreamController<void> _inputPressedStream =
      StreamController(sync: true);

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasDirectionality(context));

    final theme = Theme.of(context);
    final textFieldTheme = TextFieldTheme.resolve(
      context,
      widget.theme?.copyWith(style: widget.style) ??
          (widget.style != null
              ? TextFieldThemeData(style: widget.style!)
              : null),
    );

    final TextEditingController controller = _effectiveController;
    final FocusNode focusNode = _effectiveFocusNode;
    final List<TextInputFormatter> formatters = <TextInputFormatter>[
      ...?widget.inputFormatters,
      if (widget.maxLength != null)
        LengthLimitingTextInputFormatter(
          widget.maxLength,
          maxLengthEnforcement: textFieldTheme.maxLengthEnforcement,
        ),
    ];

    final bool paintCursorAboveText;
    Offset? cursorOffset;
    Color? autocorrectionTextRectColor;
    VoidCallback? handleDidGainAccessibilityFocus;

    switch (theme.platform) {
      case TargetPlatform.iOS:
        forcePressEnabled = true;
        paintCursorAboveText = true;
        cursorOffset = Offset(
            iOSHorizontalOffset / MediaQuery.devicePixelRatioOf(context), 0);
        autocorrectionTextRectColor = textFieldTheme.selectionColor;

      case TargetPlatform.macOS:
        forcePressEnabled = false;
        paintCursorAboveText = true;
        cursorOffset = Offset(
            iOSHorizontalOffset / MediaQuery.devicePixelRatioOf(context), 0);
        handleDidGainAccessibilityFocus = () {
          // Automatically activate the TextField when it receives accessibility focus.
          if (!_effectiveFocusNode.hasFocus &&
              _effectiveFocusNode.canRequestFocus) {
            _effectiveFocusNode.requestFocus();
          }
        };

      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
        forcePressEnabled = false;
        paintCursorAboveText = false;

      case TargetPlatform.windows:
        forcePressEnabled = false;
        paintCursorAboveText = false;
        handleDidGainAccessibilityFocus = () {
          // Automatically activate the TextField when it receives accessibility focus.
          if (!_effectiveFocusNode.hasFocus &&
              _effectiveFocusNode.canRequestFocus) {
            _effectiveFocusNode.requestFocus();
          }
        };
    }

    final materialState = _materialState;
    Widget child = RepaintBoundary(
      child: UnmanagedRestorationScope(
        bucket: bucket,
        child: EditableTextM3(
          key: editableTextKey,
          readOnly: widget.readOnly || !_isEnabled,
          showCursor: _inputHasFocus ? widget.showCursor : false,
          showSelectionHandles: _showSelectionHandles,
          controller: controller,
          focusNode: focusNode,
          undoController: widget.undoController,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          style: textFieldTheme.inputTextStyle
              .copyWith(color: textFieldTheme.textColor.resolve(materialState)),
          strutStyle: textFieldTheme.strutStyle ?? StrutStyle.disabled,
          textAlign: textFieldTheme.textAlign,
          textDirection: widget.textDirection,
          autofocus: widget.autofocus,
          obscuringCharacter: textFieldTheme.obscuringCharacter,
          obscureText: widget.obscureText,
          autocorrect: widget.autocorrect,
          smartDashesType: widget.obscureText
              ? SmartDashesType.disabled
              : textFieldTheme.smartDashesType,
          smartQuotesType: widget.obscureText
              ? SmartQuotesType.disabled
              : textFieldTheme.smartQuotesType,
          enableSuggestions: widget.enableSuggestions,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          expands: widget.expands,
          forceLine: widget.chips?.chips.isEmpty ?? true,
          // Only show the selection highlight when the text field is focused.
          selectionColor:
              focusNode.hasFocus ? textFieldTheme.selectionColor : null,
          selectionControls:
              widget.selectionEnabled ? textFieldTheme.selectionControls : null,
          onChanged: widget.onChanged,
          onSelectionChanged: _handleSelectionChanged,
          onEditingComplete: widget.onEditingComplete,
          onSubmitted: widget.onSubmitted,
          onAppPrivateCommand: widget.onAppPrivateCommand,
          onSelectionHandleTapped: _handleSelectionHandleTapped,
          onTapOutside: widget.onTapOutside,
          inputFormatters: formatters,
          rendererIgnoresPointer: textFieldTheme.style != TextFieldStyle.raw,
          mouseCursor: textFieldTheme.mouseCursor.resolve(materialState),
          // TextField will handle the cursor
          cursorWidth: textFieldTheme.cursorWidth,
          cursorHeight: textFieldTheme.cursorHeight,
          cursorRadius: textFieldTheme.cursorRadius,
          cursorColor: textFieldTheme.cursorColor.resolve(materialState),
          selectionHeightStyle: textFieldTheme.selectionHeightStyle,
          selectionWidthStyle: textFieldTheme.selectionWidthStyle,
          cursorOpacityAnimates: textFieldTheme.cursorOpacityAnimates,
          cursorOffset: cursorOffset,
          paintCursorAboveText: paintCursorAboveText,
          backgroundCursorColor: CupertinoColors.inactiveGray,
          scrollPadding: textFieldTheme.scrollPadding,
          keyboardAppearance: textFieldTheme.keyboardAppearance,
          enableInteractiveSelection: widget.enableInteractiveSelection,
          dragStartBehavior: widget.dragStartBehavior,
          scrollController: widget.scrollController,
          scrollPhysics: textFieldTheme.scrollPhysics,
          autofillClient: this,
          autocorrectionTextRectColor: autocorrectionTextRectColor,
          clipBehavior: textFieldTheme.clipBehavior,
          restorationId: 'editable',
          scribbleEnabled: textFieldTheme.scribbleEnabled,
          enableIMEPersonalizedLearning:
              textFieldTheme.enableIMEPersonalizedLearning,
          contentInsertionConfiguration:
              textFieldTheme.contentInsertionConfiguration,
          contextMenuBuilder: textFieldTheme.contextMenuBuilder,
          spellCheckConfiguration: textFieldTheme.spellCheckConfiguration,
          magnifierConfiguration: textFieldTheme.magnifierConfiguration,
        ),
      ),
    );

    if (widget.chips != null) {
      child = widget.chips!.wrap(
        input: child,
        inputFocusNode: focusNode,
        textDirection: widget.textDirection,
        textController: controller,
        onInputFocusChanged: handleInputChipListFocusChange,
        inputPressed: _inputPressedStream.stream,
      );
    }

    if (textFieldTheme.style != TextFieldStyle.raw) {
      child = AnimatedBuilder(
        animation: Listenable.merge(<Listenable>[focusNode, controller]),
        builder: (BuildContext context, Widget? child) {
          return InputDecorator(
            style: textFieldTheme.style,
            theme: textFieldTheme,
            materialStates: materialState,
            decoration: _getDecorationWithCounter(textFieldTheme),
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            isEmpty: controller.value.text.isEmpty &&
                (widget.chips?.chips.isEmpty ?? true),
            expands: widget.expands,
            constraints: widget.constraints,
            child: child!,
          );
        },
        child: child,
      );
    }
    final int? semanticsMaxValueLength;
    if (textFieldTheme.maxLengthEnforcement != MaxLengthEnforcement.none &&
        widget.maxLength != null &&
        widget.maxLength! > 0) {
      semanticsMaxValueLength = widget.maxLength;
    } else {
      semanticsMaxValueLength = null;
    }

    return MouseRegion(
      onEnter: (PointerEnterEvent event) => _handleHover(true),
      onExit: (PointerExitEvent event) => _handleHover(false),
      child: TextFieldTapRegion(
        onTapInside: (_) => _inputPressedStream.add(null),
        child: IgnorePointer(
          ignoring: !_isEnabled,
          child: AnimatedBuilder(
            animation: controller, // changes the _currentLength
            builder: (BuildContext context, Widget? child) {
              return Semantics(
                maxValueLength: semanticsMaxValueLength,
                currentValueLength: _currentLength,
                onTap: widget.readOnly
                    ? null
                    : () {
                        if (!_effectiveController.selection.isValid) {
                          _effectiveController.selection =
                              TextSelection.collapsed(
                                  offset: _effectiveController.text.length);
                        }
                        _requestKeyboard();
                      },
                onDidGainAccessibilityFocus: handleDidGainAccessibilityFocus,
                child: child,
              );
            },
            child: _selectionGestureDetectorBuilder.buildGestureDetector(
              behavior: HitTestBehavior.translucent,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'checkbox.dart';
import 'checkbox_theme.dart';
import 'list_tile.dart';
import 'list_tile_element.dart';
import 'list_tile_theme.dart';
import 'theme.dart';

// Examples can assume:
// late bool? _throwShotAway;
// void setState(VoidCallback fn) { }

enum _CheckboxType { material, adaptive }

/// A [ListTile] with a [Checkbox]. In other words, a checkbox with a label.
///
/// The entire list tile is interactive: tapping anywhere in the tile toggles
/// the checkbox.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=RkSqPAn9szs}
///
/// The [value], [onChanged], [activeColor] and [checkColor] properties of this widget are
/// identical to the similarly-named properties on the [Checkbox] widget.
///
/// The [headline], [supportingText], [isThreeLine], [dense], and [contentPadding] properties are like
/// those of the same name on [ListTile].
///
/// The [selected] property on this widget is similar to the [ListTile.selected]
/// property. This tile's [activeColor] is used for the selected item's text color, or
/// the theme's [CheckboxThemeData.stateLayerColor] if [activeColor] is null.
///
/// This widget does not coordinate the [selected] state and the [value] state; to have the list tile
/// appear selected when the checkbox is checked, pass the same value to both.
///
/// The checkbox is shown on the right by default in left-to-right languages
/// (i.e. the trailing edge). This can be changed using [controlAffinity]. The
/// [secondary] widget is placed on the opposite side. This maps to the
/// [ListTile.leading] and [ListTile.trailing] properties of [ListTile].
///
/// This widget requires a [Material] widget ancestor in the tree to paint
/// itself on, which is typically provided by the app's [Scaffold].
/// The [tileColor], and [selectedTileColor] are not painted by the
/// [CheckboxListTile] itself but by the [Material] widget ancestor.
/// In this case, one can wrap a [Material] widget around the [CheckboxListTile],
/// e.g.:
///
/// {@tool snippet}
/// ```dart
/// ColoredBox(
///   color: Colors.green,
///   child: Material(
///     child: CheckboxListTile(
///       tileColor: Colors.red,
///       title: const Text('CheckboxListTile with red background'),
///       value: true,
///       onChanged:(bool? value) { },
///     ),
///   ),
/// )
/// ```
/// {@end-tool}
///
/// ## Performance considerations when wrapping [CheckboxListTile] with [Material]
///
/// Wrapping a large number of [CheckboxListTile]s individually with [Material]s
/// is expensive. Consider only wrapping the [CheckboxListTile]s that require it
/// or include a common [Material] ancestor where possible.
///
/// To show the [CheckboxListTile] as disabled, pass null as the [onChanged]
/// callback.
///
/// {@tool dartpad}
/// ![CheckboxListTile sample](https://flutter.github.io/assets-for-api-docs/assets/material/checkbox_list_tile.png)
///
/// This widget shows a checkbox that, when checked, slows down all animations
/// (including the animation of the checkbox itself getting checked!).
///
/// This sample requires that you also import 'package:flutter/scheduler.dart',
/// so that you can reference [timeDilation].
///
/// ** See code in examples/api/lib/material/checkbox_list_tile/checkbox_list_tile.0.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This sample demonstrates how [CheckboxListTile] positions the checkbox widget
/// relative to the text in different configurations.
///
/// ** See code in examples/api/lib/material/checkbox_list_tile/checkbox_list_tile.1.dart **
/// {@end-tool}
///
/// ## Semantics in CheckboxListTile
///
/// Since the entirety of the CheckboxListTile is interactive, it should represent
/// itself as a single interactive entity.
///
/// To do so, a CheckboxListTile widget wraps its children with a [MergeSemantics]
/// widget. [MergeSemantics] will attempt to merge its descendant [Semantics]
/// nodes into one node in the semantics tree. Therefore, CheckboxListTile will
/// throw an error if any of its children requires its own [Semantics] node.
///
/// For example, you cannot nest a [RichText] widget as a descendant of
/// CheckboxListTile. [RichText] has an embedded gesture recognizer that
/// requires its own [Semantics] node, which directly conflicts with
/// CheckboxListTile's desire to merge all its descendants' semantic nodes
/// into one. Therefore, it may be necessary to create a custom radio tile
/// widget to accommodate similar use cases.
///
/// {@tool dartpad}
/// ![Checkbox list tile semantics sample](https://flutter.github.io/assets-for-api-docs/assets/material/checkbox_list_tile_semantics.png)
///
/// Here is an example of a custom labeled checkbox widget, called
/// LinkedLabelCheckbox, that includes an interactive [RichText] widget that
/// handles tap gestures.
///
/// ** See code in examples/api/lib/material/checkbox_list_tile/custom_labeled_checkbox.0.dart **
/// {@end-tool}
///
/// ## CheckboxListTile isn't exactly what I want
///
/// If the way CheckboxListTile pads and positions its elements isn't quite
/// what you're looking for, you can create custom labeled checkbox widgets by
/// combining [Checkbox] with other widgets, such as [Text], [Padding] and
/// [InkWell].
///
/// {@tool dartpad}
/// ![Custom checkbox list tile sample](https://flutter.github.io/assets-for-api-docs/assets/material/checkbox_list_tile_custom.png)
///
/// Here is an example of a custom LabeledCheckbox widget, but you can easily
/// make your own configurable widget.
///
/// ** See code in examples/api/lib/material/checkbox_list_tile/custom_labeled_checkbox.1.dart **
/// {@end-tool}
///
/// See also:
///
///  * [ListTileTheme], which can be used to affect the style of list tiles,
///    including checkbox list tiles.
///  * [RadioListTile], a similar widget for radio buttons.
///  * [SwitchListTile], a similar widget for switches.
///  * [ListTile] and [Checkbox], the widgets from which this widget is made.
class CheckboxListTile extends StatelessWidget {
  /// Creates a combination of a list tile and a checkbox.
  ///
  /// The checkbox tile itself does not maintain any state. Instead, when the
  /// state of the checkbox changes, the widget calls the [onChanged] callback.
  /// Most widgets that use a checkbox will listen for the [onChanged] callback
  /// and rebuild the checkbox tile with a new [value] to update the visual
  /// appearance of the checkbox.
  ///
  /// The following arguments are required:
  ///
  /// * [value], which determines whether the checkbox is checked. The [value]
  ///   can only be null if [tristate] is true.
  /// * [onChanged], which is called when the value of the checkbox should
  ///   change. It can be set to null to disable the checkbox.
  ///
  /// The value of [tristate] must not be null.
  const CheckboxListTile({
    super.key,
    required this.value,
    required this.onChanged,
    this.checkboxTheme,
    this.listTileTheme,
    this.layout,
    this.focusNode,
    this.autofocus = false,
    this.isError = false,
    this.enabled,
    this.overline,
    this.headline,
    this.supportingText,
    this.chip,
    this.secondary,
    this.selected = false,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.tristate = false,
    this.checkboxShape,
    this.selectedTileColor,
    this.onFocusChange,
    this.enableFeedback,
  })  : _checkboxType = _CheckboxType.material,
        assert(tristate || value != null),
        assert(
        layout == null || layout == ListTileLayout.threeLine ||
            (layout == ListTileLayout.oneLine && overline == null && supportingText == null) ||
            (layout == ListTileLayout.twoLine && (overline == null || supportingText == null))
        );

  /// Creates a combination of a list tile and a platform adaptive checkbox.
  ///
  /// The checkbox uses [Checkbox.adaptive] to show a [CupertinoCheckbox] for
  /// iOS platforms, or [Checkbox] for all others.
  ///
  /// All other properties are the same as [CheckboxListTile].
  const CheckboxListTile.adaptive({
    super.key,
    required this.value,
    required this.onChanged,
    this.checkboxTheme,
    this.listTileTheme,
    this.layout,
    this.focusNode,
    this.autofocus = false,
    this.isError = false,
    this.enabled,
    this.overline,
    this.headline,
    this.supportingText,
    this.chip,
    this.secondary,
    this.selected = false,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.tristate = false,
    this.checkboxShape,
    this.selectedTileColor,
    this.onFocusChange,
    this.enableFeedback,
  })  : _checkboxType = _CheckboxType.adaptive,
        assert(tristate || value != null),
        assert(
          !(supportingText != null &&
              overline != null &&
              layout != ListTileLayout.threeLine),
          'CheckboxListTile.supportingText and CheckboxListTile.overline must not be present '
          'together when layout == ListTileLayout.threeLine',
        );

  /// Whether this checkbox is checked.
  final bool? value;

  /// Called when the value of the checkbox should change.
  ///
  /// The checkbox passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the checkbox tile with the
  /// new value.
  ///
  /// If null, the checkbox will be displayed as disabled.
  ///
  /// {@tool snippet}
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// CheckboxListTile(
  ///   value: _throwShotAway,
  ///   onChanged: (bool? newValue) {
  ///     setState(() {
  ///       _throwShotAway = newValue;
  ///     });
  ///   },
  ///   title: const Text('Throw away your shot'),
  /// )
  /// ```
  /// {@end-tool}
  final ValueChanged<bool?>? onChanged;

  /// CheckboxTheme overrides that only apply to this checkbox list tile.
  final CheckboxThemeData? checkboxTheme;

  /// ListTileThemeData overrides that only apply to this checkbox list tile.
  final ListTileThemeData? listTileTheme;

  /// The line layout of the [ListTile]. When no layout is passed in during
  /// construction the value will be calculated base on the presence
  /// or absence of [overline] and [supportingText], and the length of
  /// [supportingText].
  final ListTileLayout? layout;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// {@macro flutter.material.checkbox.isError}
  ///
  /// Defaults to false.
  final bool isError;

  final Widget? overline;

  /// The primary content of the list tile.
  ///
  /// Typically a [Text] widget.
  final Widget? headline;

  /// Additional content displayed below the title.
  ///
  /// Typically a [Text] widget.
  final Widget? supportingText;

  final Widget? chip;

  /// A widget to display on the opposite side of the tile from the checkbox.
  ///
  /// Typically an [Icon] widget.
  final Widget? secondary;

  /// Whether to render icons and text in the [activeColor].
  ///
  /// No effort is made to automatically coordinate the [selected] state and the
  /// [value] state. To have the list tile appear selected when the checkbox is
  /// checked, pass the same value to both.
  ///
  /// Normally, this property is left to its default value, false.
  final bool selected;

  /// Where to place the control relative to the text.
  final ListTileControlAffinity controlAffinity;

  /// If true the checkbox's [value] can be true, false, or null.
  ///
  /// Checkbox displays a dash when its value is null.
  ///
  /// When a tri-state checkbox ([tristate] is true) is tapped, its [onChanged]
  /// callback will be applied to true if the current value is false, to null if
  /// value is true, and to false if value is null (i.e. it cycles through false
  /// => true => null => false when tapped).
  ///
  /// If tristate is false (the default), [value] must not be null.
  final bool tristate;

  /// {@macro flutter.material.checkbox.shape}
  ///
  /// If this property is null then [CheckboxThemeData.shape] of [ThemeData.checkboxTheme]
  /// is used. If that's null then the shape will be a [RoundedRectangleBorder]
  /// with a circular corner radius of 1.0.
  final OutlinedBorder? checkboxShape;

  /// If non-null, defines the background color when [CheckboxListTile.selected] is true.
  final Color? selectedTileColor;

  /// {@macro flutter.material.inkwell.onFocusChange}
  final ValueChanged<bool>? onFocusChange;

  /// {@macro flutter.material.ListTile.enableFeedback}
  ///
  /// See also:
  ///
  ///  * [Feedback] for providing platform-specific feedback to certain actions.
  final bool? enableFeedback;

  /// Whether the CheckboxListTile is interactive.
  ///
  /// If false, this list tile is styled with the disabled color from the
  /// current [Theme] and the [ListTile.onTap] callback is
  /// inoperative.
  final bool? enabled;

  final _CheckboxType _checkboxType;

  void _handleValueChange() {
    assert(onChanged != null);
    switch (value) {
      case false:
        onChanged!(true);
      case true:
        onChanged!(tristate ? null : false);
      case null:
        onChanged!(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ListTileElement control;

    switch (_checkboxType) {
      case _CheckboxType.material:
        control = ListTileElement.icon24(
          child: Checkbox(
            value: value,
            onChanged: enabled ?? true ? onChanged : null,
            theme: checkboxTheme,
            autofocus: autofocus,
            tristate: tristate,
            isError: isError,
          ),
        );
      case _CheckboxType.adaptive:
        control = ListTileElement.icon24(
          child: Checkbox.adaptive(
            value: value,
            onChanged: enabled ?? true ? onChanged : null,
            theme: checkboxTheme,
            autofocus: autofocus,
            tristate: tristate,
            isError: isError,
          ),
        );
    }

    ListTileElement? leading;
    ListTileElement? trailing;
    switch (controlAffinity) {
      case ListTileControlAffinity.leading:
        leading = control;
        trailing = ListTileElement.wrap(secondary);
      case ListTileControlAffinity.trailing:
      case ListTileControlAffinity.platform:
        leading = ListTileElement.wrap(secondary);
        trailing = control;
    }
    return MergeSemantics(
      child: ListTile(
        layout: layout,
        theme: listTileTheme,
        leading: leading,
        overline: overline,
        headline: headline,
        supportingText: supportingText,
        chip: chip,
        trailing: trailing,
        enabled: enabled ?? onChanged != null,
        onTap: onChanged != null ? _handleValueChange : null,
        selected: selected,
        autofocus: autofocus,
        focusNode: focusNode,
        onFocusChange: onFocusChange,
      ),
    );
  }
}

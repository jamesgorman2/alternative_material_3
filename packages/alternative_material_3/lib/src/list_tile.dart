// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'buttons/button.dart';
import 'constants.dart';
import 'debug.dart';
import 'divider.dart';
import 'ink_decoration.dart';
import 'ink_well.dart';
import 'list_tile_element.dart';
import 'list_tile_theme.dart';
import 'material_state.dart';
import 'padding_correction.dart';
import 'text_extensions.dart';
import 'theme_data.dart';

// Examples can assume:
// int _act = 1;

/// Where to place the control in widgets that use [ListTile] to position a
/// control next to a label.
///
/// See also:
///
///  * [CheckboxListTile], which combines a [ListTile] with a [Checkbox].
///  * [RadioListTile], which combines a [ListTile] with a [Radio] button.
///  * [SwitchListTile], which combines a [ListTile] with a [Switch].
///  * [ExpansionTile], which combines a [ListTile] with a button that expands
///    or collapses the tile to reveal or hide the children.
enum ListTileControlAffinity {
  /// Position the control on the leading edge, and the secondary widget, if
  /// any, on the trailing edge.
  leading,

  /// Position the control on the trailing edge, and the secondary widget, if
  /// any, on the leading edge.
  trailing,

  /// Position the control relative to the text in the fashion that is typical
  /// for the current platform, and place the secondary widget on the opposite
  /// side.
  platform,
}

/// Use internally to pass the list size in lines.
enum ListTileLayout {
  /// A one-line list.
  oneLine,

  /// A two-line list.
  twoLine,

  /// A three-line list.
  threeLine,
}

/// A single fixed-height row that typically contains some text as well as
/// a leading or trailing icon.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=l8dj0yPBvgQ}
///
/// A list tile contains one to three lines of text optionally flanked by icons or
/// other widgets, such as check boxes. The icons (or other widgets) for the
/// tile are defined with the [leading] and [trailing] parameters. The first
/// line of text is not optional and is specified with [headline]. The value of
/// [supportingText], which _is_ optional, will occupy the space allocated for an
/// additional line of text, or two lines if [isThreeLine] is true. If [dense]
/// is true then the overall height of this tile and the size of the
/// [DefaultTextStyle]s that wrap the [headline] and [supportingText] widget are reduced.
///
/// It is the responsibility of the caller to ensure that [headline] and [overline]
/// do not wrap, and to ensure that [supportingText] doesn't wrap
/// (if [isThreeLine] is false) or wraps to two lines (if it is true).
///
/// The heights of the [leading] and [trailing] widgets are constrained
/// according to the
/// [Material 2](https://m2.material.io/components/lists#specs) or
/// [Material 3](https://m3.material.io/components/lists/specs) spec,
/// determined by [ThemeData.useMaterial3].
/// An exception is made for one-line ListTileM3s for accessibility. Please
/// see the example below to see how to adhere to both Material spec and
/// accessibility requirements.
///
/// By default, the [leading] and [trailing] widgets can expand as far as they wish
/// horizontally, so ensure that they are properly constrained but are limited
/// to height of 56. This can be changed using [leadingConstraint] and [trailingConstraint].
///
/// In addition, [leadingConstraint] and [trailingConstraint] can be used to
/// correct padding offsets and enforce Material styles for [IconButton]s
/// avatar, images and video widgets. User specified [ListTileM3Constraint]s
/// can also be created.
///
/// List tiles are typically used in [ListView]s, or arranged in [Column]s in
/// [Drawer]s and [Card]s.
///
/// This widget requires a [Material] widget ancestor in the tree to paint
/// itself on, which is typically provided by the app's [Scaffold].
/// The [tileColor], [selectedTileColor], [focusColor], and [hoverColor]
/// are not painted by the [ListTile] itself but by the [Material] widget
/// ancestor. In this case, one can wrap a [Material] widget around the
/// [ListTile], e.g.:
///
/// {@tool snippet}
/// ```dart
/// const ColoredBox(
///   color: Colors.green,
///   child: Material(
///     child: ListTileM3(
///       headline: Text('ListTileM3 with red background'),
///       tileColor: Colors.red,
///     ),
///   ),
/// )
/// ```
/// {@end-tool}
///
/// ## Performance considerations when wrapping [ListTile] with [Material]
///
/// Wrapping a large number of [ListTile]s individually with [Material]s
/// is expensive. Consider only wrapping the [ListTile]s that require it
/// or include a common [Material] ancestor where possible.
///
/// [ListTile] must be wrapped in a [Material] widget to animate [tileColor],
/// [selectedTileColor], [focusColor], and [hoverColor] as these colors
/// are not drawn by the list tile itself but by the material widget ancestor.
///
/// {@tool dartpad}
/// This example showcases how [ListTile] needs to be wrapped in a [Material]
/// widget to animate colors.
///
/// ** See code in examples/api/lib/material/list_tile/list_tile.0.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This example uses a [ListView] to demonstrate different configurations of
/// [ListTile]s in [Card]s.
///
/// ![Different variations of ListTileM3](https://flutter.github.io/assets-for-api-docs/assets/material/list_tile.png)
///
/// ** See code in examples/api/lib/material/list_tile/list_tile.1.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This sample shows the creation of a [ListTile] using [ThemeData.useMaterial3] flag,
/// as described in: https://m3.material.io/components/lists/overview.
///
/// ** See code in examples/api/lib/material/list_tile/list_tile.2.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This sample shows [ListTile]'s [expandedHeadlineColor] and [expandedIconColor] can use
/// [MaterialStateColor] color to change the color of the text and icon
/// when the [ListTile] is enabled, selected, or disabled.
///
/// ** See code in examples/api/lib/material/list_tile/list_tile.3.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This sample shows [ListTile.titleAlignment] can be used to configure the
/// [leading] and [trailing] widgets alignment relative to the [headline] and
/// [supportingText] widgets.
///
/// ** See code in examples/api/lib/material/list_tile/list_tile.4.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This sample shows [ListTileM3Constraint] can be used to
/// configure the [leading] and [trailing] widgets to make the list in the
/// Material 3 spec.
///
/// ** See code in examples/api/lib/material/list_tile/list_tile.5.dart **
/// {@end-tool}
///
/// {@tool snippet}
/// To use a [ListTile] within a [Row], it needs to be wrapped in an
/// [Expanded] widget. [ListTile] requires fixed width constraints,
/// whereas a [Row] does not constrain its children.
///
/// ```dart
/// const Row(
///   children: <Widget>[
///     Expanded(
///       child: ListTileM3(
///         leading: FlutterLogo(),
///         headline: Text('These ListTileM3s are expanded '),
///       ),
///     ),
///     Expanded(
///       child: ListTileM3(
///         trailing: FlutterLogo(),
///         headline: Text('to fill the available space.'),
///       ),
///     ),
///   ],
/// )
/// ```
/// {@end-tool}
/// {@tool snippet}
///
/// Tiles can be much more elaborate. Here is a tile which can be tapped, but
/// which is disabled when the `_act` variable is not 2. When the tile is
/// tapped, the whole row has an ink splash effect (see [InkWell]).
///
/// ```dart
/// ListTileM3(
///   leading: const Icon(Icons.flight_land),
///   headline: const Text("Trix's airplane"),
///   supportingText: _act != 2 ? const Text('The airplane is only in Act II.') : null,
///   enabled: _act == 2,
///   onTap: () { /* react to the tile being tapped */ }
/// )
/// ```
/// {@end-tool}
///
/// To be accessible, tappable [leading] and [trailing] widgets have to
/// be at least 48x48 in size. However, to adhere to the Material spec,
/// [trailing] and [leading] widgets in one-line ListTileM3s should visually be
/// at most 32 ([dense]: true) or 40 ([dense]: false) in height, which may
/// conflict with the accessibility requirement.
///
/// For this reason, a one-line ListTileM3 allows the height of [leading]
/// and [trailing] widgets to be constrained by the height of the ListTileM3.
/// This allows for the creation of tappable [leading] and [trailing] widgets
/// that are large enough, but it is up to the developer to ensure that
/// their widgets follow the Material spec.
///
/// {@tool snippet}
///
/// Here is an example of a one-line, non-[dense] ListTileM3 with a
/// tappable leading widget that adheres to accessibility requirements and
/// the Material spec. To adjust the use case below for a one-line, [dense]
/// ListTileM3, adjust the vertical padding to 8.0.
///
/// ```dart
/// ListTileM3(
///   leading: GestureDetector(
///     behavior: HitTestBehavior.translucent,
///     onTap: () {},
///     child: Container(
///       width: 48,
///       height: 48,
///       padding: const EdgeInsets.symmetric(vertical: 4.0),
///       alignment: Alignment.center,
///       child: const CircleAvatar(),
///     ),
///   ),
///   headline: const Text('headline'),
///   dense: false,
/// )
/// ```
/// {@end-tool}
///
/// ## The ListTileM3 layout isn't exactly what I want
///
/// If the way ListTileM3 pads and positions its elements isn't quite what
/// you're looking for, it's easy to create custom list items with a
/// combination of other widgets, such as [Row]s and [Column]s.
///
/// {@tool dartpad}
/// Here is an example of a custom list item that resembles a YouTube-related
/// video list item created with [Expanded] and [Container] widgets.
///
/// ![Custom list item a](https://flutter.github.io/assets-for-api-docs/assets/widgets/custom_list_item_a.png)
///
/// ** See code in examples/api/lib/material/list_tile/custom_list_item.0.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// Here is an example of an article list item with multiline titles and
/// subtitles. It utilizes [Row]s and [Column]s, as well as [Expanded] and
/// [AspectRatio] widgets to organize its layout.
///
/// ![Custom list item b](https://flutter.github.io/assets-for-api-docs/assets/widgets/custom_list_item_b.png)
///
/// ** See code in examples/api/lib/material/list_tile/custom_list_item.1.dart **
/// {@end-tool}
///
/// See also:
///
///  * [ListTileTheme], which defines visual properties for [ListTile]s.
///  * [ListView], which can display an arbitrary number of [ListTile]s
///    in a scrolling list.
///  * [ReorderableList],  that allows the user to interactively reorder the
///    list items.
///  * [CircleAvatar], which shows an icon representing a person and is often
///    used as the [leading] element of a ListTileM3.
///  * [Card], which can be used with [Column] to show a few [ListTile]s.
///  * [Divider], which can be used to separate [ListTile]s.
///  * [ListTile.divideTiles], a utility for inserting [Divider]s in between [ListTile]s.
///  * [CheckboxListTileM3], [ExpansionTile], [RadioListTileM3], and [SwitchListTileM3], widgets
///    that combine [ListTile] with other controls.
///  * Material 3 [ListTile] specifications are referenced from <https://m3.material.io/components/lists/specs>
///    and Material 2 [ListTile] specifications are referenced from <https://m2.material.io/components/lists#specs>
///  * Cookbook: [Use lists](https://flutter.dev/docs/cookbook/lists/basic-list)
///  * Cookbook: [Implement swipe to dismiss](https://flutter.dev/docs/cookbook/gestures/dismissible)
class ListTile extends StatelessWidget {
  /// Creates a list tile.
  ///
  /// If [isThreeLine] is true, then [overline] or [supportingText] must not be null.
  /// If [isThreeLine] is false, then only one of [overline] and [supportingText] must
  /// be not null.
  ///
  /// Requires one of its ancestors to be a [Material] widget.
  const ListTile({
    super.key,
    this.theme,
    this.layout,
    this.leading,
    this.headline,
    this.overline,
    this.supportingText,
    this.chip,
    this.trailing,
    this.enabled = true,
    this.onTap,
    this.onLongPress,
    this.onFocusChange,
    this.selected = false,
    this.focusNode,
    this.autofocus = false,
  }) : assert(layout == null ||
            layout == ListTileLayout.threeLine ||
            (layout == ListTileLayout.oneLine &&
                overline == null &&
                supportingText == null) ||
            (layout == ListTileLayout.twoLine &&
                (overline == null || supportingText == null)));

  /// ListTileThemeData overrides that only apply to this list tile.
  final ListTileThemeData? theme;

  /// A widget to display before the headline.
  ///
  /// Typically an [Icon] or a [CircleAvatar] widget.
  final ListTileElement? leading;

  /// The primary content of the list tile.
  ///
  /// Typically a [Text] widget.
  ///
  /// This should not wrap. To enforce the single line limit, use
  /// [Text.maxLines].
  final Widget? headline;

  /// Additional content displayed above the headline.
  ///
  /// Typically a [Text] widget. This should not wrap.
  ///
  /// If [isThreeLine] is false, at most one of [ListTile.overline] and
  /// [ListTile.overline] can be present.
  ///
  /// The subtitle's default [TextStyle] depends on [TextTheme.labelSmall] except
  /// [TextStyle.color]. The [TextStyle.color] depends on the value of [enabled]
  /// and [selected].
  ///
  /// When [enabled] is false, the text color is set to [ThemeData.disabledColor].
  ///
  /// When [selected] is false, the text color is set to [ListTileThemeData.overlineTextColor].
  final Widget? overline;

  /// Additional content displayed below the headline.
  ///
  /// Typically a [Text] widget.
  ///
  /// If [isThreeLine] is false, this should not wrap.
  ///
  /// If [isThreeLine] is false, at most one of [ListTile.overline] and
  /// [ListTile.overline] can be present.
  ///
  /// The subtitle's default [TextStyle] depends on [TextTheme.bodyMedium] except
  /// [TextStyle.color]. The [TextStyle.color] depends on the value of [enabled]
  /// and [selected].
  ///
  /// When [enabled] is false, the text color is set to [ThemeData.disabledColor].
  ///
  /// When [selected] is false, the text color is set to [ListTileM3Theme.expandedHeadlineColor]
  /// if it's not null and to [TextTheme.bodySmall]'s color if [ListTileM3Theme.expandedHeadlineColor]
  /// is null.
  final Widget? supportingText;

  /// An optional widget to display between the headline and the trailing.
  /// This widget will reduce the available space for the headline. It will
  /// be placed with its start at the end of the headline, overline or
  /// supporting text.
  ///
  /// This should have a constrained width.
  ///
  ///
  final Widget? chip;

  /// A widget to display after the headline.
  ///
  /// Typically an [Icon] widget.
  ///
  /// To show right-aligned metadata (assuming left-to-right reading order;
  /// left-aligned for right-to-left reading order), consider using a [Row] with
  /// [CrossAxisAlignment.baseline] alignment whose first item is [Expanded] and
  /// whose second child is the metadata text, instead of using the [trailing]
  /// property.
  final ListTileElement? trailing;

  /// The line layout of the [ListTile]. When no layout is passed in during
  /// construction the value will be calculated base on the presence
  /// or absence of [overline] and [supportingText], and the length of
  /// [supportingText].
  final ListTileLayout? layout;

  /// Whether this list tile is interactive.
  ///
  /// If false, this list tile is styled with the disabled color from the
  /// current [Theme] and the [onTap] and [onLongPress] callbacks are
  /// inoperative.
  final bool enabled;

  /// Called when the user taps this list tile.
  ///
  /// Inoperative if [enabled] is false.
  final GestureTapCallback? onTap;

  /// Called when the user long-presses on this list tile.
  ///
  /// Inoperative if [enabled] is false.
  final GestureLongPressCallback? onLongPress;

  /// {@macro flutter.material.inkwell.onFocusChange}
  final ValueChanged<bool>? onFocusChange;

  /// If this tile is also [enabled] then icons and text are rendered with the same color.
  ///
  /// By default the selected color is the theme's primary color. The selected color
  /// can be overridden with a [ListTileM3Theme].
  ///
  /// {@tool dartpad}
  /// Here is an example of using a [StatefulWidget] to keep track of the
  /// selected index, and using that to set the [selected] property on the
  /// corresponding [ListTile].
  ///
  /// ** See code in examples/api/lib/material/list_tile/list_tile.selected.0.dart **
  /// {@end-tool}
  final bool selected;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    final ListTileThemeData tileTheme = ListTileTheme.resolve(context, theme);

    Color resolveColor(Color enabledColor, Color? selectedColor) {
      final baseColor =
          selected && selectedColor != null ? selectedColor : enabledColor;
      return enabled
          ? baseColor
          : baseColor.withOpacity(tileTheme.stateTheme.disabledOpacity);
    }

    Widget? leadingElement;
    if (leading != null) {
      final leadingColor = resolveColor(
        tileTheme.leadingColor,
        tileTheme.selectedLeadingColor,
      );

      leadingElement = IconTheme.merge(
        data: IconThemeData(color: leadingColor),
        child: IconButtonTheme(
          data: IconButtonThemeData(
            style: ButtonStyle(
                labelColor: MaterialStateProperty.all(leadingColor)),
          ),
          child: AnimatedDefaultTextStyle(
            style: tileTheme.leadingTextStyle.copyWith(color: leadingColor),
            duration: kThemeChangeDuration,
            child: leading!,
          ),
        ),
      );
    }

    Widget? overlineText;
    if (overline != null) {
      final overlineColor = resolveColor(
        tileTheme.overlineColor,
        tileTheme.selectedOverlineColor,
      );
      overlineText = IconTheme.merge(
        data: IconThemeData(color: overlineColor),
        child: IconButtonTheme(
          data: IconButtonThemeData(
            style: ButtonStyle(
                labelColor: MaterialStateProperty.all(overlineColor)),
          ),
          child: AnimatedDefaultTextStyle(
            style: tileTheme.overlineTextStyle.copyWith(
              color: overlineColor,
            ),
            duration: kThemeChangeDuration,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            child: overline!,
          ),
        ),
      );
    }

    final Color headlineColor = resolveColor(
      tileTheme.headlineColor,
      tileTheme.selectedHeadlineColor,
    );
    final Widget headlineText = IconTheme.merge(
      data: IconThemeData(color: headlineColor),
      child: IconButtonTheme(
        data: IconButtonThemeData(
          style:
              ButtonStyle(labelColor: MaterialStateProperty.all(headlineColor)),
        ),
        child: AnimatedDefaultTextStyle(
          style: tileTheme.headlineTextStyle.copyWith(
            color: headlineColor,
          ),
          duration: kThemeChangeDuration,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          child: headline ?? const SizedBox(),
        ),
      ),
    );

    Widget? supportingTextWidget;
    if (supportingText != null) {
      final supportingTextColor = resolveColor(
        tileTheme.supportingTextColor,
        tileTheme.selectedSupportingTextColor,
      );
      final maxSupportingTextLines =
          overline != null || layout == ListTileLayout.twoLine ? 1 : 2;

      supportingTextWidget = IconTheme.merge(
        data: IconThemeData(color: supportingTextColor),
        child: IconButtonTheme(
          data: IconButtonThemeData(
            style: ButtonStyle(
                labelColor: MaterialStateProperty.all(supportingTextColor)),
          ),
          child: AnimatedDefaultTextStyle(
            style: tileTheme.supportingTextTextStyle.copyWith(
              color: supportingTextColor,
            ),
            duration: kThemeChangeDuration,
            maxLines: maxSupportingTextLines,
            overflow: TextOverflow.ellipsis,
            child: supportingText!,
          ),
        ),
      );
    }

    Widget? trailingElement;
    if (trailing != null) {
      final trailingColor = resolveColor(
        tileTheme.trailingColor,
        tileTheme.selectedTrailingColor,
      );
      trailingElement = IconTheme.merge(
        data: IconThemeData(color: trailingColor),
        child: IconButtonTheme(
          data: IconButtonThemeData(
            style: ButtonStyle(
                labelColor: MaterialStateProperty.all(trailingColor)),
          ),
          child: AnimatedDefaultTextStyle(
            style: tileTheme.leadingTextStyle.copyWith(color: trailingColor),
            duration: kThemeChangeDuration,
            child: trailing!,
          ),
        ),
      );
    }

    // Show basic cursor when ListTile isn't enabled or
    // gesture callbacks are null.
    final Set<MaterialState> mouseStates = <MaterialState>{
      if (!enabled || (onTap == null && onLongPress == null))
        MaterialState.disabled,
    };
    final MouseCursor effectiveMouseCursor =
        tileTheme.mouseCursor.resolve(mouseStates);

    return InkWell(
      customBorder: tileTheme.customBorder,
      onTap: enabled ? onTap : null,
      onLongPress: enabled ? onLongPress : null,
      onFocusChange: onFocusChange,
      mouseCursor: effectiveMouseCursor,
      canRequestFocus: enabled,
      focusNode: focusNode,
      overlayColor: tileTheme.stateLayers,
      autofocus: autofocus,
      enableFeedback: tileTheme.enableFeedback,
      child: Semantics(
        selected: selected,
        enabled: enabled,
        child: Ink(
          decoration: ShapeDecoration(
            shape: tileTheme.customBorder,
            color: tileTheme.tileColor,
          ),
          child: _ListTile(
            layout: layout,
            padding: tileTheme.padding,
            internalHorizontalPadding: tileTheme.internalHorizontalPadding,
            tallVerticalPadding: tileTheme.tallVerticalPadding,
            leading: leadingElement,
            headline: headlineText,
            overline: overlineText,
            supportingText: supportingTextWidget,
            chip: chip,
            trailing: trailingElement,
            visualDensity: tileTheme.visualDensity,
            textDirection: Directionality.of(context),
            leadingPaddingCorrection: leading?.paddingCorrection,
            leadingTargetSize: leading?.targetSize,
            trailingPaddingCorrection: trailing?.paddingCorrection,
            trailingTargetSize: trailing?.targetSize,
            maxOverlineHeight: tileTheme.strict
                ? tileTheme.overlineTextStyle.heightInDps
                : double.infinity,
            maxHeadlineHeight: tileTheme.strict
                ? tileTheme.headlineTextStyle.heightInDps
                : double.infinity,
            maxSupportingTextHeight: tileTheme.strict
                ? (overline != null || layout == ListTileLayout.twoLine
                    ? tileTheme.supportingTextTextStyle.heightInDps
                    : tileTheme.supportingTextTextStyle.heightInDps * 2)
                : double.infinity,
            supportingTextSingleLineHeight:
                tileTheme.supportingTextTextStyle.heightInDps,
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Key>('key', key, defaultValue: null));
    properties.add(DiagnosticsProperty<ListTileThemeData>('theme', theme,
        defaultValue: null));
    properties.add(DiagnosticsProperty<ListTileLayout>('layout', layout,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty<Widget?>('leading', leading, defaultValue: null));
    properties.add(
        DiagnosticsProperty<Widget?>('headline', headline, defaultValue: null));
    properties.add(
        DiagnosticsProperty<Widget?>('overline', overline, defaultValue: null));
    properties.add(DiagnosticsProperty<Widget?>(
        'supportingText', supportingText,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty<Widget?>('trailing', trailing, defaultValue: null));
    properties
        .add(DiagnosticsProperty<bool>('enabled', enabled, defaultValue: true));
    properties
        .add(DiagnosticsProperty<Function>('onTap', onTap, defaultValue: null));
    properties.add(DiagnosticsProperty<Function>('onLongPress', onLongPress,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Function>('onFocusChange', onFocusChange,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty<bool>('selected', selected, defaultValue: false));
    properties.add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty<bool>('autofocus', autofocus, defaultValue: false));
  }

  /// Add a one pixel border in between each tile. If color isn't specified the
  /// [ThemeData.dividerColor] of the context's [Theme] is used.
  ///
  /// See also:
  ///
  ///  * [Divider], which you can use to obtain this effect manually.
  static Iterable<Widget> divideTiles(
      {BuildContext? context, required Iterable<Widget> tiles, Color? color}) {
    assert(color != null || context != null);
    tiles = tiles.toList();

    if (tiles.isEmpty || tiles.length == 1) {
      return tiles;
    }

    Widget wrapTile(Widget tile) {
      return DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          border: Border(
            bottom: Divider.createBorderSide(context, color: color),
          ),
        ),
        child: tile,
      );
    }

    return <Widget>[
      ...tiles.take(tiles.length - 1).map(wrapTile),
      tiles.last,
    ];
  }
}

// Identifies the children of a _ListTileM3Element.
enum _ListTileSlot {
  leading,
  overline,
  headline,
  supportingText,
  chip,
  trailing,
}

class _ListTile extends RenderObjectWidget
    with SlottedMultiChildRenderObjectWidgetMixin<_ListTileSlot> {
  // extends SlottedMultiChildRenderObjectWidget<_ListTileM3Slot, RenderBox> {
  const _ListTile({
    required this.layout,
    required this.padding,
    required this.tallVerticalPadding,
    required this.internalHorizontalPadding,
    this.leading,
    required this.headline,
    this.overline,
    this.supportingText,
    this.chip,
    this.trailing,
    required this.visualDensity,
    required this.textDirection,
    required this.leadingTargetSize,
    required this.trailingTargetSize,
    required this.leadingPaddingCorrection,
    required this.trailingPaddingCorrection,
    required this.maxOverlineHeight,
    required this.maxHeadlineHeight,
    required this.maxSupportingTextHeight,
    required this.supportingTextSingleLineHeight,
  });

  final ListTileLayout? layout;

  final EdgeInsetsDirectional padding;
  final double tallVerticalPadding;
  final double internalHorizontalPadding;

  final Widget? leading;
  final Widget headline;
  final Widget? overline;
  final Widget? supportingText;
  final Widget? chip;
  final Widget? trailing;
  final VisualDensity visualDensity;
  final TextDirection textDirection;

  final Size? leadingTargetSize;
  final Size? trailingTargetSize;
  final PaddingCorrectionGenerator? leadingPaddingCorrection;
  final PaddingCorrectionGenerator? trailingPaddingCorrection;
  final double maxOverlineHeight;
  final double maxHeadlineHeight;
  final double maxSupportingTextHeight;
  final double supportingTextSingleLineHeight;

  @override
  Iterable<_ListTileSlot> get slots => _ListTileSlot.values;

  @override
  Widget? childForSlot(_ListTileSlot slot) {
    switch (slot) {
      case _ListTileSlot.leading:
        return leading;
      case _ListTileSlot.overline:
        return overline;
      case _ListTileSlot.headline:
        return headline;
      case _ListTileSlot.supportingText:
        return supportingText;
      case _ListTileSlot.chip:
        return chip;
      case _ListTileSlot.trailing:
        return trailing;
    }
  }

  @override
  _RenderListTile createRenderObject(BuildContext context) {
    return _RenderListTile(
      layout: layout,
      padding: padding,
      internalHorizontalPadding: internalHorizontalPadding,
      tallVerticalPadding: tallVerticalPadding,
      visualDensity: visualDensity,
      textDirection: textDirection,
      leadingTargetSize: leadingTargetSize,
      trailingTargetSize: trailingTargetSize,
      leadingPaddingCorrection: leadingPaddingCorrection,
      trailingPaddingCorrection: trailingPaddingCorrection,
      maxOverlineHeight: maxOverlineHeight,
      maxHeadlineHeight: maxHeadlineHeight,
      maxSupportingTextHeight: maxSupportingTextHeight,
      supportingTextSingleLineHeight: supportingTextSingleLineHeight,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderListTile renderObject) {
    renderObject
      ..layoutLines = layout
      ..padding = padding
      ..internalHorizontalPadding = internalHorizontalPadding
      ..tallVerticalPadding = tallVerticalPadding
      ..visualDensity = visualDensity
      ..textDirection = textDirection
      ..leadingTargetSize = leadingTargetSize
      ..trailingTargetSize = trailingTargetSize
      ..leadingPaddingCorrection = leadingPaddingCorrection
      ..trailingPaddingCorrection = trailingPaddingCorrection
      ..maxOverlineHeight = maxOverlineHeight
      ..maxHeadlineHeight = maxHeadlineHeight
      ..maxSupportingTextHeight = maxSupportingTextHeight;
  }
}

class _RenderListTile extends RenderBox
    with SlottedContainerRenderObjectMixin<_ListTileSlot> {
  // with SlottedContainerRenderObjectMixin<_ListTileM3Slot, RenderBox> {
  _RenderListTile({
    required ListTileLayout? layout,
    required EdgeInsetsDirectional padding,
    required double tallVerticalPadding,
    required double internalHorizontalPadding,
    required VisualDensity visualDensity,
    required TextDirection textDirection,
    Size? leadingTargetSize,
    Size? trailingTargetSize,
    PaddingCorrectionGenerator? leadingPaddingCorrection,
    PaddingCorrectionGenerator? trailingPaddingCorrection,
    required double maxOverlineHeight,
    required double maxHeadlineHeight,
    required double maxSupportingTextHeight,
    required double supportingTextSingleLineHeight,
  })  : _layout = layout,
        _padding = padding,
        _tallVerticalPadding = tallVerticalPadding,
        _internalHorizontalPadding = internalHorizontalPadding,
        _visualDensity = visualDensity,
        _textDirection = textDirection,
        _leadingTargetSize = leadingTargetSize,
        _trailingTargetSize = trailingTargetSize,
        _leadingPaddingCorrection = leadingPaddingCorrection,
        _trailingPaddingCorrection = trailingPaddingCorrection,
        _maxOverlineHeight = maxOverlineHeight,
        _maxHeadlineHeight = maxHeadlineHeight,
        _maxSupportingTextHeight = maxSupportingTextHeight,
        _supportingTextSingleLineHeight = supportingTextSingleLineHeight;

  RenderBox? get leading => childForSlot(_ListTileSlot.leading);

  RenderBox? get headline => childForSlot(_ListTileSlot.headline);

  RenderBox? get overline => childForSlot(_ListTileSlot.overline);

  RenderBox? get supportingText => childForSlot(_ListTileSlot.supportingText);

  RenderBox? get chip => childForSlot(_ListTileSlot.chip);

  RenderBox? get trailing => childForSlot(_ListTileSlot.trailing);

  // The returned list is ordered for hit testing.
  @override
  Iterable<RenderBox> get children {
    return <RenderBox>[
      if (leading != null) leading!,
      if (headline != null) headline!,
      if (overline != null) overline!,
      if (supportingText != null) supportingText!,
      if (chip != null) chip!,
      if (trailing != null) trailing!,
    ];
  }

  VisualDensity get visualDensity => _visualDensity;
  VisualDensity _visualDensity;

  set visualDensity(VisualDensity value) {
    if (_visualDensity != value) {
      _visualDensity = value;
      markNeedsLayout();
    }
  }

  static const double _videoTilePaddingStart = 0.0;

  EdgeInsetsDirectional get padding => _padding;
  EdgeInsetsDirectional _padding;

  set padding(EdgeInsetsDirectional value) {
    if (_padding != value) {
      _padding = value;
      markNeedsLayout();
    }
  }

  double get tallVerticalPadding => _tallVerticalPadding;
  double _tallVerticalPadding;

  set tallVerticalPadding(double value) {
    if (_tallVerticalPadding != value) {
      _tallVerticalPadding = value;
      markNeedsLayout();
    }
  }

  double get internalHorizontalPadding => _internalHorizontalPadding;
  double _internalHorizontalPadding;

  set internalHorizontalPadding(double value) {
    if (_internalHorizontalPadding != value) {
      _internalHorizontalPadding = value;
      markNeedsLayout();
    }
  }

  bool get hasOverline => overline != null;

  bool get hasSupportingText => supportingText != null;

  bool get hasChip => chip != null;

  bool get hasLeading => leading != null;

  bool get hasTrailing => trailing != null;

  ListTileLayout? get layoutLines => _layout;
  ListTileLayout? _layout;

  set layoutLines(ListTileLayout? value) {
    if (_layout == value) {
      return;
    }
    _layout = value;
    markNeedsLayout();
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;

  set textDirection(TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    markNeedsLayout();
  }

  Size? get leadingTargetSize => _leadingTargetSize;
  Size? _leadingTargetSize;

  set leadingTargetSize(Size? value) {
    if (_leadingTargetSize == value) {
      return;
    }
    _leadingTargetSize = value;
    markNeedsLayout();
  }

  PaddingCorrectionGenerator get leadingPaddingCorrection =>
      _leadingPaddingCorrection ?? PaddingCorrectionGenerators.noCorrection;
  PaddingCorrectionGenerator? _leadingPaddingCorrection;

  set leadingPaddingCorrection(PaddingCorrectionGenerator? value) {
    if (_leadingPaddingCorrection == value) {
      return;
    }
    _leadingPaddingCorrection = value;
    markNeedsLayout();
  }

  Size? get trailingTargetSize => _trailingTargetSize;
  Size? _trailingTargetSize;

  set trailingTargetSize(Size? value) {
    if (_trailingTargetSize == value) {
      return;
    }
    _trailingTargetSize = value;
    markNeedsLayout();
  }

  PaddingCorrectionGenerator get trailingPaddingCorrection =>
      _trailingPaddingCorrection ?? PaddingCorrectionGenerators.noCorrection;
  PaddingCorrectionGenerator? _trailingPaddingCorrection;

  set trailingPaddingCorrection(PaddingCorrectionGenerator? value) {
    if (_trailingPaddingCorrection == value) {
      return;
    }
    _trailingPaddingCorrection = value;
    markNeedsLayout();
  }

  double get maxOverlineHeight => _maxOverlineHeight;
  double _maxOverlineHeight;

  set maxOverlineHeight(double value) {
    if (_maxOverlineHeight != value) {
      _maxOverlineHeight = value;
      markNeedsLayout();
    }
  }

  double get maxHeadlineHeight => _maxHeadlineHeight;
  double _maxHeadlineHeight;

  set maxHeadlineHeight(double value) {
    if (_maxHeadlineHeight != value) {
      _maxHeadlineHeight = value;
      markNeedsLayout();
    }
  }

  double get maxSupportingTextHeight => _maxSupportingTextHeight;
  double _maxSupportingTextHeight;

  set maxSupportingTextHeight(double value) {
    if (_maxSupportingTextHeight != value) {
      _maxSupportingTextHeight = value;
      markNeedsLayout();
    }
  }

  double get supportingTextSingleLineHeight => _supportingTextSingleLineHeight;
  double _supportingTextSingleLineHeight;

  set supportingTextSingleLineHeight(double value) {
    if (_supportingTextSingleLineHeight != value) {
      _supportingTextSingleLineHeight = value;
      markNeedsLayout();
    }
  }

  double get maxContentHeight => math.min(
        64.0, // 88 - 12 - 12
        (overline != null ? maxOverlineHeight : 0) +
            (headline != null ? maxHeadlineHeight : 0) +
            (supportingText != null ? maxSupportingTextHeight : 0),
      );

  @override
  bool get sizedByParent => false;

  static double _minHeight(RenderBox? box, double width) {
    return box == null ? 0.0 : box.getMinIntrinsicHeight(width);
  }

  static double _minWidth(RenderBox? box, double height) {
    return box == null ? 0.0 : box.getMinIntrinsicWidth(height);
  }

  static double _maxWidth(RenderBox? box, double height) {
    return box == null ? 0.0 : box.getMaxIntrinsicWidth(height);
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final double startPadding = _startPadding(height);
    final double leadingWidth = _minWidth(leading, height);
    final double leadingPadding = _effectiveInternalHorizontalPadding;
    final double leadingPaddingCorrectionX = math.min(
          leadingPaddingCorrection(Size(leadingWidth, height)).start,
          startPadding,
        ) +
        math.min(
          leadingPaddingCorrection(Size(leadingWidth, height)).end,
          leadingPadding,
        );
    final double textWidth = math.max(
      _minWidth(overline, height),
      math.max(
        _minWidth(headline, height),
        _minWidth(supportingText, height),
      ),
    );
    final double chipWidth = _minWidth(chip, height);
    final double chipPadding = _effectiveChipHorizontalPadding;
    final double trailingPadding = _effectiveInternalHorizontalPadding;
    final double trailingWidth = _minWidth(leading, height);
    final double endPadding = _padding.end;
    final double trailingPaddingCorrectionX = math.min(
          trailingPaddingCorrection(Size(leadingWidth, height)).start,
          trailingPadding,
        ) +
        math.min(
          trailingPaddingCorrection(Size(leadingWidth, height)).end,
          endPadding,
        );

    return startPadding +
        leadingWidth +
        leadingPadding +
        textWidth +
        chipPadding +
        chipWidth +
        trailingPadding +
        trailingWidth +
        endPadding -
        leadingPaddingCorrectionX -
        trailingPaddingCorrectionX;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final double startPadding = _startPadding(height);
    final double leadingWidth = _maxWidth(leading, height);
    final double leadingPadding = _effectiveInternalHorizontalPadding;
    final double leadingPaddingCorrectionX = math.min(
          leadingPaddingCorrection(Size(leadingWidth, height)).start,
          startPadding,
        ) +
        math.min(
          leadingPaddingCorrection(Size(leadingWidth, height)).end,
          leadingPadding,
        );
    final double textWidth = math.max(
      _maxWidth(overline, height),
      math.max(
        _maxWidth(headline, height),
        _maxWidth(supportingText, height),
      ),
    );
    final double chipWidth = _maxWidth(chip, height);
    final double chipPadding = _effectiveChipHorizontalPadding;
    final double trailingPadding = _effectiveInternalHorizontalPadding;
    final double trailingWidth = _maxWidth(leading, height);
    final double endPadding = padding.end;
    final double trailingPaddingCorrectionX = math.min(
          trailingPaddingCorrection(Size(leadingWidth, height)).start,
          trailingPadding,
        ) +
        math.min(
          trailingPaddingCorrection(Size(leadingWidth, height)).end,
          endPadding,
        );

    return startPadding +
        leadingWidth +
        leadingPadding +
        textWidth +
        chipPadding +
        chipWidth +
        trailingPadding +
        trailingWidth +
        endPadding -
        leadingPaddingCorrectionX -
        trailingPaddingCorrectionX;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final double maxElementHeight = math.max(
      _minHeight(leading, width),
      math.max(
        _minHeight(overline, width) +
            _minHeight(headline, width) +
            _minHeight(supportingText, width),
        math.max(
          _minHeight(chip, width),
          _minHeight(trailing, width),
        ),
      ),
    );
    return _tileHeight(math.min(
      maxElementHeight,
      maxContentHeight, // clamp if strict
    ));
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return computeMinIntrinsicHeight(width);
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    assert(headline != null);
    final BoxParentData parentData = headline!.parentData! as BoxParentData;
    return parentData.offset.dy +
        headline!.getDistanceToActualBaseline(baseline)!;
  }

  static Size _layoutBox(RenderBox? box, BoxConstraints constraints) {
    if (box == null) {
      return Size.zero;
    }
    box.layout(constraints, parentUsesSize: true);
    return box.size;
  }

  static void _positionBox(RenderBox box, Offset offset) {
    final BoxParentData parentData = box.parentData! as BoxParentData;
    parentData.offset = offset;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    // TODO
    assert(debugCannotComputeDryLayout(
      reason:
          'Layout requires baseline metrics, which are only available after a full layout.',
    ));
    return Size.zero;
  }

  double get _effectiveChipHorizontalPadding =>
      _internalHorizontalPadding + visualDensity.horizontal * 2.0;

  double get _effectiveInternalHorizontalPadding =>
      _internalHorizontalPadding + visualDensity.horizontal * 2.0;

  static const double _avatarHeight = 40.0;
  static const double _imageHeight = 56.0;
  static const double _videoHeight = 64.0;

  // static const double _shortTileHeight = 56.0;
  // static const double _medTileHeight = 72.0;
  static const double _tallTileHeight = 88.0;

  static const double _maxWidthBeforeRemovingStartPadding = 102.0;

  double _tileHeight(double maxElementHeight) {
    if ((_layout == null || _layout == ListTileLayout.oneLine) &&
        maxElementHeight <= _avatarHeight &&
        overline == null &&
        supportingText == null) {
      return _avatarHeight + 2.0 * _padding.top;
    } else if (_layout != ListTileLayout.threeLine &&
        maxElementHeight <= _imageHeight) {
      // one- or two-line
      return _imageHeight + 2.0 * _padding.top;
    } else if (maxElementHeight <= _videoHeight) {
      return _videoHeight + 2.0 * _tallVerticalPadding;
    }
    return maxElementHeight + 2.0 * _tallVerticalPadding;
  }

  double _verticalPadding(double tileHeight) {
    if (tileHeight >= _tallTileHeight) {
      return _tallVerticalPadding;
    }
    return _padding.top;
  }

  double _startPadding(double leadingElementWidth) {
    if (leadingElementWidth > _maxWidthBeforeRemovingStartPadding) {
      return _videoTilePaddingStart;
    }
    return _padding.start;
  }

  double _endPadding(double leadingElementWidth) {
    if (leadingElementWidth > _maxWidthBeforeRemovingStartPadding) {
      return _videoTilePaddingStart;
    }
    return _padding.end;
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    final BoxConstraints looseConstraints = constraints.loosen();

    final double tileWidth = looseConstraints.maxWidth;

    // infinite if not strict
    final Size maxContentHeightConstraint = Size.fromHeight(maxContentHeight);

    final BoxConstraints maxLeadingHeightConstraint = BoxConstraints.loose(
      _leadingTargetSize ?? maxContentHeightConstraint,
    );
    final BoxConstraints maxTrailingHeightConstraint = BoxConstraints.loose(
      _leadingTargetSize ?? maxContentHeightConstraint,
    );
    final BoxConstraints leadingConstraints =
        looseConstraints.enforce(maxLeadingHeightConstraint);
    final BoxConstraints trailingConstraints =
        looseConstraints.enforce(maxTrailingHeightConstraint);

    final Size leadingSize = _layoutBox(leading, leadingConstraints);
    final Size trailingSize = _layoutBox(trailing, trailingConstraints);

    assert(
      tileWidth != leadingSize.width || tileWidth == 0.0,
      'Leading widget consumes entire tile width. Please use a sized widget, '
      'or consider replacing ListTileM3 with a custom widget '
      '(see https://api.flutter.dev/flutter/material/ListTileM3-class.html#material.ListTileM3.4)',
    );
    assert(
      tileWidth != trailingSize.width || tileWidth == 0.0,
      'Trailing widget consumes entire tile width. Please use a sized widget, '
      'or consider replacing ListTileM3 with a custom widget '
      '(see https://api.flutter.dev/flutter/material/ListTileM3-class.html#material.ListTileM3.4)',
    );

    final double startPadding = _startPadding(leadingSize.width);
    final double endPadding = _endPadding(trailingSize.width);

    final PaddingCorrection leadingPaddingCorrection_ =
        leadingPaddingCorrection(leadingSize);
    final double leadingInternalPadding = _effectiveInternalHorizontalPadding;
    final double leadingStart = math.max(
      startPadding - leadingPaddingCorrection_.start,
      0.0,
    );
    final double leadingEnd = leadingStart + leadingSize.width;
    final double effectiveLeadingEnd = hasLeading
        ? math.max(
            leadingEnd -
                math.min(leadingPaddingCorrection_.end, leadingInternalPadding),
            leadingStart,
          )
        : 0.0;

    final PaddingCorrection trailingPaddingCorrection_ =
        trailingPaddingCorrection(trailingSize);
    final double trailingInternalPadding = _effectiveInternalHorizontalPadding;
    final double trailingEnd = hasTrailing
        ? tileWidth - math.max(endPadding - trailingPaddingCorrection_.end, 0.0)
        : tileWidth - endPadding;
    final double trailingStart = trailingEnd - trailingSize.width;

    final Size chipSize;
    if (hasChip) {
      final double chipAvailableSpaceStart = hasLeading
          ? effectiveLeadingEnd + leadingInternalPadding
          : startPadding;
      final double chipAvailableSpaceEnd = hasTrailing
          ? trailingStart -
              math.max(
                  trailingInternalPadding - trailingPaddingCorrection_.start,
                  0.0)
          : tileWidth - endPadding;
      final BoxConstraints chipConstraints = looseConstraints.copyWith(
        maxWidth: chipAvailableSpaceEnd - chipAvailableSpaceStart,
      );
      chipSize = _layoutBox(chip, chipConstraints);
    } else {
      chipSize = Size.zero;
    }

    final double chipWidthAllocation =
        hasChip ? chipSize.width + _effectiveChipHorizontalPadding : 0.0;

    final double textStart = hasLeading
        ? effectiveLeadingEnd + leadingInternalPadding
        : startPadding;
    final double textMaxEnd = hasTrailing
        ? trailingStart -
            math.max(
              trailingInternalPadding - trailingPaddingCorrection_.start,
              0.0,
            ) -
            chipWidthAllocation
        : tileWidth - endPadding - chipWidthAllocation;

    final BoxConstraints overlineConstraints = looseConstraints.copyWith(
      maxWidth: textMaxEnd - textStart,
      maxHeight: maxOverlineHeight,
    );
    final BoxConstraints headlineConstraints = looseConstraints.copyWith(
      maxWidth: textMaxEnd - textStart,
      maxHeight: maxHeadlineHeight,
    );
    final BoxConstraints supportingTextConstraints = looseConstraints.copyWith(
      maxWidth: textMaxEnd - textStart,
      maxHeight: maxSupportingTextHeight,
    );
    final Size overlineSize = _layoutBox(overline, overlineConstraints);
    final Size headlineSize = _layoutBox(headline, headlineConstraints);
    final Size supportingTextSize =
        _layoutBox(supportingText, supportingTextConstraints);

    final double textEnd = textStart +
        math.max(
          overlineSize.width,
          math.max(
            headlineSize.width,
            supportingTextSize.width,
          ),
        );

    final double chipStart = textEnd + _effectiveChipHorizontalPadding;
    final double chipEnd = chipStart + chipSize.width;

    final double totalLabelHeight =
        overlineSize.height + headlineSize.height + supportingTextSize.height;

    final double tileHeight = _tileHeight(
      math.max(
        totalLabelHeight,
        math.max(
          chipSize.height,
          math.max(
            leadingSize.height,
            trailingSize.height,
          ),
        ),
      ),
    );

    final double verticalPadding = _verticalPadding(tileHeight);

    // Text vertical alignment
    final double leadingY;
    final double? overlineY;
    final double headlineY;
    final double? supportingTextY;
    final double? chipY;
    final double trailingY;
    // Material 3 treats the text elements as a single block with
    // 0 padding between individual text blocks.
    if (_layout == ListTileLayout.threeLine ||
        tileHeight > _tallTileHeight ||
        (overline != null && supportingText != null) ||
        supportingTextSize.height > supportingTextSingleLineHeight) {
      // Top align
      // There is an inconsistency in the spec. In the written component
      // it is tileHeight >= 88, but this conflicts with the one and two line
      // video layouts which are centred.
      overlineY = verticalPadding;
      headlineY = overlineY + overlineSize.height;
      supportingTextY = headlineY + headlineSize.height;
      leadingY = math.max(verticalPadding - leadingPaddingCorrection_.top, 0.0);
      chipY = verticalPadding;
      trailingY =
          math.max(verticalPadding - trailingPaddingCorrection_.top, 0.0);
    } else {
      // Center
      overlineY = (tileHeight - totalLabelHeight) / 2.0;
      headlineY = overlineY + overlineSize.height;
      supportingTextY = headlineY + headlineSize.height;
      leadingY = (tileHeight -
              leadingSize.height +
              leadingPaddingCorrection_.offsetY) /
          2.0;
      chipY = (tileHeight - chipSize.height) / 2.0;
      trailingY = (tileHeight -
              trailingSize.height +
              trailingPaddingCorrection_.offsetY) /
          2.0;
    }

    // Widget positioning
    switch (textDirection) {
      case TextDirection.rtl:
        {
          if (hasLeading) {
            _positionBox(leading!, Offset(tileWidth - leadingEnd, leadingY));
          }
          if (hasOverline) {
            _positionBox(overline!, Offset(tileWidth - textEnd, overlineY));
          }
          _positionBox(headline!, Offset(tileWidth - textEnd, headlineY));
          if (hasSupportingText) {
            _positionBox(
                supportingText!, Offset(tileWidth - textEnd, supportingTextY));
          }
          if (hasChip) {
            _positionBox(chip!, Offset(tileWidth - chipEnd, chipY));
          }
          if (hasTrailing) {
            _positionBox(trailing!, Offset(tileWidth - trailingEnd, trailingY));
          }
          break;
        }
      case TextDirection.ltr:
        {
          if (hasLeading) {
            _positionBox(leading!, Offset(leadingStart, leadingY));
          }
          if (hasOverline) {
            _positionBox(overline!, Offset(textStart, overlineY));
          }
          _positionBox(headline!, Offset(textStart, headlineY));
          if (hasSupportingText) {
            _positionBox(supportingText!, Offset(textStart, supportingTextY));
          }
          if (hasChip) {
            _positionBox(chip!, Offset(chipStart, chipY));
          }
          if (hasTrailing) {
            _positionBox(trailing!, Offset(trailingStart, trailingY));
          }
          break;
        }
    }

    size = constraints.constrain(Size(tileWidth, tileHeight));
    assert(size.width == constraints.constrainWidth(tileWidth));
    assert(size.height == constraints.constrainHeight(tileHeight));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    void doPaint(RenderBox? child) {
      if (child != null) {
        final BoxParentData parentData = child.parentData! as BoxParentData;
        context.paintChild(child, parentData.offset + offset);
      }
    }

    doPaint(leading);
    doPaint(overline);
    doPaint(headline);
    doPaint(supportingText);
    doPaint(chip);
    doPaint(trailing);
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (final RenderBox child in children) {
      final BoxParentData parentData = child.parentData! as BoxParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: parentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - parentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );
      if (isHit) {
        return true;
      }
    }
    return false;
  }
}

// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'color_scheme.dart';
import 'colors.dart';
import 'list_tile.dart';
import 'material_state.dart';
import 'state_theme.dart';
import 'text_theme.dart';
import 'theme.dart';
import 'theme_data.dart';

// Examples can assume:
// late BuildContext context;

/// Used with [ListTileTheme] to define default property values for
/// descendant [ListTile] widgets, as well as classes that build
/// [ListTile]s, like [CheckboxListTile], [RadioListTile], and
/// [SwitchListTile].
///
/// Descendant widgets obtain the current [ListTileThemeData] object
/// using `ListTileTheme.of(context)`. Instances of
/// [ListTileThemeData] can be customized with
/// [ListTileThemeData.copyWith].
///
/// A [ListTileThemeData] is often specified as part of the
/// overall [Theme] with [ThemeData.listTileTheme].
///
/// All [ListTileThemeData] properties are `null` by default.
/// When a theme property is null, the [ListTile] will provide its own
/// default based on the overall [Theme]'s textTheme and
/// colorScheme. See the individual [ListTile] properties for details.
///
/// The [Drawer] widget specifies a list tile theme for its children that
/// defines [style] to be [ListTileStyle.drawer].
///
/// See also:
///
///  * [ThemeData], which describes the overall theme information for the
///    application.
@immutable
class ListTileThemeData with Diagnosticable {
  /// Creates a [ListTileThemeData].
  const ListTileThemeData({
    ShapeBorder? customBorder,
    bool? strict,
    Color? tileColor,
    Color? selectedTileColor,
    StateThemeData? stateTheme,
    StateLayerColors? stateLayers,
    Color? selectedLeadingColor,
    Color? selectedOverlineColor,
    Color? selectedHeadlineColor,
    Color? selectedSupportingTextColor,
    Color? selectedTrailingColor,
    Color? leadingColor,
    Color? overlineColor,
    Color? headlineColor,
    Color? supportingTextColor,
    Color? trailingColor,
    TextStyle? leadingTextStyle,
    TextStyle? overlineTextStyle,
    TextStyle? headlineTextStyle,
    TextStyle? supportingTextTextStyle,
    TextStyle? trailingTextStyle,
    EdgeInsetsDirectional? padding,
    double? tallVerticalPadding,
    double? internalHorizontalPadding,
    bool? enableFeedback,
    MaterialStateProperty<MouseCursor>? mouseCursor,
    VisualDensity? visualDensity,
  })  : _customBorder = customBorder,
        _strict = strict,
        _tileColor = tileColor,
        _selectedTileColor = selectedTileColor,
        _stateTheme = stateTheme,
        _stateLayers = stateLayers,
        _selectedLeadingColor = selectedLeadingColor,
        _selectedOverlineColor = selectedOverlineColor,
        _selectedHeadlineColor = selectedHeadlineColor,
        _selectedSupportingTextColor = selectedSupportingTextColor,
        _selectedTrailingColor = selectedTrailingColor,
        _leadingColor = leadingColor,
        _overlineColor = overlineColor,
        _headlineColor = headlineColor,
        _supportingTextColor = supportingTextColor,
        _trailingColor = trailingColor,
        _leadingTextStyle = leadingTextStyle,
        _overlineTextStyle = overlineTextStyle,
        _headlineTextStyle = headlineTextStyle,
        _supportingTextTextStyle = supportingTextTextStyle,
        _trailingTextStyle = trailingTextStyle,
        _padding = padding,
        _tallVerticalPadding = tallVerticalPadding,
        _internalHorizontalPadding = internalHorizontalPadding,
        _enableFeedback = enableFeedback,
        _mouseCursor = mouseCursor,
        _visualDensity = visualDensity;

  ListTileThemeData._clone(ListTileThemeData other)
      : _customBorder = other._customBorder,
        _strict = other._strict,
        _tileColor = other._tileColor,
        _selectedTileColor = other._selectedTileColor,
        _stateTheme = other._stateTheme,
        _stateLayers = other._stateLayers,
        _selectedLeadingColor = other._selectedLeadingColor,
        _selectedOverlineColor = other._selectedOverlineColor,
        _selectedHeadlineColor = other._selectedHeadlineColor,
        _selectedSupportingTextColor = other._selectedSupportingTextColor,
        _selectedTrailingColor = other._selectedTrailingColor,
        _leadingColor = other._leadingColor,
        _overlineColor = other._overlineColor,
        _headlineColor = other._headlineColor,
        _supportingTextColor = other._supportingTextColor,
        _trailingColor = other._trailingColor,
        _leadingTextStyle = other._leadingTextStyle,
        _overlineTextStyle = other._overlineTextStyle,
        _headlineTextStyle = other._headlineTextStyle,
        _supportingTextTextStyle = other._supportingTextTextStyle,
        _trailingTextStyle = other._trailingTextStyle,
        _padding = other._padding,
        _tallVerticalPadding = other._tallVerticalPadding,
        _internalHorizontalPadding = other._internalHorizontalPadding,
        _enableFeedback = other._enableFeedback,
        _mouseCursor = other._mouseCursor,
        _visualDensity = other._visualDensity;

  /// Copy this ListTileThemeData with any default values that
  /// require a [BuildContext] set, such as colors and text themes.
  ListTileThemeData withContext(BuildContext context) =>
      _LateResolvingListTileThemeData(this, context);

  /// Defines the tile's [InkWell.customBorder] and [Ink.decoration] border
  /// shape.
  ///
  /// The default shape is an empty [Border].
  ///
  /// See also:
  ///
  /// * [ListTileTheme.of], which returns the nearest [ListTileTheme]'s
  ///   [ListTileThemeData].
  ShapeBorder get customBorder => _customBorder ?? const Border();
  final ShapeBorder? _customBorder;

  /// Defines the tiles response to multi-line text and over sized
  /// leading a trailing elements based on the value of [ListTile.layout].
  ///
  /// If true, [ListTile.overline] and [ListTile.headline] will be limited to
  /// one line. When [ListTile.layout] is [ListTileLayout.twoLine] or
  /// [ListTile.overline] is not null,
  /// [ListTile.supportingText] will be limited to one line, otherwise it will
  /// be limited to two lines.
  ///
  /// The default value is true;
  bool get strict => _strict ?? true;
  final bool? _strict;

  /// Defines the background color of `ListTile` when [selected] is false.
  ///
  /// This defaults to [Colors.transparent].
  ///
  /// If this property is null and [selected] is false then [ListTileThemeData.tileColor]
  /// is used. If that is also null and [selected] is true, [selectedTileColor] is used.
  /// When that is also null, the [ListTileTheme.selectedTileColor] is used, otherwise
  /// [Colors.transparent] is used.
  Color get tileColor => _tileColor ?? Colors.transparent;
  final Color? _tileColor;

  /// Defines the background color of `ListTile` when [selected] is true.
  ///
  /// This defaults to [Colors.transparent].
  Color get selectedTileColor => _selectedTileColor ?? Colors.transparent;
  final Color? _selectedTileColor;

  /// Defines the state layer opacities applied to this list tile.
  ///
  /// Default value is [ThemeData.stateTheme] .
  StateThemeData get stateTheme => _stateTheme!;
  final StateThemeData? _stateTheme;

  /// Defines the state layers applied to this list tile.
  ///
  /// Default color values are [ColorScheme.onSurface] and the
  /// opacities are from [ListTileThemeData.stateThemeData].
  StateLayerColors get stateLayers => _stateLayers!;
  final StateLayerColors? _stateLayers;

  /// Defines the color used for text and icons in [ListTile.leading]
  /// when the list tile is selected.
  ///
  /// If this property is null then [ListTileThemeData.leadingColor]
  /// is used.
  Color get selectedLeadingColor => _selectedLeadingColor ?? leadingColor;
  final Color? _selectedLeadingColor;

  /// Defines the color used for [ListTile.overline] when the list tile is selected.
  ///
  /// If this property is null then [ListTileThemeData.overlineColor]
  /// is used.
  Color get selectedOverlineColor => _selectedOverlineColor ?? overlineColor;
  final Color? _selectedOverlineColor;

  /// Defines the color used for [ListTile.headline] when the list tile is selected.
  ///
  /// If this property is null then [ListTileThemeData.headlineColor]
  /// is used.
  Color get selectedHeadlineColor => _selectedHeadlineColor ?? headlineColor;
  final Color? _selectedHeadlineColor;

  /// Defines the color used for [ListTile.supportingText] when the list tile is selected.
  ///
  /// If this property is null then [ListTileThemeData.supportingTextColor]
  /// is used.
  Color get selectedSupportingTextColor =>
      _selectedSupportingTextColor ?? supportingTextColor;
  final Color? _selectedSupportingTextColor;

  /// Defines the color used for text and icons in [ListTile.trailing] when the list
  /// tile is selected.
  ///
  /// If this property is null then [ListTileThemeData.trailingColor]
  /// is used.
  Color get selectedTrailingColor => _selectedTrailingColor ?? trailingColor;
  final Color? _selectedTrailingColor;

  /// Defines the color used for text and icons in [ListTile.leading].
  ///
  /// Defaults to [ColorScheme.onSurfaceVariant].
  Color get leadingColor => _leadingColor!;
  final Color? _leadingColor;

  /// Defines the color used for [ListTile.overline].
  ///
  /// Defaults to [ColorScheme.onSurfaceVariant].
  Color get overlineColor => _overlineColor!;
  final Color? _overlineColor;

  /// Defines the color used for [ListTile.headline].
  ///
  /// Defaults to [ColorScheme.onSurface].
  Color get headlineColor => _headlineColor!;
  final Color? _headlineColor;

  /// Defines the color used for [ListTile.supportingText].
  ///
  /// Defaults to [ColorScheme.onSurfaceVariant].
  Color get supportingTextColor => _supportingTextColor!;
  final Color? _supportingTextColor;

  /// Defines the color used for text and icons in [ListTile.trailing].
  ///
  /// Defaults to [ColorScheme.onSurfaceVariant].
  Color get trailingColor => _trailingColor!;
  final Color? _trailingColor;

  /// Defines the color used for text in [ListTile.leading].
  ///
  /// Defaults to [TextTheme.labelSmall].
  TextStyle get leadingTextStyle => _leadingTextStyle!;
  final TextStyle? _leadingTextStyle;

  /// Defines the color used for text in [ListTile.overline].
  ///
  /// Defaults to [TextTheme.labelSmall].
  TextStyle get overlineTextStyle => _overlineTextStyle!;
  final TextStyle? _overlineTextStyle;

  /// Defines the color used for text in [ListTile.headline].
  ///
  /// Defaults to [TextTheme.bodyLarge].
  TextStyle get headlineTextStyle => _headlineTextStyle!;
  final TextStyle? _headlineTextStyle;

  /// Defines the color used for text in [ListTile.supportingText].
  ///
  /// Defaults to [TextTheme.bodyMedium].
  TextStyle get supportingTextTextStyle => _supportingTextTextStyle!;
  final TextStyle? _supportingTextTextStyle;

  /// Defines the color used for text in [ListTile.trailing].
  ///
  /// Defaults to [TextTheme.labelSmall].
  TextStyle get trailingTextStyle => _trailingTextStyle!;
  final TextStyle? _trailingTextStyle;

  /// The tile's internal padding.
  ///
  /// Insets a [ListTile]'s contents: its [leading], [headline], [supportingText],
  /// and [trailing] widgets.
  ///
  /// If null, `EdgeInsetsDirectional.only(start: 16.0, end: 24.0, top: 8.0, bottom: 8.0)` is used.
  EdgeInsetsDirectional get padding =>
      _padding ??
      const EdgeInsetsDirectional.only(
        start: 16.0,
        end: 24.0,
        top: 8.0,
        bottom: 8.0,
      );
  final EdgeInsetsDirectional? _padding;

  /// The vertical padding to use on tall tiles. Tall tiles have are either
  /// where [ListTile.layout] is [ListTileLayout.threeLine] or the
  /// content height is greater than or equal to 64.
  ///
  /// Defaults to 12.0
  double get tallVerticalPadding => _tallVerticalPadding ?? 12.0;
  final double? _tallVerticalPadding;

  /// The horizontal gap between the titles and the leading/trailing widgets.
  ///
  /// THe default value is 16.
  double get internalHorizontalPadding => _internalHorizontalPadding ?? 16.0;
  final double? _internalHorizontalPadding;

  /// {@template flutter.material.ListTile.enableFeedback}
  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  ///
  /// For example, on Android a tap will produce a clicking sound and a
  /// long-press will produce a short vibration, when feedback is enabled.
  ///
  /// When null, the default value is true.
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [Feedback] for providing platform-specific feedback to certain actions.
  bool get enableFeedback => _enableFeedback ?? true;
  final bool? _enableFeedback;

  /// {@template flutter.material.ListTile.mouseCursor}
  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// widget.
  ///
  /// If [mouseCursor] is a [MaterialStateProperty<MouseCursor>],
  /// [MaterialStateProperty.resolve] is used for the following [MaterialState]s:
  ///
  ///  * [MaterialState.selected].
  ///  * [MaterialState.disabled].
  /// {@endtemplate}
  ///
  /// If null, then the value of [ListTileThemeData.mouseCursor] is used. If
  /// that is also null, then [MaterialStateMouseCursor.clickable] is used.
  ///
  /// See also:
  ///
  ///  * [MaterialStateMouseCursor], which can be used to create a [MouseCursor]
  ///    that is also a [MaterialStateProperty<MouseCursor>].
  MaterialStateProperty<MouseCursor> get mouseCursor =>
      _mouseCursor ?? MaterialStateMouseCursor.clickable;
  final MaterialStateProperty<MouseCursor>? _mouseCursor;

  /// Defines how compact the list tile's layout will be.
  ///
  /// {@macro flutter.material.themedata.visualDensity}
  ///
  /// See also:
  ///
  ///  * [ThemeData.visualDensity], which specifies the [visualDensity] for all
  ///    widgets within a [Theme].
  VisualDensity get visualDensity => _visualDensity!;
  final VisualDensity? _visualDensity;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  ListTileThemeData copyWith({
    ShapeBorder? customBorder,
    bool? strict,
    Color? tileColor,
    Color? selectedTileColor,
    StateThemeData? stateTheme,
    StateLayerColors? stateLayers,
    Color? selectedLeadingColor,
    Color? selectedOverlineColor,
    Color? selectedHeadlineColor,
    Color? selectedSupportingTextColor,
    Color? selectedTrailingColor,
    Color? leadingColor,
    Color? overlineColor,
    Color? headlineColor,
    Color? supportingTextColor,
    Color? trailingColor,
    TextStyle? leadingTextStyle,
    TextStyle? overlineTextStyle,
    TextStyle? headlineTextStyle,
    TextStyle? supportingTextTextStyle,
    TextStyle? trailingTextStyle,
    EdgeInsetsDirectional? padding,
    double? tallVerticalPadding,
    double? internalHorizontalPadding,
    bool? enableFeedback,
    MaterialStateProperty<MouseCursor>? mouseCursor,
    VisualDensity? visualDensity,
  }) {
    return ListTileThemeData(
      customBorder: customBorder ?? _customBorder,
      strict: strict ?? _strict,
      tileColor: tileColor ?? _tileColor,
      selectedTileColor: selectedTileColor ?? _selectedTileColor,
      stateTheme: stateTheme ?? _stateTheme,
      stateLayers: stateLayers ?? _stateLayers,
      selectedLeadingColor: selectedLeadingColor ?? _selectedLeadingColor,
      selectedOverlineColor: selectedOverlineColor ?? _selectedOverlineColor,
      selectedHeadlineColor: selectedHeadlineColor ?? _selectedHeadlineColor,
      selectedSupportingTextColor:
          selectedSupportingTextColor ?? _selectedSupportingTextColor,
      selectedTrailingColor: selectedTrailingColor ?? _selectedTrailingColor,
      leadingColor: leadingColor ?? _leadingColor,
      overlineColor: overlineColor ?? _overlineColor,
      headlineColor: headlineColor ?? _headlineColor,
      supportingTextColor: supportingTextColor ?? _supportingTextColor,
      trailingColor: trailingColor ?? _trailingColor,
      leadingTextStyle: leadingTextStyle ?? _leadingTextStyle,
      overlineTextStyle: overlineTextStyle ?? _overlineTextStyle,
      headlineTextStyle: headlineTextStyle ?? _headlineTextStyle,
      supportingTextTextStyle:
          supportingTextTextStyle ?? _supportingTextTextStyle,
      trailingTextStyle: trailingTextStyle ?? _trailingTextStyle,
      padding: padding ?? _padding,
      tallVerticalPadding: tallVerticalPadding ?? _tallVerticalPadding,
      internalHorizontalPadding:
          internalHorizontalPadding ?? _internalHorizontalPadding,
      enableFeedback: enableFeedback ?? _enableFeedback,
      mouseCursor: mouseCursor ?? _mouseCursor,
      visualDensity: visualDensity ?? _visualDensity,
    );
  }

  /// Creates a copy of this object with fields replaced with the
  /// non-null values from [other].
  ListTileThemeData mergeWith(ListTileThemeData? other) {
    return copyWith(
      customBorder: other?._customBorder,
      strict: other?._strict,
      tileColor: other?._tileColor,
      selectedTileColor: other?._selectedTileColor,
      stateTheme: other?._stateTheme,
      stateLayers: other?._stateLayers,
      selectedLeadingColor: other?._selectedLeadingColor,
      selectedOverlineColor: other?._selectedOverlineColor,
      selectedHeadlineColor: other?._selectedHeadlineColor,
      selectedSupportingTextColor: other?._selectedSupportingTextColor,
      selectedTrailingColor: other?._selectedTrailingColor,
      leadingColor: other?._leadingColor,
      overlineColor: other?._overlineColor,
      headlineColor: other?._headlineColor,
      supportingTextColor: other?._supportingTextColor,
      trailingColor: other?._trailingColor,
      leadingTextStyle: other?._leadingTextStyle,
      overlineTextStyle: other?._overlineTextStyle,
      headlineTextStyle: other?._headlineTextStyle,
      supportingTextTextStyle: other?._supportingTextTextStyle,
      trailingTextStyle: other?._trailingTextStyle,
      padding: other?._padding,
      tallVerticalPadding: other?._tallVerticalPadding,
      internalHorizontalPadding: other?._internalHorizontalPadding,
      enableFeedback: other?._enableFeedback,
      mouseCursor: other?._mouseCursor,
      visualDensity: other?._visualDensity,
    );
  }

  /// Linearly interpolate between ListTileThemeData objects.
  static ListTileThemeData? lerp(
      ListTileThemeData? a, ListTileThemeData? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return ListTileThemeData(
      customBorder: ShapeBorder.lerp(a?._customBorder, b?._customBorder, t),
      strict: t < 0.5 ? a?._strict : b?._strict,
      tileColor: Color.lerp(a?._tileColor, b?._tileColor, t),
      selectedTileColor:
          Color.lerp(a?._selectedTileColor, b?._selectedTileColor, t),
      stateTheme: StateThemeData.lerp(a?._stateTheme, b?._stateTheme, t),
      stateLayers: StateLayerColors.lerp(a?._stateLayers, b?._stateLayers, t),
      selectedLeadingColor:
          Color.lerp(a?._selectedLeadingColor, b?._selectedLeadingColor, t),
      selectedOverlineColor:
          Color.lerp(a?._selectedOverlineColor, b?._selectedOverlineColor, t),
      selectedHeadlineColor:
          Color.lerp(a?._selectedHeadlineColor, b?._selectedHeadlineColor, t),
      selectedSupportingTextColor: Color.lerp(
          a?._selectedSupportingTextColor, b?._selectedSupportingTextColor, t),
      selectedTrailingColor:
          Color.lerp(a?._selectedTrailingColor, b?._selectedTrailingColor, t),
      leadingColor: Color.lerp(a?._leadingColor, b?._leadingColor, t),
      overlineColor: Color.lerp(a?._overlineColor, b?._overlineColor, t),
      headlineColor: Color.lerp(a?._headlineColor, b?._headlineColor, t),
      supportingTextColor:
          Color.lerp(a?._supportingTextColor, b?._supportingTextColor, t),
      trailingColor: Color.lerp(a?._trailingColor, b?._trailingColor, t),
      leadingTextStyle:
          TextStyle.lerp(a?._leadingTextStyle, b?._leadingTextStyle, t),
      overlineTextStyle:
          TextStyle.lerp(a?._overlineTextStyle, b?._overlineTextStyle, t),
      headlineTextStyle:
          TextStyle.lerp(a?._headlineTextStyle, b?._headlineTextStyle, t),
      supportingTextTextStyle: TextStyle.lerp(
          a?._supportingTextTextStyle, b?._supportingTextTextStyle, t),
      trailingTextStyle:
          TextStyle.lerp(a?._trailingTextStyle, b?._trailingTextStyle, t),
      padding: EdgeInsetsDirectional.lerp(a?._padding, b?._padding, t),
      tallVerticalPadding:
          lerpDouble(a?._tallVerticalPadding, b?._tallVerticalPadding, t),
      internalHorizontalPadding: lerpDouble(
          a?._internalHorizontalPadding, b?._internalHorizontalPadding, t),
      enableFeedback: t < 0.5 ? a?._enableFeedback : b?._enableFeedback,
      mouseCursor: t < 0.5 ? a?._mouseCursor : b?._mouseCursor,
      visualDensity:
          VisualDensity.lerp(a?._visualDensity, b?._visualDensity, t),
    );
  }

  @override
  int get hashCode => Object.hashAll([
        _customBorder,
        _strict,
        _tileColor,
        _selectedTileColor,
        _stateTheme,
        _stateLayers,
        _selectedLeadingColor,
        _selectedOverlineColor,
        _selectedHeadlineColor,
        _selectedSupportingTextColor,
        _selectedTrailingColor,
        _leadingColor,
        _overlineColor,
        _headlineColor,
        _supportingTextColor,
        _trailingColor,
        _leadingTextStyle,
        _overlineTextStyle,
        _headlineTextStyle,
        _supportingTextTextStyle,
        _trailingTextStyle,
        _padding,
        _tallVerticalPadding,
        _internalHorizontalPadding,
        _enableFeedback,
        _mouseCursor,
        _visualDensity,
      ]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is ListTileThemeData &&
        other._customBorder == _customBorder &&
        other._strict == _strict &&
        other._tileColor == _tileColor &&
        other._selectedTileColor == _selectedTileColor &&
        other._stateTheme == _stateTheme &&
        other._stateLayers == _stateLayers &&
        other._selectedLeadingColor == _selectedLeadingColor &&
        other._selectedOverlineColor == _selectedOverlineColor &&
        other._selectedHeadlineColor == _selectedHeadlineColor &&
        other._selectedSupportingTextColor == _selectedSupportingTextColor &&
        other._selectedTrailingColor == _selectedTrailingColor &&
        other._leadingColor == _leadingColor &&
        other._overlineColor == _overlineColor &&
        other._headlineColor == _headlineColor &&
        other._supportingTextColor == _supportingTextColor &&
        other._trailingColor == _trailingColor &&
        other._leadingTextStyle == _leadingTextStyle &&
        other._overlineTextStyle == _overlineTextStyle &&
        other._headlineTextStyle == _headlineTextStyle &&
        other._supportingTextTextStyle == _supportingTextTextStyle &&
        other._trailingTextStyle == _trailingTextStyle &&
        other._padding == _padding &&
        other._tallVerticalPadding == _tallVerticalPadding &&
        other._internalHorizontalPadding == _internalHorizontalPadding &&
        other._enableFeedback == _enableFeedback &&
        other._mouseCursor == _mouseCursor &&
        other._visualDensity == _visualDensity;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ShapeBorder?>(
        'customBorder', _customBorder,
        defaultValue: null));
    properties
        .add(DiagnosticsProperty<bool?>('strict', _strict, defaultValue: null));
    properties.add(DiagnosticsProperty<Color?>('tileColor', _tileColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Color?>(
        'selectedTileColor', _selectedTileColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<StateThemeData?>(
        'stateTheme', _stateTheme,
        defaultValue: null));
    properties.add(DiagnosticsProperty<StateLayerColors?>(
        'stateLayers', _stateLayers,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Color?>(
        'selectedLeadingColor', _selectedLeadingColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Color?>(
        'selectedOverlineColor', _selectedOverlineColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Color?>(
        'selectedHeadlineColor', _selectedHeadlineColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Color?>(
        'selectedSupportingTextColor', _selectedSupportingTextColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Color?>(
        'selectedTrailingColor', _selectedTrailingColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Color?>('leadingColor', _leadingColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Color?>('overlineColor', _overlineColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Color?>('headlineColor', _headlineColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Color?>(
        'supportingTextColor', _supportingTextColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Color?>('trailingColor', _trailingColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle?>(
        'leadingTextStyle', _leadingTextStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle?>(
        'overlineTextStyle', _overlineTextStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle?>(
        'headlineTextStyle', _headlineTextStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle?>(
        'supportingTextTextStyle', _supportingTextTextStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle?>(
        'trailingTextStyle', _trailingTextStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsetsDirectional?>(
        'padding', _padding,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double?>(
        'tallVerticalPadding', _tallVerticalPadding,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double?>(
        'internalHorizontalPadding', _internalHorizontalPadding,
        defaultValue: null));
    properties.add(DiagnosticsProperty<bool?>('enableFeedback', _enableFeedback,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<MouseCursor?>?>(
        'mouseCursor', _mouseCursor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<VisualDensity?>(
        'visualDensity', _visualDensity,
        defaultValue: null));
  }
}

// Resolves late
class _LateResolvingListTileThemeData extends ListTileThemeData {
  _LateResolvingListTileThemeData(super.other, this.context) : super._clone();

  final BuildContext context;

  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;
  late final TextTheme _textTheme = _theme.textTheme;

  @override
  StateThemeData get stateTheme => _stateTheme ?? _theme.stateTheme;

  @override
  StateLayerColors get stateLayers => _stateLayers != null
      ? _stateLayers!
      : StateLayerColors(
          hoverColor: StateLayer(_colors.onSurface, stateTheme.hoverOpacity),
          focusColor: StateLayer(_colors.onSurface, stateTheme.focusOpacity),
          pressColor: StateLayer(_colors.onSurface, stateTheme.pressOpacity),
          dragColor: StateLayer(_colors.onSurface, stateTheme.dragOpacity),
        );

  @override
  Color get leadingColor => _leadingColor ?? _colors.onSurfaceVariant;

  @override
  Color get overlineColor => _overlineColor ?? _colors.onSurfaceVariant;

  @override
  Color get headlineColor => _headlineColor ?? _colors.onSurface;

  @override
  Color get supportingTextColor =>
      _supportingTextColor ?? _colors.onSurfaceVariant;

  @override
  Color get trailingColor => _trailingColor ?? _colors.onSurfaceVariant;

  @override
  TextStyle get leadingTextStyle => _leadingTextStyle ?? _textTheme.labelSmall;

  @override
  TextStyle get overlineTextStyle =>
      _overlineTextStyle ?? _textTheme.labelSmall;

  @override
  TextStyle get headlineTextStyle => _headlineTextStyle ?? _textTheme.bodyLarge;

  @override
  TextStyle get supportingTextTextStyle =>
      _supportingTextTextStyle ?? _textTheme.bodyMedium;

  @override
  TextStyle get trailingTextStyle =>
      _trailingTextStyle ?? _textTheme.labelSmall;

  @override
  VisualDensity get visualDensity => _visualDensity ?? _theme.visualDensity;
}

/// An inherited widget that defines color and style parameters for [ListTile]s
/// in this widget's subtree.
///
/// Values specified here are used for [ListTile] properties that are not given
/// an explicit non-null value.
///
/// The [Drawer] widget specifies a tile theme for its children which sets
/// [style] to [ListTileStyle.drawer].
class ListTileTheme extends InheritedTheme {
  /// Creates a list tile theme that defines the color and style parameters for
  /// descendant [ListTile]s.
  ///
  /// Only the [data] parameter should be used. The other parameters are
  /// redundant (are now obsolete) and will be deprecated in a future update.
  const ListTileTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// Create a new [ListTileTheme] from the nearest ancestor [ListTileTheme],
  /// non-null values in [data] replacing the values from the ancestor.
  static Widget merge({
    Key? key,
    required ListTileThemeData data,
    required Widget child,
  }) {
    return Builder(
      builder: (BuildContext context) {
        final ListTileTheme? listTileTheme =
            context.dependOnInheritedWidgetOfExactType<ListTileTheme>();
        return ListTileTheme(
          key: key,
          data:
              listTileTheme != null ? listTileTheme.data.mergeWith(data) : data,
          child: child,
        );
      },
    );
  }

  /// The configuration of this theme.
  final ListTileThemeData data;

  /// The [data] property of the closest instance of this class that
  /// encloses the given context.
  ///
  /// If there is no enclosing [ListTileTheme] widget, then
  /// [ThemeData.listTileTheme] is used (see [Theme.of]).
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// ListTileThemeData theme = ListTileTheme.of(context);
  /// ```
  static ListTileThemeData of(BuildContext context) {
    final ListTileTheme? result =
        context.dependOnInheritedWidgetOfExactType<ListTileTheme>();
    return result?.data ?? Theme.of(context).listTileTheme;
  }

  /// Return a [ListTileThemeData] that merges the nearest ancestor [ListTileTheme]
  /// and the [ListTileThemeData] provided by the nearest [Theme].
  ///
  /// A current context theme can also be provided, used when the
  /// StateThemeData is passed as a parameter to a widget other than
  /// StateTheme.
  ///
  /// See also:
  ///
  /// * [BuildContext.dependOnInheritedWidgetOfExactType]
  static ListTileThemeData resolve(
    BuildContext context, [
    ListTileThemeData? currentContextTheme,
  ]) {
    final ancestorTheme =
        context.dependOnInheritedWidgetOfExactType<ListTileTheme>()?.data;
    final List<ListTileThemeData> ancestorThemes = [
      Theme.of(context).listTileTheme,
      if (ancestorTheme != null) ancestorTheme,
      if (currentContextTheme != null) currentContextTheme,
    ];
    if (ancestorThemes.length > 1) {
      return ancestorThemes
          .reduce((acc, e) => acc.mergeWith(e))
          .withContext(context);
    }
    return ancestorThemes.first.withContext(context);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return ListTileTheme(
      data: data,
      child: child,
    );
  }

  @override
  bool updateShouldNotify(ListTileTheme oldWidget) => data != oldWidget.data;
}

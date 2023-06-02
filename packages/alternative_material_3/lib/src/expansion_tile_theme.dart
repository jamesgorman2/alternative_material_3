// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'colors.dart';
import 'theme.dart';

// Examples can assume:
// late BuildContext context;

/// Used with [ExpansionTileTheme] to define default property values for
/// descendant [ExpansionTile] widgets.
///
/// Descendant widgets obtain the current [ExpansionTileThemeData] object
/// using `ExpansionTileTheme.of(context)`. Instances of
/// [ExpansionTileThemeData] can be customized with
/// [ExpansionTileThemeData.copyWith].
///
/// A [ExpansionTileThemeData] is often specified as part of the
/// overall [Theme] with [ThemeData.expansionTileTheme].
///
/// All [ExpansionTileThemeData] properties are `null` by default.
/// When a theme property is null, the [ExpansionTile]  will provide its own
/// default based on the overall [Theme]'s textTheme and
/// colorScheme. See the individual [ExpansionTile] properties for details.
///
/// See also:
///
///  * [ThemeData], which describes the overall theme information for the
///    application.
///  * [ExpansionTileTheme] which overrides the default [ExpansionTileTheme]
///    of its [ExpansionTile] descendants.
///  * [ThemeData.textTheme], text with a color that contrasts with the card
///    and canvas colors.
///  * [ThemeData.colorScheme], the thirteen colors that most Material widget
///    default colors are based on.
@immutable
class ExpansionTileThemeData with Diagnosticable {
  /// Creates a [ExpansionTileThemeData].
  const ExpansionTileThemeData ({
    Color? expandedBackgroundColor,
    Color? collapsedBackgroundColor,
    Color? expandedIconColor,
    Color? collapsedIconColor,
    Color? expandedHeadlineColor,
    Color? collapsedHeadlineColor,
    bool? showTopDividerWhenExpanded,
    bool? showBottomDividerWhenExpanded,
    Alignment? expandedAlignment,
    Clip? clipBehavior,
  }) : _expandedBackgroundColor =  expandedBackgroundColor,
        _collapsedBackgroundColor =  collapsedBackgroundColor,
        _expandedIconColor =  expandedIconColor,
        _collapsedIconColor =  collapsedIconColor,
        _expandedHeadlineColor =  expandedHeadlineColor,
        _collapsedHeadlineColor =  collapsedHeadlineColor,
        _showTopDividerWhenExpanded = showTopDividerWhenExpanded,
        _showBottomDividerWhenExpanded = showBottomDividerWhenExpanded,
  _expandedAlignment = expandedAlignment,
        _clipBehavior = clipBehavior;

  /// The color to display behind the sublist when expanded.
  /// 
  /// The default value is [Colors.transparent].
  Color get expandedBackgroundColor => _expandedBackgroundColor ?? Colors.transparent;
  final Color? _expandedBackgroundColor;

  /// The color to display behind the sublist when collapsed.
  /// 
  /// The default value is [Colors.transparent].
  Color get collapsedBackgroundColor => _collapsedBackgroundColor ?? Colors.transparent;
  final Color? _collapsedBackgroundColor;
  
  /// The color of the tile's expansion icon when the sublist is expanded.
  /// 
  /// When null the color is set from [ListTileThemeData.trailingColor].
  /// 
  /// The default value is null.
  Color? get expandedIconColor => _expandedIconColor;
  final Color? _expandedIconColor;

  /// The color of the tile's expansion icon when the sublist is collapsed.
  /// 
  /// When null the color is set from [ListTileThemeData.trailingColor].
  /// 
  /// The default value is null.
  Color? get collapsedIconColor => _collapsedIconColor;
  final Color? _collapsedIconColor;

  /// The color of the tile's titles when the sublist is expanded.
  /// 
  /// When null the color is set from [ListTileThemeData.headlineColor].
  /// 
  /// The default value is null.
  Color? get expandedHeadlineColor => _expandedHeadlineColor;
  final Color? _expandedHeadlineColor;

  /// The color of the tile's titles when the sublist is collapsed.
  /// 
  /// When null the color is set from [ListTileThemeData.headlineColor].
  /// 
  /// The default value is null.
  Color? get collapsedHeadlineColor => _collapsedHeadlineColor;
  final Color? _collapsedHeadlineColor;

  /// If true, a divider is drawn across the top of the expansion tile
  /// when it is expanded.
  /// 
  /// Default value is false.
  bool get showTopDividerWhenExpanded => _showTopDividerWhenExpanded ?? false;
  final bool? _showTopDividerWhenExpanded;

  /// If true, a divider is drawn across the top of the expansion tile
  /// when it is expanded.
  /// 
  /// Default value is true.
  bool get showBottomDividerWhenExpanded => _showBottomDividerWhenExpanded ?? true;
  final bool? _showBottomDividerWhenExpanded;

  /// Specifies the alignment of [ExpansionTile.child].
  ///
  /// The default value is [Alignment.center].
  Alignment get expandedAlignment => _expandedAlignment ?? Alignment.center;
  final Alignment? _expandedAlignment;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// The default is [Clip.none].
  ///
  /// See also:
  ///
  /// * [ExpansionTileTheme.of], which returns the nearest [ExpansionTileTheme]'s
  ///   [ExpansionTileThemeData].
  Clip get clipBehavior => _clipBehavior ?? Clip.none;
  final Clip? _clipBehavior;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  ExpansionTileThemeData copyWith({
    Color? expandedBackgroundColor,
    Color? collapsedBackgroundColor,
    Color? expandedIconColor,
    Color? collapsedIconColor,
    Color? expandedHeadlineColor,
    Color? collapsedHeadlineColor,
    bool? showTopDividerWhenExpanded,
    bool? showBottomDividerWhenExpanded,
    Alignment? expandedAlignment,
    Clip? clipBehavior,
  }) {
    return ExpansionTileThemeData(
      expandedBackgroundColor: expandedBackgroundColor ?? _expandedBackgroundColor,
      collapsedBackgroundColor: collapsedBackgroundColor ?? _collapsedBackgroundColor,
      expandedIconColor: expandedIconColor ?? _expandedIconColor,
      collapsedIconColor: collapsedIconColor ?? _collapsedIconColor,
      expandedHeadlineColor: expandedHeadlineColor ?? _expandedHeadlineColor,
      collapsedHeadlineColor: collapsedHeadlineColor ?? _collapsedHeadlineColor,
      showTopDividerWhenExpanded: showTopDividerWhenExpanded ?? _showTopDividerWhenExpanded,
      showBottomDividerWhenExpanded: showBottomDividerWhenExpanded ?? _showBottomDividerWhenExpanded,
      expandedAlignment: expandedAlignment ?? _expandedAlignment,
      clipBehavior: clipBehavior ?? _clipBehavior,
    );
  }

  /// Creates a copy of this object with fields replaced with the
  /// non-null values from [other].
  ExpansionTileThemeData mergeWith(ExpansionTileThemeData? other) {
    return copyWith(
      expandedBackgroundColor: other?._expandedBackgroundColor,
      collapsedBackgroundColor: other?._collapsedBackgroundColor,
      expandedIconColor: other?._expandedIconColor,
      collapsedIconColor: other?._collapsedIconColor,
      expandedHeadlineColor: other?._expandedHeadlineColor,
      collapsedHeadlineColor: other?._collapsedHeadlineColor,
      showTopDividerWhenExpanded: other?._showTopDividerWhenExpanded,
      showBottomDividerWhenExpanded: other?._showBottomDividerWhenExpanded,
      expandedAlignment: other?._expandedAlignment,
      clipBehavior: other?._clipBehavior,
    );
  }
  
  /// Linearly interpolate between ExpansionTileThemeData objects.
  static ExpansionTileThemeData? lerp(ExpansionTileThemeData? a, ExpansionTileThemeData? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return ExpansionTileThemeData(
      expandedBackgroundColor: Color.lerp(a?._expandedBackgroundColor, b?._expandedBackgroundColor, t),
      collapsedBackgroundColor: Color.lerp(a?._collapsedBackgroundColor, b?._collapsedBackgroundColor, t),
      expandedIconColor: Color.lerp(a?._expandedIconColor, b?._expandedIconColor, t),
      collapsedIconColor: Color.lerp(a?._collapsedIconColor, b?._collapsedIconColor, t),
      expandedHeadlineColor: Color.lerp(a?._expandedHeadlineColor, b?._expandedHeadlineColor, t),
      collapsedHeadlineColor: Color.lerp(a?._collapsedHeadlineColor, b?._collapsedHeadlineColor, t),
      showTopDividerWhenExpanded: t < 0.5 ? a?._showTopDividerWhenExpanded : b?._showTopDividerWhenExpanded,
      showBottomDividerWhenExpanded: t < 0.5 ? a?._showBottomDividerWhenExpanded : b?._showBottomDividerWhenExpanded,
      expandedAlignment: t < 0.5 ? a?._expandedAlignment : b?._expandedAlignment,
      clipBehavior: t < 0.5 ? a?._clipBehavior : b?._clipBehavior,
    );
  }

  @override
  int get hashCode {
    return Object.hash(
      _expandedBackgroundColor,
      _collapsedBackgroundColor,
      _expandedIconColor,
      _collapsedIconColor,
      _expandedHeadlineColor,
      _collapsedHeadlineColor,
      _showTopDividerWhenExpanded,
      _showBottomDividerWhenExpanded,
      _expandedAlignment,
      _clipBehavior,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is ExpansionTileThemeData
    && other._expandedBackgroundColor == _expandedBackgroundColor
    && other._collapsedBackgroundColor == _collapsedBackgroundColor
    && other._expandedIconColor == _expandedIconColor
    && other._collapsedIconColor == _collapsedIconColor
    && other._expandedHeadlineColor == _expandedHeadlineColor
    && other._collapsedHeadlineColor == _collapsedHeadlineColor
    && other._showTopDividerWhenExpanded == _showTopDividerWhenExpanded
    && other._showBottomDividerWhenExpanded == _showBottomDividerWhenExpanded
    && other._expandedAlignment == _expandedAlignment
    && other._clipBehavior == _clipBehavior;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('expandedBackgroundColor', _expandedBackgroundColor, defaultValue: null));
    properties.add(ColorProperty('collapsedBackgroundColor', _collapsedBackgroundColor, defaultValue: null));
    properties.add(ColorProperty('iconColor', _expandedIconColor, defaultValue: null));
    properties.add(ColorProperty('collapsedIconColor', _collapsedIconColor, defaultValue: null));
    properties.add(ColorProperty('textColor', _expandedHeadlineColor, defaultValue: null));
    properties.add(ColorProperty('collapsedTextColor', _collapsedHeadlineColor, defaultValue: null));
    properties.add(DiagnosticsProperty<bool?>('shape', _showTopDividerWhenExpanded, defaultValue: null));
    properties.add(DiagnosticsProperty<bool?>('collapsedShape', _showBottomDividerWhenExpanded, defaultValue: null));
    properties.add(DiagnosticsProperty<Alignment?>('expandedAlignment', _expandedAlignment, defaultValue: null));
    properties.add(DiagnosticsProperty<Clip?>('clipBehavior', _clipBehavior, defaultValue: null));
  }
}

/// Overrides the default [ExpansionTileTheme] of its [ExpansionTile] descendants.
///
/// See also:
///
///  * [ExpansionTileThemeData], which is used to configure this theme.
///  * [ThemeData.expansionTileTheme], which can be used to override the default
///    [ExpansionTileTheme] for [ExpansionTile]s below the overall [Theme].
class ExpansionTileTheme extends InheritedTheme {
  /// Applies the given theme [data] to [child].
  ///
  /// The [data] and [child] arguments must not be null.
  const ExpansionTileTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// Specifies color, alignment, and text style values for
  /// descendant [ExpansionTile] widgets.
  final ExpansionTileThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [ExpansionTileTheme] widget, then
  /// [ThemeData.expansionTileTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// ExpansionTileThemeData theme = ExpansionTileTheme.of(context);
  /// ```
  static ExpansionTileThemeData of(BuildContext context) {
    final ExpansionTileTheme? inheritedTheme = context.dependOnInheritedWidgetOfExactType<ExpansionTileTheme>();
    return inheritedTheme?.data ?? Theme.of(context).expansionTileTheme;
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
  static ExpansionTileThemeData resolve(
      BuildContext context, [
        ExpansionTileThemeData? currentContextTheme,
      ]) {
    final ancestorTheme =
        context.dependOnInheritedWidgetOfExactType<ExpansionTileTheme>()?.data;
    final List<ExpansionTileThemeData> ancestorThemes = [
      Theme.of(context).expansionTileTheme,
      if (ancestorTheme != null) ancestorTheme,
      if (currentContextTheme != null) currentContextTheme,
    ];
    // no default values require build context
    if (ancestorThemes.length > 1) {
      return ancestorThemes
          .reduce((acc, e) => acc.mergeWith(e));
    }
    return ancestorThemes.first;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return ExpansionTileTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(ExpansionTileTheme oldWidget) => data != oldWidget.data;
 }

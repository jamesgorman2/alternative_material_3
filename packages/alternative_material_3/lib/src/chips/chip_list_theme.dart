// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../theme.dart';
import '../theme_data.dart';

/// Applies a chip theme to descendant [RawChip]-based widgets, like [Chip],
/// [InputChip], [ChoiceChip], [FilterChip], and [ActionChip].
///
/// A chip theme describes the color, shape and text styles for the chips it is
/// applied to.
///
/// Descendant widgets obtain the current theme's [ChipListThemeData] object using
/// [ChipListTheme.of]. When a widget uses [ChipListTheme.of], it is automatically
/// rebuilt if the theme later changes.
///
/// The [ThemeData] object given by the [Theme.of] call also contains a default
/// [ThemeData.ChipListTheme] that can be customized by copying it (using
/// [ChipListThemeData.copyWith]).
///
/// See also:
///
///  * [Chip], a chip that displays information and can be deleted.
///  * [InputChip], a chip that represents a complex piece of information, such
///    as an entity (person, place, or thing) or conversational text, in a
///    compact form.
///  * [ChoiceChip], allows a single selection from a set of options. Choice
///    chips contain related descriptive text or categories.
///  * [FilterChip], uses tags or descriptive words as a way to filter content.
///  * [ActionChip], represents an action related to primary content.
///  * [ChipListThemeData], which describes the actual configuration of a chip
///    theme.
///  * [ThemeData], which describes the overall theme information for the
///    application.
class ChipListTheme extends InheritedTheme {
  /// Applies the given theme [data] to [child].
  ///
  /// The [data] and [child] arguments must not be null.
  const ChipListTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// Specifies the color, shape, and text style values for descendant chip
  /// widgets.
  final ChipListThemeData data;

  /// Returns the data from the closest [ChipListTheme] instance that encloses
  /// the given context.
  ///
  /// Defaults to the ambient [ThemeData.ChipListTheme] if there is no
  /// [ChipListTheme] in the given build context.
  ///
  /// {@tool snippet}
  ///
  /// ```dart
  /// class Spaceship extends StatelessWidget {
  ///   const Spaceship({super.key});
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return ChipListTheme(
  ///       data: ChipListTheme.of(context).copyWith(backgroundColor: Colors.red),
  ///       child: ActionChip(
  ///         label: const Text('Launch'),
  ///         onPressed: () { print('We have liftoff!'); },
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [ChipListThemeData], which describes the actual configuration of a chip
  ///    theme.
  static ChipListThemeData of(BuildContext context) {
    final ChipListTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<ChipListTheme>();
    return inheritedTheme?.data ?? Theme.of(context).chipListTheme;
  }

  /// Return a [CheckboxThemeData] that merges the nearest ancestor [CheckboxTheme]
  /// and the [CheckboxThemeData] provided by the nearest [Theme].
  ///
  /// A current context theme can also be provided, used when the
  /// StateThemeData is passed as a parameter to a widget other than
  /// StateTheme.
  ///
  /// See also:
  ///
  /// * [BuildContext.dependOnInheritedWidgetOfExactType]
  static ChipListThemeData resolve(
    BuildContext context, [
    ChipListThemeData? currentContextTheme,
  ]) {
    final ancestorTheme =
        context.dependOnInheritedWidgetOfExactType<ChipListTheme>()?.data;
    final List<ChipListThemeData> ancestorThemes = [
      Theme.of(context).chipListTheme,
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
    return ChipListTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(ChipListTheme oldWidget) => data != oldWidget.data;
}

/// Holds the color, shape, and text styles for a Material Design chip list.
///
/// Use this class to configure a [ChipListTheme] widget, or to set the
/// [ThemeData.ChipListTheme] for a [Theme] widget.
///
/// To obtain the current ambient chip theme, use [ChipListTheme.of].
///
///  * [Chip], a chip that displays information and can be deleted.
///  * [InputChip], a chip that represents a complex piece of information, such
///    as an entity (person, place, or thing) or conversational text, in a
///    compact form.
///  * [ChoiceChip], allows a single selection from a set of options. Choice
///    chips contain related descriptive text or categories.
///  * [FilterChip], uses tags or descriptive words as a way to filter content.
///  * [ActionChip], represents an action related to primary content.
///  * [CircleAvatar], which shows images or initials of entities.
///  * [Wrap], A widget that displays its children in multiple horizontal or
///    vertical runs.
///  * [ChipListTheme] widget, which can override the chip theme of its
///    children.
///  * [Theme] widget, which performs a similar function to [ChipListTheme],
///    but for overall themes.
///  * [ThemeData], which has a default [ChipListThemeData].
@immutable
class ChipListThemeData with Diagnosticable {
  /// Create a [ChipListThemeData] given a set of exact values. All the values
  /// must be specified except for [shadowColor], [selectedShadowColor],
  /// [elevation], and [pressElevation], which may be null.
  ///
  /// This will rarely be used directly. It is used by [lerp] to
  /// create intermediate themes based on two themes.
  const ChipListThemeData({
    double? horizontalMargin,
    double? verticalMargin,
    double? minLines,
    double? maxLines,
    double? overflowLineHeight,
    VisualDensity? visualDensity,
  })  : _horizontalMargin = horizontalMargin,
        _verticalMargin = verticalMargin,
        _minLines = minLines,
        _maxLines = maxLines,
        _overflowLineHeight = overflowLineHeight,
        _visualDensity = visualDensity,
        assert(minLines == null || minLines > 0.0),
        assert(maxLines == null || maxLines > 0.0),
        assert(minLines == null || maxLines == null || minLines <= maxLines),
        assert(overflowLineHeight == null ||
            (overflowLineHeight >= 0.0 && overflowLineHeight <= 1.0));

  ChipListThemeData._clone(ChipListThemeData other)
      : _horizontalMargin = other._horizontalMargin,
        _verticalMargin = other._verticalMargin,
        _minLines = other._minLines,
        _maxLines = other._maxLines,
        _overflowLineHeight = other._overflowLineHeight,
        _visualDensity = other._visualDensity;

  /// Copy this ChipListThemeData and set any default values that
  /// require a [BuildContext] set, such as colors and text themes.
  ChipListThemeData withContext(BuildContext context) =>
      _LateResolvingChipListThemeData(this, context);

  /// The horizontal distance between chips.
  ///
  /// The default value is 8.
  double get horizontalMargin => _horizontalMargin ?? 8.0;
  final double? _horizontalMargin;

  /// The vertical distance between chips. This if
  /// [ThemeData.minInteractiveDimension] is greater than
  /// [ChipThemeData.containerHeight] and [ThemeData.materialTapTargetSize] is
  /// [MaterialTapTargetSize.padded], this distance will include the padding
  /// around the chips.
  ///
  /// The default value is 16.
  double get verticalMargin => _verticalMargin ?? 16.0;
  final double? _verticalMargin;

  /// The minimum number of lines to display. If empty this is unbounded.
  ///
  /// The default value is null.
  double? get minLines => _minLines;
  final double? _minLines;

  /// The maximum number of lines to display. If empty this is unbounded.
  ///
  /// The default value is null.
  double? get maxLines => _maxLines;
  final double? _maxLines;

  /// If [maxLines] is not null, how much additional height to show as
  /// a percentage of a single line height.
  ///
  /// The default is 0.
  double get overflowLineHeight => _overflowLineHeight ?? 0.0;
  final double? _overflowLineHeight;

  /// {@macro flutter.material.themedata.visualDensity}
  ///
  /// The default value is [ThemeData.visualDensity].
  VisualDensity get visualDensity => _visualDensity!;
  final VisualDensity? _visualDensity;

  /// Creates a copy of this object but with the given fields replaced with the
  /// new values.
  ChipListThemeData copyWith({
    double? horizontalMargin,
    double? verticalMargin,
    double? minLines,
    double? maxLines,
    double? overflowLineHeight,
    VisualDensity? visualDensity,
  }) {
    return ChipListThemeData(
      horizontalMargin: horizontalMargin ?? _horizontalMargin,
      verticalMargin: verticalMargin ?? _verticalMargin,
      minLines: minLines ?? _minLines,
      maxLines: maxLines ?? _maxLines,
      overflowLineHeight: overflowLineHeight ?? _overflowLineHeight,
      visualDensity: visualDensity ?? _visualDensity,
    );
  }

  /// Creates a copy of this object with fields replaced with the
  /// non-null values from [other].
  ChipListThemeData mergeWith(ChipListThemeData? other) {
    return copyWith(
      horizontalMargin: other?._horizontalMargin,
      verticalMargin: other?._verticalMargin,
      minLines: other?._minLines,
      maxLines: other?._maxLines,
      overflowLineHeight: other?._overflowLineHeight,
      visualDensity: other?._visualDensity,
    );
  }

  /// Linearly interpolate between two chip themes.
  ///
  /// The arguments must not be null.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static ChipListThemeData? lerp(
      ChipListThemeData? a, ChipListThemeData? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return ChipListThemeData(
      horizontalMargin:
          lerpDouble(a?._horizontalMargin, b?._horizontalMargin, t),
      verticalMargin: lerpDouble(a?._verticalMargin, b?._verticalMargin, t),
      minLines: lerpDouble(a?._minLines, b?._minLines, t),
      maxLines: lerpDouble(a?._maxLines, b?._maxLines, t),
      overflowLineHeight:
          lerpDouble(a?._overflowLineHeight, b?._overflowLineHeight, t),
      visualDensity:
          VisualDensity.lerp(a?._visualDensity, b?._visualDensity, t),
    );
  }

  @override
  int get hashCode => Object.hash(
        _horizontalMargin,
        _verticalMargin,
        _minLines,
        _maxLines,
        _overflowLineHeight,
        _visualDensity,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is ChipListThemeData &&
        _horizontalMargin == other._horizontalMargin &&
        _verticalMargin == other._verticalMargin &&
        _minLines == other._minLines &&
        _maxLines == other._maxLines &&
        _overflowLineHeight == other._overflowLineHeight &&
        _visualDensity == other._visualDensity;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<double>(
        'horizontalMargin', _horizontalMargin,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>(
        'verticalMargin', _verticalMargin,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty<double>('minLines', _minLines, defaultValue: null));
    properties.add(
        DiagnosticsProperty<double>('maxLines', _maxLines, defaultValue: null));
    properties.add(DiagnosticsProperty<double>(
        'overflowLineHeight', _overflowLineHeight,
        defaultValue: null));
    properties.add(DiagnosticsProperty<VisualDensity>(
        'visualDensity', _visualDensity,
        defaultValue: null));
  }
}

class _LateResolvingChipListThemeData extends ChipListThemeData {
  _LateResolvingChipListThemeData(super.other, this.context) : super._clone();

  final BuildContext context;

  late final ThemeData _theme = Theme.of(context);

  @override
  VisualDensity get visualDensity => _visualDensity ?? _theme.visualDensity;
}

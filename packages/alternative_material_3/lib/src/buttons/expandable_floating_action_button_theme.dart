import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../../material.dart';
import '../theme.dart';

///
@immutable
class ExpandableFloatingActionButtonThemeData with Diagnosticable {
  ///
  const ExpandableFloatingActionButtonThemeData({
    double? primaryPadding,
    double? supportingPadding,
    Duration? animationDuration,
  })  : _primaryPadding = primaryPadding,
        _supportingPadding = supportingPadding,
        _animationDuration = animationDuration;

  static ExpandableFloatingActionButtonThemeData resolve(
    BuildContext context, [
    ExpandableFloatingActionButtonThemeData? currentContextTheme,
  ]) {
    final List<ExpandableFloatingActionButtonThemeData> ancestorThemes = [
      Theme.of(context).expandableFloatingActionButtonTheme,
      if (currentContextTheme != null) currentContextTheme,
    ];
    if (ancestorThemes.length > 1) {
      return ancestorThemes.reduce((acc, e) => acc.mergeWith(e));
    }
    return ancestorThemes.first;
  }

  double get primaryPadding => _primaryPadding ?? 24.0;
  final double? _primaryPadding;

  double get supportingPadding => _supportingPadding ?? 16.0;
  final double? _supportingPadding;

  Duration get animationDuration =>
      _animationDuration ?? kThemeAnimationDuration;
  final Duration? _animationDuration;

  ExpandableFloatingActionButtonThemeData copyWith(
    double? primaryPadding,
    double? supportingPadding,
    Duration? animationDuration,
  ) {
    return ExpandableFloatingActionButtonThemeData(
      primaryPadding: primaryPadding ?? _primaryPadding,
      supportingPadding: supportingPadding ?? _supportingPadding,
      animationDuration: animationDuration ?? _animationDuration,
    );
  }

  ExpandableFloatingActionButtonThemeData mergeWith(
      ExpandableFloatingActionButtonThemeData? other,
  ) {
    return ExpandableFloatingActionButtonThemeData(
      primaryPadding: other?._primaryPadding ?? _primaryPadding,
      supportingPadding: other?._supportingPadding ?? _supportingPadding,
      animationDuration: other?._animationDuration ?? _animationDuration,
    );
  }

  static ExpandableFloatingActionButtonThemeData? lerp(
      ExpandableFloatingActionButtonThemeData? a,
      ExpandableFloatingActionButtonThemeData? b,
      double t
  ) {
    if (identical(a, b)) {
      return a;
    }

    return ExpandableFloatingActionButtonThemeData(
      animationDuration: Duration(
          milliseconds: (lerpDouble(a?.animationDuration.inMilliseconds, b?.animationDuration.inMilliseconds, t) ?? 0.0).round()
      ),
      primaryPadding: lerpDouble(a?.primaryPadding, b?.primaryPadding, t),
      supportingPadding: lerpDouble(a?.supportingPadding, b?.supportingPadding, t),
    );
  }
}

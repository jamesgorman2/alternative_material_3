import 'package:flutter/widgets.dart';

import 'state_theme.dart';
import 'theme.dart';

/// A widget that notifies its descendants that they should be disabled.
///
/// This also disabled hit testing, focus and (optionally) semantics for
/// its descendants.
class Disabled extends InheritedWidget {
  /// If [isDisabled] is true, all descendants should be disabled.
  ///
  /// If [ignoringSemantics] is null,
  /// this render object will be ignored for semantics if [isDisabled] is true.
  const Disabled({
    super.key,
    required this.isDisabled,
    this.ignoringSemantics,
    required super.child,
  });

  /// If true,
  final bool isDisabled;

  /// {@template alternative_material_3.disabled.ignoringSemantics}
  /// Whether the semantics of this widget is ignored when compiling the semantics tree.
  ///
  /// If null, defaults to value of [ignoring].
  ///
  /// See [SemanticsNode] for additional information about the semantics tree.
  /// {@endtemplate}
  final bool? ignoringSemantics;

  /// Returns [isDisabled] from the closest [Disabled] instance that encloses
  /// the given context, otherwise false.
  static bool of(BuildContext context) {
    final Disabled? inheritedDisabled =
        context.dependOnInheritedWidgetOfExactType<Disabled>();
    return inheritedDisabled?.isDisabled ?? false;
  }

  @override
  bool updateShouldNotify(Disabled oldWidget) {
    return oldWidget.isDisabled != isDisabled;
  }

  @override
  Widget get child => IgnorePointer(
        ignoring: isDisabled,
        ignoringSemantics: ignoringSemantics,
        child: ExcludeFocus(
          excluding: isDisabled,
          child: super.child,
        ),
      );
}

/// A wrapper to render a widget as disabled by wrapping it in an
/// [Opacity].
///
/// This is used wrap children that do not support [Disabled] natively,
/// such as [Text] and [Image].
///
/// Nesting [Disableable] should be avoided as the opacty will be applied
/// mulitple times.
class Disableable extends StatelessWidget {
  /// Create a Disableable widget.
  ///
  /// Only one of [disabledOpacity] and [disabledOpacityFromTheme] may be
  /// present.
  const Disableable({
    super.key,
    this.isDisabled,
    this.disabledOpacity,
    this.disabledOpacityFromTheme,
    this.stateTheme,
    required this.child,
  }) : assert(
          !(disabledOpacity != null && disabledOpacityFromTheme != null),
          'Only one of `disabledOpacity` and `disabledOpacityFromTheme` may be '
              'defined.',
        );

  /// If true, render [child] with a disabled opacity.
  ///
  /// The default value is [Disabled.of] from the current context.
  final bool? isDisabled;

  /// The widget that may be disabled.
  final Widget? child;

  /// A fixed opacity to use when disabled.
  ///
  /// If this and [disabledOpacity] are null, [StateThemeData.disabledOpacity]
  /// will be used.
  final double? disabledOpacity;

  /// Select a disabled opacity from a state theme.
  ///
  /// If this and [disabledOpacity] are null, [StateThemeData.disabledOpacity]
  /// will be used.
  final double Function(StateThemeData stateTheme)? disabledOpacityFromTheme;

  /// An optional [StateThemeData] used to determine the disabled opacity.
  ///
  /// The default value is [ThemeData.stateTheme].
  final StateThemeData? stateTheme;

  @override
  Widget build(BuildContext context) {
    final double opacity;
    if (isDisabled ?? Disabled.of(context)) {
      final stateTheme = this.stateTheme ?? Theme.of(context).stateTheme;
      opacity = disabledOpacity ??
          disabledOpacityFromTheme?.call(stateTheme) ??
          stateTheme.disabledOpacity;
    } else {
      opacity = 1.0;
    }
    return Opacity(
      opacity: opacity,
      child: child,
    );
  }
}

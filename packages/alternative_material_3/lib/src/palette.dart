import 'dart:math' as math;
import 'dart:ui';

import 'package:alternative_material_3/material.dart' as flutter;
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:meta/meta.dart';

final TonalPalette _defaultErrorPalette = TonalPalette.of(25, 84);

///
@immutable
class Palette {
  ///
  Palette({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.neutral,
    required this.neutralVariant,
    TonalPalette? error,
  }) : error = error ?? _defaultErrorPalette;

  ///
  factory Palette.fromSeedColor(Color color) {
    final cam = Cam16.fromInt(color.value);
    final hue = cam.hue;
    final chroma = cam.chroma;
    return Palette(
        primary: TonalPalette.of(hue, math.max(48, chroma)),
        secondary: TonalPalette.of(hue, 16),
        tertiary: TonalPalette.of(hue + 60, 24),
        neutral: TonalPalette.of(hue, 4),
        neutralVariant: TonalPalette.of(hue, 8),
        error: _defaultErrorPalette);
  }

  ///
  factory Palette.fromColors({
    required Color primary,
    Color? secondary,
    Color? tertiary,
    Color? neutral,
    Color? neutralVariant,
    Color? error,
    bool clamp = false,
  }) {
    final primaryCam = Cam16.fromInt(primary.value);
    final primaryHue = primaryCam.hue;
    TonalPalette asTonal(Color? color, double hueChange, double maxChroma) {
      if (color != null) {
        final cam = Cam16.fromInt(color.value);
        return TonalPalette.of(
          cam.hue,
          math.max(
            cam.chroma,
            clamp ? maxChroma : 0,
          ),
        );
      }
      return TonalPalette.of(primaryHue + hueChange, maxChroma);
    }

    return Palette(
      primary: asTonal(primary, 0, 48),
      secondary: asTonal(secondary, 0, 16),
      tertiary: asTonal(tertiary, 60, 24),
      neutral: asTonal(neutral, 0, 4),
      neutralVariant: asTonal(neutralVariant, 0, 8),
      error: error != null ? asTonal(error, 0, 84) : _defaultErrorPalette,
    );
  }

  ///
  factory Palette.fromColorScheme({
    required flutter.ColorScheme colorScheme,
    bool clamp = false,
  }) {
    return Palette.fromColors(
      primary: colorScheme.primary,
      secondary: colorScheme.secondary,
      tertiary: colorScheme.tertiary,
      error: colorScheme.error,
      clamp: clamp,
    );
  }

  ///
  factory Palette.fromCorePalette(CorePalette corePalette) {
    return Palette(
      primary: corePalette.primary,
      secondary: corePalette.primary,
      tertiary: corePalette.primary,
      neutral: corePalette.primary,
      neutralVariant: corePalette.primary,
    );
  }

  ///
  final TonalPalette primary;

  ///
  final TonalPalette secondary;

  ///
  final TonalPalette tertiary;

  ///
  final TonalPalette neutral;

  ///
  final TonalPalette neutralVariant;

  ///
  final TonalPalette error;

  ///
  Palette copyWith({
    TonalPalette? primary,
    TonalPalette? secondary,
    TonalPalette? tertiary,
    TonalPalette? neutral,
    TonalPalette? neutralVariant,
    TonalPalette? error,
  }) {
    return Palette(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      neutral: neutral ?? this.neutral,
      neutralVariant: neutralVariant ?? this.neutralVariant,
      error: error ?? this.error,
    );
  }

  static TonalPalette lerpTonalPalette(TonalPalette a, TonalPalette b, double t) {
    // TODO - remove at material_color_util 0.5.0
    final aCam = Cam16.fromInt(a.get(40));
    final aHue = aCam.hue;
    final aChroma = aCam.chroma;
    final bCam = Cam16.fromInt(b.get(40));
    final bHue = bCam.hue;
    final bChroma = bCam.chroma;
    return TonalPalette.of(
      lerpDouble(aHue, bHue, t)!,
      lerpDouble(aChroma, bChroma, t)!,
    );
  }

  static Palette lerp(Palette a, Palette b, double t) {
    return Palette(
      primary: lerpTonalPalette(a.primary, b.primary, t),
      secondary: lerpTonalPalette(a.secondary, b.secondary, t),
      tertiary: lerpTonalPalette(a.tertiary, b.tertiary, t),
      neutral: lerpTonalPalette(a.neutral, b.neutral, t),
      neutralVariant: lerpTonalPalette(a.neutralVariant, b.neutralVariant, t),
      error: lerpTonalPalette(a.error, b.error, t)
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Palette &&
        primary == other.primary &&
        secondary == other.secondary &&
        tertiary == other.tertiary &&
        neutral == other.neutral &&
        neutralVariant == other.neutralVariant &&
        error == other.error;
  }

  @override
  int get hashCode => Object.hash(
        primary,
        secondary,
        tertiary,
        neutral,
        neutralVariant,
        error,
      );

  @override
  String toString() {
    return 'Palette('
        'primary: $primary, '
        'secondary: $secondary, '
        'tertiary: $tertiary, '
        'neutral: $neutral, '
        'neutralVariant: $neutralVariant, '
        'error: $error'
        ')';
  }
}

// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/painting.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

import 'app.dart';
import 'colors.dart';
import 'palette.dart';

///
@immutable
class ColorScheme with Diagnosticable {
  ///
  const ColorScheme({
    required this.palette,
    required this.brightness,
    required this.primary,
    required this.primaryContainer,
    required this.onPrimary,
    required this.onPrimaryContainer,
    required this.inversePrimary,
    required this.secondary,
    required this.secondaryContainer,
    required this.onSecondary,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.tertiaryContainer,
    required this.onTertiary,
    required this.onTertiaryContainer,
    required this.primaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixed,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixed,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixed,
    required this.onTertiaryFixedVariant,
    required this.surface,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.surfaceVariant,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.inverseSurface,
    required this.inverseOnSurface,
    required this.background,
    required this.onBackground,
    required this.error,
    required this.errorContainer,
    required this.onError,
    required this.onErrorContainer,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
  });

  ///
  factory ColorScheme.fromPalette({
    required Palette palette,
    Brightness brightness = Brightness.light,
  }) {
    final bool light = brightness == Brightness.light;
    return ColorScheme(
      palette: palette,
      brightness: brightness,
      primary: Color(palette.primary.get(light ? 40 : 80)),
      primaryContainer: Color(palette.primary.get(light ? 90 : 30)),
      onPrimary: Color(palette.primary.get(light ? 100 : 20)),
      onPrimaryContainer: Color(palette.primary.get(light ? 10 : 90)),
      inversePrimary: Color(palette.primary.get(light ? 80 : 40)),
      secondary: Color(palette.secondary.get(light ? 40 : 80)),
      secondaryContainer: Color(palette.secondary.get(light ? 90 : 30)),
      onSecondary: Color(palette.secondary.get(light ? 100 : 20)),
      onSecondaryContainer: Color(palette.secondary.get(light ? 10 : 90)),
      tertiary: Color(palette.tertiary.get(light ? 40 : 80)),
      tertiaryContainer: Color(palette.tertiary.get(light ? 90 : 30)),
      onTertiary: Color(palette.tertiary.get(light ? 100 : 20)),
      onTertiaryContainer: Color(palette.tertiary.get(light ? 10 : 90)),
      surface: Color(palette.neutral.get(light ? 98 : 6)),
      surfaceDim: Color(palette.neutral.get(light ? 87 : 6)),
      surfaceBright: Color(palette.neutral.get(light ? 98 : 24)),
      surfaceContainerLowest: Color(palette.neutral.get(light ? 100 : 4)),
      surfaceContainerLow: Color(palette.neutral.get(light ? 96 : 10)),
      surfaceContainer: Color(palette.neutral.get(light ? 94 : 12)),
      surfaceContainerHigh: Color(palette.neutral.get(light ? 92 : 17)),
      surfaceContainerHighest: Color(palette.neutral.get(light ? 90 : 22)),
      surfaceVariant: Color(palette.neutralVariant.get(light ? 90 : 30)),
      onSurface: Color(palette.neutral.get(light ? 10 : 90)),
      onSurfaceVariant: Color(palette.neutralVariant.get(light ? 30 : 80)),
      inverseSurface: Color(palette.neutral.get(light ? 20 : 90)),
      inverseOnSurface: Color(palette.neutral.get(light ? 95 : 20)),
      background: Color(palette.neutral.get(light ? 98 : 6)),
      onBackground: Color(palette.neutral.get(light ? 10 : 90)),
      error: Color(palette.error.get(light ? 40 : 80)),
      errorContainer: Color(palette.error.get(light ? 90 : 30)),
      onError: Color(palette.error.get(light ? 100 : 20)),
      onErrorContainer: Color(palette.error.get(light ? 10 : 90)),
      outline: Color(palette.neutralVariant.get(light ? 50 : 60)),
      outlineVariant: Color(palette.neutralVariant.get(light ? 80 : 30)),
      shadow: Color(palette.neutral.get(0)),
      scrim: Color(palette.neutral.get(0)),
      primaryFixed: Color(palette.primary.get(90)),
      primaryFixedDim: Color(palette.primary.get(80)),
      onPrimaryFixed: Color(palette.primary.get(10)),
      onPrimaryFixedVariant: Color(palette.primary.get(30)),
      secondaryFixed: Color(palette.secondary.get(90)),
      secondaryFixedDim: Color(palette.secondary.get(80)),
      onSecondaryFixed: Color(palette.secondary.get(10)),
      onSecondaryFixedVariant: Color(palette.secondary.get(30)),
      tertiaryFixed: Color(palette.tertiary.get(90)),
      tertiaryFixedDim: Color(palette.tertiary.get(80)),
      onTertiaryFixed: Color(palette.tertiary.get(10)),
      onTertiaryFixedVariant: Color(palette.tertiary.get(30)),
    );
  }

  ///
  factory ColorScheme.fromColorScheme({
    required flutter.ColorScheme colorScheme,
    Brightness brightness = Brightness.light,
    bool clamp = false,
  }) {
    return ColorScheme.fromPalette(
      palette: Palette.fromColorScheme(colorScheme: colorScheme, clamp: clamp),
      brightness: brightness,
    );
  }

  ///
  factory ColorScheme.fromSeed({
    required Color seedColor,
    Brightness brightness = Brightness.light,
  }) {
    return ColorScheme.fromPalette(
      palette: Palette.fromSeedColor(seedColor),
      brightness: brightness,
    );
  }

  ///
  factory ColorScheme.fromBightness(Brightness brightness) =>
    brightness == Brightness.light
      ? m3DefaultLight
      : m3DefaultDark;

  ///
  factory ColorScheme.fromSwatch({
    required Color primary,
    Color? secondary,
    Color? tertiary,
    Color? neutral,
    Color? neutralVariant,
    Color? error,
    Brightness brightness = Brightness.light,
    bool clamp = false,
  }) {
    return ColorScheme.fromPalette(
      palette: Palette.fromColors(
        primary: primary,
        secondary: secondary,
        tertiary: tertiary,
        neutral: neutral,
        neutralVariant: neutralVariant,
        error: error,
        clamp: clamp,
      ),
      brightness: brightness,
    );
  }

  // Off-by-one error calculating the palette means we hard code this for now
  ///
  static final m3DefaultLight = ColorScheme(
    brightness: Brightness.light,
    palette: Palette.fromColors(
      primary: const Color(0x006750a4),
      secondary: const Color(0x00625b71),
      tertiary: const Color(0x007d5260),
    ),
    primary: const Color(0Xff6750A4),
    primaryContainer: const Color(0XffEADDFF),
    onPrimary: const Color(0XffFFFFFF),
    onPrimaryContainer: const Color(0Xff21005E),
    inversePrimary: const Color(0XffD0BCFF),
    secondary: const Color(0Xff625B71),
    secondaryContainer: const Color(0XffE8DEF8),
    onSecondary: const Color(0XffFFFFFF),
    onSecondaryContainer: const Color(0Xff1E192B),
    tertiary: const Color(0Xff7D5260),
    tertiaryContainer: const Color(0XffFFD8E4),
    onTertiary: const Color(0XffFFFFFF),
    onTertiaryContainer: const Color(0Xff370B1E),
    surface: const Color(0XffFEF7FF),
    surfaceDim: const Color(0XffDED8E1),
    surfaceBright: const Color(0XffFEF7FF),
    surfaceContainerLowest: const Color(0XffFFFFFF),
    surfaceContainerLow: const Color(0XffF7F2FA),
    surfaceContainer: const Color(0XffF3EDF7),
    surfaceContainerHigh: const Color(0XffECE6F0),
    surfaceContainerHighest: const Color(0XffE6E0E9),
    surfaceVariant: const Color(0XffE7E0EC),
    onSurface: const Color(0Xff1C1B1F),
    onSurfaceVariant: const Color(0Xff49454E),
    inverseSurface: const Color(0Xff313033),
    inverseOnSurface: const Color(0XffF4EFF4),
    background: const Color(0XffFEF7FF),
    onBackground: const Color(0Xff1C1B1F),
    error: const Color(0XffB3261E),
    errorContainer: const Color(0XffF9DEDC),
    onError: const Color(0XffFFFFFF),
    onErrorContainer: const Color(0Xff410E0B),
    outline: const Color(0Xff79747E),
    outlineVariant: const Color(0XffC4C7C5),
    shadow: const Color(0Xff000000),
    scrim: const Color(0Xff000000),

    primaryFixed: const Color(0xffEADDFf),
    primaryFixedDim: const Color(0xffd0bcff),
    onPrimaryFixed: const Color(0xff21005d),
    onPrimaryFixedVariant: const Color(0xff4f378b),

    secondaryFixed: const Color(0xffe8def8),
    secondaryFixedDim: const Color(0xffccc2dc),
    onSecondaryFixed: const Color(0xff1d192b),
    onSecondaryFixedVariant: const Color(0xff4a4458),

    tertiaryFixed: const Color(0xffffd8e4),
    tertiaryFixedDim: const Color(0xffefb8c8),
    onTertiaryFixed: const Color(0xff31111d),
    onTertiaryFixedVariant: const Color(0xff633b48),
  );

  // Off-by-one error calculating the palette means we hard code this for now
  ///
  static final m3DefaultDark = ColorScheme(
    brightness: Brightness.dark,

    palette: Palette.fromColors(
      primary: const Color(0x006750a4),
      secondary: const Color(0x00625b71),
      tertiary: const Color(0x007d5260),
    ),

    primary: const Color(0XffD0BCFF),
    primaryContainer: const Color(0Xff4F378B),
    onPrimary: const Color(0Xff371E73),
    onPrimaryContainer: const Color(0XffEADDFF),
    inversePrimary: const Color(0Xff6750A4),
    secondary: const Color(0XffCCC2DC),
    secondaryContainer: const Color(0Xff4A4458),
    onSecondary: const Color(0Xff332D41),
    onSecondaryContainer: const Color(0XffE8DEF8),
    tertiary: const Color(0XffEFB8C8),
    tertiaryContainer: const Color(0Xff633B48),
    onTertiary: const Color(0Xff492532),
    onTertiaryContainer: const Color(0XffFFD8E4),
    surface: const Color(0Xff141218),
    surfaceDim: const Color(0Xff141218),
    surfaceBright: const Color(0Xff3B383E),
    surfaceContainerLowest: const Color(0Xff0F0D13),
    surfaceContainerLow: const Color(0Xff1D1B20),
    surfaceContainer: const Color(0Xff211F26),
    surfaceContainerHigh: const Color(0Xff2B2930),
    surfaceContainerHighest: const Color(0Xff36343B),
    surfaceVariant: const Color(0Xff49454F),
    onSurface: const Color(0XffE6E1E5),
    onSurfaceVariant: const Color(0XffCAC4D0),
    inverseSurface: const Color(0XffE6E1E5),
    inverseOnSurface: const Color(0Xff313033),
    background: const Color(0Xff141218),
    onBackground: const Color(0XffE6E1E5),
    error: const Color(0XffF2B8B5),
    errorContainer: const Color(0Xff8C1D18),
    onError: const Color(0Xff601410),
    onErrorContainer: const Color(0XffF9DEDC),
    outline: const Color(0Xff938F99),
    outlineVariant: const Color(0Xff444746),
    shadow: const Color(0Xff000000),
    scrim: const Color(0Xff000000),

    primaryFixed: const Color(0xffEADDFf),
    primaryFixedDim: const Color(0xffd0bcff),
    onPrimaryFixed: const Color(0xff21005d),
    onPrimaryFixedVariant: const Color(0xff4f378b),

    secondaryFixed: const Color(0xffe8def8),
    secondaryFixedDim: const Color(0xffccc2dc),
    onSecondaryFixed: const Color(0xff1d192b),
    onSecondaryFixedVariant: const Color(0xff4a4458),

    tertiaryFixed: const Color(0xffffd8e4),
    tertiaryFixedDim: const Color(0xffefb8c8),
    onTertiaryFixed: const Color(0xff31111d),
    onTertiaryFixedVariant: const Color(0xff633b48),
  );

  final Palette palette;
  final Brightness brightness;
  final Color primary;
  final Color primaryContainer;
  final Color onPrimary;
  final Color onPrimaryContainer;
  final Color inversePrimary;
  final Color secondary;
  final Color secondaryContainer;
  final Color onSecondary;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color tertiaryContainer;
  final Color onTertiary;
  final Color onTertiaryContainer;
  final Color primaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixed;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixed;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixed;
  final Color onTertiaryFixedVariant;
  final Color surface;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color surfaceVariant;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color background;
  final Color onBackground;
  final Color error;
  final Color errorContainer;
  final Color onError;
  final Color onErrorContainer;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;

  ///
  ColorScheme asDark() {
    if (brightness == Brightness.dark) {
      return this;
    }
    return ColorScheme.fromPalette(
      palette: palette,
      brightness: Brightness.dark,
    );
  }

  ///
  ColorScheme asLight() {
    if (brightness == Brightness.light) {
      return this;
    }
    return ColorScheme.fromPalette(palette: palette);
  }

  ///
  ColorScheme as(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return asLight();
      case ThemeMode.dark:
        return asDark();
      case ThemeMode.system:
        // TODO
        throw Error();
    }
  }

  ///
  flutter.ColorScheme toFlutterColorScheme() {
    return flutter.ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      error: error,
      errorContainer: errorContainer,
      onError: onError,
      background: background,
      onBackground: onBackground,
      surface: surface,
      onSurface: onSurface,
      tertiary: tertiary,
      inversePrimary: inversePrimary,
      inverseSurface: inverseSurface,
      onErrorContainer: onErrorContainer,
      onPrimaryContainer: onPrimaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      onSurfaceVariant: onSurfaceVariant,
      onTertiary: onTertiary,
      onTertiaryContainer: onTertiaryContainer,
      outline: outline,
      outlineVariant: outlineVariant,
      primaryContainer: primaryContainer,
      scrim: scrim,
      secondaryContainer: secondaryContainer,
      shadow: shadow,
      surfaceTint: Color(palette.primary.get(brightness == Brightness.light ? 40 : 80)),
      tertiaryContainer: tertiaryContainer,
      // not supported:
      // primaryVariant: ,
      // secondaryVariant: ,
      // inverseOnSurface: ,
      // surfaceVariant: ,
    );
  }

  static ColorScheme lerp(ColorScheme a, ColorScheme b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return ColorScheme(
      palette: Palette.lerp(a.palette, b.palette, t),
      brightness: t < 0.5 ? a.brightness : b.brightness,
      primary: Color.lerp(a.primary, b.primary, t)!,
      primaryContainer: Color.lerp(a.primaryContainer, b.primaryContainer, t)!,
      onPrimary: Color.lerp(a.onPrimary, b.onPrimary, t)!,
      onPrimaryContainer:
          Color.lerp(a.onPrimaryContainer, b.onPrimaryContainer, t)!,
      inversePrimary: Color.lerp(a.inversePrimary, b.inversePrimary, t)!,
      secondary: Color.lerp(a.secondary, b.secondary, t)!,
      secondaryContainer:
          Color.lerp(a.secondaryContainer, b.secondaryContainer, t)!,
      onSecondary: Color.lerp(a.onSecondary, b.onSecondary, t)!,
      onSecondaryContainer:
          Color.lerp(a.onSecondaryContainer, b.onSecondaryContainer, t)!,
      tertiary: Color.lerp(a.tertiary, b.tertiary, t)!,
      tertiaryContainer:
          Color.lerp(a.tertiaryContainer, b.tertiaryContainer, t)!,
      onTertiary: Color.lerp(a.onTertiary, b.onTertiary, t)!,
      onTertiaryContainer:
          Color.lerp(a.onTertiaryContainer, b.onTertiaryContainer, t)!,
      primaryFixed: Color.lerp(a.primaryFixed, b.primaryFixed, t)!,
      primaryFixedDim: Color.lerp(a.primaryFixedDim, b.primaryFixedDim, t)!,
      onPrimaryFixed: Color.lerp(a.onPrimaryFixed, b.onPrimaryFixed, t)!,
      onPrimaryFixedVariant:
          Color.lerp(a.onPrimaryFixedVariant, b.onPrimaryFixedVariant, t)!,
      secondaryFixed: Color.lerp(a.secondaryFixed, b.secondaryFixed, t)!,
      secondaryFixedDim:
          Color.lerp(a.secondaryFixedDim, b.secondaryFixedDim, t)!,
      onSecondaryFixed: Color.lerp(a.onSecondaryFixed, b.onSecondaryFixed, t)!,
      onSecondaryFixedVariant:
          Color.lerp(a.onSecondaryFixedVariant, b.onSecondaryFixedVariant, t)!,
      tertiaryFixed: Color.lerp(a.tertiaryFixed, b.tertiaryFixed, t)!,
      tertiaryFixedDim: Color.lerp(a.tertiaryFixedDim, b.tertiaryFixedDim, t)!,
      onTertiaryFixed: Color.lerp(a.onTertiaryFixed, b.onTertiaryFixed, t)!,
      onTertiaryFixedVariant:
          Color.lerp(a.onTertiaryFixedVariant, b.onTertiaryFixedVariant, t)!,
      surface: Color.lerp(a.surface, b.surface, t)!,
      surfaceDim: Color.lerp(a.surfaceDim, b.surfaceDim, t)!,
      surfaceBright: Color.lerp(a.surfaceBright, b.surfaceBright, t)!,
      surfaceContainerLowest:
          Color.lerp(a.surfaceContainerLowest, b.surfaceContainerLowest, t)!,
      surfaceContainerLow:
          Color.lerp(a.surfaceContainerLow, b.surfaceContainerLow, t)!,
      surfaceContainer: Color.lerp(a.surfaceContainer, b.surfaceContainer, t)!,
      surfaceContainerHigh:
          Color.lerp(a.surfaceContainerHigh, b.surfaceContainerHigh, t)!,
      surfaceContainerHighest:
          Color.lerp(a.surfaceContainerHighest, b.surfaceContainerHighest, t)!,
      surfaceVariant: Color.lerp(a.surfaceVariant, b.surfaceVariant, t)!,
      onSurface: Color.lerp(a.onSurface, b.onSurface, t)!,
      onSurfaceVariant: Color.lerp(a.onSurfaceVariant, b.onSurfaceVariant, t)!,
      inverseSurface: Color.lerp(a.inverseSurface, b.inverseSurface, t)!,
      inverseOnSurface: Color.lerp(a.inverseOnSurface, b.inverseOnSurface, t)!,
      background: Color.lerp(a.background, b.background, t)!,
      onBackground: Color.lerp(a.onBackground, b.onBackground, t)!,
      error: Color.lerp(a.error, b.error, t)!,
      errorContainer: Color.lerp(a.errorContainer, b.errorContainer, t)!,
      onError: Color.lerp(a.onError, b.onError, t)!,
      onErrorContainer: Color.lerp(a.onErrorContainer, b.onErrorContainer, t)!,
      outline: Color.lerp(a.outline, b.outline, t)!,
      outlineVariant: Color.lerp(a.outlineVariant, b.outlineVariant, t)!,
      shadow: Color.lerp(a.shadow, b.shadow, t)!,
      scrim: Color.lerp(a.scrim, b.scrim, t)!,
    );
  }

  ColorScheme copyWith({
    Palette? palette,
    Brightness? brightness,
    Color? primary,
    Color? primaryContainer,
    Color? onPrimary,
    Color? onPrimaryContainer,
    Color? inversePrimary,
    Color? secondary,
    Color? secondaryContainer,
    Color? onSecondary,
    Color? onSecondaryContainer,
    Color? tertiary,
    Color? tertiaryContainer,
    Color? onTertiary,
    Color? onTertiaryContainer,
    Color? primaryFixed,
    Color? primaryFixedDim,
    Color? onPrimaryFixed,
    Color? onPrimaryFixedVariant,
    Color? secondaryFixed,
    Color? secondaryFixedDim,
    Color? onSecondaryFixed,
    Color? onSecondaryFixedVariant,
    Color? tertiaryFixed,
    Color? tertiaryFixedDim,
    Color? onTertiaryFixed,
    Color? onTertiaryFixedVariant,
    Color? surface,
    Color? surfaceDim,
    Color? surfaceBright,
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? surfaceVariant,
    Color? onSurface,
    Color? onSurfaceVariant,
    Color? inverseSurface,
    Color? inverseOnSurface,
    Color? background,
    Color? onBackground,
    Color? error,
    Color? errorContainer,
    Color? onError,
    Color? onErrorContainer,
    Color? outline,
    Color? outlineVariant,
    Color? shadow,
    Color? surfaceTint,
    Color? scrim,
  }) {
    return ColorScheme(
      palette: palette ?? this.palette,
      brightness: brightness ?? this.brightness,
      primary: primary ?? this.primary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimary: onPrimary ?? this.onPrimary,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      inversePrimary: inversePrimary ?? this.inversePrimary,
      secondary: secondary ?? this.secondary,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      onSecondary: onSecondary ?? this.onSecondary,
      onSecondaryContainer: onSecondaryContainer ?? this.onSecondaryContainer,
      tertiary: tertiary ?? this.tertiary,
      tertiaryContainer: tertiaryContainer ?? this.tertiaryContainer,
      onTertiary: onTertiary ?? this.onTertiary,
      onTertiaryContainer: onTertiaryContainer ?? this.onTertiaryContainer,
      primaryFixed: primaryFixed ?? this.primaryFixed,
      primaryFixedDim: primaryFixedDim ?? this.primaryFixedDim,
      onPrimaryFixed: onPrimaryFixed ?? this.onPrimaryFixed,
      onPrimaryFixedVariant:
          onPrimaryFixedVariant ?? this.onPrimaryFixedVariant,
      secondaryFixed: secondaryFixed ?? this.secondaryFixed,
      secondaryFixedDim: secondaryFixedDim ?? this.secondaryFixedDim,
      onSecondaryFixed: onSecondaryFixed ?? this.onSecondaryFixed,
      onSecondaryFixedVariant:
          onSecondaryFixedVariant ?? this.onSecondaryFixedVariant,
      tertiaryFixed: tertiaryFixed ?? this.tertiaryFixed,
      tertiaryFixedDim: tertiaryFixedDim ?? this.tertiaryFixedDim,
      onTertiaryFixed: onTertiaryFixed ?? this.onTertiaryFixed,
      onTertiaryFixedVariant:
          onTertiaryFixedVariant ?? this.onTertiaryFixedVariant,
      surface: surface ?? this.surface,
      surfaceDim: surfaceDim ?? this.surfaceDim,
      surfaceBright: surfaceBright ?? this.surfaceBright,
      surfaceContainerLowest:
          surfaceContainerLowest ?? this.surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      surfaceContainerHighest:
          surfaceContainerHighest ?? this.surfaceContainerHighest,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      inverseSurface: inverseSurface ?? this.inverseSurface,
      inverseOnSurface: inverseOnSurface ?? this.inverseOnSurface,
      background: background ?? this.background,
      onBackground: onBackground ?? this.onBackground,
      error: error ?? this.error,
      errorContainer: errorContainer ?? this.errorContainer,
      onError: onError ?? this.onError,
      onErrorContainer: onErrorContainer ?? this.onErrorContainer,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      shadow: shadow ?? this.shadow,
      scrim: scrim ?? this.scrim,
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
    return other is ColorScheme &&
        other.palette == palette &&
        other.brightness == brightness &&
        other.primary == primary &&
        other.primaryContainer == primaryContainer &&
        other.onPrimary == onPrimary &&
        other.onPrimaryContainer == onPrimaryContainer &&
        other.inversePrimary == inversePrimary &&
        other.secondary == secondary &&
        other.secondaryContainer == secondaryContainer &&
        other.onSecondary == onSecondary &&
        other.onSecondaryContainer == onSecondaryContainer &&
        other.tertiary == tertiary &&
        other.tertiaryContainer == tertiaryContainer &&
        other.onTertiary == onTertiary &&
        other.onTertiaryContainer == onTertiaryContainer &&
        other.primaryFixed == primaryFixed &&
        other.primaryFixedDim == primaryFixedDim &&
        other.onPrimaryFixed == onPrimaryFixed &&
        other.onPrimaryFixedVariant == onPrimaryFixedVariant &&
        other.secondaryFixed == secondaryFixed &&
        other.secondaryFixedDim == secondaryFixedDim &&
        other.onSecondaryFixed == onSecondaryFixed &&
        other.onSecondaryFixedVariant == onSecondaryFixedVariant &&
        other.tertiaryFixed == tertiaryFixed &&
        other.tertiaryFixedDim == tertiaryFixedDim &&
        other.onTertiaryFixed == onTertiaryFixed &&
        other.onTertiaryFixedVariant == onTertiaryFixedVariant &&
        other.surface == surface &&
        other.surfaceDim == surfaceDim &&
        other.surfaceBright == surfaceBright &&
        other.surfaceContainerLowest == surfaceContainerLowest &&
        other.surfaceContainerLow == surfaceContainerLow &&
        other.surfaceContainer == surfaceContainer &&
        other.surfaceContainerHigh == surfaceContainerHigh &&
        other.surfaceContainerHighest == surfaceContainerHighest &&
        other.surfaceVariant == surfaceVariant &&
        other.onSurface == onSurface &&
        other.onSurfaceVariant == onSurfaceVariant &&
        other.inverseSurface == inverseSurface &&
        other.inverseOnSurface == inverseOnSurface &&
        other.background == background &&
        other.onBackground == onBackground &&
        other.error == error &&
        other.errorContainer == errorContainer &&
        other.onError == onError &&
        other.onErrorContainer == onErrorContainer &&
        other.outline == outline &&
        other.outlineVariant == outlineVariant &&
        other.shadow == shadow &&
        other.scrim == scrim;
  }

  @override
  int get hashCode => Object.hashAll([
        palette,
        brightness,
        primary,
        primaryContainer,
        onPrimary,
        onPrimaryContainer,
        inversePrimary,
        secondary,
        secondaryContainer,
        onSecondary,
        onSecondaryContainer,
        tertiary,
        tertiaryContainer,
        onTertiary,
        onTertiaryContainer,
        primaryFixed,
        primaryFixedDim,
        onPrimaryFixed,
        onPrimaryFixedVariant,
        secondaryFixed,
        secondaryFixedDim,
        onSecondaryFixed,
        onSecondaryFixedVariant,
        tertiaryFixed,
        tertiaryFixedDim,
        onTertiaryFixed,
        onTertiaryFixedVariant,
        surface,
        surfaceDim,
        surfaceBright,
        surfaceContainerLowest,
        surfaceContainerLow,
        surfaceContainer,
        surfaceContainerHigh,
        surfaceContainerHighest,
        surfaceVariant,
        onSurface,
        onSurfaceVariant,
        inverseSurface,
        inverseOnSurface,
        background,
        onBackground,
        error,
        errorContainer,
        onError,
        onErrorContainer,
        outline,
        outlineVariant,
        shadow,
        scrim,
      ]);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final ColorScheme defaultScheme = ColorScheme.m3DefaultLight;
    properties.add(DiagnosticsProperty<Palette>('palette', palette,
        defaultValue: defaultScheme.palette));
    properties.add(DiagnosticsProperty<Brightness>('brightness', brightness,
        defaultValue: defaultScheme.brightness));
    properties.add(
        ColorProperty('primary', primary, defaultValue: defaultScheme.primary));
    properties.add(ColorProperty('primaryContainer', primaryContainer,
        defaultValue: defaultScheme.primaryContainer));
    properties.add(ColorProperty('onPrimary', onPrimary,
        defaultValue: defaultScheme.onPrimary));
    properties.add(ColorProperty('onPrimaryContainer', onPrimaryContainer,
        defaultValue: defaultScheme.onPrimaryContainer));
    properties.add(ColorProperty('inversePrimary', inversePrimary,
        defaultValue: defaultScheme.inversePrimary));
    properties.add(ColorProperty('secondary', secondary,
        defaultValue: defaultScheme.secondary));
    properties.add(ColorProperty('secondaryContainer', secondaryContainer,
        defaultValue: defaultScheme.secondaryContainer));
    properties.add(ColorProperty('onSecondary', onSecondary,
        defaultValue: defaultScheme.onSecondary));
    properties.add(ColorProperty('onSecondaryContainer', onSecondaryContainer,
        defaultValue: defaultScheme.onSecondaryContainer));
    properties.add(ColorProperty('tertiary', tertiary,
        defaultValue: defaultScheme.tertiary));
    properties.add(ColorProperty('tertiaryContainer', tertiaryContainer,
        defaultValue: defaultScheme.tertiaryContainer));
    properties.add(ColorProperty('onTertiary', onTertiary,
        defaultValue: defaultScheme.onTertiary));
    properties.add(ColorProperty('onTertiaryContainer', onTertiaryContainer,
        defaultValue: defaultScheme.onTertiaryContainer));
    properties.add(ColorProperty('primaryFixed', primaryFixed,
        defaultValue: defaultScheme.primaryFixed));
    properties.add(ColorProperty('primaryFixedDim', primaryFixedDim,
        defaultValue: defaultScheme.primaryFixedDim));
    properties.add(ColorProperty('onPrimaryFixed', onPrimaryFixed,
        defaultValue: defaultScheme.onPrimaryFixed));
    properties.add(ColorProperty('onPrimaryFixedVariant', onPrimaryFixedVariant,
        defaultValue: defaultScheme.onPrimaryFixedVariant));
    properties.add(ColorProperty('secondaryFixed', secondaryFixed,
        defaultValue: defaultScheme.secondaryFixed));
    properties.add(ColorProperty('secondaryFixedDim', secondaryFixedDim,
        defaultValue: defaultScheme.secondaryFixedDim));
    properties.add(ColorProperty('onSecondaryFixed', onSecondaryFixed,
        defaultValue: defaultScheme.onSecondaryFixed));
    properties.add(ColorProperty(
        'onSecondaryFixedVariant', onSecondaryFixedVariant,
        defaultValue: defaultScheme.onSecondaryFixedVariant));
    properties.add(ColorProperty('tertiaryFixed', tertiaryFixed,
        defaultValue: defaultScheme.tertiaryFixed));
    properties.add(ColorProperty('tertiaryFixedDim', tertiaryFixedDim,
        defaultValue: defaultScheme.tertiaryFixedDim));
    properties.add(ColorProperty('onTertiaryFixed', onTertiaryFixed,
        defaultValue: defaultScheme.onTertiaryFixed));
    properties.add(ColorProperty(
        'onTertiaryFixedVariant', onTertiaryFixedVariant,
        defaultValue: defaultScheme.onTertiaryFixedVariant));
    properties.add(
        ColorProperty('surface', surface, defaultValue: defaultScheme.surface));
    properties.add(ColorProperty('surfaceDim', surfaceDim,
        defaultValue: defaultScheme.surfaceDim));
    properties.add(ColorProperty('surfaceBright', surfaceBright,
        defaultValue: defaultScheme.surfaceBright));
    properties.add(ColorProperty(
        'surfaceContainerLowest', surfaceContainerLowest,
        defaultValue: defaultScheme.surfaceContainerLowest));
    properties.add(ColorProperty('surfaceContainerLow', surfaceContainerLow,
        defaultValue: defaultScheme.surfaceContainerLow));
    properties.add(ColorProperty('surfaceContainer', surfaceContainer,
        defaultValue: defaultScheme.surfaceContainer));
    properties.add(ColorProperty('surfaceContainerHigh', surfaceContainerHigh,
        defaultValue: defaultScheme.surfaceContainerHigh));
    properties.add(ColorProperty(
        'surfaceContainerHighest', surfaceContainerHighest,
        defaultValue: defaultScheme.surfaceContainerHighest));
    properties.add(ColorProperty('surfaceVariant', surfaceVariant,
        defaultValue: defaultScheme.surfaceVariant));
    properties.add(ColorProperty('onSurface', onSurface,
        defaultValue: defaultScheme.onSurface));
    properties.add(ColorProperty('onSurfaceVariant', onSurfaceVariant,
        defaultValue: defaultScheme.onSurfaceVariant));
    properties.add(ColorProperty('inverseSurface', inverseSurface,
        defaultValue: defaultScheme.inverseSurface));
    properties.add(ColorProperty('inverseOnSurface', inverseOnSurface,
        defaultValue: defaultScheme.inverseOnSurface));
    properties.add(ColorProperty('background', background,
        defaultValue: defaultScheme.background));
    properties.add(ColorProperty('onBackground', onBackground,
        defaultValue: defaultScheme.onBackground));
    properties
        .add(ColorProperty('error', error, defaultValue: defaultScheme.error));
    properties.add(ColorProperty('errorContainer', errorContainer,
        defaultValue: defaultScheme.errorContainer));
    properties.add(
        ColorProperty('onError', onError, defaultValue: defaultScheme.onError));
    properties.add(ColorProperty('onErrorContainer', onErrorContainer,
        defaultValue: defaultScheme.onErrorContainer));
    properties.add(
        ColorProperty('outline', outline, defaultValue: defaultScheme.outline));
    properties.add(ColorProperty('outlineVariant', outlineVariant,
        defaultValue: defaultScheme.outlineVariant));
    properties.add(
        ColorProperty('shadow', shadow, defaultValue: defaultScheme.shadow));
    properties
        .add(ColorProperty('scrim', scrim, defaultValue: defaultScheme.scrim));
  }

  /// Generate a [ColorScheme] derived from the given `imageProvider`.
  ///
  /// Material Color Utilities extracts the dominant color from the
  /// supplied [ImageProvider]. Using this color, a set of tonal palettes are
  /// constructed. These tonal palettes are based on the Material 3 Color
  /// system and provide all the needed colors for a [ColorScheme]. These
  /// colors are designed to work well together and meet contrast
  /// requirements for accessibility.
  ///
  /// If any of the optional color parameters are non-null, they will be
  /// used in place of the generated colors for that field in the resulting
  /// color scheme. This allows apps to override specific colors for their
  /// needs.
  ///
  /// Given the nature of the algorithm, the most dominant color of the
  /// `imageProvider` may not wind up as one of the ColorScheme colors.
  ///
  /// The provided image will be scaled down to a maximum size of 112x112 pixels
  /// during color extraction.
  ///
  /// See also:
  ///
  ///  * <https://m3.material.io/styles/color/the-color-system/color-roles>, the
  ///    Material 3 Color system specification.
  ///  * <https://pub.dev/packages/material_color_utilities>, the package
  ///    used to generate the base color and tonal palettes needed for the scheme.
  static Future<ColorScheme> fromImageProvider({
    required ImageProvider provider,
    Brightness brightness = Brightness.light,
  }) async {
    // Extract dominant colors from image.
    final QuantizerResult quantizerResult =
        await _extractColorsFromImageProvider(provider);
    final Map<int, int> colorToCount = quantizerResult.colorToCount.map(
      (int key, int value) => MapEntry<int, int>(_getArgbFromAbgr(key), value),
    );

    // Score colors for color scheme suitability.
    final List<int> scoredResults = Score.score(colorToCount, desired: 1);

    return ColorScheme.fromPalette(
      palette: Palette.fromCorePalette(CorePalette.of(scoredResults.first)),
      brightness: brightness,
    );
  }

  // ColorScheme.fromImageProvider() utilities.

  // Extracts bytes from an [ImageProvider] and returns a [QuantizerResult]
  // containing the most dominant colors.
  static Future<QuantizerResult> _extractColorsFromImageProvider(
      ImageProvider imageProvider) async {
    final ui.Image scaledImage = await _imageProviderToScaled(imageProvider);
    final ByteData? imageBytes = await scaledImage.toByteData();

    final QuantizerResult quantizerResult = await QuantizerCelebi().quantize(
      imageBytes!.buffer.asUint32List(),
      128,
      returnInputPixelToClusterPixel: true,
    );
    return quantizerResult;
  }

  // Scale image size down to reduce computation time of color extraction.
  static Future<ui.Image> _imageProviderToScaled(
      ImageProvider imageProvider) async {
    const double maxDimension = 112.0;
    final ImageStream stream = imageProvider.resolve(
        const ImageConfiguration(size: Size(maxDimension, maxDimension)));
    final Completer<ui.Image> imageCompleter = Completer<ui.Image>();
    late ImageStreamListener listener;
    late ui.Image scaledImage;
    Timer? loadFailureTimeout;

    listener = ImageStreamListener((ImageInfo info, bool sync) async {
      loadFailureTimeout?.cancel();
      stream.removeListener(listener);
      final ui.Image image = info.image;
      final int width = image.width;
      final int height = image.height;
      double paintWidth = width.toDouble();
      double paintHeight = height.toDouble();
      assert(width > 0 && height > 0);

      final bool rescale = width > maxDimension || height > maxDimension;
      if (rescale) {
        paintWidth =
            (width > height) ? maxDimension : (maxDimension / height) * width;
        paintHeight =
            (height > width) ? maxDimension : (maxDimension / width) * height;
      }
      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);
      paintImage(
          canvas: canvas,
          rect: Rect.fromLTRB(0, 0, paintWidth, paintHeight),
          image: image,
          filterQuality: FilterQuality.none);

      final ui.Picture picture = pictureRecorder.endRecording();
      scaledImage =
          await picture.toImage(paintWidth.toInt(), paintHeight.toInt());
      imageCompleter.complete(info.image);
    }, onError: (Object exception, StackTrace? stackTrace) {
      stream.removeListener(listener);
      throw Exception('Failed to render image: $exception');
    });

    loadFailureTimeout = Timer(const Duration(seconds: 5), () {
      stream.removeListener(listener);
      imageCompleter.completeError(
          TimeoutException('Timeout occurred trying to load image'));
    });

    stream.addListener(listener);
    await imageCompleter.future;
    return scaledImage;
  }

  // Converts AABBGGRR color int to AARRGGBB format.
  static int _getArgbFromAbgr(int abgr) {
    const int exceptRMask = 0xFF00FFFF;
    const int onlyRMask = ~exceptRMask;
    const int exceptBMask = 0xFFFFFF00;
    const int onlyBMask = ~exceptBMask;
    final int r = (abgr & onlyRMask) >> 16;
    final int b = abgr & onlyBMask;
    return (abgr & exceptRMask & exceptBMask) | (b << 16) | r;
  }
}

// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:typed_data';

import 'package:alternative_material_3/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'core/image_data.dart';
import 'flutter_test/extensions.dart';

void main() {
  test('ColorScheme lerp special cases', () {
    final ColorScheme scheme = ColorScheme.m3DefaultLight;
    expect(identical(ColorScheme.lerp(scheme, scheme, 0.5), scheme), true);
  });

  test('light scheme matches the spec', () {
    // Colors should match the Material Design baseline default light theme:
    // https://m3.material.io/styles/color/the-color-system/tokens.
    final ColorScheme scheme = ColorScheme.m3DefaultLight;
    expect(scheme.primary, ColorMatcher(const Color(0Xff6750A4)));
    expect(scheme.primaryContainer, ColorMatcher(const Color(0XffEADDFF)));
    expect(scheme.onPrimary, ColorMatcher(const Color(0XffFFFFFF)));
    expect(scheme.onPrimaryContainer, ColorMatcher(const Color(0Xff21005E)));
    expect(scheme.inversePrimary, ColorMatcher(const Color(0XffD0BCFF)));
    expect(scheme.secondary, ColorMatcher(const Color(0Xff625B71)));
    expect(scheme.secondaryContainer, ColorMatcher(const Color(0XffE8DEF8)));
    expect(scheme.onSecondary, ColorMatcher(const Color(0XffFFFFFF)));
    expect(scheme.onSecondaryContainer, ColorMatcher(const Color(0Xff1E192B)));
    expect(scheme.tertiary, ColorMatcher(const Color(0Xff7D5260)));
    expect(scheme.tertiaryContainer, ColorMatcher(const Color(0XffFFD8E4)));
    expect(scheme.onTertiary, ColorMatcher(const Color(0XffFFFFFF)));
    expect(scheme.onTertiaryContainer, ColorMatcher(const Color(0Xff370B1E)));
    expect(scheme.surface, ColorMatcher(const Color(0XffFEF7FF)));
    expect(scheme.surfaceDim, ColorMatcher(const Color(0XffDED8E1)));
    expect(scheme.surfaceBright, ColorMatcher(const Color(0XffFEF7FF)));
    expect(scheme.surfaceContainerLowest, ColorMatcher(const Color(0XffFFFFFF)));
    expect(scheme.surfaceContainerLow, ColorMatcher(const Color(0XffF7F2FA)));
    expect(scheme.surfaceContainer, ColorMatcher(const Color(0XffF3EDF7)));
    expect(scheme.surfaceContainerHigh, ColorMatcher(const Color(0XffECE6F0)));
    expect(scheme.surfaceContainerHighest, ColorMatcher(const Color(0XffE6E0E9)));
    expect(scheme.surfaceVariant, ColorMatcher(const Color(0XffE7E0EC)));
    expect(scheme.onSurface, ColorMatcher(const Color(0Xff1C1B1F)));
    expect(scheme.onSurfaceVariant, ColorMatcher(const Color(0Xff49454E)));
    expect(scheme.inverseSurface, ColorMatcher(const Color(0Xff313033)));
    expect(scheme.inverseOnSurface, ColorMatcher(const Color(0XffF4EFF4)));
    expect(scheme.background, ColorMatcher(const Color(0XffFEF7FF)));
    expect(scheme.onBackground, ColorMatcher(const Color(0Xff1C1B1F)));
    expect(scheme.error, ColorMatcher(const Color(0XffB3261E)));
    expect(scheme.errorContainer, ColorMatcher(const Color(0XffF9DEDC)));
    expect(scheme.onError, ColorMatcher(const Color(0XffFFFFFF)));
    expect(scheme.onErrorContainer, ColorMatcher(const Color(0Xff410E0B)));
    expect(scheme.outline, ColorMatcher(const Color(0Xff79747E)));
    expect(scheme.outlineVariant, ColorMatcher(const Color(0XffC4C7C5)));
    expect(scheme.shadow, ColorMatcher(const Color(0Xff000000)));
    expect(scheme.surfaceTint, ColorMatcher(const Color(0Xff6750A4)));
    expect(scheme.scrim, ColorMatcher(const Color(0Xff000000)));
  });

  test('dark scheme matches the spec', () {
    // Colors should match the Material Design baseline dark theme:
    // https://m3.material.io/styles/color/the-color-system/tokens
    final ColorScheme scheme = ColorScheme.m3DefaultDark;
    expect(scheme.brightness, Brightness.dark);
    expect(scheme.primary, ColorMatcher(const Color(0XffD0BCFF)));
    expect(scheme.primaryContainer, ColorMatcher(const Color(0Xff4F378B)));
    expect(scheme.onPrimary, ColorMatcher(const Color(0Xff371E73)));
    expect(scheme.onPrimaryContainer, ColorMatcher(const Color(0XffEADDFF)));
    expect(scheme.inversePrimary, ColorMatcher(const Color(0Xff6750A4)));
    expect(scheme.secondary, ColorMatcher(const Color(0XffCCC2DC)));
    expect(scheme.secondaryContainer, ColorMatcher(const Color(0Xff4A4458)));
    expect(scheme.onSecondary, ColorMatcher(const Color(0Xff332D41)));
    expect(scheme.onSecondaryContainer, ColorMatcher(const Color(0XffE8DEF8)));
    expect(scheme.tertiary, ColorMatcher(const Color(0XffEFB8C8)));
    expect(scheme.tertiaryContainer, ColorMatcher(const Color(0Xff633B48)));
    expect(scheme.onTertiary, ColorMatcher(const Color(0Xff492532)));
    expect(scheme.onTertiaryContainer, ColorMatcher(const Color(0XffFFD8E4)));
    expect(scheme.surface, ColorMatcher(const Color(0Xff141218)));
    expect(scheme.surfaceDim, ColorMatcher(const Color(0Xff141218)));
    expect(scheme.surfaceBright, ColorMatcher(const Color(0Xff3B383E)));
    expect(scheme.surfaceContainerLowest, ColorMatcher(const Color(0Xff0F0D13)));
    expect(scheme.surfaceContainerLow, ColorMatcher(const Color(0Xff1D1B20)));
    expect(scheme.surfaceContainer, ColorMatcher(const Color(0Xff211F26)));
    expect(scheme.surfaceContainerHigh, ColorMatcher(const Color(0Xff2B2930)));
    expect(scheme.surfaceContainerHighest, ColorMatcher(const Color(0Xff36343B)));
    expect(scheme.surfaceVariant, ColorMatcher(const Color(0Xff49454F)));
    expect(scheme.onSurface, ColorMatcher(const Color(0XffE6E1E5)));
    expect(scheme.onSurfaceVariant, ColorMatcher(const Color(0XffCAC4D0)));
    expect(scheme.inverseSurface, ColorMatcher(const Color(0XffE6E1E5)));
    expect(scheme.inverseOnSurface, ColorMatcher(const Color(0Xff313033)));
    expect(scheme.background, ColorMatcher(const Color(0Xff141218)));
    expect(scheme.onBackground, ColorMatcher(const Color(0XffE6E1E5)));
    expect(scheme.error, ColorMatcher(const Color(0XffF2B8B5)));
    expect(scheme.errorContainer, ColorMatcher(const Color(0Xff8C1D18)));
    expect(scheme.onError, ColorMatcher(const Color(0Xff601410)));
    expect(scheme.onErrorContainer, ColorMatcher(const Color(0XffF9DEDC)));
    expect(scheme.outline, ColorMatcher(const Color(0Xff938F99)));
    expect(scheme.outlineVariant, ColorMatcher(const Color(0Xff444746)));
    expect(scheme.shadow, ColorMatcher(const Color(0Xff000000)));
    expect(scheme.surfaceTint, ColorMatcher(const Color(0XffD0BCFF)));
    expect(scheme.scrim, ColorMatcher(const Color(0Xff000000)));
  });

  test('can generate a light scheme from a seed color', () {
    final ColorScheme scheme = ColorScheme.fromSeed(seedColor: Colors.blue);
    expect(scheme.primary, ColorMatcher(const Color(0xff0061a4)));
    expect(scheme.onPrimary, ColorMatcher(const Color(0xffffffff)));
    expect(scheme.primaryContainer, ColorMatcher(const Color(0xffd1e4ff)));
    expect(scheme.onPrimaryContainer, ColorMatcher(const Color(0xff001d36)));
    expect(scheme.secondary, ColorMatcher(const Color(0xff535f70)));
    expect(scheme.onSecondary, ColorMatcher(const Color(0xffffffff)));
    expect(scheme.secondaryContainer, ColorMatcher(const Color(0xffd7e3f7)));
    expect(scheme.onSecondaryContainer, ColorMatcher(const Color(0xff101c2b)));
    expect(scheme.tertiary, ColorMatcher(const Color(0xff6b5778)));
    expect(scheme.onTertiary, ColorMatcher(const Color(0xffffffff)));
    expect(scheme.tertiaryContainer, ColorMatcher(const Color(0xfff2daff)));
    expect(scheme.onTertiaryContainer, ColorMatcher(const Color(0xff251431)));
    expect(scheme.error, ColorMatcher(const Color(0xffba1a1a)));
    expect(scheme.onError, ColorMatcher(const Color(0xffffffff)));
    expect(scheme.errorContainer, ColorMatcher(const Color(0xffffdad6)));
    expect(scheme.onErrorContainer, ColorMatcher(const Color(0xff410002)));
    expect(scheme.outline, ColorMatcher(const Color(0xff73777f)));
    expect(scheme.outlineVariant, ColorMatcher(const Color(0xffc3c7cf)));
    expect(scheme.background, ColorMatcher(const Color(0xfffaf9fc)));
    expect(scheme.onBackground, ColorMatcher(const Color(0xff1a1c1e)));
    expect(scheme.surface, ColorMatcher(const Color(0xfffaf9fc)));
    expect(scheme.onSurface, ColorMatcher(const Color(0xff1a1c1e)));
    expect(scheme.surfaceVariant, ColorMatcher(const Color(0xffdfe2eb)));
    expect(scheme.onSurfaceVariant, ColorMatcher(const Color(0xff43474e)));
    expect(scheme.inverseSurface, ColorMatcher(const Color(0xff2f3033)));
    expect(scheme.inverseOnSurface, ColorMatcher(const Color(0xfff1f0f4)));
    expect(scheme.inversePrimary, ColorMatcher(const Color(0xff9ecaff)));
    expect(scheme.shadow, ColorMatcher(const Color(0xff000000)));
    expect(scheme.scrim, ColorMatcher(const Color(0xff000000)));
    expect(scheme.surfaceTint, ColorMatcher(const Color(0xff0061a4)));
    expect(scheme.brightness, Brightness.light);
  });

  test('copyWith overrides given colors', () {
    final ColorScheme scheme = ColorScheme.m3DefaultLight.copyWith(
        brightness: Brightness.dark,
        primary: const Color(0x00000001),
        onPrimary: const Color(0x00000002),
        primaryContainer: const Color(0x00000003),
        onPrimaryContainer: const Color(0x00000004),
        secondary: const Color(0x00000005),
        onSecondary: const Color(0x00000006),
        secondaryContainer: const Color(0x00000007),
        onSecondaryContainer: const Color(0x00000008),
        tertiary: const Color(0x00000009),
        onTertiary: const Color(0x0000000A),
        tertiaryContainer: const Color(0x0000000B),
        onTertiaryContainer: const Color(0x0000000C),
        error: const Color(0x0000000D),
        onError: const Color(0x0000000E),
        errorContainer: const Color(0x0000000F),
        onErrorContainer: const Color(0x00000010),
        background: const Color(0x00000011),
        onBackground: const Color(0x00000012),
        surface: const Color(0x00000013),
        onSurface: const Color(0x00000014),
        surfaceVariant: const Color(0x00000015),
        onSurfaceVariant: const Color(0x00000016),
        outline: const Color(0x00000017),
        outlineVariant: const Color(0x00000117),
        shadow: const Color(0x00000018),
        scrim: const Color(0x00000118),
        inverseSurface: const Color(0x00000019),
        inverseOnSurface: const Color(0x0000001A),
        inversePrimary: const Color(0x0000001B),
        surfaceTint: const Color(0x0000001C),
    );

    expect(scheme.brightness, Brightness.dark);
    expect(scheme.primary, ColorMatcher(const Color(0x00000001)));
    expect(scheme.onPrimary, ColorMatcher(const Color(0x00000002)));
    expect(scheme.primaryContainer, ColorMatcher(const Color(0x00000003)));
    expect(scheme.onPrimaryContainer, ColorMatcher(const Color(0x00000004)));
    expect(scheme.secondary, ColorMatcher(const Color(0x00000005)));
    expect(scheme.onSecondary, ColorMatcher(const Color(0x00000006)));
    expect(scheme.secondaryContainer, ColorMatcher(const Color(0x00000007)));
    expect(scheme.onSecondaryContainer, ColorMatcher(const Color(0x00000008)));
    expect(scheme.tertiary, ColorMatcher(const Color(0x00000009)));
    expect(scheme.onTertiary, ColorMatcher(const Color(0x0000000A)));
    expect(scheme.tertiaryContainer, ColorMatcher(const Color(0x0000000B)));
    expect(scheme.onTertiaryContainer, ColorMatcher(const Color(0x0000000C)));
    expect(scheme.error, ColorMatcher(const Color(0x0000000D)));
    expect(scheme.onError, ColorMatcher(const Color(0x0000000E)));
    expect(scheme.errorContainer, ColorMatcher(const Color(0x0000000F)));
    expect(scheme.onErrorContainer, ColorMatcher(const Color(0x00000010)));
    expect(scheme.background, ColorMatcher(const Color(0x00000011)));
    expect(scheme.onBackground, ColorMatcher(const Color(0x00000012)));
    expect(scheme.surface, ColorMatcher(const Color(0x00000013)));
    expect(scheme.onSurface, ColorMatcher(const Color(0x00000014)));
    expect(scheme.surfaceVariant, ColorMatcher(const Color(0x00000015)));
    expect(scheme.onSurfaceVariant, ColorMatcher(const Color(0x00000016)));
    expect(scheme.outline, ColorMatcher(const Color(0x00000017)));
    expect(scheme.outlineVariant, ColorMatcher(const Color(0x00000117)));
    expect(scheme.shadow, ColorMatcher(const Color(0x00000018)));
    expect(scheme.scrim, ColorMatcher(const Color(0x00000118)));
    expect(scheme.inverseSurface, ColorMatcher(const Color(0x00000019)));
    expect(scheme.inverseOnSurface, ColorMatcher(const Color(0x0000001A)));
    expect(scheme.inversePrimary, ColorMatcher(const Color(0x0000001B)));
    expect(scheme.surfaceTint, ColorMatcher(const Color(0x0000001C)));
  });

  test('can generate a dark scheme from a seed color', () {
    final ColorScheme scheme = ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark);
    expect(scheme.primary, ColorMatcher(const Color(0xff9ecaff)));
    expect(scheme.onPrimary, ColorMatcher(const Color(0xff003258)));
    expect(scheme.primaryContainer, ColorMatcher(const Color(0xff00497d)));
    expect(scheme.onPrimaryContainer, ColorMatcher(const Color(0xffd1e4ff)));
    expect(scheme.secondary, ColorMatcher(const Color(0xffbbc7db)));
    expect(scheme.onSecondary, ColorMatcher(const Color(0xff253140)));
    expect(scheme.secondaryContainer, ColorMatcher(const Color(0xff3b4858)));
    expect(scheme.onSecondaryContainer, ColorMatcher(const Color(0xffd7e3f7)));
    expect(scheme.tertiary, ColorMatcher(const Color(0xffd6bee4)));
    expect(scheme.onTertiary, ColorMatcher(const Color(0xff3b2948)));
    expect(scheme.tertiaryContainer, ColorMatcher(const Color(0xff523f5f)));
    expect(scheme.onTertiaryContainer, ColorMatcher(const Color(0xfff2daff)));
    expect(scheme.error, ColorMatcher(const Color(0xffffb4ab)));
    expect(scheme.onError, ColorMatcher(const Color(0xff690005)));
    expect(scheme.errorContainer, ColorMatcher(const Color(0xff93000a)));
    expect(scheme.onErrorContainer, ColorMatcher(const Color(0xffffdad6)));
    expect(scheme.outline, ColorMatcher(const Color(0xff8d9199)));
    expect(scheme.outlineVariant, ColorMatcher(const Color(0xff43474e)));
    expect(scheme.background, ColorMatcher(const Color(0xff131316)));
    expect(scheme.onBackground, ColorMatcher(const Color(0xffe2e2e6)));
    expect(scheme.surface, ColorMatcher(const Color(0xff121316)));
    expect(scheme.onSurface, ColorMatcher(const Color(0xffe2e2e6)));
    expect(scheme.surfaceVariant, ColorMatcher(const Color(0xff43474e)));
    expect(scheme.onSurfaceVariant, ColorMatcher(const Color(0xffc3c7cf)));
    expect(scheme.inverseSurface, ColorMatcher(const Color(0xffe2e2e6)));
    expect(scheme.inverseOnSurface, ColorMatcher(const Color(0xff2f3033)));
    expect(scheme.inversePrimary, ColorMatcher(const Color(0xff0061a4)));
    expect(scheme.shadow, ColorMatcher(const Color(0xff000000)));
    expect(scheme.scrim, ColorMatcher(const Color(0xff000000)));
    expect(scheme.surfaceTint, ColorMatcher(const Color(0xff9ecaff)));
    expect(scheme.brightness, Brightness.dark);
  });

  test('can override specific colors in a generated scheme', () {
    final ColorScheme baseScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
    const Color primaryOverride = Color(0xffabcdef);
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: Colors.blue,
    ).copyWith(
      primary: primaryOverride,
    );
    expect(scheme.primary, primaryOverride);
    // The rest should be the same.
    expect(scheme.onPrimary, baseScheme.onPrimary);
    expect(scheme.primaryContainer, baseScheme.primaryContainer);
    expect(scheme.onPrimaryContainer, baseScheme.onPrimaryContainer);
    expect(scheme.secondary, baseScheme.secondary);
    expect(scheme.onSecondary, baseScheme.onSecondary);
    expect(scheme.secondaryContainer, baseScheme.secondaryContainer);
    expect(scheme.onSecondaryContainer, baseScheme.onSecondaryContainer);
    expect(scheme.tertiary, baseScheme.tertiary);
    expect(scheme.onTertiary, baseScheme.onTertiary);
    expect(scheme.tertiaryContainer, baseScheme.tertiaryContainer);
    expect(scheme.onTertiaryContainer, baseScheme.onTertiaryContainer);
    expect(scheme.error, baseScheme.error);
    expect(scheme.onError, baseScheme.onError);
    expect(scheme.errorContainer, baseScheme.errorContainer);
    expect(scheme.onErrorContainer, baseScheme.onErrorContainer);
    expect(scheme.outline, baseScheme.outline);
    expect(scheme.outlineVariant, baseScheme.outlineVariant);
    expect(scheme.background, baseScheme.background);
    expect(scheme.onBackground, baseScheme.onBackground);
    expect(scheme.surface, baseScheme.surface);
    expect(scheme.onSurface, baseScheme.onSurface);
    expect(scheme.surfaceVariant, baseScheme.surfaceVariant);
    expect(scheme.onSurfaceVariant, baseScheme.onSurfaceVariant);
    expect(scheme.inverseSurface, baseScheme.inverseSurface);
    expect(scheme.inverseOnSurface, baseScheme.inverseOnSurface);
    expect(scheme.inversePrimary, baseScheme.inversePrimary);
    expect(scheme.shadow, baseScheme.shadow);
    expect(scheme.scrim, baseScheme.shadow);
    expect(scheme.surfaceTint, baseScheme.surfaceTint);
    expect(scheme.brightness, baseScheme.brightness);
  });

   test('can generate a light scheme from an imageProvider', () async {
    final Uint8List blueSquareBytes = Uint8List.fromList(kBlueSquarePng);
    final ImageProvider image = MemoryImage(blueSquareBytes);

    final ColorScheme scheme =
        await ColorScheme.fromImageProvider(provider: image);

    expect(scheme.brightness, Brightness.light);
    expect(scheme.primary, ColorMatcher(const Color(0xff4040f3)));
    expect(scheme.onPrimary, ColorMatcher(const Color(0xffffffff)));
    expect(scheme.primaryContainer, ColorMatcher(const Color(0xffe1e0ff)));
    expect(scheme.onPrimaryContainer, ColorMatcher(const Color(0xff06006c)));
    expect(scheme.secondary, ColorMatcher(const Color(0xff5d5c72)));
    expect(scheme.onSecondary, ColorMatcher(const Color(0xffffffff)));
    expect(scheme.secondaryContainer, ColorMatcher(const Color(0xffe2e0f9)));
    expect(scheme.onSecondaryContainer, ColorMatcher(const Color(0xff191a2c)));
    expect(scheme.tertiary, ColorMatcher(const Color(0xff79536a)));
    expect(scheme.onTertiary, ColorMatcher(const Color(0xffffffff)));
    expect(scheme.tertiaryContainer, ColorMatcher(const Color(0xffffd8ec)));
    expect(scheme.onTertiaryContainer, ColorMatcher(const Color(0xff2e1125)));
    expect(scheme.error, ColorMatcher(const Color(0xffba1a1a)));
    expect(scheme.onError, ColorMatcher(const Color(0xffffffff)));
    expect(scheme.errorContainer, ColorMatcher(const Color(0xffffdad6)));
    expect(scheme.onErrorContainer, ColorMatcher(const Color(0xff410002)));
    expect(scheme.background, ColorMatcher(const Color(0xfffcf8fd)));
    expect(scheme.onBackground, ColorMatcher(const Color(0xff1c1b1f)));
    expect(scheme.surface, ColorMatcher(const Color(0xfffcf8fd)));
    expect(scheme.onSurface, ColorMatcher(const Color(0xff1c1b1f)));
    expect(scheme.surfaceVariant, ColorMatcher(const Color(0xffe4e1ec)));
    expect(scheme.onSurfaceVariant, ColorMatcher(const Color(0xff46464f)));
    expect(scheme.outline, ColorMatcher(const Color(0xff777680)));
    expect(scheme.outlineVariant, ColorMatcher(const Color(0xffc8c5d0)));
    expect(scheme.shadow, ColorMatcher(const Color(0xff000000)));
    expect(scheme.scrim, ColorMatcher(const Color(0xff000000)));
    expect(scheme.inverseSurface, ColorMatcher(const Color(0xff313034)));
    expect(scheme.inverseOnSurface, ColorMatcher(const Color(0xfff3eff4)));
    expect(scheme.inversePrimary, ColorMatcher(const Color(0xffc0c1ff)));
    expect(scheme.surfaceTint, ColorMatcher(const Color(0xff4040f3)));
  }, skip: isBrowser, // [intended] uses dart:typed_data.
);

  test('can generate a dark scheme from an imageProvider', () async {
    final Uint8List blueSquareBytes = Uint8List.fromList(kBlueSquarePng);
    final ImageProvider image = MemoryImage(blueSquareBytes);

    final ColorScheme scheme = await ColorScheme.fromImageProvider(
        provider: image, brightness: Brightness.dark);

    expect(scheme.primary, ColorMatcher(const Color(0xffc0c1ff)));
    expect(scheme.onPrimary, ColorMatcher(const Color(0xff0f00aa)));
    expect(scheme.primaryContainer, ColorMatcher(const Color(0xff2218dd)));
    expect(scheme.onPrimaryContainer, ColorMatcher(const Color(0xffe1e0ff)));
    expect(scheme.secondary, ColorMatcher(const Color(0xffc6c4dd)));
    expect(scheme.onSecondary, ColorMatcher(const Color(0xff2e2f42)));
    expect(scheme.secondaryContainer, ColorMatcher(const Color(0xff454559)));
    expect(scheme.onSecondaryContainer, ColorMatcher(const Color(0xffe2e0f9)));
    expect(scheme.tertiary, ColorMatcher(const Color(0xffe9b9d3)));
    expect(scheme.onTertiary, ColorMatcher(const Color(0xff46263a)));
    expect(scheme.tertiaryContainer, ColorMatcher(const Color(0xff5f3c51)));
    expect(scheme.onTertiaryContainer, ColorMatcher(const Color(0xffffd8ec)));
    expect(scheme.error, ColorMatcher(const Color(0xffffb4ab)));
    expect(scheme.onError, ColorMatcher(const Color(0xff690005)));
    expect(scheme.errorContainer, ColorMatcher(const Color(0xff93000a)));
    expect(scheme.onErrorContainer, ColorMatcher(const Color(0xffffdad6)));
    expect(scheme.background, ColorMatcher(const Color(0xff131316)));
    expect(scheme.onBackground, ColorMatcher(const Color(0xffe5e1e6)));
    expect(scheme.surface, ColorMatcher(const Color(0xff121316)));
    expect(scheme.onSurface, ColorMatcher(const Color(0xffe5e1e6)));
    expect(scheme.surfaceVariant, ColorMatcher(const Color(0xff46464f)));
    expect(scheme.onSurfaceVariant, ColorMatcher(const Color(0xffc8c5d0)));
    expect(scheme.outline, ColorMatcher(const Color(0xff918f9a)));
    expect(scheme.outlineVariant, ColorMatcher(const Color(0xff46464f)));
    expect(scheme.inverseSurface, ColorMatcher(const Color(0xffe5e1e6)));
    expect(scheme.inverseOnSurface, ColorMatcher(const Color(0xff313034)));
    expect(scheme.inversePrimary, ColorMatcher(const Color(0xff4040f3)));
    expect(scheme.surfaceTint, ColorMatcher(const Color(0xffc0c1ff)));
    }, skip: isBrowser, // [intended] uses dart:isolate and io.
  );

  test('fromImageProvider() propogates TimeoutException when image cannot be rendered', () async {
    final Uint8List blueSquareBytes = Uint8List.fromList(kBlueSquarePng);

    // Corrupt the image's bytelist so it cannot be read.
    final Uint8List corruptImage = blueSquareBytes.sublist(5);
    final ImageProvider image = MemoryImage(corruptImage);

    expect(() async => ColorScheme.fromImageProvider(provider: image), throwsA(
      isA<Exception>().having((Exception e) => e.toString(),
        'Timeout occurred trying to load image', contains('TimeoutException')),
      ),
    );
  });

  testWidgets('generated scheme "on" colors meet a11y contrast guidelines', (WidgetTester tester) async {
    final ColorScheme colors = ColorScheme.fromSeed(seedColor: Colors.teal);

    Widget label(String text, Color textColor, Color background) {
      return Container(
        color: background,
        padding: const EdgeInsets.all(8),
        child: Text(text, style: TextStyle(color: textColor)),
      );
    }

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.from(colorScheme: colors),
        home: Scaffold(
          body: Column(
            children: <Widget>[
              label('primary', colors.onPrimary, colors.primary),
              label('secondary', colors.onSecondary, colors.secondary),
              label('tertiary', colors.onTertiary, colors.tertiary),
              label('error', colors.onError, colors.error),
              label('background', colors.onBackground, colors.background),
              label('surface', colors.onSurface, colors.surface),
            ],
          ),
        ),
      ),
    );
    await expectLater(tester, meetsGuideline(textContrastGuideline));
  },
    skip: isBrowser, // https://github.com/flutter/flutter/issues/44115
  );
}

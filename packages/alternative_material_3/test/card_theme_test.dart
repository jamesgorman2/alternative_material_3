// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// This file is run as part of a reduced test set in CI on Mac and Windows
// machines.
@Tags(<String>['reduced-test-set'])
library;

import 'package:alternative_material_3/material.dart';
import 'package:alternative_material_3/src/elevation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CardTheme copyWith, ==, hashCode basics', () {
    expect(const CardTheme(), const CardTheme().copyWith());
    expect(const CardTheme().hashCode, const CardTheme().copyWith().hashCode);
  });

  test('CardTheme lerp special cases', () {
    expect(CardTheme.lerp(null, null, 0), const CardTheme());
    const CardTheme theme = CardTheme();
    expect(identical(CardTheme.lerp(theme, theme, 0.5), theme), true);
  });

  testWidgets('Passing no CardTheme returns defaults', (WidgetTester tester) async {
    final ThemeData theme = ThemeData();
    await tester.pumpWidget(MaterialApp(
      theme: theme,
      home: const Scaffold(
        body: Card(),
      ),
    ));

    final Container container = _getCardContainer(tester);
    final Material material = _getCardMaterial(tester);

    expect(material.clipBehavior, Clip.none);
    expect(material.color, theme.colorScheme.surfaceContainerLow);
    expect(material.shadowColor, theme.colorScheme.shadow);
    expect(material.surfaceTintColor, theme.colorScheme.surfaceTint); // Default primary color
    expect(material.elevation, Elevation.level1);
    expect(container.margin, const EdgeInsets.all(4.0));
    expect(material.shape, const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
    ));
  });

  testWidgets('Card uses values from CardTheme', (WidgetTester tester) async {
    final CardTheme cardTheme = _cardTheme();

    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(cardTheme: cardTheme),
      home: const Scaffold(
        body: Card(),
      ),
    ));

    final Container container = _getCardContainer(tester);
    final Material material = _getCardMaterial(tester);

    expect(material.clipBehavior, cardTheme.clipBehavior);
    expect(material.color, cardTheme.color);
    expect(material.shadowColor, cardTheme.shadowColor);
    expect(material.surfaceTintColor, cardTheme.surfaceTintColor);
    expect(material.elevation, cardTheme.elevation);
    expect(container.margin, cardTheme.margin);
    expect(material.shape, cardTheme.shape);
  });

  testWidgets('Card widget properties take priority over theme', (WidgetTester tester) async {
    const Clip clip = Clip.hardEdge;
    const Color color = Colors.orange;
    const Color shadowColor = Colors.pink;
    const Elevation elevation = Elevation.level3;
    const EdgeInsets margin = EdgeInsets.all(3.0);
    const ShapeBorder shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(9.0)),
    );

    await tester.pumpWidget(MaterialApp(
      theme: _themeData().copyWith(cardTheme: _cardTheme()),
      home: const Scaffold(
        body: Card(
          clipBehavior: clip,
          color: color,
          shadowColor: shadowColor,
          elevation: elevation,
          margin: margin,
          shape: shape,
        ),
      ),
    ));

    final Container container = _getCardContainer(tester);
    final Material material = _getCardMaterial(tester);

    expect(material.clipBehavior, clip);
    expect(material.color, color);
    expect(material.shadowColor, shadowColor);
    expect(material.elevation, elevation);
    expect(container.margin, margin);
    expect(material.shape, shape);
  });

  testWidgets('CardTheme properties take priority over ThemeData properties', (WidgetTester tester) async {
    final CardTheme cardTheme = _cardTheme();
    final ThemeData themeData = _themeData().copyWith(cardTheme: cardTheme);

    await tester.pumpWidget(MaterialApp(
      theme: themeData,
      home: const Scaffold(
        body: Card(),
      ),
    ));

    final Material material = _getCardMaterial(tester);
    expect(material.color, cardTheme.color);
  });

  testWidgets('ThemeData properties are used when no CardTheme is set', (WidgetTester tester) async {
    final ThemeData themeData = _themeData();

    await tester.pumpWidget(MaterialApp(
      theme: themeData,
      home: const Scaffold(
        body: Card(),
      ),
    ));

    final Material material = _getCardMaterial(tester);
    expect(material.color, _altSurfaceLow);
  });
}

CardTheme _cardTheme() {
  return const CardTheme(
    clipBehavior: Clip.antiAlias,
    color: Colors.green,
    shadowColor: Colors.red,
    surfaceTintColor: Colors.purple,
    elevation: Elevation.level3,
    margin: EdgeInsets.all(7.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
    ),
  );
}

const Color _altSurfaceLow = Colors.pink;
ThemeData _themeData() {
  return ThemeData(
    colorScheme: ColorScheme.m3DefaultLight.copyWith(surfaceContainerLow: _altSurfaceLow),
  );
}

Material _getCardMaterial(WidgetTester tester) {
  return tester.widget<Material>(
    find.descendant(
      of: find.byType(Card),
      matching: find.byType(Material),
    ),
  );
}

Container _getCardContainer(WidgetTester tester) {
  return tester.widget<Container>(
    find.descendant(
      of: find.byType(Card),
      matching: find.byType(Container),
    ),
  );
}

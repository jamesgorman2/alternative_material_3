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
  test('BottomAppBarTheme lerp special cases', () {
    expect(BottomAppBarTheme.lerp(null, null, 0), const BottomAppBarTheme());
    const BottomAppBarTheme data = BottomAppBarTheme();
    expect(identical(BottomAppBarTheme.lerp(data, data, 0.5), data), true);
  });

  group('Material 3 tests', () {
    Material getBabRenderObject(WidgetTester tester) {
      return tester.widget<Material>(
        find.descendant(
          of: find.byType(BottomAppBar),
          matching: find.byType(Material),
        ),
      );
    }

    testWidgets('BAB theme overrides color - M3', (WidgetTester tester) async {
      const Color themedColor = Colors.black87;
      const BottomAppBarTheme theme = BottomAppBarTheme(
        color: themedColor,
        elevation: Elevation.level0,
      );
      await tester.pumpWidget(_withTheme(theme));

      final PhysicalShape widget = _getBabRenderObject(tester);
      expect(widget.color, themedColor);
    });

    testWidgets('BAB color - Widget - M3', (WidgetTester tester) async {
      const Color babThemeColor = Colors.black87;
      const Color babColor = Colors.pink;
      const BottomAppBarTheme theme = BottomAppBarTheme(color: babThemeColor);

      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(
          bottomAppBarTheme: theme,
        ),
        home: const Scaffold(body: BottomAppBar(color: babColor)),
      ));

      final PhysicalShape widget = _getBabRenderObject(tester);
      expect(widget.color, babColor);
    });

    testWidgets('BAB color - BabTheme - M3', (WidgetTester tester) async {
      const Color babThemeColor = Colors.black87;
      const BottomAppBarTheme theme = BottomAppBarTheme(color: babThemeColor);

      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(
          bottomAppBarTheme: theme,
        ),
        home: const Scaffold(body: BottomAppBar()),
      ));

      final PhysicalShape widget = _getBabRenderObject(tester);
      expect(widget.color, babThemeColor);
    });

    testWidgets('BAB theme does not affect defaults - M3', (WidgetTester tester) async {
      final ThemeData theme = ThemeData();
      await tester.pumpWidget(MaterialApp(
        theme: theme,
        home: const Scaffold(body: BottomAppBar()),
      ));

      final PhysicalShape widget = _getBabRenderObject(tester);

      expect(widget.color, theme.colorScheme.surfaceContainer);
      expect(widget.elevation, equals(3.0));
    });

    testWidgets('BAB theme overrides surfaceTintColor - M3', (WidgetTester tester) async {
      const Color babThemeSurfaceTintColor = Colors.black87;
      const BottomAppBarTheme theme = BottomAppBarTheme(
        surfaceTintColor: babThemeSurfaceTintColor, elevation: Elevation.level0
      );
      await tester.pumpWidget(_withTheme(theme));

      final Material widget = getBabRenderObject(tester);
      expect(widget.surfaceTintColor, babThemeSurfaceTintColor);
    });

    testWidgets('BAB theme overrides shadowColor - M3', (WidgetTester tester) async {
      const Color babThemeShadowColor = Colors.yellow;
      const BottomAppBarTheme theme = BottomAppBarTheme(
        shadowColor: babThemeShadowColor, elevation: Elevation.level0
      );
      await tester.pumpWidget(_withTheme(theme));

      final Material widget = getBabRenderObject(tester);
      expect(widget.shadowColor, babThemeShadowColor);
    });

    testWidgets('BAB surfaceTintColor - Widget - M3', (WidgetTester tester) async {
      const Color babThemeSurfaceTintColor = Colors.black87;
      const Color babSurfaceTintColor = Colors.pink;
      const BottomAppBarTheme theme = BottomAppBarTheme(
        surfaceTintColor: babThemeSurfaceTintColor
      );
      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(
          bottomAppBarTheme: theme,
        ),
        home: const Scaffold(
          body: BottomAppBar(surfaceTintColor: babSurfaceTintColor)
        ),
      ));

      final Material widget = getBabRenderObject(tester);
      expect(widget.surfaceTintColor, babSurfaceTintColor);
    });

    testWidgets('BAB surfaceTintColor - BabTheme - M3', (WidgetTester tester) async {
      const Color babThemeColor = Colors.black87;
      const BottomAppBarTheme theme = BottomAppBarTheme(
        surfaceTintColor: babThemeColor
      );

      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(
          bottomAppBarTheme: theme,
        ),
        home: const Scaffold(body: BottomAppBar()),
      ));

      final Material widget = getBabRenderObject(tester);
      expect(widget.surfaceTintColor, babThemeColor);
    });
  });
}

PhysicalShape _getBabRenderObject(WidgetTester tester) {
  return tester.widget<PhysicalShape>(
      find.descendant(
        of: find.byType(BottomAppBar),
        matching: find.byType(PhysicalShape),
      ),
  );
}

final Key _painterKey = UniqueKey();

Widget _withTheme(BottomAppBarTheme theme) {
  return MaterialApp(
    theme: ThemeData(bottomAppBarTheme: theme),
    home: Scaffold(
      floatingActionButton: const FloatingActionButton(onPressed: null),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: RepaintBoundary(
        key: _painterKey,
        child: const BottomAppBar(
          child: Row(
            children: <Widget>[
              Icon(Icons.add),
              Expanded(child: SizedBox()),
              Icon(Icons.add),
            ],
          ),
        ),
      ),
    ),
  );
}

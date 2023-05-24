// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// This file is run as part of a reduced test set in CI on Mac and Windows
// machines.
@Tags(<String>['reduced-test-set'])
library;

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/constants.dart';
import 'package:flutter_test/flutter_test.dart';

import 'rendering/mock_canvas.dart';

void main() {
  testWidgets('InkSparkle in a Button compiles and does not crash', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(splashFactory: InkSparkle.splashFactory),
            child: const Text('Sparkle!'),
            onPressed: () { },
          ),
        ),
      ),
    ));
    final Finder buttonFinder = find.text('Sparkle!');
    await tester.tap(buttonFinder);
    await tester.pump();
    await tester.pumpAndSettle();
  },
    skip: kIsWeb, // [intended] shaders are not yet supported for web.
  );

  testWidgets('InkSparkle default splashFactory paints with drawRect when bounded', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: InkWell(
            splashFactory: InkSparkle.splashFactory,
            child: const Text('Sparkle!'),
            onTap: () { },
          ),
        ),
      ),
    ));
    final Finder buttonFinder = find.text('Sparkle!');
    await tester.tap(buttonFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    final MaterialInkController material = Material.of(tester.element(buttonFinder));
    expect(material, paintsExactlyCountTimes(#drawRect, 1));

    // ignore: avoid_dynamic_calls
    expect((material as dynamic).debugInkFeatures, hasLength(1));

    await tester.pumpAndSettle();
    // ink feature is disposed.
    // ignore: avoid_dynamic_calls
    expect((material as dynamic).debugInkFeatures, isEmpty);
  },
    skip: kIsWeb, // [intended] shaders are not yet supported for web.
  );

  testWidgets('InkSparkle default splashFactory paints with drawPaint when unbounded', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: InkResponse(
            splashFactory: InkSparkle.splashFactory,
            child: const Text('Sparkle!'),
            onTap: () { },
          ),
        ),
      ),
    ));
    final Finder buttonFinder = find.text('Sparkle!');
    await tester.tap(buttonFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    final MaterialInkController material = Material.of(tester.element(buttonFinder));
    expect(material, paintsExactlyCountTimes(#drawPaint, 1));
  },
    skip: kIsWeb, // [intended] shaders are not yet supported for web.
  );
}

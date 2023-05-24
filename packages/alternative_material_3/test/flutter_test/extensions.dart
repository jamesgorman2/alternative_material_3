// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:alternative_material_3/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Some frequently used widget [Finder]s.
///
/// These are to override any Finders that reference flutter/material.
extension CommonFindersM3 on CommonFinders {

  /// Finds Tooltip widgets with the given message.
  ///
  /// ## Sample code
  ///
  /// ```dart
  /// expect(find.byTooltipM3('Back'), findsOneWidget);
  /// ```
  ///
  /// If the `skipOffstage` argument is true (the default), then this skips
  /// nodes that are [Offstage] or that are from inactive [Route]s.
  Finder byTooltipM3(String message, { bool skipOffstage = true }) {
    return find.byWidgetPredicate(
          (Widget widget) => widget is Tooltip && widget.message == message,
      skipOffstage: skipOffstage,
    );
  }
}

extension WidgetTesterM3 on WidgetTester {
  /// Makes an effort to dismiss the current page with a Material [Scaffold] or
  /// a [CupertinoPageScaffold].
  ///
  /// Will throw an error if there is no back button in the page.
  Future<void> pageBackM3() async {
    return TestAsyncUtils.guard<void>(() async {
      Finder backButton = find.byTooltipM3('Back');
      if (backButton.evaluate().isEmpty) {
        backButton = find.byType(CupertinoNavigationBarBackButton);
      }

      expectSync(backButton, findsOneWidget, reason: 'One back button expected on screen');

      await tap(backButton);
    });
  }
}

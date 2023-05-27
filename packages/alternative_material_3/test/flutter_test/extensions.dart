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


/// Colors can be out by one due to the HSV processing in
/// material_color_utilities
class ColorMatcher extends Matcher {
  ColorMatcher(this.expected, {this.exact = false});

  final Color expected;
  final bool exact;

  @override
  Description describe(Description description) {
    if (exact) {
      return description.addDescriptionOf(expected);
    }
    return description.addDescriptionOf(expected);
  }
  @override
  bool matches(dynamic item, Map<dynamic, dynamic> matchState) {
    if (item == expected) {
      return true;
    } else if (item is Color && !exact) {
      int diffA = (item.alpha - expected.alpha).abs();
      int diffR = (item.red - expected.red).abs();
      int diffB = (item.blue - expected.blue).abs();
      int diffG = (item.green - expected.green).abs();

      return diffA + diffR + diffB + diffG <= 2;
    }
    return false;
  }
}

class RootFinder extends MatchFinder {
  @override
  String get description => 'the root';

  @override
  bool matches(Element candidate) {
    return candidate == WidgetsBinding.instance.rootElement!;
  }

}

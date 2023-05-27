// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// This file is run as part of a reduced test set in CI on Mac and Windows
// machines.
@Tags(<String>['reduced-test-set'])
library;

import 'package:alternative_material_3/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'rendering/mock_canvas.dart';
import 'widgets/test_border.dart' show TestBorder;

class NotifyMaterial extends StatelessWidget {
  const NotifyMaterial({ super.key });
  @override
  Widget build(BuildContext context) {
    const LayoutChangedNotification().dispatch(context);
    return Container();
  }
}

Widget buildMaterial({
  double elevation = 0.0,
  Color shadowColor = const Color(0xFF00FF00),
  Color? surfaceTintColor,
  Color color = const Color(0xFF0000FF),
}) {
  return Center(
    child: SizedBox(
      height: 100.0,
      width: 100.0,
      child: Material(
        color: color,
        shadowColor: shadowColor,
        surfaceTintColor: surfaceTintColor,
        elevation: elevation,
        shape: const CircleBorder(),
      ),
    ),
  );
}

RenderPhysicalShape getModel(WidgetTester tester) {
  return tester.renderObject(find.byType(PhysicalShape));
}

class PaintRecorder extends CustomPainter {
  PaintRecorder(this.log);

  final List<Size> log;

  @override
  void paint(Canvas canvas, Size size) {
    log.add(size);
    final Paint paint = Paint()..color = const Color(0xFF0000FF);
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(PaintRecorder oldDelegate) => false;
}

class ElevationColor {
  const ElevationColor(this.elevation, this.color);
  final double elevation;
  final Color color;
}

void main() {
  // Regression test for https://github.com/flutter/flutter/issues/81504
  testWidgets('MaterialApp.home nullable and update test', (WidgetTester tester) async {
    // _WidgetsAppState._usesNavigator == true
    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));

    // _WidgetsAppState._usesNavigator == false
    await tester.pumpWidget(const MaterialApp()); // Do not crash!

    // _WidgetsAppState._usesNavigator == true
    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink())); // Do not crash!

    expect(tester.takeException(), null);
  });

  testWidgets('default Material debugFillProperties', (WidgetTester tester) async {
    final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
    const Material().debugFillProperties(builder);

    final List<String> description = builder.properties
      .where((DiagnosticsNode node) => !node.isFiltered(DiagnosticLevel.info))
      .map((DiagnosticsNode node) => node.toString())
      .toList();

    expect(description, <String>['type: canvas']);
  });

  testWidgets('Material implements debugFillProperties', (WidgetTester tester) async {
    final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
    const Material(
      color: Color(0xFFFFFFFF),
      shadowColor: Color(0xffff0000),
      surfaceTintColor: Color(0xff0000ff),
      textStyle: TextStyle(color: Color(0xff00ff00)),
      borderRadius: BorderRadiusDirectional.all(Radius.circular(10)),
    ).debugFillProperties(builder);

    final List<String> description = builder.properties
      .where((DiagnosticsNode node) => !node.isFiltered(DiagnosticLevel.info))
      .map((DiagnosticsNode node) => node.toString())
      .toList();

    expect(description, <String>[
      'type: canvas',
      'color: Color(0xffffffff)',
      'shadowColor: Color(0xffff0000)',
      'surfaceTintColor: Color(0xff0000ff)',
      'textStyle.inherit: true',
      'textStyle.color: Color(0xff00ff00)',
      'borderRadius: BorderRadiusDirectional.circular(10.0)',
    ]);
  });

  testWidgets('LayoutChangedNotification test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const Material(
        child: NotifyMaterial(),
      ),
    );
  });

  testWidgets('ListView scroll does not repaint', (WidgetTester tester) async {
    final List<Size> log = <Size>[];

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          children: <Widget>[
            SizedBox(
              width: 150.0,
              height: 150.0,
              child: CustomPaint(
                painter: PaintRecorder(log),
              ),
            ),
            Expanded(
              child: Material(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        children: <Widget>[
                          Container(
                            height: 2000.0,
                            color: const Color(0xFF00FF00),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 100.0,
                      height: 100.0,
                      child: CustomPaint(
                        painter: PaintRecorder(log),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // We paint twice because we have two CustomPaint widgets in the tree above
    // to test repainting both inside and outside the Material widget.
    expect(log, equals(<Size>[
      const Size(150.0, 150.0),
      const Size(100.0, 100.0),
    ]));
    log.clear();

    await tester.drag(find.byType(ListView), const Offset(0.0, -300.0));
    await tester.pump();

    expect(log, isEmpty);
  });

  testWidgets('Shadow color defaults', (WidgetTester tester) async {
    Widget buildWithShadow(Color? shadowColor) {
      return Center(
        child: SizedBox(
          height: 100.0,
          width: 100.0,
          child: Material(
            shadowColor: shadowColor,
            elevation: 10,
            shape: const CircleBorder(),
          ),
        )
      );
    }

    // Default M3 shadow color
    await tester.pumpWidget(
        Theme(
          data: ThemeData(
            
          ),
          child: buildWithShadow(null),
        )
    );
    await tester.pumpAndSettle();
    expect(getModel(tester).shadowColor, ThemeData().colorScheme.shadow);

    // Drop shadow can be turned off with a transparent color.
    await tester.pumpWidget(
        Theme(
          data: ThemeData(
            
          ),
          child: buildWithShadow(Colors.transparent),
        )
    );
    await tester.pumpAndSettle();
    expect(getModel(tester).shadowColor, Colors.transparent);
  });

  testWidgets('Shadows animate smoothly', (WidgetTester tester) async {
    // This code verifies that the PhysicalModel's elevation animates over
    // a kThemeChangeDuration time interval.

    await tester.pumpWidget(buildMaterial());
    final RenderPhysicalShape modelA = getModel(tester);
    expect(modelA.elevation, equals(0.0));

    await tester.pumpWidget(buildMaterial(elevation: 9.0));
    final RenderPhysicalShape modelB = getModel(tester);
    expect(modelB.elevation, equals(0.0));

    await tester.pump(const Duration(milliseconds: 1));
    final RenderPhysicalShape modelC = getModel(tester);
    expect(modelC.elevation, moreOrLessEquals(0.0, epsilon: 0.001));

    await tester.pump(kThemeChangeDuration ~/ 2);
    final RenderPhysicalShape modelD = getModel(tester);
    expect(modelD.elevation, isNot(moreOrLessEquals(0.0, epsilon: 0.001)));

    await tester.pump(kThemeChangeDuration);
    final RenderPhysicalShape modelE = getModel(tester);
    expect(modelE.elevation, equals(9.0));
  });

  testWidgets('Shadow colors animate smoothly', (WidgetTester tester) async {
    // This code verifies that the PhysicalModel's shadowColor animates over
    // a kThemeChangeDuration time interval.

    await tester.pumpWidget(buildMaterial());
    final RenderPhysicalShape modelA = getModel(tester);
    expect(modelA.shadowColor, equals(const Color(0xFF00FF00)));

    await tester.pumpWidget(buildMaterial(shadowColor: const Color(0xFFFF0000)));
    final RenderPhysicalShape modelB = getModel(tester);
    expect(modelB.shadowColor, equals(const Color(0xFF00FF00)));

    await tester.pump(const Duration(milliseconds: 1));
    final RenderPhysicalShape modelC = getModel(tester);
    expect(modelC.shadowColor, within<Color>(distance: 1, from: const Color(0xFF00FF00)));

    await tester.pump(kThemeChangeDuration ~/ 2);
    final RenderPhysicalShape modelD = getModel(tester);
    expect(modelD.shadowColor, isNot(within<Color>(distance: 1, from: const Color(0xFF00FF00))));

    await tester.pump(kThemeChangeDuration);
    final RenderPhysicalShape modelE = getModel(tester);
    expect(modelE.shadowColor, equals(const Color(0xFFFF0000)));
  });

  testWidgets('Transparent material widget does not absorb hit test', (WidgetTester tester) async {
    // This is a regression test for https://github.com/flutter/flutter/issues/58665.
    bool pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  pressed = true;
                },
                child: null,
              ),
              const Material(
                type: MaterialType.transparency,
                child: SizedBox(
                  width: 400.0,
                  height: 500.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.byType(ElevatedButton));
    expect(pressed, isTrue);
  });

  group('Surface Tint Overlay', () {
    testWidgets('surfaceTintColor is used to as an overlay to indicate elevation', (WidgetTester tester) async {
      const Color baseColor = Color(0xFF121212);
      const Color surfaceTintColor = Color(0xff44CCFF);

      // With no surfaceTintColor specified, it should not apply an overlay
      await tester.pumpWidget(
        Theme(
          data: ThemeData(
            
          ),
          child: buildMaterial(
            color: baseColor,
            elevation: 12.0,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final RenderPhysicalShape noTintModel = getModel(tester);
      expect(noTintModel.color, equals(baseColor));

      // With transparent surfaceTintColor, it should not apply an overlay
      await tester.pumpWidget(
        Theme(
          data: ThemeData(
            
          ),
          child: buildMaterial(
            color: baseColor,
            surfaceTintColor: Colors.transparent,
            elevation: 12.0,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final RenderPhysicalShape transparentTintModel = getModel(tester);
      expect(transparentTintModel.color, equals(baseColor));

      // With surfaceTintColor specified, it should not apply an overlay based
      // on the elevation.
      await tester.pumpWidget(
        Theme(
          data: ThemeData(
            
          ),
          child: buildMaterial(
            color: baseColor,
            surfaceTintColor: surfaceTintColor,
            elevation: 12.0,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final RenderPhysicalShape tintModel = getModel(tester);

      // Final color should be the base with a tint of 0.14 opacity or 0xff192c33
      expect(tintModel.color, equals(const Color(0xff192c33)));
    });

  }); // Surface Tint Overlay group

  group('Transparency clipping', () {
    testWidgets('No clip by default', (WidgetTester tester) async {
      final GlobalKey materialKey = GlobalKey();
      await tester.pumpWidget(
          Material(
            key: materialKey,
            type: MaterialType.transparency,
            child: const SizedBox(width: 100.0, height: 100.0),
          ),
      );

      final RenderClipPath renderClip = tester.allRenderObjects.whereType<RenderClipPath>().first;
      expect(renderClip.clipBehavior, equals(Clip.none));
    });

    testWidgets('clips to bounding rect by default given Clip.antiAlias', (WidgetTester tester) async {
      final GlobalKey materialKey = GlobalKey();
      await tester.pumpWidget(
        Material(
          key: materialKey,
          type: MaterialType.transparency,
          clipBehavior: Clip.antiAlias,
          child: const SizedBox(width: 100.0, height: 100.0),
        ),
      );

      expect(find.byKey(materialKey), clipsWithBoundingRect);
    });

    testWidgets('clips to rounded rect when borderRadius provided given Clip.antiAlias', (WidgetTester tester) async {
      final GlobalKey materialKey = GlobalKey();
      await tester.pumpWidget(
        Material(
          key: materialKey,
          type: MaterialType.transparency,
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          clipBehavior: Clip.antiAlias,
          child: const SizedBox(width: 100.0, height: 100.0),
        ),
      );

      expect(
        find.byKey(materialKey),
        clipsWithBoundingRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
      );
    });

    testWidgets('clips to shape when provided given Clip.antiAlias', (WidgetTester tester) async {
      final GlobalKey materialKey = GlobalKey();
      await tester.pumpWidget(
        Material(
          key: materialKey,
          type: MaterialType.transparency,
          shape: const StadiumBorder(),
          clipBehavior: Clip.antiAlias,
          child: const SizedBox(width: 100.0, height: 100.0),
        ),
      );

      expect(
        find.byKey(materialKey),
        clipsWithShapeBorder(
          shape: const StadiumBorder(),
        ),
      );
    });

    testWidgets('supports directional clips', (WidgetTester tester) async {
      final List<String> logs = <String>[];
      final ShapeBorder shape = TestBorder((String message) { logs.add(message); });
      Widget buildMaterial() {
        return Material(
          type: MaterialType.transparency,
          shape: shape,
          clipBehavior: Clip.antiAlias,
          child: const SizedBox(width: 100.0, height: 100.0),
        );
      }
      final Widget material = buildMaterial();
      // verify that a regular clip works as one would expect
      logs.add('--0');
      await tester.pumpWidget(material);
      // verify that pumping again doesn't recompute the clip
      // even though the widget itself is new (the shape doesn't change identity)
      logs.add('--1');
      await tester.pumpWidget(buildMaterial());
      // verify that Material passes the TextDirection on to its shape when it's transparent
      logs.add('--2');
      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: material,
      ));
      // verify that changing the text direction from LTR to RTL has an effect
      // even though the widget itself is identical
      logs.add('--3');
      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.rtl,
        child: material,
      ));
      // verify that pumping again with a text direction has no effect
      logs.add('--4');
      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.rtl,
        child: buildMaterial(),
      ));
      logs.add('--5');
      // verify that changing the text direction and the widget at the same time
      // works as expected
      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: material,
      ));
      expect(logs, <String>[
        '--0',
        'getOuterPath Rect.fromLTRB(0.0, 0.0, 800.0, 600.0) null',
        'paint Rect.fromLTRB(0.0, 0.0, 800.0, 600.0) null',
        '--1',
        '--2',
        'getOuterPath Rect.fromLTRB(0.0, 0.0, 800.0, 600.0) TextDirection.ltr',
        'paint Rect.fromLTRB(0.0, 0.0, 800.0, 600.0) TextDirection.ltr',
        '--3',
        'getOuterPath Rect.fromLTRB(0.0, 0.0, 800.0, 600.0) TextDirection.rtl',
        'paint Rect.fromLTRB(0.0, 0.0, 800.0, 600.0) TextDirection.rtl',
        '--4',
        '--5',
        'getOuterPath Rect.fromLTRB(0.0, 0.0, 800.0, 600.0) TextDirection.ltr',
        'paint Rect.fromLTRB(0.0, 0.0, 800.0, 600.0) TextDirection.ltr',
      ]);
    });
  });

  group('PhysicalModels', () {
    testWidgets('canvas', (WidgetTester tester) async {
      final GlobalKey materialKey = GlobalKey();
      await tester.pumpWidget(
        Material(
          key: materialKey,
          child: const SizedBox(width: 100.0, height: 100.0),
        ),
      );

      expect(find.byKey(materialKey), rendersOnPhysicalModel(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.zero,
          elevation: 0.0,
      ));
    });

    testWidgets('canvas with borderRadius and elevation', (WidgetTester tester) async {
      final GlobalKey materialKey = GlobalKey();
      await tester.pumpWidget(
        Material(
          key: materialKey,
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          elevation: 1.0,
          child: const SizedBox(width: 100.0, height: 100.0),
        ),
      );

      expect(find.byKey(materialKey), rendersOnPhysicalModel(
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          elevation: 1.0,
      ));
    });

    testWidgets('canvas with shape and elevation', (WidgetTester tester) async {
      final GlobalKey materialKey = GlobalKey();
      await tester.pumpWidget(
        Material(
          key: materialKey,
          shape: const StadiumBorder(),
          elevation: 1.0,
          child: const SizedBox(width: 100.0, height: 100.0),
        ),
      );

      expect(find.byKey(materialKey), rendersOnPhysicalShape(
          shape: const StadiumBorder(),
          elevation: 1.0,
      ));
    });

    testWidgets('card', (WidgetTester tester) async {
      final GlobalKey materialKey = GlobalKey();
      await tester.pumpWidget(
        Material(
          key: materialKey,
          type: MaterialType.card,
          child: const SizedBox(width: 100.0, height: 100.0),
        ),
      );

      expect(find.byKey(materialKey), rendersOnPhysicalModel(
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(2.0)),
          elevation: 0.0,
      ));
    });

    testWidgets('card with borderRadius and elevation', (WidgetTester tester) async {
      final GlobalKey materialKey = GlobalKey();
      await tester.pumpWidget(
        Material(
          key: materialKey,
          type: MaterialType.card,
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          elevation: 5.0,
          child: const SizedBox(width: 100.0, height: 100.0),
        ),
      );

      expect(find.byKey(materialKey), rendersOnPhysicalModel(
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          elevation: 5.0,
      ));
    });

    testWidgets('card with shape and elevation', (WidgetTester tester) async {
      final GlobalKey materialKey = GlobalKey();
      await tester.pumpWidget(
        Material(
          key: materialKey,
          type: MaterialType.card,
          shape: const StadiumBorder(),
          elevation: 5.0,
          child: const SizedBox(width: 100.0, height: 100.0),
        ),
      );

      expect(find.byKey(materialKey), rendersOnPhysicalShape(
          shape: const StadiumBorder(),
          elevation: 5.0,
      ));
    });

    testWidgets('circle', (WidgetTester tester) async {
      final GlobalKey materialKey = GlobalKey();
      await tester.pumpWidget(
        Material(
          key: materialKey,
          type: MaterialType.circle,
          color: const Color(0xFF0000FF),
          child: const SizedBox(width: 100.0, height: 100.0),
        ),
      );

      expect(find.byKey(materialKey), rendersOnPhysicalModel(
          shape: BoxShape.circle,
          elevation: 0.0,
      ));
    });

    testWidgets('button', (WidgetTester tester) async {
      final GlobalKey materialKey = GlobalKey();
      await tester.pumpWidget(
        Material(
          key: materialKey,
          type: MaterialType.button,
          color: const Color(0xFF0000FF),
          child: const SizedBox(width: 100.0, height: 100.0),
        ),
      );

      expect(find.byKey(materialKey), rendersOnPhysicalModel(
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(2.0)),
          elevation: 0.0,
      ));
    });

    testWidgets('button with elevation and borderRadius', (WidgetTester tester) async {
      final GlobalKey materialKey = GlobalKey();
      await tester.pumpWidget(
        Material(
          key: materialKey,
          type: MaterialType.button,
          color: const Color(0xFF0000FF),
          borderRadius: const BorderRadius.all(Radius.circular(6.0)),
          elevation: 4.0,
          child: const SizedBox(width: 100.0, height: 100.0),
        ),
      );

      expect(find.byKey(materialKey), rendersOnPhysicalModel(
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(6.0)),
          elevation: 4.0,
      ));
    });

    testWidgets('button with elevation and shape', (WidgetTester tester) async {
      final GlobalKey materialKey = GlobalKey();
      await tester.pumpWidget(
        Material(
          key: materialKey,
          type: MaterialType.button,
          color: const Color(0xFF0000FF),
          shape: const StadiumBorder(),
          elevation: 4.0,
          child: const SizedBox(width: 100.0, height: 100.0),
        ),
      );

      expect(find.byKey(materialKey), rendersOnPhysicalShape(
          shape: const StadiumBorder(),
          elevation: 4.0,
      ));
    });
  });

  group('Border painting', () {
    testWidgets('border is painted on physical layers', (WidgetTester tester) async {
      final GlobalKey materialKey = GlobalKey();
      await tester.pumpWidget(
        Material(
          key: materialKey,
          type: MaterialType.button,
          color: const Color(0xFF0000FF),
          shape: const CircleBorder(
            side: BorderSide(
              width: 2.0,
              color: Color(0xFF0000FF),
            ),
          ),
          child: const SizedBox(width: 100.0, height: 100.0),
        ),
      );

      final RenderBox box = tester.renderObject(find.byKey(materialKey));
      expect(box, paints..circle());
    });

    testWidgets('border is painted for transparent material', (WidgetTester tester) async {
      final GlobalKey materialKey = GlobalKey();
      await tester.pumpWidget(
        Material(
          key: materialKey,
          type: MaterialType.transparency,
          shape: const CircleBorder(
            side: BorderSide(
              width: 2.0,
              color: Color(0xFF0000FF),
            ),
          ),
          child: const SizedBox(width: 100.0, height: 100.0),
        ),
      );

      final RenderBox box = tester.renderObject(find.byKey(materialKey));
      expect(box, paints..circle());
    });

    testWidgets('border is not painted for when border side is none', (WidgetTester tester) async {
      final GlobalKey materialKey = GlobalKey();
      await tester.pumpWidget(
        Material(
          key: materialKey,
          type: MaterialType.transparency,
          shape: const CircleBorder(),
          child: const SizedBox(width: 100.0, height: 100.0),
        ),
      );

      final RenderBox box = tester.renderObject(find.byKey(materialKey));
      expect(box, isNot(paints..circle()));
    });
  });

  testWidgets('InkFeature skips painting if intermediate node skips', (WidgetTester tester) async {
    final GlobalKey sizedBoxKey = GlobalKey();
    final GlobalKey materialKey = GlobalKey();
    await tester.pumpWidget(Material(
      key: materialKey,
      child: Offstage(
        child: SizedBox(key: sizedBoxKey, width: 20, height: 20),
      ),
    ));
    final MaterialInkController controller = Material.of(sizedBoxKey.currentContext!);

    final TrackPaintInkFeature tracker = TrackPaintInkFeature(
      controller: controller,
      referenceBox: sizedBoxKey.currentContext!.findRenderObject()! as RenderBox,
    );
    controller.addInkFeature(tracker);
    expect(tracker.paintCount, 0);

    // Force a repaint. Since it's offstage, the ink feature should not get painted.
    materialKey.currentContext!.findRenderObject()!.paint(PaintingContext(ContainerLayer(), Rect.largest), Offset.zero);
    expect(tracker.paintCount, 0);

    await tester.pumpWidget(Material(
      key: materialKey,
      child: Offstage(
        offstage: false,
        child: SizedBox(key: sizedBoxKey, width: 20, height: 20),
      ),
    ));
    // Gets a paint because the global keys have reused the elements and it is
    // now onstage.
    expect(tracker.paintCount, 1);

    // Force a repaint again. This time, it gets repainted because it is onstage.
    materialKey.currentContext!.findRenderObject()!.paint(PaintingContext(ContainerLayer(), Rect.largest), Offset.zero);
    expect(tracker.paintCount, 2);
  });

  group('LookupBoundary', () {
    testWidgets('hides Material from Material.maybeOf', (WidgetTester tester) async {
      MaterialInkController? material;

      await tester.pumpWidget(
        Material(
          child: LookupBoundary(
            child: Builder(
              builder: (BuildContext context) {
                material = Material.maybeOf(context);
                return Container();
              },
            ),
          ),
        ),
      );

      expect(material, isNull);
    });

    testWidgets('hides Material from Material.of', (WidgetTester tester) async {
      await tester.pumpWidget(
        Material(
          child: LookupBoundary(
            child: Builder(
              builder: (BuildContext context) {
                Material.of(context);
                return Container();
              },
            ),
          ),
        ),
      );
      final Object? exception = tester.takeException();
      expect(exception, isFlutterError);
      final FlutterError error = exception! as FlutterError;

      expect(
        error.toStringDeep(),
        'FlutterError\n'
        '   Material.of() was called with a context that does not have access\n'
        '   to a Material widget.\n'
        '   The context provided to Material.of() does have a Material widget\n'
        '   ancestor, but it is hidden by a LookupBoundary. This can happen\n'
        '   because you are using a widget that looks for a Material\n'
        '   ancestor, but no such ancestor exists within the closest\n'
        '   LookupBoundary.\n'
        '   The context used was:\n'
        '     Builder(dirty)\n'
      );
    });

    testWidgets('hides Material from debugCheckHasMaterial', (WidgetTester tester) async {
      await tester.pumpWidget(
        Material(
          child: LookupBoundary(
            child: Builder(
              builder: (BuildContext context) {
                debugCheckHasMaterial(context);
                return Container();
              },
            ),
          ),
        ),
      );
      final Object? exception = tester.takeException();
      expect(exception, isFlutterError);
      final FlutterError error = exception! as FlutterError;

      expect(
        error.toStringDeep(), startsWith(
          'FlutterError\n'
          '   No Material widget found within the closest LookupBoundary.\n'
          '   There is an ancestor Material widget, but it is hidden by a\n'
          '   LookupBoundary.\n'
          '   Builder widgets require a Material widget ancestor within the\n'
          '   closest LookupBoundary.\n'
          '   In Material Design, most widgets are conceptually "printed" on a\n'
          "   sheet of material. In Flutter's material library, that material\n"
          '   is represented by the Material widget. It is the Material widget\n'
          '   that renders ink splashes, for instance. Because of this, many\n'
          '   material library widgets require that there be a Material widget\n'
          '   in the tree above them.\n'
          '   To introduce a Material widget, you can either directly include\n'
          '   one, or use a widget that contains Material itself, such as a\n'
          '   Card, Dialog, Drawer, or Scaffold.\n'
          '   The specific widget that could not find a Material ancestor was:\n'
          '     Builder\n'
          '   The ancestors of this widget were:\n'
          '     LookupBoundary\n'
        ),
      );
    });
  });
}

class TrackPaintInkFeature extends InkFeature {
  TrackPaintInkFeature({required super.controller, required super.referenceBox});

  int paintCount = 0;
  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {
    paintCount += 1;
  }
}

import 'package:alternative_material_3/material.dart';
import 'package:device_frame/device_frame.dart';
import 'package:flutter/gestures.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // debugDefaultTargetPlatformOverride = TargetPlatform.windows;

    // cursor style between chips still text

    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          materialTapTargetSize: MaterialTapTargetSize.padded,
          minInteractiveDimension: 48.0,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: DeviceFrame(
          device: Devices.android.mediumPhone,
          screen: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showLabel = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 400,
        color: Colors.black26,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SwitchListTile(
              value: true,
              onChanged: (_) {},
              headline: Text('Foo'),
            ),
          ],
        ),
      ),
    );
  }
}

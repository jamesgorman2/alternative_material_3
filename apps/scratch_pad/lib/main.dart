import 'package:alternative_material_3/material.dart';
import 'package:flutter/services.dart';

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

    return
      MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        materialTapTargetSize: MaterialTapTargetSize.padded,
        minInteractiveDimension: 48.0,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
            Container(
              width: 350,
              color: Colors.white70,
              child: TextField.outlined(
                decoration: const InputDecoration(
                  label: Text('Label'),
                ),
                chips: TextFieldInputChips<int>(
                  // singleLine: true,
                  maxChipWidth: 300,
                  onDeleted: (value) => print('Deleted $value'),
                  chips: [
                    const InputChipData<int>(
                      value: 0,
                      label: Text('Label 0Label 0Label 0Label 0Label 0Label 0Label 0Label 0Label 0Label 0'),
                    ),
                    const InputChipData<int>(
                      value: 1,
                      label: Text('Label 1'),
                    ),
                    const InputChipData<int>(
                      value: 2,
                      label: Text('Label 2'),
                    ),
                    const InputChipData<int>(
                      value: 3,
                      label: Text('Label 3'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

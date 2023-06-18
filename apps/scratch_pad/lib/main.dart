import 'package:alternative_material_3/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    return MaterialApp(
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

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 300,
        color: Colors.black26,
        padding: const EdgeInsets.all(24),
        child: Container(
          color: Colors.white70,
          child: ChipList(
            // singleLine: true,
            theme: const ChipListThemeData(
              maxLines: 2,
              overflowLineHeight: 0.5,
            ),
            children: [
                InputChip(
                label: const Text('Label 1'),
                onPressed: () {},
                onDeletePressed: () {},
              ),
              InputChip(
                label: const Text('Label 2'),
                onPressed: () {},
                onDeletePressed: () {},
              ),
              InputChip(
                label: const Text('Label 3'),
                onPressed: () {},
                onDeletePressed: () {},
              ),
              InputChip(
                label: const Text('Label 4'),
                onPressed: () {},
                onDeletePressed: () {},
              ),
              InputChip(
                label: const Text('Label 5'),
                onPressed: () {},
                onDeletePressed: () {},
              ),
              const Text('Text'),
            ],
          ),
        ),
      ),
    );
  }
}

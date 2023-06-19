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
        width: 300,
        color: Colors.black26,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.white70,
              child: FloatingActionButton.extended(
                onPressed: () => setState(() {
                  showLabel = !showLabel;
                }),
                icon: const Icon(Icons.add),
                label: showLabel ? const Text('Label') : null,
              ),
            ),
            SizedBox(height: 24),
            AnimatedRow(
              duration: Duration(milliseconds: 300),
              children: [
                const Icon(Icons.add),
                showLabel ? const Text('Label') : null,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

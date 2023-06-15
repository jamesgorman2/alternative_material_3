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
        padding: const EdgeInsets.all(24),
        child: const Column(
          children: [
            // TextField.plain(
            //   maxLines: 3,
            // ),
            // TextField.underlined(
            //   decoration: InputDecoration(
            //     label: Text('Label'),
            //     placeholderText: 'Money',
            //     prefixIcon: Icon(Icons.search_outlined),
            //     prefix: Text('\$'),
            //     suffix: Text('.00'),
            //     suffixIcon: Icon(Icons.cancel_outlined),
            //     supportingText: 'You\'re great!',
            //   ),
            //   maxLines: 3,
            // ),
            // TextField.filled(
            //   decoration: InputDecoration(
            //     label: Text('Label'),
            //     placeholderText: 'Money',
            //     prefixIcon: Icon(Icons.search_outlined),
            //     prefix: Text('\$'),
            //     suffix: Text('.00'),
            //     suffixIcon: Icon(Icons.cancel_outlined),
            //     supportingText: 'You\'re great!',
            //   ),
            //   maxLines: 3,
            // ),
            TextField.filled(
              theme: TextFieldThemeData(
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                supportingTextMinLines: 2,
              ),
              decoration: InputDecoration(
                label: Text('Label'),
                placeholderText: 'Money',
                prefixIcon: Icon(Icons.search_outlined),
                prefix: Text('\$'),
                suffix: Text('.00'),
                suffixIcon: Icon(Icons.cancel_outlined),
                supportingText: 'You\'re great! ',
                // errorText: 'You\'re not great!',
              ),
              minLines: 1,
              maxLines: 3,
              // maxLength: 10,
            ),
          ],
        ),
      ),
    );
  }
}

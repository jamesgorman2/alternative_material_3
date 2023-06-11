import 'package:alternative_material_3/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Icon? leading;
  String label = 'FooFoo';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1)).then((value) {
      setState(() {
        leading = const Icon(Icons.add_circle_outline);
      });
    });
    Future.delayed(Duration(seconds: 2)).then((value) {
      setState(() {
        label = 'FooFooFooFoo';
      });
    });
    Future.delayed(Duration(seconds: 3)).then((value) {
      setState(() {
        label = 'BarBarBarBarBarBarBar';
      });
    });
    Future.delayed(Duration(seconds: 4)).then((value) {
      setState(() {
        leading = null;
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              color: Colors.black12,
              constraints: const BoxConstraints(
                maxWidth: 200,
              ),
              child: ButtonContent(
                startPadding: 8.0,
                endLeadingPadding: 8.0,
                startTrailingPadding: 8.0,
                endPadding: 8.0,
                leadingIcon: leading,
                label: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailingIcon: const Icon(Icons.drafts_outlined),
                containerConstraints: const BoxConstraints.expand(),
                animationDuration: const Duration(milliseconds: 1000),
              ),
            ),
            // Container(
            //   color: Colors.black12,
            //   constraints: const BoxConstraints(
            //     maxWidth: 200,
            //   ),
            //   child: const ButtonContent(
            //     startPadding: 8.0,
            //     endLeadingPadding: 8.0,
            //     startTrailingPadding: 8.0,
            //     endPadding: 8.0,
            //     leadingIcon: Icon(Icons.add_circle_outline),
            //     label: Text(
            //       'FooFooFooFooFooFooFoo',
            //       maxLines: 1,
            //       overflow: TextOverflow.ellipsis,
            //     ),
            //     trailingIcon: null,
            //     containerConstraints: BoxConstraints.expand(),
            //     animationDuration: Duration(milliseconds: 1000),
            //   ),
            // ),
            // Container(
            //   color: Colors.black12,
            //   constraints: const BoxConstraints(
            //     maxWidth: 200,
            //   ),
            //   child: const ButtonContent(
            //     startPadding: 8.0,
            //     endLeadingPadding: 8.0,
            //     startTrailingPadding: 8.0,
            //     endPadding: 8.0,
            //     leadingIcon: null,
            //     label: Text(
            //       'FooFooFooFooFooFooFooFooFooFooFooFooFooFoo',
            //       maxLines: 1,
            //       overflow: TextOverflow.ellipsis,
            //     ),
            //     trailingIcon: null,
            //     containerConstraints: BoxConstraints.expand(),
            //     animationDuration: Duration(milliseconds: 1000),
            //   ),
            // ),
          ],
        ),
      )),
    );
  }
}

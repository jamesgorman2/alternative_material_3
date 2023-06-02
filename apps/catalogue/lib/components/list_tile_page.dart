import 'package:alternative_material_3/material.dart';

import '../common_scaffold.dart';
import 'component_card.dart';
import 'components_overview.dart';

class ListTilePage extends StatelessWidget {
  const ListTilePage({super.key});

  static const String route = '${ComponentsOverview.route}/lists';
  static const String label = 'Lists';

  @override
  Widget build(BuildContext context) {
    final colorSchemeLight = Theme.of(context).colorScheme.asLight();
    final colorSchemeDark = colorSchemeLight.asDark();

    return CommonScaffold(
      title: const Text(label),
      body: Column(
        children: [
          SingleLineListTiles(colorScheme: colorSchemeLight),
          const SizedBox(height: 24.0),
          TwoListListTiles(colorScheme: colorSchemeLight),
          const SizedBox(height: 24.0),
          ThreeListListTiles(colorScheme: colorSchemeLight),
          const SizedBox(height: 24.0),
          CheckboxTiles(colorScheme: colorSchemeLight),
          const SizedBox(height: 24.0),
          RadioButtonTiles(colorScheme: colorSchemeLight),
          const SizedBox(height: 24.0),
          SwitchTiles(colorScheme: colorSchemeLight),
          const SizedBox(height: 24.0),
          ExpansionTiles(colorScheme: colorSchemeLight),
          const SizedBox(height: 24.0),
          SingleLineListTiles(colorScheme: colorSchemeDark),
          const SizedBox(height: 24.0),
          TwoListListTiles(colorScheme: colorSchemeDark),
          const SizedBox(height: 24.0),
          ThreeListListTiles(colorScheme: colorSchemeDark),
          const SizedBox(height: 24.0),
          CheckboxTiles(colorScheme: colorSchemeDark),
          const SizedBox(height: 24.0),
          RadioButtonTiles(colorScheme: colorSchemeDark),
          const SizedBox(height: 24.0),
          SwitchTiles(colorScheme: colorSchemeDark),
          const SizedBox(height: 24.0),
          ExpansionTiles(colorScheme: colorSchemeDark),
        ],
      ),
    );
  }
}

class ListTilesCard extends StatelessWidget {
  const ListTilesCard({
    super.key,
    required this.label,
    required this.colorScheme,
    required this.children,
  });

  final String label;
  final ColorScheme colorScheme;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LabeledComponentCard(
      label: label,
      colorScheme: colorScheme,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Material(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}

class ListTilesCard2 extends StatelessWidget {
  const ListTilesCard2({
    super.key,
    required this.label,
    required this.colorScheme,
    required this.columnA,
    required this.columnB,
  });

  final String label;
  final ColorScheme colorScheme;
  final List<Widget> columnA;
  final List<Widget> columnB;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 800,
          ),
          child: Container(
            alignment: AlignmentDirectional.topStart,
            padding: const EdgeInsetsDirectional.only(start: 8.0),
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        ComponentCard(
          colorScheme: colorScheme,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Material(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: columnA,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Material(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: columnB,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SingleLineListTiles extends StatelessWidget {
  const SingleLineListTiles({super.key, required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return ListTilesCard(
      label: 'One-line lists',
      colorScheme: colorScheme,
      children: [
        const ListTile(
          headline: Text('Headline'),
        ),
        const ListTile(
          leading: ListTileElement.icon24(child: Icon(Icons.person_outline)),
          headline: Text('Headline'),
        ),
        CheckboxListTile(
          value: true,
          onChanged: (bool? value) {},
          secondary: const ListTileElement.avatar(
            child: CircleAvatar(
              child: Text('A'),
            ),
          ),
          headline: const Text('Headline'),
        ),
        const ListTile(
          leading: ListTileElement.image(
              child: Image(image: AssetImage('images/image_proxy.png'))),
          headline: Text('Headline'),
          trailing: ListTileElement.supportingText(child: Text('100+')),
        ),
        CheckboxListTile(
          value: true,
          onChanged: (bool? value) {},
          secondary: const ListTileElement.video(
            child: Image(
              fit: BoxFit.fitWidth,
              height: 64.0,
              width: 114,
              image: AssetImage('images/image_proxy.png'),
            ),
          ),
          headline: const Text('Headline'),
        ),
      ],
    );
  }
}

class TwoListListTiles extends StatelessWidget {
  const TwoListListTiles({super.key, required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return ListTilesCard2(
      label: 'Two-line lists',
      colorScheme: colorScheme,
      columnA: [
        const ListTile(
          headline: Text('Headline'),
          supportingText: Text('Supporting text'),
        ),
        const ListTile(
          leading: ListTileElement.icon24(child: Icon(Icons.person_outline)),
          headline: Text('Headline'),
          supportingText: Text('Supporting text'),
        ),
        CheckboxListTile(
          value: true,
          onChanged: (bool? value) {},
          layout: ListTileLayout.twoLine,
          secondary: const ListTileElement.avatar(
            child: CircleAvatar(
              child: Text('A'),
            ),
          ),
          headline: const Text('Headline'),
          supportingText: const Text(
              'Supporting text that is long enough to fill up multiple lines'),
        ),
        const ListTile(
          leading: ListTileElement.image(
              child: Image(image: AssetImage('images/image_proxy.png'))),
          headline: Text('Headline'),
          supportingText: Text('Supporting text'),
          trailing: ListTileElement.supportingText(child: Text('100+')),
        ),
        CheckboxListTile(
          value: true,
          onChanged: (bool? value) {},
          secondary: const ListTileElement.video(
            child: Image(
              fit: BoxFit.fitWidth,
              height: 64.0,
              width: 114,
              image: AssetImage('images/image_proxy.png'),
            ),
          ),
          headline: const Text('Headline'),
          supportingText: const Text('Supporting text'),
        ),
      ],
      columnB: [
        const ListTile(
          overline: Text('Overline'),
          headline: Text('Headline'),
        ),
        const ListTile(
          leading: ListTileElement.icon24(child: Icon(Icons.person_outline)),
          overline: Text('Overline'),
          headline: Text('Headline'),
        ),
        CheckboxListTile(
          value: true,
          onChanged: (bool? value) {},
          layout: ListTileLayout.twoLine,
          secondary: const ListTileElement.avatar(
            child: CircleAvatar(
              child: Text('A'),
            ),
          ),
          overline: const Text(
              'Overline text that that is long enough to fill up multiple lines'),
          headline: const Text('Headline'),
        ),
        const ListTile(
          leading: ListTileElement.image(
              child: Image(image: AssetImage('images/image_proxy.png'))),
          overline: Text('Overline'),
          headline: Text('Headline'),
          trailing: ListTileElement.supportingText(child: Text('100+')),
        ),
        CheckboxListTile(
          value: true,
          onChanged: (bool? value) {},
          secondary: const ListTileElement.video(
            child: Image(
              fit: BoxFit.fitWidth,
              height: 64.0,
              width: 114,
              image: AssetImage('images/image_proxy.png'),
            ),
          ),
          overline: const Text('Overline'),
          headline: const Text('Headline'),
        ),
      ],
    );
  }
}

class ThreeListListTiles extends StatelessWidget {
  const ThreeListListTiles({super.key, required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return ListTilesCard2(
      label: 'Three-line lists',
      colorScheme: colorScheme,
      columnA: [
        const ListTile(
          headline: Text('Headline'),
          supportingText: Text(
              'Supporting text that is long enough to fill up multiple lines'),
        ),
        const ListTile(
          leading: ListTileElement.icon24(child: Icon(Icons.person_outline)),
          headline: Text('Headline'),
          supportingText: Text(
              'Supporting text that is long enough to fill up multiple lines'),
        ),
        CheckboxListTile(
          value: true,
          onChanged: (bool? value) {},
          secondary: const ListTileElement.avatar(
            child: CircleAvatar(
              child: Text('A'),
            ),
          ),
          headline: const Text('Headline'),
          supportingText: const Text(
              'Supporting text that is long enough to fill up multiple lines'),
        ),
        const ListTile(
          leading: ListTileElement.image(
              child: Image(image: AssetImage('images/image_proxy.png'))),
          headline: Text('Headline'),
          supportingText: Text(
              'Supporting text that is long enough to fill up multiple lines'),
          trailing: ListTileElement.supportingText(child: Text('100+')),
        ),
        CheckboxListTile(
          value: true,
          onChanged: (bool? value) {},
          secondary: const ListTileElement.video(
            child: Image(
              fit: BoxFit.fitWidth,
              height: 64.0,
              width: 114,
              image: AssetImage('images/image_proxy.png'),
            ),
          ),
          headline: const Text('Headline'),
          supportingText: const Text(
              'Supporting text that is long enough to fill up multiple lines'),
        ),
      ],
      columnB: [
        const ListTile(
          overline: Text('Overline'),
          headline: Text('Headline'),
          supportingText: Text(
              'Supporting text that is long enough to fill up multiple lines'),
        ),
        const ListTile(
          leading: ListTileElement.icon24(child: Icon(Icons.person_outline)),
          overline: Text('Overline'),
          headline: Text('Headline'),
          supportingText: Text(
              'Supporting text that is long enough to fill up multiple lines'),
        ),
        CheckboxListTile(
          value: true,
          onChanged: (bool? value) {},
          secondary: const ListTileElement.avatar(
            child: CircleAvatar(
              child: Text('A'),
            ),
          ),
          overline: const Text('Overline'),
          headline: const Text('Headline'),
          supportingText: const Text(
              'Supporting text that is long enough to fill up multiple lines'),
        ),
        const ListTile(
          leading: ListTileElement.image(
              child: Image(image: AssetImage('images/image_proxy.png'))),
          overline: Text('Overline'),
          headline: Text('Headline'),
          supportingText: Text(
              'Supporting text that is long enough to fill up multiple lines'),
          trailing: ListTileElement.supportingText(child: Text('100+')),
        ),
        CheckboxListTile(
          value: true,
          onChanged: (bool? value) {},
          secondary: const ListTileElement.video(
            child: Image(
              fit: BoxFit.fitWidth,
              height: 64.0,
              width: 114,
              image: AssetImage('images/image_proxy.png'),
            ),
          ),
          overline: const Text('Overline'),
          headline: const Text('Headline'),
          supportingText: const Text(
              'Supporting text that is long enough to fill up multiple lines'),
        ),
      ],
    );
  }
}

class CheckboxTiles extends StatefulWidget {
  const CheckboxTiles({super.key, required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  State<CheckboxTiles> createState() => _CheckboxTilesState();
}

class _CheckboxTilesState extends State<CheckboxTiles> {
  List<bool?> checked = List.filled(6, false);

  void handleChange(bool? value, int i) {
    if (checked[i] != value) {
      setState(() {
        checked[i] = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTilesCard2(
      label: 'With checkbox',
      colorScheme: widget.colorScheme,
      columnA: [
        CheckboxListTile(
          value: checked[0],
          onChanged: (bool? v) => handleChange(v, 0),
          headline: const Text('Headline'),
          supportingText: const Text(
              'Supporting text that is long enough to fill up multiple lines'),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        CheckboxListTile(
          value: checked[1],
          onChanged: (bool? v) => handleChange(v, 1),
          headline: const Text('Headline'),
          supportingText: const Text('Supporting text'),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        CheckboxListTile(
          value: checked[2],
          onChanged: (bool? v) => handleChange(v, 2),
          headline: const Text('Headline'),
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ],
      columnB: [
        CheckboxListTile(
          value: checked[3],
          onChanged: (bool? v) => handleChange(v, 3),
          headline: const Text('Headline'),
          supportingText: const Text(
              'Supporting text that is long enough to fill up multiple lines'),
          secondary: const ListTileElement.supportingText(child: Text('100+')),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        CheckboxListTile(
          value: checked[4],
          onChanged: (bool? v) => handleChange(v, 4),
          headline: const Text('Headline'),
          supportingText: const Text('Supporting text'),
          secondary: const ListTileElement.supportingText(child: Text('100+')),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        CheckboxListTile(
          value: checked[5],
          onChanged: (bool? v) => handleChange(v, 5),
          headline: const Text('Headline'),
          secondary: const ListTileElement.supportingText(child: Text('100+')),
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ],
    );
  }
}

class RadioButtonTiles extends StatefulWidget {
  const RadioButtonTiles({super.key, required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  State<RadioButtonTiles> createState() => _RadioButtonTilesState();
}

class _RadioButtonTilesState extends State<RadioButtonTiles> {
  int? selectedA = 0;
  int? selectedB = 0;

  void handleChangeA(int? value) {
    if (value != selectedA) {
      setState(() {
        selectedA = value;
      });
    }
  }

  void handleChangeB(int? value) {
    if (value != selectedB) {
      setState(() {
        selectedB = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTilesCard2(
      label: 'With radio buttons',
      colorScheme: widget.colorScheme,
      columnA: [
        RadioListTile<int>(
          value: 0,
          groupValue: selectedA,
          onChanged: handleChangeA,
          headline: const Text('Headline'),
          supportingText: const Text(
              'Supporting text that is long enough to fill up multiple lines'),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        RadioListTile<int>(
          value: 1,
          groupValue: selectedA,
          onChanged: handleChangeA,
          headline: const Text('Headline'),
          supportingText: const Text('Supporting text'),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        RadioListTile<int>(
          value: 2,
          groupValue: selectedA,
          onChanged: handleChangeA,
          headline: const Text('Headline'),
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ],
      columnB: [
        RadioListTile<int>(
          value: 0,
          groupValue: selectedB,
          onChanged: handleChangeB,
          headline: const Text('Headline'),
          supportingText: const Text(
              'Supporting text that is long enough to fill up multiple lines'),
          secondary: const ListTileElement.supportingText(child: Text('100+')),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        RadioListTile<int>(
          value: 1,
          groupValue: selectedB,
          onChanged: handleChangeB,
          headline: const Text('Headline'),
          supportingText: const Text('Supporting text'),
          secondary: const ListTileElement.supportingText(child: Text('100+')),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        RadioListTile<int>(
          value: 2,
          groupValue: selectedB,
          onChanged: handleChangeB,
          headline: const Text('Headline'),
          secondary: const ListTileElement.supportingText(child: Text('100+')),
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ],
    );
  }
}

class SwitchTiles extends StatefulWidget {
  const SwitchTiles({super.key, required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  State<SwitchTiles> createState() => _SwitchTilesState();
}

class _SwitchTilesState extends State<SwitchTiles> {
  List<bool> checked = List.filled(6, false);

  void handleChange(bool value, int i) {
    if (checked[i] != value) {
      setState(() {
        checked[i] = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTilesCard2(
      label: 'With switch',
      colorScheme: widget.colorScheme,
      columnA: [
        SwitchListTile(
          value: checked[0],
          onChanged: (bool v) => handleChange(v, 0),
          headline: const Text('Headline'),
          supportingText: const Text(
              'Supporting text that is long enough to fill up multiple lines'),
        ),
        SwitchListTile(
          value: checked[1],
          onChanged: (bool v) => handleChange(v, 1),
          headline: const Text('Headline'),
          supportingText: const Text('Supporting text'),
        ),
        SwitchListTile(
          value: checked[2],
          onChanged: (bool v) => handleChange(v, 2),
          headline: const Text('Headline'),
        ),
      ],
      columnB: [
        SwitchListTile(
          value: checked[3],
          onChanged: (bool v) => handleChange(v, 3),
          headline: const Text('Headline'),
          supportingText: const Text(
              'Supporting text that is long enough to fill up multiple lines'),
          secondary:
              const ListTileElement.icon24(child: Icon(Icons.person_outline)),
        ),
        SwitchListTile(
          value: checked[4],
          onChanged: (bool v) => handleChange(v, 4),
          headline: const Text('Headline'),
          supportingText: const Text('Supporting text'),
          secondary:
              const ListTileElement.icon24(child: Icon(Icons.person_outline)),
        ),
        SwitchListTile(
          value: checked[5],
          onChanged: (bool v) => handleChange(v, 5),
          headline: const Text('Headline'),
          secondary:
              const ListTileElement.icon24(child: Icon(Icons.person_outline)),
        ),
      ],
    );
  }
}

class ExpansionTiles extends StatefulWidget {
  const ExpansionTiles({super.key, required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  State<ExpansionTiles> createState() => _ExpansionTilesState();
}

class _ExpansionTilesState extends State<ExpansionTiles> {
  bool expanded = false;

  void handleExpand(bool value) {
    if (value != expanded) {
      setState(() {
        expanded = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTilesCard(
      label: 'Expansion tiles',
      colorScheme: widget.colorScheme,
      children: [
        ExpansionTile(
          secondary:
              const ListTileElement.icon24(child: Icon(Icons.place_outlined)),
          headline: const Text('Single line item'),
          theme: const ExpansionTileThemeData(
            showBottomDividerWhenExpanded: false,
          ),
          listTileTheme: ListTileThemeData(
            leadingColor:
                expanded ? Theme.of(context).colorScheme.primary : null,
          ),
          onExpansionChangeStart: handleExpand,
          child: const Column(
            children: [
              ListTile(
                leading: ListTileElement.icon24(child: SizedBox(width: 24)),
                headline: Text('Expanded item 1'),
              ),
              ListTile(
                leading: ListTileElement.icon24(child: SizedBox(width: 24)),
                headline: Text('Expanded item 2'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

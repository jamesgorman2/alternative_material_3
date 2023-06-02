import 'package:alternative_material_3/material.dart';

import '../common_scaffold.dart';
import 'component_card.dart';
import 'components_overview.dart';

class ChipsPage extends StatelessWidget {
  const ChipsPage({super.key});

  static const String route = '${ComponentsOverview.route}/chips';
  static const String label = 'Chips';

  static const Widget imageIcon = Image(
    image: AssetImage('images/colored_icon.png'),
  );

  @override
  Widget build(BuildContext context) {
    final colorSchemeLight = Theme.of(context).colorScheme.asLight();
    final colorSchemeDark = colorSchemeLight.asDark();

    return CommonScaffold(
      title: const Text(label),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AssistChips(colorScheme: colorSchemeLight),
          const SizedBox(height: 16.0),
          FilterChips(colorScheme: colorSchemeLight),
          const SizedBox(height: 16.0),
          MultiSelectFilterChips(colorScheme: colorSchemeLight),
          const SizedBox(height: 16.0),
          InputChips(colorScheme: colorSchemeLight),
          const SizedBox(height: 16.0),
          SuggestionChips(colorScheme: colorSchemeLight),
          const SizedBox(height: 16.0),
          AssistChips(colorScheme: colorSchemeDark),
          const SizedBox(height: 16.0),
          FilterChips(colorScheme: colorSchemeDark),
          const SizedBox(height: 16.0),
          MultiSelectFilterChips(colorScheme: colorSchemeDark),
          const SizedBox(height: 16.0),
          InputChips(colorScheme: colorSchemeDark),
          const SizedBox(height: 16.0),
          SuggestionChips(colorScheme: colorSchemeDark),
        ],
      ),
    );
  }
}

class AssistChips extends StatelessWidget {
  const AssistChips({super.key, required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return LabeledComponentCard(
      label: 'Assist chips',
      colorScheme: colorScheme,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              AssistChip(
                label: const Text('Assist chip'),
                onPressed: () {},
              ),
              const SizedBox(height: 16.0),
              AssistChip.elevated(
                label: const Text('Assist chip'),
                onPressed: () {},
              ),
              const SizedBox(height: 36.0),
              AssistChip(
                label: const Text('Assist chip'),
                icon: const Icon(Icons.local_taxi_outlined),
                onPressed: () {},
              ),
              const SizedBox(height: 16.0),
              AssistChip.elevated(
                label: const Text('Assist chip'),
                icon: const Icon(Icons.local_taxi_outlined),
                onPressed: () {},
              ),
              const SizedBox(height: 36.0),
              AssistChip(
                label: const Text('Assist chip'),
                icon: ChipsPage.imageIcon,
                onPressed: () {},
              ),
              const SizedBox(height: 16.0),
              AssistChip.elevated(
                label: const Text('Assist chip'),
                icon: ChipsPage.imageIcon,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(width: 48.0),
          const Column(
            children: [
              AssistChip(
                label: Text('Assist chip'),
              ),
              SizedBox(height: 16.0),
              AssistChip.elevated(
                label: Text('Assist chip'),
              ),
              SizedBox(height: 36.0),
              AssistChip(
                label: Text('Assist chip'),
                icon: Icon(Icons.local_taxi_outlined),
              ),
              SizedBox(height: 16.0),
              AssistChip.elevated(
                label: Text('Assist chip'),
                icon: Icon(Icons.local_taxi_outlined),
              ),
              SizedBox(height: 36.0),
              AssistChip(
                label: Text('Assist chip'),
                icon: ChipsPage.imageIcon,
              ),
              SizedBox(height: 16.0),
              AssistChip.elevated(
                label: Text('Assist chip'),
                icon: ChipsPage.imageIcon,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FilterChips extends StatelessWidget {
  const FilterChips({super.key, required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return LabeledComponentCard(
      label: 'Filter chips',
      colorScheme: colorScheme,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  FilterChip(
                    label: const Text('Filter chip'),
                    isSelected: false,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 16.0),
                  FilterChip.elevated(
                    label: const Text('Filter chip'),
                    isSelected: false,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 36.0),
                  FilterChip(
                    label: const Text('Filter chip'),
                    isSelected: true,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 16.0),
                  FilterChip.elevated(
                    label: const Text('Filter chip'),
                    isSelected: true,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 36.0),
                  FilterChip(
                    label: const Text('Filter chip'),
                    isSelected: true,
                    trailingIcon: const Icon(Icons.arrow_drop_down_outlined),
                    onPressed: () {},
                    onTrailingIconPressed: () {},
                  ),
                  const SizedBox(height: 16.0),
                  FilterChip.elevated(
                    label: const Text('Filter chip'),
                    isSelected: true,
                    trailingIcon: const Icon(Icons.arrow_drop_down_outlined),
                    onPressed: () {},
                    onTrailingIconPressed: () {},
                  ),
                ],
              ),
              const SizedBox(width: 48.0),
              Column(
                children: [
                  const FilterChip(
                    label: Text('Filter chip'),
                    isSelected: false,
                  ),
                  const SizedBox(height: 16.0),
                  const FilterChip.elevated(
                    label: Text('Filter chip'),
                    isSelected: false,
                  ),
                  const SizedBox(height: 36.0),
                  const FilterChip(
                    label: Text('Filter chip'),
                    isSelected: true,
                  ),
                  const SizedBox(height: 16.0),
                  const FilterChip.elevated(
                    label: Text('Filter chip'),
                    isSelected: true,
                  ),
                  const SizedBox(height: 36.0),
                  FilterChip(
                    label: const Text('Filter chip'),
                    trailingIcon: const Icon(Icons.arrow_drop_down_outlined),
                    isSelected: true,
                    onTrailingIconPressed: () {},
                  ),
                  const SizedBox(height: 16.0),
                  FilterChip.elevated(
                    label: const Text('Filter chip'),
                    trailingIcon: const Icon(Icons.arrow_drop_down_outlined),
                    isSelected: true,
                    onTrailingIconPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 36.0),
          FilterChipsExample(colorScheme: colorScheme),
        ],
      ),
    );
  }
}

class FilterChipsExample extends StatefulWidget {
  const FilterChipsExample({super.key, required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  State<FilterChipsExample> createState() => _FilterChipsExampleState();
}

class _FilterChipsExampleState extends State<FilterChipsExample> {
  int? singleSelected;
  List<bool> multiSelected = List.filled(4, false);

  void handleSelectSingle(int? i) {
    setState(() {
      if (i != singleSelected) {
        singleSelected = i;
      } else {
        singleSelected = null;
      }
    });
  }

  void handleSelectMulti(int i) {
    setState(() {
      multiSelected[i] = !multiSelected[i];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilterChip(
              isSelected: multiSelected[0],
              label: const Text('Extra soft'),
              onPressed: () => handleSelectMulti(0),
            ),
            const SizedBox(width: 8),
            FilterChip(
              isSelected: multiSelected[1],
              label: const Text('Soft'),
              onPressed: () => handleSelectMulti(1),
            ),
            const SizedBox(width: 8),
            FilterChip(
              isSelected: multiSelected[2],
              label: const Text('Medium'),
              onPressed: () => handleSelectMulti(2),
            ),
            const SizedBox(width: 8),
            FilterChip(
              isSelected: multiSelected[3],
              label: const Text('Hard'),
              onPressed: () => handleSelectMulti(3),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Filter chip group',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilterChip.elevated(
              isSelected: singleSelected == 0,
              label: const Text('Extra soft'),
              onPressed: () => handleSelectSingle(0),
            ),
            const SizedBox(width: 8),
            FilterChip.elevated(
              isSelected: singleSelected == 1,
              label: const Text('Soft'),
              onPressed: () => handleSelectSingle(1),
            ),
            const SizedBox(width: 8),
            FilterChip.elevated(
              isSelected: singleSelected == 2,
              label: const Text('Medium'),
              onPressed: () => handleSelectSingle(2),
            ),
            const SizedBox(width: 8),
            FilterChip.elevated(
              isSelected: singleSelected == 3,
              label: const Text('Hard'),
              onPressed: () => handleSelectSingle(3),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Toggled filter chip group',
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ],
    );
  }
}

class MultiSelectFilterChips extends StatefulWidget {
  const MultiSelectFilterChips({super.key, required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  State<MultiSelectFilterChips> createState() => _MultiSelectFilterChipsState();
}

class _MultiSelectFilterChipsState extends State<MultiSelectFilterChips> {
  List<bool> selected = List.filled(2, false);

  void _handleFirstExampleSelect(int i) {
    setState(() {
      selected[i] = !selected[i];
    });
  }

  final List<FilterChipChoice<int>> _filters = [
    const FilterChipChoice(
      value: 0,
      label: Text('Running'),
      icon: Icon(Icons.directions_walk_outlined),
    ),
    const FilterChipChoice(
      value: 1,
      label: Text('Walking'),
      icon: Icon(Icons.directions_run_outlined),
    ),
    const FilterChipChoice(
      value: 2,
      label: Text('Hiking'),
      icon: Icon(Icons.nordic_walking_outlined),
    ),
    const FilterChipChoice(
      value: 3,
      label: Text('Cycling'),
      icon: Icon(Icons.directions_bike_outlined),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final scrollController = ControlledScroll.of(context)!;

    return LabeledComponentCard(
      label: 'Multi-select filter chips',
      colorScheme: widget.colorScheme,
      child: Builder(builder: (context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const SizedBox(height: 16.0),
                MultiSelectFilterChip(
                  filters: _filters,
                  initialFilterValue: 0,
                  onFilterChanged: (_) {},
                  isSelected: selected[0],
                  onPressed: () => _handleFirstExampleSelect(0),
                  scrollControllers: [scrollController],
                ),
                const SizedBox(height: 16.0),
                MultiSelectFilterChip.elevated(
                  filters: _filters,
                  initialFilterValue: 0,
                  onFilterChanged: (_) {},
                  isSelected: selected[1],
                  onPressed: () => _handleFirstExampleSelect(1),
                  scrollControllers: [scrollController],
                ),
                const SizedBox(height: 12.0),
                Text(
                  'Select and toggle not linked',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 16.0),
              ],
            ),
            const SizedBox(width: 24.0),
            Column(
              children: [
                const SizedBox(height: 16.0),
                MultiSelectFilterChip(
                  filters: _filters,
                  initialFilterValue: 0,
                  onFilterChanged: (_) {},
                  isSelected: true,
                  scrollControllers: [scrollController],
                ),
                const SizedBox(height: 16.0),
                MultiSelectFilterChip.elevated(
                  filters: _filters,
                  initialFilterValue: 0,
                  onFilterChanged: (_) {},
                  isSelected: true,
                  scrollControllers: [scrollController],
                ),
                const SizedBox(height: 12.0),
                Text(
                  'Always selected',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 16.0),
              ],
            ),
            const SizedBox(width: 24.0),
            Column(
              children: [
                const SizedBox(height: 16.0),
                MultiSelectFilterChip(
                  filters: _filters,
                  initialFilterValue: 0,
                  onFilterChanged: (_) {},
                  isSelected: false,
                  scrollControllers: [scrollController],
                ),
                const SizedBox(height: 16.0),
                MultiSelectFilterChip.elevated(
                  filters: _filters,
                  initialFilterValue: 0,
                  onFilterChanged: (_) {},
                  isSelected: false,
                  scrollControllers: [scrollController],
                ),
                const SizedBox(height: 12.0),
                Text(
                  'Always unselected',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ],
        );
      }),
    );
  }
}

class InputChips extends StatelessWidget {
  const InputChips({super.key, required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return LabeledComponentCard(
      label: 'Input chips',
      colorScheme: colorScheme,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              InputChip(
                label: const Text('Input chip'),
                onPressed: () {},
                onDeletePressed: () {},
              ),
              const SizedBox(height: 16.0),
              InputChip(
                avatar: const CircleAvatar(
                  backgroundImage: AssetImage('images/avatar.png'),
                ),
                label: const Text('Input chip'),
                onPressed: () {},
                onDeletePressed: () {},
              ),
              const SizedBox(height: 16.0),
              InputChip(
                icon: const Icon(Icons.image_outlined),
                label: const Text('Input chip'),
                onPressed: () {},
                onDeletePressed: () {},
              ),
              const SizedBox(height: 36.0),
              InputChip(
                label: const Text('Input chip'),
                isSelected: true,
                hideDeleteIcon: () => true,
                onPressed: () {},
              ),
              const SizedBox(height: 16.0),
              InputChip(
                icon: const Icon(Icons.image_outlined),
                label: const Text('Input chip'),
                isSelected: true,
                onPressed: () {},
                onDeletePressed: () {},
              ),
            ],
          ),
          const SizedBox(width: 48.0),
          Column(
            children: [
              const InputChip(
                label: Text('Input chip'),
                enabled: false,
              ),
              const SizedBox(height: 16.0),
              const InputChip(
                avatar: CircleAvatar(
                  backgroundImage: AssetImage('images/avatar.png'),
                ),
                label: Text('Input chip'),
                enabled: false,
              ),
              const SizedBox(height: 16.0),
              const InputChip(
                icon: Icon(Icons.image_outlined),
                label: Text('Input chip'),
                enabled: false,
              ),
              const SizedBox(height: 36.0),
              InputChip(
                label: const Text('Input chip'),
                isSelected: true,
                hideDeleteIcon: () => true,
                enabled: false,
              ),
              const SizedBox(height: 16.0),
              const InputChip(
                icon: Icon(Icons.image_outlined),
                label: Text('Input chip'),
                isSelected: true,
                enabled: false,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class SuggestionChips extends StatelessWidget {
  const SuggestionChips({super.key, required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return LabeledComponentCard(
      label: 'Suggestion chips',
      colorScheme: colorScheme,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              SuggestionChip(
                label: const Text('Suggestion chip'),
                onPressed: () {},
              ),
              const SizedBox(height: 16.0),
              SuggestionChip.elevated(
                label: const Text('Suggestion chip'),
                onPressed: () {},
              ),
              const SizedBox(height: 36.0),
              SuggestionChip(
                label: const Text('Suggestion chip'),
                isSelected: true,
                onPressed: () {},
              ),
              const SizedBox(height: 16.0),
              SuggestionChip.elevated(
                label: const Text('Suggestion chip'),
                isSelected: true,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(width: 48.0),
          Column(
            children: [
              SuggestionChip(
                label: const Text('Suggestion chip'),
                enabled: false,
                onPressed: () {},
              ),
              const SizedBox(height: 16.0),
              SuggestionChip.elevated(
                label: const Text('Suggestion chip'),
                enabled: false,
                onPressed: () {},
              ),
              const SizedBox(height: 36.0),
              SuggestionChip(
                label: const Text('Suggestion chip'),
                isSelected: true,
                enabled: false,
                onPressed: () {},
              ),
              const SizedBox(height: 16.0),
              SuggestionChip.elevated(
                label: const Text('Suggestion chip'),
                isSelected: true,
                enabled: false,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

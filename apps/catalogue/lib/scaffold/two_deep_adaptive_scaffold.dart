import 'package:alternative_material_3/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

class TwoDeepAdaptiveScaffold extends StatelessWidget {
  const TwoDeepAdaptiveScaffold({
    super.key,
    this.appBar,
    this.smallBody,
    this.body,
    this.largeBody,
    required this.destinations,
    this.actions,
  });

  /// Option to override the default [AppBar] when using drawer in desktop
  /// small.
  final PreferredSizeWidget? appBar;

  /// Widget to be displayed in the body slot at the smallest breakpoint.
  ///
  /// If nothing is entered for this property, then the default [body] is
  /// displayed in the slot. If null is entered for this slot, the slot stays
  /// empty.
  final WidgetBuilder? smallBody;

  /// Widget to be displayed in the body slot at the middle breakpoint.
  ///
  /// The default displayed body.
  final WidgetBuilder? body;

  /// Widget to be displayed in the body slot at the largest breakpoint.
  ///
  /// If nothing is entered for this property, then the default [body] is
  /// displayed in the slot. If null is entered for this slot, the slot stays
  /// empty.
  final WidgetBuilder? largeBody;

  final List<NestableNavigationDestination> destinations;

  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context),
        drawer: _drawer(context),
        body: AdaptiveLayout(
          primaryNavigation: SlotLayout(config: {
            Breakpoints.large: SlotLayout.from(
              key: const Key('primaryNavigation.large'),
              builder: (context) => _navRail(context),
            ),
          }),
          body: SlotLayout(config: {
            Breakpoints.small: SlotLayout.from(
              key: const Key('body.small'),
              builder: smallBody,
            ),
            Breakpoints.medium: SlotLayout.from(
              key: const Key('body.medium'),
              builder: body,
            ),
            Breakpoints.large: SlotLayout.from(
              key: const Key('body.large'),
              builder: largeBody,
            ),
          }),
        ));
  }

  bool _useNavBar(BuildContext context) {
    return Breakpoints.large.isActive(context);
  }

  PreferredSizeWidget? _appBar(BuildContext context) {
    return _useNavBar(context) ? null : appBar ?? AppBar();
  }

  Widget? _drawer(BuildContext context) {
    return _useNavBar(context)
        ? null
        : const Drawer(
            child: Placeholder(),
          );
  }

  Widget _navRail(BuildContext context) {
    return SizedBox(
      width: 96.0,
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: NavigationRail(
            elevation: 1,
            // backgroundColor: Theme.of(context).colorScheme,
            destinations: destinations
                .map(
                  (d) => NavigationRailDestination(
                    icon: d.icon!,
                    selectedIcon: d.selectedIcon,
                    label: Text(d.label),
                  ),
                )
                .toList(),
            selectedIndex: 0,
            labelType: NavigationRailLabelType.all,
          ),
        ),
      ),
    );
  }
}

class NestableNavigationDestination {
  const NestableNavigationDestination({
    required this.route,
    required this.label,
    this.icon,
    this.selectedIcon,
    List<NestableNavigationDestination>? children,
  }) : children = children ?? const [];

  final String route;
  final String label;
  final Widget? icon;
  final Widget? selectedIcon;
  final List<NestableNavigationDestination> children;
}

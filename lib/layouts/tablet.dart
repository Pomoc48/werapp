import 'package:flutter/material.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/widgets/drawer.dart';

class TabletView extends StatelessWidget {
  const TabletView({
    Key? key,
    required this.children,
    this.drawer,
    this.welcome,
  }) : super(key: key);

  final List<Widget> children;
  final bool? drawer;
  final Widget? welcome;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    if (welcome is Widget) {
      SizedBox marginT = const SizedBox(height: 48);
      widgets.addAll([marginT, welcome!, marginT]);
      widgets.add(SizedBox(height: Settings.pagePadding));
    }

    for (int a = 0; a < children.length; a++) {
      widgets.add(children[a]);
      if (a != children.length - 1) {
        widgets.add(SizedBox(height: Settings.pagePadding));
      }
    }

    if (Scaffold.of(context).hasFloatingActionButton) {
      widgets.add(const SizedBox(height: 72));
    }

    Widget finalWidgets = Padding(
      padding: EdgeInsets.all(Settings.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );

    if (drawer is bool && drawer!) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 260, child: PDrawer()),
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: finalWidgets,
            ),
          ),
        ],
      );
    }

    return finalWidgets;
  }
}

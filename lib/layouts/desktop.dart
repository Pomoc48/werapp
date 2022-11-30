import 'package:flutter/material.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/widgets/drawer.dart';

class DesktopView extends StatelessWidget {
  const DesktopView({
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
    SizedBox columnWidth(List<Widget> widgetList) {
      return SizedBox(
        width: 300,
        child: Column(children: widgetList),
      );
    }

    List<Widget> widgets = [];

    if (welcome is Widget) {
      SizedBox marginT = const SizedBox(height: 48);
      widgets.addAll([marginT, welcome!, marginT]);
      widgets.add(SizedBox(height: Settings.pagePadding * 1.2));
    }

    List<Widget> wL = [];
    List<Widget> wR = [];

    for (int a = 0; a < children.length; a++) {
      if (a % 2 == 0) {
        wL.add(children[a]);
        if (a != children.length - 1) {
          wL.add(SizedBox(height: Settings.pagePadding * 1.2));
        }
      } else {
        wR.add(children[a]);
        if (a != children.length - 1) {
          wR.add(SizedBox(height: Settings.pagePadding * 1.2));
        }
      }
    }

    if (wL.last is SizedBox) wL.removeLast();

    widgets.add(
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: columnWidth(wL)),
          SizedBox(width: Settings.pagePadding * 1.2),
          Expanded(child: columnWidth(wR)),
        ],
      ),
    );

    if (Scaffold.of(context).hasFloatingActionButton) {
      widgets.add(const SizedBox(height: 72));
    }

    Widget finalWidgets = Padding(
      padding: EdgeInsets.all(Settings.pagePadding * 1.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );

    if (drawer is bool && drawer!) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 320, child: PDrawer()),
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

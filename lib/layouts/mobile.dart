import 'package:flutter/material.dart';
import 'package:wera_f2/settings.dart';

class MobileView extends StatelessWidget {
  const MobileView({
    Key? key,
    required this.children,
    this.welcome,
    this.noScroll,
  }) : super(key: key);

  final List<Widget> children;
  final Widget? welcome;
  final bool? noScroll;

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
        widgets.add(SizedBox(height: Settings.pagePadding / 2));
      }
    }

    if (Scaffold.of(context).hasFloatingActionButton) {
      widgets.add(const SizedBox(height: 72));
    }

    if (noScroll is bool && noScroll!) {
      return Padding(
        padding: EdgeInsets.all(Settings.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets,
        ),
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(Settings.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wera_f2/settings.dart';

class WidgetFromList extends StatelessWidget {
  const WidgetFromList({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    for (int a = 0; a < children.length; a++) {
      widgets.add(children[a]);
      if (a != children.length - 1) {
        widgets.add(SizedBox(height: Settings.pagePadding / 2));
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}
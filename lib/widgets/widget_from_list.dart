import 'package:flutter/material.dart';
import 'package:wera_f2/settings.dart';

class WidgetFromList extends StatelessWidget {
  const WidgetFromList({
    super.key,
    required this.children,
    required this.contextWidth,
    this.forceSingle = false,
  });

  final List<Widget> children;
  final double contextWidth;
  final bool forceSingle;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    SizedBox columnWidth(List<Widget> widgetList) {
      return SizedBox(
        width: 300,
        child: Column(children: widgetList),
      );
    }

    if (contextWidth > 999 && !forceSingle) {
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
            SizedBox(width: Settings.pagePadding),
            Expanded(child: columnWidth(wR)),
          ],
        ),
      );
    }

    else {
      for (int a = 0; a < children.length; a++) {
        widgets.add(children[a]);
        if (a != children.length - 1) {
          widgets.add(SizedBox(height: Settings.pagePadding / 2));
        }
      }
    }

    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: widgets,
    );
  }
}
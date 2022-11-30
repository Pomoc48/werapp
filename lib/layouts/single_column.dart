import 'package:flutter/material.dart';
import 'package:wera_f2/layouts/mobile.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/widgets/drawer.dart';

class SingleColumn extends StatelessWidget {
  const SingleColumn({
    Key? key,
    required this.constraints,
    required this.children,
    this.welcome,
    this.drawer,
  }) : super(key: key);

  final BoxConstraints constraints;
  final List<Widget> children;
  final Widget? welcome;
  final bool? drawer;

  @override
  Widget build(BuildContext context) {
    if (constraints.maxWidth < 600) {
      return MobileView(
        welcome: welcome,
        noScroll: true,
        children: children,
      );
    }

    double padding = (welcome is String) ? 0 : Settings.pagePadding * 4;
    double drawerWidth = (constraints.maxWidth < 1000) ? 260 : 320;

    if (drawer is bool && drawer!) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: drawerWidth, child: const PDrawer()),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(child: SizedBox()),
                  Padding(
                    padding: EdgeInsets.only(top: padding),
                    child: SizedBox(
                      width: 600,
                      child: MobileView(
                        welcome: welcome,
                        noScroll: true,
                        children: children,
                      ),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
          ],
        );
      }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(child: SizedBox()),
        Padding(
          padding: EdgeInsets.only(top: padding),
          child: SizedBox(
            width: 600,
            child: MobileView(
              welcome: welcome,
              noScroll: true,
              children: children,
            ),
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}

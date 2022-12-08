import 'package:flutter/material.dart';
import 'package:wera_f2/layouts/mobile2.dart';
import 'package:wera_f2/layouts/tablet2.dart';
import 'package:wera_f2/widgets/drawer.dart';

class PLayout extends StatelessWidget {
  const PLayout({
    Key? key,
    required this.title,
    required this.child,
    this.welcome,
    this.fab,
    this.drawer = false,
    this.backArrow = true,
    this.scrollable = false,
    this.onRefresh,
    
  }) : super(key: key);

  final String title;
  final Widget child;
  final Widget? welcome;
  final Widget? fab;
  final bool drawer;
  final bool backArrow;
  final bool scrollable;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints c) {
        AppBar appbar = AppBar(
          title: Text(title),
          automaticallyImplyLeading: backArrow,
        );

        if (c.maxWidth < 600) {
          return Scaffold(
            appBar: appbar,
            floatingActionButton: fab,
            drawer: drawer ? const PDrawer() : null,
            body: MobileView2(
              welcome: welcome,
              scrollable: scrollable,
              onRefresh: onRefresh,
              child: child,
            ),
          );
        }

        return Scaffold(
          appBar: appbar,
          body: TabletView2(
            welcome: welcome,
            drawer: drawer,
            fab: fab,
            scrollable: scrollable,
            onRefresh: onRefresh,
            child: child,
          )
        );
      }
    );
  }
}

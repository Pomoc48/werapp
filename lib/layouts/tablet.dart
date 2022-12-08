import 'package:flutter/material.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/widgets/drawer.dart';

class TabletView extends StatelessWidget {
  const TabletView({
    Key? key,
    required this.child,
    this.drawer = false,
    this.welcome,
    this.fab,
    this.scrollable = false,
    this.onRefresh,
  }) : super(key: key);

  final Widget child;
  final bool drawer;
  final Widget? welcome;
  final Widget? fab;
  final bool scrollable;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    if (welcome is Widget) {
      SizedBox marginT = const SizedBox(height: 48);
      widgets.addAll([marginT, welcome!, marginT]);
      widgets.add(SizedBox(height: Settings.pagePadding));
    }

    widgets.add(child);

    Widget finalWidgets = _getScroll(
      Padding(
        padding: EdgeInsets.all(Settings.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: widgets,
        ),
      ),
    );

    if (drawer) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 260, child: PDrawer(fab: fab)),
          Expanded(child: finalWidgets),
        ],
      );
    }

    return finalWidgets;
  }

  Widget _getScroll(Widget widget) {
    if (scrollable) {
      if (onRefresh != null) {
        return RefreshIndicator(
          onRefresh: onRefresh!,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: widget,
          ),
        );
      }

      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: widget,
      );
    }

    return widget;
  }
}

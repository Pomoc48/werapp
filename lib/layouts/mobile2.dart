import 'package:flutter/material.dart';
import 'package:wera_f2/settings.dart';

class MobileView2 extends StatelessWidget {
  const MobileView2({
    Key? key,
    required this.child,
    this.welcome,
    this.scrollable = false,
    this.onRefresh,
  }) : super(key: key);

  final Widget child;
  final Widget? welcome;
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

    if (Scaffold.of(context).hasFloatingActionButton) {
      widgets.add(const SizedBox(height: 72));
    }

    return _getScroll(
      Padding(
        padding: EdgeInsets.all(Settings.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets,
        ),
      ),
    );
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

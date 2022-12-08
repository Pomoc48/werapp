import 'package:flutter/material.dart';
import 'package:wera_f2/settings.dart';
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
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints c) {
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

      if (c.maxWidth < 1000) {
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

      // return DesktopView(
      //   drawer: drawer,
      //   welcome: welcome,
      //   children: children,
      // );

      // TODO for now
      return Scaffold(
        appBar: appbar,
        body: TabletView2(
          welcome: welcome,
          drawer: drawer,
          fab: fab,
          child: child,
        )
      );

      
    });
  }
}


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

class TabletView2 extends StatelessWidget {
  const TabletView2({
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


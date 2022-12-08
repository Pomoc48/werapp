import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wera_f2/layouts/mobile2.dart';
import 'package:wera_f2/layouts/tablet2.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
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
    this.logoutConfirm = false,
    this.onRefresh,
    this.appbarActions,
    
  }) : super(key: key);

  final String title;
  final Widget child;
  final Widget? welcome;
  final Widget? fab;
  final bool drawer;
  final bool backArrow;
  final bool scrollable;
  final bool logoutConfirm;
  final Future<void> Function()? onRefresh;
  final List<Widget>? appbarActions;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints c) {
        AppBar appbar = AppBar(
          title: Text(title),
          automaticallyImplyLeading: backArrow,
          actions: appbarActions,
        );

        if (c.maxWidth < 600) {
          return _checkLogout(
            Scaffold(
              appBar: appbar,
              floatingActionButton: fab,
              drawer: drawer ? const PDrawer() : null,
              body: MobileView2(
                welcome: welcome,
                scrollable: scrollable,
                onRefresh: onRefresh,
                child: child,
              ),
            ),
          );
        }

        if (!drawer) {
          return _checkLogout(
            Scaffold(
              appBar: appbar,
              body: Center(
                child: SizedBox(
                  width: 600,
                  child: TabletView2(
                    welcome: welcome,
                    fab: fab,
                    scrollable: scrollable,
                    onRefresh: onRefresh,
                    child: child,
                  ),
                ),
              ),
            )
          );
        }

        return _checkLogout(
          Scaffold(
            appBar: appbar,
            body: TabletView2(
              welcome: welcome,
              drawer: drawer,
              fab: fab,
              scrollable: scrollable,
              onRefresh: onRefresh,
              child: child,
            )
          ),
        );
      }
    );
  }

  Widget _checkLogout(Widget w) {
    if (logoutConfirm) {
      return WillPopScope(
        onWillPop: () async {
          await showDialog(
            context: Get.context!,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(PStrings.logout),
                content: Text(PStrings.logoutConfirm),
                actions: [
                  TextButton(
                    child: Text(PStrings.no),
                    onPressed: () => Get.back(),
                  ),
                  TextButton(
                    child: Text(PStrings.yes),
                    onPressed:() => Get.offAllNamed(Routes.login),
                  ),
                ],
              );
            },
          );
          return false;
        },
        child: w,
      );
    }

    return w;
  }
}

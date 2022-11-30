import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wera_f2/classes/user.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/layouts/desktop.dart';
import 'package:wera_f2/layouts/mobile.dart';
import 'package:wera_f2/layouts/tablet.dart';

String formatDouble(double n, int format) {
  return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : format);
}

String formatDate(DateTime date, {bool short = false}) {
  if (short) return DateFormat('d MMM yyyy').format(date);
  return DateFormat('d MMMM yyyy, HH:mm').format(date);
}

double parseDouble(value) {
  try {
    return value;
  } catch (e) {
    return double.parse('$value.0');
  }
}

void snackBar(BuildContext context, String text, [SnackBarAction? action]) {
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(text),
    action: action,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

User findUser({required int id, required List<User> userList}) {
  return userList.singleWhere((element) => element.id == id);
}

bool isMobile(BoxConstraints constraints) {
  if (constraints.maxWidth < 600) return true;
  return false;
}

Widget? drawDrawer(BoxConstraints constraints, Widget child) {
  if (isMobile(constraints)) return child;
  return null;
}

Widget getLayout({
  required BoxConstraints constraints,
  required List<Widget> children,
  Widget? welcome,
  bool? drawer,
}) {
  if (constraints.maxWidth < 600) {
    return MobileView(
      welcome: welcome,
      children: children,
    );
  }

  if (constraints.maxWidth < 1000) {
    return TabletView(
      drawer: drawer,
      welcome: welcome,
      children: children,
    );
  }

  return DesktopView(
    drawer: drawer,
    welcome: welcome,
    children: children,
  );
}

Future<bool> logoutConfirm(BuildContext context) async {
  await showDialog(
    context: context,
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
}

void loading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Center(
        child: SizedBox(
          width: 48,
          height: 48,
          child: CircularProgressIndicator(),
        ),
      );
    },
  );
}

void loaded(BuildContext context) {
  Navigator.of(context).pop();
}

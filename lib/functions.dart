import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:wera_f2/models/user.dart';

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

void snackBar(BuildContext context, String text) {
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: context.width > 600 ? EdgeInsets.fromLTRB(20, 0, context.width - 600, 20) : null,
    content: Text(text),
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

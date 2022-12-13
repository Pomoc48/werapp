import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/pages/charts/view.dart';
import 'package:wera_f2/pages/command_logs.dart';
import 'package:wera_f2/pages/create_user.dart';
import 'package:wera_f2/pages/events/add/view.dart';
import 'package:wera_f2/pages/events/view/view.dart';
import 'package:wera_f2/pages/events/list/view.dart';
import 'package:wera_f2/pages/expense_add.dart';
import 'package:wera_f2/pages/expenses.dart';
import 'package:wera_f2/pages/home/view.dart';
import 'package:wera_f2/pages/login/view.dart';
import 'package:wera_f2/pages/new_command.dart';
import 'package:wera_f2/pages/new_price_list.dart';
import 'package:wera_f2/pages/price_list.dart';
import 'package:wera_f2/pages/setup/view.dart';
import 'package:wera_f2/pages/settigns/view.dart';
import 'package:wera_f2/pages/stats/view.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';

void main() async {
  Get.put(GlobalController());
  await GetStorage.init();
  
  String? themeColor = GetStorage().read("themeColor");

  ThemeData themeDark = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.blue,
    brightness: Brightness.dark,
  );

  ThemeData themeLight = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.blue,
    brightness: Brightness.light,
  );

  if (themeColor != null) {
    Color color = Color(int.parse(themeColor));

    themeDark = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: color,
      brightness: Brightness.dark,
    );

    themeLight = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: color,
      brightness: Brightness.light,
    );
  }
  
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      enableLog: false,
      title: PStrings.appName,
      theme: themeLight,
      darkTheme: themeDark,
      scrollBehavior: const ScrollBehavior().copyWith(
        physics: const BouncingScrollPhysics(),
      ),
      routes: {
        Routes.login: (context) => LoginPage(),
        Routes.home: (context) => HomePage(),
        Routes.newCommand: (context) => NewCommandPage(),
        Routes.commandsLog: (context) => CommandLogPage(),
        Routes.stats: (context) => StatsPage(),
        Routes.detailEvent: (context) => DetailedEventPage(),
        Routes.events: (context) => EventsPage(),
        Routes.newEvent: (context) => AddEventPage(),
        Routes.expenses: (context) => ExpensesPage(),
        Routes.newExpense: (context) => AddExpensePage(),
        Routes.charts: (context) => ChartsPage(),
        Routes.priceList: (context) => PriceListPage(),
        Routes.newPriceList: (context) => NewPriceListPage(),
        Routes.newUser: (context) => AddUser(),
        Routes.setup: (context) => Setup(),
        Routes.settings: (context) => SettingsPage(),
      },
    ),
  );
}

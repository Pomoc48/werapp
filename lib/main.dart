import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/pages/charts.dart';
import 'package:wera_f2/pages/command_logs.dart';
import 'package:wera_f2/pages/create_user.dart';
import 'package:wera_f2/pages/event_add.dart';
import 'package:wera_f2/pages/event_detail.dart';
import 'package:wera_f2/pages/events.dart';
import 'package:wera_f2/pages/expense_add.dart';
import 'package:wera_f2/pages/expenses.dart';
import 'package:wera_f2/pages/home.dart';
import 'package:wera_f2/pages/login.dart';
import 'package:wera_f2/pages/new_command.dart';
import 'package:wera_f2/pages/new_price_list.dart';
import 'package:wera_f2/pages/price_list.dart';
import 'package:wera_f2/pages/setup.dart';
import 'package:wera_f2/pages/settings.dart';
import 'package:wera_f2/pages/stats.dart';
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
      defaultTransition: Transition.circularReveal,
      enableLog: false,
      themeMode: ThemeMode.dark,
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

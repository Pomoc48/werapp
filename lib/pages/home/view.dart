import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wera_f2/models/home_data.dart';
import 'package:wera_f2/models/user.dart';
import 'package:wera_f2/firebase_init.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/layouts/layout.dart';
import 'package:wera_f2/pages/home/controller.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/cards/event.dart';
import 'package:wera_f2/cards/expense.dart';
import 'package:wera_f2/cards/command_log.dart';
import 'package:wera_f2/widgets/current_points.dart';
import 'package:wera_f2/widgets/money_ratio.dart';
import 'package:wera_f2/widgets/title.dart';
import 'package:wera_f2/widgets/title_widget.dart';
import 'package:wera_f2/widgets/widget_from_list.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeController local = HomeController();

  @override
  Widget build(BuildContext context) {
    local.pageSetup(() {
      local.updateHome();
      firebaseInit();
    });

    FloatingActionButton fab = FloatingActionButton.extended(
      heroTag: "main",
      onPressed: () async {
        local.controller.fadeOut();
        await Navigator.pushNamed(context, Routes.newCommand);
        local.updateHome();
      },
      label: Text(PStrings.newCommandFAB),
      icon: const Icon(Icons.grade),
    );

    return PLayout(
      title: PStrings.appName,
      drawer: true,
      fab: fab,
      logoutConfirm: true,
      scrollable: true,
      fadeController: local.controller,
      onRefresh: () async => local.updateHome(),
      welcome: Obx(() => _getTitle(local.data, local.userId!)),
      child: WidgetFromList(
        contextWidth: context.width,
        children: [
          TitleWidget(
            text: PStrings.currentPoints,
            child: const CurrentPoints(),
          ),
          TitleWidget(
            text: PStrings.moneyIndicator,
            child: const MoneyRatio(),
          ),
          TitleWidget(
            text: PStrings.upcomingEvent,
            child: Obx(() => EventCard(
              event: local.data?.event,
              controller: local.controller,
              refresh: () => local.updateHome(),
            )),
          ),
          TitleWidget(
            text: PStrings.recentExpense,
            child: Obx(() => ExpenseCard(
              expense: local.data?.expense,
              controller: local.controller,
              refresh: () => local.updateHome(),
            )),
          ),
          TitleWidget(
            text: PStrings.recentCommandLog,
            child: Obx(() => CommandLogCard(
              cmdLog: local.data?.commandLog,
              controller: local.controller,
              refresh: () => local.updateHome(),
            )),
          ),
        ],
      ),
    );
  }

  Widget _getTitle(HomeData? data, int userId) {
    if (data != null) {
      User currentUser = findUser(id: userId, userList: data.users);
      return PTitle(message: "${PStrings.welcome} ${currentUser.name}!");
    }
    return const SizedBox();
  }
}

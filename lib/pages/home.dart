import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:get/get.dart';
import 'package:wera_f2/classes/home_data.dart';
import 'package:wera_f2/classes/user.dart';
import 'package:wera_f2/firebase_init.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/layouts/layout.dart';
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

class LocalController extends GetxController{
  bool _initial = true;
  final FadeInController controller = FadeInController();

  runOnce(Function() fun) {
    if (_initial) {
      fun();
      _initial = false;
    }
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final GlobalController global = Get.find();
  final LocalController local = LocalController();

  @override
  Widget build(BuildContext context) {
    local.runOnce(() {
      global.updateHomeData(local.controller);
      firebaseInit();
    });

    FloatingActionButton fab = FloatingActionButton.extended(
      heroTag: "main",
      onPressed: () async {
        local.controller.fadeOut();
        await Navigator.pushNamed(context, Routes.newCommand);
        global.updateHomeData(local.controller);
      },
      label: Text(PStrings.newCommandFAB),
      icon: const Icon(Icons.grade),
    );

    void Function([FadeInController?]) refresh = global.updateHomeData;

    return PLayout(
      title: PStrings.appName,
      drawer: true,
      fab: fab,
      logoutConfirm: true,
      scrollable: true,
      fadeController: local.controller,
      onRefresh: () async => refresh(local.controller),
      welcome: Obx(() => _getTitle(global.homeData, global.userId!)),
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
              event: global.homeData?.event,
              controller: local.controller,
              refresh: () => refresh(local.controller),
            )),
          ),
          TitleWidget(
            text: PStrings.recentExpense,
            child: Obx(() => ExpenseCard(
              expense: global.homeData?.expense,
              controller: local.controller,
              refresh: () => refresh(local.controller),
            )),
          ),
          TitleWidget(
            text: PStrings.recentCommandLog,
            child: Obx(() => CommandLogCard(
              cmdLog: global.homeData?.commandLog,
              controller: local.controller,
              refresh: () => refresh(local.controller),
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

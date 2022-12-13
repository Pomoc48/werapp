import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:get/get.dart';
import 'package:wera_f2/classes/command.dart';
import 'package:wera_f2/classes/user.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/layouts/layout.dart';
import 'package:wera_f2/server_query.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/widgets/create_card.dart';
import 'package:wera_f2/widgets/widget_from_list.dart';

class LocalController extends GetxController{
  bool _initial = true;
  final FadeInController fadeController = FadeInController();

  runOnce(Function() fun) {
    if (_initial) {
      fun();
      _initial = false;
    }
  }
}

class PriceListPage extends StatelessWidget {
  PriceListPage({super.key});

  final GlobalController global = Get.find();
  final LocalController local = LocalController();

  @override
  Widget build(BuildContext context) {
    local.runOnce(() => _getCommands());

    FloatingActionButton fab = FloatingActionButton.extended(
      heroTag: "main",
      onPressed: () async => _view(null),
      icon: const Icon(Icons.category),
      label: Text(PStrings.newCategoryFAB),
    );

    return PLayout(
      title: PStrings.priceList,
      drawer: true,
      logoutConfirm: true,
      scrollable: true,
      fadeController: local.fadeController,
      onRefresh: () async => _getCommands(),
      fab: fab,
      child: Obx(() => WidgetFromList(
        contextWidth: context.width,
        children: _main(global.commands),
      )),
    );
  }

  List<Widget> _main(List<Command>? data) {
    if (data == null) return [];

    List<Widget> widgets = [];
    for (Command command in data) {
      User user = findUser(
        id: command.userId,
        userList: global.homeData!.users,
      );

      widgets.add(
        InkWell(
          splashColor: PColors().inkWell(Get.context!),
          borderRadius: Settings.cardRadius,
          onTap: () async => _view(command),
            child: CreateCard(
              main: [command.name, command.cost.toString()],
              cont: [user.name, formatDate(command.updated)]
            ),
          ),
      );
    }

    return widgets;
  }

  void _view(Command? command) async {
    local.fadeController.fadeOut();
    await Get.toNamed(Routes.newPriceList, arguments: {"command": command});
    _getCommands();
  }

  Future<void> _getCommands() async {
    local.fadeController.fadeOut();
    global.updateCommands();
    local.fadeController.fadeIn();
  }
}

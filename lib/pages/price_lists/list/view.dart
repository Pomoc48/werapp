import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wera_f2/classes/command.dart';
import 'package:wera_f2/classes/user.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/layouts/layout.dart';
import 'package:wera_f2/pages/price_lists/list/controller.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/widgets/create_card.dart';
import 'package:wera_f2/widgets/widget_from_list.dart';

class PriceListPage extends StatelessWidget {
  PriceListPage({super.key});
  
  final PriceListController local = PriceListController();

  @override
  Widget build(BuildContext context) {
    local.runOnce();

    FloatingActionButton fab = FloatingActionButton.extended(
      heroTag: "main",
      onPressed: () async => local.view(null),
      icon: const Icon(Icons.category),
      label: Text(PStrings.newCategoryFAB),
    );

    return PLayout(
      title: PStrings.priceList,
      drawer: true,
      logoutConfirm: true,
      scrollable: true,
      fadeController: local.fadeController,
      onRefresh: () async => local.getCommands(),
      fab: fab,
      child: Obx(() => WidgetFromList(
        contextWidth: context.width,
        children: _main(local.global.commands),
      )),
    );
  }

  List<Widget> _main(List<Command>? data) {
    if (data == null) return [];

    List<Widget> widgets = [];
    for (Command command in data) {
      User user = findUser(
        id: command.userId,
        userList: local.global.homeData!.users,
      );

      widgets.add(
        InkWell(
          splashColor: PColors().inkWell(Get.context!),
          borderRadius: Settings.cardRadius,
          onTap: () async => local.view(command),
            child: CreateCard(
              main: [command.name, command.cost.toString()],
              cont: [user.name, formatDate(command.updated)]
            ),
          ),
      );
    }

    return widgets;
  }
}

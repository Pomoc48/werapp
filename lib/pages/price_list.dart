import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:get/get.dart';
import 'package:wera_f2/classes/command.dart';
import 'package:wera_f2/classes/user.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/server_query.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/widgets/create_card.dart';
import 'package:wera_f2/widgets/drawer.dart';

void main() => runApp(PriceListPage());

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

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints c) {
        return WillPopScope(
          onWillPop: () async => await logoutConfirm(context),
          child: Scaffold(
            appBar: AppBar(title: Text(PStrings.priceList)),
            drawer: drawDrawer(c, const PDrawer()),
            floatingActionButton: FloatingActionButton.extended(
              heroTag: "main",
              onPressed: () async => _view(null),
              icon: const Icon(Icons.category),
              label: Text(PStrings.newCategoryFAB),
            ),
            body: RefreshIndicator(
              onRefresh: () async => _getCommands(),
              child: FadeIn(
                controller: local.fadeController,
                child: Obx(() => _mainSection(c, global.commands)),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _mainSection(BoxConstraints constraints, List<Command>? data) {
    if (data == null) return const SizedBox();

    List<Widget> widgets = [];
    for (Command command in data) {
      User user = findUser(
        id: command.userId,
        userList: global.homeData!.users,
      );

      widgets.add(
        InkWell(
          splashColor: PColors().inkWell(Get.context!),
          borderRadius: PRadius.card,
          onTap: () async => _view(command),
            child: CreateCard(
              main: [command.name, command.cost.toString()],
              cont: [user.name, formatDate(command.updated)]
            ),
          ),
      );
    }

    return getLayout(
      constraints: constraints,
      drawer: !isMobile(constraints),
      children: widgets,
    );
  }

  void _view(Command? command) async {
    local.fadeController.fadeOut();
    await Get.toNamed(Routes.newPriceList, arguments: {"command": command});
    _getCommands();
  }

  Future<void> _getCommands() async {
    local.fadeController.fadeOut();
    Map map = await query(link: "command", type: RequestType.get);

    if (map["success"]) {
      global.updateCommands(commandListFromList(map["data"]));
    } else {
      snackBar(Get.context!, map["message"]);
    }

    local.fadeController.fadeIn();
  }
}

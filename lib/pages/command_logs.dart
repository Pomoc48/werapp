import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:get/get.dart';
import 'package:wera_f2/classes/command_log.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/server_query.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/cards/command_log.dart';
import 'package:wera_f2/widgets/drawer.dart';

void main() => runApp(CommandLogPage());

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

class CommandLogPage extends StatelessWidget {
  CommandLogPage({super.key});

  final GlobalController global = Get.find();
  final LocalController local = LocalController();

  @override
  Widget build(BuildContext context) {
    local.runOnce(() => _getCommandLogs());

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints c) {
        return WillPopScope(
          onWillPop: () async => await logoutConfirm(context),
          child: Scaffold(
            appBar: AppBar(
              title: Text(PStrings.commandsLog),
              automaticallyImplyLeading: isMobile(c),
            ),
            drawer: drawDrawer(c, const PDrawer()),
            floatingActionButton: FloatingActionButton.extended(
              heroTag: "main",
              onPressed: () async {
                local.controller.fadeOut();
                await Navigator.pushNamed(context, Routes.newCommand);
                _getCommandLogs();
              },
              label: Text(PStrings.newCommandFAB),
              icon: const Icon(Icons.grade),
            ),
            body: RefreshIndicator(
              onRefresh: () async => _getCommandLogs(),
              child: FadeIn(
                controller: local.controller,
                child: Obx(() => _mainColumn(c, global.commandsLog)),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _mainColumn(BoxConstraints constraints, List<CommandLog>? data) {
    if (data == null) return const SizedBox();

    List<Widget> widgets = [];
    for (CommandLog commandLog in data) {
      widgets.add(CommandLogCard(
        cmdLog: commandLog,
        refresh: _getCommandLogs,
        controller: local.controller,
      ));
    }

    return getLayout(
      constraints: constraints,
      drawer: !isMobile(constraints),
      children: widgets,
    );
  }

  Future<void> _getCommandLogs() async {
    local.controller.fadeOut();
    Map map = await query(link: "command-log", type: RequestType.get);

    if (map["success"]) {
      global.updateCmdLog(commandLogListFromList(map["data"]));
    } else {
      snackBar(Get.context!, map["message"]);
    }

    local.controller.fadeIn();
  }
}

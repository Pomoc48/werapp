import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wera_f2/classes/command_log.dart';
import 'package:wera_f2/layouts/layout.dart';
import 'package:wera_f2/pages/command_logs/list/controller.dart';
import 'package:wera_f2/widgets/widget_from_list.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/cards/command_log.dart';

class CommandLogPage extends StatelessWidget {
  CommandLogPage({super.key});

  final CommandLogController local = CommandLogController();

  @override
  Widget build(BuildContext context) {
    local.runOnce();

    FloatingActionButton fab = FloatingActionButton.extended(
      heroTag: "main",
      onPressed: () async => local.newCommand(),
      label: Text(PStrings.newCommandFAB),
      icon: const Icon(Icons.grade),
    );

    return PLayout(
      title: PStrings.commandsLog,
      drawer: true,
      fab: fab,
      scrollable: true,
      logoutConfirm: true,
      fadeController: local.controller,
      onRefresh: () async => local.getCommandLogs(),
      child: Obx(() => WidgetFromList(
        contextWidth: context.width,
        children: _main(local.global.commandsLog),
      )),
    );
  }

  List<Widget> _main(List<CommandLog>? data) {
    if (data == null) return [];

    List<Widget> widgets = [];
    for (CommandLog commandLog in data) {
      widgets.add(
        CommandLogCard(
          cmdLog: commandLog,
          refresh: local.getCommandLogs,
          controller: local.controller,
        ),
      );
    }

    return widgets;
  }
}

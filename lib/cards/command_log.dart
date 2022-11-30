import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:get/get.dart';
import 'package:wera_f2/classes/command_log.dart';
import 'package:wera_f2/classes/user.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/widgets/create_card.dart';
import 'package:wera_f2/widgets/profile_avatar.dart';

class CommandLogCard extends StatelessWidget {
  const CommandLogCard({
    Key? key,
    required this.cmdLog,
    required this.refresh,
    required this.controller,
  }) : super(key: key);

  final CommandLog? cmdLog;
  final void Function() refresh;
  final FadeInController controller;

  @override
  Widget build(BuildContext context) {
    final GlobalController global = Get.find();

    if (cmdLog != null) {
      List<Widget> widgets = [
        ProfileAvatar(
          userId: cmdLog!.userId,
          timestamp: cmdLog!.timestamp,
        ),
      ];

      if (global.userId! == cmdLog!.userId) {
        if (cmdLog!.reported) {
          widgets.add(OutlinedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.report_gmailerrorred),
            label: Text(PStrings.complained),
          ));
        } else {
          widgets.add(OutlinedButton.icon(
            onPressed: () async {
              showDialog(
                context: Get.context!,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(PStrings.dialogAlert),
                    content: Text(PStrings.complainConfirm),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text(PStrings.no),
                      ),
                      TextButton(
                        onPressed: () async {
                          controller.fadeOut();
                          Map map = await cmdLog!.report();

                          Get.back();
                          snackBar(Get.context!, map["message"]);
                          refresh();
                        },
                        child: Text(PStrings.yes),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.report_gmailerrorred),
            label: Text(PStrings.complaint),
          ));
        }
      }

      User user = findUser(
        id: cmdLog!.recipientId,
        userList: global.homeData!.users,
      );

      return CreateCard(
        main: widgets,
        cont: [
          "${cmdLog!.commandName} (${cmdLog!.cost}) for ${user.name}",
          cmdLog!.description,
        ],
      );
    }

    return InkWell(
      splashColor: PColors().inkWell(context),
      borderRadius: PRadius.card,
      onTap: () async {
        controller.fadeOut();
        await Navigator.pushNamed(context, Routes.newCommand);
        refresh();
      },
      child: CreateCard(
        main: [PStrings.noRecentCommandLog],
        cont: [PStrings.newCommand],
      ),
    );
  }
}

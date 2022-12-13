import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wera_f2/layouts/layout.dart';
import 'package:wera_f2/pages/events/view/controller.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/widgets/create_card.dart';
import 'package:wera_f2/widgets/title.dart';
import 'package:wera_f2/widgets/widget_from_list.dart';

class DetailedEventPage extends StatelessWidget {
  DetailedEventPage({super.key});

  final EventDetailController local = EventDetailController();

  @override
  Widget build(BuildContext context) {
    local.pageSetup();

    return PLayout(
      title: local.event!.description,
      welcome: Obx(() => PTitle(
        message: "${local.diff.value.inHours} ${PStrings.hoursLeft}",
      )),
      appbarActions: [
        IconButton(
          constraints: Settings.actionConstraint,
          icon: const Icon(Icons.delete),
          onPressed: () => {
            showDialog(
              context: Get.context!,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(PStrings.dialogAlert),
                  content: Text(PStrings.removeConfirm),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(PStrings.no),
                    ),
                    TextButton(
                      onPressed: () async => local.removeEvent(),
                      child: Text(PStrings.yes),
                    ),
                  ],
                );
              },
            ),
          },
        ),
      ],
      child: WidgetFromList(
        contextWidth: context.width,
        forceSingle: true,
        children: [
          Obx(() => _progressBar(
            title: PStrings.days,
            time: local.days.value,
            divider: 7,
          )),
          Obx(() => _progressBar(
            title: PStrings.hours,
            time: local.hours.value,
            divider: 24,
          )),
          Obx(() => _progressBar(
            title: PStrings.minutes,
            time: local.minutes.value,
            divider: 60,
          )),
          Obx(() => _progressBar(
            title: PStrings.seconds,
            time: local.seconds.value,
            divider: 60,
          )),
        ],
      ),
    );
  }

  Widget _progressBar({
    required String title,
    required int time,
    required int divider,
  }) {
    return CreateCard(
      main: [title, time.toString()],
      cont: LinearProgressIndicator(
        minHeight: 4,
        backgroundColor: PColors().surfaceVar(Get.context!),
        value: time / divider,
      ),
    );
  }
}

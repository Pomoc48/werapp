import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:get/get.dart';
import 'package:wera_f2/classes/event.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/layouts/single_column.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/widgets/create_card.dart';
import 'package:wera_f2/widgets/title.dart';

void main() => runApp(DetailedEventPage());

class LocalController extends GetxController{
  bool _initial = true;
  Event? event;

  final diff = Rx<Duration>(const Duration());

  final days = 0.obs;
  final hours = 0.obs;
  final minutes = 0.obs;
  final seconds = 0.obs;

  updateDiff(Duration duration) {
    diff.value = duration;

    Duration minDays = duration - Duration(days: duration.inDays);
    Duration minHours = minDays - Duration(hours: minDays.inHours);
    Duration minMins = minHours - Duration(minutes: minHours.inMinutes);

    days.value = duration.inDays;
    hours.value = minDays.inHours;
    minutes.value = minHours.inMinutes;
    seconds.value = minMins.inSeconds;
  }

  runOnce(Function() fun) {
    if (_initial) {
      fun();
      _initial = false;
    }
  }
}

class DetailedEventPage extends StatelessWidget {
  DetailedEventPage({super.key});

  final GlobalController global = Get.put(GlobalController());
  final LocalController local = LocalController();

  @override
  Widget build(BuildContext context) {
    local.runOnce(() {
      local.event = Get.arguments["event"];
      _calculateWait();
      _repeatCalculateWait();
    });

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            constraints: Settings.actionConstraint,
            icon: const Icon(Icons.delete),
            onPressed: () => _delete(),
          ),
        ],
        title: Text(local.event!.description),
      ),
      body: SingleChildScrollView(
        child: FadeIn(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleColumn(
                constraints: constraints,
                welcome: Obx(() => PTitle(
                  message: "${local.diff.value.inHours} ${PStrings.hoursLeft}",
                )),
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
              );
            },
          ),
        ),
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

  void _repeatCalculateWait() {
    Future.delayed(const Duration(seconds: 1), () {
      _calculateWait();
      _repeatCalculateWait();
    });
  }

  void _calculateWait() {
    DateTime now = DateTime.now();

    if (now.isAfter(local.event!.timestamp)) {
      local.diff.value = const Duration(seconds: 0);
      return;
    }

    local.updateDiff(local.event!.timestamp.difference(now));
  }

  void _delete() async {
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
              onPressed: () async {
                Map map = await local.event!.remove();
                snackBar(Get.context!, map["message"]);

                Get.back();
                Get.back();
              },
              child: Text(PStrings.yes),
            ),
          ],
        );
      },
    );
  }
}

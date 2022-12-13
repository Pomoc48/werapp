import 'package:get/get.dart';
import 'package:wera_f2/models/event.dart';
import 'package:wera_f2/functions.dart';

class EventDetailController extends GetxController{
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

  void removeEvent() async {
    Map map = await event!.remove();
    snackBar(Get.context!, map["message"]);

    Get.back();
    Get.back();
  }

  void repeatCalculateWait() {
    Future.delayed(const Duration(seconds: 1), () {
      calculateWait();
      repeatCalculateWait();
    });
  }

  void calculateWait() {
    DateTime now = DateTime.now();

    if (now.isAfter(event!.timestamp)) {
      diff.value = const Duration(seconds: 0);
      return;
    }

    updateDiff(event!.timestamp.difference(now));
  }

  void pageSetup() {
    if (_initial) {
      event = Get.arguments["event"];
      calculateWait();
      repeatCalculateWait();
      _initial = false;
    }
  }
}

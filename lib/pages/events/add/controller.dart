import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/server_query.dart';
import 'package:wera_f2/strings.dart';

class EventAddController extends GetxController{
  final TextEditingController controller = TextEditingController();
  final GlobalController global = Get.find();

  bool datePicked = false;
  DateTime dateTime = DateTime.now();

  final newText = formatDate(
    DateTime.now().add(const Duration(hours: 1)),
  ).obs;

  void updateDate(DateTime? newTime) {
    dateTime = newTime!;
    newText.value = formatDate(dateTime);
  }

  void inputTime() async {
    DateTime? date = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2120, 12, 31),
    );

    TimeOfDay? time;

    if (date is DateTime) {
      time = await showTimePicker(
        context: Get.context!,
        initialTime: const TimeOfDay(hour: 0, minute: 0),
      );
    }

    if (date is DateTime && time is TimeOfDay) {
      datePicked = true;
      updateDate(
        date.add(Duration(hours: time.hour, minutes: time.minute)),
      );
    }
  }

  void buttonPressed() async {
    if (!datePicked) {
      snackBar(Get.context!, PStrings.pickDate);
      return;
    }

    if (controller.text == "") {
      snackBar(Get.context!, PStrings.pickTitle);
      return;
    }

    loading(Get.context!);

    DateTime d = dateTime;
    String timestamp = "${d.year}-${d.month}-${d.day} ${d.hour}:${d.minute}";

    Map map = await query(
      link: "event",
      type: RequestType.post,
      params: {
        "user_id": global.userId!,
        "description": controller.text,
        "timestamp": timestamp,
      }
    );

    loaded(Get.context!);

    snackBar(Get.context!, map["message"]);
    if (map["success"]) Get.back();
  }
}

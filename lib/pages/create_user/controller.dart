import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/server_query.dart';
import 'package:wera_f2/strings.dart';

class NewUserController extends GetxController{
  final TextEditingController nameC = TextEditingController();
  final TextEditingController imageUrlC = TextEditingController();

  bool datePicked = false;
  bool pinPicked = false;
  DateTime dateTime = DateTime.now();

  String pinStringInt = "";

  final newDate = PStrings.clickSet.obs;
  final newPin = PStrings.clickSet.obs;

  void clearPin() => pinStringInt = "";
  void updatePin(number) => pinStringInt += number;

  void updateDate(DateTime? newTime) {
    dateTime = newTime!;
    newDate.value = formatDate(dateTime, short: true);
  }

  void pinInput(String number) {
    updatePin(number);
    if (pinStringInt.length != 4) return;

    pinPicked = true;
    newPin.value = PStrings.pinHint;

    Get.back();
  }

  void timeInput() async {
    DateTime now = DateTime.now();

    DateTime? date = await showDatePicker(
      context: Get.context!,
      initialDate: now,
      firstDate: DateTime(1920),
      lastDate: now,
    );

    if (date is DateTime) {
      datePicked = true;
      updateDate(date);
    }
  }

  void buttonPressed() async {
    if (nameC.text == "") {
      snackBar(Get.context!, PStrings.pickName);
      return;
    }

    if (pinPicked == false) {
      snackBar(Get.context!, PStrings.pickPin);
      return;
    }

    loading(Get.context!);

    String timestamp;

    if (datePicked) {
      DateTime d = dateTime;
      timestamp = "${d.year}-${d.month}-${d.day} ${d.hour}:${d.minute}";
    } else {
      timestamp = "0000-00-00 00:00";
    }

    Map map = await query(
      link: "user",
      type: RequestType.post,
      params: {
        "name": nameC.text,
        "pin": pinStringInt,
        "birthdate": timestamp,
        "profile_url": imageUrlC.text.replaceAll("&", "%26"),
      }
    );

    loaded(Get.context!);

    snackBar(Get.context!, map["message"]);
    if (map["success"]) Get.back();
  }
}

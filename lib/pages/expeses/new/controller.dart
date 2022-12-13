import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/server_query.dart';
import 'package:wera_f2/strings.dart';

class NewExpenseController extends GetxController{
  final gift = false.obs;
  final userId = Rx<int?>(null);

  final textController = TextEditingController();
  final priceController = TextEditingController();
  final GlobalController global = Get.find();

  void toggleCheck() => gift.value = gift.value ? false : true;
  void updateUserId(newInt) => userId.value = newInt;
  void updateUserIfNull(int newInt) => userId.value ??= newInt;

  void buttonPressed() async {
    if (priceController.text == "") {
      snackBar(Get.context!, PStrings.pickExpense);
      return;
    }

    loading(Get.context!);

    late double money;

    try {
      money = double.parse(priceController.text);
    } catch (e) {
      try {
        money = double.parse(priceController.text.replaceAll(',', '.'));
      } catch (e) {
        try {
          money = int.parse(priceController.text).toDouble();
        } catch (e) {
          snackBar(Get.context!, PStrings.parseError);
          return;
        }
      }
    }

    Map map = await query(
      link: "expense",
      type: RequestType.post,
      params: {
        "user_id": global.userId!,
        "recipient_id": userId.value!,
        "money": money,
        "description": textController.text,
        "gift": gift.value,
      }
    );

    loaded(Get.context!);

    snackBar(Get.context!, map["message"]);
    if (map["success"]) Get.back();
  }
}

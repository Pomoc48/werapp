import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:get/get.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/server_query.dart';
import 'package:wera_f2/strings.dart';

class NewCommandController extends GetxController{
  bool _initial = true;

  final categoryId = Rx<int?>(null);
  final userId = Rx<int?>(null);

  final FadeInController fadeController = FadeInController();
  final TextEditingController textController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final GlobalController global = Get.find();

  updateCategoryId(newInt) => categoryId.value = newInt;
  updateCatIfNull(int newInt) => categoryId.value ??= newInt;
  updateUserId(newInt) => userId.value = newInt;
  updateUserIfNull(int newInt) => userId.value ??= newInt;

  void getCommands() async {
    fadeController.fadeOut();
    global.updateCommands();

    fadeController.fadeIn();
  }

  void add() async {
    if (textController.text == "") {
      snackBar(Get.context!, PStrings.pickComm);
      return;
    }

    loading(Get.context!);

    Map map = await query(
      link: "command-log",
      type: RequestType.post,
      params: {
        "user_id": global.userId!,
        "command_id": categoryId.value!,
        "description": textController.text,
        "recipient_id": userId.value!,
      },
    );

    loaded(Get.context!);

    snackBar(Get.context!, map["message"]);
    if (map["success"]) Get.back();
  }

  void pageSetup() {
    if (_initial) {
      getCommands();
      _initial = false;
    }
  }
}

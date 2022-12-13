import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/server_query.dart';
import 'package:wera_f2/strings.dart';

class SetupController extends GetxController{
  final textController = TextEditingController();
  final GlobalController global = Get.find();

  void checkConnection() async {
    if (textController.text == "") {
      snackBar(Get.context!, PStrings.pickBackend);
      return;
    }

    loading(Get.context!);

    String backendString = "${textController.text}/";
    Map resp = await query(
      link: "test",
      type: RequestType.post,
      backend: backendString,
    );

    loaded(Get.context!);
    snackBar(Get.context!, resp["message"]);

    if (resp["success"]) {
      await GetStorage().write('backend', backendString);
      await GetStorage().write('setup', true);

      global.updateBackend(backendString);
      Get.back();
    }
  }
}

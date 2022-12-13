import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wera_f2/models/command.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/server_query.dart';
import 'package:wera_f2/strings.dart';

class NewPriceListController extends GetxController{
  bool initial = true;
  Command? passedItem;

  final GlobalController global = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  void updateInit() => initial = false;

  void addUpdate(bool add) async {
    if (nameController.text == "" || priceController.text == "") {
      snackBar(Get.context!, PStrings.pickAllFields);
      return;
    }

    loading(Get.context!);

    int cost;
    try {
      cost = int.parse(priceController.text);
    } catch (e) {
      snackBar(Get.context!, PStrings.parseErrorInt);
      return;
    }

    Map map;
    if (add) {
      map = await query(
        link: "command",
        type: RequestType.post,
        params: {
          "name": nameController.text,
          "cost": cost,
          "user_id": global.userId!,
        },
      );

    } else {
      map = await passedItem!.update(
        newName: nameController.text,
        newCost: cost,
        newUserId: global.userId!,
      );
    }

    loaded(Get.context!);

    snackBar(Get.context!, map["message"]);
    if (map["success"]) Get.back();
  }

  void deletePrice() async {
    loading(Get.context!);
    Map map = await passedItem!.remove();
    loaded(Get.context!);

    snackBar(Get.context!, map["message"]);
    Get.back();
    Get.back();
  }

  void updateItem(Command item) {
    passedItem = item;
    nameController.text = item.name;
    priceController.text = item.cost.toString();
  }
}

import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:get/get.dart';
import 'package:wera_f2/classes/command.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/settings.dart';

class PriceListController extends GetxController{
  bool _initial = true;
  final FadeInController fadeController = FadeInController();
  final GlobalController global = Get.find();

  void view(Command? command) async {
    fadeController.fadeOut();
    await Get.toNamed(Routes.newPriceList, arguments: {"command": command});
    getCommands();
  }

  void getCommands() async {
    fadeController.fadeOut();
    global.updateCommands();
    fadeController.fadeIn();
  }

  void runOnce() {
    if (_initial) {
      getCommands();
      _initial = false;
    }
  }
}

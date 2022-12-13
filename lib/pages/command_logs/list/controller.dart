import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:get/get.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/settings.dart';

class CommandLogController extends GetxController{
  bool _initial = true;
  final FadeInController controller = FadeInController();
  final GlobalController global = Get.find();

  void getCommandLogs() async {
    controller.fadeOut();
    global.updateCommandLogs();
    controller.fadeIn();
  }

  void newCommand() async {
    controller.fadeOut();
    await Get.toNamed(Routes.newCommand);
    getCommandLogs();
  }

  void runOnce() {
    if (_initial) {
      getCommandLogs();
      _initial = false;
    }
  }
}

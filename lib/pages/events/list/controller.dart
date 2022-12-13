import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:get/get.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/settings.dart';

class EventsController extends GetxController{
  bool _initial = true;
  final FadeInController controller = FadeInController();
  final GlobalController global = Get.find();

  void getEvents() async {
    controller.fadeOut();
    global.updateEvents();
    controller.fadeIn();
  }

  void newEvent() async {
    controller.fadeOut();
    await Get.toNamed(Routes.newEvent);
    getEvents();
  }

  void runOnce() {
    if (_initial) {
      getEvents();
      _initial = false;
    }
  }
}

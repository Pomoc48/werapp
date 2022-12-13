import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:get/get.dart';
import 'package:wera_f2/get_controller.dart';

class StatsController extends GetxController{
  bool _initial = true;
  final FadeInController controller = FadeInController();
  final GlobalController global = Get.find();

  void getStats() async {
    controller.fadeOut();
    global.updateStats();
    controller.fadeIn();
  }

  void runOnce(Function() fun) {
    if (_initial) {
      fun();
      _initial = false;
    }
  }
}

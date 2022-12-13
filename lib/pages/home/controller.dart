import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:get/get.dart';
import 'package:wera_f2/classes/home_data.dart';
import 'package:wera_f2/get_controller.dart';

class HomeController extends GetxController{
  bool _initial = true;

  final FadeInController controller = FadeInController();
  final GlobalController global = Get.find();

  HomeData? get data => global.homeData;
  int? get userId => global.userId;

  void updateHome() {
    controller.fadeOut();
    global.updateHomeData();
    controller.fadeIn();
  }

  void runOnce(Function() fun) {
    if (_initial) {
      fun();
      _initial = false;
    }
  }
}

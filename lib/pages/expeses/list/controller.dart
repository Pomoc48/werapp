import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:get/get.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/settings.dart';

class ExpensesController extends GetxController{
  bool _initial = true;
  final FadeInController controller = FadeInController();
  final GlobalController global = Get.find();

  void getExpenses() async {
    controller.fadeOut();
    global.updateExpenses();
    controller.fadeIn();
  }

  void newExpense() async {
    controller.fadeOut();
    await Get.toNamed(Routes.newExpense);
    getExpenses();
  }

  void pageSetup() {
    if (_initial) {
      getExpenses();
      _initial = false;
    }
  }
}

import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/server_query.dart';
import 'package:wera_f2/settings.dart';

class LoginController extends GetxController{
  final FadeInController controller = FadeInController();
  bool _initial = true;

  String pinStringInt = "";
  int? lastUserId;

  final GlobalController global = Get.find();

  clearPin() => pinStringInt = "";
  updatePin(number) => pinStringInt += number;

  void updateUsers() async {
    if (global.backend == null) return;
    controller.fadeOut();
    await Future.delayed(const Duration(milliseconds: 250));

    global.updateUsers();
    controller.fadeIn();
  }

  void getPrefs() async {
    if (_initial) {
      if (await GetStorage().read('setup') == null) {
        await Get.toNamed(Routes.setup);
      } else {
        global.updateBackend(await GetStorage().read('backend'));
      }

      updateUsers();
      _initial = false;
    }
  }

  void openNewUser({bool leading = true}) async {
    controller.fadeOut();
    await Future.delayed(const Duration(milliseconds: 100));
    
    await Get.toNamed(Routes.newUser, arguments: {"leading": leading});
    updateUsers();
  }

  void buttonInput(String number) async {
    updatePin(number);
    if (pinStringInt.length != 4) return;

    Get.back();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    loading(Get.context!);

    Map resp = await query(
      link: "login",
      type: RequestType.get,
      params: {
        "user_id": lastUserId!,
        "pin": pinStringInt,
        "version": packageInfo.version,
      }
    );

    loaded(Get.context!);

    if (resp["success"]) {
      global.updateLoginValues(
        newToken: resp["data"]["token"].toString(),
        newVapid: resp["data"]["vapid"],
        newId: resp["data"]["id"],
      );

      clearPin();
      Get.offNamed(Routes.home);
    } else {
      clearPin();
      snackBar(Get.context!, resp["message"]);
    }
  }
}

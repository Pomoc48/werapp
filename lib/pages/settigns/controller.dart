import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wera_f2/classes/user.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/server_query.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/widgets/numpad.dart';

class SettingsController extends GetxController{
  bool _initial = true;
  bool pinPicked = false;
  User? user;

  final GlobalController global = Get.find();

  Rx<Color?> themeColor = Rx<Color?>(null);
  Rx<String?> themeColorName = Rx<String?>(null);

  String pinStringInt = "";
  final newPin = PStrings.clickUpdate.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  void clearPin() => pinStringInt = "";
  void updatePin(number) => pinStringInt += number;

  void updateColor(Color color, String name) {
    themeColor.value = color;
    themeColorName.value = name;
    Get.back();
  }

  void pinInput() async {
    clearPin();
    showModalBottomSheet<void>(
      context: Get.context!,
      builder: (BuildContext context) {
        return Numpad(
          buttonInput: (String number) {
            updatePin(number);
            if (pinStringInt.length != 4) return;

            pinPicked = true;
            newPin.value = PStrings.pinHint;

            Get.back();
          },
          inputClear: clearPin,
        );
      },
    );
  }

  void confirm() async {
    String colorCut = themeColor.value.toString().substring(6, 16);

    if (await GetStorage().read("themeColor") != colorCut) {
      await GetStorage().write('themeColor', colorCut);
      await GetStorage().write("themeColorName", themeColorName.value!);

      if (Get.isDarkMode) {
        Get.changeTheme(ThemeData(
          useMaterial3: true,
          colorSchemeSeed: themeColor.value,
          brightness: Brightness.dark,
        ));
      } else {
        Get.changeTheme(ThemeData(
          useMaterial3: true,
          colorSchemeSeed: themeColor.value,
          brightness: Brightness.light,
        ));
      }

      Get.changeThemeMode(ThemeMode.light);
    }
    
    if (nameController.text == "") {
      snackBar(Get.context!, PStrings.pickName);
      return;
    }

    Map<String, dynamic> params;
    if (pinPicked == true) {
      params = {
        "user_id": global.userId,
        "name": nameController.text,
        "pin": pinStringInt,
        "profile_url": imageController.text.replaceAll("&", "%26"),
      };
    } else {
      params = {
        "user_id": global.userId,
        "name": nameController.text,
        "profile_url": imageController.text.replaceAll("&", "%26"),
      };
    }

    loading(Get.context!);
    Map map = await query(link: "user", type: RequestType.put, params: params);

    loaded(Get.context!);
    snackBar(Get.context!, map["message"]);
  }

  void runOnce() {
    if (_initial) {
      user = findUser(
        id: global.userId!,
        userList: global.homeData!.users,
      );

      nameController.text = user!.name;

      if (user!.profileUrl != null) {
        imageController.text = user!.profileUrl!;
      }

      String? themeColorString = GetStorage().read("themeColor");
      if (themeColorString != null) {
        themeColor.value = Color(int.parse(themeColorString));
        themeColorName.value = GetStorage().read("themeColorName");
      }
      _initial = false;
    }
  }
}

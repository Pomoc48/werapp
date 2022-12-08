import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fadein/flutter_fadein.dart'; // TODO: fix, add back
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wera_f2/classes/user.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/layouts/layout.dart';
import 'package:wera_f2/server_query.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/widgets/create_card.dart';
import 'package:wera_f2/widgets/input_container.dart';
import 'package:wera_f2/widgets/numpad.dart';
import 'package:wera_f2/widgets/padding.dart';
import 'package:wera_f2/widgets/title_widget.dart';
import 'package:wera_f2/widgets/widget_from_list.dart';

void main() => runApp(SettingsPage());

class LocalController extends GetxController{
  bool _initial = true;
  bool pinPicked = false;
  User? user; 

  Rx<Color?> themeColor = Rx<Color?>(null);
  Rx<String?> themeColorName = Rx<String?>(null);

  String pinStringInt = "";
  final newPin = PStrings.clickUpdate.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  clearPin() => pinStringInt = "";
  updatePin(number) => pinStringInt += number;

  updateColor(Color color, String name) {
    themeColor.value = color;
    themeColorName.value = name;
  }

  runOnce(Function() fun) {
    if (_initial) {
      fun();
      _initial = false;
    }
  }
}

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final GlobalController global = Get.find();
  final LocalController local = LocalController();

  @override
  Widget build(BuildContext context) {

    local.runOnce(() {
      local.user = findUser(
        id: global.userId!,
        userList: global.homeData!.users,
      );

      local.nameController.text = local.user!.name;

      if (local.user!.profileUrl != null) {
        local.imageController.text = local.user!.profileUrl!;
      }

      String? themeColor = GetStorage().read("themeColor");
      if (themeColor != null) {
        local.themeColor.value = Color(int.parse(themeColor));
        local.themeColorName.value = GetStorage().read("themeColorName");
      }

    });

    FloatingActionButton fab = FloatingActionButton.extended(
      heroTag: "main",
      onPressed: _confirm,
      icon: const Icon(Icons.check),
      label: Text(PStrings.confirmFAB),
    );

    return PLayout(
      title: PStrings.settings,
      drawer: true,
      logoutConfirm: true,
      scrollable: true,
      fab: fab,
      child: WidgetFromList(
        contextWidth: context.width,
        forceSingle: true,
        children: [
          TitleWidget(
            text: PStrings.userData,
            child: Column(
              children: [
                _nameInput(),
                SizedBox(height: Settings.pagePadding / 2),
                _pinInput(),
                SizedBox(height: Settings.pagePadding / 2),
                _imageUrlInput(),
              ],
            ),
          ),
          TitleWidget(
            text: PStrings.themes,
            child: _themeOptions(),
          ),
        ],
      ),
    );
  }

  Widget _nameInput() {
    return Row(
      children: [
        PPadding(widget: Text(PStrings.name, style: Get.textTheme.bodyLarge)),
        Expanded(
          child: InputContainer(
            widget: TextField(
              controller: local.nameController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              style: Get.textTheme.bodyLarge,
              decoration: InputDecoration(
                enabledBorder: Settings.noBorder,
                focusedBorder: Settings.noBorder,
                hintText: PStrings.nameHint,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _pinInput() {
    return Row(
      children: [
        PPadding(widget: Text(
          PStrings.userPin,
          style: Get.textTheme.bodyLarge,
        )),
        Expanded(
          child: InkWell(
            splashColor: PColors().inkWell(Get.context!),
            borderRadius: Settings.cardRadius,
            onTap: () async {
              local.clearPin();

              showModalBottomSheet<void>(
                context: Get.context!,
                builder: (BuildContext context) {
                  return Numpad(
                    buttonInput: (String number) {
                      local.updatePin(number);
                      if (local.pinStringInt.length != 4) return;

                      local.pinPicked = true;
                      local.newPin.value = PStrings.pinHint;

                      Get.back();
                    },
                    inputClear: local.clearPin,
                  );
                },
              );
            },
            child: Obx(() => CreateCard(main: [local.newPin.value])),
          ),
        ),
      ],
    );
  }

  Widget _imageUrlInput() {
    return Row(
      children: [
        PPadding(widget: Text(
          PStrings.imageUrl,
          style: Get.textTheme.bodyLarge,
        )),
        Expanded(
          child: InputContainer(
            widget: TextField(
              maxLengthEnforcement: MaxLengthEnforcement.none,
              controller: local.imageController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              style: Get.textTheme.bodyLarge,
              decoration: InputDecoration(
                enabledBorder: Settings.noBorder,
                focusedBorder: Settings.noBorder,
                hintText: PStrings.imageUrlHint,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _themeOptions() {
    return Row(
      children: [
        PPadding(
          widget: Text(
            PStrings.colorTheme,
            style: Get.textTheme.bodyLarge,
          ),
        ),
        Expanded(
          child: InkWell(
            splashColor: PColors().inkWell(Get.context!),
            borderRadius: Settings.cardRadius,
            onTap: () async {
              await showDialog(
                context: Get.context!,
                builder: (BuildContext context) {
                  return AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    content: _dialogContent(),
                  );
                },
              );
            },
            child: Obx(() => _colorPreview(
              local.themeColor.value,
              local.themeColorName.value,
            )),
          ),
        ),
      ],
    );
  }

  Column _colorPreview(Color? color, String? name) {
    if (color == null) {
      color = Colors.blue;
      name = "Blue";
    }

    return Column(
      children: [
        CreateCard(
          main: [
            Row(
              children: [
                CircleAvatar(backgroundColor: color, radius: 12),
                SizedBox(width: Settings.pagePadding),
                Text(name!, style: PStyles().onSurface(Get.context!).bodyLarge),
              ],
            ),
          ],
        ),
        SizedBox(height: Settings.pagePadding / 2),
      ],
    );
  }

  PPadding _dialogContent() {
    return PPadding(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 350,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _themeOptionItem(Colors.blue.shade700, "Blue"),
                  _themeOptionItem(Colors.teal.shade700, "Teal"),
                  _themeOptionItem(Colors.green.shade700, "Green"),
                  _themeOptionItem(Colors.yellow.shade700, "Yellow"),
                  _themeOptionItem(Colors.orange.shade700, "Orange"),
                  _themeOptionItem(Colors.red.shade700, "Red"),
                  _themeOptionItem(Colors.pink.shade700, "Pink"),
                  _themeOptionItem(Colors.purple.shade700, "Purple"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _themeOptionItem(Color color, String name) {
    return InkWell(
      splashColor: PColors().inkWell(Get.context!),
      borderRadius: Settings.cardRadius,
      onTap: () {
        local.updateColor(color, name);
        Get.back();
      },
      child: PPadding(
        widget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: PStyles().onSurface(Get.context!).bodyLarge),
            CircleAvatar(backgroundColor: color, radius: 16),
          ],
        ),
      ),
    );
  }

  void _confirm() async {
    String colorCut = local.themeColor.value.toString().substring(6, 16);

    if (await GetStorage().read("themeColor") != colorCut) {
      await GetStorage().write('themeColor', colorCut);
      await GetStorage().write("themeColorName", local.themeColorName.value!);

      if (Get.isDarkMode) {
        Get.changeTheme(ThemeData(
          useMaterial3: true,
          colorSchemeSeed: local.themeColor.value,
          brightness: Brightness.dark,
        ));
      } else {
        Get.changeTheme(ThemeData(
          useMaterial3: true,
          colorSchemeSeed: local.themeColor.value,
          brightness: Brightness.light,
        ));
      }

      Get.changeThemeMode(ThemeMode.light);
    }
    
    if (local.nameController.text == "") {
      snackBar(Get.context!, PStrings.pickName);
      return;
    }

    Map<String, dynamic> params;
    if (local.pinPicked == true) {
      params = {
        "user_id": global.userId,
        "name": local.nameController.text,
        "pin": local.pinStringInt,
        "profile_url": local.imageController.text.replaceAll("&", "%26"),
      };
    } else {
      params = {
        "user_id": global.userId,
        "name": local.nameController.text,
        "profile_url": local.imageController.text.replaceAll("&", "%26"),
      };
    }

    loading(Get.context!);
    Map map = await query(link: "user", type: RequestType.put, params: params);

    loaded(Get.context!);
    snackBar(Get.context!, map["message"]);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wera_f2/classes/user.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/layouts/layout.dart';
import 'package:wera_f2/server_query.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/widgets/create_card.dart';
import 'package:wera_f2/widgets/numpad.dart';
import 'package:wera_f2/widgets/padding.dart';
import 'package:wera_f2/widgets/profile_avatar.dart';
import 'package:wera_f2/widgets/title.dart';
import 'package:wera_f2/widgets/widget_from_list.dart';

void main() => runApp(LoginPage());

class LocalController extends GetxController{
  final FadeInController controller = FadeInController();
  bool _initial = true;

  String pinStringInt = "";
  int? lastUserId;

  clearPin() => pinStringInt = "";
  updatePin(number) => pinStringInt += number;

  runOnce(Function() fun) {
    if (_initial) {
      fun();
      _initial = false;
    }
  }
}

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final GlobalController global = Get.find();
  final LocalController local = LocalController();

  @override
  Widget build(BuildContext context) {
    local.runOnce(_getPrefs);

    return PLayout(
      title: PStrings.login,
      welcome: PTitle(message: PStrings.chooseUser),
      scrollable: true,
      onRefresh: () async => _getUsers(),
      child: Obx(() => WidgetFromList(
        contextWidth: context.width,
        forceSingle: true,
        children: _main(global.users),
      )),
    );
  }

  List<Widget> _main(List<User>? users) {
    if (users == null) {
      return [
        PTitle(message: PStrings.noConnection),
        PPadding(widget: Text(PStrings.noConnectionMessage)),
        PPadding(
          widget: ElevatedButton.icon(
            onPressed: () => Get.toNamed(Routes.setup),
            icon: const Icon(Icons.sync),
            label: Text(PStrings.updateBackend),
          ),
        ),
      ];
    }

    return _getUserList(users);
  }

  List<Widget> _getUserList(List<User> data) {
    if (data.isEmpty) _openNewUser(leading: false);
    List<Widget> usersList = [];

    for (User user in data) {
      usersList.add(
        InkWell(
          onTap: () async {
            local.lastUserId = user.id;
            local.clearPin();

            showModalBottomSheet<void>(
              context: Get.context!,
              builder: (BuildContext context) {
                return Numpad(
                  buttonInput: _buttonInput,
                  inputClear: local.clearPin,
                );
              },
            );
          },
          splashColor: PColors().inkWell(Get.context!),
          borderRadius: Settings.cardRadius,
          child: CreateCard(main: ProfileAvatar(userId: user.id)),
        ),
      );
    }

    usersList.add(
      Row(
        children: [
          SizedBox(width: Settings.pagePadding / 2),
          TextButton.icon(
            onPressed: _openNewUser,
            icon: const Icon(Icons.person_add_alt_1),
            label: Text(PStrings.newUser),
          ),
        ],
      ),
    );

    usersList.add(const SizedBox(height: 64));
    return usersList;
  }

  void _openNewUser({bool leading = true}) async {
    local.controller.fadeOut();
    await Future.delayed(const Duration(milliseconds: 100));
    await Get.toNamed(Routes.newUser, arguments: {"leading": leading});
    _getUsers();
  }

  void _buttonInput(String number) async {
    local.updatePin(number);
    if (local.pinStringInt.length != 4) return;

    Get.back();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    loading(Get.context!);

    Map resp = await query(
      link: "login",
      type: RequestType.get,
      params: {
        "user_id": local.lastUserId!,
        "pin": local.pinStringInt,
        "version": packageInfo.version,
      }
    );

    loaded(Get.context!);

    if (resp["success"]) {
      global.updateToken(resp["data"]["token"].toString());
      global.updateUserId(resp["data"]["id"]);
      global.updateVapid(resp["data"]["vapid"]);

      local.clearPin();
      Get.offNamed(Routes.home);
    } else {
      local.clearPin();
      snackBar(Get.context!, resp["message"]);
    }
  }

  void _getPrefs() async {
    if (await GetStorage().read('setup') == null) {
      await Get.toNamed(Routes.setup);
    } else {
      global.updateBackend(await GetStorage().read('backend'));
    }

    _getUsers();
  }

  Future<void> _getUsers() async {
    if (global.backend == null) return;

    local.controller.fadeOut();
    await Future.delayed(const Duration(milliseconds: 250));
    global.updateUsers(null);
    Map map = await query(link: "user", type: RequestType.get);

    if (map["success"]) {
      global.updateUsers(userListFromList(map["data"]));
    } else {
      snackBar(Get.context!, map["message"]);
    }

    local.controller.fadeIn();
  }
}

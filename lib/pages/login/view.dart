import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wera_f2/classes/user.dart';
import 'package:wera_f2/layouts/layout.dart';
import 'package:wera_f2/pages/login/controller.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/widgets/create_card.dart';
import 'package:wera_f2/widgets/numpad.dart';
import 'package:wera_f2/widgets/padding.dart';
import 'package:wera_f2/widgets/profile_avatar.dart';
import 'package:wera_f2/widgets/title.dart';
import 'package:wera_f2/widgets/widget_from_list.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final LoginController local = LoginController();

  @override
  Widget build(BuildContext context) {
    local.getPrefs();

    return PLayout(
      title: PStrings.login,
      welcome: PTitle(message: PStrings.chooseUser),
      scrollable: true,
      fadeController: local.controller,
      onRefresh: () async => local.updateUsers(),
      child: Obx(() => WidgetFromList(
        contextWidth: context.width,
        forceSingle: true,
        children: _main(local.global.users),
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
    if (data.isEmpty) local.openNewUser(leading: false);
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
                  buttonInput: local.buttonInput,
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
            onPressed: local.openNewUser,
            icon: const Icon(Icons.person_add_alt_1),
            label: Text(PStrings.newUser),
          ),
        ],
      ),
    );

    usersList.add(const SizedBox(height: 64));
    return usersList;
  }
}

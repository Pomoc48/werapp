import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:get/get.dart';
import 'package:wera_f2/classes/command.dart';
import 'package:wera_f2/classes/user.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/layouts/layout.dart';
import 'package:wera_f2/server_query.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/widgets/dropdown.dart';
import 'package:wera_f2/widgets/input_container.dart';
import 'package:wera_f2/widgets/widget_from_list.dart';

void main() => runApp(NewCommandPage());

class LocalController extends GetxController{
  bool _initial = true;

  final categoryId = Rx<int?>(null);
  final userId = Rx<int?>(null);

  final FadeInController fadeController = FadeInController();
  final TextEditingController textController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  updateCategoryId(newInt) => categoryId.value = newInt;
  updateCatIfNull(int newInt) => categoryId.value ??= newInt;
  updateUserId(newInt) => userId.value = newInt;
  updateUserIfNull(int newInt) => userId.value ??= newInt;

  runOnce(Function() fun) {
    if (_initial) {
      fun();
      _initial = false;
    }
  }
}

class NewCommandPage extends StatelessWidget {
  NewCommandPage({super.key});

  final GlobalController global = Get.find();
  final LocalController local = LocalController();

  @override
  Widget build(BuildContext context) {
    local.runOnce(() => _getCommands());

    FloatingActionButton fab = FloatingActionButton.extended(
      heroTag: "main",
      onPressed: _add,
      icon: const Icon(Icons.check),
      label: Text(PStrings.confirmFAB),
    );

    return PLayout(
      title: PStrings.newCommand,
      fab: fab,
      child: Obx(() => WidgetFromList(children: _main(global.commands))),
    );
  }

  List<Widget> _main(List<Command>? commands) {
    if (commands == null) return [];
    return [_categorySelect(), _userSelect(), _descriptionInput()];
  }

  Widget _categorySelect() {
    return PDropdown(
      title: PStrings.commandType,
      items: _displayCategories(global.commands!),
      value: local.categoryId.value,
      onChanged: local.updateCategoryId,
    );
  }

  Widget _userSelect() {
    return PDropdown(
      title: PStrings.recipient,
      items: _displayUsers(global.homeData!.users),
      value: local.userId.value,
      onChanged: local.updateUserId,
    );
  }

  List<DropdownMenuItem> _displayCategories(List<Command> commands) {
    List<DropdownMenuItem> widgets = [];

    for (Command command in commands) {
      local.updateCatIfNull(command.id);
      widgets.add(dropdownMenuItem(command.id, "${command.name} (${command.cost})"));
    }
    return widgets;
  }

  List<DropdownMenuItem> _displayUsers(List<User> users) {
    List<DropdownMenuItem> widgets = [];

    for (User user in users) {
      if (user.id != global.userId) {
        local.updateUserIfNull(user.id);
        widgets.add(dropdownMenuItem(user.id, user.name));
      } 
    }
    return widgets;
  }

  Widget _descriptionInput() {
    return InputContainer(
      widget: TextField(
        controller: local.textController,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          enabledBorder: Settings.noBorder,
          focusedBorder: Settings.noBorder,
          hintText: PStrings.commandDescriptionHint,
          labelText: PStrings.descriptionRequried,
        ),
      ),
    );
  }

  Future<void> _add() async {
    if (local.textController.text == "") {
      snackBar(Get.context!, PStrings.pickComm);
      return;
    }

    loading(Get.context!);

    Map map = await query(
      link: "command-log",
      type: RequestType.post,
      params: {
        "user_id": global.userId!,
        "command_id": local.categoryId.value!,
        "description": local.textController.text,
        "recipient_id": local.userId.value!,
      },
    );

    loaded(Get.context!);

    snackBar(Get.context!, map["message"]);
    if (map["success"]) Get.back();
  }

  Future<void> _getCommands() async {
    local.fadeController.fadeOut();
    Map map = await query(link: "command", type: RequestType.get);

    if (map["success"]) {
      global.updateCommands(commandListFromList(map["data"]));
    } else {
      snackBar(Get.context!, map["message"]);
    }

    local.fadeController.fadeIn();
  }
}

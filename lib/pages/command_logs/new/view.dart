import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wera_f2/classes/command.dart';
import 'package:wera_f2/classes/user.dart';
import 'package:wera_f2/layouts/layout.dart';
import 'package:wera_f2/pages/command_logs/new/controller.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/widgets/dropdown.dart';
import 'package:wera_f2/widgets/input_container.dart';
import 'package:wera_f2/widgets/widget_from_list.dart';

class NewCommandPage extends StatelessWidget {
  NewCommandPage({super.key});

  final NewCommandController local = NewCommandController();

  @override
  Widget build(BuildContext context) {
    local.runOnce();

    FloatingActionButton fab = FloatingActionButton.extended(
      heroTag: "main",
      onPressed: local.add,
      icon: const Icon(Icons.check),
      label: Text(PStrings.confirmFAB),
    );

    return PLayout(
      title: PStrings.newCommand,
      fab: fab,
      fadeController: local.fadeController,
      child: Obx(() => WidgetFromList(
        contextWidth: context.width,
        forceSingle: true,
        children: _main(local.global.commands),
      )),
    );
  }

  List<Widget> _main(List<Command>? commands) {
    if (commands == null) return [];
    return [_categorySelect(), _userSelect(), _descriptionInput()];
  }

  Widget _categorySelect() {
    return PDropdown(
      title: PStrings.commandType,
      items: _displayCategories(local.global.commands!),
      value: local.categoryId.value,
      onChanged: local.updateCategoryId,
    );
  }

  Widget _userSelect() {
    return PDropdown(
      title: PStrings.recipient,
      items: _displayUsers(local.global.homeData!.users),
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
      if (user.id != local.global.userId) {
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
}

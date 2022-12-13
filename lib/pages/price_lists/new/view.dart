import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wera_f2/models/command.dart';
import 'package:wera_f2/layouts/layout.dart';
import 'package:wera_f2/pages/price_lists/new/controller.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/widgets/input_container.dart';
import 'package:wera_f2/widgets/padding.dart';
import 'package:wera_f2/widgets/widget_from_list.dart';

class NewPriceListPage extends StatelessWidget {
  NewPriceListPage({super.key});
  
  final NewPriceListController local = NewPriceListController();

  @override
  Widget build(BuildContext context) {
    String pageTitle = PStrings.newPriceList;

    if (local.initial) {
      Map? data = ModalRoute.of(context)?.settings.arguments as Map?;

      if (data != null && data["command"] is Command) {
        local.updateItem(data["command"]);
        pageTitle = PStrings.editPriceList;
      }
      local.updateInit();
    }

    FloatingActionButton fab = FloatingActionButton.extended(
      heroTag: "main",
      onPressed: () => local.addUpdate(local.passedItem == null),
      icon: const Icon(Icons.check),
      label: Text(PStrings.confirmFAB),
    );

    return PLayout(
      title: pageTitle,
      appbarActions: _drawDelete(),
      fab: fab,
      child: WidgetFromList(
        contextWidth: context.width,
        forceSingle: true,
        children: _main(),
      ),
    );
  }

  List<Widget>? _drawDelete() {
    if (local.passedItem != null) {
      return [
        IconButton(
          constraints: Settings.actionConstraint,
          icon: const Icon(Icons.delete),
          onPressed: () => _delete(),
        ),
      ];
    }

    return null;
  }

  List<Widget> _main() {
    if (local.global.commands == null) return [];
    return [_nameInput(), _priceInput()];
  }

  Widget _nameInput() {
    return Row(
      children: [
        PPadding(widget: Text(
          PStrings.nameRequried,
          style: Get.textTheme.bodyLarge,
        )),
        Expanded(
          child: InputContainer(
            widget: TextField(
              autofocus: true,
              controller: local.nameController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                enabledBorder: Settings.noBorder,
                focusedBorder: Settings.noBorder,
                hintText: PStrings.commandNameHint,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _priceInput() {
    return Row(
      children: [
        PPadding( widget: Text(
          PStrings.commandCost,
          style: Get.textTheme.bodyLarge,
        )),
        Expanded(
          child: InputContainer(
            widget: TextField(
              controller: local.priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                enabledBorder: Settings.noBorder,
                focusedBorder: Settings.noBorder,
                hintText: PStrings.commandPriceHint,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _delete() async {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(PStrings.dialogAlert),
          content: Text(PStrings.removeConfirm),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(PStrings.no),
            ),
            TextButton(
              onPressed: () async => local.deletePrice(),
              child: Text(PStrings.yes),
            ),
          ],
        );
      },
    );
  }
}

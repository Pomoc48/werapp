import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wera_f2/classes/command.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/layouts/layout.dart';
import 'package:wera_f2/server_query.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/widgets/input_container.dart';
import 'package:wera_f2/widgets/padding.dart';
import 'package:wera_f2/widgets/widget_from_list.dart';

void main() => runApp(NewPriceListPage());

class LocalController extends GetxController{
  bool initial = true;
  Command? passedItem;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  updateInit() => initial = false;

  updateItem(Command item) {
    passedItem = item;
    nameController.text = item.name;
    priceController.text = item.cost.toString();
  }
}

class NewPriceListPage extends StatelessWidget {
  NewPriceListPage({super.key});

  final GlobalController global = Get.find();
  final LocalController local = LocalController();

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
      onPressed: () => _addUpdate(local.passedItem == null),
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
    if (global.commands == null) return [];
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

  Future<void> _delete() async {
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
              onPressed: () async {
                loading(Get.context!);
                Map map = await local.passedItem!.remove();
                loaded(Get.context!);

                snackBar(Get.context!, map["message"]);
                Get.back();
                Get.back();
              },
              child: Text(PStrings.yes),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addUpdate(bool add) async {
    if (local.nameController.text == "" || local.priceController.text == "") {
      snackBar(Get.context!, PStrings.pickAllFields);
      return;
    }

    loading(Get.context!);

    int cost;
    try {
      cost = int.parse(local.priceController.text);
    } catch (e) {
      snackBar(Get.context!, PStrings.parseErrorInt);
      return;
    }

    Map map;
    if (add) {
      map = await query(
        link: "command",
        type: RequestType.post,
        params: {
          "name": local.nameController.text,
          "cost": cost,
          "user_id": global.userId!,
        },
      );

    } else {
      map = await local.passedItem!.update(
        newName: local.nameController.text,
        newCost: cost,
        newUserId: global.userId!,
      );
    }

    loaded(Get.context!);

    snackBar(Get.context!, map["message"]);
    if (map["success"]) Get.back();
  }
}

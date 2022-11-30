import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:get/get.dart';
import 'package:wera_f2/classes/user.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/layouts/single_column.dart';
import 'package:wera_f2/server_query.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/widgets/create_card.dart';
import 'package:wera_f2/widgets/dropdown.dart';
import 'package:wera_f2/widgets/input_container.dart';
import 'package:wera_f2/widgets/padding.dart';

void main() => runApp(AddExpensePage());

class LocalController extends GetxController{
  final gift = false.obs;
  final userId = Rx<int?>(null);

  final textController = TextEditingController();
  final priceController = TextEditingController();

  void toggleCheck() => gift.value = gift.value ? false : true;
  updateUserId(newInt) => userId.value = newInt;
  updateUserIfNull(int newInt) => userId.value ??= newInt;
}

class AddExpensePage extends StatelessWidget {
  AddExpensePage({super.key});

  final GlobalController global = Get.find();
  final LocalController local = LocalController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(PStrings.newExpense)),
      body: FadeIn(child: _mainSection()),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "main",
        onPressed: () => _buttonPressed(),
        icon: const Icon(Icons.check),
        label: Text(PStrings.confirmFAB),
      ),
    );
  }

  Widget _mainSection() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleColumn(
          constraints: constraints,
          children: [
            _priceInput(),
            _userSelect(),
            _descriptionInput(),
            _checkBox(),
          ],
        );
      },
    );
  }

  Widget _priceInput() {
    return Row(
      children: [
        PPadding(widget: Text(
          PStrings.expensePrice,
          style: Get.textTheme.bodyLarge,
        )),
        Expanded(
          child: InputContainer(
            widget: TextField(
              autofocus: true,
              controller: local.priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: PStyles().onSurface(Get.context!).bodyLarge,
              decoration: InputDecoration(
                enabledBorder: Settings.noBorder,
                focusedBorder: Settings.noBorder,
                hintText: PStrings.moneyHint,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _userSelect() {
    return Obx(() => PDropdown(
      title: PStrings.recipient,
      items: _displayUsers(global.homeData!.users),
      value: local.userId.value,
      onChanged: local.updateUserId,
    ));
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
        style: PStyles().onSurface(Get.context!).bodyLarge,
        decoration: InputDecoration(
          enabledBorder: Settings.noBorder,
          focusedBorder: Settings.noBorder,
          hintText: PStrings.expensesDescriptionHint,
          labelText: PStrings.description,
        ),
      ),
    );
  }

  Widget _checkBox() {
    return GestureDetector(
      onTap: (() => local.toggleCheck()),
      child: CreateCard(
        main: [
          Text(
            PStrings.expenseGift,
            style: PStyles().onSurface(Get.context!).bodyLarge,
          ),
          Obx(() => Checkbox(
            activeColor: Theme.of(Get.context!).colorScheme.primary,
            checkColor: Theme.of(Get.context!).colorScheme.onPrimary,
            value: local.gift.value,
            onChanged: (val) => local.toggleCheck(),
          )),
        ],
      ),
    );
  }

  void _buttonPressed() async {
    if (local.priceController.text == "") {
      snackBar(Get.context!, PStrings.pickExpense);
      return;
    }

    loading(Get.context!);

    late double money;

    try {
      money = double.parse(local.priceController.text);
    } catch (e) {
      try {
        money = double.parse(local.priceController.text.replaceAll(',', '.'));
      } catch (e) {
        try {
          money = int.parse(local.priceController.text).toDouble();
        } catch (e) {
          snackBar(Get.context!, PStrings.parseError);
          return;
        }
      }
    }

    Map map = await query(
      link: "expense",
      type: RequestType.post,
      params: {
        "user_id": global.userId!,
        "recipient_id": local.userId.value!,
        "money": money,
        "description": local.textController.text,
        "gift": local.gift.value,
      }
    );

    loaded(Get.context!);

    snackBar(Get.context!, map["message"]);
    if (map["success"]) Get.back();
  }
}

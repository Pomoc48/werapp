import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wera_f2/classes/user.dart';
import 'package:wera_f2/layouts/layout.dart';
import 'package:wera_f2/pages/expeses/new/controller.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/widgets/create_card.dart';
import 'package:wera_f2/widgets/dropdown.dart';
import 'package:wera_f2/widgets/input_container.dart';
import 'package:wera_f2/widgets/padding.dart';
import 'package:wera_f2/widgets/widget_from_list.dart';

class AddExpensePage extends StatelessWidget {
  AddExpensePage({super.key});
  
  final NewExpenseController local = NewExpenseController();

  @override
  Widget build(BuildContext context) {

    FloatingActionButton fab = FloatingActionButton.extended(
      heroTag: "main",
      onPressed: () => local.buttonPressed(),
      icon: const Icon(Icons.check),
      label: Text(PStrings.confirmFAB),
    );

    return PLayout(
      title: PStrings.newExpense,
      fab: fab,
      child: WidgetFromList(
        contextWidth: context.width,
        forceSingle: true,
        children: [
          _priceInput(),
          _userSelect(),
          _descriptionInput(),
          _checkBox(),
        ],
      ),
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
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
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
      items: _displayUsers(local.global.homeData!.users),
      value: local.userId.value,
      onChanged: local.updateUserId,
    ));
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
}

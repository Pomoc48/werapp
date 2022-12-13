import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wera_f2/layouts/layout.dart';
import 'package:wera_f2/pages/create_user/controller.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/widgets/create_card.dart';
import 'package:wera_f2/widgets/input_container.dart';
import 'package:wera_f2/widgets/numpad.dart';
import 'package:wera_f2/widgets/padding.dart';
import 'package:wera_f2/widgets/widget_from_list.dart';

class AddUser extends StatelessWidget {
  AddUser({super.key});

  final NewUserController local = NewUserController();

  @override
  Widget build(BuildContext context) {

    FloatingActionButton fab = FloatingActionButton.extended(
      heroTag: "main",
      onPressed: () => local.buttonPressed(),
      icon: const Icon(Icons.check),
      label: Text(PStrings.confirmFAB),
    );

    return PLayout(
      title: PStrings.newUser,
      backArrow: Get.arguments["leading"],
      fab: fab,
      child: WidgetFromList(
        contextWidth: context.width,
        forceSingle: true,
        children: [
          _nameInput(),
          _pinInput(),
          _timeInput(),
          _imageUrlInput(),
        ],
      ),
    );
  }

  Widget _timeInput() {
    return Row(
      children: [
        PPadding(widget: Text(
          PStrings.birthdate,
          style: Get.textTheme.bodyLarge,
        )),
        Expanded(
          child: InkWell(
            splashColor: PColors().inkWell(Get.context!),
            borderRadius: Settings.cardRadius,
            onTap: () async => local.timeInput(),
            child: Obx(() => CreateCard(main: [local.newDate.value])),
          ),
        ),
      ],
    );
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
              controller: local.nameC,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
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
              controller: local.imageUrlC,
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

  Widget _pinInput() {
    return Row(
      children: [
        PPadding(widget: Text(
          PStrings.userPinRequried,
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
                    buttonInput: local.pinInput,
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
}

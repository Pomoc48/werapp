import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wera_f2/layouts/layout.dart';
import 'package:wera_f2/pages/events/add/controller.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/widgets/create_card.dart';
import 'package:wera_f2/widgets/input_container.dart';
import 'package:wera_f2/widgets/padding.dart';
import 'package:wera_f2/widgets/widget_from_list.dart';

class AddEventPage extends StatelessWidget {
  AddEventPage({super.key});

  final EventAddController local = EventAddController();

  @override
  Widget build(BuildContext context) {

    FloatingActionButton fab = FloatingActionButton.extended(
      heroTag: "main",
      onPressed: () => local.buttonPressed(),
      icon: const Icon(Icons.check),
      label: Text(PStrings.confirmFAB),
    );

    return PLayout(
      title: PStrings.newEventTitle,
      fab: fab,
      child: WidgetFromList(
        contextWidth: context.width,
        forceSingle: true,
        children: [_timeInput(), _descriptionInput()],
      ),
    );
  }

  Widget _timeInput() {
    return Row(
      children: [
        PPadding(widget: Text(
          PStrings.eventDate,
          style: Get.textTheme.bodyLarge,
        )),
        Expanded(
          child: InkWell(
            splashColor: PColors().inkWell(Get.context!),
            borderRadius: Settings.cardRadius,
            onTap: () async => local.updateDate,
            child: Obx(() => CreateCard(main: [local.newText.value])),
          ),
        ),
      ],
    );
  }

  Widget _descriptionInput() {
    return InputContainer(
      widget: TextField(
        controller: local.controller,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        style: Get.textTheme.bodyLarge,
        decoration: InputDecoration(
          enabledBorder: Settings.noBorder,
          focusedBorder: Settings.noBorder,
          hintText: PStrings.eventDescriptionHint,
          labelText: PStrings.descriptionRequried,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:get/get.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/layouts/single_column.dart';
import 'package:wera_f2/server_query.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/widgets/create_card.dart';
import 'package:wera_f2/widgets/input_container.dart';
import 'package:wera_f2/widgets/padding.dart';

void main() => runApp(AddEventPage());

class LocalController extends GetxController{
  final TextEditingController controller = TextEditingController();

  bool datePicked = false;
  DateTime dateTime = DateTime.now();

  final newText = formatDate(
    DateTime.now().add(const Duration(hours: 1)),
  ).obs;

  updateDate(DateTime? newTime) {
    dateTime = newTime!;
    newText.value = formatDate(dateTime);
  }
}

class AddEventPage extends StatelessWidget {
  AddEventPage({super.key});

  final GlobalController global = Get.find();
  final LocalController local = LocalController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(PStrings.newEventTitle),
      ),
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
          children: [_timeInput(), _descriptionInput()],
        );
      },
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
            onTap: () async {
              DateTime? date = await showDatePicker(
                context: Get.context!,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2120, 12, 31),
              );
        
              TimeOfDay? time;
        
              if (date is DateTime) {
                time = await showTimePicker(
                  context: Get.context!,
                  initialTime: const TimeOfDay(hour: 0, minute: 0),
                );
              }
        
              if (date is DateTime && time is TimeOfDay) {
                local.datePicked = true;
        
                local.updateDate(
                  date.add(Duration(hours: time.hour, minutes: time.minute)),
                );
              }
            },
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

  void _buttonPressed() async {
    if (!local.datePicked) {
      snackBar(Get.context!, PStrings.pickDate);
      return;
    }

    if (local.controller.text == "") {
      snackBar(Get.context!, PStrings.pickTitle);
      return;
    }

    loading(Get.context!);

    DateTime d = local.dateTime;
    String timestamp = "${d.year}-${d.month}-${d.day} ${d.hour}:${d.minute}";

    Map map = await query(
      link: "event",
      type: RequestType.post,
      params: {
        "user_id": global.userId!,
        "description": local.controller.text,
        "timestamp": timestamp,
      }
    );

    loaded(Get.context!);

    snackBar(Get.context!, map["message"]);
    if (map["success"]) Get.back();
  }
}

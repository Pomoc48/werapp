import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:wera_f2/widgets/numpad.dart';
import 'package:wera_f2/widgets/padding.dart';

void main() => runApp(AddUser());

class LocalController extends GetxController{
  final TextEditingController nameC = TextEditingController();
  final TextEditingController imageUrlC = TextEditingController();

  bool datePicked = false;
  bool pinPicked = false;
  DateTime dateTime = DateTime.now();

  String pinStringInt = "";

  final newDate = PStrings.clickSet.obs;
  final newPin = PStrings.clickSet.obs;

  clearPin() => pinStringInt = "";
  updatePin(number) => pinStringInt += number;

  updateDate(DateTime? newTime) {
    dateTime = newTime!;
    newDate.value = formatDate(dateTime, short: true);
  }
}

class AddUser extends StatelessWidget {
  AddUser({super.key});

  final GlobalController global = Get.find();
  final LocalController local = LocalController();

  final BuildContext? buildContext = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(PStrings.newUser),
        automaticallyImplyLeading: Get.arguments["leading"],
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
          children: [
            _nameInput(),
            _pinInput(),
            _timeInput(),
            _imageUrlInput(),
          ],
        );
      },
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
            onTap: () async {
              DateTime now = DateTime.now();

              DateTime? date = await showDatePicker(
                context: Get.context!,
                initialDate: now,
                firstDate: DateTime(1920),
                lastDate: now,
              );

              if (date is DateTime) {
                local.datePicked = true;
                local.updateDate(date);
              }
            },
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
                    buttonInput: (String number) {
                      local.updatePin(number);
                      if (local.pinStringInt.length != 4) return;

                      local.pinPicked = true;
                      local.newPin.value = PStrings.pinHint;

                      Get.back();
                    },
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

  void _buttonPressed() async {
    if (local.nameC.text == "") {
      snackBar(Get.context!, PStrings.pickName);
      return;
    }

    if (local.pinPicked == false) {
      snackBar(Get.context!, PStrings.pickPin);
      return;
    }

    loading(Get.context!);

    String timestamp;

    if (local.datePicked) {
      DateTime d = local.dateTime;
      timestamp = "${d.year}-${d.month}-${d.day} ${d.hour}:${d.minute}";
    } else {
      timestamp = "0000-00-00 00:00";
    }

    Map map = await query(
      link: "user",
      type: RequestType.post,
      params: {
        "name": local.nameC.text,
        "pin": local.pinStringInt,
        "birthdate": timestamp,
        "profile_url": local.imageUrlC.text.replaceAll("&", "%26"),
      }
    );

    loaded(Get.context!);

    snackBar(Get.context!, map["message"]);
    if (map["success"]) Get.back();
  }
}

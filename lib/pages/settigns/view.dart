import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wera_f2/layouts/layout.dart';
import 'package:wera_f2/pages/settigns/controller.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/widgets/create_card.dart';
import 'package:wera_f2/widgets/input_container.dart';
import 'package:wera_f2/widgets/padding.dart';
import 'package:wera_f2/widgets/title_widget.dart';
import 'package:wera_f2/widgets/widget_from_list.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});
  
  final SettingsController local = SettingsController();

  @override
  Widget build(BuildContext context) {
    local.pageSetup();

    FloatingActionButton fab = FloatingActionButton.extended(
      heroTag: "main",
      onPressed: local.confirm,
      icon: const Icon(Icons.check),
      label: Text(PStrings.confirmFAB),
    );

    return PLayout(
      title: PStrings.settings,
      drawer: true,
      logoutConfirm: true,
      scrollable: true,
      fab: fab,
      child: WidgetFromList(
        contextWidth: context.width,
        children: [
          TitleWidget(
            text: PStrings.userData,
            child: Column(
              children: [
                _nameInput(),
                SizedBox(height: Settings.pagePadding / 2),
                _pinInput(),
                SizedBox(height: Settings.pagePadding / 2),
                _imageUrlInput(),
              ],
            ),
          ),
          TitleWidget(text: PStrings.themes, child: _themeOptions()),
        ],
      ),
    );
  }

  Widget _nameInput() {
    return Row(
      children: [
        PPadding(widget: Text(PStrings.name, style: Get.textTheme.bodyLarge)),
        Expanded(
          child: InputContainer(
            widget: TextField(
              controller: local.nameController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
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

  Widget _pinInput() {
    return Row(
      children: [
        PPadding(widget: Text(
          PStrings.userPin,
          style: Get.textTheme.bodyLarge,
        )),
        Expanded(
          child: InkWell(
            splashColor: PColors().inkWell(Get.context!),
            borderRadius: Settings.cardRadius,
            onTap: () async  => local.pinInput(),
            child: Obx(() => CreateCard(main: [local.newPin.value])),
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
              controller: local.imageController,
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

  Widget _themeOptions() {
    return Row(
      children: [
        PPadding(
          widget: Text(
            PStrings.colorTheme,
            style: Get.textTheme.bodyLarge,
          ),
        ),
        Expanded(
          child: InkWell(
            splashColor: PColors().inkWell(Get.context!),
            borderRadius: Settings.cardRadius,
            onTap: () async {
              await showDialog(
                context: Get.context!,
                builder: (BuildContext context) {
                  return AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    content: _dialogContent(),
                  );
                },
              );
            },
            child: Obx(() => _colorPreview(
              local.themeColor.value,
              local.themeColorName.value,
            )),
          ),
        ),
      ],
    );
  }

  Column _colorPreview(Color? color, String? name) {
    if (color == null) {
      color = Colors.blue;
      name = "Blue";
    }

    return Column(
      children: [
        CreateCard(
          main: [
            Row(
              children: [
                CircleAvatar(backgroundColor: color, radius: 12),
                SizedBox(width: Settings.pagePadding),
                Text(name!, style: PStyles().onSurface(Get.context!).bodyLarge),
              ],
            ),
          ],
        ),
        SizedBox(height: Settings.pagePadding / 2),
      ],
    );
  }

  PPadding _dialogContent() {
    return PPadding(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 350,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _themeOptionItem(Colors.blue.shade700, "Blue"),
                  _themeOptionItem(Colors.teal.shade700, "Teal"),
                  _themeOptionItem(Colors.green.shade700, "Green"),
                  _themeOptionItem(Colors.yellow.shade700, "Yellow"),
                  _themeOptionItem(Colors.orange.shade700, "Orange"),
                  _themeOptionItem(Colors.red.shade700, "Red"),
                  _themeOptionItem(Colors.pink.shade700, "Pink"),
                  _themeOptionItem(Colors.purple.shade700, "Purple"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _themeOptionItem(Color color, String name) {
    return InkWell(
      splashColor: PColors().inkWell(Get.context!),
      borderRadius: Settings.cardRadius,
      onTap: () => local.updateColor(color, name),
      child: PPadding(
        widget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: PStyles().onSurface(Get.context!).bodyLarge),
            CircleAvatar(backgroundColor: color, radius: 16),
          ],
        ),
      ),
    );
  }
}
